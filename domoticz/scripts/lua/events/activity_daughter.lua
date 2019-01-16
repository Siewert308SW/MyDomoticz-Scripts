--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_daughter.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 16-01-2019
	@ Script to switch ON/OFF various standbykillers in my daughter her bedroom
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
--  If standbykillers daughters bedroom ON when she arrives
-- *********************************************************************
--

	if (devicechanged[motion_sensor.natalya] == 'On' or devicechanged[phone.natalya] == 'On')
		and timebetween("06:00:00","22:29:59")
		and otherdevices[light.natalya_rgb_string]  == 'Off'
		and otherdevices[phone.natalya] == 'On'	
	then
		commandArray[light.natalya_rgb_string]='On'
		commandArray[plug.natalya_tv]='On AFTER 1'		
	end

	if devicechanged[lux_sensor.porch]
		and otherdevices[phone.natalya] == 'On'
		and otherdevices[someone.home] == 'Thuis'		
		and timebetween("06:00:00","22:29:59")
		and otherdevices[light.natalya_rgb_string]  == 'Off'
	then
		commandArray[light.natalya_rgb_string]='On'
		commandArray[plug.natalya_tv]='On AFTER 1'		
	end
	
--
-- *********************************************************************
--  
-- *********************************************************************
--

	if devicechanged[switch.natalya_reading_on] then
		commandArray[light.natalya_reading]='On'
	elseif devicechanged[switch.natalya_reading_off] then
		commandArray[light.natalya_reading]='Off'
	end	
	
	if devicechanged[switch.natalya_light_on] then
		commandArray[light.natalya_light]='On'
	elseif devicechanged[switch.natalya_light_off] then
		commandArray[light.natalya_light]='Off'
	end	
