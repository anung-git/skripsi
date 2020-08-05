#ifndef Event_H
#define Event_H

#include <Arduino.h>


class Event
{
private:
    unsigned long previousMillis,interval ;    
public:
    Event(int second);
    bool getEvent();
    void setEvent(int mili_second);
    ~Event();
};



// Existing code goes here

#endif