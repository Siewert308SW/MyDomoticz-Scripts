--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen", "Time Trigger 5min", "Time Trigger 10min", "WoonkamerContr_Verlichting_AAN", "WoonkamerContr_Verlichting_UIT", "BijkeukenContr_Verlichting_AAN", "BijkeukenContr_Verlichting_UIT"}) then return end

--
-- **********************************************************
-- Living lights ON when some one gets home
-- **********************************************************
--
	
	if devicechanged["Personen"] == 'Start' and lastSeenVar("woonkamer_verlichting_auto", ">", 10) and powerFailsave('false') then
		if dark('false', 'living', 20) and uservariables["woonkamer_verlichting_auto"] ~= 1 then
			commandArray[#commandArray+1]={["Scene:Woonkamer One"] = "On"}
			kitchen_spots('On', 60)
			switchDevice("Variable:manual_light", "0")
			switchDevice("Variable:woonkamer_verlichting_auto", "1")
			debugLog('Woonkamer Scene 1 ingeschakeld')
			
		elseif dark('true', 'living', 20) and dark('false', 'living', 10) and uservariables["woonkamer_verlichting_auto"] ~= 2 then
			commandArray[#commandArray+1]={["Scene:Woonkamer Two"] = "On"}
			kitchen_spots('On', 60)
			switchDevice("Variable:manual_light", "0")
			switchDevice("Variable:woonkamer_verlichting_auto", "2")
			debugLog('Woonkamer Scene 2 ingeschakeld')			
			
		elseif dark('true', 'living', 10) and uservariables["woonkamer_verlichting_auto"] ~= 3 then
			commandArray[#commandArray+1]={["Scene:Woonkamer Three"] = "On"}
			kitchen_spots('On', 60)
			switchDevice("Variable:manual_light", "0")
			switchDevice("Variable:woonkamer_verlichting_auto", "3")
			debugLog('Woonkamer Scene 3 ingeschakeld')			
			
		end
		
	end

--
-- **********************************************************
-- Living lights OFF when nobody home
-- **********************************************************
--

	--if (devicechanged["Personen"] == 'Slapen' or devicechanged["Personen"] == 'Weg') and uservariables["woonkamer_verlichting_auto"] ~= 0 and powerFailsave('false')
	if devicechanged["Personen"] == 'Stop' 
		and (uservariables["manual_light"] == 0 or uservariables["woonkamer_verlichting_auto"] ~= 0) and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Shutdown"] = "On"}
		switchDevice("Variable:manual_light", "0")
		switchDevice("Variable:woonkamer_verlichting_auto", "0")
		--debugLog('Woonkamer verlichting uitgeschakeld, niemand aanwezig....')
	end
	
--
-- **********************************************************
-- Living lights ON/OFF when lux is higher/lower then threshold  and timebetween(sunTime("sunsetEarly"),"23:59:59")
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'Off' and otherdevices["Personen"] == 'Aanwezig' and uservariables["manual_light"] == 0 and powerFailsave('false') then

		if dark('false', 'living', 20) and lastSeenVar("woonkamer_verlichting_auto", ">", 3) and uservariables["woonkamer_verlichting_auto"] ~= 1 then
			commandArray[#commandArray+1]={["Scene:Woonkamer One"] = "On"}
			kitchen_spots('On', 30)
			switchDevice("Variable:woonkamer_verlichting_auto", "1")
			debugLog('Woonkamer Scene 1 ingeschakeld')			
			
		elseif dark('true', 'living', 20) and dark('false', 'living', 10) and lastSeenVar("woonkamer_verlichting_auto", ">", 3) and uservariables["woonkamer_verlichting_auto"] ~= 2 then
			commandArray[#commandArray+1]={["Scene:Woonkamer Two"] = "On"}
			kitchen_spots('On', 30)
			switchDevice("Variable:woonkamer_verlichting_auto", "2")
			debugLog('Woonkamer Scene 2 ingeschakeld')			
			
		elseif dark('true', 'living', 10) and lastSeenVar("woonkamer_verlichting_auto", ">", 3) and uservariables["woonkamer_verlichting_auto"] ~= 3 then
			commandArray[#commandArray+1]={["Scene:Woonkamer Three"] = "On"}
			kitchen_spots('On', 30)
			switchDevice("Variable:woonkamer_verlichting_auto", "3")
			debugLog('Woonkamer Scene 3 ingeschakeld')			
			
		end

	end
	
--
-- **********************************************************
-- What to do when lights are manualy toggled
-- **********************************************************
--

	if (devicechanged["WoonkamerContr_Verlichting_AAN"] == 'On' or devicechanged["BijkeukenContr_Verlichting_AAN"] == 'On') and powerFailsave('false') then
		commandArray[#commandArray+1]={["Scene:Woonkamer Three"] = "On"}
		kitchen_spots('On', 10)
		switchDevice("Personen", "Set Level 40") -- START
		switchDevice("Variable:manual_light", "1")
		switchDevice("Variable:woonkamer_verlichting_auto", "0")
		debugLog('Woonkamer verlichting manueel ingeschakeld')
	end

-- **********************************************************
		
	if (devicechanged["WoonkamerContr_Verlichting_UIT"] == 'On' or devicechanged["BijkeukenContr_Verlichting_UIT"] == 'On') and powerFailsave('false') then	
		commandArray[#commandArray+1]={["Scene:Woonkamer Shutdown"] = "On"}
		switchDevice("Personen", "Set Level 50") -- STOP
		switchDevice("Variable:manual_light", "1")
		switchDevice("Variable:woonkamer_verlichting_auto", "0")
		debugLog('Woonkamer verlichting manueel uitgeschakeld')
	end

--
-- **********************************************************
-- Reset manual override
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On' and uservariables["manual_light"] == 1 and timedifference(uservariables_lastupdate["manual_light"]) > 600 and powerFailsave('false') then
		switchDevice("Variable:manual_light", "0")	
	end
	
--
-- **********************************************************
-- Check if Kitchen spots are dimmed correctly
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'Off'
		and otherdevices["Personen"] == 'Aanwezig'
		and uservariables["manual_light"] == 0
		and uservariables["woonkamer_verlichting_auto"] ~= 0
		and sensorValue('Keuken_Spots_Huidige_Verbruik') > 2
		and powerFailsave('false')  
	then
		kitchen_spots('On', 10)
	end
	