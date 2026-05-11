--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 30min"}) then return end

--
-- **********************************************************
-- Living humidifier ON
-- **********************************************************
--

	if devicechanged["Time Trigger 30min"] == 'On'
		and otherdevices["Kerstboom_WCD"] == 'Off'
		and lastSeen("Kerstboom_WCD", ">=", 3600)
		and humidity('living') <= 46
		and powerFailsave('false')
	then
		switchDevice("Kerstboom_WCD", "On")
	end

--
-- **********************************************************
-- Living humidifier OFF
-- **********************************************************
	
	if devicechanged["Time Trigger 30min"] == 'On'
		and otherdevices["Kerstboom_WCD"] == 'On'
		and lastSeen("Kerstboom_WCD", ">=", 3600)
		and humidity('living') >= 56
		and powerFailsave('false')
	then
		switchDevice("Kerstboom_WCD", "Off")
	end

