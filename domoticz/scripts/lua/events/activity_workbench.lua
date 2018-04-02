--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_workbench.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-4-2018
	@ Script to switch ON/OFF plug.workbench
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
--  Workbench ON when the master arrives at home
-- *********************************************************************
--

	if (devicechanged[phone.siewert]  == 'On' or devicechanged[someone.home]  == 'Thuis')	
		and timebetween("08:00:00","22:29:59")
		and otherdevices[plug.workbench]  == 'Off'		
	then
		commandArray[plug.workbench]='On'	
	end
	
--
-- *********************************************************************
--  Workbench ON
-- *********************************************************************
--

	if devicechanged[motion_sensor.porch]  == 'On'	
		and timebetween("08:00:00","22:29:59")
		and otherdevices[plug.workbench]  == 'Off'
		and otherdevices[phone.siewert]  == 'On'		
		and otherdevices[someone.home]  == 'Thuis'		
	then
		commandArray[plug.workbench]='On'	
	end	
	
--
-- *********************************************************************
--  If the master is at home then plug.workbench ON if signal is missed
-- *********************************************************************
--

	if devicechanged[lux_sensor.living]
		and otherdevices[plug.workbench]  == 'Off'
		and otherdevices[phone.siewert]  == 'On'
		and otherdevices[someone.home]  == 'Thuis'		
		and timebetween("08:00:00","22:29:59")
		and timedifference(otherdevices_lastupdate[plug.workbench]) > timeout.hours8		
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
			and timebetween("08:00:00","22:29:59")			
		then
			commandArray[plug.workbench]='Off'	
		end
	
--
-- *********************************************************************
--  If the master is at home then plug.workbench OFF after x minutes at night
-- *********************************************************************
--

		if otherdevices[plug.workbench]  == 'On'
			and powerusage(watt.workbench) >= 0		
			and powerusage(watt.workbench) <= 20
			and timedifference(otherdevices_lastupdate[plug.workbench]) > timeout.minutes30
			and timedifference(otherdevices_lastupdate[door.back]) > timeout.minutes30
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) > timeout.minutes30		
			and (otherdevices[phone.siewert] == 'On' or otherdevices[someone.home] ~= 'Thuis')
			and (timebetween("22:30:00","23:59:59")	or timebetween("00:00:00","07:59:59"))
		then
			commandArray[plug.workbench]='Off'
		end	

--
-- *********************************************************************
--  If the master is at home then plug.workbench OFF after x minutes at night
-- *********************************************************************
--

		if otherdevices[plug.workbench]  == 'On'
			and powerusage(watt.workbench) >= 0		
			and powerusage(watt.workbench) <= 20
			and timedifference(otherdevices_lastupdate[plug.workbench]) > timeout.hours3
			and timedifference(otherdevices_lastupdate[door.back]) > timeout.minutes30
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) > timeout.minutes30
			and timebetween("00:00:00","23:59:59")
			and (otherdevices[phone.siewert] == 'On' or otherdevices[someone.home] == 'Thuis')
		then
			commandArray[plug.workbench]='Off'
		end			
	end