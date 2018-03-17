#!/usr/bin/env python3
#
#   Buienradar.nl Weather Lookup Plugin
#
#   Frank Fesevur, 2017
#   https://github.com/ffes/domoticz-buienradar
#
#   About the weather service:
#   https://www.buienradar.nl/overbuienradar/gratis-weerdata
#

import os
from buienradar import Buienradar

interval = 10
# Den Haag
lat_dh = 52.095556
lon_dh = 4.316389
# Maastricht
lat_mt = 50.849722
lon_mt = 5.693056
# Schiermonnikoog
lat_so = 53.489167
lon_so = 6.202222
# Cadzand (Zeeuws Vlaanderen)
lat_cd = 51.367778
lon_cd = 3.408056
# Berlijn
lat_be = 52.516667
lon_be = 13.416667

x = Buienradar(lat_so, lon_so, interval)

xmlFile = './buienradar.xml'

if os.path.isfile(xmlFile):
    x.getBuienradarXML(file = xmlFile)
else:
    x.getBuienradarXML()

x.getNearbyWeatherStation()

x.getWeather()
