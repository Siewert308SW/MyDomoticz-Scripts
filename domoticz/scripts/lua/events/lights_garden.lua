--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_garden.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2017
	@ Script to switch garden light ON/OFF when IsDark taking in count IsWeekend or IsNotWeekend
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]] 

--
-- **********************************************************
-- Porch lights ON when dark
-- **********************************************************
--

	if devicechanged[lux_sensor.hallway]
		and uservariables[var.garden_light_standby] == 0	
		and timebetween("16:00:00","22:44:59")
		and dark('true', 3)
		and tonumber(otherdevices[temp.veranda]) >= temp.porch_light		
		and otherdevices[porch_lights] == 'Off'
		and otherdevices[someone.home] == 'On'
		and (otherdevices[door.back] == 'Open' or otherdevices[door.garden] == 'Open')		
	then	
		commandArray[porch_lights]='On AFTER 120 REPEAT 3 INTERVAL 1'	
	end
	
--
-- **********************************************************
-- Garden lights ON when dark
-- **********************************************************
--

	if devicechanged[lux_sensor.hallway]
		and uservariables[var.garden_light_standby] == 0	
		and timebetween("16:00:00","22:44:59")
		and dark('true', 1.5)	
		and otherdevices[garden.shed_lights] == 'Off'		
	then	
		commandArray["Group:" ..group.garden_lights.. ""]='On AFTER 120 REPEAT 3 INTERVAL 20'	
	end
	
--
-- **********************************************************
-- Garden light standby ON when some one home
-- **********************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and timebetween("22:30:00","23:59:59")
		and uservariables[var.garden_light_standby] == 0	
		and otherdevices[someone.home] =='On'		
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
		and timebetween("23:00:00","23:59:59")
		and otherdevices[garden.shed_lights] ~= 'Off'
		and otherdevices[someone.home] =='Off'
		and weekend('false')		
	then	
		commandArray[porch_lights]='Off AFTER 120 REPEAT 3 INTERVAL 1'
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 3 INTERVAL 20'		
	end
	
	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 0	
		and timebetween("23:45:00","23:59:59")
		and otherdevices[garden.shed_lights] ~= 'Off'
		and otherdevices[someone.home] =='Off'
		and weekend('false')		
	then	
		commandArray[porch_lights]='Off AFTER 120 REPEAT 3 INTERVAL 1'
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 3 INTERVAL 20'		
	end

--
-- **********************************************************
-- Garden light OFF when someone at home and it's a specific and NotWeekend
-- **********************************************************
--
	
	if devicechanged[lux_sensor.living]
		and uservariables[var.garden_light_standby] == 1	
		and timebetween("23:00:00","23:59:59")
		and otherdevices[garden.shed_lights] ~= 'Off'
		and otherdevices[someone.home] =='On'
		and weekend('false')		
	then	
		commandArray[porch_lights]='Off AFTER 120 REPEAT 3 INTERVAL 1'
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 3 INTERVAL 20'		
	end	

--
-- **********************************************************
-- Garden light OFF when lux value is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.hallway]
		and dark('false', 2)
		and uservariables[var.garden_light_standby] == 1
		and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes10		
	then
		commandArray["Variable:" .. var.garden_light_standby .. ""]= '0'	
		commandArray[porch_lights]='Off AFTER 120 REPEAT 3 INTERVAL 1'
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 3 INTERVAL 20'		
	end	
	
--
-- **********************************************************
-- Garden lights OFF when Nobody at home
-- **********************************************************
--

	if devicechanged[someone.home] == 'Off'
		and uservariables[var.garden_light_standby] == 1	
		and otherdevices[garden.shed_lights] ~= 'Off'	
	then	
		commandArray[porch_lights]='Off AFTER 120 REPEAT 3 INTERVAL 1'
		commandArray["Group:" ..group.garden_lights.. ""]='Off AFTER 180 REPEAT 3 INTERVAL 20'		
	end

