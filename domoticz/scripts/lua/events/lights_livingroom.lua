--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 01-01-2019
	@ Script for switching various livingroom light scenes
	
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

	if devicechanged[someone.home] == 'Thuis' and xmasseason('false')
		and otherdevices[light.living_standing_light] == 'Off'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high
		and uservariables[var.living_light_override] == 0
    then
		
		if device_svalue(lux_sensor.porch) <= lux_trigger.living_low
			and timebetween("04:00:00","11:59:59")		
		then
			commandArray[light.living_standing_light]='Set Level 20'
		end
		
		if device_svalue(lux_sensor.porch) > lux_trigger.living_low
			and device_svalue(lux_sensor.porch) <= lux_trigger.living_high
			and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","03:59:59"))			
		then
			commandArray[light.living_standing_light]='Set Level 66'
		end
		
		if device_svalue(lux_sensor.porch) <= lux_trigger.living_low
			and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","03:59:59"))			
		then
			commandArray["Scene:" ..scene.normal.. ""]='On REPEAT 2 INTERVAL 5'
		end
	end
	
--
-- **********************************************************
-- Livingroom lights ON when lux is lower then threshold
-- **********************************************************
--
	if devicechanged[lux_sensor.living] and xmasseason('false')
		and otherdevices[someone.home] == 'Thuis'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high	
    then
	
		if device_svalue(lux_sensor.porch) < lux_trigger.living_low	
			and otherdevices[light.living_standing_light] == 'Off'
			and timebetween("04:00:00","11:59:59")
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10
			and uservariables[var.living_light_override] == 0				
		then
			commandArray[light.living_standing_light]='Set Level 20'
		end	

-- **********************************************************
		
		if device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
			and otherdevices[light.living_standing_light] == 'Off'
			and otherdevices[light.living_deco_light] == 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","03:59:59"))
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10
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
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes15				
			and (timebetween("16:00:00","23:59:59") or timebetween("00:00:00","03:59:59"))
			and uservariables[var.living_light_override] == 0
		then
			commandArray["Scene:" ..scene.normal.. ""]='On REPEAT 2 INTERVAL 5'
		end
	end

--
-- **********************************************************
-- Livingroom lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('false')
		and otherdevices[someone.home] == 'Thuis'
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
-- **********************************************************
-- Livingroom lights On/Off
-- **********************************************************
--

	if devicechanged[switch.living_light] == 'On' and otherdevices[someone.home] ~= 'Thuis' and xmasseason('false') then
		commandArray["Scene:" ..scene.normal.. ""]='On REPEAT 2 INTERVAL 5'
		commandArray[someone.home]='Set Level 10 AFTER 1'
		commandArray["Variable:" .. var.living_light_override .. ""]= '0'		
	elseif devicechanged[switch.living_light] == 'On' and otherdevices[someone.home] == 'Thuis' and xmasseason('false') then
		commandArray["Scene:" ..scene.normal.. ""]='On REPEAT 2 INTERVAL 5'	
		
	end

	if devicechanged[switch.living_light] == 'Off' and timebetween("08:00:00","21:59:59") and xmasseason('false') then
		commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '1'		
	end	
	
	if devicechanged[switch.living_light] == 'Off' and xmasseason('false') and (timebetween("00:00:00","07:59:59") or timebetween("22:00:00","23:59:59")) then
		commandArray[someone.home]='Set Level 0 AFTER 1'
		commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '1'		
	end	

-- **********************************************************
-- Livingroom lights Off, triggered by time trigger
-- **********************************************************
--

	if devicechanged[someone.home] == 'Off' and xmasseason('false') 
		and (otherdevices[light.living_standing_light] ~= 'Off' or otherdevices[light.living_deco_light] ~= 'Off')
	then
		commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
		--commandArray["Variable:" .. var.living_light_override .. ""]= '0'		
	end

	
	if (devicechanged[someone.home] == 'Weg' or devicechanged[someone.home] == 'Slapen')
		and xmasseason('false') 		
	then
		commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '0'		
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

	if devicechanged[someone.home] == 'Thuis' and xmasseason('true')
		and otherdevices[light.living_standing_light] == 'Off'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high 
		and uservariables[var.living_light_override] == 0
    then
		
		if device_svalue(lux_sensor.porch) <= lux_trigger.living_low
			and timebetween("04:00:00","11:59:59")		
		then
			commandArray[light.living_standing_light]='Set Level 20'
		end
		
		if device_svalue(lux_sensor.porch) > lux_trigger.living_low
			and device_svalue(lux_sensor.porch) <= lux_trigger.living_high
			and (timebetween("15:30:00","23:59:59") or timebetween("00:00:00","03:59:59"))			
		then

			if otherdevices[light_xmas.window] == 'Off' then
			commandArray[light.living_standing_light]='Set Level 66'
			commandArray[light_xmas.tree]='On AFTER 1'
			commandArray["Scene:" ..scene.xmas_daytime.. ""]='On AFTER 2'
			end
			
			if otherdevices[light_xmas.window] == 'On' then
			commandArray[light.living_standing_light]='Set Level 66'
			commandArray[light_xmas.tree]='On AFTER 1'
			end			
				
		end
		
		if device_svalue(lux_sensor.porch) <= lux_trigger.living_low
			and (timebetween("15:30:00","23:59:59") or timebetween("00:00:00","03:59:59"))			
		then
		
			if otherdevices[light_xmas.window] == 'Off' then
			commandArray["Scene:" ..scene.xmas.. ""]='On AFTER 5 REPEAT 2 INTERVAL 5'
			if otherdevices[light_xmas.tree] == 'Off' then commandArray[light_xmas.tree]='On' end
			commandArray["Scene:" ..scene.xmas_daytime.. ""]='On AFTER 2'
			end
			
			if otherdevices[light_xmas.window] == 'On' then
			commandArray["Scene:" ..scene.xmas.. ""]='On AFTER 5 REPEAT 2 INTERVAL 5'
			if otherdevices[light_xmas.tree] == 'Off' then commandArray[light_xmas.tree]='On' end
			end	
			
		end
	end
	
--
-- **********************************************************
-- Livingroom Xmas lights ON when someone home
-- **********************************************************
--	

	if devicechanged[someone.home] == 'Thuis' and xmasseason('true')
		and otherdevices[light_xmas.tree] == 'Off'
		and device_svalue(lux_sensor.porch) > lux_trigger.living_high
		and weekend('false')		
		and (timebetween("08:30:00","23:59:59") or timebetween("00:00:00","03:59:59"))
    then
		commandArray[light_xmas.tree]='On'	
	end

	if devicechanged[someone.home] == 'Thuis' and xmasseason('true')
		and otherdevices[light_xmas.tree] == 'Off'
		and device_svalue(lux_sensor.porch) > lux_trigger.living_high
		and weekend('true')		
		and (timebetween("07:30:00","23:59:59") or timebetween("00:00:00","03:59:59"))
    then
		commandArray[light_xmas.tree]='On'	
	end
	
--
-- **********************************************************
-- Livingroom lights ON when lux is lower then threshold
-- **********************************************************
--
	if devicechanged[lux_sensor.living] and xmasseason('true')
		and otherdevices[someone.home] == 'Thuis'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high
    then
	
		if device_svalue(lux_sensor.porch) < lux_trigger.living_low	
			and otherdevices[light.living_standing_light] == 'Off'
			and timebetween("04:00:00","11:59:59")
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10
			and uservariables[var.living_light_override] == 0				
		then
			commandArray[light.living_standing_light]='Set Level 20'
		end	

-- **********************************************************
		
		if device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
			and otherdevices[light.living_standing_light] == 'Off'
			and otherdevices[light.living_deco_light] == 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and (timebetween("15:30:00","23:59:59") or timebetween("00:00:00","03:59:59"))
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes10
			and uservariables[var.living_light_override] == 0
		then
		
			if otherdevices[light_xmas.window] == 'Off' then
			commandArray[light.living_standing_light]='Set Level 66'
			commandArray["Scene:" ..scene.xmas_daytime.. ""]='On'
			if otherdevices[light_xmas.tree] == 'Off' then commandArray[light_xmas.tree]='On' end			
			end
			
			if otherdevices[light_xmas.window] == 'On' then
			commandArray[light.living_standing_light]='Set Level 66'
			if otherdevices[light_xmas.tree] == 'Off' then commandArray[light_xmas.tree]='On' end			
			end
			
		end
		
-- **********************************************************

		if device_svalue(lux_sensor.porch) <= lux_trigger.living_high			
			and otherdevices[light.living_standing_light] ~= 'Off'
			and otherdevices[light.living_twilight] == 'Off'			
			and otherdevices[light.living_wall_lights] == 'Off'
			and otherdevices[light.living_deco_light] == 'Off'
			and timedifference(otherdevices_lastupdate[light.living_standing_light]) >= timeout.minutes15				
			and (timebetween("15:30:00","23:59:59") or timebetween("00:00:00","03:59:59"))
			and uservariables[var.living_light_override] == 0
		then

			if otherdevices[light_xmas.window] == 'Off' then
			commandArray["Scene:" ..scene.xmas.. ""]='On REPEAT 2 INTERVAL 5'
			commandArray["Scene:" ..scene.xmas_daytime.. ""]='On'
			if otherdevices[light_xmas.tree] == 'Off' then commandArray[light_xmas.tree]='On' end			
			end
			
			if otherdevices[light_xmas.window] == 'On' then
			commandArray["Scene:" ..scene.xmas.. ""]='On REPEAT 2 INTERVAL 5'
			if otherdevices[light_xmas.tree] == 'Off' then commandArray[light_xmas.tree]='On' end			
			end	

		end
	end
	
--
-- **********************************************************
-- Livingroom Xmas lights ON when someone home
-- **********************************************************
--	

	if devicechanged[lux_sensor.living] and xmasseason('true')
		and otherdevices[someone.home] == 'Thuis'
		and otherdevices[light_xmas.tree] == 'Off'
		and weekend('false')		
		and (timebetween("09:00:00","23:59:59") or timebetween("00:00:00","03:59:59"))
    then
		commandArray[light_xmas.tree]='On'	
	end

	if devicechanged[lux_sensor.living] and xmasseason('true')
		and otherdevices[someone.home] == 'Thuis'
		and otherdevices[light_xmas.tree] == 'Off'
		and weekend('true')		
		and (timebetween("07:30:00","23:59:59") or timebetween("00:00:00","03:59:59"))
    then
		commandArray[light_xmas.tree]='On'	
	end		

--
-- **********************************************************
-- Livingroom lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('true')
		and otherdevices[someone.home] == 'Thuis'
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
			commandArray["Scene:" ..scene.shutdown_xmas.. ""]='On REPEAT 2 INTERVAL 10'
			commandArray["Variable:" .. var.living_light_override .. ""]= '0'	
		end
		
	end		

--
-- **********************************************************
-- Livingroom lights On/Off
-- **********************************************************
--

	if devicechanged[switch.living_light] == 'On' and otherdevices[someone.home] ~= 'Thuis' and xmasseason('true')  then
		commandArray["Scene:" ..scene.xmas.. ""]='On REPEAT 2 INTERVAL 5'
		commandArray[someone.home]='Set Level 10 AFTER 1'
		commandArray["Variable:" .. var.living_light_override .. ""]= '0'		
	elseif devicechanged[switch.living_light] == 'On' and otherdevices[someone.home] == 'Thuis' and xmasseason('true')  then
		commandArray["Scene:" ..scene.xmas.. ""]='On REPEAT 2 INTERVAL 5'	
		
	end

	if devicechanged[switch.living_light] == 'Off' and timebetween("08:00:00","21:59:59") and xmasseason('true')  then
		commandArray[light_xmas.tree]='Off'		
		commandArray["Scene:" ..scene.shutdown_xmas.. ""]='On AFTER 1 REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '1'		
	end	
	
	if devicechanged[switch.living_light] == 'Off' and xmasseason('true')  and (timebetween("00:00:00","07:59:59") or timebetween("22:00:00","23:59:59")) then
		commandArray[someone.home]='Set Level 0 AFTER 2'
		commandArray[light_xmas.tree]='Off'		
		commandArray["Scene:" ..scene.shutdown_xmas.. ""]='On AFTER 1 REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '1'		
	end	

-- **********************************************************
-- Livingroom lights Off, triggered by time trigger
-- **********************************************************
--

	if devicechanged[someone.home] == 'Off' and xmasseason('true')  
		and (otherdevices[light.living_standing_light] ~= 'Off' or otherdevices[light.living_deco_light] ~= 'Off')
	then
		commandArray[light_xmas.tree]='Off'		
		commandArray["Scene:" ..scene.shutdown_xmas.. ""]='On AFTER 1 REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '0'		
	end

	
	if (devicechanged[someone.home] == 'Weg' or devicechanged[someone.home] == 'Slapen')
		and xmasseason('true') 		
	then
		commandArray[light_xmas.tree]='Off'		
		commandArray["Scene:" ..scene.shutdown_xmas.. ""]='On AFTER 1 REPEAT 2 INTERVAL 10'
		commandArray["Variable:" .. var.living_light_override .. ""]= '0'		
	end	