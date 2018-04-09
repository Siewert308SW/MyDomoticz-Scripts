--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_garden.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 4-9-2018
	@ Script to switch garden light ON/OFF when IsDark or motion, taking in count IsWeekend or IsNotWeekend
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]	
	
--
-- **********************************************************
-- Garden party lights ON/OFF when lux threshold is high or low
-- **********************************************************
--

		if devicechanged[lux_sensor.hallway]	
			and otherdevices[garden.party_lights] == 'Off'
			and device_svalue(lux_sensor.porch) <= 15			
			and timebetween("16:00:00","22:59:59")
			and (otherdevices[door.garden] == 'Open'
			or otherdevices[door.back] == 'Open'
			or timedifference(otherdevices_lastupdate[motion_sensor.porch]) < timeout.minutes5)			
		then
			commandArray[garden.party_lights]='On AFTER 120 REPEAT 3 INTERVAL 2'	
		end

		if devicechanged[lux_sensor.hallway]	
			and otherdevices[garden.party_lights] == 'On'
			and device_svalue(lux_sensor.porch) > 20		
		then
			commandArray[garden.party_lights]='Off AFTER 120 REPEAT 3 INTERVAL 2'	
		end

		if devicechanged[lux_sensor.hallway]	
			and otherdevices[garden.party_lights] ~= 'Off'
			and otherdevices[door.garden] == 'Closed'
			and otherdevices[door.back] == 'Closed'
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes5
			and otherdevices[someone.home] ~= 'Thuis'	
		then
			commandArray[garden.party_lights]='Off AFTER 120 REPEAT 3 INTERVAL 2'		
		end		

--
-- **********************************************************
-- Garden lights ON/OFF when lux threshold is high or low
-- **********************************************************
--
		
		if devicechanged[lux_sensor.porch]	
			and otherdevices[garden.shed_lights] == 'Off'
			and device_svalue(lux_sensor.porch) <= 5			
			and timebetween("16:00:00","22:44:59")		
		then	
			commandArray["Group:" ..group.garden_lights.. ""]='On AFTER 180 REPEAT 3 INTERVAL 20'	
		end

-- **********************************************************

		if devicechanged[lux_sensor.porch]	
			and otherdevices[garden.shed_lights] ~= 'Off'
			and device_svalue(lux_sensor.porch) >= 5
			and timebetween("00:00:00","15:59:59")				
		then	
			commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 3 INTERVAL 20'	
		end

-- **********************************************************
		
		if devicechanged[lux_sensor.porch]	
			and otherdevices[garden.shed_lights] ~= 'Off'
			and device_svalue(lux_sensor.porch) >= 10
			and timebetween("16:00:00","23:59:59")				
		then	
			commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 3 INTERVAL 20'	
		end

--
-- **********************************************************
-- Garden light OFF when somebody at home and it's a specific
-- **********************************************************
--

		if devicechanged[lux_sensor.porch]	
			and otherdevices[garden.shed_lights] ~= 'Off'
			and uservariables[var.garden_light_motion] == 0
			and weekend('false')
			and (timebetween("22:45:00","23:59:59") or timebetween("00:00:00","15:59:59"))
			and otherdevices[door.garden] == 'Closed'
			and otherdevices[door.back] == 'Closed'
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes10
			and (otherdevices[someone.home] == 'Thuis' or otherdevices[someone.home] ~= 'Thuis')		
		then
			commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 3 INTERVAL 20'		
		end	

-- **********************************************************

		if devicechanged[lux_sensor.porch]	
			and otherdevices[garden.shed_lights] ~= 'Off'
			and uservariables[var.garden_light_motion] == 0
			and weekend('true')
			and (timebetween("23:45:00","23:59:59") or timebetween("00:00:00","15:59:59"))
			and otherdevices[door.garden] == 'Closed'
			and otherdevices[door.back] == 'Closed'
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes10
			and (otherdevices[someone.home] == 'Thuis' or otherdevices[someone.home] ~= 'Thuis')			
		then
			commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 3 INTERVAL 20'		
		end
	
--
-- **********************************************************
-- Garden light ON when motion detected
-- **********************************************************
--

	if devicechanged[motion_sensor.porch] == 'On'
		and uservariables[var.garden_light_motion] == 0	
		and otherdevices[garden.shed_lights] == 'Off'
		and device_svalue(lux_sensor.porch) == 0
		and (otherdevices[someone.home] == 'Weg' or otherdevices[someone.home] == 'Slapen')			
	then
		commandArray["Variable:" .. var.garden_light_motion .. ""]= '1'	
		commandArray[garden.shed_lights]='On AFTER 1'		
	end

-- **********************************************************	

	if devicechanged[lux_sensor.hallway]
		and uservariables[var.garden_light_motion] == 1
		and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes5		
	then
		commandArray["Variable:" .. var.garden_light_motion .. ""]= '0'	
		commandArray[garden.shed_lights]='Off AFTER 1'		
	end		
