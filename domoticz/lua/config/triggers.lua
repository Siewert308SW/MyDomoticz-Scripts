--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ triggers.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 20-01-2019
	@ Devices which can/may trigger the event system
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Domoticz Trigger Devices
-- **********************************************************
--

	triggers = {											-- Define your triggers which can/may trigger a script

	-- SomeOneHome Triggers
		'Aanwezigheid',

	-- Media Triggers
		'Televisie',

	-- DomoFence Triggers
		'Jerina DomoFence',
		'Siewert DomoFence',
		'Natalya DomoFence',
	
	-- Phones
		'Jerina GSM',
		'Siewert GSM',
		'Natalya GSM',
		
	-- Laptops	
		'Jerina_Laptop',
		'Siewert_Laptop',	
		'Natalya_Laptop',
		
	-- Door/Window/Motion Sensors
		'Voor Deur',					
		'Achter Deur',
		'Kamer Deur',
		'Schuifpui',
		'Bijkeuken Deur',
		'Kelder Deur',	
		'Overloop - Motion',
		'Trap - Motion',
		'Gang - Motion',		
		'W.C - Motion',		
		'Woonkamer - Motion',
		'Keuken - Motion',
		'Voorraam',
		'Eettafel - Motion (links)',
		'Eettafel - Motion (rechts)',
		'Veranda - Motion',
		'Natalya Kamer - Motion',
		
	-- Light Switches
		'Woonkamer - Verlichting Knop',		
		--'Tuin - Verlichting Knop',
		--'Eettafel - Verlichting Knop',		
		'Douche - Verlichting',
		'W.C - Verlichting',
		'Natalya Kamer - Leeslamp Knop (aan)',
		'Natalya Kamer - Leeslamp Knop (uit)',
		'Natalya Kamer - Lamp Knop (aan)',
		'Natalya Kamer - Lamp Knop (uit)',		
		--'Keuken - Cabinet Lamp (Wasbak)',
		--'Keuken - Cabinet Lamp (Fornuis)',
	
	-- Doorbell Switches
		'Deurbel Knop',
		
	-- Sensors as 3,5,10 time trigger
		'Raspberry - CPU Temperatuur', 	-- 1minute time trigger
		'Woonkamer - Lux', 				-- 3min trigger
		'Gang - Lux',					-- 5min trigger
		'Overloop - Lux',				-- 10min trigger
		'Veranda - Lux',				-- 15min trigger

	-- Test (Dummy) devices used for testing
		'Dummy 1',
		'Dummy 2',	
}
