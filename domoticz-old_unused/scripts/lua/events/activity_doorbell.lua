--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_doorbell.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script to increase frontdoor light lumen and switch hallway light ON/OFF when someone at the frontdoor and rang the doorbell
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Doorbell locals
	local doorbell_button 					= 'Deurbel - Knop'
	local doorbell_1 						= 'Deurbel_1'
	local doorbell_2    					= 'Deurbel_2'
	local doorbell_standby 					= 'Deurbel - Standby'
	--local front_door_acivity				= 'IsFrontDoor_Acivity'

-- Door Sensors
	local frontdoor							= 'Voor Deur'
	local livingroom_door					= 'Kamer Deur'

-- Various locals
	local someonehome						= 'Iemand Thuis'
	local light_state						= 'IsGarden_Light_State'
	local security_activation_type			= 'alarm_ActivationType'
	
-- IsDark Switches
	local isdark_front_door_trigger 		= 'IsDonker_Voordeur_Verlichting'
	local isdark_sunset						= 'Sunrise/Sunset'
	local isdark_dinner_table 				= 'IsDonker_Eettafel'
	
-- Lights
	local hallway_light						= 'Gang Wandlamp'
	local front_door_light					= 'Tuin Voordeur Verlichting'
	local back_garden_lights				= 'Tuin Schuur Verlichting'	
	local scullery_light					= 'Bijkeuken Lamp'
	local twilight							= 'Woonkamer Schemerlamp'
	local kitchen_light					    = 'Keuken Spots'	
	local hood								= 'Afzuigkap'
	
-- Scenes
	local garden_lights_leave_scene		= 'Tuinverlichting Vertrek'
	local garden_lights_scene			= 'Tuinverlichting'
    local garden_lights_backup_scene	= 'Tuin Verlichting - Backup'
    local doorbell_day_scene			= 'Deurbel - Dag'
	local doorbell_night_scene			= 'Deurbel - Avond'
	
	scullery_blink = (otherdevices[scullery_light] ~= 'Off' and otherdevices[someonehome] == 'On')
	twilight_blink = (otherdevices[twilight] ~= 'Off' and otherdevices[scullery_light] == 'Off' and otherdevices[someonehome] == 'On')
		
--
-- **********************************************************
-- Doorbell pressed, Ring doorbell twice
-- **********************************************************
--

	if devicechanged[doorbell_button]	
		and otherdevices[frontdoor]   == 'Closed'
		and otherdevices[doorbell_standby]   == 'Off'
	then	
		commandArray["Scene:" ..doorbell_day_scene.. ""]='On'
		event_body = '.............................................................'
	end
	
-- Script not finished yet	
