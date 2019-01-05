--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_kitchen_cabinet.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 01-01-2019
	@ Script for switching kitchen cabinet lights ON/OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Kitchen cabinet lights ON when motion detected
-- **********************************************************
--

	if devicechanged[motion_sensor.kitchen] == 'On'
		and otherdevices[light.kitchen_cabinet1] == 'Off'
		and otherdevices[light.kitchen_cabinet2] == 'Off'
		and otherdevices[someone.home] == 'Thuis'		
		and powerusage(watt.hood) >= watt.hood_low	
	then
		commandArray[light.kitchen_cabinet1]='On'
		commandArray[light.kitchen_cabinet2]='On AFTER 1'	
	end
	
	if devicechanged[motion_sensor.kitchen] == 'On'
		and otherdevices[light.kitchen_cabinet1] == 'Off'
		and otherdevices[light.kitchen_cabinet2] == 'Off'
		and otherdevices[someone.home] == 'Thuis'	
		and timedifference(otherdevices_lastupdate[light.kitchen_cabinet1]) >= timeout.seconds30
		and timedifference(otherdevices_lastupdate[light.kitchen_cabinet2]) >= timeout.seconds30
		and powerusage(watt.hood) < watt.hood_low
		and otherdevices[phone.jerina] == 'Off'
		and otherdevices[phone.natalya] == 'Off'
	then
		commandArray[light.kitchen_cabinet1]='On'		
	end	

--
-- **********************************************************
-- Kitchen cabinet lights OFF when nomotion for x minutes
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and (otherdevices[light.kitchen_cabinet1] == 'On' or otherdevices[light.kitchen_cabinet2] == 'On')
	then

		if timedifference(otherdevices_lastupdate[motion_sensor.kitchen]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[light.kitchen_cabinet1]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[light.kitchen_cabinet2]) >= timeout.minutes5
			and otherdevices[motion_sensor.kitchen] == 'Off'		
			and powerusage(watt.hood) >= watt.hood_low
			and powerusage(watt.hood) < watt.hood_high			
		then
			commandArray[light.kitchen_cabinet1]='Off'
			commandArray[light.kitchen_cabinet2]='Off AFTER 1'	
		end

		if timedifference(otherdevices_lastupdate[motion_sensor.kitchen]) >= timeout.minute1
			and timedifference(otherdevices_lastupdate[light.kitchen_cabinet1]) >= timeout.minute1
			and timedifference(otherdevices_lastupdate[light.kitchen_cabinet2]) >= timeout.minute1
			and otherdevices[motion_sensor.kitchen] == 'Off'		
			and powerusage(watt.hood) < watt.hood_low	
		then
			commandArray[light.kitchen_cabinet1]='Off'
			commandArray[light.kitchen_cabinet2]='Off AFTER 1'	
		end
	end		
		