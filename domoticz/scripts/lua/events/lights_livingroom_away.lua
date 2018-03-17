--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom_away.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-17-2018
	@ Script to switch ON/OFF Away light scene when nobody at home
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Turn ON Away Scene when nobody at home and IsDark
-- **********************************************************
--

	if devicechanged[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) < 10		
		and otherdevices[light.living_standing_light] == 'Off'
		and otherdevices[light.living_twilight_tv] == 'Off'
		and otherdevices[lux_sensor.switch] == 'On'		
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes3
		and timebetween("16:00:00","22:29:59")	
	then
		commandArray["Scene:" ..scene.stage_away.. ""]='On AFTER 1 REPEAT 2 INTERVAL 5'
	end
	
	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) < 10
		and otherdevices[light.living_standing_light] == 'Off'
		and otherdevices[light.living_twilight_tv] == 'Off'
		and otherdevices[lux_sensor.switch] == 'On'		
		and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.minutes3
		and timebetween("16:00:00","22:29:59")	
	then
		commandArray["Scene:" ..scene.stage_away.. ""]='On AFTER 1 REPEAT 2 INTERVAL 5'
	end

--
-- **********************************************************
-- Turn OFF Away Scene when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and otherdevices[light.living_twilight_tv] ~= 'Off'
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10		
		and device_svalue(lux_sensor.porch) >= 60	
	then
		commandArray["Scene:" ..scene.shutdown.. ""]='On AFTER 10 REPEAT 2 INTERVAL 5'
	end

--
-- **********************************************************
-- Turn OFF Away Scene when it's time
-- **********************************************************
--

	if devicechanged[lux_sensor.living] then
		if otherdevices[light.living_twilight_tv] ~= 'Off'
			and otherdevices[someone.home] == 'Weg'		
			and timebetween("23:00:00","23:59:00")
			and weekend('false')		
		then
			commandArray["Scene:" ..scene.shutdown.. ""]='On AFTER 10 REPEAT 2 INTERVAL 5'		
		end
	
		if otherdevices[light.living_twilight_tv] ~= 'Off'
			and otherdevices[someone.home] == 'Weg'		
			and timebetween("23:45:00","23:59:00")
			and weekend('true')		
		then
			commandArray["Scene:" ..scene.shutdown.. ""]='On AFTER 10 REPEAT 2 INTERVAL 5'		
		end
	end	