--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ someone_home.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script for switching SomeOneHome ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Devices														-- Various Switches
	local laptop_switch 				= 'Laptops'					local someonehome					= 'Iemand Thuis'
	local television 					= 'Televisie'				local someonehome_standby			= 'Iemand Thuis - Standby'
	local phone_switch 					= 'Telefoons'				local nobody_home					= 'Niemand Thuis'
	local media_switch 					= 'Media'					local nest_away						= 'Nest - Away'
																	local sirene_loop					= 'Rookmelder - Loop'
																	local security_activation_type		= 'alarm_ActivationType'
-- Scenes														-- UPS
	local nobody_home_scene				= 'Nobody Home'				local pico_power    				= 'PIco RPi Powered'
	local nobody_home_scene_nomedia		= 'Nobody Home NoMedia'		local pico_power_scene    			= 'Power Outage'
																	local IsPIco_Power_Outage_State    	= 'IsPIco_Power_Outage_State'																	
-- Door/Window Sensors	
	local frontdoor						= 'Voor Deur'
	local backdoor			 			= 'Achter Deur'
	local livingroom_door				= 'Kamer Deur'
	local sliding_door	 				= 'Schuifpui'
	local scullery_door 				= 'Bijkeuken Deur'
	local motion_upstairs 				= 'Trap Motion Boven'

	doors = (devicechanged[livingroom_door] or devicechanged[frontdoor] or devicechanged[backdoor] or devicechanged[sliding_door] or devicechanged[scullery_door])	
--
--
-- **********************************************************
-- Some One Home when a sensor is triggered
-- **********************************************************
--

	if doors 
		and otherdevices[someonehome] == 'Off' 
		and otherdevices[someonehome_standby] == 'Off' 
		and otherdevices[pico_power] == 'On' 
		and otherdevices[nobody_home] == 'On' 
		and otherdevices[sirene_loop] == 'Off'
		and uservariables[security_activation_type] == 0	
	then	
			commandArray[someonehome]='On'
	end
	
	if devicechanged[motion_upstairs] 
		and otherdevices[someonehome] == 'Off' 
		and otherdevices[someonehome_standby] == 'Off' 
		and otherdevices[pico_power] == 'On' 
		and otherdevices[nobody_home] == 'On' 
		and otherdevices[livingroom_door] == 'Open' 
		and otherdevices[sirene_loop] == 'Off' 
		and uservariables[security_activation_type] == 0	
	then		
			commandArray[someonehome]='On'		
	end
	
--
-- **********************************************************
-- Some one home OFF when Nest - Away kicks in
-- **********************************************************
--
	
	if devicechanged[nest_away] == 'On'		
		and otherdevices[someonehome] == 'On'
		and uservariables[security_activation_type] == 0		
	then	
		commandArray[someonehome]='Off'
		commandArray[someonehome_standby]='Off AFTER 15'
		commandArray[nobody_home]='On AFTER 30'	
	end
	
--
-- **********************************************************
-- Nobody home - Kill all lights and standbykiller
-- **********************************************************
--
	
	if devicechanged[nobody_home] == 'On'		
		and otherdevices[someonehome] == 'Off' and otherdevices[media_switch] == 'On' and uservariables[security_activation_type] == 0
	then	
		commandArray["Scene:" ..nobody_home_scene.. ""]='On REPEAT 2 INTERVAL 30'		
	end

	if devicechanged[nobody_home] == 'On'		
		and otherdevices[someonehome] == 'Off' and otherdevices[media_switch] == 'Off' and uservariables[security_activation_type] == 0
	then	
		commandArray["Scene:" ..nobody_home_scene_nomedia.. ""]='On REPEAT 2 INTERVAL 30'		
	end		
	
--
-- **********************************************************
-- Power Outage Event (Shutdown House)
-- **********************************************************
--
--[[
	if devicechanged[pico_power] == 'Off' and otherdevices[someonehome] == 'On'
	then
		event_body = 'Seem like you have been hit by a power outage, shutting down...'	
		commandArray["Variable:" .. IsPIco_Power_Outage_State .. ""]= '1'	
		commandArray[someonehome]='Off'
		commandArray[someonehome_standby]='Off AFTER 1'
		commandArray[nobody_home]='On AFTER 2'
		commandArray["Group:" ..pico_power_scene.. ""]='Off'
	end
	
	if devicechanged[pico_power] == 'Off' and otherdevices[someonehome] == 'Off'
	then
		event_body = 'Seem like you have been hit by a power outage, shutting down...'		
		commandArray["Variable:" .. IsPIco_Power_Outage_State .. ""]= '0'
		commandArray["Group:" ..pico_power_scene.. ""]='Off'		
	end
	
--
-- **********************************************************
-- Power Outage Event (restore events)
-- **********************************************************
--

	if devicechanged[pico_power] == 'On' and uservariables[IsPIco_Power_Outage_State]   == 1
	then
		event_body = 'Seem like power has been restored...'		
		commandArray[someonehome]='On'
	end	
--]]	
	