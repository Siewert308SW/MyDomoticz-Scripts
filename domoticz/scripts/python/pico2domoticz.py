#!/usr/bin/python
# Author : JF Hautenauven
# Description : Script that get the status of the UPS Pico and sends it back to Domoticz
# Version : 1.0.1
# Credits : to pimodules.com for providing the documentation
import sys
import ssl
import smbus
import time
import datetime
import time
from urllib2 import urlopen
 
# change these values
# domoticz = URL to the Domoticz server
# idx_ are the id's of the devices corresponding to the data in domoticz
domoticz = "http://127.0.0.1:8080"
idx_bat_level = 136
idx_rpi_level = 137
idx_PIcoBoardTemperature = 144
idx_PIcoFanTemperature = 134
idx_PIcoFanSpeed = 135
# End 
 
i2c = smbus.SMBus(1)

def bat_level():
   time.sleep(0.1)
   data = i2c.read_word_data(0x69, 0x08)
   data = format(data,"02x")
   return (float(data) / 100)

def pwr_mode():
   time.sleep(0.1)
   data = i2c.read_byte_data(0x69, 0x00)
   data = data & ~(1 << 7)
   if (data == 1):
      return "RPi POWERED"
   elif (data == 2):
      return "BAT POWERED"
   else:
      return "ERROR"
	  
def rpi_level():
   time.sleep(0.1)
   data = i2c.read_word_data(0x69, 0x0a)
   data = format(data,"02x")
   powermode = pwr_mode()
   if (powermode == "RPi POWERED"):
		return (float(data) / 100)
   else:
		return "0.0"
 
def ntc1_temp():
   time.sleep(0.1)
   data = i2c.read_byte_data(0x69, 0x1b)
   data = format(data,"02x")
   return data
   
def to92_temp():
   time.sleep(0.1)
   data = i2c.read_byte_data(0x69, 0x1c)
   data = format(data,"02x")
   return data
   
def fan_speed():
   time.sleep(0.1)
   data = i2c.read_byte_data(0x6b, 0x12)
   if (data == 0x00):
      return 0
   elif (data == 0x19):
      return 25.00	  
   elif (data == 0x32):
      return 50.00
   elif (data == 0x4b):
      return 75.00
   elif (data == 0x64):
      return 100.00		  
   else:
      return "0"

# PIco BATT Level
response= urlopen(domoticz+'/json.htm?type=command&param=udevice&idx='+str(idx_bat_level)+'&nvalue=0&svalue='+str(bat_level()))
response.read()

# RPi Level
response= urlopen(domoticz+'/json.htm?type=command&param=udevice&idx='+str(idx_rpi_level)+'&nvalue=0&svalue='+str(rpi_level()))
response.read()

# PIco board temperature
response= urlopen(domoticz+'/json.htm?type=command&param=udevice&idx='+str(idx_PIcoBoardTemperature)+'&nvalue=0&svalue='+str(ntc1_temp()))
response.read()
	  	  
# PIco fan temperature
response= urlopen(domoticz+'/json.htm?type=command&param=udevice&idx='+str(idx_PIcoFanTemperature)+'&nvalue=0&svalue='+str(to92_temp()))
response.read()

# PIco fan speed
response= urlopen(domoticz+'/json.htm?type=command&param=udevice&idx='+str(idx_PIcoFanSpeed)+'&nvalue=0&svalue='+str(fan_speed()))
response.read()

exit();