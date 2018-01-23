--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom_away.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script to switch ON/OFF Away light scene when nobody at home taking in count IsWeekend or IsNotWeekend
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

	local Package_Path = debug.getinfo(1).source:match("@?(.*/)")
	package.path = package.path .. ';' .. Package_Path .. '?.lua'
	package.path = package.path .. ';' .. Package_Path .. 'config/?.lua'
    require "functions"

-- IsDark Switches													-- Lights
	local isdark_living_room_trigger2		= 'IsDonker_Woonkamer_1'	local twilight_light					= 'Woonkamer Schemerlamp'
	local isdark_standby					= 'IsDonker - Standby'

-- Various Switches													-- Scenes
	local someonehome						= 'Iemand Thuis'			local scene_away						= 'Woonkamer_Away'
	local someonehome_standby				= 'Iemand Thuis - Standby'
	local pico_power						= 'PIco RPi Powered'
	
-- Variables
	local iskerst							= 'Feestdagen'
	local away_lights_verify				= 'Away_Verlichting_Verify'
	local pico_power_state    				= 'IsPIco_Power_Outage_State'
	local security_activation_type			= 'alarm_ActivationType'	

	weekend = IsWeekend()	
--
-- **********************************************************
-- Twilight Scene ON when dark, nobody home activated and IsNotXmas
-- **********************************************************
--

	if devicechanged[someonehome]   == 'Off'
	    and otherdevices[pico_power]   == 'On'	
		and otherdevices[isdark_living_room_trigger2]   == 'On'		
		and otherdevices[twilight_light]  == 'Off'
		and otherdevices[iskerst] == 'Off'	
		and uservariables[away_lights_verify]   == 0
		and uservariables[security_activation_type] == 0	
		and timebetween("15:00:00","22:00:00")	 
	then
		commandArray["Group:" ..scene_away.. ""]='On REPEAT 2 INTERVAL 15'
		event_body = '.............................................................'
	end
	
---------------------------
	
	if devicechanged[isdark_living_room_trigger2]   == 'On'
	    and otherdevices[pico_power]   == 'On'	
		and otherdevices[someonehome]   == 'Off'
		and otherdevices[twilight_light]  == 'Off' 
		and otherdevices[iskerst] == 'Off'
		and uservariables[away_lights_verify]   == 0
		and uservariables[security_activation_type] == 0	
		and timebetween("15:00:00","22:30:00")	 
	then	
		commandArray["Group:" ..scene_away.. ""]='On REPEAT 2 INTERVAL 15'
		event_body = '.............................................................'		
	end	

--
-- **********************************************************
-- Twilight Scene OFF when IsNotWeekend and IsNotXmas
-- **********************************************************
--

	if (time.hour == 23) and (time.min == 00)
	    and otherdevices[pico_power]   == 'On'	
		and otherdevices[someonehome]   == 'Off'		
		and otherdevices[isdark_living_room_trigger2]   == 'On'	
		and otherdevices[twilight_light]  ~= 'Off'				
		and weekend == 0
		and otherdevices[iskerst] == 'Off'
		and uservariables[away_lights_verify]   == 0
		and uservariables[security_activation_type] == 0	
	then	
		commandArray["Group:" ..scene_away.. ""]='Off REPEAT 2 INTERVAL 15'	
		commandArray["Variable:" .. away_lights_verify .. ""]= '1'
		event_body = '.............................................................'	
	end	
	
--
-- **********************************************************
-- Twilight Scene OFF when IsWeekend and IsNotXmas
-- **********************************************************
--

	if (time.hour == 23) and (time.min == 45)
	    and otherdevices[pico_power]   == 'On'	
		and otherdevices[someonehome]   == 'Off'		
		and otherdevices[isdark_living_room_trigger2]   == 'On'		
		and otherdevices[twilight_light]  ~= 'Off'				
		and weekend == 1
		and otherdevices[iskerst] == 'Off'	
		and uservariables[away_lights_verify]   == 0
		and uservariables[security_activation_type] == 0	
	then	
		commandArray["Group:" ..scene_away.. ""]='Off REPEAT 2 INTERVAL 15'		
		commandArray["Variable:" .. away_lights_verify .. ""]= '1'	
		event_body = '.............................................................'		
	end

	if devicechanged[isdark_living_room_trigger2] == 'Off'
		and uservariables[away_lights_verify]   == 1
		and uservariables[security_activation_type] == 0	
	then	
		commandArray["Variable:" .. away_lights_verify .. ""]= '0'		
	end	

	if devicechanged[someonehome] == 'On'
		and uservariables[away_lights_verify]   == 1		
	then	
		commandArray["Variable:" .. away_lights_verify .. ""]= '0'		
	end

--
-- **********************************************************
-- Garden lights ON after power outage
-- **********************************************************
--

	if devicechanged[pico_power] == 'On'
		and otherdevices[someonehome]   == 'Off'
		and otherdevices[twilight_light]  == 'Off'
		and otherdevices[isdark_living_room_trigger2]   == 'On'			
		and uservariables[IsPIco_Power_Outage_State]   == 0
		and otherdevices[someonehome]   == 'Off'		
		and timebetween("15:00:00","22:30:00")	 		
	then
		commandArray["Group:" ..scene_away.. ""]='On REPEAT 2 INTERVAL 15'
		event_body = '.............................................................'
	end	
