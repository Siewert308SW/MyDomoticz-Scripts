--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_scullery.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script for switching scullery light
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Door/Window Sensors	
	local scullery_door					= 'Bijkeuken Deur'
	local backdoor			 			= 'Achter Deur'
	
-- Various Switches
	local pico_power					= 'PIco RPi Powered'
	
-- Various locals
	local timeout_backdoor 			    = 59
	local timeout_scullery_door 	    = 10	
	local timeout_scullery_door_short   = 10
	local security_activation_type		= 'alarm_ActivationType'
	
-- IsDark Switches
	local isdark_living_room_trigger_1	= 'IsDonker_Woonkamer_1'
	
-- Lights
	local scullery_light				= 'Bijkeuken Lamp'

--
-- **********************************************************
-- Scullery light ON/OFF when someone is entering the Scullery
-- **********************************************************
--
--[[
	if devicechanged[scullery_door] == 'Open'
		and otherdevices[backdoor]   == 'Closed'
		and otherdevices[scullery_light]   == 'Off'		
	    and otherdevices[pico_power]   == 'On'		
		and otherdevices[isdark_living_room_trigger_1]   == 'On'	
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate[backdoor]) > timeout_scullery_door		
	then	
		commandArray[scullery_light]='Set Level 95 REPEAT 2 INTERVAL 1'
		event_body = '.............................................................'	
	end

	if devicechanged[scullery_door] == 'Closed'
		and otherdevices[backdoor]   == 'Closed'
		and otherdevices[scullery_light]   ~= 'Off'
		and timedifference(otherdevices_lastupdate[backdoor]) > timeout_scullery_door		
		and timedifference(otherdevices_lastupdate[scullery_light]) > timeout_scullery_door_short		
	then	
		commandArray[scullery_light]='Off AFTER 5 REPEAT 2 INTERVAL 5'
		event_body = '.............................................................'		
	end

	if devicechanged[backdoor] == 'Closed'
		and otherdevices[scullery_door]   == 'Closed'
		and otherdevices[scullery_light]   ~= 'Off'		
		--and timedifference(otherdevices_lastupdate[scullery_door]) < timeout_backdoor		
	then	
		commandArray[scullery_light]='Off AFTER 5 REPEAT 2 INTERVAL 5'
		event_body = '.............................................................'	
	end

	if devicechanged[backdoor] == 'Open'
		and otherdevices[scullery_door]   == 'Closed'
		and otherdevices[scullery_light]   == 'Off'		
	    and otherdevices[pico_power]   == 'On'		
		--and otherdevices[isdark_living_room_trigger_1]   == 'On'
		and timedifference(otherdevices_lastupdate[scullery_door]) > timeout_scullery_door	
	then	
		commandArray[scullery_light]='Set Level 100 AFTER 1'
		event_body = 'Somebody has entered the scullery via the garden'		
	end	
--]]