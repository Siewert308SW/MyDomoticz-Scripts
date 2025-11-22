--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen", "Time Trigger 1min"}) then return end
	
--
-- *********************************************************************
-- WalkIn closet light OFF after X minutes when no motion detected
-- *********************************************************************
--

	if (devicechanged["Time Trigger 1min"] == 'On' or devicechanged["Personen"] == 'Slapen' or devicechanged["Personen"] == 'Weg')
		and otherdevices["WalkIn_Verlichting"] == 'On'
		and otherdevices["Overloop_Verlichting"] == 'Off'
		and lastSeen("WalkIn_Verlichting", ">=", 1200)
		and lastSeen("Overloop_Motion", ">=", 600)
		and lastSeen("Overloop_Deur", ">=", 600)
		and powerFailsave('false')		
	then
		switchDevice("WalkIn_Verlichting", "Off")
		debugLog('WalkIn verlichting UIT #Failsave')
	end