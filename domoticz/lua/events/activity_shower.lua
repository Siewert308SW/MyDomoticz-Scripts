--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_shower.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 24-03-2019
	@ Script to switch OFF livingroom lights when one person at home and is taking a shower, to let people think i'm not at home ;-)
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Standby ON when one person is at home and showering
-- **********************************************************
--

	if devicechanged[light.shower] == 'On'
		and otherdevices[someone.home] == 'Thuis'
		and otherdevices[media_device.tv] == 'Off'
		and onlinedevices(findstring.gsm) == 1
		and onlinedevices(findstring.geodevice) == 1		
		and timebetween("14:00:00","23:59:59")			
	then
		commandArray[someone.home]='Set Level 40'
	end

--
-- **********************************************************
-- SomeOneHome
-- **********************************************************
--

	if (devicechanged[door.front]
		or devicechanged[door.back]
		or devicechanged[door.garden]
		or devicechanged[door.scullery]
		or devicechanged[window.living]
		or devicechanged[door.living])
		and otherdevices[someone.home] == 'Douchen'
	then
		commandArray[someone.home]='Set Level 10'
	end

--
-- *********************************************************************
-- Shower light OFF when no motion for x minutes
-- *********************************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[light.shower] =='On'		
		and youless_svalue(youless.gas) <= 1000		
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.minutes30
		and timedifference(otherdevices_lastupdate[light.shower]) >= timeout.hour1	
	then
		commandArray[light.shower]='Off'		
	end
