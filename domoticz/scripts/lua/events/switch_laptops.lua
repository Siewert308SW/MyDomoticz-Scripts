--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switch_laptops.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
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
		commandArray[plug.printer]='On AFTER 60'		
	end

-- **********************************************************
	
	if devicechanged[laptop.siewert]== 'On' 
		and otherdevices[laptop.switch] == 'Off'
	then
		commandArray[laptop.switch]='On AFTER 1'
		commandArray[plug.siewert]='On'		
		commandArray[plug.printer]='On AFTER 60'		
	end
	
	if devicechanged[laptop.siewert]== 'On' 
		and otherdevices[laptop.switch] == 'On'
	then
		commandArray[plug.siewert]='On'	
	end	

-- **********************************************************
	
	if devicechanged[laptop.natalya]== 'On' 
		and otherdevices[laptop.switch] == 'Off'
	then
		commandArray[laptop.switch]='On AFTER 1'
		commandArray[plug.printer]='On AFTER 60'		
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
		commandArray[plug.printer]='Off AFTER 60'		
	end

-- **********************************************************
	
	if devicechanged[laptop.siewert]== 'Off'
		and otherdevices[laptop.jerina] == 'Off'
		and otherdevices[laptop.natalya] == 'Off'		
		and otherdevices[laptop.switch] == 'On'	
	then
		commandArray[laptop.switch]='Off AFTER 1'
		commandArray[plug.siewert]='Off'		
		commandArray[plug.printer]='Off AFTER 60'		
	end
	
	if devicechanged[laptop.siewert]== 'Off'
		and otherdevices[laptop.jerina] == 'On'
		and otherdevices[laptop.natalya] == 'Off'		
		and otherdevices[laptop.switch] == 'On'		
	then
		commandArray[plug.siewert]='Off'	
	end

	if devicechanged[laptop.siewert]== 'Off'
		and otherdevices[laptop.jerina] == 'Off'
		and otherdevices[laptop.natalya] == 'On'		
		and otherdevices[laptop.switch] == 'On'		
	then
		commandArray[plug.siewert]='Off'	
	end
	
	if devicechanged[laptop.siewert]== 'Off'
		and otherdevices[laptop.jerina] == 'On'
		and otherdevices[laptop.natalya] == 'On'		
		and otherdevices[laptop.switch] == 'On'		
	then
		commandArray[plug.siewert]='Off'	
	end		

-- **********************************************************
	
	if devicechanged[laptop.natalya]== 'Off'
		and otherdevices[laptop.jerina] == 'Off'
		and otherdevices[laptop.siewert] == 'Off'		
		and otherdevices[laptop.switch] == 'On'		
	then
		commandArray[laptop.switch]='Off AFTER 1'
		commandArray[plug.printer]='Off AFTER 60'		
	end
	
--
-- **********************************************************
-- Printserver still online while laptops offline then kill it (433mhz)
-- **********************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[plug.printer] == 'On'
		and otherdevices[laptop.switch] == 'Off'
		and timedifference(otherdevices_lastupdate[laptop.switch]) > timeout.minutes10	
	then	
		commandArray[plug.printer]='Off'		
	end
	
--
-- **********************************************************
-- Printserver still offline while laptops obline then start (433mhz)
-- **********************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[laptop.printer]== 'Off'
		and otherdevices[laptop.switch] == 'On'
		and timedifference(otherdevices_lastupdate[laptop.switch]) > timeout.minutes10		
	then
		commandArray[plug.printer]='Off FOR 5 SECONDS'		
	end		
	