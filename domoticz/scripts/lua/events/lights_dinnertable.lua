--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_dinnertable.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script to switch diner table light ON/OFF with taking in count Laptops ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]] 

	local laptop_switch 					= 'Laptops'
    local isdark_dinner_table 				= 'IsDonker_Eettafel'
	local dinner_table_light 				= 'Woonkamer Eettafel Lamp'
	local shower_standby					= 'Douche - Standby'
	local pico_power    					= 'PIco RPi Powered'
	local motion_dinnertable    			= 'Motion Eettafel'
	local hood				    			= 'Afzuigkap'
	local isdark_standby					= 'IsDonker - Standby'	
	
-- Variables
	local dinner_table_light_level_low		= 7
	local dinner_table_light_level_high		= 33
	timeon_dinnertable_light				= 1199 	
	local security_activation_type		= 'alarm_ActivationType'
	
deviceChangedON = (devicechanged[laptop_switch] == 'On' or devicechanged[shower_standby] == 'Off')
deviceChangedOFF = (devicechanged[laptop_switch] == 'Off' or devicechanged[shower_standby] == 'On')

--
-- **********************************************************
-- Dinner table light ON/OFF when a laptop is online
-- **********************************************************
--

	if deviceChangedON
		and otherdevices[isdark_dinner_table] == 'On'
		and otherdevices[dinner_table_light] == 'Off'
	    and otherdevices[pico_power]   == 'On'	
		and uservariables[security_activation_type] == 0		
	then
		commandArray[dinner_table_light]='Set Level '..dinner_table_light_level_low..' AFTER 15 REPEAT 2 INTERVAL 1'	
		event_body = '.............................................................'		
	end

----------

	if deviceChangedOFF
		and otherdevices[dinner_table_light] ~= 'Off'
	    and otherdevices[pico_power]   == 'On'	
		and uservariables[security_activation_type] == 0		
	then
		commandArray[dinner_table_light]='Off AFTER 15 REPEAT 2 INTERVAL 1'
		event_body = '.............................................................'	
	end

--
-- **********************************************************
-- Dinner table light ON/OFF when IsDark and a laptop is online
-- **********************************************************
--

	if devicechanged[isdark_dinner_table] == 'On'
		and otherdevices[pico_power] == 'On'	
		and otherdevices[laptop_switch] == 'On'
		and otherdevices[shower_standby]   == 'Off'		
		and otherdevices[dinner_table_light] == 'Off'
		and uservariables[security_activation_type] == 0		
	then
	commandArray[dinner_table_light]='Set Level '..dinner_table_light_level_low..' REPEAT 2 INTERVAL 1'	
		event_body = '.............................................................'		
	end

----------

	if devicechanged[isdark_dinner_table] == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then
	commandArray[dinner_table_light]='Off AFTER 15 REPEAT 2 INTERVAL 1'
		event_body = '.............................................................'	
	end	

--
-- **********************************************************
-- Dinner table light ON/OFF when IsDark and motion is detected
-- **********************************************************
--
--[[
	if devicechanged[motion_dinnertable] == 'On'
		and otherdevices[pico_power] == 'On'	
		and otherdevices[laptop_switch] == 'On'	
		--and otherdevices[hood] == 'On'		
		and otherdevices[isdark_dinner_table] == 'On'	
		and otherdevices[dinner_table_light] == 'Off'
		and otherdevices[isdark_standby]   == 'Off'	
	and timedifference(otherdevices_lastupdate[laptop_switch]) > timeon_dinnertable_light
	and timedifference(otherdevices_lastupdate[dinner_table_light]) > timeon_dinnertable_light		
		--and (tonumber(otherdevices_svalues[dinner_table_light]) ~= 4)		
	then
	commandArray[dinner_table_light]='Set Level '..dinner_table_light_level_low..' AFTER 2'
	event_body = 'Motion detected...'	
	end
	
	if devicechanged[motion_dinnertable] == 'On'
		and otherdevices[pico_power] == 'On'	
		and otherdevices[laptop_switch] == 'Off'	
		--and otherdevices[hood] == 'On'		
		and otherdevices[isdark_dinner_table] == 'On'	
		and otherdevices[dinner_table_light] == 'Off'
		and otherdevices[isdark_standby]   == 'Off'	
	and timedifference(otherdevices_lastupdate[laptop_switch]) > timeon_dinnertable_light
	and timedifference(otherdevices_lastupdate[dinner_table_light]) > timeon_dinnertable_light		
		--and (tonumber(otherdevices_svalues[dinner_table_light]) ~= 4)		
	then
	commandArray[dinner_table_light]='Set Level '..dinner_table_light_level_high..' AFTER 2'
	event_body = 'Motion detected...'	
	end	
--]]	
--[[
	if devicechanged[motion_dinnertable] == 'On'
		and otherdevices[pico_power] == 'On'	
		and otherdevices[laptop_switch] == 'On'	
		and otherdevices[hood] == 'On'		
		and otherdevices[isdark_dinner_table] == 'On'	
		and otherdevices[dinner_table_light] == 'Off'
		and (tonumber(otherdevices_svalues[dinner_table_light]) ~= 4)		
	then
	commandArray[dinner_table_light]='Set Level '..dinner_table_light_level_low..''
	event_body = ''..motion_dinnertable..' activated, '..dinner_table_light..' switched ON...'	
	end
--]]
	
--[[	
	if devicechanged[motion_dinnertable] == 'On'
		and otherdevices[pico_power] == 'On'
		and otherdevices[laptop_switch] == 'Off'
		and otherdevices[hood] == 'Off' -- Afzuigkap lamp aan		
		and otherdevices[isdark_dinner_table] == 'On'	
		and otherdevices[dinner_table_light] == 'Off'		
	then
	commandArray[dinner_table_light]='Set Level '..dinner_table_light_level_low..''
	event_body = ''..motion_dinnertable..' activated, '..dinner_table_light..' switched ON...'	
	end	

	if devicechanged[motion_dinnertable] == 'On'
		and otherdevices[pico_power] == 'On'
		and otherdevices[laptop_switch] == 'Off'
		and otherdevices[hood] == 'On' -- Afzuigkap lamp uit		
		and otherdevices[isdark_dinner_table] == 'On'	
		and otherdevices[dinner_table_light] == 'Off'		
	then
	commandArray[dinner_table_light]='Set Level '..dinner_table_light_level_low..''
	event_body = ''..motion_dinnertable..' activated, '..dinner_table_light..' switched ON...'	
	end		
--]]	