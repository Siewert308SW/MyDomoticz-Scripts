--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ settings.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-10-2018
	@ All global settings
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Domoticz Logging Settings
-- **********************************************************
--

	lua = {		
		notify			= "true";							-- If you want a email notification
		verbose 		= "true";							-- If you want to see logs in domoticz
		device_check 	= "true";							-- If you want to check if your predefined devices are still present		
	}
	
--
-- **********************************************************
-- Domoticz Log Message Colors
-- **********************************************************
-- Usage example: print_color('RED', 'Hello world')

-- Possible colors option...
-- GREEN | RED | BLUE | YELLOW | ORANGE | GOLD | GREY | WHITE | MAGENTA 
-- LIGHTBLUE | SPRINGGREEN | GREENYELLOW | PURPLE | CHOCOLATE | CYAN
		
	msgcolor = {		
		header				= "GREEN";
		footer				= "GREEN";		
		triggerTitle		= "BLUE";
		trigger				= "GREEN";		
		messageTitle		= "BLUE";
		message				= "GREEN";		
		commandarrayTitle	= "BLUE";
		commandarray		= "RED";		
	}

	errorcolor = {		
		header				= "RED";
		footer				= "RED";		
		title				= "BLUE";
		message				= "PURPLE";		
	}	
	
--
-- **********************************************************
-- Domoticz Sunrise/Sunset Settings
-- **********************************************************
--

	before_sun = {		
		rise		= 30;									-- Define minutes before
		set 		= 15;									-- Define minutes before
	}
	
	after_sun = {		
		rise		= 30;									-- Define minutes after
		set 		= 15;									-- Define minutes after
	}	
	
--
-- **********************************************************
-- Domoticz Lux Settings
-- **********************************************************
--

	lux_trigger = {
		dinner		= 15;									-- Define max Lux value (lower is dark)	
		living1		= 10;									-- Define max Lux value (lower is dark)
		living2		= 5;									-- Define max Lux value (lower is dark)
		hallway		= 2;									-- Define max Lux value (lower is dark)		
		porch 		= 1;									-- Define max Lux value (lower is dark)		
		garden 		= 1;									-- Define max Lux value (lower is dark)	
	}	
	
--
-- **********************************************************
-- Domoticz Trigger Devices
-- **********************************************************
--

	triggers = {												-- Define your trigger which can/may trigger a script

	-- SomeOneHome Triggers
		'Iemand Thuis',

	-- Media Triggers
		'Televisie',
	
	-- Phones
		'Jerina GSM',
		'Siewert GSM',
		'Natalya GSM',		
		'Telefoons',
		
	-- Phones Visitos
		'Oma GSM',
		'Oma Tablet',
		'Visite',		
		
	-- Laptops	
		'Jerina Laptop - eth',	
		'Siewert Laptop - eth',	
		'Natalya Laptop - eth',
		'Laptops',
		
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
		'Keuken - Cabinet Motion',
		'Voorraam',
		'Eettafel - Motion (links)',
		'Eettafel - Motion (rechts)',
		'Veranda - Motion',		
		
	-- Light Switches
		'Woonkamer - Kamer Verlichting Knop',
		'Tuin - Verlichting Knop',
		'Woonkamer - Eettafel Verlichting Knop',		
		'Douche - Lamp',
		'W.C - Lamp',		
		'Keuken - Cabinet Lamp (Wasbak)',
		'Keuken - Cabinet Lamp (Fornuis)',
	
	-- Doorbell Switches
		'Deurbel',
		
	-- Sensors as 3,5,10 time trigger
		'Woonkamer - Lux', 	-- 3min trigger
		'Gang - Lux',		-- 5min trigger
		'Overloop - Lux',	-- 10min trigger	
		'Veranda - Lux',	-- Triggers garden lights event
		
	-- Various Switches
		'Dummy 1',
		--'Dummy 2',
		--'Dummy 3'			
}	
	
--
-- **********************************************************
-- Domoticz Event Timeouts
-- **********************************************************
--	
	
	timeout = {
		second1 		= 1;	
		seconds5 		= 5;	
		seconds10 		= 10;
		seconds15 		= 15;
		seconds30 		= 30;
		seconds45 		= 45;

		minute1 		= 60;
		minutes2 		= 120;
		minutes5 		= 300;
		minutes10 		= 600;		
		minutes15 		= 900;
		minutes20 		= 1200;
		minutes25 		= 1500;
		minutes30 		= 1800;
		minutes45 		= 2700;

		hour1 			= 3600;
		hours5 			= 18000;	
		hours15 		= 57600;			
	}	

--
-- **********************************************************
-- Domoticz Timer Scripts Timeouts at which script may be execuded
-- **********************************************************
--	
	
	timers = {"1","3","5","10","15"}								-- Here you can define your desired script_time triggers
	