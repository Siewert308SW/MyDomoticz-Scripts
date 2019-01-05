--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ various_timers.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 01-01-2019
	@ Script to switch ON/OFF various devices
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- *********************************************************************
-- Shower light OFF when no motion for x minutes
-- *********************************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[light.shower] =='On'
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.hour1
		and timedifference(otherdevices_lastupdate[light.shower]) >= timeout.hour1	
	then
		commandArray[light.shower]='Off'		
	end
	
--
-- *********************************************************************
-- Check if it's a national holiday
-- *********************************************************************
--


	if devicechanged[lux_sensor.porch] and timebetween("21:59:59","23:59:59") then
		
		today=os.capture('date --date="0 days ago " +"%-d-%-m-%Y"', false)
		tomorrow=os.capture('date --date="tomorrow " +"%-d-%-m-%Y"', false)	
		
		return_today=os.capture("curl -s 'http://www.kayaposoft.com/enrico/json/v2.0/?action=isPublicHoliday&date="..today.."&country=nl'", false)

		return_tomorrow=os.capture("curl -s 'http://www.kayaposoft.com/enrico/json/v2.0/?action=isPublicHoliday&date="..tomorrow.."&country=nl'", false)

-- *********************************************************************
		
		if string.find(return_today, 'true') and string.find(return_tomorrow, 'true') and uservariables[var.holiday] ~= 1 then
			commandArray["Variable:" .. var.holiday .. ""]= '1'
		end

		if string.find(return_today, 'false') and string.find(return_tomorrow, 'true') and uservariables[var.holiday] ~= 1 then
			commandArray["Variable:" .. var.holiday .. ""]= '1'
		end

-- *********************************************************************
		
		if string.find(return_today, 'false') and string.find(return_tomorrow, 'false') and uservariables[var.holiday] ~= 0 then
			commandArray["Variable:" .. var.holiday .. ""]= '0'
		end
		
		if string.find(return_today, 'true') and string.find(return_tomorrow, 'false') and uservariables[var.holiday] ~= 0 then
			commandArray["Variable:" .. var.holiday .. ""]= '0'
		end		

	end