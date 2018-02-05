--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_daughter.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-31-2018
	@ Script to switch ON/OFF daughter bedroom plug.natalya
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
--  If plug.natalya ON when she arrives at home
-- *********************************************************************
--

	if (devicechanged[phone.natalya]  == 'On' or devicechanged[laptop.natalya]  == 'On')	
		and timebetween("06:00:00","22:29:59")
		and otherdevices[plug.natalya]  == 'Off'
		and otherdevices[someone.home]  == 'Thuis'		
	then
		commandArray[plug.natalya]='On AFTER 1'	
	end
	
--
-- *********************************************************************
--  If she's at home then plug.natalya ON if signal is missed
-- *********************************************************************
--

	if devicechanged[lux_sensor.upstairs]
		and otherdevices[plug.natalya]  == 'Off'
		and otherdevices[phone.natalya]  == 'On'
		and otherdevices[someone.home]  == 'Thuis'		
		and timebetween("06:00:00","22:29:59")		
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
		and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) > timeout.minutes30
		and (otherdevices[phone.natalya]  == 'Off' or otherdevices[someone.home]  ~= 'Thuis')		
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
		and timebetween("22:30:00","23:59:59")
		and powerusage(watt.natalya) <= watt.media_usage
		and weekend('false')		
	then
		commandArray[plug.natalya]='Off'	
	end

-- *********************************************************************
	
	if devicechanged[lux_sensor.upstairs]
		and otherdevices[plug.natalya]  == 'On'
		and timebetween("23:00:00","23:59:59")
		and powerusage(watt.natalya) <= watt.media_usage
		and weekend('true')		
	then
		commandArray[plug.natalya]='Off'	
	end	