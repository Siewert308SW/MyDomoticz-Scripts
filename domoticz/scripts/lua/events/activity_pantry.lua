--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_pantry.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 01-01-2019
	@ Script to switch ON/OFF pantry light
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- Pantry light ON when door Open
-- **********************************************************
--

	if devicechanged[door.pantry] == 'Open' 
		and otherdevices[light.pantry]  == 'Off'		
	then		
		commandArray[light.pantry]='On'	
	end

--
-- **********************************************************
-- Pantry light OFF when door Closed
-- **********************************************************
--

	if devicechanged[door.pantry] == 'Closed' 
		and otherdevices[light.pantry]  == 'On'		
	then		
		commandArray[light.pantry]='Off'
	end

--
-- **********************************************************
-- Pantry light OFF when timeout exceeded
-- **********************************************************
--

	if devicechanged[lux_sensor.hallway]
		and otherdevices[light.pantry]  == 'On'
		and otherdevices[door.front] == 'Closed' -- In case a mechanic is busy in the pantry for electric/gas maintenance
		and timedifference(otherdevices_lastupdate[light.pantry]) > timeout.minutes10		
	then		
		commandArray[light.pantry]='Off'
	end		