#!/bin/bash

#######################################################################################################################################################	

### speedtest2domo.sh
### @author	: safi78
### @since	: 22-10-2016
### @updated: 19-4-2017
### Thread: https://www.domoticz.com/forum/viewtopic.php?f=21&t=13814
### Simple script for monitoring your ping, down/upload speeds and pass them to custom virtual devices

#######################################################################################################################################################

#setup
host=xxx.xxx.xxx.xxx
port=xxxx
username=xxx
password=xxx
pingidx=xxx
downloadidx=xxx
uploadidx=xxx

# no need to edit
speedtest-cli --simple > /mnt/storage/domoticz_scripts/logging/speedtest/speedtest.txt
ping=$(cat /mnt/storage/domoticz_scripts/logging/speedtest/speedtest.txt | sed -ne 's/^Ping: \([0-9]*\.[0-9]*\).*/\1/p')
download=$(cat /mnt/storage/domoticz_scripts/logging/speedtest/speedtest.txt | sed -ne 's/^Download: \([0-9]*\.[0-9]*\).*/\1/p')
upload=$(cat /mnt/storage/domoticz_scripts/logging/speedtest/speedtest.txt | sed -ne 's/^Upload: \([0-9]*\.[0-9]*\).*/\1/p')

#output if you run it manually
echo "ping = $ping ms"
echo "download = $download Mbps"
echo "upload =  $upload Mbps"

curl -s -i -H "Accept: application/json" "http://$username:$password@$host:$port/json.htm?type=command&param=udevice&idx=$pingidx&svalue=$ping"
curl -s -i -H "Accept: application/json" "http://$username:$password@$host:$port/json.htm?type=command&param=udevice&idx=$downloadidx&svalue=$download"
curl -s -i -H "Accept: application/json" "http://$username:$password@$host:$port/json.htm?type=command&param=udevice&idx=$uploadidx&svalue=$upload"

