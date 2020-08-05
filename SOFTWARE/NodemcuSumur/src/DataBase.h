#ifndef DATABASE_H
#define DATABASE_H
#include <Arduino.h>

class DataBase
{
private:
    
    int dataInt;
    float dataFloat;
    bool dataBool;
    String dataString;
    int tempDataInt;
    float tempDataFloat;
    bool tempDataBool;
    String tempDataString;
    bool dataUpdate;
public:
    DataBase();
    bool setData(String data);
    bool setData(bool data);
    bool setData(int data);
    bool setData(float data);
    ~DataBase();
};
#endif