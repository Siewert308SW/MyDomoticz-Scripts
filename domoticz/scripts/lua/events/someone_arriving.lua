--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ someone_arriving.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 20-4-2017
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
	local motion_garden					= 'Tuin Achter Motion'
	
-- Cars
	local car_1							= 'Peugeot308SW'
	
-- Standby Switches
	local doorbell_standby 				= 'Deurbel - Standby'
	local leaving_standby				= 'Vertrek - Standby'
	local arriving_standby				= 'Aankomst - Standby'
	local arriving_garden_standby		= 'Aankomst Tuin - Standby'
	
-- Various locals 
	local frontdoor_acivity				= 'IsFrontdoor_Acitivity'
	local timeout 						= 59
	local pico_power					= 'PIco RPi Powered'
	local security_activation_type		= 'alarm_ActivationType'
	
-- IsDark Switches
	local isdark_living_room_trigger_2	= 'IsDonker_Woonkamer_2'
	local isdark_garden_lights_trigger 	= 'IsDonker_Tuin_Verlichting'	
	local isdark_sunset					= 'Sunrise/Sunset'
	local isdark_standby				= 'IsDonker - Standby'
	
-- Lights
	local hallway_light					= 'Gang Wandlamp'
	local scullery_light				= 'Bijkeuken Lamp'
	local frontdoor_light				= 'Tuin Voordeur Verlichting'
	
-- Scenes
	local garden_lights_leave_scene		= 'Tuinverlichting Vertrek'	
	
--
-- **********************************************************
-- Activate garden lights when motion detected
-- **********************************************************
--

	if devicechanged[motion_garden] == 'On'
		and otherdevices[arriving_garden_standby]   == 'Off'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[leaving_standby]   == 'Off'
		and otherdevices[doorbell_standby]   == 'Off'
		and otherdevices[hallway_light]   == 'Off'		
		and otherdevices[frontdoor_light]   == 'Off'	
	    and otherdevices[isdark_sunset]   == 'On'		
		and otherdevices[isdark_garden_lights_trigger]   == 'On'
	    and otherdevices[pico_power]   == 'On'	 		
		and uservariables[frontdoor_acivity]   == 0
		and uservariables[security_activation_type] == 0		
	then
		commandArray[arriving_garden_standby]='On'	
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='On REPEAT 2 INTERVAL 5'
		event_body = '.............................................................'		
	end	
	
--
-- **********************************************************
-- Activate garden light scene when a car is driving on the driveway
-- **********************************************************
--

	if devicechanged[car_1] == 'On'
		and otherdevices[frontdoor]   == 'Closed'
		and otherdevices[arriving_garden_standby]   == 'Off'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[leaving_standby]   == 'Off'		
		and otherdevices[livingroom_door]   == 'Closed'
		and otherdevices[doorbell_standby]   == 'Off'
		and otherdevices[hallway_light]   == 'Off'		
		and otherdevices[frontdoor_light]   == 'Off'
	    --and otherdevices[isdark_standby]   == 'Off'	
	    and otherdevices[isdark_sunset]   == 'On'		
		and otherdevices[isdark_garden_lights_trigger]   == 'On'
	    and otherdevices[pico_power]   == 'On'		
		--and timebetween("15:00:00","23:30:00")	 		
		and uservariables[frontdoor_acivity]   == 0
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate[livingroom_door]) > timeout
		and timedifference(otherdevices_lastupdate[motion_upstairs]) > timeout	
		and timedifference(otherdevices_lastupdate[motion_toilet]) > timeout
		and timedifference(otherdevices_lastupdate[doorbell_standby]) > timeout
		and timedifference(otherdevices_lastupdate[leaving_standby]) > timeout
		and timedifference(otherdevices_lastupdate[arriving_standby]) > timeout
		and timedifference(otherdevices_lastupdate[arriving_garden_standby]) > timeout		
	then
		commandArray[arriving_garden_standby]='On'	
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='On REPEAT 2 INTERVAL 5'
		event_body = '.............................................................'		
	end

	if devicechanged[arriving_garden_standby] == 'Off'		
	then		
		commandArray["Group:" ..garden_lights_leave_scene.. ""]='Off AFTER 10 REPEAT 2 INTERVAL 5'
	end	
	
--
-- **********************************************************
-- Hallway light ON/OFF when someone is arriving when IsDark
-- **********************************************************
--

	if devicechanged[frontdoor] == 'Open'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[leaving_standby]   == 'Off'		
		and otherdevices[livingroom_door]   == 'Closed'
		and otherdevices[doorbell_standby]   == 'Off'		
		and otherdevices[hallway_light]   == 'Off'
	    --and otherdevices[isdark_standby]   == 'Off'	
	    and otherdevices[isdark_sunset]   == 'On'		
		and otherdevices[isdark_living_room_trigger_2]   == 'On'
	    and otherdevices[pico_power]   == 'On'		
		--and timebetween("15:00:00","23:30:00")	 		
		and uservariables[frontdoor_acivity]   == 0
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate[livingroom_door]) > timeout
		and timedifference(otherdevices_lastupdate[motion_upstairs]) > timeout	
		and timedifference(otherdevices_lastupdate[motion_toilet]) > timeout
		and timedifference(otherdevices_lastupdate[doorbell_standby]) > timeout
		and timedifference(otherdevices_lastupdate[leaving_standby]) > timeout
		and timedifference(otherdevices_lastupdate[arriving_standby]) > timeout	
	then
		commandArray[arriving_standby]='On'	
		commandArray["Variable:" .. frontdoor_acivity .. ""]= '1'	
		commandArray[hallway_light]='On AFTER 1 REPEAT 2 INTERVAL 1'
		event_body = '.............................................................'		
	end

	if devicechanged[arriving_standby] == 'Off'		
	then		
		commandArray[hallway_light]='Off AFTER 15 REPEAT 3 INTERVAL 5'
		commandArray["Variable:" .. frontdoor_acivity .. ""]= '0'
		
		if otherdevices[arriving_garden_standby] == 'On'		
		then
			commandArray[arriving_garden_standby]='Off AFTER 50'
		end
		
	end	

	if devicechanged[livingroom_door] == 'Closed'
		and otherdevices[frontdoor]   == 'Closed'
		and otherdevices[arriving_standby]   == 'On'		
		and otherdevices[hallway_light]   == 'On'
		and uservariables[frontdoor_acivity]   == 1
		and timedifference(otherdevices_lastupdate[frontdoor]) > 3		
	then		
		commandArray[hallway_light]='Off AFTER 5 REPEAT 3 INTERVAL 3'
		commandArray[arriving_standby]='Off AFTER 1'		
		commandArray["Variable:" .. frontdoor_acivity .. ""]= '0'
		
		if otherdevices[arriving_garden_standby] == 'On'		
		then
			commandArray[arriving_garden_standby]='Off AFTER 50'
		end
				
		event_body = '.............................................................'		
	end	

--
-- **********************************************************
-- Scullery light ON/OFF when someone is arriving when IsDark
-- **********************************************************
--

	if devicechanged[backdoor] == 'Open'
		and otherdevices[arriving_standby]   == 'Off'
		and otherdevices[leaving_standby]   == 'Off'		
		and otherdevices[scullery_door]   == 'Closed'		
		and otherdevices[scullery_light]   == 'Off'
	    --and otherdevices[isdark_standby]   == 'Off'	
	    and otherdevices[isdark_sunset]   == 'On'		
		and otherdevices[isdark_living_room_trigger_2]   == 'On'
	    and otherdevices[pico_power]   == 'On'		
		--and timebetween("15:00:00","23:30:00")	 		
		and uservariables[frontdoor_acivity]   == 0
		and uservariables[security_activation_type] == 0
		and timedifference(otherdevices_lastupdate[scullery_door]) > timeout
		and timedifference(otherdevices_lastupdate[doorbell_standby]) > timeout
		and timedifference(otherdevices_lastupdate[leaving_standby]) > timeout
		and timedifference(otherdevices_lastupdate[arriving_standby]) > timeout	
	then
		commandArray[arriving_standby]='On'	
		commandArray["Variable:" .. frontdoor_acivity .. ""]= '2'	
		commandArray[scullery_light]='Set Level 50 AFTER 1 REPEAT 2 INTERVAL 1'
		event_body = '.............................................................'		
	end

	if devicechanged[arriving_standby] == 'Off'		
	then		
		commandArray[scullery_light]='Off AFTER 15 REPEAT 3 INTERVAL 5'
		commandArray["Variable:" .. frontdoor_acivity .. ""]= '0'
		
		if otherdevices[arriving_garden_standby] == 'On'		
		then
			commandArray[arriving_garden_standby]='Off AFTER 50'
		end
				
	end	

	if devicechanged[scullery_door] == 'Closed'
		and otherdevices[backdoor]   == 'Closed'
		and otherdevices[arriving_standby]   == 'On'		
		and otherdevices[scullery_light]   ~= 'Off'
		and uservariables[frontdoor_acivity]   == 2
		and timedifference(otherdevices_lastupdate[backdoor]) > 10		
	then		
		commandArray[scullery_light]='Off AFTER 5 REPEAT 3 INTERVAL 3'
		commandArray[arriving_standby]='Off AFTER 1'		
		commandArray["Variable:" .. frontdoor_acivity .. ""]= '0'
		
		if otherdevices[arriving_garden_standby] == 'On'		
		then
			commandArray[arriving_garden_standby]='Off AFTER 50'
		end
				
		event_body = '.............................................................'		
	end	
