--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 5min"}) then return end
	
--
-- **********************************************************
-- XMAS Living lights ON @ AWAY
-- **********************************************************
--
	
	if devicechanged["Time Trigger 5min"] == 'On' 
		and otherdevices["Kerstboom_WCD"] == 'Off' 
		and otherdevices["Personen"] == 'Weg'
		and timebetween("15:30:00","23:59:59")
		and xmasseason('true')
	then
		switchDevice("Kerstboom_WCD", "On")
		switchDevice("Woonkamer_Vloerlamp_Links", "On")
		switchDevice("AllPurpose1", "On")
		--commandArray[#commandArray+1]={["Kerstboom_WCD"] = "On AFTER 30"}
		--commandArray[#commandArray+1]={["Woonkamer_Vloerlamp_Links"] = "On AFTER 35"}
		debugLog('Kerstverlichting woonkamer ingeschakeld')
	end

--
-- **********************************************************
-- XMAS Living light OFF @ AWAY
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On' 
		and otherdevices["Kerstboom_WCD"] == 'On' 
		and otherdevices["Personen"] ~= 'Aanwezig'
		and timebetween("00:15:00",sunTime("sunrise"))
		and xmasseason('true')
	then
		switchDevice("Kerstboom_WCD", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")
		switchDevice("AllPurpose1", "Off")
		--commandArray[#commandArray+1]={["Kerstboom_WCD"] = "Off AFTER 30"}
		--commandArray[#commandArray+1]={["Woonkamer_Vloerlamp_Links"] = "Off AFTER 35"}
		debugLog('Kerstverlichting woonkamer uitgeschakeld')
	end