#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Basic Python Plugin Example
#
# Author: Xorfor
#
"""
<plugin key="xfr_aardbeving" name="Dutch earthquakes" author="Xorfor" version="1.0.1" wikilink="https://github.com/Xorfor/Domoticz-LastDutchEarthquake-Plugin" externallink="http://www.knmi.nl/nederland-nu/seismologie/aardbevingen/laatste_beving">
    <params>
        <!--
        <param field="Address" label="IP Address" width="200px" required="true" default="127.0.0.1"/>
        <param field="Port" label="Port" width="30px" required="true" default="80"/>
        -->
        <param field="Mode6" label="Debug" width="75px">
            <options>
                <option label="True" value="Debug"/>
                <option label="False" value="Normal" default="true"/>
            </options>
        </param>
    </params>
</plugin>
"""
import Domoticz
import xml.etree.ElementTree as ET


class BasePlugin:

    __HEARTBEATS2MIN = 6
    __MINUTES = 10         # or use a parameter

    __UNIT_TEXT = 1

    __API_ADDRESS = "cdn.knmi.nl"
    __API_PORT = "80"
    __API_URL = "/knmi/map/page/seismologie/GQuake_KNMI_RSS.xml"

    def __init__(self):
        self.__runAgain = 0
        self.__rssConn = None
        return

    def onStart(self):
        Domoticz.Debug("onStart called")
        if Parameters["Mode6"] == "Debug":
            Domoticz.Debugging(1)
        else:
            Domoticz.Debugging(0)
        # Images
        # Check if images are in database
        # if "xfr_template" not in Images:
        #     Domoticz.Image("xfr_template.zip").Create()
        # try:
        #     image = Images["xfr_template"].ID
        # except:
        #     image = 0
        # Domoticz.Debug("Image created. ID: "+str(image))
        # Validate parameters
        # Create devices
        if len(Devices) == 0:
            Domoticz.Device(Unit=self.__UNIT_TEXT, Name="Last", TypeName="Text", Used=1).Create()
        # Log config
        DumpConfigToLog()
        # Connection
        self.__rssConn = Domoticz.Connection(Name="KNMI", Transport="TCP/IP", Protocol="HTTP", Address=self.__API_ADDRESS, Port=self.__API_PORT)
        self.__rssConn.Connect()

    def onStop(self):
        Domoticz.Debug("onStop called")

    def onConnect(self, Connection, Status, Description):
        Domoticz.Debug("onConnect called")
        if (Status == 0):
            Domoticz.Debug("Connected successfully.")
            sendData = {'Verb': 'GET',
                        'URL': self.__API_URL,
                        'Headers': {'Content-Type': 'text/xml; charset=utf-8', \
                                    'Connection': 'keep-alive', \
                                    'Accept': 'Content-Type: text/html; charset=UTF-8', \
                                    'Host': self.__API_ADDRESS, \
                                    'User-Agent': 'Domoticz/1.0'}
                        }
            self.__rssConn.Send(sendData)

    def onMessage(self, Connection, Data):
        Domoticz.Debug("onMessage called")
        DumpHTTPResponseToLog(Data)
        Status = int(Data["Status"])
        if Status == 200:
            Domoticz.Debug("Good response received")
            strData = Data["Data"].decode("utf-8", "ignore")
            root = ET.fromstring(strData)
            desc = root.findtext("./channel/item[1]/description")
            Domoticz.Debug("desc: "+str(desc))
            items = desc.split(",")
            for item in items:
                if "Plaats = " in item:
                    plaats = str(item).split("=")[1].strip()
                    Domoticz.Debug("Plaats: " + plaats)
                if "Diepte = " in item:
                    diepte = str(item).split("=")[1].strip()
                    Domoticz.Debug("Diepte: " + diepte)
                if "Type = " in item:
                    type = str(item).split("=")[1].strip().lower()
                    Domoticz.Debug("Type: " + type)
                if "M = " in item:
                    m = str(item).split("=")[1].strip()
                    Domoticz.Debug("M: " + m)
                if "Lat = " in item:
                    lat = str(item).split("=")[1].strip()
                    Domoticz.Debug("Lat: " + lat)
                if "Lon = " in item:
                    lon = str(item).split("=")[1].strip()
                    Domoticz.Debug("Lon: " + lon)
            date = items[0] + " " + items[1]
            Domoticz.Debug("Date: " + date)
            txt = date + ": <a target='_blank' style='color: black;' href='https://www.google.com/maps/search/?api=1&query=" + lat + "+" + lon + "'>" + plaats + "</a><br/>" + \
                  "Magnitude: " + m + " (" + type + ")<br/>" + \
                  "Depth: " + diepte
            #UpdateDeviceName(self.__UNIT_TEXT, plaats)
            UpdateDevice(self.__UNIT_TEXT, 0, txt)
            self.__rssConn.Disconnect()
        elif Status == 302:
            Domoticz.Log("Page Moved Error.")
        elif Status == 400:
            Domoticz.Error("Bad Request Error.")
        elif Status == 500:
            Domoticz.Error("Server Error.")
        else:
            Domoticz.Error("Returned a status: "+str(Status))

    def onCommand(self, Unit, Command, Level, Hue):
        Domoticz.Debug("onCommand called for Unit " + str(Unit) + ": Parameter '" + str(Command) + "', Level: " + str(Level))

    def onNotification(self, Name, Subject, Text, Status, Priority, Sound, ImageFile):
        Domoticz.Debug("Notification: " + Name + "," + Subject + "," + Text + "," + Status + "," +
                       str(Priority) + "," + Sound + "," + ImageFile)

    def onDisconnect(self, Connection):
        Domoticz.Debug("onDisconnect called")

    def onHeartbeat(self):
        Domoticz.Debug("onHeartbeat called")
        self.__runAgain -= 1
        # Execute your command
        if self.__rssConn.Connecting():
            Domoticz.Debug("onHeartbeat called, Connecting.")
        elif self.__rssConn.Connected():
            Domoticz.Debug("onHeartbeat called, Connection is alive.")
        else:
            if self.__runAgain <= 0:
                Domoticz.Debug("onHeartbeat called, Reconnect.")
                self.__runAgain = self.__HEARTBEATS2MIN * self.__MINUTES
                self.__rssConn.Connect()
        Domoticz.Debug("onHeartbeat called, run again in " + str(self.__runAgain) + " heartbeats.")


global _plugin
_plugin = BasePlugin()

def onStart():
    global _plugin
    _plugin.onStart()

def onStop():
    global _plugin
    _plugin.onStop()

def onConnect(Connection, Status, Description):
    global _plugin
    _plugin.onConnect(Connection, Status, Description)

def onMessage(Connection, Data):
    global _plugin
    _plugin.onMessage(Connection, Data)

def onCommand(Unit, Command, Level, Hue):
    global _plugin
    _plugin.onCommand(Unit, Command, Level, Hue)

def onNotification(Name, Subject, Text, Status, Priority, Sound, ImageFile):
    global _plugin
    _plugin.onNotification(Name, Subject, Text, Status, Priority, Sound, ImageFile)

def onDisconnect(Connection):
    global _plugin
    _plugin.onDisconnect(Connection)

def onHeartbeat():
    global _plugin
    _plugin.onHeartbeat()

################################################################################
# Generic helper functions
################################################################################
def DumpConfigToLog():
    # Show parameters
    Domoticz.Debug("Parameters count.....: " + str(len(Parameters)))
    for x in Parameters:
        if Parameters[x] != "":
           Domoticz.Debug("Parameter '" + x + "'...: '" + str(Parameters[x]) + "'")
    # Show settings
        Domoticz.Debug("Settings count...: " + str(len(Settings)))
    for x in Settings:
       Domoticz.Debug("Setting '" + x + "'..: '" + str(Settings[x]) + "'")
    # Show images
    Domoticz.Debug("Image count..........: " + str(len(Images)))
    for x in Images:
        Domoticz.Debug("Image '" + x + "'...: '" + str(Images[x]) + "'")
    # Show devices
    Domoticz.Debug("Device count.........: " + str(len(Devices)))
    for x in Devices:
        Domoticz.Debug("Device...............: " + str(x) + " - " + str(Devices[x]))
        Domoticz.Debug("Device Idx...........: " + str(Devices[x].ID))
        Domoticz.Debug("Device Type..........: " + str(Devices[x].Type) + " / " + str(Devices[x].SubType))
        Domoticz.Debug("Device Name..........: '" + Devices[x].Name + "'")
        Domoticz.Debug("Device nValue........: " + str(Devices[x].nValue))
        Domoticz.Debug("Device sValue........: '" + Devices[x].sValue + "'")
        Domoticz.Debug("Device Options.......: '" + str(Devices[x].Options) + "'")
        Domoticz.Debug("Device Used..........: " + str(Devices[x].Used))
        Domoticz.Debug("Device ID............: '" + str(Devices[x].DeviceID) + "'")
        Domoticz.Debug("Device LastLevel.....: " + str(Devices[x].LastLevel))
        Domoticz.Debug("Device Image.........: " + str(Devices[x].Image))

def UpdateDevice(Unit, nValue, sValue, TimedOut=0, AlwaysUpdate=False):
    if Unit in Devices:
        if Devices[Unit].nValue != nValue or Devices[Unit].sValue != sValue or Devices[Unit].TimedOut != TimedOut or AlwaysUpdate:
            Devices[Unit].Update(nValue=nValue, sValue=str(sValue), TimedOut=TimedOut)
            Domoticz.Debug("Update " + Devices[Unit].Name + ": " + str(nValue) + " - '" + str(sValue) + "'")

def UpdateDeviceOptions(Unit, Options={}):
    if Unit in Devices:
        if Devices[Unit].Options != Options:
            Devices[Unit].Update(nValue=Devices[Unit].nValue, sValue=Devices[Unit].sValue, Options=Options)
            Domoticz.Debug("Device Options update: " + Devices[Unit].Name + " = " + str(Options))

def UpdateDeviceName(Unit, Name):
    if Unit in Devices:
        if Devices[Unit].Name != Name:
            Devices[Unit].Update(nValue=Devices[Unit].nValue, sValue=Devices[Unit].sValue, Name=Name)
            Domoticz.Debug("Device Name update: " + Devices[Unit].Name + " = " + Name)

def UpdateDeviceImage(Unit, Image):
    if Unit in Devices and Image in Images:
        if Devices[Unit].Image != Images[Image].ID:
            Devices[Unit].Update(nValue=Devices[Unit].nValue, sValue=Devices[Unit].sValue, Image=Images[Image].ID)
            Domoticz.Debug("Device Image update: " + Devices[Unit].Name + " = " + str(Images[Image].ID))

def DumpHTTPResponseToLog(httpDict):
    if isinstance(httpDict, dict):
        Domoticz.Debug("HTTP Details (" + str(len(httpDict)) + "):")
        for x in httpDict:
            if isinstance(httpDict[x], dict):
                Domoticz.Debug("....'" + x + " (" + str(len(httpDict[x])) + "):")
                for y in httpDict[x]:
                    Domoticz.Debug("........'" + y + "':'" + str(httpDict[x][y]) + "'")
            else:
                Domoticz.Debug("....'" + x + "':'" + str(httpDict[x]) + "'")
