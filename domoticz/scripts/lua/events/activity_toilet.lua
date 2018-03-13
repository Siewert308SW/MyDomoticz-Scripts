--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_toilet.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-13-2018
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
		and timedifference(otherdevices_lastupdate[light.toilet]) > timeout.seconds10
		and (otherdevices[someone.home]  == 'Thuis' or otherdevices[someone.home]  == 'Off')			
	then		
		commandArray[light.toilet]='On'
	end

--
-- *********************************************************************
-- Toilet light OFF after X minutes when no motion detected
-- *********************************************************************
--

	if devicechanged[lux_sensor.hallway]
		and otherdevices[light.toilet]  == 'On'	
		and timedifference(otherdevices_lastupdate[motion_sensor.toilet]) > timeout.minutes5
		and timedifference(otherdevices_lastupdate[light.toilet]) > timeout.minutes5		
	then		
		commandArray[light.toilet]='Off'	
	end	
