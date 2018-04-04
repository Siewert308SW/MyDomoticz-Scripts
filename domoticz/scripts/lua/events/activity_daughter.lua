--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_daughter.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 4-4-2018
	@ Script to switch ON/OFF daughter bedroom plug.natalya
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
--  If plug.natalya ON when she arrives at home
-- *********************************************************************
--

	if (devicechanged[phone.natalya]  == 'On' or devicechanged[laptop.natalya]  == 'On')	
		and timebetween("07:00:00","21:29:59")
		and otherdevices[plug.natalya]  == 'Off'
		and otherdevices[someone.home]  == 'Thuis'		
	then
		commandArray[plug.natalya]='On'	
	end
	
--
-- *********************************************************************
--  If she's at home then plug.natalya ON if signal is missed
-- *********************************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[plug.natalya]  == 'Off'		
		and otherdevices[someone.home]  == 'Thuis'		
		and timebetween("07:00:00","21:29:59")
		and (otherdevices[phone.natalya]  == 'On'
		or otherdevices[laptop.natalya]  == 'On')		
	then
		commandArray[plug.natalya]='On'	
	end
	
--
-- *********************************************************************
--  If she aint at home or sleeping then plug.natalya OFF after x minutes
-- *********************************************************************
--
	
	if devicechanged[lux_sensor.upstairs]
		and otherdevices[plug.natalya]  == 'On'		
		and powerusage(watt.natalya) <= watt.media_usage
		and timedifference(otherdevices_lastupdate[phone.natalya]) > timeout.minutes30
		and timedifference(otherdevices_lastupdate[laptop.natalya]) > timeout.minutes30		
		and timedifference(otherdevices_lastupdate[plug.natalya]) > timeout.minutes30
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) > timeout.minutes30
		and otherdevices[phone.natalya]  == 'Off'
		and otherdevices[laptop.natalya]  == 'Off'		
	then
		commandArray[plug.natalya]='Off'	
	end	
	
--
-- *********************************************************************
--  If she's at home then plug.natalya OFF after x minutes at night
-- *********************************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[plug.natalya]  == 'On'
		and otherdevices[laptop.natalya]  == 'Off'
		and weekend('false')		
		and powerusage(watt.natalya) <= watt.media_usage
		and (timebetween("21:30:00","23:59:59")	or timebetween("00:00:00","06:59:59"))
	then
		commandArray[plug.natalya]='Off'	
	end

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[plug.natalya]  == 'On'
		and otherdevices[laptop.natalya]  == 'Off'
		and weekend('true')		
		and powerusage(watt.natalya) <= watt.media_usage
		and (timebetween("22:30:00","23:59:59")	or timebetween("00:00:00","06:59:59"))
	then
		commandArray[plug.natalya]='Off'	
	end		