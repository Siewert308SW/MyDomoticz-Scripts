--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switch_phones.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 10-4-2017
	@ Script for switching phone dummy switch to determine if SomeOneHome
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Phones
	local phone_1 						= 'Jerina GSM'
	local phone_2 						= 'Siewert GSM'
	local phone_3 						= 'Natalya GSM'
	local phone_4 						= 'Oma GSM'	
	
	local phone_switch 					= 'Telefoons'
	local pico_power    				= 'PIco RPi Powered'
	
--
-- **********************************************************
-- Phone 1 ON/OFF
-- **********************************************************
--
	if devicechanged[phone_1] == 'On' 
		and otherdevices[phone_switch] == 'Off'
	then	
		commandArray[phone_switch]='On'
		event_body = '.............................................................'		
	end
	
	if devicechanged[phone_1] == 'Off'	
		and otherdevices[phone_2] == 'Off'
		and otherdevices[phone_3] == 'Off'
		and otherdevices[phone_4] == 'Off'		
		and otherdevices[phone_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then	
		commandArray[phone_switch]='Off'
		event_body = '.............................................................'		
	end
	
--
-- **********************************************************
-- Phone 2 ON/OFF
-- **********************************************************
--
	if devicechanged[phone_2] == 'On' 
		and otherdevices[phone_switch] == 'Off'
	then
		commandArray[phone_switch]='On'
		event_body = '.............................................................'		
	end
		
	if devicechanged[phone_2] == 'Off'
		and otherdevices[phone_3] == 'Off'
		and otherdevices[phone_1] == 'Off' 
		and otherdevices[phone_4] == 'Off'		
		and otherdevices[phone_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then
		commandArray[phone_switch]='Off'
		event_body = '.............................................................'		
	end
	
--
-- **********************************************************
-- Phone 3 ON/OFF
-- **********************************************************
--
	if devicechanged[phone_3] == 'On' 
		and otherdevices[phone_switch] == 'Off'		
	then		
		commandArray[phone_switch]='On'	
		event_body = '.............................................................'
	end		
		
	if devicechanged[phone_3] == 'Off'	
		and otherdevices[phone_2] == 'Off'
		and otherdevices[phone_1] == 'Off'
		and otherdevices[phone_4] == 'Off'		
		and otherdevices[phone_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then	
		commandArray[phone_switch]='Off'
		event_body = '.............................................................'	
	end
	
--
-- **********************************************************
-- Phone 4 ON/OFF
-- **********************************************************
--

	if devicechanged[phone_4] == 'On' 
		and otherdevices[phone_switch] == 'Off'		
	then		
		commandArray[phone_switch]='On'	
		event_body = '.............................................................'
	end		
		
	if devicechanged[phone_4] == 'Off'	
		and otherdevices[phone_2] == 'Off'
		and otherdevices[phone_1] == 'Off'
		and otherdevices[phone_3] == 'Off'		
		and otherdevices[phone_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then	
		commandArray[phone_switch]='Off'
		event_body = '.............................................................'	
	end	