--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_hallway.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script for switching hallway light when someone is entering the house
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Door/Window Sensors	
	local frontdoor						= 'Voor Deur'
	local backdoor			 			= 'Achter Deur'
	local livingroom_door				= 'Kamer Deur'
	local motion_upstairs 				= 'Trap Motion Boven'
	local motion_toilet					= 'W.C Motion'
	
-- Standby Switches
	local doorbell_standby 				= 'Deurbel - Standby'
	local leaving_standby				= 'Vertrek - Standby'
	local arriving_standby				= 'Aankomst - Standby'
	local walktrue_standby				= 'Doorloop - Standby'
	local pico_power					= 'PIco RPi Powered'
	
-- Various locals 
	local front_door_acivity			= 'IsFrontdoor_Acitivity'
	local timeout_short 			    = 10
	local timeout_long 					= 59	
	local security_activation_type		= 'alarm_ActivationType'
	
-- IsDark Switches
	local isdark_living_room_trigger_2	= 'IsDonker_Woonkamer_2'
	local isdark_sunset					= 'Sunrise/Sunset'
	local isdark_standby				= 'IsDonker - Standby'
	
-- Lights
	local hallway_light					= 'Gang Wandlamp'
	local toilet_light					= 'W.C Lamp'


 
--
-- **********************************************************
-- Hallway light ON/OFF when someone is arriving when IsDark
-- **********************************************************
--

	if devicechanged[livingroom_door] == 'Open'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[walktrue_standby]   == 'Off'
		and otherdevices[leaving_standby]   == 'Off'
		and otherdevices[doorbell_standby]   == 'Off'		
		and otherdevices[frontdoor]   == 'Closed'
		and otherdevices[hallway_light]   == 'Off'
	    and otherdevices[isdark_standby]   == 'Off'
	    and otherdevices[isdark_sunset]   == 'On'		
	    and otherdevices[pico_power]   == 'On'		
		and otherdevices[isdark_living_room_trigger_2]   == 'On'		
		and uservariables[front_door_acivity]   == 0
		and timebetween("15:00:00","22:00:00")	
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate[frontdoor]) > timeout_short
		and timedifference(otherdevices_lastupdate[motion_upstairs]) > timeout_short	
		and timedifference(otherdevices_lastupdate[motion_toilet]) > timeout_short
		and timedifference(otherdevices_lastupdate[doorbell_standby]) > timeout_short
		and timedifference(otherdevices_lastupdate[leaving_standby]) > timeout_short
		and timedifference(otherdevices_lastupdate[arriving_standby]) > timeout_short
		and timedifference(otherdevices_lastupdate[walktrue_standby]) > timeout_short		
	then
		commandArray[walktrue_standby]='On'	
		commandArray["Variable:" .. front_door_acivity .. ""]= '1'	
		commandArray[hallway_light]='On AFTER 1'
		event_body = '.............................................................'	
	end
	
	if devicechanged[livingroom_door] == 'Closed'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[walktrue_standby]   == 'On'
		and otherdevices[leaving_standby]   == 'Off'
		and otherdevices[doorbell_standby]   == 'Off'		
		and otherdevices[frontdoor]   == 'Closed'
		and otherdevices[hallway_light]   == 'On'
	    and otherdevices[isdark_standby]   == 'Off'
	    and otherdevices[isdark_sunset]   == 'On'		
	    and otherdevices[pico_power]   == 'On'		
		and otherdevices[isdark_living_room_trigger_2]   == 'On'		
		and uservariables[front_door_acivity]   == 1 	
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate[frontdoor]) > timeout_long
		and timedifference(otherdevices_lastupdate[motion_upstairs]) > timeout_long	
		and timedifference(otherdevices_lastupdate[motion_toilet]) > timeout_short
		and timedifference(otherdevices_lastupdate[doorbell_standby]) > timeout_long
		and timedifference(otherdevices_lastupdate[leaving_standby]) > timeout_long
		and timedifference(otherdevices_lastupdate[arriving_standby]) > timeout_long
		and timedifference(otherdevices_lastupdate[walktrue_standby]) > timeout_long		
	then
		commandArray[walktrue_standby]='Off AFTER 10'	
		commandArray["Variable:" .. front_door_acivity .. ""]= '0'	
		commandArray[hallway_light]='Off AFTER 15'
		event_body = '.............................................................'		
	end
	
--------------------------------------------------------------------------------------------------------------------------	
	
	if devicechanged[motion_upstairs] == 'On'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[walktrue_standby]   == 'Off'
		and otherdevices[leaving_standby]   == 'Off'
		and otherdevices[doorbell_standby]   == 'Off'		
		and otherdevices[frontdoor]   == 'Closed'
		and otherdevices[livingroom_door]   == 'Closed'		
		and otherdevices[hallway_light]   == 'Off'
	    and otherdevices[isdark_standby]   == 'Off'	
	    and otherdevices[isdark_sunset]   == 'On'	
	    and otherdevices[pico_power]   == 'On'		
		and otherdevices[isdark_living_room_trigger_2]   == 'On'		
		and uservariables[front_door_acivity]   == 0
		and timebetween("15:00:00","22:00:00")	 	
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate[frontdoor]) > timeout_short
		and timedifference(otherdevices_lastupdate[livingroom_door]) > timeout_short	
		and timedifference(otherdevices_lastupdate[motion_toilet]) > timeout_short
		and timedifference(otherdevices_lastupdate[doorbell_standby]) > timeout_short
		and timedifference(otherdevices_lastupdate[leaving_standby]) > timeout_short
		and timedifference(otherdevices_lastupdate[arriving_standby]) > timeout_short
		and timedifference(otherdevices_lastupdate[walktrue_standby]) > timeout_short		
	then
		commandArray[walktrue_standby]='On'	
		commandArray["Variable:" .. front_door_acivity .. ""]= '1'	
		commandArray[hallway_light]='On AFTER 1'
		event_body = '.............................................................'	
	end	
	
	if devicechanged[toilet_light] == 'Off'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[walktrue_standby]   == 'Off'
		and otherdevices[leaving_standby]   == 'Off'
		and otherdevices[doorbell_standby]   == 'Off'		
		and otherdevices[frontdoor]   == 'Closed'
		and otherdevices[livingroom_door]   == 'Closed'		
		and otherdevices[hallway_light]   == 'Off'
	    and otherdevices[isdark_standby]   == 'Off'	
	    and otherdevices[isdark_sunset]   == 'On'		
		and otherdevices[isdark_living_room_trigger_2]   == 'On'	
	    and otherdevices[pico_power]   == 'On'		
		and uservariables[front_door_acivity]   == 0
		and uservariables[security_activation_type] == 0		
		and timebetween("15:00:00","22:00:00")			
		and timedifference(otherdevices_lastupdate[frontdoor]) > timeout_short
		and timedifference(otherdevices_lastupdate[livingroom_door]) > timeout_short
		and timedifference(otherdevices_lastupdate[doorbell_standby]) > timeout_short
		and timedifference(otherdevices_lastupdate[leaving_standby]) > timeout_short
		and timedifference(otherdevices_lastupdate[arriving_standby]) > timeout_short
		and timedifference(otherdevices_lastupdate[walktrue_standby]) > timeout_short		
	then
		commandArray[walktrue_standby]='On'	
		commandArray["Variable:" .. front_door_acivity .. ""]= '1'	
		commandArray[hallway_light]='On AFTER 1'
		event_body = '.............................................................'		
	end	

	if devicechanged[walktrue_standby] == 'On' and uservariables[security_activation_type] == 0		
	then		
		commandArray[hallway_light]='On'
	end	 
	
	if devicechanged[walktrue_standby] == 'Off'	and uservariables[security_activation_type] == 0	
	then		
		commandArray[hallway_light]='Off AFTER 3'
		commandArray["Variable:" .. front_door_acivity .. ""]= '0'
	end		