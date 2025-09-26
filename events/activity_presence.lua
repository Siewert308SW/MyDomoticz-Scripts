--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen", "Voor_Deur", "Garage_Deur", "Achter_Deur", "Hal_Deur", "Bijkeuken_Deur", "Overloop_Deur", "Time Trigger 5min"}) then return end

--
-- **********************************************************
-- Personen Thuis
-- **********************************************************
--

	if (devicechanged["Voor_Deur"] == 'Open'
		or devicechanged["Garage_Deur"] == 'Open'
		or devicechanged["Achter_Deur"] == 'Open'
		or devicechanged["Hal_Deur"] == 'Open'
		or devicechanged["Bijkeuken_Deur"] == 'Open'
		or devicechanged["Overloop_Deur"] == 'Open')
		and (otherdevices["Personen"] ~= 'Aanwezig' or uservariables["manual_light"] == 1)
		and lastSeen("Personen", ">", 60)
		and lastSeen("Woonkamer_Verlichting UIT", ">", 120)
		and lastSeen("Garage_Controler_Woonkamer UIT", ">", 120)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 40") -- START
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
		and motionHome('false', 3600)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 50") -- STOP
		debugLog('Iedereen slaapt (1hr trigger)')
	end

	if devicechanged["Time Trigger 5min"] == 'Off'
		and phonesOnline('true')
		and laptopsOnline('false')
		and mediaOnline('false')
		and otherdevices["Personen"] == 'Standby'
		and motionHome('false', 300)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 50") -- STOP
		debugLog('Iedereen slaapt (2min trigger)')
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
		and motionHome('false', 600)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 50") -- STOP
		debugLog('Niemand thuis (10min trigger)')
	end

	if devicechanged["Time Trigger 5min"] == 'Off'
		and phonesOnline('false')
		and laptopsOnline('false')
		and mediaOnline('false')
		and otherdevices["Personen"] == 'Standby'
		and motionHome('false', 300)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 50") -- STOP
		debugLog('Niemand thuis (2min trigger)')
	end

--
-- **********************************************************
-- Personen Start/Stop
-- **********************************************************
--
	
	if devicechanged["Personen"] == 'Start'
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Personen"] = "Set Level 10 AFTER 8"}
		debugLog('Iemand thuis, huis wordt opgestart')
	end

-- **********************************************************
	
	if devicechanged["Personen"] == 'Stop'
		and powerFailsave('false')
	then

		if phonesOnline('true') then
		commandArray[#commandArray+1]={["Personen"] = "Set Level 20 AFTER 8"}
		debugLog('Iedereen slaapt, huis wordt afgesloten')
		
		elseif phonesOnline('false') then
		commandArray[#commandArray+1]={["Personen"] = "Set Level 0 AFTER 8"}
		debugLog('Niemand thuis, huis wordt afgesloten')		
		end

	end