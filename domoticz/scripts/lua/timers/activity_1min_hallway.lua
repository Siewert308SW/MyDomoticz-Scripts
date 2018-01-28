--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_hallway.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ Script for switching hallway light when someone is entering the hallway
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- Hallway light OFF when no motion for x seconds
-- **********************************************************
--

	if otherdevices[light.hallway] == 'On'
		and otherdevices[door.front] == 'Closed' 
		and otherdevices[door.pantry] == 'Closed' 
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds30
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) > timeout.seconds30			
		and timedifference(otherdevices_lastupdate[door.front]) > timeout.seconds30
		and timedifference(otherdevices_lastupdate[door.pantry]) > timeout.seconds30		
		and timedifference(otherdevices_lastupdate[door.living]) > timeout.seconds30			
	then	
		commandArray[light.hallway]='Off AFTER 1 REPEAT 3 INTERVAL 2'
	end