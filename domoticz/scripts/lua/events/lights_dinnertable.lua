--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_dinnertable.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-4-2018
	@ Script to switch diner table light ON/OFF with taking in count Laptops ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
-- Dinner table light ON/OFF when a laptop is online
-- *********************************************************************
--

	if devicechanged[laptop.switch] == 'On'		
		and otherdevices[light.dinnertable] == 'Off'
		and dark('true', 15)
	then
		commandArray[light.dinnertable]='Set Level 7 REPEAT 3 INTERVAL 1'		
	end

-- *********************************************************************

	if devicechanged[laptop.switch] == 'Off'
		and otherdevices[light.dinnertable] ~= 'Off'		
	then
		commandArray[light.dinnertable]='Off REPEAT 3 INTERVAL 1'	
	end
	
--
-- *********************************************************************
-- Dinner table light ON/OFF when lux is higher or lower then threshold
-- *********************************************************************
--

	if devicechanged[lux_sensor.living]
		and otherdevices[laptop.switch] == 'On'
		and otherdevices[light.dinnertable] == 'Off'			
		and dark('true', 15)
		and uservariables[var.dinner_light_override] == 0	
	then
		commandArray[light.dinnertable]='Set Level 7 AFTER 1 REPEAT 3 INTERVAL 1'		
	end
		
-- *********************************************************************

	if devicechanged[lux_sensor.living]
		and otherdevices[light.dinnertable] ~= 'Off'			
		and dark('false', 15)
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes10				
	then
		commandArray[light.dinnertable]='Off REPEAT 3 INTERVAL 2'		
	end
		
	if devicechanged[lux_sensor.living]
		and uservariables[var.dinner_light_override] ~= 0			
		and dark('false', 15)			
	then
		commandArray["Variable:" .. var.dinner_light_override .. ""]= '0'		
	end			