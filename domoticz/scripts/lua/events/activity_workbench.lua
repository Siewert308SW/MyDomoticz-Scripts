--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_workbench.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-4-2018
	@ Script to switch ON/OFF plug.workbench
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
--  Workbench ON when the master arrives at home
-- *********************************************************************
--

	if devicechanged[phone.siewert]  == 'On'	
		and timebetween("08:00:00","22:29:59")
		and otherdevices[plug.workbench]  == 'Off'		
	then
		commandArray[plug.workbench]='On'	
	end	
	
--
-- *********************************************************************
--  If the master aint at home or sleeping then plug.workbench OFF after x minutes
-- *********************************************************************
--
	
	if devicechanged[lux_sensor.porch] then
	
		if otherdevices[plug.workbench]  == 'On'
			and timedifference(otherdevices_lastupdate[plug.workbench]) > timeout.minutes30
			and timedifference(otherdevices_lastupdate[door.back]) > timeout.minutes30
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) > timeout.minutes30		
			and (otherdevices[phone.siewert] == 'Off' or otherdevices[someone.home] ~= 'Thuis')		
		then
			commandArray[plug.workbench]='Off'	
		end
	
--
-- *********************************************************************
--  If the master is at home then plug.workbench ON
-- *********************************************************************
--

		if otherdevices[plug.workbench]  == 'Off'
			and timedifference(otherdevices_lastupdate[plug.workbench]) > timeout.minutes30
			and timedifference(otherdevices_lastupdate[door.back]) > timeout.minutes30
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) > timeout.minutes30		
			and otherdevices[phone.siewert] == 'On' 
			and otherdevices[someone.home] == 'Thuis'
			and timebetween("08:00:00","22:29:59")			
		then
			commandArray[plug.workbench]='Off'	
		end
	
	end