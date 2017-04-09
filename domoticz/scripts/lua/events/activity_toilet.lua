--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_toilet.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script to switch ON toilet light when motion is triggered with standby to avoid triggering it again when light set OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- IsDark Switches and Trigger									-- Light Switches
	local motion_toilet					= 'W.C Motion'				local toilet_light					= 'W.C Lamp'

-- Various Switches
	local toilet_standby				= 'W.C Standby'
	local upstairs_standby				= 'Trap Boven - Standby'
	local downstairs_standby			= 'Trap Beneden - Standby'
	local isdark_standby				= 'IsDonker - Standby'
	local pico_power					= 'PIco RPi Powered'
	local security_activation_type		= 'alarm_ActivationType'
	
--
-- **********************************************************
-- Toilet light ON at motion detection
-- **********************************************************
--

	if devicechanged[motion_toilet] == 'On' 
		and otherdevices[toilet_light]  == 'Off'
		and otherdevices[toilet_standby]  == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and timebetween("08:00:00","23:30:00")	
		and uservariables[security_activation_type] == 0		
	then		
		commandArray[toilet_standby]='On'		
		commandArray[toilet_light]='On REPEAT 2 INTERVAL 1'
		event_body = '.............................................................'		
	end

--
-- **********************************************************
-- Toilet light manual ON
-- **********************************************************
--

	if devicechanged[toilet_light] == 'On'
		and otherdevices[motion_toilet]  == 'Off'
		and otherdevices[toilet_standby]  == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then	
		commandArray[toilet_standby]='On'
		event_body = '.............................................................'	
	end

--
-- **********************************************************
-- Toilet light manual OFF
-- **********************************************************
--

	if devicechanged[toilet_light] == 'Off'
		and otherdevices[toilet_standby]  == 'On'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then		
		commandArray[toilet_standby]='Off AFTER 10'
		event_body = '.............................................................'	
	end