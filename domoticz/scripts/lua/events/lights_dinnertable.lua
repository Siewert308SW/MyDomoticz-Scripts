--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_dinnertable.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-30-2018
	@ Script to switch diner table light ON/OFF with taking in count Laptops ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
-- Dinner table light ON/OFF when a laptop is online
-- *********************************************************************
--

	if devicechanged[laptop.switch] == 'On'
		and laptops_powered('true')		
		and otherdevices[light.dinnertable] == 'Off'
		and device_svalue(lux_sensor.porch) < 30
		and timebetween("00:00:00","15:59:59")
	then
		commandArray[light.dinnertable]='Set Level 7 AFTER 10'	
	end
	
	if devicechanged[laptop.switch] == 'On'
		and laptops_powered('true')		
		and otherdevices[light.dinnertable] == 'Off'
		and device_svalue(lux_sensor.porch) < 70
		and timebetween("16:00:00","23:59:59")
	then
		commandArray[light.dinnertable]='Set Level 7 AFTER 10'	
	end	

-- *********************************************************************

	if devicechanged[laptop.switch] == 'Off'
		and laptops_powered('false')
		and otherdevices[light.dinnertable] ~= 'Off'		
	then
		commandArray[light.dinnertable]='Off AFTER 10'	
	end
	
--
-- *********************************************************************
-- Dinner table light ON/OFF when lux is higher or lower then threshold
-- *********************************************************************
--

	if devicechanged[lux_sensor.porch]
		and otherdevices[laptop.switch] == 'On'
		and laptops_powered('true')	
		and otherdevices[light.dinnertable] == 'Off'			
		and device_svalue(lux_sensor.porch) < 30
		and timebetween("00:00:00","15:59:59")			
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes10				
	then
		commandArray[light.dinnertable]='Set Level 7 AFTER 1'
	end
	
	if devicechanged[lux_sensor.porch]
		and otherdevices[laptop.switch] == 'On'
		and laptops_powered('true')	
		and otherdevices[light.dinnertable] == 'Off'			
		and device_svalue(lux_sensor.porch) < 70
		and timebetween("16:00:00","23:59:59")			
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes10				
	then
		commandArray[light.dinnertable]='Set Level 7 AFTER 1'
	end
	
-- *********************************************************************

	if devicechanged[lux_sensor.porch]
		and otherdevices[light.dinnertable] ~= 'Off'			
		and device_svalue(lux_sensor.porch) >= 30
		and timebetween("00:00:00","15:59:59")			
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes10				
	then
		commandArray[light.dinnertable]='Off AFTER 1'
	end
	
	if devicechanged[lux_sensor.porch]
		and otherdevices[light.dinnertable] ~= 'Off'			
		and device_svalue(lux_sensor.porch) >= 70
		and timebetween("16:00:00","23:59:59")			
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes10				
	then
		commandArray[light.dinnertable]='Off AFTER 1'
	end	
	