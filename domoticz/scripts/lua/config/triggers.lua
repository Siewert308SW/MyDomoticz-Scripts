--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ triggers.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 24-4-2017
	@ All devices which can trigger a event in a scene
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
--  Device triggers
-- **********************************************************
--

	trigger = {

	--	Portable Devices
		phone_1 						= 'Jerina GSM',
		phone_2 						= 'Siewert GSM',
		phone_3 						= 'Natalya GSM',
		phone_4 						= 'Oma GSM',		
		phone_switch 			        = 'Telefoons',

	-- Cars
		car_1							= 'Peugeot308SW',
		
	-- Portable Devices	
		laptop_1 						= 'Jerina Laptop',	
		laptop_2 						= 'Siewert Laptop',	
		laptop_3 						= 'Natalya Laptop',
		laptop_switch 					= 'Laptops',

	-- Media Devices
		television 						= 'Televisie',
		mediabox 						= 'MediaBox',
		media_switch 					= 'Media',
		
	-- IsDark Switches
		isdark_garden_lights_trigger 	= 'IsDonker_Tuin_Verlichting',
		isdark_living_room_trigger_2	= 'IsDonker_Woonkamer_2',	
		isdark_dinner_table 			= 'IsDonker_Eettafel',	
		isdark_living_room_trigger_1	= 'IsDonker_Woonkamer_1',
		isdark_sunset					= 'Sunrise/Sunset',
		
	-- Door/Window Sensors
		frontdoor						= 'Voor Deur',					
		backdoor			 			= 'Achter Deur',
		livingroom_door					= 'Kamer Deur',
		sliding_door	 				= 'Schuifpui',
		scullery_door 					= 'Bijkeuken Deur',
		pantry_door 					= 'Kelder Deur',	
		motion_upstairs 				= 'Trap Motion Boven',
		motion_downstairs 				= 'Trap Motion Beneden',
		motion_toilet					= 'W.C Motion',
		motion_dinnertable				= 'Motion Eettafel',		
		motion_living					= 'Woonkamer Motion',
		motion_garden					= 'Tuin Achter Motion',		
		
	-- SomeOneHome Triggers
		someonehome						= 'Iemand Thuis',
		someonehome_standby				= 'Iemand Thuis - Standby',
		nobody_home 					= 'Niemand Thuis',	
		visitors						= 'Visite',
		nest_away						= 'Nest - Away',			
		leaving_standby					= 'Vertrek - Standby',	
		arriving_standby				= 'Aankomst - Standby',
		arriving_garden_standby			= 'Aankomst Tuin - Standby',		
		shower_standby					= 'Douche - Standby',
		walktrue_standby				= 'Doorloop - Standby',
		--pico_power    					= 'PIco RPi Powered',
	
	-- Light Switches
		toilet_light					= 'W.C Lamp',
		livingroom_light_switch			= 'Woonkamer Verlichting Knop',
		dinnertable_light_switch		= 'Woonkamer Eettafel Verlichting Knop',
		shower_light					= 'Douche Lamp',
		
	-- Various Switches
		doorbell_button 				= 'Deurbel - Knop',
		doorbell 						= 'Deurbel_1',
		doorbell_2 						= 'Deurbel_2',	
		doorbell_standby 				= 'Deurbel - Standby',
		
	-- Firealarm
		sirene_topfloor					= 'Rookmelder - Overloop',
		sirene_scullery					= 'Rookmelder - Schuur',
		sirene_living					= 'Rookmelder - Woonkamer',
		sirene_pantry					= 'Rookmelder - Kelder',		
		sirene_remote					= 'Alarm AB Knop',
		sirene_loop						= 'Rookmelder - Loop',
	
	-- Dummy Devices
		dummy1							= 'Dummy 1',
		dummy2							= 'Dummy 2',
		dummy3							= 'Dummy 3'		
	}