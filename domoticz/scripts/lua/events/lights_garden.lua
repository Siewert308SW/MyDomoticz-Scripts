--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_garden.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 16-4-2017
	@ Script to switch garden light ON/OFF when IsDark taking in count IsWeekend or IsNotWeekend
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]] 

	local Package_Path = debug.getinfo(1).source:match("@?(.*/)")
	package.path = package.path .. ';' .. Package_Path .. '?.lua'
	package.path = package.path .. ';' .. Package_Path .. 'config/?.lua'
    require "functions"

-- IsDark Switches															-- Various Switches
	local isdark_garden_lights_trigger 	= 'IsDonker_Tuin_Verlichting'			local someonehome					= 'Iemand Thuis'
	local isdark_sunset					= 'Sunrise/Sunset'						local someonehome_standby			= 'Iemand Thuis - Standby'
	local isdark_standby				= 'IsDonker - Standby'					local nobody_home					= 'Niemand Thuis'
																				local leaving_standby				= 'Vertrek - Standby'

-- Variables																-- Light Switches
	local isdark_garden_lights_variable	= 'IsDonker_Tuin_Verlichting_Standby'	local back_garden_lights			= 'Tuin Schuur Verlichting'
	local garden_lights_verify			= 'Tuin_Verlichting_Verify'				local front_door_light				= 'Tuin Voordeur Verlichting'
	local pico_power_state    			= 'IsPIco_Power_Outage_State'			local border_lights					= 'Tuin Border Verlichting'				local garden_light_switch			= 'Tuin Verlichting Knop'
	local security_activation_type		= 'alarm_ActivationType'
	
-- Scenes
	local garden_lights_scene			= 'Tuinverlichting'
	local visitors						= 'Visite'
	local pico_power    				= 'PIco RPi Powered'
		
	weekend = IsWeekend()
		
--
-- **********************************************************
-- Garden light ON when dark
-- **********************************************************
--

	if devicechanged[isdark_garden_lights_trigger] == 'On'
		and otherdevices[pico_power] == 'On'	
		and otherdevices[isdark_sunset] == 'On'
		and otherdevices[back_garden_lights] == 'Off'
		and uservariables[security_activation_type] == 0		
	then	
		commandArray["Group:" ..garden_lights_scene.. ""]='On REPEAT 2 INTERVAL 20'
		event_body = '.............................................................'	
	end

--
-- **********************************************************
-- Garden light standby ON when some one home
-- **********************************************************
--

	if (time.hour == 22) and (time.min == 45)
		and uservariables[isdark_garden_lights_variable] == 0	
		and otherdevices[someonehome] =='On'		
	then
		commandArray["Variable:" .. isdark_garden_lights_variable .. ""]= '1'	
	end
	
--
-- **********************************************************
-- Garden light OFF when some one at home at is not weekend
-- **********************************************************
--

	if (time.hour == 23) and (time.min == 01)
		and otherdevices[isdark_garden_lights_trigger] == 'On'
		and otherdevices[back_garden_lights] ~= 'Off'
		and uservariables[isdark_garden_lights_variable] == 1
		and weekend == 0		
		and otherdevices[someonehome] =='On'
		and uservariables[garden_lights_verify]   == 0
		and otherdevices[pico_power] == 'On'	
		and uservariables[security_activation_type] == 0		
	then	
		commandArray["Group:" ..garden_lights_scene.. ""]='Off REPEAT 3 INTERVAL 20'	
		commandArray["Variable:" .. garden_lights_verify .. ""]= '1'
		--event_body = '.............................................................'		
	end
	
--
-- **********************************************************
-- Garden light OFF when nobody is home and IsNotWeekend
-- **********************************************************
--

	if (time.hour == 23) and (time.min == 01)
		and otherdevices[isdark_garden_lights_trigger] == 'On'
		and otherdevices[back_garden_lights] ~= 'Off'
		and uservariables[isdark_garden_lights_variable] == 0
		and uservariables[garden_lights_verify]   == 0
		and weekend == 0
		and otherdevices[someonehome] =='Off'
		and otherdevices[pico_power] == 'On'
		and uservariables[security_activation_type] == 0		
	then			
		commandArray["Group:" ..garden_lights_scene.. ""]='Off REPEAT 3 INTERVAL 20'		
		commandArray["Variable:" .. garden_lights_verify .. ""]= '1'
		--event_body = '.............................................................'		
	end		

--
-- **********************************************************
-- Garden light OFF when nobody is home and IsWeekend
-- **********************************************************
--

	if (time.hour == 23) and (time.min == 59)
		and otherdevices[isdark_garden_lights_trigger] == 'On'
		and otherdevices[back_garden_lights] ~= 'Off'
		and uservariables[isdark_garden_lights_variable] == 0
		and uservariables[garden_lights_verify]   == 0
		and weekend == 1	
		and otherdevices[someonehome] =='Off'	
		and otherdevices[pico_power] == 'On'
		and uservariables[security_activation_type] == 0		
	then			
		commandArray["Group:" ..garden_lights_scene.. ""]='Off REPEAT 3 INTERVAL 20'	
		commandArray["Variable:" .. garden_lights_verify .. ""]= '1'
		--event_body = '.............................................................'		
	end

--
-- **********************************************************
-- Garden light OFF when IsDark OFF
-- **********************************************************
--

	if devicechanged[isdark_garden_lights_trigger] == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then	
		commandArray["Group:" ..garden_lights_scene.. ""]='Off AFTER 50 REPEAT 2 INTERVAL 20'	
		commandArray["Variable:" .. garden_lights_verify .. ""]= '0'
		commandArray["Variable:" .. isdark_garden_lights_variable .. ""]= '0'
		event_body = '.............................................................'		
	end

--
-- **********************************************************
-- Garden lights OFF when Nobody at home
-- **********************************************************
--

	if devicechanged[someonehome] == 'Off'	
		and otherdevices[leaving_standby]   == 'Off'		
		and otherdevices[back_garden_lights] ~= 'Off'
		and uservariables[isdark_garden_lights_variable] == 1	
		and otherdevices[pico_power] == 'On'
		and uservariables[security_activation_type] == 0		
	then	
		commandArray["Group:" ..garden_lights_scene.. ""]='Off AFTER 120 REPEAT 3 INTERVAL 20'		
		--event_body = '.............................................................'		
	end
	
--
-- **********************************************************
-- Garden lights ON after power outage
-- **********************************************************
--

	if devicechanged[pico_power] == 'On'
		and otherdevices[isdark_garden_lights_trigger] == 'On'		
		and otherdevices[back_garden_lights] == 'Off'
		and timebetween("15:00:00","22:30:00") 		
	then	
		commandArray["Group:" ..garden_lights_scene.. ""]='On AFTER 60 REPEAT 2 INTERVAL 20'		
		event_body = '.............................................................'		
	end	