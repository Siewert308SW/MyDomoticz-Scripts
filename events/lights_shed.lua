--
-- *********************************************************************
-- Shed light ON
-- *********************************************************************
--

	if devicechanged["Fietsenschuur_Deur"] == 'Open'
		and otherdevices["Fietsenschuur_Verlichting"] == 'Off'
		and lastSeen("Fietsenschuur_Verlichting", ">", 2)
		and powerFailsave('false')		
	then
		switchDevice("Fietsenschuur_Verlichting", "On")
		--debugLog('Fietsenschuur verlichting AAN')
	end
	
--
-- *********************************************************************
-- Shed light OFF
-- *********************************************************************
--

	if devicechanged["Fietsenschuur_Deur"] == 'Closed'
		and otherdevices["Fietsenschuur_Verlichting"] == 'On'
		and powerFailsave('false')
	then
		switchDevice("Fietsenschuur_Verlichting", "Off")
		--debugLog('Fietsenschuur verlichting UIT')
	end

	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Fietsenschuur_Verlichting"] ~= 'Off'
		and lastSeen("Fietsenschuur_Deur", ">=", 300)
		and lastSeen("Fietsenschuur_Verlichting", ">=", 300)
		and powerFailsave('false')
	then
		switchDevice("Fietsenschuur_Verlichting", "Off")
		--debugLog('#Failsave: Fietsenschuur verlichting UIT')
	end