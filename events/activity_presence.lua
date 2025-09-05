--
-- **********************************************************
-- Personen Thuis
-- **********************************************************
--
	
	if (devicechanged["Voor_Deur"] == 'Open'
		or devicechanged["Garage_Deur"] == 'Open'
		or devicechanged["Achter_Deur"] == 'Open'
		or devicechanged["Hal_Deur"] == 'Open'
		or devicechanged["Bijkeuken_Deur"] == 'Open')
		and otherdevices["Personen"] ~= 'Aanwezig'
		and lastSeen("Personen", ">", 30)
		and lastSeen("Woonkamer_Verlichting UIT", ">", 30)
		and lastSeen("Garage_Controler_Woonkamer UIT", ">", 30)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 10")
		debugLog('Iemand thuis gekomen')
	end

	if devicechanged["Overloop_Deur"] == 'Open'
		and (otherdevices["Personen"] ~= 'Aanwezig' or uservariables["manual_light"] == 1)
		and lastSeen("Personen", ">", 30)
		and lastSeen("Woonkamer_Verlichting UIT", ">", 60)
		and lastSeen("Garage_Controler_Woonkamer UIT", ">", 60)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 10")
		debugLog('Iemand thuis gekomen')
	end	
--
-- **********************************************************
-- Personen Slapen
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and phonesOnline('true')
		and laptopsOnline('false')
		and mediaOnline('false')
		and otherdevices["Personen"] == 'Aanwezig'
		and otherdevices["Personen"] ~= 'Slapen'
		and motionHome('false', 3600)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 20")
		debugLog('Iedereen slaapt')
	end

	if devicechanged["Time Trigger 5min"] == 'On'
		and phonesOnline('true')
		and laptopsOnline('false')
		and mediaOnline('false')
		and otherdevices["Personen"] == 'Standby'
		and otherdevices["Personen"] ~= 'Slapen'
		and motionHome('false', 120)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 20")
		debugLog('Iedereen slaapt')
	end
--
-- **********************************************************
-- Personen Weg
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and phonesOnline('false')
		and laptopsOnline('false')
		and mediaOnline('false')
		and otherdevices["Personen"] == 'Aanwezig'
		and otherdevices["Personen"] ~= 'Weg'
		and motionHome('false', 120)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 0")
		debugLog('Iedereen weg')
	end