--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ someone_arriving.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script for switching hallway light when someone is entering the house
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]	 

-- Door/Window Sensors
	local frontdoor						= 'Voor Deur'	
	local scullery_door					= 'Bijkeuken Deur'
	local backdoor			 			= 'Achter Deur'
	local livingroom_door				= 'Kamer Deur'
	local motion_upstairs 				= 'Trap Motion Boven'
	local motion_toilet					= 'W.C Motion'
	
-- Standby Switches
	local doorbell_standby 				= 'Deurbel - Standby'
	local leaving_standby				= 'Vertrek - Standby'
	local arriving_standby				= 'Aankomst - Standby'
	local walktrue_standby				= 'Doorloop - Standby'
	
-- Various locals 
	local front_door_acivity			= 'IsFrontdoor_Acitivity'
	local timeout 						= 59
	local pico_power					= 'PIco RPi Powered'
	local security_activation_type		= 'alarm_ActivationType'
	
-- IsDark Switches
	local isdark_living_room_trigger_2	= 'IsDonker_Woonkamer_2'
	local isdark_sunset					= 'Sunrise/Sunset'
	local isdark_standby				= 'IsDonker - Standby'
	
-- Lights
	local hallway_light					= 'Gang Wandlamp'
	local scullery_light				= 'Bijkeuken Lamp'

--
-- **********************************************************
-- Hallway light ON/OFF when someone is arriving when IsDark
-- **********************************************************
--

	if devicechanged[frontdoor] == 'Open'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[walktrue_standby]   == 'Off'
		and otherdevices[leaving_standby]   == 'Off'		
		and otherdevices[livingroom_door]   == 'Closed'
		and otherdevices[doorbell_standby]   == 'Off'		
		and otherdevices[hallway_light]   == 'Off'
	    and otherdevices[isdark_standby]   == 'Off'	
	    and otherdevices[isdark_sunset]   == 'On'		
		and otherdevices[isdark_living_room_trigger_2]   == 'On'
	    and otherdevices[pico_power]   == 'On'		
		--and timebetween("15:00:00","23:30:00")	 		
		and uservariables[front_door_acivity]   == 0
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate[livingroom_door]) > timeout
		and timedifference(otherdevices_lastupdate[motion_upstairs]) > timeout	
		and timedifference(otherdevices_lastupdate[motion_toilet]) > timeout
		and timedifference(otherdevices_lastupdate[doorbell_standby]) > timeout
		and timedifference(otherdevices_lastupdate[leaving_standby]) > timeout
		and timedifference(otherdevices_lastupdate[arriving_standby]) > timeout
		and timedifference(otherdevices_lastupdate[walktrue_standby]) > timeout		
	then
		commandArray[arriving_standby]='On'	
		commandArray["Variable:" .. front_door_acivity .. ""]= '1'	
		commandArray[hallway_light]='On AFTER 1 REPEAT 2 INTERVAL 1'
		event_body = '.............................................................'		
	end

	if devicechanged[arriving_standby] == 'Off'		
	then		
		commandArray[hallway_light]='Off AFTER 15 REPEAT 3 INTERVAL 5'
		commandArray["Variable:" .. front_door_acivity .. ""]= '0'
	end	

	if devicechanged[livingroom_door] == 'Closed'
		and otherdevices[frontdoor]   == 'Closed'
		and otherdevices[arriving_standby]   == 'On'		
		and otherdevices[hallway_light]   == 'On'
		and uservariables[front_door_acivity]   == 1
		and timedifference(otherdevices_lastupdate[frontdoor]) > 10		
	then		
		commandArray[hallway_light]='Off AFTER 5 REPEAT 3 INTERVAL 3'
		commandArray[arriving_standby]='Off'		
		commandArray["Variable:" .. front_door_acivity .. ""]= '0'
		event_body = '.............................................................'		
	end	

--
-- **********************************************************
-- Scullery light ON/OFF when someone is arriving when IsDark
-- **********************************************************
--

	if devicechanged[backdoor] == 'Open'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[walktrue_standby]   == 'Off'
		and otherdevices[leaving_standby]   == 'Off'		
		and otherdevices[scullery_door]   == 'Closed'		
		and otherdevices[scullery_light]   == 'Off'
	    and otherdevices[isdark_standby]   == 'Off'	
	    and otherdevices[isdark_sunset]   == 'On'		
		and otherdevices[isdark_living_room_trigger_2]   == 'On'
	    and otherdevices[pico_power]   == 'On'		
		--and timebetween("15:00:00","23:30:00")	 		
		and uservariables[front_door_acivity]   == 0
		and uservariables[security_activation_type] == 0
		and timedifference(otherdevices_lastupdate[scullery_door]) > timeout
		and timedifference(otherdevices_lastupdate[doorbell_standby]) > timeout
		and timedifference(otherdevices_lastupdate[leaving_standby]) > timeout
		and timedifference(otherdevices_lastupdate[arriving_standby]) > timeout	
	then
		commandArray[arriving_standby]='On'	
		commandArray["Variable:" .. front_door_acivity .. ""]= '2'	
		commandArray[scullery_light]='Set Level 50 AFTER 1 REPEAT 2 INTERVAL 1'
		event_body = '.............................................................'		
	end

	if devicechanged[arriving_standby] == 'Off'		
	then		
		commandArray[scullery_light]='Off AFTER 15 REPEAT 3 INTERVAL 5'
		commandArray["Variable:" .. front_door_acivity .. ""]= '0'
	end	

	if devicechanged[scullery_door] == 'Closed'
		and otherdevices[backdoor]   == 'Closed'
		and otherdevices[arriving_standby]   == 'On'		
		and otherdevices[scullery_light]   ~= 'Off'
		and uservariables[front_door_acivity]   == 2
		and timedifference(otherdevices_lastupdate[backdoor]) > 10		
	then		
		commandArray[scullery_light]='Off AFTER 5 REPEAT 3 INTERVAL 3'
		commandArray[arriving_standby]='Off'		
		commandArray["Variable:" .. front_door_acivity .. ""]= '0'
		event_body = '.............................................................'		
	end	
