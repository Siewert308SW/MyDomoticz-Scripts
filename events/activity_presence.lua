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
		and lastSeen("WoonkamerContr_Verlichting_UIT", ">", 120)
		and lastSeen("BijkeukenContr_Verlichting_UIT", ">", 120)
		and powerFailsave('false')
	then
		switchDevice("Personen", "Set Level 40") -- START		
		debugLog('Iemand thuis gekomen')
	end

--
-- **********************************************************
-- Personen Start
-- **********************************************************
--
	
	if devicechanged["Personen"] == 'Start'
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Personen"] = "Set Level 10 AFTER 9"}
		debugLog('Iemand thuis, huis wordt opgestart')
	end
	
--
-- **********************************************************
-- Personen Stop
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
		debugLog('Niemand aanwezig? (1hr trigger)')
	end

	if devicechanged["Time Trigger 5min"] == 'On'
		and phonesOnline('false')
		and laptopsOnline('false')
		and mediaOnline('false')
		and otherdevices["Personen"] == 'Aanwezig'
		and motionHome('false', 300)
		and powerFailsave('false')
	then		
		switchDevice("Personen", "Set Level 50") -- STOP		
		debugLog('Niemand thuis? (5min trigger)')
	end
	
--
-- **********************************************************
-- Personen Slapen/Weg
-- **********************************************************
--
	
	if devicechanged["Time Trigger 5min"] == 'Off'
		and laptopsOnline('false')
		and mediaOnline('false')
		and otherdevices["Personen"] == 'Stop'
		and motionHome('false', 300)
		and powerFailsave('false')
	then

		if phonesOnline('true') then
		commandArray[#commandArray+1]={["Personen"] = "Set Level 20 AFTER 9"}
		debugLog('Iedereen slaapt, huis wordt afgesloten')
		
		elseif phonesOnline('false') then
		commandArray[#commandArray+1]={["Personen"] = "Set Level 0 AFTER 9"}
		debugLog('Niemand thuis, huis wordt afgesloten')		
		end

	end
