--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 5min"}) then return end

--
-- **********************************************************
-- Living lights ON @ AWAY
-- **********************************************************
--
	
	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Feestdagen"] ~= 'Kerst Binnen/Buiten'
		and otherdevices["AllPurpose1"] == 'Off' 
		and otherdevices["Personen"] == 'Weg'
		and timebetween("16:30:00","21:59:59")
		and sensorValue('Woonkamer_Gem_Lux') <= 20
		--and dark('true', 'living', 20)
	then
		switchDevice("AllPurpose1", "On")
		switchDevice("Woonkamer_Spotjes", "Set Level 5")
		debugLog('Woonkamer ingeschakeld @ AWAY')
	end

--
-- **********************************************************
-- Living light OFF @ AWAY
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Feestdagen"] ~= 'Kerst Binnen/Buiten'
		and otherdevices["AllPurpose1"] == 'On' 
		and otherdevices["Personen"] ~= 'Aanwezig'
		and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
	then
		switchDevice("AllPurpose1", "Off")
		switchDevice("Woonkamer_Spotjes", "Off")
		debugLog('Woonkamer uitgeschakeld @ AWAY')
	end
	
--
-- **********************************************************
-- Living lights ON @ AWAY XMAS
-- **********************************************************
--
	
	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Feestdagen"] == 'Kerst Binnen/Buiten'
		and otherdevices["Kerstboom_WCD"] == 'Off' 
		and otherdevices["Personen"] == 'Weg'
		and timebetween("16:30:00","21:59:59")
		and sensorValue('Woonkamer_Gem_Lux') <= 20
		--and dark('true', 'living', 20)
	then
		switchDevice("Kerstboom_WCD", "On")
		switchDevice("Woonkamer_Vloerlamp_Links", "On")
		switchDevice("AllPurpose1", "On")
		debugLog('Woonkamer ingeschakeld @ AWAY')
	end

--
-- **********************************************************
-- Living light OFF @ AWAY XMAS
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Feestdagen"] == 'Kerst Binnen/Buiten'
		and otherdevices["Kerstboom_WCD"] == 'On' 
		and otherdevices["Personen"] ~= 'Aanwezig'
		and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
	then
		switchDevice("Kerstboom_WCD", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")
		switchDevice("AllPurpose1", "Off")
		debugLog('Woonkamer uitgeschakeld @ AWAY')
	end