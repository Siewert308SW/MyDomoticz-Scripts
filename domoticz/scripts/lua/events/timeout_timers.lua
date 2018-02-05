--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ timeout_timers.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-4-2018
	@ Script to switch ON/OFF various devices if max timeout reached
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- *********************************************************************
-- 
-- *********************************************************************
--
	
	if devicechanged[lux_sensor.upstairs]
		and (otherdevices[light.upstairs] ~='Off' or otherdevices[switch.upstairs1] =='On' or otherdevices[switch.upstairs1] =='On')
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.minutes10
		and timedifference(otherdevices_lastupdate[switch.upstairs1]) >= timeout.minutes10
		and timedifference(otherdevices_lastupdate[switch.upstairs2]) >= timeout.minutes10
		and timedifference(otherdevices_lastupdate[light.upstairs]) >= timeout.minutes10		
	then
		commandArray[light.upstairs]='Off'
		commandArray[switch.upstairs1]='Off AFTER 1'		
		commandArray[switch.upstairs2]='Off AFTER 2'		
	end

--
-- *********************************************************************
-- 
-- *********************************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[light.shower] =='On'
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.hour1
		and timedifference(otherdevices_lastupdate[light.shower]) >= timeout.hour1	
	then
		commandArray[light.shower]='Off REPEAT 2 INTERVAL 1'		
	end
	