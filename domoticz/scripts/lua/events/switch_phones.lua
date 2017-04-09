--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switch_phones.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-4-2017
	@ Script for switching phone dummy switch to determine if SomeOneHome
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Phones
	local phone_1 						= 'Jerina GSM'
	local phone_2 						= 'Siewert GSM'
	local phone_3 						= 'Natalya GSM'	

-- Slave devices which runs a seperate online ETH check on a Raspberry slave located upstairs
-- Just incase BT isn't detected upstairs or when back in the garden
	local phone_1_slave 				= 'Dummy 1'
	local phone_2_slave 				= 'Dummy 2'
	local phone_3_slave				    = 'Dummy 3'
	
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
	
	if devicechanged[phone_1_slave] == 'On' 
		and otherdevices[phone_switch] == 'Off'
	then	
		commandArray[phone_switch]='On'
		event_body = '.............................................................'		
	end	
	
	if devicechanged[phone_1] == 'Off'	
		and otherdevices[phone_2] == 'Off'
		and otherdevices[phone_3] == 'Off'
		and otherdevices[phone_1_slave] == 'Off'
		and otherdevices[phone_2_slave] == 'Off'
		and otherdevices[phone_3_slave] == 'Off' 		
		and otherdevices[phone_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then	
		commandArray[phone_switch]='Off'
		event_body = '.............................................................'		
	end
	
	if devicechanged[phone_1_slave] == 'Off'	
		and otherdevices[phone_2] == 'Off'
		and otherdevices[phone_3] == 'Off'
		and otherdevices[phone_1] == 'Off'
		and otherdevices[phone_2_slave] == 'Off'
		and otherdevices[phone_3_slave] == 'Off' 		
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
	
	if devicechanged[phone_2_slave] == 'On' 
		and otherdevices[phone_switch] == 'Off'
	then	
		commandArray[phone_switch]='On'
		event_body = '.............................................................'		
	end		
		
	if devicechanged[phone_2] == 'Off'
		and otherdevices[phone_3] == 'Off'
		and otherdevices[phone_1] == 'Off' 
		and otherdevices[phone_1_slave] == 'Off'
		and otherdevices[phone_2_slave] == 'Off'
		and otherdevices[phone_3_slave] == 'Off'		
		and otherdevices[phone_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then
		commandArray[phone_switch]='Off'
		event_body = '.............................................................'		
	end

	if devicechanged[phone_2_slave] == 'Off'
		and otherdevices[phone_3] == 'Off'
		and otherdevices[phone_1] == 'Off' 
		and otherdevices[phone_1_slave] == 'Off'
		and otherdevices[phone_2] == 'Off'
		and otherdevices[phone_3_slave] == 'Off'		
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
	
	if devicechanged[phone_3_slave] == 'On' 
		and otherdevices[phone_switch] == 'Off'
	then	
		commandArray[phone_switch]='On'
		event_body = '.............................................................'		
	end		
		
	if devicechanged[phone_3] == 'Off'	
		and otherdevices[phone_2] == 'Off'
		and otherdevices[phone_1] == 'Off'
		and otherdevices[phone_1_slave] == 'Off'
		and otherdevices[phone_2_slave] == 'Off'
		and otherdevices[phone_3_slave] == 'Off'		
		and otherdevices[phone_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then	
		commandArray[phone_switch]='Off'
		event_body = '.............................................................'	
	end	
	
	if devicechanged[phone_3_slave] == 'Off'	
		and otherdevices[phone_2] == 'Off'
		and otherdevices[phone_1] == 'Off'
		and otherdevices[phone_1_slave] == 'Off'
		and otherdevices[phone_2_slave] == 'Off'
		and otherdevices[phone_3] == 'Off'		
		and otherdevices[phone_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then	
		commandArray[phone_switch]='Off'
		event_body = '.............................................................'	
	end