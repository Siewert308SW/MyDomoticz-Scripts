--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_laptops.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 01-01-2019
	@ Script for switching plug.printer switch
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- Laptops ON
-- **********************************************************
--

	if (devicechanged[laptop.jerina]== 'On' or devicechanged[laptop.natalya]== 'On')
		and otherdevices[plug.printer] == 'Off'
	then
		commandArray[plug.printer]='On AFTER 1'	
	end

-- **********************************************************
	
	if devicechanged[laptop.siewert]== 'On' 
		and otherdevices[plug.siewert] == 'Off'
	then
		commandArray[plug.siewert]='On'
		if otherdevices[plug.printer] == 'Off'
		then
			commandArray[plug.printer]='On AFTER 1'	
		end		
	end
	
--
-- **********************************************************
-- Laptops OFF
-- **********************************************************
--

	if (devicechanged[laptop.jerina]== 'Off' or devicechanged[laptop.natalya]== 'Off')
		and otherdevices[laptop.jerina] == 'Off'
		and otherdevices[laptop.natalya] == 'Off'	
		and otherdevices[laptop.siewert] == 'Off'
		and otherdevices[plug.printer] == 'On'	
	then
		commandArray[plug.printer]='Off AFTER 1'		
	end

-- **********************************************************
	
	if devicechanged[laptop.siewert]== 'Off'
		and otherdevices[laptop.jerina] == 'Off'
		and otherdevices[laptop.natalya] == 'Off'	
		and otherdevices[plug.siewert] == 'On'
	then
		commandArray[plug.siewert]='Off AFTER 1'
		if otherdevices[plug.printer] == 'On'
		then
			commandArray[plug.printer]='Off AFTER 2'	
		end				
	end

-- **********************************************************
	
	if devicechanged[laptop.siewert]== 'Off'		
		and otherdevices[plug.siewert] == 'On'
		and (otherdevices[laptop.jerina] == 'On'
		or otherdevices[laptop.natalya] == 'On')		
	then
		commandArray[plug.siewert]='Off AFTER 1'	
	end
	