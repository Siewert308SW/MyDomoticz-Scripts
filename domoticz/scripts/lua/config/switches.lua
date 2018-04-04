--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switches.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 4-4-2018
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
-- Laptops
-- **********************************************************
--

laptop = {
	jerina						= 'Jerina Laptop',
	siewert						= 'Siewert Laptop',
	natalya						= 'Natalya Laptop',		
	switch						= 'Laptops',
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
	switch						= 'Telefoons',
}

--
-- **********************************************************
-- Phones Visitors
-- **********************************************************
--

visitor = {
	grandma_gsm					= 'Oma GSM',
	grandma_tablet				= 'Oma Tablet',
	switch						= 'Visite',		
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
}

--
-- **********************************************************
-- Light Switch Devices
-- **********************************************************
--

switch = {
	living_light				= 'Woonkamer - Verlichting Knop',
	dinner_light 				= 'Eettafel - Verlichting Knop',
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
	garden_lights				= 'Tuin - Verlichting',
	garden_lights_leaving		= 'Tuin - Verlichting Vertrek',
}

scene = {
	stage_1						= 'Woonkamer - Stage 1',	
	stage_2						= 'Woonkamer - Stage 2',
	stage_away					= 'Woonkamer - Stage Away',	
	shutdown					= 'Woonkamer - Shutdown',
	nobodyhome					= 'Niemand - Thuis',	
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
	kitchen						= 'Keuken - Motion',
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
	printer		 				= 'Standbykiller - Printer',
	natalya		 				= 'Standbykiller - Natalya TV Hoek',
	workbench		 			= 'Standbykiller - Werkbank',
	pihole			 			= 'Standbykiller - PiHole',	
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
	hood						= 'Verbruik - Afzuigkap',
	workbench		 			= 'Verbruik - Werkbank',
	pihole			 			= 'Verbruik - PiHole',	
	media_usage					= 15,
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
	holiday						= 'holiday',	
	lua_error					= 'lua_error',
	lua_logging					= 'lua_logging',		
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
	porch						= 'Veranda - Lux',
	switch						= 'Sunrise/Sunset',	
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
	room_temp					= 'Nest - Temperatuur',	
	setpoint_idx				= 13,
	
	setpoint_low_summer			= 16.0,
	setpoint_low_autumn			= 19.0,	
	setpoint_low_winter			= 20.5,
	
	setpoint_temp1				= 20.5,
	setpoint_temp2				= 21.5,
	setpoint_temp3				= 21.9,		
	trigger_temp				= 22.5,
	
	summer_temp					= 19,
	autumn_temp					= 16,	
	winter_temp					= 10,	
}

--
-- **********************************************************
-- PIco UPS HV3.0A
-- **********************************************************
--

pico = {
	fan_selector_switch 		= 'PIco Fan Control',	
	rpi_temp_sensor				= 'Raspberry - CPU Temperatuur',
}

--
-- **********************************************************
-- Various
-- **********************************************************
--

standby = {
	hallway						= 'Gang - Standby',
	shower						= 'Douche - Standby',
	doorbell					= 'Deurbel - Standby',	
}

logging = {
	switch						= 'Logging',
}

dummy = {
	one							= 'Dummy 1',
	two							= 'Dummy 2',
	three						= 'Dummy 3',	
}	