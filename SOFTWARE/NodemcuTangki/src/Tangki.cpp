#include "Tangki.h"
#include <Arduino.h>
void Tangki::setMax(int high){
    Serial.print("seting max =");
    Serial.println(high);
    this->max =high;
};
void Tangki::setMin(int low){
    Serial.print("seting min =");
    Serial.println(low);
    this->min =low;
};
void Tangki::setState(bool state){
    this->state=state;
};
int Tangki::setLevel(float tinggi){
    if (tinggi >= this->max)
    {
        this->state=LOW;
    }
    else if (tinggi <= this->min)
    {
        this->state =HIGH;
    }
    return this->state;
}

Tangki::Tangki(int high, int low ,bool state)
{
    this->max =high;
    this->min =low;
    this->state=state;
}

Tangki::~Tangki()
{
}
