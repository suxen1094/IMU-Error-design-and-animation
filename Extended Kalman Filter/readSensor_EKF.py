#!/usr/bin/env python

from threading import Thread
import serial
import time
import struct
import numpy as np

def wait_until_transmission_start(ser):
 while True:
   # Used to indicate start of transmission
   line = ser.readline().strip().decode()
   s = 'init'
   if s in line:
     break
   else:
     print ("ERROR: received non init line", line)

class SerialRead:
    def __init__(self, serialPort='/dev/ttyUSB0', serialBaud=38400, dataNumBytes=2, numParams=1):
        self.port = serialPort
        self.baud = serialBaud
        self.dataNumBytes = dataNumBytes
        self.numParams = numParams
        self.line = 0
        self.dataType = None
        if dataNumBytes == 2:
            self.dataType = 'h'     # 2 byte integer
        elif dataNumBytes == 4:
            self.dataType = 'f'     # 4 byte float
        self.data = np.zeros(numParams)
        self.isRun = True
        self.isReceiving = False
        self.thread = None
        # self.csvData = []

        print('Trying to connect to: ' + str(serialPort) + ' at ' + str(serialBaud) + ' BAUD.')
        try:
            self.serialConnection = serial.Serial(serialPort, serialBaud, timeout=4)
            print('Connected to ' + str(serialPort) + ' at ' + str(serialBaud) + ' BAUD.')
        except:
            print("Failed to connect with " + str(serialPort) + ' at ' + str(serialBaud) + ' BAUD.')
            exit()

    def readSerialStart(self):
        if self.thread == None:
            self.thread = Thread(target=self.backgroundThread)
            self.thread.start()
            # Block till we start receiving values
            while self.isReceiving != True:
                time.sleep(0.1)

    def getSerialData(self):
        for i in range(9):
            value = self.line[i]
            if i <= 2:
                # gyro data => Units: degree per second -> radians per second => value = value / 180 * pi
                value = value/ 180.0 * np.pi
            elif i <= 5:
                # accel data => Units: g -> g => value = value
                value = value
            elif i <= 8:
                # magnet data => Units: Tesla * 10^-6 -> gauss * 10^-3 => value = value * 10
                value = value * 10
            self.data[i] = value
        return self.data
        # for i in range(self.numParams):
        #     data = privateData[(i*self.dataNumBytes):(self.dataNumBytes + i*self.dataNumBytes)]
        #     value,  = struct.unpack(self.dataType, data)
        #     if i == 0:
        #         value = ((value * 0.00875) - 0.464874541896) / 180.0 * np.pi
        #     elif i == 1:
        #         value = ((value * 0.00875) - 9.04805461852) / 180.0 * np.pi
        #     elif i == 2:
        #         value = ((value * 0.00875) + 0.23642053973) / 180.0 * np.pi
        #     elif i == 3:
        #         value = (value * 0.061) - 48.9882695319
        #     elif i == 4:
        #         value = (value * 0.061) - 58.9882695319
        #     elif i == 5:
        #         value = (value * 0.061) - 75.9732905214
        #     elif i == 6:
        #         value = value * 0.080
        #     elif i == 7:
        #         value = value * 0.080
        #     elif i == 8:
        #         value = value * 0.080
        #     self.data[i] = value

    def backgroundThread(self):    # retrieve data
        time.sleep(1.0)  # give some buffer time for retrieving data
        self.serialConnection.reset_input_buffer()
        while (self.isRun):
            wait_until_transmission_start(self.serialConnection)
            self.line = self.serialConnection.readline().strip().decode().lstrip("\x00").lstrip("C!").lstrip('\xf8')
            self.line = self.line.rstrip("\x00")
            self.line = [float(j) for j in self.line.split(" ")]
            self.isReceiving = True
            # print(self.line)

    def close(self):
        self.isRun = False
        self.thread.join()
        self.serialConnection.close()
        print('Disconnected...')
        # df = pd.DataFrame(self.csvData)
        # df.to_csv('/home/rikisenia/Desktop/data.csv')