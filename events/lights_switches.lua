--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"WoonkamerContr_Verlichting_AAN", "WoonkamerContr_Verlichting_UIT", "BijkeukenContr_Verlichting_AAN", "BijkeukenContr_Verlichting_UIT"}) then return end

--
-- **********************************************************
-- What to do when lights are manualy toggled
-- **********************************************************
--

	if (devicechanged["WoonkamerContr_Verlichting_AAN"] == 'On' or devicechanged["BijkeukenContr_Verlichting_AAN"] == 'On') and powerFailsave('false') then
		switchDevice("Scene:Woonkamer Three", "On")
		kitchen_spots('On', 10)
		switchDevice("Personen", "Set Level 40") -- START
		switchDevice("Variable:manual_light", "1")
		switchDevice("Variable:woonkamer_verlichting_auto", "0")
		debugLog('Woonkamer verlichting manueel ingeschakeld')
	end

-- **********************************************************
		
	if (devicechanged["WoonkamerContr_Verlichting_UIT"] == 'On' or devicechanged["BijkeukenContr_Verlichting_UIT"] == 'On') and powerFailsave('false') then	
		switchDevice("Scene:Woonkamer Shutdown", "On")
		switchDevice("Personen", "Set Level 50") -- STOP
		switchDevice("Variable:manual_light", "1")
		switchDevice("Variable:woonkamer_verlichting_auto", "0")
		debugLog('Woonkamer verlichting manueel uitgeschakeld')
	end
