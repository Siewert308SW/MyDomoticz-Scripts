--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Jerina_GSM", "Time Trigger 5min"}) then return end

--
-- **********************************************************
-- Jerina Phone ON
-- **********************************************************
--
	if (devicechanged["Time Trigger 5min"] == 'Off' or devicechanged["Jerina_GSM"] == 'On')
		and otherdevices["Jerina_GSM"] == 'On'
		and otherdevices["Personen"] == 'Aanwezig'
		and otherdevices["Jerina_Laptop_WCD"] == 'Off'
	then
		switchDevice("Jerina_Laptop_WCD", "On")
		debugLog('Jerina Laptop_WCD ingeschakeld')
	end

--
-- **********************************************************
-- Jerina Phone OFF
-- **********************************************************
--
	if devicechanged["Time Trigger 5min"] == 'Off'
		and (otherdevices["Jerina_GSM"] == 'Off' or otherdevices["Personen"] ~= 'Aanwezig')
		and otherdevices["Jerina_Laptop_WCD"] == 'On'
		and lastSeen('Jerina_GSM', '>=', '300')
		and lastSeen('Jerina_Laptop_WCD', '>=', '300')
	then
		switchDevice("Jerina_Laptop_WCD", "Off")
		debugLog('Jerina Laptop_WCD uitgeschakeld')
	end