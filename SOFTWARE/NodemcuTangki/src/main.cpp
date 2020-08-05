#include <Arduino.h>
//FirebaseESP8266.h must be included before ESP8266WiFi.h
#include "FirebaseESP8266.h"
#include "Ping.h"
#include <ESP8266WiFi.h>
#include "Tangki.h"
#include "Loger.h"
#include "Event.h"
#include <SimpleKalmanFilter.h>


const char *ssid     = "ardinista";
const char *password = "ardiasta";
#define TRIGGER_PIN  D7  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     D8  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 200 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.



#define FIREBASE_HOST "skripsi-9726b.firebaseio.com" //Without http:// or https:// schemes
#define FIREBASE_AUTH "b5LLW3w6JPyKzecPzKwUqz3oX5sTdW2wGUOpTM4A"
#define WIFI_SSID "ardinista"
#define WIFI_PASSWORD "ardiasta"


//Define FirebaseESP8266 data object
FirebaseData firebaseData;
FirebaseData firebaseStream;
FirebaseJson json;
SimpleKalmanFilter simpleKalmanFilter(2, 2, 0.1);

Tangki tangki = Tangki(11, 2 ,false);
Ping sonar = Ping (TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.
Loger dataLoger ;
Event event = Event(1000);
Event kedip = Event(500);
Event eventLevel = Event(50);
// Event eventLevel = Event(10);

void streamCallback(StreamData data){
  Serial.println("Stream callback ...");

  if (data.dataPath()=="/sumur"){
    dataLoger.setLevelSumur(data.floatData());
    Serial.print("level sumur =");
    Serial.println(data.floatData());
  }

  if (data.dataPath()=="/tangki_max"){
    tangki.setMax(data.floatData());
    Serial.print("max level =");
    Serial.println(data.floatData());
  }
  
  if (data.dataPath()=="/tangki_min"){
    tangki.setMin(data.floatData());
    Serial.print("min level =");
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

      if (key=="sumur"){
        dataLoger.setLevelSumur(value.toInt());
        Serial.print("sumur level log =");
        Serial.println(value.toInt());
      }

      if (key=="tangki_min"){
        tangki.setMin(value.toInt());
        Serial.print("min level =");
        Serial.println(value.toInt());
      }
      
      if (key=="tangki_max"){
        tangki.setMax(value.toInt());
        Serial.print("max level =");
        Serial.println(value.toInt());
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

void setup()
{
  
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

  firebaseStream.setBSSLBufferSize(1024, 1024);
  firebaseStream.setResponseSize(1024);

  if (!Firebase.beginStream(firebaseStream, "/tankGet"))
  {
    Serial.println("------------------------------------");
    Serial.println("Can't begin stream connection...");
    Serial.println("REASON: " + firebaseStream.errorReason());
    Serial.println("------------------------------------");
    Serial.println();
  }

  Firebase.setStreamCallback(firebaseStream, streamCallback, streamTimeoutCallback);
  // test();
  sonar.setMirorLenght(22.2);
  dataLoger.setInterval(10);
  pinMode(D0,OUTPUT);
}


float level ;//= sonar.getMirorDistance();
void loop() {
  if (eventLevel.getEvent()){
    level = sonar.getMirorDistance();
  }

  dataLoger.loop();
  if (kedip.getEvent())
  {
    digitalRead(D0)==LOW?
    digitalWrite(D0,HIGH):
    digitalWrite(D0,LOW);
  }
  
  if (event.getEvent()){
    Firebase.setDouble(firebaseData,"/nodeSet/tangki", level);
    dataLoger.setLevelTangki(level);

    if (tangki.setLevel(level)==LOW){
      Serial.println("motor off");
      Firebase.setBool(firebaseData, "/nodeGet/motor", false);
    }
    else
    {
      Serial.println("motor on");
      Firebase.setBool(firebaseData, "/nodeGet/motor", true);
    }
    
  }
}