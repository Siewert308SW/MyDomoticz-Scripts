--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ various_timers.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-4-2018
	@ Script to switch ON/OFF various devices if max timeout reached
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--[[
-- *********************************************************************
-- Coridor light OFF when no motion for x minutes
-- *********************************************************************
--
	
	if devicechanged[lux_sensor.upstairs]
		and (otherdevices[light.upstairs] ~='Off' or otherdevices[switch.upstairs1] =='On' or otherdevices[switch.upstairs1] =='On')
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.minutes10
		and timedifference(otherdevices_lastupdate[switch.upstairs1]) >= timeout.minutes10
		and timedifference(otherdevices_lastupdate[switch.upstairs2]) >= timeout.minutes10
		and timedifference(otherdevices_lastupdate[light.upstairs]) >= timeout.minutes10		
	then
		commandArray[light.upstairs]='Off'
		commandArray[switch.upstairs1]='Off AFTER 1'		
		commandArray[switch.upstairs2]='Off AFTER 2'		
	end
--]]

--
-- *********************************************************************
-- Show light OFF when no motion for x minutes
-- *********************************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[light.shower] =='On'
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.hour1
		and timedifference(otherdevices_lastupdate[light.shower]) >= timeout.hour1	
	then
		commandArray[light.shower]='Off AFTER 1'		
	end
	
--
-- *********************************************************************
-- Check if it's a national holiday
-- *********************************************************************
--


	if devicechanged[lux_sensor.upstairs] and (timebetween("21:59:59","23:59:59") or timebetween("00:00:00","00:29:59")) then
		
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

	