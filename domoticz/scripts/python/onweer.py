#!/usr/bin/env python
# -*- coding: utf-8 -*-
#####################################################
# Following libraries in python are needed : json, yaml,math,time,requests
# This script will load an external json file that contact for europe the lightning information and will send it to Domoticz when it's
# insde the distance range
# Many thanks to Ignacio for helping ;-).
#
# How to use:
# 1) made an dummy counter inside Domoticz and set the idx into this script "deviceIdx"
# 2) You cen set the GPS location where to calculate with manual otherwise the script try to receive this info from the settings page inside Domoticz
# 3) Set the distance range in km where to calculate with.
# 4) Run this script on the way you like, as service or cronjob, etc.
#
# Accuracy is quite good and is sometimes lower than 1 kilometer. This is equal to commercial stroke detection companies. But you can not use this info for protection of life and property!
#
#####################################################

import math
import requests
import json
import os
from datetime import datetime

# Domoticz server settings
server = "http://127.0.0.1"
port = 8080
deviceIdx = "16"

# Location to import the lightning info
jsonUrl = "http://www.onweeractueel.nl/domoticz_bo.json"

# GPS location and distance to calculate
latHome = 00.000000
lngHome = 0.000000
distanceRange = 10  # Distance in km

# Try to get GPS location from domoticz
try:
    data = json.loads(
        requests.get(
            "%s:%d/json.htm?type=settings" %
            (server, port)).content)
    latHome = float(data['Location']['Latitude'])
    lngHome = float(data['Location']['Longitude'])
except:
    pass


# Location distance calculation

def distance(lat1, lng1, lat2, lng2):
    radius = 6371

    dLat = (lat2 - lat1) * math.pi / 180
    dLng = (lng2 - lng1) * math.pi / 180

    lat1 = lat1 * math.pi / 180
    lat2 = lat2 * math.pi / 180

    val = math.sin(dLat / 2) * math.sin(dLat / 2) + math.sin(dLng / 2) * \
        math.sin(dLng / 2) * math.cos(lat1) * math.cos(lat2)
    ang = 2 * math.atan2(math.sqrt(val), math.sqrt(1 - val))
    return radius * ang

last = 0
if os.path.exists("/tmp/last_lightning.txt"):
    f = open("/tmp/last_lightning.txt")
    last = int(f.read())
    f.close()

z = requests.get(jsonUrl)
data = json.loads(z.content)
value = 0
ignored = 0
for pos in data:
    time_, lat, lng = pos
    distanceBetween = distance(latHome, lngHome, lat, lng)
    if (distanceBetween <= distanceRange):
        if (time_ > last):
            value += 1
        else:
            ignored += 1

f = open("/tmp/last_lightning.txt", "w")
f.write(str(time_))
f.close()

print ("Found %d matches -- %s" %
       (value, datetime.strftime(datetime.now(), "%c")))
print ("%d old matches were ignored -- %s" %
       (ignored, datetime.strftime(datetime.now(), "%c")))

requests.get(
    "%s:%d/json.htm?type=command&param=udevice&idx=%s&svalue=%d" %
    (server, port, deviceIdx, value))