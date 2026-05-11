--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Natalya_GSM", "Natalya_School_Lapt0p", "Natalya_Lapt0p", "Time Trigger 5min"}) then return end

--
-- **********************************************************
-- Natalya Bedroom WCD ON
-- **********************************************************
--
	if (devicechanged["Time Trigger 5min"] == 'On' or devicechanged["Natalya_GSM"] == 'On' or devicechanged["Natalya_School_Lapt0p"] == 'On' or devicechanged["Natalya_Lapt0p"] == 'On')
		and otherdevices["Natalya_GSM"] == 'On'
		and otherdevices["Natalya_WCD"] == 'Off'
	then
		switchDevice("Natalya_WCD", "On")
		debugLog('Natalya is thuis, Slaapkamer uit standby')
	end

--
-- **********************************************************
-- Natalya Bedroom WCD OFF
-- **********************************************************
--
	if devicechanged["Time Trigger 5min"] == 'Off'
		and otherdevices["Natalya_GSM"] == 'Off'
		and otherdevices["Natalya_School_Lapt0p"] == 'Off'
		and otherdevices["Natalya_Lapt0p"] == 'Off'
		and otherdevices["Natalya_WCD"] == 'On'
		and otherdevices["Personen"] ~= 'Slapen'
		and lastSeen('Natalya_GSM', '>=', '600')
		and lastSeen('Natalya_School_Lapt0p', '>=', '600')
		and lastSeen('Natalya_Lapt0p', '>=', '600')
		and lastSeen('Natalya_WCD', '>=', '1200')
		and sensorValue('Natalya_WCD_Huidige_Verbruik') < 12
	then
		switchDevice("Natalya_WCD", "Off")
		switchDevice("Natalya_Verlichting", "Off")
		debugLog('Natalya is weg, Slaapkamer in standby')
	end