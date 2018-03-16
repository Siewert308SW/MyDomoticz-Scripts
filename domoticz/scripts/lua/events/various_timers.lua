--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ various_timers.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-16-2018
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
-- Sunrise/Sunset switch ON/OFF to overrule some events
-- *********************************************************************
--

--[[
	if devicechanged[lux_sensor.upstairs] then
		
		-- If nighttime
		if (timeofday['Nighttime']) and otherdevices[lux_sensor.switch] == 'Off' then
			commandArray[lux_sensor.switch]='On AFTER 1'
		end

		-- If daytime
		if (timeofday['Daytime']) and otherdevices[lux_sensor.switch] == 'On' then
			commandArray[lux_sensor.switch]='Off AFTER 1'
		end
	end
--]]	
	