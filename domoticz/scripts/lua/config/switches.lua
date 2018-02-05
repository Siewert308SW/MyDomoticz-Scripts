--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switches.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-5-2018
	@ Define your switches and devices, Lua globally used.
	@ Once you have renamed a switches then no need to edit all your scripts

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- SomeOneHome selector switch
-- **********************************************************
--

someone = {
		home					= 'Iemand Thuis',
}

--
-- **********************************************************
-- Laptops
-- **********************************************************
--

laptop = {
		jerina					= 'Jerina Laptop - eth',
		siewert					= 'Siewert Laptop - eth',
		natalya					= 'Natalya Laptop - eth',		
		switch					= 'Laptops',
		printer					= 'Print Server',
}

--
-- **********************************************************
-- Phones
-- **********************************************************
--

phone = {
		jerina					= 'Jerina GSM',
		siewert					= 'Siewert GSM',
		natalya					= 'Natalya GSM',		
		switch					= 'Telefoons',
}

--
-- **********************************************************
-- Phones Visitors
-- **********************************************************
--

visitor = {
		grandma_gsm				= 'Oma GSM',
		grandma_tablet			= 'Oma Tablet',
		switch					= 'Visite',		
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
	living_wall_lights			= 'Woonkamer - Wand Lampen',
	living_salon_light			= 'Woonkamer - Salon Tafel Lamp',
	toilet						= 'W.C - Lamp',
	pantry						= 'Kelder - Verlichting',
	kitchen_cabinet1			= 'Keuken - Cabinet Lamp (Wasbak)',
	kitchen_cabinet2			= 'Keuken - Cabinet Lamp (Fornuis)',
	hood						= 'Keuken - Afzuigkap',
	dinnertable 				= 'Woonkamer - Eettafel Lamp',
	upstairs    				= 'Overloop - Verlichting',
	shower						= 'Douche - Lamp',
	hallway						= 'Gang - Wandlamp',
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
	porch_lights				= 'Tuin - Veranda Verlichting',	
}

--
-- **********************************************************
-- Light Switch Devices
-- **********************************************************
--

switch = {
	living_light				= 'Woonkamer - Kamer Verlichting Knop',
	dinner_light 				= 'Woonkamer - Eettafel Verlichting Knop',
	garden_light				= 'Tuin - Verlichting Knop',
	upstairs1    				= 'Overloop - Verlichting Knop (H1)',
	upstairs2    				= 'Overloop - Verlichting Knop (H2)',	
}

--
-- **********************************************************
-- Scenes and Groups
-- **********************************************************
--

group = {
	standy_killers_433mhz		= 'Standby Killers (433Mhz)',
	standy_killers_zwave		= 'Standby Killers (z-wave)',
	garden_lights				= 'Tuin Verlichting',
	garden_lights_leaving		= 'Tuin Verlichting Vertrek',
	nobodyhome					= 'Woonkamer Niemand Thuis',
}

scene = {
	stage_1						= 'Woonkamer Stage 1',	
	stage_2						= 'Woonkamer Stage 2',	
	stage_3						= 'Woonkamer Stage 3',
	stage_4						= 'Woonkamer Stage 4',
	shutdown					= 'Woonkamer Shutdown',
	away_shutdown				= 'Woonkamer Away Shutdown',	
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
	dinner1						= 'Eettafel - Motion (links)',
	dinner2						= 'Eettafel - Motion (rechts)',
	toilet						= 'W.C - Motion',
	upstairs					= 'Overloop - Motion',
	downstairs 					= 'Trap - Motion',
	dinner1						= 'Eettafel - Motion (links)',
	dinner2						= 'Eettafel - Motion (rechts)',
	kitchen						= 'Keuken - Cabinet Motion',
	porch						= 'Veranda - Motion',	
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
	printer		 				= 'Standbykiller - Printer/Server',
	natalya		 				= 'Standbykiller - Natalya TV Hoek',
	pantry		 				= 'Standbykiller - Kelder',	
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
	pantry						= 'Verbruik - Kelder',
	hood						= 'Verbruik - Afzuigkap',	
	media_usage					= 10,
	hood_high					= 80, -- When hood ventilation is ON
	hood_low					= 11, -- Only lights ON
}

--
-- **********************************************************
-- User Variables
-- **********************************************************
--

var = {

	living_light_override		= 'living_light_override',
	dinner_light_override 		= 'dinner_light_override',
	garden_light_override		= 'garden_light_override',
	garden_light_standby		= 'garden_light_standby',
	garden_light_motion			= 'garden_light_motion',	
	leaving_override			= 'leaving_override',
	doorbell_standby			= 'doorbell_standby',
	lua_error					= 'lua_error',	
}

--
-- **********************************************************
-- Lux Sensor
-- **********************************************************
--

lux_sensor = {
	living						= 'Woonkamer - Lux',
	hallway 					= 'Gang - Lux',
	upstairs					= 'Overloop - Lux',
	veranda						= 'Veranda - Lux',	
}

--
-- **********************************************************
-- Doorbell
-- **********************************************************
--

doorbell = {
	button						= 'Deurbel',	
}

--
-- **********************************************************
-- Various Temperature Sensors
-- **********************************************************
--

temp = {
	veranda						= 'Veranda - Temperatuur',
	porch_light					= 18,
}

--
-- **********************************************************
-- Nest
-- **********************************************************
--

nest = {
	heating						= 'Nest - HeatingOn',
	setpoint					= 'Nest - Setpoint',
	room_temp					= 'Nest - TempHum',	
	setpoint_idx				= 45,	
}
