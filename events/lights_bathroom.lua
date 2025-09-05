--
-- *********************************************************************
-- Bathroom light ON when motion detected
-- *********************************************************************
--

	if devicechanged["Badkamer_Motion"] == 'On'
		and otherdevices["Badkamer_Spiegel_Spots"] == 'Off'
		and otherdevices["Badkamer_Verlichting"] == 'Off'
		and otherdevices["Personen"] == 'Aanwezig'
		and timebetween("08:30:00","21:59:59")
		and lastSeen("Badkamer_Spiegel_Spots", ">=", 30)
		and powerFailsave('false')
	then
		switchDevice("Badkamer_Spiegel_Spots", "On")
		switchDevice("Badkamer_Verlichting", "On")
		--debugLog('Iemand in de badkamer')
	end
	
--
-- *********************************************************************
-- Bathroom light OFF after X minutes when no motion detected
-- *********************************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Badkamer_Motion"] == 'Off'
		and(otherdevices["Badkamer_Spiegel_Spots"] == 'On' or otherdevices["Badkamer_Verlichting"] == 'On')
		and lastSeen("Badkamer_Spiegel_Spots", ">=", 1200)
		and lastSeen("Badkamer_Verlichting", ">=", 1200)
		and lastSeen("Badkamer_Motion", ">=", 1200)
		and sensorValue("Watermeter - Current usage") == 0
		and powerFailsave('false')
	then
		switchDevice("Badkamer_Spiegel_Spots", "Off")
		switchDevice("Badkamer_Verlichting", "Off")
		--debugLog('Niemand meer in de badkamer')
	end