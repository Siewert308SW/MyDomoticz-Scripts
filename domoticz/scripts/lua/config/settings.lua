--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ settings.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 09-01-2019
	@ Global Settings
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Domoticz Logging Settings
-- **********************************************************
--

	lua = {		
		notify			= 'false';							-- Enable/Disable email notification
		verbose 		= 'false';							-- Enable/Disable logs in domoticz
		logfile 		= 'false';							-- Enable/Disable logs into logfile @ /domoticz (only works if verbose is true)
		event_folder	= 'events/'; 						-- Your desired event scripts lua file location
		timer_folder	= 'events/'; 						-- Your desired timer scripts lua file location		
	}
	
	lualog = {		
		folder			= '/mnt/storage/logging/eventlog/'; -- Your desired event log file location
		filename 		= 'eventlog';						-- Your desired event log file name
		fileext		 	= '.txt';							-- Your desired event log file extension	
	}	
	
--
-- **********************************************************
-- Domoticz redundant ON/OFF commands
-- **********************************************************
--
	
	redundant_array = {		
		command			= 'true';							-- Enable/Disable sending redundant ON/OFF commands	for 433mhz devices		
		repeats 		= 2;								-- Define how many times to repeat the signal
		interval 		= 3;								-- Define interval between each signal	
	}	
	
--
-- **********************************************************
-- Domoticz Lux Settings
-- **********************************************************
--

	lux_trigger = {
		dinner			 = 90;									-- Define max Lux value (lower is dark)
		kitchen			 = 75;									-- Define max Lux value (lower is dark)			
		living_high		 = 65;									-- Define max Lux value (lower is dark)
		living_low		 = 25;									-- Define mix Lux value (lower is dark)
		hallway			 = 15;									-- Define max Lux value (lower is dark)
		garden_high 	 = 6;									-- Define max Lux value (lower is dark)
		garden_high_xmas = 15;									-- Define max Lux value (lower is dark)			
		garden_low 		 = 1;									-- Define min Lux value (lower is dark)			
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
		minutes3 		= 180;		
		minutes5 		= 300;
		minutes10 		= 600;		
		minutes15 		= 900;
		minutes20 		= 1200;
		minutes25 		= 1500;
		minutes30 		= 1800;
		minutes45 		= 2700;

		hour1 			= 3600;
		hours2 			= 7200;
		hours3 			= 10200;
		hours4 			= 14400;		
		hours5 			= 18000;
		hours6 			= 21600;		
		hours8 			= 28800;		
		hours15 		= 57600;			
	}