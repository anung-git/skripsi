#include <Arduino.h>

class Tangki
{
private:
    bool state;
public:
    int max,min;
    Tangki(int high, int low ,bool state);
    ~Tangki();
    void setState(bool state);
    void setMax(int high);
    void setMin(int low);
    int setLevel(float tinggi);

};