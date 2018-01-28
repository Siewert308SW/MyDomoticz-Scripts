--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_toilet.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ Script to switch ON toilet light when motion is triggered with standby to avoid triggering it again when light whiched OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- *********************************************************************
-- Toilet light ON when motion detection
-- *********************************************************************
--

	if devicechanged[motion_sensor.toilet] == 'On'	
		and otherdevices[light.toilet]  == 'Off'
		and otherdevices[someone.home]  == 'Thuis'		
		and otherdevices[phone.jerina]  == 'Off' 			-- Wife away? Then trigger always
		and timebetween("00:00:00","23:59:59")		
		and timedifference(otherdevices_lastupdate[light.toilet]) > timeout.seconds10
	then		
		commandArray[light.toilet]='On REPEAT 3 INTERVAL 1'
	end	

-- *********************************************************************
	
	if devicechanged[motion_sensor.toilet] == 'On'		
		and otherdevices[light.toilet]  == 'Off'
		and otherdevices[someone.home]  == 'Thuis'
		and otherdevices[phone.jerina]  == 'On' 				-- Wife at home? Then trigger at specfic time		
		and timebetween("06:00:00","23:59:59")
		and timedifference(otherdevices_lastupdate[light.toilet]) > timeout.seconds10
	then		
		commandArray[light.toilet]='On REPEAT 3 INTERVAL 1'
	end

--
-- *********************************************************************
-- Toilet light OFF after X minutes when no motion detected
-- *********************************************************************
--

	if devicechanged[lux_sensor.hallway]
		and otherdevices[light.toilet]  == 'On'	
		and timedifference(otherdevices_lastupdate[motion_sensor.toilet]) >= timeout.minutes5
		and timedifference(otherdevices_lastupdate[light.toilet]) >= timeout.minutes5		
	then		
		commandArray[light.toilet]='Off'	
	end	
