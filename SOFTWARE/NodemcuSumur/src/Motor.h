#ifndef MOTOR_H
#define MOTOR_H
#include <Arduino.h>


class Motor
{
private:
    float minimumLevel;
    float minimumOnLevel;
    float level;
    float maxTemperature;
    float motorTempeerature;
    int motorPin;
    int overload;
    int motorState;
    int levelState;
    int flowReset;
    unsigned long lastOn;
public:
    Motor(int motor_pin, float max_temperature);
    ~Motor();
    void motorOff();
    void turnOff();
    void motorOn();
    void turnOn();
    void resetFlow();
    void setTemperature(float temp);
    int setFlow(float temp);
    int setLevel(float temp);
    void setMinimumOnLevel(float temp);
    void setMinimumLevel(float temp);
    void setOverload(bool ol);

};

#endif