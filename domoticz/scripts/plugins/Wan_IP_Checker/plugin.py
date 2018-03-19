
# WAN IP Checker
#
# Author: ycahome, 2017
#
#  version 1.2.0 (2018-02-01): Bug Fixes, error handling and timeout on urlopen
#          1.2.2             : Added check for http:// or https:// on the "Check My IP URL" field.
#                            : Added notification check on Debug mode every 5 minutes
#                            : Bug Fixes
#          1.2.3             : "localhost" to "127.0.0.1"
#          1.2.4             : Limit notifications to email
#          1.2.5             : 
#
#
#
"""
<plugin key="WAN-IP-CHECKER" name="Wan IP Checker" author="ycahome" version="1.2.5" externallink="https://www.domoticz.com/forum/viewtopic.php?t=16266">
    <description>
		<h2>Wan IP Checker v.1.2.5</h2><br/>
    </description>
    <params>
        <param field="Address" label="Check My IP URL" width="200px" required="true" default="https://4.ifcfg.me/ip"/>
        <param field="Mode1" label="Check Interval(seconds)" width="75px" required="true" default="60"/>
        <param field="Mode3" label="Notifications" width="75px">
            <options>
                <option label="Notify" value="Notify"/>
                <option label="Disable" value="Disable"  default="true" />
            </options>
        </param>
         <param field="Mode6" label="Debug" width="75px">
            <options>
                <option label="True" value="Debug"/>
                <option label="False" value="Normal"  default="true" />
            </options>
        </param>
    </params>
</plugin>
"""

import Domoticz
import hmac
import hashlib
import time
import urllib
import urllib.request
import urllib.error

#from urllib2 import urlopen
from datetime import datetime, timedelta


class BasePlugin:
    enabled = False
    pluginState = "Not Ready"
    sessionCookie = ""
    privateKey = b""
    socketOn = "FALSE"

    def __init__(self):
        self.debug = False
        self.error = False
        self.nextpoll = datetime.now()
        self.pollinterval = 60  #Time in seconds between two polls
        return

    def onStart(self):

        Domoticz.Debug("onStart called")
        self.pollinterval = int(Parameters["Mode1"])  #Time in seconds between two polls

        if Parameters["Mode6"] == 'Debug':
            self.debug = True
            Domoticz.Debugging(1)
            DumpConfigToLog()
        else:
            Domoticz.Debugging(0)


        #if 'wanipaddress' not in Images: Domoticz.Image('wanipaddress.zip').Create()

        #Domoticz.Debug("Number of icons loaded = " + str(len(Images)))
        #for image in Images:
        #    Domoticz.Debug("Icon " + str(Images[image].ID) + " " + Images[image].Name)


        # create the mandatory child device if it does not yet exist
        if 1 not in Devices:
            Domoticz.Device(Name="WAN IP Alert", Unit=1, TypeName="Alert", Used=1).Create()
             #Domoticz.Device(Name="WAN IP 1", Unit=1, TypeName="Text", Used=1).Create()
            Domoticz.Log("Device created.")

        Domoticz.Heartbeat(int(Parameters["Mode1"]))


    def onStop(self):
        Domoticz.Log("Plugin is stopping.")
        Domoticz.Debugging(0)

    def onHeartbeat(self):

        Domoticz.Debug("onHeartbeat called")

        if Devices[1].nValue == 2:
            Domoticz.Log("Reverting WAN IP Change status to normal.")
            Devices[1].Update(nValue=1,sValue=Devices[1].sValue)

        url = Parameters["Address"]

        if mid(url,0,7)!= "http://" and mid(url,0,8)!= "https://"  :
         Domoticz.Error("Check my IP URL Prefix is wrong: 'http://' or 'https://' required.")
         return

        try:
          response = urllib.request.urlopen(url, timeout = 30).read()
        except urllib.error.URLError as err0:
          Domoticz.Error("URL Request error: " + str(err0) + " URL: " + url)
          response =  ""
        except urllib.error.HTTPError as err01:
          Domoticz.Error("HTTP Request error: " + str(err01) + " URL: " + url)
          response =  ""
        else:
          WANip = str(response,'utf-8')
          WANip = WANip.strip(' \t\n\r')

          if WANip != "" and len(WANip)<16:
            Domoticz.Debug("IP Discovery Site's response len is:"+ str(len(WANip)))
            Domoticz.Debug("WAN IP retrieved:" + WANip)
            CurWANip = Devices[1].sValue
            CurWANip = CurWANip.strip(' \t\n\r')
            Domoticz.Debug("Previous WAN IP:" + CurWANip)

            CurMin = str(datetime.now().minute)
            if len(CurMin) == 1: CurMin = "0" + CurMin

            if Parameters["Mode6"] == 'Debug' and (mid(CurMin,1,1) == "3" or  mid(CurMin,1,1) == "5" or  mid(CurMin,1,1) == "0"):
              Domoticz.Error("Debug is on. Trigering IP Change:")
              CurWANip = "0.0.0.0"

            if  CurWANip != WANip:
              Domoticz.Log("WAN IP Updated to:" + WANip)
              #Devices[1].Update(2,WANip)
              Devices[1].Update(2,WANip)
              if Parameters["Mode3"] == 'Notify':
                Domoticz.Log("Running WAN IP Notifications")
                Domoticz.Debug("WAN IP retrieved:" + WANip)

                ServerURL = "http://127.0.0.1:8080/json.htm?param=sendnotification&type=command"
                Domoticz.Debug("ConstructedURL ServerURL is:" + ServerURL)

                MailDetailsURL = "&subject=WAN-IP-Changed&body=" + WANip + "&subsystem=email"


                notificationURL = ServerURL + MailDetailsURL
                Domoticz.Debug("ConstructedURL is:" + notificationURL)
                try:
                  response = urllib.request.urlopen(notificationURL, timeout = 30).read()
                except urllib.error.HTTPError as err1:
                  Domoticz.Error("HTTP Request error: " + str(err1) + " URL: " + notificationURL)
                return
                Domoticz.Debug("Notification URL is :" + str(notificationURL))
            else:
              Domoticz.Log("WAN IP the same. Skipping")

            #Devices[1].Update(1,WANip, Images["wanipaddress"].ID)
          else:
            Domoticz.Error("IP Discovery Site's response not valid")





global _plugin
_plugin = BasePlugin()

def onStart():
    global _plugin
    _plugin.onStart()

def onStop():
    global _plugin
    _plugin.onStop()

def onHeartbeat():
    global _plugin
    _plugin.onHeartbeat()


# Generic helper functions
def DumpConfigToLog():
    for x in Parameters:
        if Parameters[x] != "":
            Domoticz.Debug( "'" + x + "':'" + str(Parameters[x]) + "'")
    Domoticz.Debug("Device count: " + str(len(Devices)))
    for x in Devices:
        Domoticz.Debug("Device:           " + str(x) + " - " + str(Devices[x]))
        Domoticz.Debug("Device ID:       '" + str(Devices[x].ID) + "'")
        Domoticz.Debug("Device Name:     '" + Devices[x].Name + "'")
        Domoticz.Debug("Device nValue:    " + str(Devices[x].nValue))
        Domoticz.Debug("Device sValue:   '" + Devices[x].sValue + "'")
    return


#
# Parse an int and return None if no int is given
#

def parseIntValue(s):

        try:
            return int(s)
        except:
            return None


def mid(s, offset, amount):
    return s[offset:offset+amount]



