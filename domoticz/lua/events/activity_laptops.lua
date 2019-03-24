--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_laptops.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 24-03-2019
	@ Script for switching plug.printer and laptop standbykiller
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- Laptops ON
-- **********************************************************
--

	if (devicechanged[laptop.jerina]== 'On' or devicechanged[laptop.natalya]== 'On' or devicechanged[laptop.siewert]== 'On')
		and otherdevices[plug.printer] == 'Off'
	then
		commandArray[plug.printer]='On'	
	end
	
--
-- **********************************************************
-- Laptops OFF
-- **********************************************************
--

	if (devicechanged[laptop.jerina]== 'Off' or devicechanged[laptop.natalya]== 'Off' or devicechanged[laptop.siewert]== 'Off')
		and otherdevices[laptop.jerina] == 'Off'
		and otherdevices[laptop.natalya] == 'Off'	
		and otherdevices[laptop.siewert] == 'Off'
		and otherdevices[plug.printer] == 'On'	
	then
		commandArray[plug.printer]='Off'		
	end
	
--
-- **********************************************************
-- Laptops standbykiller ON/OFF
-- **********************************************************
--

	if devicechanged[laptop.siewert] == 'Off'
		and otherdevices[plug.siewert] == 'On'
	then
		commandArray[plug.siewert]='Off'			
	end
	
	if devicechanged[laptop.siewert] == 'On'
		and otherdevices[plug.siewert] == 'Off'
	then
		commandArray[plug.siewert]='On'			
	end

	