--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_garden.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-5-2018
	@ Script to switch garden light ON/OFF when IsDark or motion, taking in count IsWeekend or IsNotWeekend
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Porch lights ON/OFF
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 0
		and dark('true', 5)
		and tonumber(otherdevices[temp.veranda]) >= temp.porch_light		
		and otherdevices[garden.porch_lights] == 'Off'
		and otherdevices[door.garden] == 'Open'	
	then	
		commandArray[garden.porch_lights]='On AFTER 1 REPEAT 3 INTERVAL 3'	
	end
	
	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 0
		and dark('false', 5)		
		and otherdevices[garden.porch_lights] ~= 'Off'
		and otherdevices[door.garden] == 'Closed'	
	then	
		commandArray[garden.porch_lights]='Off AFTER 1 REPEAT 3 INTERVAL 3'	
	end	
	
--
-- **********************************************************
-- Garden lights ON/OFF
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 0	
		and timebetween("16:00:00","22:59:59")
		and dark('true', 1)	
		and otherdevices[garden.shed_lights] == 'Off'		
	then	
		commandArray["Group:" ..group.garden_lights.. ""]='On AFTER 1 REPEAT 3 INTERVAL 20'	
	end
	
	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 1
		and dark('false', 5)	
		and otherdevices[garden.shed_lights] == 'Off'		
	then
		commandArray["Variable:" .. var.garden_light_standby .. ""]= '0'	
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 1 REPEAT 3 INTERVAL 20'	
	end

	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 0
		and dark('false', 5)	
		and otherdevices[garden.shed_lights] ~= 'Off'		
	then	
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 1 REPEAT 3 INTERVAL 20'	
	end		
	
--
-- **********************************************************
-- Garden light standby ON when some one home
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 0	
		and timebetween("23:00:00","23:59:59")
		and otherdevices[someone.home] =='Thuis'	
	then	
		commandArray["Variable:" .. var.garden_light_standby .. ""]= '1'		
	end	
	
--
-- **********************************************************
-- Garden light OFF when nobody at home and it's a specific
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 0
		and uservariables[var.garden_light_motion] == 0	
		and otherdevices[garden.shed_lights] ~= 'Off'
		and weekend('false')
		and (timebetween("23:00:00","23:59:59") or timebetween("00:00:00","15:59:59"))		
		and (otherdevices[someone.home] == 'Weg' or otherdevices[someone.home] == 'Slapen')	
	then	
		if otherdevices[garden.porch_lights] == 'On' then commandArray[garden.porch_lights]='Off AFTER 10 REPEAT 3 INTERVAL 3' end
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 60 REPEAT 3 INTERVAL 20'		
	end

-- **********************************************************
	
	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 0
		and uservariables[var.garden_light_motion] == 0	
		and otherdevices[garden.shed_lights] ~= 'Off'
		and weekend('true')
		and (timebetween("23:45:00","23:59:59") or timebetween("00:00:00","15:59:59"))		
		and (otherdevices[someone.home] == 'Weg' or otherdevices[someone.home] == 'Slapen')	
	then	
		if otherdevices[garden.porch_lights] == 'On' then commandArray[garden.porch_lights]='Off AFTER 10 REPEAT 3 INTERVAL 3' end
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 60 REPEAT 3 INTERVAL 20'		
	end

--
-- **********************************************************
-- Garden light OFF when someone at home and it's a specific and NotWeekend
-- **********************************************************
--
	
	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 1
		and uservariables[var.garden_light_motion] == 0	
		and otherdevices[garden.shed_lights] ~= 'Off'
		and weekend('false')
		and (timebetween("23:00:00","23:59:59") or timebetween("00:00:00","15:59:59"))		
		and (otherdevices[someone.home] == 'Thuis' or otherdevices[someone.home] == 'Weg' or otherdevices[someone.home] == 'Slapen')	
	then	
		if otherdevices[garden.porch_lights] == 'On' then commandArray[garden.porch_lights]='Off AFTER 1 REPEAT 3 INTERVAL 1' end
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 10 REPEAT 3 INTERVAL 20'		
	end
	
--
-- **********************************************************
-- Garden lights OFF when Nobody at home
-- **********************************************************
--

	if (devicechanged[someone.home] == 'Weg' or devicechanged[someone.home] == 'Slapen')
		and uservariables[var.garden_light_standby] == 1	
		and otherdevices[garden.shed_lights] == 'On'	
	then	
		if otherdevices[garden.porch_lights] == 'On' then commandArray[garden.porch_lights]='Off AFTER 120 REPEAT 3 INTERVAL 1' end
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 4 INTERVAL 20'		
	end
	
--
-- **********************************************************
-- Garden light switch double function for hallway wall lights as they aint got their own switch yet
-- **********************************************************
--

	if devicechanged[switch.garden_light] == 'On'
	and timedifference(otherdevices_lastupdate[switch.garden_light]) <= timeout.second1
	then
	commandArray[light.hallway]='On'
	end

	if devicechanged[switch.garden_light] == 'Off'
	and timedifference(otherdevices_lastupdate[switch.garden_light]) <= timeout.second1
	then
	commandArray[light.hallway]='Off'
	end

--
-- **********************************************************
-- Garden light ON when motion detected
-- **********************************************************
--

	if devicechanged[motion_sensor.porch] == 'On'
		and uservariables[var.garden_light_motion] == 0	
		and otherdevices[garden.shed_lights] == 'Off'
		and dark('true', 1)		
	then
		commandArray["Variable:" .. var.garden_light_motion .. ""]= '1'	
		commandArray[garden.shed_lights]='On REPEAT 3 INTERVAL 2'		
	end

-- **********************************************************	

	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_motion] == 1
		and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes5		
	then
		commandArray["Variable:" .. var.garden_light_motion .. ""]= '0'	
		commandArray[garden.shed_lights]='Off REPEAT 3 INTERVAL 2'		
	end	

