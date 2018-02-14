--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_doorbell.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-14-2018
	@ Script for someone who pressed the doorbell
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Doorbell pressed, Ring doorbell twice
-- **********************************************************
--

	if devicechanged[doorbell.button]	
		and otherdevices[door.front]   == 'Closed'
		and otherdevices[someone.home]   == 'Thuis'
		and uservariables[var.doorbell_standby] == 0		
		and timedifference(otherdevices_lastupdate[var.doorbell_standby]) >= timeout.seconds30		
	then
		commandArray["Variable:" .. var.doorbell_standby .. ""]= '1'	
		commandArray[doorbell.button] = 'On AFTER 3'

		if powerusage(watt.hood) >= watt.hood_high then
		blink(light.kitchen_cabinet1 ,3)
		end
	end
	
--
-- **********************************************************
-- Doorbell standby OFF
-- **********************************************************
--

	if (devicechanged[lux_sensor.living])
		and uservariables[var.doorbell_standby] == 1		
	then
		commandArray["Variable:" .. var.doorbell_standby .. ""]= '0'
	end	