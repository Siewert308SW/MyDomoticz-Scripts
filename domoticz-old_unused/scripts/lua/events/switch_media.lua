--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switch_media.lua
	@ Author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script for switching media dummy switches to determine if SomeOneHome
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]	 

-- Media
	local television 					= 'Televisie'
	local mediabox 						= 'MediaBox'
	local media_switch 					= 'Media'
	local coax_box 					    = 'Standby Killer (T.V Versterker)'	
	local pico_power    				= 'PIco RPi Powered'
	local security_activation_type		= 'alarm_ActivationType'
	
--
-- **********************************************************
-- Television ON/OFF
-- **********************************************************
--
	if devicechanged[television] == 'On'
		and otherdevices[mediabox] == 'On'
		and otherdevices[media_switch] == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then	
		commandArray[media_switch]='On'
		commandArray[coax_box]='On'
			if otherdevices[someonehome] == 'Off'
			and timebetween("08:00:00","22:00:00")		
			then
				commandArray[someonehome]='On'	
			end			
		event_body = '.............................................................'		
	end

	if devicechanged[television] == 'Off'
		and otherdevices[mediabox] == 'Off'
		and otherdevices[media_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then	
		commandArray[media_switch]='Off'
		event_body = '.............................................................'		
	end

--
-- **********************************************************
-- MediaBox ON/OFF
-- **********************************************************
--
	if devicechanged[mediabox] == 'On'
		and otherdevices[television] == 'On'
		and otherdevices[media_switch] == 'Off'
	    and otherdevices[pico_power]   == 'On'	
		and uservariables[security_activation_type] == 0		
	then	
		commandArray[media_switch]='On'
			if otherdevices[someonehome] == 'Off'
			and timebetween("08:00:00","22:00:00")		
			then
				commandArray[someonehome]='On'	
			end			
		event_body = '.............................................................'		
	end

	if devicechanged[mediabox] == 'Off'
		and otherdevices[television] == 'Off'	
		and otherdevices[media_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then
		commandArray[media_switch]='Off'
		event_body = '.............................................................'		
	end	