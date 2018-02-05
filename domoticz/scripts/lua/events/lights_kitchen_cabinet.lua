--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_kitchen_cabinet.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-3-2018
	@ Script for switching kitchen cabinet lights ON/OFF when someone is entering the kitchen
	@ Taking in count that the kitchen light where manually switched ON earlier
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

	if devicechanged[motion_sensor.kitchen] == 'On'
		and otherdevices[light.kitchen_cabinet1] == 'Off'
		and otherdevices[light.kitchen_cabinet2] == 'Off'
		and timebetween("16:00:00","23:59:59")		
		and powerusage(watt.hood) >= watt.hood_low
		and timedifference(otherdevices_lastupdate[light.kitchen_cabinet1]) > timeout.seconds15
		and timedifference(otherdevices_lastupdate[light.kitchen_cabinet2]) > timeout.seconds15		
	then
		commandArray[light.kitchen_cabinet1]='On'
		commandArray[light.kitchen_cabinet2]='On AFTER 1 REPEAT 2 INTERVAL 1'	
	end
	
--
-- **********************************************************
-- Kitchen cabinet lights OFF when nomotion for x minutes
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and (otherdevices[light.kitchen_cabinet1] == 'On' or otherdevices[light.kitchen_cabinet2] == 'On')
		and timedifference(otherdevices_lastupdate[motion_sensor.kitchen]) > timeout.minutes5
		and timedifference(otherdevices_lastupdate[light.kitchen_cabinet1]) > timeout.minutes5
		and timedifference(otherdevices_lastupdate[light.kitchen_cabinet2]) > timeout.minutes5		
		and powerusage(watt.hood) < watt.hood_low	
	then
		commandArray[light.kitchen_cabinet1]='Off'
		commandArray[light.kitchen_cabinet2]='Off AFTER 1 REPEAT 2 INTERVAL 1'	
	end

-- **********************************************************
	
	if devicechanged[lux_sensor.living]
		and (otherdevices[light.kitchen_cabinet1] == 'On' or otherdevices[light.kitchen_cabinet2] == 'On')
		and timedifference(otherdevices_lastupdate[motion_sensor.kitchen]) > timeout.minutes15
		and timedifference(otherdevices_lastupdate[light.kitchen_cabinet1]) > timeout.minutes15
		and timedifference(otherdevices_lastupdate[light.kitchen_cabinet2]) > timeout.minutes15	
		and powerusage(watt.hood) >= watt.hood_high	
	then
		commandArray[light.kitchen_cabinet1]='Off'
		commandArray[light.kitchen_cabinet2]='Off AFTER 1 REPEAT 2 INTERVAL 1'	
	end
	