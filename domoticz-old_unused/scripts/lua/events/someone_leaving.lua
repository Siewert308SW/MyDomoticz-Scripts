--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ someone_leaving.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 12-4-2017
	@ Script to switch Garden Lights when OFF and someone is leaving the house
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Devices
	local phone_1 						= 'Jerina GSM'
	local phone_2 						= 'Siewert GSM'
	local phone_3 						= 'Natalya GSM'
	local phone_switch 					= 'Telefoons'

-- Various Switches
	local someonehome					= 'Iemand Thuis'
	local someonehome_standby			= 'Iemand Thuis - Standby'
	local nobody_home					= 'Niemand Thuis'
	local isdark_standby				= 'IsDonker - Standby'
	local leaving_standby				= 'Vertrek - Standby'
	local arriving_standby				= 'Aankomst - Standby'
	local isdark_sunset					= 'Sunrise/Sunset'
	local isdark_garden_lights_trigger 	= 'IsDonker_Tuin_Verlichting'
	local pico_power    				= 'PIco RPi Powered'	

-- Various variables
	local front_door_acivity			= 'IsFrontDoor_Acivity'
	local timeout 						= 180
	local security_activation_type		= 'alarm_ActivationType'
	
-- Scenes
	local garden_lights_leave_scene		= 'Tuinverlichting Vertrek'

-- Light Switches
	local front_door_light				= 'Tuin Voordeur Verlichting'
	local shed_lights					= 'Tuin Schuur Verlichting'

-- Door/Window Sensors
	local frontdoor						= 'Voor Deur'
	local backdoor			 			= 'Achter Deur'
	local sliding_door	 				= 'Schuifpui'
	local livingroom_door	 			= 'Kamer Deur'

--
-- **********************************************************
-- Some one left via the frontdoor
-- **********************************************************
--

if devicechanged[frontdoor] == 'Open' and otherdevices[backdoor] == 'Closed'
	and otherdevices[arriving_standby]   == 'Off'
	and otherdevices[leaving_standby]   == 'Off'		
	and otherdevices[someonehome]   == 'On'	
	and otherdevices[shed_lights]   == 'Off'
	and otherdevices[pico_power]   == 'On'	
	and otherdevices[isdark_garden_lights_trigger]   == 'On'
	and otherdevices[isdark_standby]   == 'On'	
	and otherdevices[isdark_sunset]   == 'On'
	and uservariables[security_activation_type] == 0	
	--and timedifference(otherdevices_lastupdate[frontdoor]) > timeout
	and timedifference(otherdevices_lastupdate[livingroom_door]) < timeout	
then
		commandArray[leaving_standby]='On'	
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='On AFTER 1 REPEAT 2 INTERVAL 5'
		event_body = '.............................................................'		
end

--
--
-- **********************************************************
-- Some one left via backdoor
-- **********************************************************
--

if devicechanged[backdoor] == 'Open' and otherdevices[frontdoor] == 'Closed'
	and otherdevices[arriving_standby]   == 'Off'
	and otherdevices[leaving_standby]   == 'Off'		
	and otherdevices[someonehome]   == 'On'	
	and otherdevices[shed_lights]   == 'Off'
	and otherdevices[pico_power]   == 'On'	
	and otherdevices[isdark_garden_lights_trigger]   == 'On'
	and otherdevices[isdark_standby]   == 'On'	
	and otherdevices[isdark_sunset]   == 'On'
	and uservariables[security_activation_type] == 0	
then
		commandArray[leaving_standby]='On'
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='On AFTER 1 REPEAT 2 INTERVAL 5'
		event_body = '.............................................................'	
end

--
-- **********************************************************
-- Some one opened the sliding door
-- **********************************************************
--

if devicechanged[sliding_door] == 'Open' and otherdevices[frontdoor] == 'Closed' and otherdevices[backdoor] == 'Closed'
	and otherdevices[arriving_standby]   == 'Off'
	and otherdevices[leaving_standby]   == 'Off'		
	and otherdevices[someonehome]   == 'On'	
	and otherdevices[shed_lights]   == 'Off'
	and otherdevices[pico_power]   == 'On'	
	and otherdevices[isdark_garden_lights_trigger]   == 'On'
	and otherdevices[isdark_standby]   == 'On'	
	and otherdevices[isdark_sunset]   == 'On'
	and uservariables[security_activation_type] == 0	
then
		commandArray[leaving_standby]='On'
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='On AFTER 1 REPEAT 2 INTERVAL 5'
		event_body = '.............................................................'
end

if  devicechanged[sliding_door] == 'Closed' 
	and otherdevices[frontdoor] == 'Closed' 
	and otherdevices[backdoor] == 'Closed' 
	and otherdevices[shed_lights]   ~= 'Off' 
	and otherdevices[leaving_standby]   == 'On'
	and otherdevices[pico_power]   == 'On'
	and uservariables[security_activation_type] == 0	
then		
		commandArray[leaving_standby]='Off AFTER 30'	
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='Off AFTER 15 REPEAT 3 INTERVAL 10'
		event_body = '.............................................................'	
end

--
-- **********************************************************
-- Some one leaving - Device offline
-- **********************************************************
--

if  devicechanged[phone_1] == 'Off'
	and otherdevices[shed_lights]   ~= 'Off'
	and otherdevices[leaving_standby]   == 'On'	
then	
		commandArray[leaving_standby]='Off AFTER 30'		
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='Off AFTER 15 REPEAT 3 INTERVAL 10'
		event_body = '.............................................................'
end

if  devicechanged[phone_2] == 'Off'
	and otherdevices[shed_lights]   ~= 'Off'
	and otherdevices[leaving_standby]   == 'On'
then	
		commandArray[leaving_standby]='Off AFTER 30'		
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='Off AFTER 15 REPEAT 3 INTERVAL 10'
		event_body = '.............................................................'		
end

if  devicechanged[phone_3] == 'Off'
	and otherdevices[shed_lights]   ~= 'Off'
	and otherdevices[leaving_standby]   == 'On'
then	
		commandArray[leaving_standby]='Off AFTER 30'		
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='Off AFTER 15 REPEAT 3 INTERVAL 10'	
		event_body = '.............................................................'		
end

if  devicechanged[phone_4] == 'Off'
	and otherdevices[shed_lights]   ~= 'Off'
	and otherdevices[leaving_standby]   == 'On'
then	
		commandArray[leaving_standby]='Off AFTER 30'		
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='Off AFTER 15 REPEAT 3 INTERVAL 10'	
		event_body = '.............................................................'		
end

--
-- **********************************************************
-- Standby OFF When some one left
-- **********************************************************
--

if  devicechanged[leaving_standby] == 'Off' 
	    and otherdevices[pico_power]   == 'On'
then		
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='Off AFTER 15 REPEAT 3 INTERVAL 10'
		event_body = '.............................................................'		
end
