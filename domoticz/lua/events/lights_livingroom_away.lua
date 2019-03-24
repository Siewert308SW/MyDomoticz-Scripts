--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom_away.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 24-03-2019
	@ Script for switching various livingroom light scenes when nobody home
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Livingroom lights ON when lux is lower then threshold
-- **********************************************************
--
	if devicechanged[lux_sensor.living] and xmasseason('false')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high
		and device_svalue(lux_sensor.living) <= 4
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes20		
		and otherdevices[light.living_standing_light] == 'Off'
		and timebetween("16:00:00","22:29:59")
		and uservariables[var.living_light_override] == 0			
    then
		commandArray["Scene:" ..scene.away.. ""]='On REPEAT 2 INTERVAL 5'
	end

--
-- **********************************************************
-- Livingroom lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('false')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) > lux_trigger.living_high
		and device_svalue(lux_sensor.living) > 4
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes20		
		and (otherdevices[light.living_standing_light] ~= 'Off'
		or uservariables[var.living_light_override] == 1)	
    then
		commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '0'
	end
	
--
-- **********************************************************
-- Livingroom lights OFF at a specific time
-- **********************************************************
--

	if devicechanged[lux_sensor.porch] and xmasseason('false')
		and otherdevices[someone.home] == 'Weg'
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes20
		and timebetween("22:30:00","23:59:59")
		and weekend('false')
		and (otherdevices[light.living_standing_light] ~= 'Off'
		or uservariables[var.living_light_override] == 1)	
    then
		commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '0'
	end
	
	if devicechanged[lux_sensor.porch] and xmasseason('false')
		and otherdevices[someone.home] == 'Weg'
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes20
		and timebetween("23:30:00","23:59:59")
		and weekend('true')
		and (otherdevices[light.living_standing_light] ~= 'Off'
		or uservariables[var.living_light_override] == 1)	
    then
		commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '0'
	end
	