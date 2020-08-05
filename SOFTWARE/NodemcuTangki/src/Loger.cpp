
#include "Loger.h"

void Loger::setLevelSumur(int Level){
    this->sumur=Level;    
}
void Loger::setLevelTangki(int Level){
    this->tangki=Level;    
}

String Loger::getDay(){
    //Get a time structure
  String months[12]={"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
  timeClient.update();
  unsigned long epochTime = timeClient.getEpochTime();
  struct tm *ptm = gmtime ((time_t *)&epochTime); 
  int monthDay = ptm->tm_mday;
  int currentMonth = ptm->tm_mon+1;
  String currentMonthName = months[currentMonth-1];
  int currentYear = ptm->tm_year+1900;
  return String(currentYear) + "/" + String(currentMonth) + "/" + String(monthDay);
  // String currentDate = String(currentYear) + "-" + String(currentMonth) + "-" + String(monthDay)+"/";
  // return currentDate;
}

String Loger::getEtag(){
    //Get a time structure
  timeClient.update();
  unsigned long epochTime = timeClient.getEpochTime();
  struct tm *ptm = gmtime ((time_t *)&epochTime); 
  int monthDay = ptm->tm_mday;
  int currentMonth = ptm->tm_mon+1;
  int currentYear = ptm->tm_year+1900;
  unsigned long rawTime = timeClient.getEpochTime();
  unsigned long hours = (rawTime % 86400L) / 3600;
  String hoursStr = hours < 10 ? "0" + String(hours) : String(hours);
  unsigned long minutes = (rawTime % 3600) / 60;
  String minuteStr = minutes < 10 ? "0" + String(minutes) : String(minutes);
  unsigned long seconds = rawTime % 60;
  String secondStr = seconds < 10 ? "0" + String(seconds) : String(seconds);
  return String(currentYear) +  String(currentMonth) + String(monthDay)+hoursStr + minuteStr + secondStr;;
}

void Loger::setInterval(int detik){
    this->event.setEvent(detik*1000);
}
void Loger::loop(){
    
    if (event.getEvent()) {
        this->save();
    }
}
void Loger::save(){

    String path = "/Log/"+ this->getEtag();
    Firebase.setString(firebaseLog, path  + "/Tanggal", this->getDay());
    Firebase.setString(firebaseLog, path  + "/Jam", this->timeClient.getFormattedTime());  
    Firebase.setInt(firebaseLog, path  + "/Sumur", this->sumur);
    Firebase.setInt(firebaseLog, path  + "/Tangki", this->tangki);
}

Loger::Loger(/* args */)
{
    
    timeClient.setTimeOffset(3600*7);
    timeClient.begin();
    firebaseLog.setBSSLBufferSize(1024, 1024);
    firebaseLog.setResponseSize(1024);
    Firebase.setReadTimeout(firebaseLog, 1000 * 60);
    Firebase.setwriteSizeLimit(firebaseLog, "tiny");

}

Loger::~Loger()
{
}
