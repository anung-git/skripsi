#include <Arduino.h>
//FirebaseESP8266.h must be included before ESP8266WiFi.h
#include "FirebaseESP8266.h"
#include <ESP8266WiFi.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include "Motor.h"
#include "Event.h"
#include "DataBase.h"
#include <ESP8266TimerInterrupt.h>
#include "Ping.h"


#define FIREBASE_HOST "skripsi-9726b.firebaseio.com" //Without http:// or https:// schemes
#define FIREBASE_AUTH "b5LLW3w6JPyKzecPzKwUqz3oX5sTdW2wGUOpTM4A"
#define WIFI_SSID "ardinista"
#define WIFI_PASSWORD "ardiasta"

#define LED  D0 
#define FLOW_SENSOR  D1 
#define TRIGGER_PIN  D3  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     D7  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 200 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
#define OVERLOAD_PIN D6 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
#define oneWireBus   D5     // input untuk sensor DS18B20
#define MOTOR_PIN   D2     // motor listrik


//Define data object
ESP8266Timer ITimer;
FirebaseData firebaseData1;
FirebaseData firebaseData2;
OneWire oneWire(oneWireBus);          // Setup a oneWire instance to communicate with any OneWire devices
DallasTemperature sensors (&oneWire); // Pass our oneWire reference to Dallas Temperature sensor 
Ping sonar = Ping (TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.
Motor motor = Motor( MOTOR_PIN, 100);
Event event = Event(1000);
Event kedip = Event(500);
DataBase flowData = DataBase();
DataBase flowAlarm = DataBase();
DataBase levelData = DataBase();
//declarasi variabel

void streamCallback(StreamData data){
  Serial.println("Stream callback ...");
  // callback motor
  Serial.print("data type = ");
  Serial.println(data.dataType());
  Serial.print("data path = ");
  Serial.println(data.dataPath());
  if (data.dataPath()=="/motor") {
    if (data.dataType() == "boolean")
    data.boolData() == 1 ? motor.motorOn(): motor.motorOff();
    // data.boolData() == 1 ? Serial.println("motor on"): Serial.println("motor off");
  }
  if (data.dataPath()=="/flow_reset"){
    if(data.boolData() == false ){
      motor.resetFlow();
    }
    // Serial.println(data.floatData());
  }
  if (data.dataPath()=="/sumur_on_level"){
    motor.setMinimumOnLevel(data.floatData());
    Serial.println(data.floatData());
  }
  if (data.dataPath()=="/sumur_off_level"){
    motor.setMinimumLevel(data.floatData());
    Serial.println(data.floatData());
  }
  if (data.dataType() == "json"){
    FirebaseJson &json = data.jsonObject();
    String jsonStr;
    json.toString(jsonStr, true);
    size_t len = json.iteratorBegin();
    String key, value = "";
    int type = 0;
    for (size_t i = 0; i < len; i++){
      json.iteratorGet(i, type, key, value);

      if (key=="motor"){
        value=="true"? motor.motorOn() : motor.motorOff();
      }
      
      if (key=="sumur_on_level"){
        motor.setMinimumOnLevel(value.toInt());
        // Serial.println(value.toInt());
      }
      
      if (key=="sumur_off_level"){
        motor.setMinimumLevel(value.toInt());
        // Serial.println(value.toInt());
      }
      if (key=="flow_reset"){
        if (value=="false")
        {
          motor.resetFlow();
        }
      }
    }
    json.iteratorEnd();
  }
}

void streamTimeoutCallback(bool timeout)
{
  if (timeout)
  {
    Serial.println();
    Serial.println("Stream timeout, resume streaming...");
    Serial.println();
  }
}

float flowValue;
unsigned long counter;

void ICACHE_RAM_ATTR  flowCallback(){
  static int tambah;
  if (digitalRead(FLOW_SENSOR)==HIGH){
    if (tambah == 1){
      counter++;
      tambah = 0;
    }
  }
  else{
    tambah=1;
  }
}

void ICACHE_RAM_ATTR TimerHandler(){
  noInterrupts(); // again
  flowValue=counter/3.9;
  counter=0;
  interrupts();
}
void setup(){
    // Interval in microsecs
  ITimer.attachInterruptInterval(1000000, TimerHandler);
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
  //Set the size of WiFi rx/tx buffers in the case where we want to work with large data.
  firebaseData1.setBSSLBufferSize(1024, 1024);
  //Set the size of HTTP response buffers in the case where we want to work with large data.
  firebaseData1.setResponseSize(1024);
  // Set the size of WiFi rx/tx buffers in the case where we want to work with large data.
  firebaseData2.setBSSLBufferSize(1024, 1024);
  // Set the size of HTTP response buffers in the case where we want to work with large data.
  firebaseData2.setResponseSize(1024);

  if (!Firebase.beginStream(firebaseData1, "/nodeGet"))
  {
    Serial.println("------------------------------------");
    Serial.println("Can't begin stream connection...");
    Serial.println("REASON: " + firebaseData1.errorReason());
    Serial.println("------------------------------------");
    Serial.println();
  }

  Firebase.setStreamCallback(firebaseData1, streamCallback, streamTimeoutCallback);
  Serial.println("start.....");
  attachInterrupt(FLOW_SENSOR, flowCallback, CHANGE);
  pinMode(FLOW_SENSOR,INPUT_PULLUP);
  pinMode(OVERLOAD_PIN,INPUT_PULLUP);
  pinMode(LED,OUTPUT);
  sonar.setMirorLenght(21.8);

}



void loop(){
  float level =  sonar.getMirorDistance();

  if (kedip.getEvent())
  {
    digitalRead(LED)==LOW?
    digitalWrite(D0,HIGH):
    digitalWrite(D0,LOW);
  }
  
  if (event.getEvent()) {

    //set flow ke firebasw
    if (flowData.setData(flowValue)){
      Firebase.setDouble(firebaseData2, "/nodeSet/flow",(flowValue));
    }
     
    //cek alarm flow sensor
    if (!motor.setFlow(flowValue)){
      Firebase.setBool(firebaseData2, "/alarm/flow",true);
      if (flowAlarm.setData(HIGH)){
        Firebase.setBool(firebaseData2, "/nodeGet/flow_reset",true);
      }
    }
    else{
      flowAlarm.setData(LOW);
      Firebase.setBool(firebaseData2, "/alarm/flow",false);
    }

    // Sensor suhu pada motor listrik
    static float motorTemp;
    sensors.requestTemperatures();
    if (motorTemp != sensors.getTempCByIndex(0)){
      motor.setTemperature(sensors.getTempCByIndex(0));
      if (Firebase.setDouble(firebaseData2, "/nodeSet/suhu",sensors.getTempCByIndex(0))){
        if (sensors.getTempCByIndex(0)>=100){
          Firebase.setBool(firebaseData2, "/alarm/overheat",true);
        }
        else{
          Firebase.setBool(firebaseData2, "/alarm/overheat",false);
        }
      }
    }
    //sensor overload pada motor
    if (digitalRead(OVERLOAD_PIN)==LOW ) {
      motor.setOverload(true);
      Firebase.setBool(firebaseData2, "/alarm/overload",true);
    }
    else {
      motor.setOverload(false);
      Firebase.setBool(firebaseData2, "/alarm/overload",false);
    }
    
    
    //sensor ketinggian air sumur
    // int level = 21 - sonar.ping_cm();

    if (motor.setLevel(level)) {
      Firebase.setBool(firebaseData2, "/alarm/level",false);
    }
    else {
      Firebase.setBool(firebaseData2, "/alarm/level",true);
    }

    if (levelData.setData(level))
    {
      Firebase.setDouble(firebaseData2, "/nodeSet/sumur",(level));
      Firebase.setDouble(firebaseData2, "/tankGet/sumur",(level));
    }
  }
}
