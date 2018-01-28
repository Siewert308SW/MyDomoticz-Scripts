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
-- Hallway light ON when someone entering hallway
-- **********************************************************
--

	if devicechanged[door.front] == 'Open'
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds30	
		and otherdevices[motion_sensor.hallway] == 'Off'	
		and otherdevices[light.hallway] == 'Off'
		and dark('true', 2)		
	then
		commandArray[light.hallway]='On REPEAT 3 INTERVAL 2'	
	end
	
	if (devicechanged[light.toilet] == 'Off' or devicechanged[motion_sensor.downstairs] == 'On' or devicechanged[door.living] == 'Open')
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds30	
		and otherdevices[motion_sensor.hallway] == 'Off'	
		and otherdevices[light.hallway] == 'Off'
		and dark('true', 2)
		and timebetween("06:00:00","23:29:59")
		and otherdevices[phone.jerina] == 'On'		
	then
		commandArray[light.hallway]='On REPEAT 3 INTERVAL 2'	
	end
	
	if (devicechanged[light.toilet] == 'Off' or devicechanged[motion_sensor.downstairs] == 'On' or devicechanged[door.living] == 'Open')
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout.seconds30	
		and otherdevices[motion_sensor.hallway] == 'Off'	
		and otherdevices[light.hallway] == 'Off'
		and dark('true', 2)
		and timebetween("00:00:00","23:59:59")
		and otherdevices[phone.jerina] == 'Off'		
	then
		commandArray[light.hallway]='On REPEAT 3 INTERVAL 2'	
	end	

--
-- **********************************************************
-- Hallway Light OFF when no motion (1min trigger in timer folder)
-- **********************************************************
--
--[[
	if otherdevices[light.hallway] == 'On'
		and otherdevices[door.front] == 'Closed' 
		and otherdevices[door.pantry] == 'Closed' 
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > timeout30sec
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) > timeout30sec			
		and timedifference(otherdevices_lastupdate[door.front]) > timeout30sec
		and timedifference(otherdevices_lastupdate[door.pantry]) > timeout30sec		
		and timedifference(otherdevices_lastupdate[door.living]) > timeout30sec			
	then	
		commandArray[light.hallway]='Off AFTER 1 REPEAT 3 INTERVAL 2'
	end
--]]	
--
-- **********************************************************
-- Hallway light instant OFF when some one is taking a shit
-- **********************************************************
--

	if devicechanged[light.toilet] == 'On'		
		and otherdevices[light.hallway] == 'On'
		and otherdevices[door.living] == 'Closed'		
		and otherdevices[door.front] == 'Closed'
		and otherdevices[door.pantry] == 'Closed'
	then	
		commandArray[light.hallway]='Off AFTER 10 REPEAT 3 INTERVAL 2'
	end

--
-- **********************************************************
-- Hallway light instant OFF when some one is walking upstairs
-- **********************************************************
--

	if devicechanged[motion_sensor.upstairs] == 'On'	
		and otherdevices[light.hallway] == 'On'	
		and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) <= timeout.seconds30	
		and otherdevices[door.front] == 'Closed'
		and otherdevices[door.pantry] == 'Closed'
	then
		commandArray[light.hallway]='Off AFTER 10 REPEAT 3 INTERVAL 2'
	
	end