
#ifndef PING_H
#define PING_H
#include <Arduino.h>
#include "NewPing.h"

#define WINDOW_SIZE 25
class Ping
{
private:
    NewPing * sonar ;
    float mirror;

    int INDEX = 0;
    float VALUE = 0;
    float SUM = 0;
    float READINGS[WINDOW_SIZE];
    float AVERAGED = 0;
public:
    Ping(int triger, int echo, int max_distance);
    void setMirorLenght(float lenght);
    float getMirorDistance();
    ~Ping();
};

#endif