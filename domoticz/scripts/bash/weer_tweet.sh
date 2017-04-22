#!/bin/bash

#######################################################################################################################################################	

### weer_tweet.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 23-4-2017
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

rain=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=186"`
echo $rain > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
rain=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $33, $34}' | awk '{printf("%.1f\n", $3)}' | sed 's/\"//g' | sed 's/,//g'`

rainforecast=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=192"`
echo $rainforecast > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
rainforecast=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $17, $18}' | awk '{print $1, $2, $3, $4}' | sed 's/\"//g' | sed 's/,//g'`

wind=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=166"`
echo $wind > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
dir=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $20, $21}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`
speed=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $22, $23}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`

if [[ $speed > 0 && $speed < 1 ]]; then
   speed="| 0bft"
elif [[ $speed > 2 && $speed < 3 ]]; then
   speed="| 1bft"
elif [[ $speed > 4 && $speed < 6 ]]; then
   speed="| 2bft"
elif [[ $speed > 7 && $speed < 10 ]]; then
   speed="| 3bft"
elif [[ $speed > 11 && $speed < 16 ]]; then
   speed="| 4bft"
elif [[ $speed > 17 && $speed < 21 ]]; then
   speed="| 5bft"
elif [[ $speed > 22 && $speed < 27 ]]; then
   speed="| 6bft"
elif [[ $speed > 28 && $speed < 33 ]]; then
   speed="| 7bft"
elif [[ $speed > 34 && $speed < 40 ]]; then
   speed="| 8bft"
elif [[ $speed > 41 && $speed < 47 ]]; then
   speed="| 9bft" 
elif [[ $speed > 48 && $speed < 55 ]]; then
   speed="10bft"  
elif [[ $speed > 56 && $speed < 63 ]]; then
   speed="| 11bft"
elif [[ $speed > 63 ]]; then
   speed="| 12bft"
else
   speed=""   
fi

chill=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=166"`
echo $chill > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
chill=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $15, $16}' | awk '{printf("%.1f\n", $3)}' | sed 's/\"//g' | sed 's/,//g'`

baro=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=165"`
echo $baro > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
baro=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $14, $15}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`

zicht=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=169"`
echo $zicht > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
zicht=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $16, $17}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`

if [ $zicht == 10.0 ]; then
zicht="Zicht:>10km\n"
else
zicht="Zicht:"`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $16, $17}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`"km\n"
fi

uv=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=167"`
echo $uv > /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt
uv=`cat /mnt/storage/domoticz_scripts/weer_tweets/weather-data.txt | awk -F: '{print $16, $17}' | awk '{print $3}' | cut -c 1-2 | sed 's/\"//g' | sed 's/,//g'`

echo -ne "#Zoutkamp |"$timestamp"u| "$rainforecast"\nTemp:"$temperature"°C | Gevoel:"$chill"°C\nVocht:"$hygro"%\nNeerslag:"$rain"mm\nWind:"$dir" "$speed"\nBaro:"$baro"hPa\n"$zicht"UV:"$uv"" > /mnt/storage/domoticz_scripts/weer_tweets/weather-tweet.txt

tweet_text="/mnt/storage/domoticz_scripts/weer_tweets/weather-tweet.txt"

if [ $(cat "$tweet_text" | wc -c) -gt 140 ]; then
   echo "Tweet niet verzonden, je hebt meer dan 140 tekens!" && exit 1
elif [ "$tweet_text" == "" ]; then
   echo "Er is niks om te tweeten!" && exit 1
fi

### tweet
sudo python /home/pi/domoticz/scripts/python/weer_tweet.py
sleep 5
exit
