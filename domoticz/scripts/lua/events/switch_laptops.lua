--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switch_laptops.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 6-4-2017
	@ Script for switching dummy laptop switch to determine if SomeOneHome
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Laptops
	local laptop_1 						= 'Jerina Laptop'
	local laptop_2 						= 'Siewert Laptop'
	local laptop_3 						= 'Natalya Laptop'	
	local laptop_switch 				= 'Laptops'
	local laptop_2_killer 				= 'Standby Killer (Siewert Laptop)'	
	local printer_killer 				= 'Standby Killer (Printer & Print Server)'	
	local pico_power    				= 'PIco RPi Powered'
	local someonehome    				= 'Iemand Thuis'	
	
--
-- **********************************************************
-- Laptop 1 ON/OFF
-- **********************************************************
--
	if devicechanged[laptop_1] == 'On' 
		and otherdevices[laptop_switch] == 'Off'
	then
		commandArray[laptop_switch]='On'
		commandArray[printer_killer]='On AFTER 20 REPEAT 2 INTERVAL 10'
	if otherdevices[someonehome] == 'Off' then
		commandArray[someonehome]='On'	
	end		
		event_body = '.............................................................'		
	end
	
	if devicechanged[laptop_1] == 'Off'
		and otherdevices[laptop_2] == 'Off'
		and otherdevices[laptop_3] == 'Off' 
		and otherdevices[laptop_switch] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then
		commandArray[laptop_switch]='Off'
		commandArray[printer_killer]='Off AFTER 20 REPEAT 2 INTERVAL 10'		
		event_body = '.............................................................'
	end
	
--
-- **********************************************************
-- Laptop 2 ON/OFF
-- **********************************************************
--	
	if devicechanged[laptop_2] == 'On'	
		and otherdevices[laptop_2_killer] == 'Off'
	then
	
		if otherdevices[laptop_switch] == 'Off' then			
		commandArray[laptop_switch]='On'
		commandArray[laptop_2_killer]='On REPEAT 2 INTERVAL 30'
		commandArray[printer_killer]='On AFTER 20 REPEAT 2 INTERVAL 10'
	if otherdevices[someonehome] == 'Off' then
		commandArray[someonehome]='On'	
	end			
		event_body = '.............................................................'		
		elseif otherdevices[laptop_switch] == 'On' then
		commandArray[laptop_2_killer]='On REPEAT 2 INTERVAL 30'
		event_body = '.............................................................'	
		end
	end
	
	
	if devicechanged[laptop_2] == 'Off'	
		and otherdevices[laptop_2_killer] == 'On'
	    and otherdevices[pico_power]   == 'On'		
	then
	
		if otherdevices[laptop_3] == 'Off' and otherdevices[laptop_1] == 'Off' then		
		commandArray[laptop_switch]='Off'
		commandArray[laptop_2_killer]='Off REPEAT 2 INTERVAL 30'
		commandArray[printer_killer]='Off AFTER 20 REPEAT 2 INTERVAL 10'		
		event_body = '.............................................................'		

     	elseif otherdevices[laptop_3] == 'On' or otherdevices[laptop_1] == 'On'  then
		commandArray[laptop_2_killer]='Off REPEAT 2 INTERVAL 30'	
		event_body = '.............................................................'	
		end
		
	end	
--
-- **********************************************************
-- Laptop 3 ON/OFF
-- **********************************************************
--
	if devicechanged[laptop_3] == 'On' 
		and otherdevices[laptop_switch] == 'Off'
	then
		commandArray[laptop_switch]='On'
		commandArray[printer_killer]='On'
	if otherdevices[someonehome] == 'Off' then
		commandArray[someonehome]='On'	
	end		
		event_body = '.............................................................'		
	end
	
	if devicechanged[laptop_3] == 'Off'
	    and otherdevices[pico_power]   == 'On'	
		and otherdevices[laptop_2] == 'Off'
		and otherdevices[laptop_1] == 'Off' 
		and otherdevices[laptop_switch] == 'On'
	then	
		commandArray[laptop_switch]='Off'
		commandArray[printer_killer]='Off AFTER 20 REPEAT 2 INTERVAL 10'		
		event_body = '.............................................................'		
	end