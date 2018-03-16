--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_test_script.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-16-2018
	@ Script for testing trail and error scripts
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Upstairs light ON/OFF if someone is walking up or downstairs
-- **********************************************************
--

stairs_counter = tonumber(uservariables[var.persons_upstairs])

if devicechanged[motion_sensor.downstairs] == 'On' then

	if timedifference(otherdevices_lastupdate[motion_sensor.hallway]) < timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) then

		logmessage = 'Iemand loopt naar boven'
		stairs_counter = stairs_counter + 1
		commandArray['Variable:' .. var.persons_upstairs] = tostring(stairs_counter)
		
			if otherdevices[light.upstairs] =='Off' 
				and otherdevices[switch.upstairs1] =='Off' 
				and otherdevices[switch.upstairs1] =='Off'
				and timebetween("16:00:00","21:29:29")
				and otherdevices[someone.home] == 'Thuis'
				and device_svalue(lux_sensor.upstairs) <= 0	
				and weekend('false')			
			then
				commandArray[light.upstairs]='Set Level 7'
			
			elseif otherdevices[light.upstairs] =='Off' 
				and otherdevices[switch.upstairs1] =='Off' 
				and otherdevices[switch.upstairs1] =='Off'
				and timebetween("16:00:00","22:29:29")
				and otherdevices[someone.home] == 'Thuis'
				and device_svalue(lux_sensor.upstairs) <= 0	
				and weekend('true')			
			then
				commandArray[light.upstairs]='Set Level 7'
			end
		
	elseif timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) then


		logmessage = 'Iemand loopt naar beneden'

		if uservariables[var.persons_upstairs] < 0 then 
			stairs_counter = 0
			commandArray['Variable:' .. var.persons_upstairs] = tostring(stairs_counter)
		elseif uservariables[var.persons_upstairs] >= 0 then 
			stairs_counter = stairs_counter - 1
			commandArray['Variable:' .. var.persons_upstairs] = tostring(stairs_counter)
		end
		
			if (otherdevices[light.upstairs] ~='Off' 
				or otherdevices[switch.upstairs1] ~='Off' 
				or otherdevices[switch.upstairs1] ~='Off')
				and uservariables[var.persons_upstairs] <= 1
			then
				commandArray[light.upstairs]='Off AFTER 10'
			end
		
	end
end

--
-- **********************************************************
-- Upstairs light ON when motion detected upstairs
-- **********************************************************
--

	if devicechanged[motion_sensor.upstairs] == 'On'
		and otherdevices[light.upstairs] =='Off' 
		and otherdevices[switch.upstairs1] =='Off' 
		and otherdevices[switch.upstairs1] =='Off'
		and timebetween("16:00:00","21:29:29")
		and otherdevices[someone.home] == 'Thuis'
		and device_svalue(lux_sensor.upstairs) <= 0	
		and weekend('false')			
	then
		commandArray[light.upstairs]='Set Level 7'
		
	elseif devicechanged[motion_sensor.upstairs] == 'On'
		and otherdevices[light.upstairs] =='Off' 
		and otherdevices[switch.upstairs1] =='Off' 
		and otherdevices[switch.upstairs1] =='Off'
		and timebetween("16:00:00","22:29:29")
		and otherdevices[someone.home] == 'Thuis'
		and device_svalue(lux_sensor.upstairs) <= 0	
		and weekend('true')			
	then
		commandArray[light.upstairs]='Set Level 7'
	end
		
--
-- *********************************************************************
-- Upstairs light OFF when no motion for x minutes
-- *********************************************************************
--
	
	if devicechanged[lux_sensor.living]
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