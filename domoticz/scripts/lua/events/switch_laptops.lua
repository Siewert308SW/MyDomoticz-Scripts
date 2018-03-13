--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switch_laptops.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-13-2018
	@ Script for switching dummy laptop switch to determine if SomeOneHome
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- Laptops ON
-- **********************************************************
--

	if devicechanged[laptop.jerina]== 'On' 
		and otherdevices[laptop.switch] == 'Off'
	then
		commandArray[laptop.switch]='On AFTER 1'
		commandArray[plug.printer]='On AFTER 2'		
	end

-- **********************************************************
	
	if devicechanged[laptop.siewert]== 'On' 
		and otherdevices[laptop.switch] == 'Off'
	then
		commandArray[laptop.switch]='On AFTER 1'
		commandArray[plug.siewert]='On AFTER 2'		
		commandArray[plug.printer]='On AFTER 3'
	end
	
	if devicechanged[laptop.siewert]== 'On' 
		and otherdevices[laptop.switch] == 'On'
	then
		commandArray[plug.siewert]='On AFTER 1'	
	end	

-- **********************************************************
	
	if devicechanged[laptop.natalya]== 'On' 
		and otherdevices[laptop.switch] == 'Off'
	then
		commandArray[laptop.switch]='On AFTER 1'
		commandArray[plug.printer]='On AFTER 2'		
	end	

--
-- **********************************************************
-- Laptops OFF
-- **********************************************************
--

	if devicechanged[laptop.jerina]== 'Off'
		and otherdevices[laptop.siewert] == 'Off'
		and otherdevices[laptop.natalya] == 'Off'		
		and otherdevices[laptop.switch] == 'On'		
	then
		commandArray[laptop.switch]='Off AFTER 1'		
		commandArray[plug.printer]='Off AFTER 2'		
	end

-- **********************************************************
	
	if devicechanged[laptop.siewert]== 'Off'
		and otherdevices[laptop.jerina] == 'Off'
		and otherdevices[laptop.natalya] == 'Off'		
		and otherdevices[laptop.switch] == 'On'	
	then
		commandArray[laptop.switch]='Off AFTER 1'
		commandArray[plug.siewert]='Off AFTER 2'		
		commandArray[plug.printer]='Off AFTER 3'		
	end
	
	if devicechanged[laptop.siewert]== 'Off'
		and otherdevices[laptop.jerina] == 'On'
		and otherdevices[laptop.natalya] == 'Off'		
		and otherdevices[laptop.switch] == 'On'		
	then
		commandArray[plug.siewert]='Off AFTER 1'	
	end

	if devicechanged[laptop.siewert]== 'Off'
		and otherdevices[laptop.jerina] == 'Off'
		and otherdevices[laptop.natalya] == 'On'		
		and otherdevices[laptop.switch] == 'On'		
	then
		commandArray[plug.siewert]='Off AFTER 1'	
	end
	
	if devicechanged[laptop.siewert]== 'Off'
		and otherdevices[laptop.jerina] == 'On'
		and otherdevices[laptop.natalya] == 'On'		
		and otherdevices[laptop.switch] == 'On'		
	then
		commandArray[plug.siewert]='Off AFTER 1'	
	end		

-- **********************************************************
	
	if devicechanged[laptop.natalya]== 'Off'
		and otherdevices[laptop.jerina] == 'Off'
		and otherdevices[laptop.siewert] == 'Off'		
		and otherdevices[laptop.switch] == 'On'		
	then
		commandArray[laptop.switch]='Off AFTER 1'
		commandArray[plug.printer]='Off AFTER 2'		
	end
	