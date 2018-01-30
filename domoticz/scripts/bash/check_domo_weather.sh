#!/bin/bash

############################################################################################################################################

### check_domo_weather.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 1-30-2018
### Script grep weather data from my own weatherstation, Domoticz WeatherUnderground and Buienradar python plugin sensors to sent to twitter
### See weer_tweet.py for tweeting this data

############################################################################################################################################
### Check if Domoticz is running, if not the exit
domoticz=`sudo service domoticz.sh status | grep Active | awk '{print $3}'`

if [[ $domoticz != "(running)" ]]
    then
	exit 1
fi	
				
### Get Timestamp
timestamp=`/bin/date +%H`

############################################################################################################################################
### Scrape forecast text from Buienradar Python Plugin
forecast=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=9"`
echo $forecast > /home/pi/domoticz/logging/weather_updates/weather-data.txt
forecast=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $33}' | awk -F ', "' '{print $1}' | sed 's/"//g'`

############################################################################################################################################
### Scrape rain forecast from Buienradar Python Plugin
rainforecasts=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=8"`
echo $rainforecasts > /home/pi/domoticz/logging/weather_updates/weather-data.txt
rainforecasts=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $33}' | awk -F ' mm/h' '{print $1}' | sed 's/"//g'`

############################################################################################################################################
### Check if there is some rain predicted if so then tweet it
if [ $rainforecasts == 0 ]; then
rainforecast="\n"
else
rainforecast="\nKomende uur kans op "$rainforecasts" mm neerslag\n"
fi

############################################################################################################################################
### Scrape temperature from Buienradar Python Plugin
temp=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=3"`
echo $temp > /home/pi/domoticz/logging/weather_updates/weather-data.txt
temp=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $57, $58}' | awk '{printf("%.1f\n", $3)}' | sed 's/\"//g' | sed 's/,//g'`

############################################################################################################################################
### Scrape chill temperature from Buienradar Python Plugin
chill=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=3"`
echo $chill > /home/pi/domoticz/logging/weather_updates/weather-data.txt
chill=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $31, $32}' | awk '{printf("%.1f\n", $3)}' | sed 's/\"//g' | sed 's/,//g'`

############################################################################################################################################
### Scrape air moisture from Buienradar Python Plugin
hygro=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=1"`
echo $hygro > /home/pi/domoticz/logging/weather_updates/weather-data.txt
hygro=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $42, $43}' | awk '{print $1}' | sed 's/\,//g'`

############################################################################################################################################
### Scrape rain day total from my Rain Sensor
rain=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=13"`
echo $rain > /home/pi/domoticz/logging/weather_updates/weather-data.txt
rain=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $49, $50}' | awk '{print $3}' | sed 's/\"//g' | sed 's/\,//g'`

############################################################################################################################################
### Scrape wind speed, direction and gust from Buienradar Python Plugin
wind=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=3"`
echo $wind > /home/pi/domoticz/logging/weather_updates/weather-data.txt
dir=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $36, $37}'  | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`
speed=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $55, $56}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`
gust=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $38, $39}' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`

############################################################################################################################################
### Check if windspeed and gusts are the same if not then tweet it
if [ $speed == $gust ]; then
gusts="\n"
else
gusts=" | Vlagen: "$gust"Bft\n"
fi

############################################################################################################################################
### Scrape hPa from Buienradar Python Plugin
baro=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=2"`
echo $baro > /home/pi/domoticz/logging/weather_updates/weather-data.txt
baro=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $33, $34}' | awk '{print $3}' | sed 's/"//g' | sed 's/,//g'`

#baroforecast=`curl "http://127.0.0.1:8080/json.htm?type=graph&sensor=temp&idx=15&range=day"`
#echo $baroforecast > /home/pi/domoticz/logging/weather_updates/weather-data.txt
#baroprev=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $171}' | awk -F ', "' '{print $1}' | sed 's/"//g'`
#barocur=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $175}' | awk -F ', "' '{print $1}' | sed 's/"//g'`

#if [ $barocur == $baroprev ]; then
#baroforecast="↔"
#elif [ $barocur -gt $baroprev ]; then
#baroforecast="↑"
#elif [ $barocur -lt $baroprev ]; then
#baroforecast="↓"
#fi

############################################################################################################################################
### Scrape visibilty from Buienradar Python Plugin
zicht=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=4"`
echo $zicht > /home/pi/domoticz/logging/weather_updates/weather-data.txt
zicht=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $58, $59}' | awk '{printf("%.1f\n", $3)}' | sed 's/\"//g' | sed 's/,//g'`

############################################################################################################################################
### Weatherunderground has an issue and there for check if more then 10km
if [ $zicht == 10.0 ]; then
zicht="Zicht: >10km\n"
else
zicht="Zicht: "`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $58, $59}' | awk '{printf("%.1f\n", $3)}' | sed 's/\"//g' | sed 's/,//g'`"km\n"
fi

############################################################################################################################################
### Scrape UV from WeatherUnderground
uv=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=12"`
echo $uv > /home/pi/domoticz/logging/weather_updates/weather-data.txt
curl "http://127.0.0.1:8080/json.htm?type=devices&rid=12"
cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $32, $33}' | awk '{print $3}' | cut -c 1-2 | sed 's/\"//g' | sed 's/,//g'
uv=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $32, $33}' | awk '{print $3}' | cut -c 1-4 | sed 's/\"//g' | sed 's/,//g'`

############################################################################################################################################
### Scrape Sunrise from Domoticz
sunrise=`curl "http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet" | grep "Sunrise" | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`

############################################################################################################################################
### Scrape Sunset from Domoticz
sunset=`curl "http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet" | grep "Sunset" | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'`

############################################################################################################################################
### Scrape thunderstrikes in a 10km radius from onweer.py virtual counter widget
thunderstrikes=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=16"`
echo $thunderstrikes > /home/pi/domoticz/logging/weather_updates/weather-data.txt
thunderstrikes=`cat /home/pi/domoticz/logging/weather_updates/weather-data.txt | awk -F: '{print $32, $33}' | awk '{print $1}' | sed 's/\"//g' | sed 's/,//g'`

############################################################################################################################################
### Past all data into text file
echo -ne "#Zoutkamp | "$timestamp":00 | Zon: ▲ "$sunrise" ▼ "$sunset"\nVoorspelling:"$forecast""$rainforecast"\nTemp: "$temp"°C | Gevoel: "$chill"°C\nWind: "$dir" "$speed"Bft"$gusts"Rel. luchtv: "$hygro"%\nNeerslag: "$rain"mm\nBaro: "$baro"hPa\nZicht: "$zicht"km\nOnweer: "$thunderstrikes" inslagen (Ø 10km)\n" > /home/pi/domoticz/logging/weather_updates/weather-tweet.txt

tweet_text="/home/pi/domoticz/logging/weather_updates/weather-tweet.txt"

############################################################################################################################################
### Check if text2tweet is larger then 280 chareters if so then remove forecast text
############################################################################################################################################
### Check if text2tweet is larger then 280 chareters if so then remove forecast text
if [ $(cat "$tweet_text" | wc -c) -gt 280 ]; then
		if [ $thunderstrikes == 0 ]; then
			echo -ne "#Zoutkamp | "$timestamp":00 | Zon: ▲ "$sunrise" ▼ "$sunset"\nVoorspelling:"$forecast""$rainforecast"\nTemp: "$temp"°C | Gevoel: "$chill"°C\nWind: "$dir" "$speed"Bft"$gusts"Rel. luchtv: "$hygro"%\nNeerslag: "$rain"mm\nBaro: "$baro"hPa\n"$zicht"UV: "$uv"\n" > /home/pi/domoticz/logging/weather_updates/weather-tweet.txt
		else
			echo -ne "#Zoutkamp | "$timestamp":00 | Zon: ▲ "$sunrise" ▼ "$sunset"\nVoorspelling:"$forecast"\n\nTemp: "$temp"°C | Gevoel: "$chill"°C\nWind: "$dir" "$speed"Bft"$gusts"Rel. luchtv: "$hygro"%\nNeerslag: "$rain"mm\nBaro: "$baro"hPa\n"$zicht"UV: "$uv"\nOnweer: "$thunderstrikes" inslagen (Ø 10km)\n" > /home/pi/domoticz/logging/weather_updates/weather-tweet.txt		
		fi
elif [ $(cat "$tweet_text" | wc -c) -lt 280 ]; then
		if [ $thunderstrikes == 0 ]; then
			echo -ne "#Zoutkamp | "$timestamp":00 | Zon: ▲ "$sunrise" ▼ "$sunset"\nVoorspelling:"$forecast""$rainforecast"\nTemp: "$temp"°C | Gevoel: "$chill"°C\nWind: "$dir" "$speed"Bft"$gusts"Rel. luchtv: "$hygro"%\nNeerslag: "$rain"mm\nBaro: "$baro"hPa\n"$zicht"UV: "$uv"\n" > /home/pi/domoticz/logging/weather_updates/weather-tweet.txt
		else
			echo -ne "#Zoutkamp | "$timestamp":00 | Zon: ▲ "$sunrise" ▼ "$sunset"\nVoorspelling:"$forecast""$rainforecast"\nTemp: "$temp"°C | Gevoel: "$chill"°C\nWind: "$dir" "$speed"Bft"$gusts"Rel. luchtv: "$hygro"%\nNeerslag: "$rain"mm\nBaro: "$baro"hPa\n"$zicht"UV: "$uv"\nOnweer: "$thunderstrikes" inslagen (Ø 10km)\n" > /home/pi/domoticz/logging/weather_updates/weather-tweet.txt		
		fi
elif [ "$tweet_text" == "" ]; then
		echo "Er is niks om te tweeten!" && exit 1
fi

############################################################################################################################################
### New text2tweet file
text2tweet="/home/pi/domoticz/logging/weather_updates/weather-tweet.txt"

############################################################################################################################################
### Tweet
sudo python /home/pi/domoticz/scripts/python/weer_tweet.py
#cat "$text2tweet"
