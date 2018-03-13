--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-13-2018
	@ Script to switch various livingroom lighting scenes ON/OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Livingroom lights ON when lux is low and in the morning
-- **********************************************************
--

	if devicechanged[someone.home] == 'Thuis'
		and timebetween("03:00:00","11:59:59")
		and device_svalue(lux_sensor.porch) < 45	
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

	if devicechanged[someone.home] == 'Thuis'
		and device_svalue(lux_sensor.porch) < 45
		and device_svalue(lux_sensor.porch) >= 30			
		and otherdevices[light.living_standing_light] == 'Off'
		and otherdevices[light.living_twilight] == 'Off'			
		and otherdevices[light.living_wall_lights] == 'Off'
		and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","02:59:59"))		
	then
		  commandArray[light.living_standing_light]='Set Level 80 AFTER 10'
	end

-- **********************************************************

	if devicechanged[someone.home] == 'Thuis'
		and device_svalue(lux_sensor.porch) < 30
		and device_svalue(lux_sensor.porch) >= 15		
		and otherdevices[light.living_standing_light] ~= 'Off'
		and otherdevices[light.living_twilight] == 'Off'			
		and otherdevices[light.living_wall_lights] == 'Off'
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10
		and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","02:59:59"))			
	then
		  commandArray[light.living_standing_light]='Set Level 66 AFTER 10'
	end

-- **********************************************************

	if devicechanged[someone.home] == 'Thuis'
		and device_svalue(lux_sensor.porch) < 15
		and otherdevices[light.living_standing_light] ~= 'Off'
		and otherdevices[light.living_twilight] == 'Off'			
		and otherdevices[light.living_wall_lights] == 'Off'
		and otherdevices[lux_sensor.switch] == 'On'		
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10
		and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","02:59:59"))			
	then
		commandArray["Scene:" ..scene.stage_1.. ""]='On AFTER 10 REPEAT 2 INTERVAL 5'
	end
	
--
-- **********************************************************
-- Livingroom lights Off, triggered by time trigger
-- **********************************************************
--

	if (devicechanged[someone.home] == 'Off'
		or devicechanged[someone.home] == 'Weg'
		or devicechanged[someone.home] == 'Slapen') 
		and otherdevices[light.living_standing_light] ~= 'Off' 
	then
		commandArray["Scene:" ..scene.shutdown.. ""]='On AFTER 1'	
	end
	
--
-- **********************************************************
-- Livingroom lights ON when lux is low and in the morning
-- **********************************************************
--

	if devicechanged[lux_sensor.living] then
	
--
-- **********************************************************
-- Livingroom lights ON when lux is low and in the afternoon
-- **********************************************************
--	

		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(lux_sensor.porch) < 45
			and device_svalue(lux_sensor.porch) >= 30			
			and otherdevices[light.living_standing_light] == 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and timebetween("16:00:00","22:29:59")		
		then
			  commandArray[light.living_standing_light]='Set Level 66 AFTER 10'
		end

-- **********************************************************

		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(lux_sensor.porch) < 30
			and device_svalue(lux_sensor.porch) >= 15		
			and otherdevices[light.living_standing_light] ~= 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10
			and timebetween("16:00:00","22:29:59")			
		then
			  commandArray[light.living_standing_light]='Set Level 53 AFTER 10'
		end

-- **********************************************************

		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(lux_sensor.porch) < 15
			and otherdevices[light.living_standing_light] ~= 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and otherdevices[lux_sensor.switch] == 'On'			
			and media('true')
			and timebetween("16:00:00","22:29:59")		
		then
			commandArray["Scene:" ..scene.stage_1.. ""]='On AFTER 10 REPEAT 2 INTERVAL 5'
		end
	
-- **********************************************************

		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(lux_sensor.porch) < 15
			and otherdevices[light.living_standing_light] ~= 'Off'
			and otherdevices[light.living_twilight] ~= 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and otherdevices[lux_sensor.switch] == 'On'			
			and media('false')
			and timebetween("16:00:00","22:29:59")			
		then
			commandArray["Scene:" ..scene.stage_2.. ""]='On AFTER 10 REPEAT 2 INTERVAL 5'
		end
		
end
	
--
-- **********************************************************
-- Livingroom lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and otherdevices[light.living_standing_light] ~= 'Off'
		and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10		
		and device_svalue(lux_sensor.porch) >= 45	
	then
		commandArray["Scene:" ..scene.shutdown.. ""]='On AFTER 10 REPEAT 2 INTERVAL 5'
	end
	
--
-- **********************************************************
-- Livingroom light scenes
-- **********************************************************
--

	if (devicechanged[media_device.tv] == 'On'
		or devicechanged[laptop.switch] == 'On'
		or devicechanged[watt.tvcorner]
		or devicechanged[watt.siewert])	
		and otherdevices[someone.home] == 'Thuis'
		and device_svalue(lux_sensor.porch) < 15
		and otherdevices[light.living_standing_light] ~= 'Off'
		and otherdevices[light.living_twilight] == 'Off'			
		and otherdevices[light.living_wall_lights] ~= 'Off'
		and media('true')		
		and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","02:59:59"))		
	then
		commandArray["Scene:" ..scene.stage_1.. ""]='On AFTER 1 REPEAT 2 INTERVAL 5'
	end
	
-- **********************************************************

	if (devicechanged[media_device.tv] == 'Off'
		or devicechanged[laptop.switch] == 'Off'
		or devicechanged[watt.tvcorner]
		or devicechanged[watt.siewert])
		and device_svalue(lux_sensor.porch) < 15
		and otherdevices[light.living_standing_light] ~= 'Off'
		and otherdevices[light.living_twilight] == 'On'			
		and otherdevices[light.living_wall_lights] == 'Off'
		and media('false')
		and timebetween("16:00:00","22:29:59")
	then
		commandArray["Scene:" ..scene.stage_2.. ""]='On AFTER 1 REPEAT 2 INTERVAL 5'
	end