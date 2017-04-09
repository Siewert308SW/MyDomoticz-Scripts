--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_stairs.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script for switching topfloor light ON/OFF when someone walking up/down stairs
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Motion/Door/Window Sensors
	local motion_upstairs 				= 'Trap Motion Boven'
	local motion_downstairs 			= 'Trap Motion Beneden'
	local livingroom_door				= 'Kamer Deur'
	
-- Lights
	local topfloor_light				= 'Gang Lamp Boven'
	local topfloor_light_standby		= 'Gang Lamp Boven - Standby'		

-- Various locals 	
	local timeout_short 			    = 10
	local timeout_long 					= 59
	local security_activation_type		= 'alarm_ActivationType'
	
-- Various
	local dusk_sensor					= 'Schemer Sensor'
	local pico_power					= 'PIco RPi Powered'

--
-- **********************************************************
--  
-- **********************************************************
--
	
	if devicechanged[motion_upstairs] == 'On'
		and otherdevices[topfloor_light_standby]   == 'Off'
	    and otherdevices[pico_power]   == 'On'		
		and otherdevices[dusk_sensor]   == 'On'		
		and timebetween("13:00:00","19:00:00")		
		and timedifference(otherdevices_lastupdate[motion_downstairs]) < timeout_short
		and timedifference(otherdevices_lastupdate[livingroom_door]) < timeout_short
		and uservariables[security_activation_type] == 0		
	then	
		commandArray[topfloor_light]='Set Level 50 REPEAT 2 INTERVAL 2'
		event_body = '.............................................................'
		event_body0 = 'Somebody walking upstairs'

	elseif devicechanged[motion_upstairs] == 'On'
		and otherdevices[topfloor_light_standby]   == 'Off'
	    and otherdevices[pico_power]   == 'On'		
		and otherdevices[dusk_sensor]   == 'On'		
		and timebetween("19:00:01","21:45:00")		
		and timedifference(otherdevices_lastupdate[motion_downstairs]) < timeout_short
		and timedifference(otherdevices_lastupdate[livingroom_door]) < timeout_short
		and uservariables[security_activation_type] == 0		
	then	
		commandArray[topfloor_light]='Set Level 10 REPEAT 2 INTERVAL 2'
		event_body = '.............................................................'
		event_body0 = 'Somebody walking upstairs'		
	end

	if devicechanged[motion_downstairs] == 'On'
		and otherdevices[topfloor_light_standby]   == 'On'
	    and otherdevices[pico_power]   == 'On'		
		--and otherdevices[dusk_sensor]   == 'On'		
		--and timebetween("13:00:00","22:00:00")		
		and timedifference(otherdevices_lastupdate[motion_upstairs]) < timeout_short
		and timedifference(otherdevices_lastupdate[livingroom_door]) > timeout_short
		and uservariables[security_activation_type] == 0		
	then	
		commandArray[topfloor_light]='Off AFTER 15 REPEAT 3 INTERVAL 15'
		event_body = '.............................................................'
		event_body0 = 'Somebody walking downstairs'		
	end	
