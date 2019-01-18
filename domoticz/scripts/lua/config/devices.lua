--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ devices.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 18-01-2019
	@ PreDefined switches and devices, Lua globally used.

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Domoticz LUA selector switch to choose various logging options
-- **********************************************************
--

lua_system = {
	switch						= 'EventSystem',
}

--
-- **********************************************************
-- SomeOneHome selector switch
-- **********************************************************
--

someone = {
	home						= 'Aanwezigheid',
}

--
-- **********************************************************
-- media devices
-- **********************************************************
--

media_device = {
	tv							= 'Televisie',
}

--
-- **********************************************************
-- DomoFence
-- **********************************************************
--

geo = {
	jerina						= 'Jerina DomoFence',
	siewert						= 'Siewert DomoFence',
	natalya						= 'Natalya DomoFence',		
}

--
-- **********************************************************
-- Laptops
-- **********************************************************
--

laptop = {
	jerina						= 'Jerina_Laptop',
	siewert						= 'Siewert_Laptop',
	natalya						= 'Natalya_Laptop',		
}

--
-- **********************************************************
-- Phones
-- **********************************************************
--

phone = {
	jerina						= 'Jerina GSM',
	siewert						= 'Siewert GSM',
	natalya						= 'Natalya GSM',
}

--
-- **********************************************************
-- Light Switch Devices
-- **********************************************************
--

switch = {
	living_light				= 'Woonkamer - Verlichting Knop',
	--dinner_light 				= 'Eettafel - Verlichting Knop',
	--garden_light				= 'Tuin - Verlichting Knop',
	natalya_reading_on			= 'Natalya Kamer - Leeslamp Knop (aan)',
	natalya_reading_off			= 'Natalya Kamer - Leeslamp Knop (uit)',
	natalya_light_on			= 'Natalya Kamer - Lamp Knop (aan)',	
	natalya_light_off			= 'Natalya Kamer - Lamp Knop (uit)',	
	upstairs1    				= 'Overloop - Verlichting Knop (H1)',
	upstairs2    				= 'Overloop - Verlichting Knop (H2)',	
}

--
-- **********************************************************
-- Lights
-- **********************************************************
--

light = {
	living_standing_light		= 'Woonkamer - Sta Lamp',
	living_twilight_tv			= 'Woonkamer - Schemerlamp (voor)',	
	living_twilight				= 'Woonkamer - Schemerlamp (achter)',
	living_deco_light			= 'Woonkamer - Vaas Lamp',	
	living_wall_lights			= 'Woonkamer - Wand Lampen',
	living_salon_light			= 'Woonkamer - Salon Tafel Lamp',
	toilet						= 'W.C - Verlichting',
	pantry						= 'Kelder - Verlichting',
	kitchen_cabinet1			= 'Keuken - Cabinet Lamp (Wasbak)',
	kitchen_cabinet2			= 'Keuken - Cabinet Lamp (Fornuis)',
	dinnertable 				= 'Woonkamer - Eettafel Lamp',
	upstairs    				= 'Overloop - Verlichting',
	shower						= 'Douche - Verlichting',
	hallway						= 'Gang - Lamp',
	hallway_wall				= 'Gang - Wandlamp',	
	natalya_reading				= 'Natalya Kamer - Leeslamp',
	natalya_light				= 'Natalya Kamer - Lamp',	
	natalya_rgb_string 			= 'Natalya Kamer - RGB String',
	natalya_rgb_light 			= 'Natalya Kamer - RGB Lamp',		
}

light_xmas = {
	tree						= 'Kerstboom',
	window						= 'Voorraam - Kerstbal',
}

--
-- **********************************************************
-- Garden Lights
-- **********************************************************
--

garden = {
	front_door_light			= 'Tuin - Voordeur Lamp',
	border_lights				= 'Tuin - Border Verlichting',
	shed_lights					= 'Tuin - Schuur Verlichting',
	party_lights				= 'Tuin - Veranda Party Verlichting',
	frontdoor_socket			= 'Tuin - Stopcontact Voor',	
	xmas_frontwindow_lights		= 'Voorraam - Kerst String',	
}

--
-- **********************************************************
-- Scenes and Groups
-- **********************************************************
--

group = {
	standy_killers_zwave_sleep	= 'Standby Killers Slapen (z-wave)',
	standy_killers_zwave_away	= 'Standby Killers Weg (z-wave)',
	standy_killers_natalya		= 'Standby Killers Natalya',	
	garden_lights				= 'Tuin - Verlichting',
	garden_lights_xmas			= 'Tuin - Verlichting XMAS',
	--livingroom					= 'Woonkamer - Verlichting Knop',
}

scene = {
	normal						= 'Woonkamer - Normaal',	
	xmas						= 'Woonkamer - Kerst',
	xmas_daytime				= 'Woonkamer - Kerst (daytime)',
	away						= 'Woonkamer - Away',
	away_xmas					= 'Woonkamer - Away XMAS',	
	shutdown					= 'Woonkamer - Shutdown',
	shutdown_xmas				= 'Woonkamer - Shutdown XMAS',	
	nobodyhome					= 'Niemand - Thuis',
	nobodyhome_xmas				= 'Niemand - Thuis XMAS',	
	
}

--
-- **********************************************************
-- Door Contacts
-- **********************************************************
--

door = {
	front						= 'Voor Deur',
	back			 			= 'Achter Deur',
	living						= 'Kamer Deur',
	garden	 					= 'Schuifpui',
	scullery 					= 'Bijkeuken Deur',
	pantry	 					= 'Kelder Deur',
}

--
-- **********************************************************
-- Motions Sensors
-- **********************************************************
--

motion_sensor = {	
	living						= 'Woonkamer - Motion',
	hallway						= 'Gang - Motion',
	toilet						= 'W.C - Motion',
	upstairs					= 'Overloop - Motion',
	downstairs 					= 'Trap - Motion',
	dinner1						= 'Eettafel - Motion (links)',
	dinner2						= 'Eettafel - Motion (rechts)',
	kitchen						= 'Keuken - Motion',
	porch						= 'Veranda - Motion',
	natalya						= 'Natalya Kamer - Motion',		
}

--
-- **********************************************************
-- Window Contacts
-- **********************************************************
--

window = {
	living						= 'Voorraam',
}

--
-- **********************************************************
-- Z-Wave Powerplugs ON/OFF
-- **********************************************************
--

plug = {
	tvcorner					= 'Standbykiller - Woonkamer TV Hoek',
	jerina 						= 'Standbykiller - Jerina Laptop',	
	siewert 					= 'Standbykiller - Siewert Laptop',
	printer		 				= 'Standbykiller - Printer',
	natalya_tv		 			= 'Standbykiller - Natalya TV Hoek',
	phone_pantry				= 'Standbykiller - GigaSet (Kelder)',
	phone_upstairs				= 'Standbykiller - GigaSet (Boven)',
	hood				 		= 'Standbykiller - Afzuigkap',	
	workbench		 			= 'Standbykiller - Werkbank',
}

--
-- **********************************************************
-- Z-Wave Powerplugs Watt
-- **********************************************************
--

watt = {
	tvcorner					= 'Verbruik - Woonkamer TV Hoek',
	siewert						= 'Verbruik - Siewert Laptop',
	jerina						= 'Verbruik - Jerina Laptop',
	natalya						= 'Verbruik - Natalya TV Hoek',
	phone_pantry				= 'Standbykiller - GigaSet (Kelder)',
	phone_upstairs				= 'Standbykiller - GigaSet (Boven)',	
	hood						= 'Verbruik - Afzuigkap',
	workbench		 			= 'Verbruik - Werkbank',
	tvcorner_usage				= 120,
	media_usage					= 11,
	media_natalya_usage			= 10,	
	laptop_usage				= 5,	
	hood_high					= 80, -- When hood ventilation is ON
	hood_low					= 16, -- Only lights ON	
}

--
-- **********************************************************
-- User Variables
-- **********************************************************
--

var = {
	living_light_scene			= 'living_light_scene',
	living_light_override		= 'living_light_override',
	living_light_pause			= 'living_light_pause',	
	--dinner_light_override 	= 'dinner_light_override',
	--garden_light_override		= 'garden_light_override',
	--garden_light_standby		= 'garden_light_standby',
	garden_light_motion			= 'garden_light_motion',
	frontgarden_light_motion	= 'frontgarden_light_motion',	
	preheat_override			= 'preheat_override',
	heat_override				= 'heat_override',	
	doorbell_standby			= 'doorbell_standby',
	holiday						= 'holiday',	
}

--
-- **********************************************************
-- Lux Sensor
-- **********************************************************
--

lux_sensor = {
	living						= 'Woonkamer - Lux',
	hallway 					= 'Gang - Lux',
	kitchen						= 'Keuken - Lux',	
	upstairs					= 'Overloop - Lux',
	porch						= 'Veranda - Lux',
	natalya						= 'Natalya Kamer - Lux',	
}

--
-- **********************************************************
-- Doorbell
-- **********************************************************
--

doorbell = {
	button						= 'Deurbel Knop',	
}

--
-- **********************************************************
-- Various Temperature Sensors
-- **********************************************************
--

temp = {
	porch						= 'Veranda - Temperatuur (fibaro)',
}

--
-- **********************************************************
-- Various
-- **********************************************************
--

timed = {
	trigger						= 'Raspberry - CPU Temperatuur',
}

test = {
	dummy1						= 'Dummy 1',
	dummy2						= 'Dummy 2',	
}

--
-- **********************************************************
-- Nest Thermostat
-- **********************************************************
--

	nest = {
		setpoint					= 'Nest - Setpoint',
		room_temp					= 'Nest - Temperatuur',
		away						= 'Nest - Away',		
		setpoint_idx				= 13,

		setpoint_temp_summer		= 20.5,
		setpoint_temp_autumn		= 21.3,		
		setpoint_temp_winter		= 21.7,

		setpoint_preheat_summer		= 20.0,
		setpoint_preheat_autumn		= 20.5,		
		setpoint_preheat_winter		= 21.0,
		
		eco_temp_summer				= 16.5,
		eco_temp_autumn				= 18.5,
		eco_temp_winter				= 20.5,	
		eco_temp_artic				= 21.0,
		
		trigger_temp_summer			= 22.5,
		trigger_temp_autumn			= 16.0,
		trigger_temp_winter			= 0.0,

		trigger_frost_temp			= 3.0, -- Used for garden lights OFF timeout when no motion is detected		
	}