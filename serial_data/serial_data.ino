/*
  Arduino LSM9DS1 - Gyroscope Application

  This example reads the gyroscope values from the LSM9DS1 sensor 
  and prints them to the Serial Monitor or Serial Plotter, as a directional detection of 
  an axis' angular velocity.

  The circuit:
  - Arduino Nano 33 BLE Sense

  Created by Riccardo Rizzo

  Modified by Benjamin Dannegård
  30 Nov 2020

  This example code is in the public domain.
*/

#include <Arduino_LSM9DS1.h>

float maxAx, maxAy, maxAz, minAx, minAy, minAz;

void setup() {
  Serial.begin(115200);
  while (!Serial);
  Serial.println("Started");

  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }
  Serial.print("Gyroscope sample rate = ");
  Serial.print(IMU.gyroscopeSampleRate());
  Serial.println(" Hz");
  Serial.println();
  Serial.println("Gyroscope in degrees/second");

  // Accelerometer code
  IMU.setAccelFS(2);        // setAccelFS(2)  = +-4 g
  IMU.setAccelODR(5);       // setAccelODR(5) = 476 Hz
  IMU.setAccelOffset(0.006245, -0.016577, -0.005882);
  IMU.setAccelSlope (1.000514, 1.001754, 1.004684);

  // Gyroscope code
  IMU.setGyroFS(0);         // setGyroFS(2)  = +-245 degree per second
  IMU.setGyroODR(5);        // setGyroODR(5) = 476 Hz
  IMU.setGyroOffset (0.0106323, -0.0292786, 1.0346252);
  IMU.setGyroSlope (1.0217233, 1.0247035, 1.0188662);

  // Magnetometer code
  IMU.setMagnetFS(0);       // setMagnetFS(0)  = +- 400 uT
  IMU.setMagnetODR(8);      // setMagnetODR(8) = 400 Hz
  IMU.setMagnetOffset(-29.737549, 39.312134, 4.569702);
  IMU.setMagnetSlope (1.300107, 1.360313, 1.211706);
}

float accelX, accelY, accelZ;
float gyroX, gyroY, gyroZ;
float magnetX, magnetY, magnetZ;

/*
 * template protocol:
 * init
 * 0.2004 -0.5284 -0.0257 0.0034 -0.0051 -1.0098 23.1567 13.5620 14.0625
 * 
 * 
 */

void loop() {
  Serial.println("init");
  
  if (IMU.gyroscopeAvailable()) {
    IMU.readGyroscope(gyroX, gyroY, gyroZ);
  }
  Serial.print(gyroX, 4);
  Serial.print(" ");
  Serial.print(gyroY, 4);
  Serial.print(" ");
  Serial.print(gyroZ, 4);
  Serial.print(" ");

  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(accelX, accelY, accelZ);
  }
  Serial.print(accelX, 4);
  Serial.print(" ");
  Serial.print(accelY, 4);
  Serial.print(" ");
  Serial.print(accelZ, 4);
  Serial.print(" ");

  if(IMU.magneticFieldAvailable()){
     IMU.readMagneticField(magnetX, magnetY, magnetZ); 
  }
  Serial.print(magnetX, 4);
  Serial.print(" ");
  Serial.print(magnetY, 4);
  Serial.print(" ");
  Serial.println(magnetZ, 4);
  delay(150);
  
}
