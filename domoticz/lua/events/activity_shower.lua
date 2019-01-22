--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_shower.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 20-1-2019
	@ Script to switch OFF livingroom lights when one person at home and is taking a shower, to let people think i'm not at home ;-)
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- *********************************************************************
-- Shower light OFF when no motion for x minutes
-- *********************************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[light.shower] =='On'
		and youless_svalue(youless.gas) <= 1000		
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) >= timeout.minutes10
		and timedifference(otherdevices_lastupdate[light.shower]) >= timeout.minutes10	
	then
		commandArray[light.shower]='Off'		
	end
   
--
-- **********************************************************
-- Stanby ON when one person is at home and showering
-- **********************************************************
--

	if devicechanged[light.shower] == 'On'
		and otherdevices[someone.home] == 'Thuis'
		and otherdevices[media_device.tv] == 'Off'
		and onlinedevices(findstring.gsm) == 1
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
		or devicechanged[motion_sensor.dinner1]
		or devicechanged[motion_sensor.dinner2]
		or devicechanged[door.living]
		or devicechanged[motion_sensor.living])
		and otherdevices[someone.home] == 'Douchen'
	then
		commandArray[someone.home]='Set Level 10'
	end
