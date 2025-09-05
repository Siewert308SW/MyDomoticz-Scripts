--
-- *********************************************************************
-- Toilet light ON when motion detection
-- *********************************************************************
--

	if devicechanged["Toilet_Motion"] == 'On'
		and otherdevices["Toilet_Verlichting"] == 'Off'
		and otherdevices["Personen"] == 'Aanwezig'
		and lastSeen("Toilet_Verlichting", ">", 10)
		and powerFailsave('false')
	then
		switchDevice("Toilet_Verlichting", "On")
		--debugLog('Toilet verlichting AAN')
	end
	
--
-- *********************************************************************
-- Toilet light OFF after X minutes when no motion detected
-- *********************************************************************
--

	if devicechanged["Time Trigger 1min"] == 'On'
		and otherdevices["Toilet_Verlichting"] == 'On'
		and otherdevices["Toilet_Motion"] == 'Off'
		and lastSeen("Toilet_Motion", ">=", 240)	
		and lastSeen("Toilet_Verlichting", ">=", 140)
		and powerFailsave('false')		
	then
		switchDevice("Toilet_Verlichting", "Off")
		--debugLog('Toilet verlichting UIT.Geen beweging meer gezien')
	end