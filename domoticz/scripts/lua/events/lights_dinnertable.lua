--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_dinnertable.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 01-01-2019
	@ Script to switch diner table light ON/OFF with when Laptops ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
-- Dinner table light ON when lux is lower then threshold
-- *********************************************************************
--

	if devicechanged[lux_sensor.porch]
		and laptops_powered('true')	
		and otherdevices[light.dinnertable] == 'Off'
		and device_svalue(lux_sensor.porch) < lux_trigger.dinner
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes5		
		and timedifference(otherdevices_lastupdate[motion_sensor.dinner1]) < timeout.minutes15
		and timedifference(otherdevices_lastupdate[motion_sensor.dinner2]) < timeout.minutes15		
	then
		commandArray[light.dinnertable]='Set Level 7'	
	end
	
	if (devicechanged[laptop.jerina] == 'On' or devicechanged[laptop.siewert] == 'On' or devicechanged[laptop.natalya] == 'On')
		and otherdevices[light.dinnertable] == 'Off'
		and device_svalue(lux_sensor.porch) < lux_trigger.dinner		
	then
		commandArray[light.dinnertable]='Set Level 7'	
	end	

--
-- *********************************************************************
-- Dinner table light OFF when lux is higher then threshold
-- *********************************************************************
--
	if devicechanged[lux_sensor.living]
		and laptops_powered('true')	
		and otherdevices[light.dinnertable] ~= 'Off'
		and device_svalue(lux_sensor.porch) >= lux_trigger.dinner
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes5		
	then
		commandArray[light.dinnertable]='Off'	
	end	

--
-- *********************************************************************
-- Dinner table light OFF when Laptops are Offline
-- *********************************************************************
--
	
	if (devicechanged[laptop.jerina] == 'Off' or devicechanged[laptop.siewert] == 'Off' or devicechanged[laptop.natalya] == 'Off')
		and laptops_powered('false')	
		and otherdevices[light.dinnertable] ~= 'Off'
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes5
		and (timebetween("00:00:00","15:59:59") or timebetween("22:00:00","23:59:59"))		
	then
		commandArray[light.dinnertable]='Off'	
	end
	
	if devicechanged[lux_sensor.porch]
		and laptops_powered('false')	
		and otherdevices[light.dinnertable] ~= 'Off'
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes5
		and timedifference(otherdevices_lastupdate[motion_sensor.dinner1]) >= timeout.minutes20
		and timedifference(otherdevices_lastupdate[motion_sensor.dinner2]) >= timeout.minutes20	
	then
		commandArray[light.dinnertable]='Off'	
	end		

--
-- *********************************************************************
-- Dinner table light standby when no motion detected
-- *********************************************************************
--

	if devicechanged[lux_sensor.hallway]
		and otherdevices[light.dinnertable] ~= 'Off'		
		and timedifference(otherdevices_lastupdate[light.dinnertable]) >= timeout.minutes5
		and timedifference(otherdevices_lastupdate[motion_sensor.dinner1]) >= timeout.minutes20
		and timedifference(otherdevices_lastupdate[motion_sensor.dinner2]) >= timeout.minutes20	
	then
		commandArray[light.dinnertable]='Off'
	end

	if devicechanged[motion_sensor.dinner2] == 'On'
		and otherdevices[light.dinnertable] == 'Off'			
		and device_svalue(lux_sensor.porch) < lux_trigger.dinner
		and laptops_powered('true')		
	then
		commandArray[light.dinnertable]='Set Level 7'
	end	
	