#include "Event.h"
bool Event::getEvent(){
    unsigned long currentMillis = millis();
    if (currentMillis - previousMillis >= interval) {
        previousMillis = currentMillis;
        return true;
    }
    else return false;
}
void Event::setEvent(int mili_second){
    this->interval = mili_second;
}

Event::Event(int mili_second)
{
    this->interval = mili_second;
    this->previousMillis=millis();
}

Event::~Event()
{
}
