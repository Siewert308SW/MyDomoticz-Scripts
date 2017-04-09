#!/bin/bash

#######################################################################################################################################################	

### weer_tweet.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 1-2-2017
### Simple script grep weather data from WeatherUnderground sensors devices in Domoticz to sent to twitter
### See weer_tweet.py for tweeting this data
timestamp=`/bin/date +%H`
#######################################################################################################################################################	

thermo=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=165"`
echo $thermo > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
temperature=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $17, $18}' | awk '{print $3}' | sed 's/\"//g'`

hygro=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=165"`
echo $hygro > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
hygro=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $18, $19}' | awk '{print $3}' | sed 's/\"//g'`

rain=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=154"`
echo $rain > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
rain=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $33, $34}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`

wind=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=166"`
echo $wind > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
dir=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $20, $21}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`
#speed=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $39, $40}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`
speed=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $22, $23}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`



  if [ $(echo "$speed > 0.0 ") ] && [ $(echo "$speed < 1 ") ]; then bft=" - 0Bft"
 elif [ $(echo "$speed > 1 ") ] && [ $(echo "$speed < 2 ") ]; then bft=" - 1Bft"
 elif [ $(echo "$speed > 2 ") ] && [ $(echo "$speed < 3 ") ]; then bft=" - 2Bft"
 elif [ $(echo "$speed > 3 ") ] && [ $(echo "$speed < 4 ") ]; then bft=" - 3Bft"
 elif [ $(echo "$speed > 4 ") ] && [ $(echo "$speed < 6 ") ]; then bft=" - 4Bft"
 elif [ $(echo "$speed > 6 ") ] && [ $(echo "$speed < 8 ") ]; then bft=" - 5Bft"
elif [ $(echo "$speed > 8 ") ] && [ $(echo "$speed < 12 ") ]; then bft=" - 6Bft"
elif [ $(echo "$speed > 12 ") ] && [ $(echo "$speed < 15 ") ]; then bft=" - 7Bft"
elif [ $(echo "$speed > 15 ") ] && [ $(echo "$speed < 20 ") ]; then bft=" - 8Bft"
elif [ $(echo "$speed > 20 ") ] && [ $(echo "$speed < 25 ") ]; then bft=" - 9Bft"
elif [ $(echo "$speed > 25 ") ] && [ $(echo "$speed < 29 ") ]; then bft=" - 10Bft"
elif [ $(echo "$speed > 29 ") ] && [ $(echo "$speed < 33 ") ]; then bft=" - 11Bft"
elif [ $(echo "$speed > 33 ") ] && [ $(echo "$speed < 40") ]; then bft=" - 12Bft"
else
bft=""
fi

chill=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=166"`
echo $chill > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
chill=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $15, $16}' | awk '{print $3}' | cut -c 1-3 | sed 's/\"//g' | sed 's/,//g'`

baro=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=165"`
echo $baro > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
baro=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $14, $15}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`

zicht=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=169"`
echo $zicht > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
zicht=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $16, $17}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`

if [ $zicht == 10.0 ]; then
zicht="Zicht: > 10km\n"
else
zicht="Zicht: "`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $16, $17}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`"km\n"
fi

uv=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=167"`
echo $uv > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
uv=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $16, $17}' | awk '{print $3}' | cut -c 1-2 | sed 's/\"//g' | sed 's/,//g'`

echo -ne "#Zoutkamp | "$timestamp":00\nTemp: "$temperature"C / Gevoel: "$chill"C\nVocht: "$hygro"%\nNeerslag: "$rain"mm\nWind: "$dir" / "$speed"m/s""\nBaro: "$baro"hPa\n"$zicht"UV: "$uv"\n" > /mnt/storage/domoticz_scripts/weer_tweets/weather-tweet.txt

sudo python /home/pi/domoticz/scripts/python/weer_tweet.py
sleep 5
exit
