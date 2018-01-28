--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_pantry.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ Script to switch ON/OFF pantry light when door is triggered
	
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
		commandArray[light.pantry]='On AFTER 1 REPEAT 2 INTERVAL 1'	
	end

--
-- **********************************************************
-- Pantry light OFF when door Closed
-- **********************************************************
--

	if devicechanged[door.pantry] == 'Closed' 
		and otherdevices[light.pantry]  == 'On'		
	then		
		commandArray[light.pantry]='Off AFTER 1 REPEAT 2 INTERVAL 1'
	end

--
-- **********************************************************
-- Pantry light OFF when ON and timeout exceeded
-- **********************************************************
--

	if devicechanged[lux_sensor.hallway]
		and otherdevices[light.pantry]  == 'On'
		and otherdevices[door.front] == 'Closed' -- In case a mechanic is busy in the pantry for electric/gas maintance
		and otherdevices[door.living] == 'Closed'
		and timedifference(otherdevices_lastupdate[light.pantry]) > timeout.minutes5		
	then		
		commandArray[light.pantry]='Off REPEAT 3 INTERVAL 2'
	end		