#include "DataBase.h"

bool DataBase::setData(String data){
    this->dataString =data;
    if (this->dataString != this->tempDataString ){
        this->dataUpdate = true;
        this->tempDataString = data;
    }
    else{
        this->dataUpdate = false;
    }   
    return this->dataUpdate;
}
bool DataBase::setData(bool data){
    this->dataBool =data;
    if (this->dataBool != this->tempDataBool ){
        this->dataUpdate = true;
        this->tempDataBool = data;
    }
    else{
        this->dataUpdate = false;
    }   
    return this->dataUpdate;
}
bool DataBase::setData(int data){
    this->dataInt=data;
    if (this->dataInt != this->tempDataInt ){
        this->dataUpdate = true;
        this->tempDataInt = data;
    }
    else{
        this->dataUpdate = false;
    }   
    return this->dataUpdate;
}
bool DataBase::setData(float data){
    this->dataFloat = data;
    if (this->dataFloat != this->tempDataFloat ){
        this->dataUpdate = true;
        this->tempDataFloat = data;
    }
    else{
        this->dataUpdate = false;
    }   
    return this->dataUpdate;
}
DataBase::DataBase(/* args */)
{
}

DataBase::~DataBase()
{
}
