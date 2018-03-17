# Bluetooth Presence Detection
#
# Author: Chris Gheen @GameDevHobby
#
"""
<plugin key="BluetoothPresenceDetection" name="Bluetooth Presence Detection" author="Chris Gheen @GameDevHobby" version="0.7.0">
    <params>
	<param field="Address" label="MAC Address" width="150px" required="true"/>
        <param field="Mode5" label="Update interval (sec)" width="30px" required="true" default="30"/>
        <param field="Mode6" label="Debug" width="75px">
            <options>
                <option label="True" value="Debug"/>
                <option label="False" value="Normal" default="true" />
            </options>
        </param>
    </params>
</plugin>
"""
import Domoticz
import subprocess

class BasePlugin:
    enabled = False
    def __init__(self):
        return

    def onStart(self):
        #Domoticz.Log("onStart called")
        #global SwitchState
        if (len(Devices) == 0):
            Domoticz.Device(Name="Bluetooth", Unit=1, Type=17, Switchtype=0).Create()
            Domoticz.Log("Devices created.")
        #else:
            #if (1 in Devices): SwitchState = Devices[1].nValue
            #for i in Devices:
        
        if Parameters["Mode6"] == "Debug": 
            self.debug = True
            Domoticz.Debugging(1)                
            DumpConfigToLog()

        updateInterval = int(Parameters["Mode5"])
        
        if updateInterval < 60:
            if updateInterval < 10: updateInterval == 10
            Domoticz.Log("Update interval set to " + str(updateInterval) + " (minimum is 10 seconds)")
            Domoticz.Heartbeat(updateInterval)
        else:
            Domoticz.Heartbeat(60)
        

    def onStop(self):
        #Domoticz.Log("onStop called")
        pass

    def onConnect(self, Status, Description):
        #Domoticz.Log("onConnect called")
        pass

    def onMessage(self, Data, Status, Extra):
        #Domoticz.Log("onMessage called")
        pass

    def onCommand(self, Unit, Command, Level, Hue):
        #Domoticz.Log("onCommand called for Unit " + str(Unit) + ": Parameter '" + str(Command) + "', Level: " + str(Level))
        pass

    def onNotification(self, Data):
        #Domoticz.Log("onNotification: " + str(Data))
        pass

    def onDisconnect(self):
        #Domoticz.Log("onDisconnect called")
        pass

    def onHeartbeat(self):
        #DumpConfigToLog()        
        if len(Devices) == 0:
            return

        p = subprocess.Popen(["hcitool", "name", Parameters["Address"]], stdout=subprocess.PIPE)
        out, err = p.communicate()
        
        if (out is not None):
            #Domoticz.Log("val: " + out.decode("utf-8") )
            if (out.decode("utf-8") != ""):
                UpdateDevice(1,1, "On")
                return

            UpdateDevice(1,0, "Off")
                
        if (err is not None):
            Domoticz.Log("err: " + err.decode("utf-8") )
        


global _plugin
_plugin = BasePlugin()

def onStart():
    global _plugin
    _plugin.onStart()

def onStop():
    global _plugin
    _plugin.onStop()

def onConnect(Status, Description):
    global _plugin
    _plugin.onConnect(Status, Description)

def onMessage(Data, Status, Extra):
    global _plugin
    _plugin.onMessage(Data, Status, Extra)

def onCommand(Unit, Command, Level, Hue):
    global _plugin
    _plugin.onCommand(Unit, Command, Level, Hue)

def onNotification(Data):
    global _plugin
    _plugin.onNotification(Data)

def onDisconnect():
    global _plugin
    _plugin.onDisconnect()

def onHeartbeat():
    global _plugin
    _plugin.onHeartbeat()

    # Generic helper functions
def DumpConfigToLog():
    for x in Parameters:
        if Parameters[x] != "":
            Domoticz.Log( "'" + x + "':'" + str(Parameters[x]) + "'")
    Domoticz.Log("Device count: " + str(len(Devices)))
    for x in Devices:
        Domoticz.Log("Device:           " + str(x) + " - " + str(Devices[x]))
        Domoticz.Log("Device ID:       '" + str(Devices[x].ID) + "'")
        Domoticz.Log("Device Name:     '" + Devices[x].Name + "'")
        Domoticz.Log("Device nValue:    " + str(Devices[x].nValue))
        Domoticz.Log("Device sValue:   '" + Devices[x].sValue + "'")
        Domoticz.Log("Device LastLevel: " + str(Devices[x].LastLevel))
    return


def UpdateDevice(Unit, nValue, sValue):
	# Make sure that the Domoticz device still exists (they can be deleted) before updating it 
	if (Unit in Devices):
		if (Devices[Unit].nValue != nValue) or (Devices[Unit].sValue != sValue):
			Devices[Unit].Update(nValue, str(sValue))
			Domoticz.Log("Update "+str(nValue)+":'"+str(sValue)+"' ("+Devices[Unit].Name+")")
	return

