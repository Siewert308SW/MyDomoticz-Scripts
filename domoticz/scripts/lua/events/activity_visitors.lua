--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_visitors.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 10-4-2017
	@ Script for switching ""visitors dummy switch for some special light scenes/events
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Phones
	local phone_4 						= 'Oma GSM'	

--Various
	local visitors						= 'Visite'
	local pico_power    				= 'PIco RPi Powered'
	local timeout 						= 120
	
-- Door/Window Sensors
	local frontdoor						= 'Voor Deur'
	local backdoor			 			= 'Achter Deur'
	local sliding_door	 				= 'Schuifpui'
	local livingroom_door	 			= 'Kamer Deur'
	
--
-- **********************************************************
-- Phone 1 ON/OFF
-- **********************************************************
--
	if devicechanged[phone_4] == 'On' 
		and otherdevices[visitors] == 'Off'
		and timedifference(otherdevices_lastupdate[frontdoor]) < timeout
	then	
		commandArray[visitors]='On'
		event_body = '.............................................................'		
	end
	
	if devicechanged[phone_4] == 'Off'	
		and otherdevices[visitors] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then	
		commandArray[visitors]='Off'
		event_body = '.............................................................'		
	end