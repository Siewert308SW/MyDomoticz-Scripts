--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_daughter.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 24-03-2019
	@ Script to switch ON/OFF various standbykillers in my daughter her bedroom
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
--  Standbykillers daughters bedroom ON when she arrives
-- *********************************************************************
--

	if devicechanged[motion_sensor.natalya] == 'On'
		and timebetween("06:00:00","22:29:59")
		and otherdevices[plug.natalya_tv]  == 'Off'
		and otherdevices[phone.natalya] == 'On'		
	then
		commandArray[light.natalya_rgb_string]='On'
		commandArray[plug.natalya_tv]='On AFTER 1'		
	end

	if devicechanged[lux_sensor.porch]
		and otherdevices[someone.home] == 'Thuis'		
		and timebetween("08:00:00","22:29:59")
		and otherdevices[plug.natalya_tv]  == 'Off'
		and otherdevices[phone.natalya] == 'On'		
	then
		commandArray[light.natalya_rgb_string]='On'
		commandArray[plug.natalya_tv]='On AFTER 1'		
	end

--
-- *********************************************************************
--  Standbykillers daughters bedroom OFF when she away
-- *********************************************************************
--
	
	if devicechanged[lux_sensor.porch] and otherdevices[plug.natalya_tv] == 'On' then
	
	if otherdevices[plug.natalya_tv] == 'On'
		and timedifference(otherdevices_lastupdate[motion_sensor.natalya]) >= timeout.hours3
		and timedifference(otherdevices_lastupdate[phone.natalya]) >= timeout.hours3
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.hours3
		and timebetween("06:00:00","22:29:59")		
		and otherdevices[phone.natalya] == 'On'		
	then
		commandArray[light.natalya_rgb_string]='Off'
		commandArray[plug.natalya_tv]='Off AFTER 1'		
	end

	if otherdevices[plug.natalya_tv] == 'On'
		and timedifference(otherdevices_lastupdate[motion_sensor.natalya]) >= timeout.hour1
		and timedifference(otherdevices_lastupdate[phone.natalya]) >= timeout.hour1
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.hour1
		and timebetween("06:00:00","22:29:59")		
		and otherdevices[phone.natalya] == 'Off'		
	then
		commandArray[light.natalya_rgb_string]='Off'
		commandArray[plug.natalya_tv]='Off AFTER 1'		
	end		
	
	if otherdevices[plug.natalya_tv] == 'On'
		and timedifference(otherdevices_lastupdate[motion_sensor.natalya]) >= timeout.minutes15
		and timedifference(otherdevices_lastupdate[phone.natalya]) >= timeout.minutes15
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.minutes15
		and (timebetween("22:30:00","23:59:59") or timebetween("00:00:00","05:59:59"))
		and otherdevices[phone.natalya] == 'On'		
	then
		commandArray[light.natalya_rgb_string]='Off'
		commandArray[plug.natalya_tv]='Off AFTER 1'		
	end	
	
	if otherdevices[plug.natalya_tv] == 'On'
		and timedifference(otherdevices_lastupdate[motion_sensor.natalya]) >= timeout.minutes15
		and timedifference(otherdevices_lastupdate[phone.natalya]) >= timeout.minutes5
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.minutes5
		and (timebetween("22:30:00","23:59:59") or timebetween("00:00:00","05:59:59"))
		and otherdevices[phone.natalya] == 'Off'		
	then
		commandArray[light.natalya_rgb_string]='Off'
		commandArray[plug.natalya_tv]='Off AFTER 1'		
	end
	
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
