--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ settings.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 17-4-2017
	@ All global settings
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Get System Time
	time = os.date("*t")
	
--
-- **********************************************************
-- 
-- **********************************************************
--

	lua = {
		config 		= "/home/pi/domoticz/scripts/lua/config/"; 	-- Path to your lua config scripts
		events 		= "/home/pi/domoticz/scripts/lua/events/"; 	-- Path to your lua event scripts
		timers 		= "/home/pi/domoticz/scripts/lua/timers/"; 	-- Path to your lua timer scripts	
		notify		= true;										-- If you want a email notification
		verbose 	= true;										-- If you want to see logs in domoticz
		fetch 	 	= true;										-- If you want to fetch data from domoticz devices		
	}
	
	domoticz = {
		ip			= "127.0.0.1";
		port		= "8080";
		latitude	= "1.11";									-- Your latitude location, used in some scripts
		longitude	= "1.11";									-- Your longitude location, used in some scripts		
	}
	
	tmpfile = {
		buienradar	= "/mnt/storage/domoticz_scripts/logging/buienradar/rain.tmp";
	}
		