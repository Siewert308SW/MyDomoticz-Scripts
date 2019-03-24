--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_corridor.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 24-03-2019
	@ Script for switching corridor light ON/OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- Corridor light ON when someone entering Corridor @ midweek
-- **********************************************************
--

	if devicechanged[motion_sensor.upstairs] == 'On'	
		and otherdevices[light.upstairs] == 'Off'
		and device_svalue(lux_sensor.porch) <= lux_trigger.hallway
		and timebetween("16:00:00","21:30:00")	
	then
		commandArray[light.upstairs]='Set Level 30'		
	end
	
	if devicechanged[motion_sensor.downstairs] == 'On'
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) > timeout.seconds30	
		and otherdevices[light.upstairs] == 'Off'	
		and device_svalue(lux_sensor.porch) <= lux_trigger.hallway
		and timebetween("16:00:00","21:30:00")		
	then
		commandArray[light.upstairs]='Set Level 30'		
	end	
	
--
-- *********************************************************************
-- Corridor light OFF when no motion for x minutes
-- *********************************************************************
--
	
	if devicechanged[lux_sensor.living]
		and (otherdevices[light.upstairs] ~='Off' or otherdevices[switch.upstairs1] =='On' or otherdevices[switch.upstairs2] =='On')
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.minutes2
		and timedifference(otherdevices_lastupdate[switch.upstairs1]) >= timeout.minutes2
		and timedifference(otherdevices_lastupdate[switch.upstairs2]) >= timeout.minutes2
		and timedifference(otherdevices_lastupdate[light.upstairs]) >= timeout.minutes2		
	then
		commandArray[light.upstairs]='Off'
		commandArray[switch.upstairs1]='Off AFTER 1'		
		commandArray[switch.upstairs2]='Off AFTER 2'		
	end	