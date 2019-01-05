--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom_away.lua
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

	if devicechanged[someone.home] == 'Weg' and xmasseason('false')
		and otherdevices[living_twilight_tv] == 'Off'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_low
		and timebetween("15:00:00","22:59:59")			
	then
			commandArray["Scene:" ..scene.away.. ""]='On AFTER 60'
	end
	
--
-- **********************************************************
-- Livingroom lights ON when lux is lower then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('false')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
		and otherdevices[living_twilight_tv] == 'Off'
		and timebetween("15:00:00","22:59:59")
	then
		
		if device_svalue(lux_sensor.porch) <= lux_trigger.living_high	
			and otherdevices[living_twilight_tv] == 'Off'
			and timebetween("15:00:00","22:59:59")
			and timedifference(otherdevices_lastupdate[living_twilight_tv]) >= timeout.minutes10		
		then
			commandArray[living_twilight_tv]='On AFTER 60'
		end
		
-- **********************************************************

		if device_svalue(lux_sensor.porch) <= lux_trigger.living_high			
			and otherdevices[living_twilight_tv] ~= 'Off'
			and timebetween("15:00:00","22:59:59")			
			and timedifference(otherdevices_lastupdate[living_twilight_tv]) >= timeout.minutes15		
		then
			commandArray["Scene:" ..scene.away.. ""]='On AFTER 60'
		end

	end

--
-- **********************************************************
-- Livingroom lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('false')
		and otherdevices[someone.home] ~= 'Thuis'
		and device_svalue(lux_sensor.porch) > lux_trigger.living_high		
		and otherdevices[living_twilight_tv] ~= 'Off'
	then
		
		if timedifference(otherdevices_lastupdate[living_twilight_tv]) >= timeout.minutes5		
			and device_svalue(lux_sensor.porch) > lux_trigger.living_high
			and otherdevices[living_twilight_tv] ~= 'Off'	
		then
			commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
		end
		
	end

--
-- **********************************************************
-- Livingroom lights OFF at specific time
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('false')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
		and otherdevices[living_twilight_tv] ~= 'Off'
		and timebetween("23:00:00","23:59:59")
	then
		
		if timedifference(otherdevices_lastupdate[living_twilight_tv]) >= timeout.minutes5		
			and device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
			and otherdevices[living_twilight_tv] ~= 'Off'		
		then
			commandArray["Scene:" ..scene.shutdown.. ""]='On REPEAT 2 INTERVAL 10'
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

	if devicechanged[someone.home] == 'Weg' and xmasseason('true')
		and otherdevices[living_twilight_tv] == 'Off'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high
		and timebetween("14:00:00","22:59:59")			
	then
	
		if os.capture('date --date="0 days ago " +"%-d-%-m"', false) ~= '25-12' and os.capture('date --date="0 days ago " +"%-d-%-m"', false) ~= '26-12' then
		commandArray["Scene:" ..scene.away_xmas.. ""]='On AFTER 60'
		end
		
		if os.capture('date --date="0 days ago " +"%-d-%-m"', false) == '25-12' or os.capture('date --date="0 days ago " +"%-d-%-m"', false) == '26-12' or os.capture('date --date="0 days ago " +"%-d-%-m"', false) == '01-01' then
		commandArray["Scene:" ..scene.away_xmas.. ""]='On AFTER 60'
		commandArray["Scene:" ..scene.xmas_daytime.. ""]='On AFTER 120'
		end
		
	end	
	
--
-- **********************************************************
-- Livingroom lights ON when lux is lower then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('true')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
		and otherdevices[living_twilight_tv] == 'Off'
		and timebetween("14:00:00","22:59:59")
	then
	
	
		if os.capture('date --date="0 days ago " +"%-d-%-m"', false) ~= '25-12' and os.capture('date --date="0 days ago " +"%-d-%-m"', false) ~= '26-12' then
			if device_svalue(lux_sensor.porch) <= lux_trigger.living_high	
				and otherdevices[living_twilight_tv] == 'Off'
				and timedifference(otherdevices_lastupdate[living_twilight_tv]) >= timeout.minutes10		
			then
				commandArray["Scene:" ..scene.away_xmas.. ""]='On'
			end
		end

-- **********************************************************
		
		if os.capture('date --date="0 days ago " +"%-d-%-m"', false) == '25-12' or os.capture('date --date="0 days ago " +"%-d-%-m"', false) == '26-12' then
			if device_svalue(lux_sensor.porch) <= lux_trigger.living_high			
				and otherdevices[living_twilight_tv] ~= 'Off'			
				and timedifference(otherdevices_lastupdate[living_twilight_tv]) >= timeout.minutes15		
			then
				commandArray["Scene:" ..scene.away_xmas.. ""]='On AFTER 60'
				commandArray["Scene:" ..scene.xmas_daytime.. ""]='On AFTER 120'
			end
		end	

	end

--
-- **********************************************************
-- Livingroom lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('true')
		and otherdevices[someone.home] ~= 'Thuis'
		and device_svalue(lux_sensor.porch) > lux_trigger.living_high		
		and otherdevices[living_twilight_tv] ~= 'Off'
	then
		
		if timedifference(otherdevices_lastupdate[living_twilight_tv]) >= timeout.minutes5		
			and device_svalue(lux_sensor.porch) > lux_trigger.living_high
			and otherdevices[living_twilight_tv] ~= 'Off'	
		then
			commandArray["Scene:" ..scene.shutdown_xmas.. ""]='On REPEAT 2 INTERVAL 10'
		end
		
	end

--
-- **********************************************************
-- Livingroom lights OFF at specific time
-- **********************************************************
--

	if devicechanged[lux_sensor.living] and xmasseason('true')
		and otherdevices[someone.home] == 'Weg'
		and device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
		and otherdevices[living_twilight_tv] ~= 'Off'
		and timebetween("23:00:00","23:59:59")
	then
		
		if timedifference(otherdevices_lastupdate[living_twilight_tv]) >= timeout.minutes5		
			and device_svalue(lux_sensor.porch) <= lux_trigger.living_high		
			and otherdevices[living_twilight_tv] ~= 'Off'		
		then
			commandArray["Scene:" ..scene.shutdown_xmas.. ""]='On REPEAT 2 INTERVAL 10'
		end
		
	end
	
