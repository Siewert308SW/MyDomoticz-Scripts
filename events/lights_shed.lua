--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************

	if not isMyTrigger({"Fietsenschuur_Deur", "Time Trigger 5min"}) then return end

--
-- *********************************************************************
-- Shed light ON
-- *********************************************************************
--

	if devicechanged["Fietsenschuur_Deur"] == 'Open'
		and otherdevices["Fietsenschuur_Verlichting"] == 'Off'
		and lastSeen("Fietsenschuur_Verlichting", ">", 2)
		and lastSeen("Fietsenschuur_Motion", ">", 60)
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
--[[
	if devicechanged["Fietsenschuur_Deur"] == 'Closed'
		and otherdevices["Fietsenschuur_Verlichting"] == 'On'
		and lastSeen("Personen", "<", 120)
		and powerFailsave('false')
	then
		switchDevice("Fietsenschuur_Verlichting", "Off")
		debugLog('Niemand meer in de fietsenschuur')
	end
--]]

	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Fietsenschuur_Verlichting"] == 'On'
		and lastSeen("Fietsenschuur_Deur", ">", 300)
		and lastSeen("Fietsenschuur_Verlichting", ">", 300)
		and lastSeen("Fietsenschuur_Motion", ">", 600)
		and powerFailsave('false')
	then
		switchDevice("Fietsenschuur_Verlichting", "Off")
		debugLog('Fietsenschuur verlichting UIT #Failsave')		
	end
