--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Fietsenschuur_Deur", "Time Trigger 5min"}) then return end

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
		debugLog('Iemand in de fietsenschuur')
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
		debugLog('Niemand meer in de fietsenschuur')
	end

	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Fietsenschuur_Verlichting"] ~= 'Off'
		and lastSeen("Fietsenschuur_Deur", ">=", 300)
		and lastSeen("Fietsenschuur_Verlichting", ">=", 300)
		and powerFailsave('false')
	then
	
		if otherdevices["Fietsenschuur_Verlichting"] == 'Closed' and lastSeen('Fietsenschuur_Deur', '>=', '300') then
			switchDevice("Fietsenschuur_Verlichting", "Off")
			debugLog('Fietsenschuur verlichting UIT na 300s #Failsave')
			
		elseif otherdevices["Fietsenschuur_Verlichting"] == 'Open' and lastSeen('Fietsenschuur_Deur', '>=', '1800') then
			switchDevice("Fietsenschuur_Verlichting", "Off")
			debugLog('Fietsenschuur verlichting UIT na 1800s #Failsave')		
		end

	end