#!/usr/bin/python

# Info on Tweepy API and installation
# http://raspi.tv/2014/tweeting-with-python-tweepy-on-the-raspberry-pi-part-2-pi-twitter-app-series

import tweepy
from datetime import datetime
from io import open

API_KEY = ''
API_SECRET = ''
ACCESS_TOKEN = ''
ACCESS_TOKEN_SECRET = ''

auth = tweepy.OAuthHandler(API_KEY, API_SECRET)
auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
api = tweepy.API(auth)

tempfile = open('/home/pi/domoticz/logging/weather_updates/weather-tweet.txt', 'rb')
thetext = tempfile.read().decode('utf8', 'ignore')
		  
tempfile.close()

api.update_status(thetext)
