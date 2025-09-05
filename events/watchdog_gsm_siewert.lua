--
-- **********************************************************
-- Siewert Phone ON
-- **********************************************************
--
	if (devicechanged["Time Trigger 5min"] == 'Off' or devicechanged["Siewert_GSM"] == 'On')
		and otherdevices["Siewert_GSM"] == 'On'
		and otherdevices["Siewert_Charger"] == 'Off'
	then
		switchDevice("Siewert_Charger", "On")
		--debugLog('Siewert is thuis, Slaapkamer uit standby')
	end

--
-- **********************************************************
-- Siewert Phone OFF
-- **********************************************************
--
	if devicechanged["Time Trigger 5min"] == 'Off'
		and otherdevices["Siewert_GSM"] == 'Off'
		and otherdevices["Siewert_Charger"] == 'On'
		and lastSeen('Siewert_GSM', '>=', '300')
		and lastSeen('Siewert_Charger', '>=', '1200')
	then
		switchDevice("Siewert_Charger", "Off")
		--debugLog('Siewert is weg, Slaapkamer in standby')
	end