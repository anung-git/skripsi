#include "Motor.h"

void Motor::setOverload( bool ol)
{
    this->overload = ol;

    if (this->overload == false )
    {
        this->turnOn();
    }
    
    if (this->motorState == HIGH &&  this->overload == true)
    {
        this->turnOff();
    }
    
}
void Motor::setMinimumOnLevel(float temp){
    this->minimumOnLevel=temp;
}
void Motor::setMinimumLevel( float cm)
{
    this->minimumLevel = cm;

    if (this->level > this->minimumLevel)
    {
        this->turnOn();
    }
    
    if (this->motorState == HIGH &&  this->level < this->minimumLevel)
    {
        this->turnOff();
    }
    
}
int Motor::setLevel( float cm)
{
    this->level = cm;
    if (this->level >= this->minimumOnLevel)
    {
        this->levelState=HIGH;
        this->turnOn();
    }
    
    if (this->motorState == HIGH && this->level  <= this->minimumLevel)
    {
        this->levelState=LOW;
        this->turnOff();
    }
    return this->levelState;
}
int Motor::setFlow( float flow){
    if (digitalRead(this->motorPin) == HIGH &&  flow == 0)
    {
        if ((millis()-this->lastOn)>2000L)
        {
            this->flowReset=HIGH;
            this->turnOn();
            // return 0;
        }
    }
    return !this->flowReset;
}

void Motor::resetFlow(){
    this->flowReset=LOW;
    this->turnOn();
}

void Motor::motorOn(){
    this->motorState=HIGH;
    this->turnOn();

}
void Motor::turnOn(){
    if (this->motorTempeerature >= this->maxTemperature) {
        this->turnOff();
        return;
    }
    if (this->level <= this->minimumLevel) {
        this->turnOff();
        return;
    }
    if (this->flowReset == HIGH) {
        this->turnOff();
        return;
    }
    if (this->overload == true) {
        this->turnOff();
        return;
    }
    if (this->levelState == LOW) {
        this->turnOff();
        return;
    }
    if (digitalRead(this->motorPin)!=this->motorState )
    {
        this->lastOn=millis();
    }
    digitalWrite(this->motorPin,this->motorState);  // motor listrik

}
void Motor::turnOff()
{
    digitalWrite(this->motorPin,LOW);    // motor listrik
    
}
void Motor::motorOff()
{
    this->motorState=LOW;
    this->turnOff();
}
void Motor::setTemperature( float temp)
{
    this->motorTempeerature = temp;
    temp >= this->maxTemperature?
        this->turnOff():
        this->turnOn();
}
Motor::Motor(int motor_pin,  float max_temperature)
{
    this->motorPin=motor_pin;
    this->maxTemperature=max_temperature;

    this->minimumLevel=2;
    this->minimumOnLevel=4;
    this->level=10;
    this->motorTempeerature=30;
    this->overload = false;
    this->motorState = LOW;
    this->levelState = HIGH;
    pinMode(this->motorPin,OUTPUT);
}

Motor::~Motor()
{
}
