--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_garden.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 24-03-2019
	@ Script to switch garden light ON/OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Garden lights ON when lux is lower then threshold
-- **********************************************************
--
		if devicechanged[lux_sensor.porch] and xmasseason('false')
			and otherdevices[garden.shed_lights] == 'Off'
			and device_svalue(lux_sensor.porch) <= lux_trigger.garden_high			
			and timebetween("16:00:00","22:29:59")
		then	
			commandArray["Group:" ..group.garden_lights.. ""]='On REPEAT 2 INTERVAL 20'	
		end

--
-- **********************************************************
-- Garden lights OFF when lux is higher then threshold
-- **********************************************************
--

		if devicechanged[lux_sensor.porch] and xmasseason('false')	
			and otherdevices[garden.shed_lights] ~= 'Off'
			and device_svalue(lux_sensor.porch) > lux_trigger.garden_high
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes10
		then	
			commandArray["Group:" ..group.garden_lights.. ""]='Off REPEAT 2 INTERVAL 20'	
		end

--
-- **********************************************************
-- Garden light OFF at specific times
-- **********************************************************
--
		if devicechanged[lux_sensor.porch] and xmasseason('false')	
			and otherdevices[garden.shed_lights] ~= 'Off'
			and uservariables[var.garden_light_motion] == 0
			and uservariables[var.frontgarden_light_motion] == 0			
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes10
			and weekend('false')		
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[door.back]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[door.garden]) >= timeout.minutes10
			and (timebetween("22:30:00","23:59:59")	or timebetween("00:00:00","15:59:59"))				
		then
			commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 120 REPEAT 2 INTERVAL 20'
		end
		
		if devicechanged[lux_sensor.porch] and xmasseason('false')	
			and otherdevices[garden.shed_lights] ~= 'Off'
			and uservariables[var.garden_light_motion] == 0
			and uservariables[var.frontgarden_light_motion] == 0			
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes10
			and weekend('true')		
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[door.back]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[door.garden]) >= timeout.minutes10
			and (timebetween("23:30:00","23:59:59")	or timebetween("00:00:00","15:59:59"))				
		then
			commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 120 REPEAT 2 INTERVAL 20'
		end		
		