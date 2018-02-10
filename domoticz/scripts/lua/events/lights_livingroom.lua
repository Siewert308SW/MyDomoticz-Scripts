--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-10-2018
	@ Script to switch various livingroom lighting scenes ON/OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Livingroom various light scenes lux is lower then threshold
-- **********************************************************
--

	if devicechanged[someone.home] == 'Thuis'
		and timebetween("00:00:00","11:59:59")
		and dark('true', 15)	
		and otherdevices[light.living_standing_light] == 'Off'
		and otherdevices[light.living_twilight] == 'Off'			
		and otherdevices[light.living_wall_lights] == 'Off'
	then
		  commandArray[light.living_standing_light]='Set Level 20'
	end

	if devicechanged[someone.home] == 'Thuis'
		and timebetween("16:00:00","23:59:59")
		and dark('true', 5)
		and otherdevices[light.living_standing_light] == 'Off'
		and otherdevices[light.living_twilight] == 'Off'			
		and otherdevices[light.living_wall_lights] == 'Off'		
	then
		commandArray["Scene:" ..scene.stage_2.. ""]='On REPEAT 2 INTERVAL 5'
	end
	
--
-- **********************************************************
-- Livingroom lights Off, triggered by time trigger
-- **********************************************************
--

	if (devicechanged[someone.home] == 'Off' or devicechanged[someone.home] == 'Weg' or devicechanged[someone.home] == 'Slapen') and otherdevices[light.living_standing_light] ~= 'Off' then
		commandArray["Scene:" ..scene.shutdown.. ""]='On'
		commandArray["Scene:" ..scene.away_shutdown.. ""]='On AFTER 5'		
	end
	
--
-- **********************************************************
-- Livingroom lights ON when lux is low and in the morning
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Thuis'
		and timebetween("00:00:00","11:59:59")
		and dark('true', 5)	
		and otherdevices[light.living_standing_light] == 'Off'
		and otherdevices[light.living_twilight] == 'Off'			
		and otherdevices[light.living_wall_lights] == 'Off'	
	then
		  commandArray[light.living_standing_light]='Set Level 20 AFTER 10'
	end

--
-- **********************************************************
-- Livingroom lights ON when lux is low and in the afternoon
-- **********************************************************
--	

	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Thuis'
		and timebetween("16:00:00","23:59:59")
		and dark('true', 15)
		and otherdevices[light.living_standing_light] == 'Off'
		and otherdevices[light.living_twilight] == 'Off'			
		and otherdevices[light.living_wall_lights] == 'Off'	
	then
		  commandArray[light.living_standing_light]='Set Level 66 AFTER 10'
	end

-- **********************************************************

	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Thuis'
		and timebetween("16:00:00","23:59:59")
		and dark('true', 5)
		and otherdevices[light.living_standing_light] ~= 'Off'
		and otherdevices[light.living_twilight] == 'Off'			
		and otherdevices[light.living_wall_lights] == 'Off'			
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10
	then
		commandArray["Scene:" ..scene.stage_2.. ""]='On AFTER 10 REPEAT 2 INTERVAL 5'
	end
--
-- **********************************************************
-- Livingroom lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and otherdevices[light.living_standing_light] ~= 'Off'
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10		
		and dark('false', 5)		
	then
		commandArray["Scene:" ..scene.shutdown.. ""]='On AFTER 10 REPEAT 2 INTERVAL 5'
	end

--
-- **********************************************************
-- Livingroom lights override OFF when lux is higher then threshold
-- **********************************************************
--
	
	if devicechanged[lux_sensor.living]
		and uservariables[var.living_light_override] ~= 0	
		and dark('false', 5)		
	then
		commandArray["Variable:" .. var.living_light_override .. ""]= '0'
	end	