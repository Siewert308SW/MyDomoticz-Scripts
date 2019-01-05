--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ helper.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 01-01-2019
	@ Global Helper
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Domoticz Stringfind Settings (See various functions)
-- **********************************************************
--

	findstring = {
		gsm				= 'GSM';
		laptop			= 'Laptop';
		nest			= 'Nest';
		geofence		= 'DomoFence';		
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