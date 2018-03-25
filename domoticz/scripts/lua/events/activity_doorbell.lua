--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_doorbell.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-25-2018
	@ Script for someone who pressed the doorbell
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Doorbell pressed, Ring doorbell twice if somebody home or blinklight when cooking
-- **********************************************************
--

	if devicechanged[doorbell.button]	
		and otherdevices[door.front] == 'Closed'
		and otherdevices[someone.home] == 'Thuis'
		and uservariables[var.doorbell_standby] == 0		
	then
		commandArray["Variable:" .. var.doorbell_standby .. ""]= '1'	
		commandArray[doorbell.button] = 'On AFTER 4'

		if powerusage(watt.hood) >= watt.hood_high then
		blink(light.kitchen_cabinet1 ,3)
		commandArray['SendNotification']='Iemand aan de deur#Iemand aan de voordeur, Deurbel afgegaan'		
		elseif powerusage(watt.hood) < watt.hood_high and otherdevices[light.living_twilight_tv] == 'On' then
		blink(light.living_twilight ,3)
		commandArray['SendNotification']='Iemand aan de deur#Iemand aan de voordeur, Deurbel afgegaan'		
		end		
	end

	if devicechanged[doorbell.button]	
		and otherdevices[door.front] == 'Closed'
		and otherdevices[someone.home] ~= 'Thuis'
		and uservariables[var.doorbell_standby] == 0		
	then
		commandArray["Variable:" .. var.doorbell_standby .. ""]= '1'	
		commandArray['SendNotification']='Iemand aan de deur#Iemand aan de voordeur, Deurbel afgegaan'	
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