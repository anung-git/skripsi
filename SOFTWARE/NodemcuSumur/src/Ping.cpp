#include "Ping.h"

void Ping::setMirorLenght(float lenght){
    this->mirror=lenght;
}
float Ping::getMirorDistance(){

    SUM = SUM - READINGS[INDEX];                        // Remove the oldest entry from the sum
    VALUE = (this->mirror -(this->sonar->ping()/57.0)); // Read the next sensor value
    READINGS[INDEX] = VALUE;                            // Add the newest reading to the window
    SUM = SUM + VALUE;                                  // Add the newest reading to the sum
    INDEX = (INDEX+1) % WINDOW_SIZE;                    // Increment the index, and wrap to 0 if it exceeds the window size
    AVERAGED = SUM / WINDOW_SIZE;                       // Divide the sum of the window by the window size for the result
  
    return AVERAGED;
}
Ping::Ping(int triger, int echo, int max_distance)
{
    this->sonar = new NewPing (triger, echo, max_distance); 
    // simpleKalmanFilter = SimpleKalmanFilter(2, 0.5, 0.1);
}

Ping::~Ping()
{
}
