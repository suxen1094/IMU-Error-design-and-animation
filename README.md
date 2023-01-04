# IMU-Error-design-and-animation

## Abstract
這是由周百祥教授指導、
由蘇志翔於111學年度上學期製作的資工系專題

## Preparation
#### 1. 使用的IDE：
Arduino IDE、VS code、Matlab
#### 2. 使用的程式語言：
C/C++ for Arduino IDE、Pyhton for VS code
#### 3. 使用的開發板：
Arduino nano 33 BLE Sense，這塊開發板的IMU為LSM9DS1
#### 4. 使用的Library：
1. 由FemmeVerbeek所製作的LSM9DS1 Calibration library，會在Arduino IDE中使用到
連結：https://github.com/FemmeVerbeek/Arduino_LSM9DS1

2. Matlab - Measure LSM9DS1 Sensor Outputs Using Nano 33 BLE Sense
負責教要怎麼從開發板中的IMU去讀取資料進Matlab  
連結：https://www.mathworks.com/help/supportpkg/arduinoio/ug/Nano33BLEsense_sensorconnections.html

## Files Description

### serial_data
裡面的資料為.ino檔，需要使用Arduino IDE開啟  
負責從開發板中讀取加速度計、陀螺儀、磁力計的資料
格式為：

_init_  
_gyro_x gyro_y gyrp_z accel_x accel_y accel_z mag_x mag_y mag_z_

其中
gyro_x的gyro代表陀螺儀，x代表x軸
accel代表加速度計  
mag代表磁力計  
以此類推

## Arduino_Matlab
裡面的資料為Matlab檔案  
負責分析開發板中IMU的資料並製作成圖表

## Extended Kalman Filter
裡面的資料為實作Kalman filter以及製作動畫的程式碼  
需要先使用Serial_data中的程式碼去讀取資料之後才能使用這份資料夾中的檔案

# Remark

這裡的Code只是做為輔助說明
完整的說明請搭配我的專題書面報告服用
