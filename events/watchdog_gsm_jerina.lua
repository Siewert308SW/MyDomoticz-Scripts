--
-- **********************************************************
-- Jerina Phone ON
-- **********************************************************
--
	if (devicechanged["Time Trigger 5min"] == 'Off' or devicechanged["Jerina_GSM"] == 'On')
		and otherdevices["Jerina_GSM"] == 'On'
		and otherdevices["Jerina_Laptop_WCD"] == 'Off'
	then
		switchDevice("Jerina_Laptop_WCD", "On")
		--debugLog('Jerina is thuis, Laptop_WCD uit standby')
	end

--
-- **********************************************************
-- Jerina Phone OFF
-- **********************************************************
--
	if devicechanged["Time Trigger 5min"] == 'Off'
		and otherdevices["Jerina_GSM"] == 'Off'
		and otherdevices["Jerina_Laptop_WCD"] == 'On'
		and lastSeen('Jerina_GSM', '>=', '300')
		and lastSeen('Jerina_Laptop_WCD', '>=', '1200')
	then
		switchDevice("Jerina_Laptop_WCD", "Off")
		--debugLog('Jerina is weg, Laptop_WCD in standby')
	end