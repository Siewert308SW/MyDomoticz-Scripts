--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Natalya_GSM", "Time Trigger 5min"}) then return end

--
-- **********************************************************
-- Natalya Bedroom WCD ON
-- **********************************************************
--
	if (devicechanged["Time Trigger 5min"] == 'On' or devicechanged["Natalya_GSM"] == 'On')
		and otherdevices["Natalya_GSM"] == 'On'
		and otherdevices["Natalya_WCD"] == 'Off'
	then
		switchDevice("Natalya_WCD", "On")
		debugLogVar('Natalya is thuis, Slaapkamer uit standby')
	end

--
-- **********************************************************
-- Natalya Bedroom WCD OFF
-- **********************************************************
--
	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Natalya_GSM"] == 'Off'
		and otherdevices["Natalya_WCD"] == 'On'
		and lastSeen('Natalya_GSM', '>=', '300')
		and lastSeen('Natalya_WCD', '>=', '1200')
	then
		switchDevice("Natalya_WCD", "Off")
		switchDevice("Natalya_Verlichting", "Off")
		debugLogVar('Natalya is weg, Slaapkamer in standby')
	end