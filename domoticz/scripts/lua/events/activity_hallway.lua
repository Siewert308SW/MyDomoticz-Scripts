--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_hallway.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 01-01-2019
	@ Script for switching hallway light ON/OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- Hallway light ON when someone entering hallway
-- **********************************************************
--

	if devicechanged[door.front] == 'Open'
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds30	
		and otherdevices[motion_sensor.hallway] == 'Off'	
		and otherdevices[light.hallway] == 'Off'	
		and device_svalue(lux_sensor.porch) <= lux_trigger.hallway		
	then
		commandArray[light.hallway]='Set Level 7'		
	end
	
-- **********************************************************

	if devicechanged[motion_sensor.hallway] == 'On'		
		and otherdevices[light.hallway] == 'Off'			
		and device_svalue(lux_sensor.porch) <= lux_trigger.hallway	
		and (otherdevices[someone.home] == 'Thuis' or otherdevices[someone.home] == 'Off')	
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) >= timeout.seconds30
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.seconds30		
		and timedifference(otherdevices_lastupdate[motion_sensor.toilet]) >= timeout.seconds30	
	then
		commandArray[light.hallway]='Set Level 7'
	end

-- **********************************************************
	
	if (devicechanged[door.living] == 'Open' or devicechanged[light.toilet] == 'Off')
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds5	
		and otherdevices[motion_sensor.hallway] == 'Off'		
		and otherdevices[light.hallway] == 'Off'			
		and device_svalue(lux_sensor.porch) <= lux_trigger.hallway	
		and (otherdevices[someone.home] == 'Thuis' or otherdevices[someone.home] == 'Off')	
	then	
	
		if timedifference(otherdevices_lastupdate[someone.home]) < timeout.hour1
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) > timeout.minutes5
		then		
		commandArray[light.hallway]='Set Level 7'
		end
		
		if timedifference(otherdevices_lastupdate[someone.home]) > timeout.hour1
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) > timeout.seconds30
		then		
		commandArray[light.hallway]='Set Level 7'
		end
		
		if timedifference(otherdevices_lastupdate[someone.home]) > timeout.hour1
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) < timeout.seconds30
		then		
		commandArray[light.hallway]='Set Level 7'
		end		
	end	

-- **********************************************************
	
	if devicechanged[motion_sensor.downstairs] == 'On'
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds5
		and timedifference(otherdevices_lastupdate[someone.home]) > timeout.hour1
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) < timeout.seconds30
		and otherdevices[motion_sensor.hallway] == 'Off'		
		and otherdevices[light.hallway] == 'Off'			
		and device_svalue(lux_sensor.porch) <= lux_trigger.hallway	
		and (otherdevices[someone.home] == 'Thuis' or otherdevices[someone.home] == 'Off')	
	then	
		commandArray[light.hallway]='Set Level 7'	
	end
	
--
-- **********************************************************
-- Hallway Light OFF when no motion
-- **********************************************************
--

	if devicechanged[timed.trigger]
		and otherdevices[light.hallway] ~= 'Off'		
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) >= timeout.minute1
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) >= timeout.seconds30
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.seconds30		
		and timedifference(otherdevices_lastupdate[door.front]) >= timeout.seconds30
		and timedifference(otherdevices_lastupdate[door.pantry]) >= timeout.seconds30		
		and timedifference(otherdevices_lastupdate[door.living]) >= timeout.seconds30		
	then
		commandArray[light.hallway]='Off'
	end	
