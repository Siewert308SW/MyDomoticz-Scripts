--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ settings.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 22-01-2019
	@ Global Settings
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Domoticz Logging Settings
-- **********************************************************
--

	lua = {		
		notify			= 'false';				-- Enable/Disable email notification
		verbose 		= 'false';				-- Enable/Disable logs in domoticz
		logfile 		= 'false';				-- Enable/Disable logs into logfile @ /domoticz (only works if verbose is true)
		event_folder	= 'events/'; 			-- Your desired event scripts lua file location
		timer_folder	= 'events/'; 			-- Your desired timer scripts lua file location		
	}
	
	lualog = {		
		folder			= '/home/pi/domoticz/logging/eventlog/'; -- Your desired event log file location
		filename 		= 'eventlog';						-- Your desired event log file name
		fileext		 	= '.txt';							-- Your desired event log file extension	
	}	
	
--
-- **********************************************************
-- Domoticz redundant ON/OFF commands
-- **********************************************************
--
	
	redundant_array = {		
		command						= 'true';	-- Enable/Disable sending redundant ON/OFF commands	for 433mhz devices		
		repeats 					= 2;	 	-- Define how many times to repeat the signal
		interval 					= 3;		-- Define interval between each signal	
	}	
	
--
-- **********************************************************
-- Domoticz Lux Settings
-- **********************************************************
--

	lux_trigger = {
		dinner			 			= 90;		-- Define max Lux value (lower is dark)
		kitchen			 			= 75;		-- Define max Lux value (lower is dark)			
		living_high		 			= 60;		-- Define max Lux value (lower is dark)
		living_low		 			= 25;		-- Define mix Lux value (lower is dark)
		hallway			 			= 15;		-- Define max Lux value (lower is dark)
		garden_high 	 			= 6;		-- Define max Lux value (lower is dark)
		garden_high_xmas 			= 15;		-- Define max Lux value (lower is dark)			
		garden_low 		 			= 1;		-- Define min Lux value (lower is dark)			
	}
	
--
-- **********************************************************
-- Z-Wave Powerplugs Watt Settings
-- **********************************************************
--

	watt_usage = {
		tvcorner					= 120,
		media						= 11,
		media_natalya				= 10,
		laptop						= 5,
		kitchen_socket1				= 25,
		kitchen_socket2				= 25,
		kitchen_socket3				= 25,
		hood_high					= 120, -- When hood ventilation is ON
		hood_low					= 16, -- Only lights ON
	}
	
--
-- **********************************************************
-- Nest Thermostat (Nest screwed up temps, real temp is 1.4 degrees lower)
-- **********************************************************
--

	nest_conf = {		
		setpoint_idx				= 13,

		setpoint_temp_summer		= 20.5,
		setpoint_temp_autumn		= 21.1,		
		setpoint_temp_winter		= 21.3,
		setpoint_temp_artic			= 21.7,		

		setpoint_preheat_summer		= 20.0,
		setpoint_preheat_autumn		= 20.5,		
		setpoint_preheat_winter		= 20.7,
		setpoint_preheat_artic		= 21.3,		
		
		eco_temp_summer				= 17.5,
		eco_temp_autumn				= 19.0,
		eco_temp_winter				= 20.5,	
		eco_temp_artic				= 21.5,
		
		trigger_temp_summer			= 21.5,
		trigger_temp_autumn			= 16.0,
		trigger_temp_winter			= 2.0,
		trigger_temp_artic			= tonumber '-3.0',		

		trigger_frost_temp			= 0.0, -- Used for garden lights OFF timeout when no motion is detected		
	}	
	
--
-- **********************************************************
-- Domoticz global HEOS HS2 Settings
-- **********************************************************
--

	heosconf = {
		host						= 'IP';
		port						= '1255';
		pid							= 'PID';
	}
	
--
-- **********************************************************
-- Domoticz Event Timeouts
-- **********************************************************
--	
	
	timeout = {
		second1 					= 1;	
		seconds5 					= 5;	
		seconds10 					= 10;
		seconds15 					= 15;
		seconds30 					= 30;
		seconds45 					= 45;

		minute1 					= 60;
		minutes2 					= 120;
		minutes3 					= 180;		
		minutes5 					= 300;
		minutes10 					= 600;		
		minutes15 					= 900;
		minutes20 					= 1200;
		minutes25 					= 1500;
		minutes30 					= 1800;
		minutes45 					= 2700;

		hour1 						= 3600;
		hours2 						= 7200;
		hours3 						= 10200;
		hours4 						= 14400;		
		hours5 						= 18000;
		hours6 						= 21600;		
		hours8 						= 28800;
		hours12 					= 43200;		
		hours15 					= 57600;			
	}	
	
--
-- **********************************************************
-- Domoticz Stringfind Settings (See various functions)
-- **********************************************************
--

	findstring = {
		gsm				= 'GSM';
		laptop			= '_Laptop';
		nest			= 'Nest';
		geofence		= 'DomoFence';
		trigger			= '_1min';
		standbykiller	= 'Standbykiller';
		dummy			= 'Dummy';
	}

--
-- **********************************************************
-- Domoticz global custom log messages
-- **********************************************************
--
	
	message = {		
		phones_on			= 'Someone just came home';
		phones_off			= 'There is nobody home anymore';

		laptops_on			= 'There is a laptop online';
		laptops_off			= 'There are no laptops online';
		
		motion_seen			= 'Last detected motion was ago';
		motion_notseen		= 'Last detected motion was ago';		

		timediff			= 'Last device update was ago';
		
		powerusage			= 'Device powerusage was .....';		
		
		dummy_on			= 'There is a Dummy device ON';
		dummy_off			= 'All Dummy devices are OFF';		
	}	