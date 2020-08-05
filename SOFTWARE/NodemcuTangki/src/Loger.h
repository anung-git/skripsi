
#ifndef LOGER_H
#define LOGER_H

#include <Arduino.h>
#include "FirebaseESP8266.h"
#include <NTPClient.h>
#include <WiFiUdp.h>
#include "Event.h"

class Loger
{
private:
    FirebaseData firebaseLog;
    int sumur, tangki;
    WiFiUDP ntpUDP;
    NTPClient timeClient = NTPClient(ntpUDP, "asia.pool.ntp.org", 3600*7);
    void save();
    String getDay();
    String getEtag();
    Event event = Event(10);
public:
    Loger();
    ~Loger();
    void loop();
    void setInterval(int detik);
    void setLevelSumur(int Level);
    void setLevelTangki(int Level);
};
#endif