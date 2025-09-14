--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Overloop_Motion", "Overloop_Deur", "Time Trigger 1min"}) then return end

--
-- **********************************************************
-- Corridor light ON
-- **********************************************************
--

	if devicechanged["Overloop_Motion"] == 'On'
		and otherdevices["Personen"] == 'Aanwezig'
		and otherdevices["Overloop_Verlichting"] == 'Off'
		and lastSeen("Overloop_Verlichting", ">=", 30)
		and timebetween("08:30:00","21:59:59")
		and dark('true', 'Overloop_LUX', 10)	
		and powerFailsave('false')
	then
		switchDevice("Overloop_Verlichting", "On")
		debugLogVar('Iemand op de overloop')
	end

	if devicechanged["Overloop_Deur"] == 'Open'
		and otherdevices["Personen"] == 'Aanwezig'
		and otherdevices["Overloop_Verlichting"] == 'Off'
		and lastSeen("Overloop_Verlichting", ">=", 30)
		and lastSeen("Overloop_Motion", ">=", 30)
		and timebetween("08:30:00","21:59:59")
		and dark('true', 'Overloop_LUX', 10)
		and powerFailsave('false')
	then
		switchDevice("Overloop_Verlichting", "On")
		debugLogVar('Iemand naar de overloop')
	end	
--
-- *********************************************************************
-- Corridor light OFF
-- *********************************************************************
--

	if devicechanged["Time Trigger 1min"] == 'On'
		and otherdevices["Overloop_Verlichting"] == 'On'
		and lastSeen("Overloop_Verlichting", ">=", 120)
		and lastSeen("Overloop_Motion", ">=", 120)
		and lastSeen("Overloop_Deur", ">=", 120)
		and powerFailsave('false')		
	then		
		switchDevice("Overloop_Verlichting", "Off")
		debugLogVar('Niemand meer op de overloop #Failsave')
	end