--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ various.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2017

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- **********************************************************
-- Various Merged switches or devices used Lua globaly
-- **********************************************************
--

	motion_detected = (devicechanged[door.living] or devicechanged[door.front] or devicechanged[door.back] or devicechanged[door.garden] or devicechanged[door.scullery] or devicechanged[motion_sensor.living] == 'On' or devicechanged[window.living] or devicechanged[switch.dinner_light] == 'On' or devicechanged[switch.dinner_light] == 'On' or devicechanged[motion_sensor.dinner1] == 'On' or devicechanged[motion_sensor.dinner2] == 'On')
	
	lightswitchON = (devicechanged[switch.living_light] == 'On' or devicechanged[switch.dinner_light] == 'On')
	lightswitchOFF = (devicechanged[switch.living_light] == 'Off' or devicechanged[switch.dinner_light] == 'Off')

	doorsOPEN = (otherdevices[door.front] == 'Open' or otherdevices[door.back] == 'Open' or otherdevices[door.garden] == 'Open')
	doorsCLOSED = (otherdevices[door.front] == 'Closed' and otherdevices[door.back] == 'Closed' and otherdevices[door.garden] == 'Closed')	