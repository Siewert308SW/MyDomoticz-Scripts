--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_hallway.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-25-2018
	@ Script for switching hallway light when someone is entering the hallway
	
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
		and otherdevices[standby.hallway] == 'Off'		
		and device_svalue(lux_sensor.porch) <= 2		
	then
		commandArray[light.hallway]='On'
		commandArray[standby.hallway]='On FOR 30 SECONDS'		
	end

	if (devicechanged[light.toilet] == 'Off' or devicechanged[motion_sensor.downstairs] == 'On' or devicechanged[door.living] == 'Open')
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds5	
		and otherdevices[motion_sensor.hallway] == 'Off'	
		and otherdevices[light.hallway] == 'Off'
		and otherdevices[standby.hallway] == 'Off'			
		and device_svalue(lux_sensor.porch) <= 2
		and timebetween("16:00:00","23:59:59")		
		and (otherdevices[someone.home] == 'Thuis' or otherdevices[someone.home] == 'Off')	
	then
		commandArray[light.hallway]='On'
		commandArray[standby.hallway]='On FOR 30 SECONDS'		
	end		
	
	if devicechanged[motion_sensor.hallway] == 'On'
		and otherdevices[light.hallway] == 'Off'
		and otherdevices[standby.hallway] == 'Off'		
		and device_svalue(lux_sensor.porch) <= 2	
		and otherdevices[someone.home] == 'Thuis'
		and timebetween("16:00:00","23:59:59")		
	then
		commandArray[light.hallway]='On'
		commandArray[standby.hallway]='On FOR 30 SECONDS'		
	end
	
--
-- **********************************************************
-- Hallway light instant OFF when some one is taking a shit
-- **********************************************************
--

	if devicechanged[light.toilet] == 'On'		
		and otherdevices[light.hallway] == 'On'
		and otherdevices[standby.hallway] == 'On'		
		and otherdevices[door.living] == 'Closed'		
		and otherdevices[door.front] == 'Closed'
		and otherdevices[door.pantry] == 'Closed'
	then	
		commandArray[light.hallway]='Off AFTER 3'
		commandArray[standby.hallway]='Off AFTER 4'		
	end

--
-- **********************************************************
-- Hallway light instant OFF when some one is walking upstairs
-- **********************************************************
--

	if devicechanged[motion_sensor.upstairs] == 'On'	
		and otherdevices[light.hallway] == 'On'	
		and otherdevices[standby.hallway] == 'On'		
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) <= timeout.seconds30
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) >= timeout.seconds5		
		and otherdevices[door.front] == 'Closed'
		and otherdevices[door.pantry] == 'Closed'
		and otherdevices[door.living] == 'Closed'		
	then
		commandArray[light.hallway]='Off AFTER 15'
		commandArray[standby.hallway]='Off AFTER 16'			
	end
	
--
-- **********************************************************
-- Hallway light instant OFF when some one leaves the hallway without any other room entrance
-- **********************************************************
--

	if devicechanged[door.living] == 'Closed'	
		and otherdevices[light.hallway] == 'On'	
		and otherdevices[standby.hallway] == 'On'		
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) >= timeout.seconds30
		and timedifference(otherdevices_lastupdate[motion_sensor.toilet]) >= timeout.seconds30
		and timedifference(otherdevices_lastupdate[standby.hallway]) >= timeout.seconds10		
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) >= timeout.seconds5
		and otherdevices[door.front] == 'Closed'
		and otherdevices[door.pantry] == 'Closed'		
	then
		commandArray[light.hallway]='Off AFTER 5'
		commandArray[standby.hallway]='Off AFTER 6'			
	end	
	
--
-- **********************************************************
-- Hallway Light OFF when no motion (1min trigger in timer folder)
-- **********************************************************
--

	if devicechanged[standby.hallway] == 'Off'
		and otherdevices[light.hallway] == 'On'		
		and otherdevices[door.front] == 'Closed' 
		and otherdevices[door.pantry] == 'Closed'
		and otherdevices[door.living] == 'Closed'		
	then

			if (timedifference(otherdevices_lastupdate[motion_sensor.hallway]) < timeout.seconds30
				or timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) < timeout.seconds30			
				or timedifference(otherdevices_lastupdate[door.front]) < timeout.seconds30
				or timedifference(otherdevices_lastupdate[door.pantry]) < timeout.seconds30		
				or timedifference(otherdevices_lastupdate[door.living]) < timeout.seconds30)		
			then	
				commandArray[standby.hallway]='On FOR 30 SECONDS'
			
			elseif (timedifference(otherdevices_lastupdate[motion_sensor.hallway]) >= timeout.seconds30
				and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) >= timeout.seconds30			
				and timedifference(otherdevices_lastupdate[door.front]) >= timeout.seconds30
				and timedifference(otherdevices_lastupdate[door.pantry]) >= timeout.seconds30		
				and timedifference(otherdevices_lastupdate[door.living]) >= timeout.seconds30)				
			then
				commandArray[light.hallway]='Off AFTER 1'
			end

	elseif devicechanged[standby.hallway] == 'Off'
		and otherdevices[light.hallway] == 'On'		
		and (otherdevices[door.front] == 'Open' 
		or otherdevices[door.pantry] == 'Open'
		or otherdevices[door.living] == 'Open'		
		or otherdevices[motion_sensor.hallway] == 'On')		
	then
		commandArray[standby.hallway]='On FOR 30 SECONDS'	
	end

	if devicechanged[lux_sensor.hallway]	
		and otherdevices[light.hallway] == 'On'
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) >= timeout.minutes2		
	then
		commandArray[light.hallway]='Off AFTER 1'
		commandArray[standby.hallway]='Off AFTER 2'		
	end	