--
-- **********************************************************
-- Pantry light ON @ door Open
-- **********************************************************
--
	if devicechanged["Kelder_Deur"] == 'Open'
		and otherdevices["Kelder_Verlichting"]  == 'Off'
		and otherdevices["Personen"] == 'Aanwezig'
		and powerFailsave('false')
	then
		switchDevice("Kelder_Verlichting", "On")
		--debugLog('Kelder verlichting AAN')
	end

--
-- **********************************************************
-- Pantry light OFF @ door Closed
-- **********************************************************
--
	if devicechanged["Kelder_Deur"] == 'Closed'
		and otherdevices["Kelder_Verlichting"]  == 'On'
		and powerFailsave('false')
	then		
		switchDevice("Kelder_Verlichting", "Off")
		--debugLog('Kelder verlichting UIT')
	end

--
-- **********************************************************
-- Pantry light OFF #Failsave
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Kelder_Verlichting"]  == 'On'	
		and lastSeen('Kelder_Deur', '>=', '300')
		and lastSeen('Kelder_Verlichting', '>=', '300')	
		and powerFailsave('false')		
	then		
		switchDevice("Kelder_Verlichting", "Off")
		--debugLog('Kelder verlichting UIT #Failsave')
	end