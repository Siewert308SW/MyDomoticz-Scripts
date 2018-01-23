--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_pantry.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-4-2017
	@ Script to switch ON/OFF pantry light when door is triggered
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Door Switch
	local pantry_door					= 'Kelder Deur'

-- Light Switches
	local pantry_light					= 'Kelder Lamp'

-- Various Switches
	local pico_power					= 'PIco RPi Powered'
	
--
-- **********************************************************
-- Pantry light ON when door open
-- **********************************************************
--

	if devicechanged[pantry_door] == 'Open' 
		and otherdevices[pantry_light]  == 'Off'
	    and otherdevices[pico_power]   == 'On'		
	then		
		commandArray[pantry_light]='On'
		--event_body = '.............................................................'		
	end

--
-- **********************************************************
-- Pantry light OFF when door open
-- **********************************************************
--

	if devicechanged[pantry_door] == 'Closed' 
		and otherdevices[pantry_light]  == 'On'	
	    and otherdevices[pico_power]   == 'On'		
	then		
		commandArray[pantry_light]='Off AFTER 15 REPEAT 2 INTERVAL 5'
		--event_body = '.............................................................'	
	end