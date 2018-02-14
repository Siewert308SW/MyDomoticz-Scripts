--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_hallway.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-14-2018
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
		and dark('true', 1)		
	then
		commandArray[light.hallway]='On'
		commandArray[standby.hallway]='On FOR 30 SECONDS'		
	end
	
	if (devicechanged[light.toilet] == 'Off' or devicechanged[motion_sensor.downstairs] == 'On' or devicechanged[door.living] == 'Open')
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds15	
		and otherdevices[motion_sensor.hallway] == 'Off'	
		and otherdevices[light.hallway] == 'Off'
		and otherdevices[standby.hallway] == 'Off'		
		and dark('true', 1)
		and timebetween("16:00:00","22:45:00")
		and otherdevices[phone.jerina] == 'On'
		and weekend('false')
	then
		commandArray[light.hallway]='On'
		commandArray[standby.hallway]='On FOR 30 SECONDS'		
	end
	
	if (devicechanged[light.toilet] == 'Off' or devicechanged[motion_sensor.downstairs] == 'On' or devicechanged[door.living] == 'Open')
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds15	
		and otherdevices[motion_sensor.hallway] == 'Off'	
		and otherdevices[light.hallway] == 'Off'
		and otherdevices[standby.hallway] == 'Off'		
		and dark('true', 1)
		and timebetween("16:00:00","23:59:59")
		and otherdevices[phone.jerina] == 'On'
		and weekend('true')
	then
		commandArray[light.hallway]='On'
		commandArray[standby.hallway]='On FOR 30 SECONDS'		
	end	
	
	if (devicechanged[light.toilet] == 'Off' or devicechanged[motion_sensor.downstairs] == 'On' or devicechanged[door.living] == 'Open')
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds15	
		and otherdevices[motion_sensor.hallway] == 'Off'	
		and otherdevices[light.hallway] == 'Off'
		and otherdevices[standby.hallway] == 'Off'		
		and dark('true', 1)
		and timebetween("00:00:00","23:59:59")
		and otherdevices[phone.jerina] == 'Off'		
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
		commandArray[light.hallway]='Off AFTER 10'
		commandArray[standby.hallway]='Off AFTER 11'		
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
		and otherdevices[door.front] == 'Closed'
		and otherdevices[door.pantry] == 'Closed'
	then
		commandArray[light.hallway]='Off AFTER 10'
		commandArray[standby.hallway]='Off AFTER 11'			
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
	then

			if timedifference(otherdevices_lastupdate[motion_sensor.hallway]) < timeout.seconds30
				or timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) < timeout.seconds30			
				or timedifference(otherdevices_lastupdate[door.front]) < timeout.seconds30
				or timedifference(otherdevices_lastupdate[door.pantry]) < timeout.seconds30		
				or timedifference(otherdevices_lastupdate[door.living]) < timeout.seconds30			
			then	
				commandArray[standby.hallway]='On FOR 30 SECONDS'
			
			elseif timedifference(otherdevices_lastupdate[motion_sensor.hallway]) >= timeout.seconds30
				and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) >= timeout.seconds30			
				and timedifference(otherdevices_lastupdate[door.front]) >= timeout.seconds30
				and timedifference(otherdevices_lastupdate[door.pantry]) >= timeout.seconds30		
				and timedifference(otherdevices_lastupdate[door.living]) >= timeout.seconds30			
			then
				commandArray[light.hallway]='Off AFTER 1'
			end

	elseif devicechanged[standby.hallway] == 'Off'
		and otherdevices[light.hallway] == 'On'		
		and (otherdevices[door.front] == 'Open' 
		or otherdevices[door.pantry] == 'Open')		
	then
		commandArray[standby.hallway]='On FOR 30 SECONDS'	
	end