--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom_away.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 19-01-2019
	@ Script for switching various livingroom light scenes when nobody home
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- ********************************************************************************************************************
-- Non XMAS version
-- ********************************************************************************************************************
--
	
--
-- **********************************************************
-- Livingroom lights ON when lux is lower then threshold
-- **********************************************************
--
	if devicechanged[lux_sensor.living] and xmasseason('false')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high	
    then
	
		if device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
			and otherdevices[light.living_standing_light] == 'Off'
			and otherdevices[light.living_deco_light] == 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","03:59:59"))
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes5
			and uservariables[var.living_light_override] == 0
		then
			commandArray[light.living_standing_light]='Set Level 66'
		end
		
-- **********************************************************

		if device_svalue(lux_sensor.porch) <= lux_trigger.living_high			
			and otherdevices[light.living_standing_light] ~= 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and otherdevices[light.living_deco_light] == 'Off'
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes20				
			and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","03:59:59"))
			and uservariables[var.living_light_override] == 0
		then
			commandArray["Scene:" ..scene.away.. ""]='On REPEAT 2 INTERVAL 5'
		end
	end

--
-- **********************************************************
-- Livingroom lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('false')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) > lux_trigger.living_high
		and (otherdevices[light.living_standing_light] ~= 'Off' or uservariables[var.living_light_override] == 1)		
    then
		
		if timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes5		
			and device_svalue(lux_sensor.porch) > lux_trigger.living_high		
			and (otherdevices[light.living_twilight_tv] ~= 'Off'
			or otherdevices[light.living_twilight] ~= 'Off'
			or otherdevices[light.living_deco_light] ~= 'Off'
			or otherdevices[light.living_wall_lights] ~= 'Off'
			or otherdevices[light.living_standing_light] ~= 'Off'
			or uservariables[var.living_light_override] == 1)		
		then
			commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
			commandArray["Variable:" .. var.living_light_override .. ""]= '0'	
		end
		
	end
	
--
-- ********************************************************************************************************************
-- XMAS version
-- ********************************************************************************************************************
--

--
-- **********************************************************
-- Livingroom lights ON when lux is lower then threshold
-- **********************************************************
--
	if devicechanged[lux_sensor.living] and xmasseason('true')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high	
    then
	
		if device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
			and otherdevices[light.living_standing_light] == 'Off'
			and otherdevices[light.living_deco_light] == 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","03:59:59"))
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes5
			and uservariables[var.living_light_override] == 0
		then
			commandArray[light.living_standing_light]='Set Level 66'
		end
		
-- **********************************************************

		if device_svalue(lux_sensor.porch) <= lux_trigger.living_high			
			and otherdevices[light.living_standing_light] ~= 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and otherdevices[light.living_deco_light] == 'Off'
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes20				
			and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","03:59:59"))
			and uservariables[var.living_light_override] == 0
		then
			commandArray["Scene:" ..scene.away_xmas.. ""]='On REPEAT 2 INTERVAL 5'
		end
	end

--
-- **********************************************************
-- Livingroom lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('true')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) > lux_trigger.living_high
		and (otherdevices[light.living_standing_light] ~= 'Off' or uservariables[var.living_light_override] == 1)		
    then
		
		if timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes5		
			and device_svalue(lux_sensor.porch) > lux_trigger.living_high		
			and (otherdevices[light.living_twilight_tv] ~= 'Off'
			or otherdevices[light.living_twilight] ~= 'Off'
			or otherdevices[light.living_deco_light] ~= 'Off'
			or otherdevices[light.living_wall_lights] ~= 'Off'
			or otherdevices[light.living_standing_light] ~= 'Off'
			or uservariables[var.living_light_override] == 1)		
		then
			commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
			commandArray["Variable:" .. var.living_light_override .. ""]= '0'	
		end
		
	end