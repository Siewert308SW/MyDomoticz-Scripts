--
-- **********************************************************
-- Living lights ON when some one gets home
-- **********************************************************
--
	IsScene = false
	scene	= 'none'
	
	if devicechanged["Personen"] == 'Aanwezig' and powerFailsave('false') then

		if dark('false', 'Woonkamer_LUX', 20) and uservariables["woonkamer_verlichting_auto"] ~= 1 then
			IsScene = true
			scene   = 'one'
			switchDevice("Variable:manual_light", "0")
			
		elseif dark('true', 'Woonkamer_LUX', 20) and dark('false', 'Woonkamer_LUX', 15) and uservariables["woonkamer_verlichting_auto"] ~= 2 then
			IsScene = true
			scene   = 'two'
			switchDevice("Variable:manual_light", "0")
			
		elseif dark('true', 'Woonkamer_LUX', 20) and dark('true', 'Woonkamer_LUX', 15) and uservariables["woonkamer_verlichting_auto"] ~= 2 then
			IsScene = true
			scene   = 'three'
			switchDevice("Variable:manual_light", "0")
			
		end
		
	end

--
-- **********************************************************
-- Living lights OFF when nobody home
-- **********************************************************
--

	if (devicechanged["Personen"] == 'Slapen' or devicechanged["Personen"] == 'Weg') and uservariables["woonkamer_verlichting_auto"] ~= 0 and powerFailsave('false')
	then
		IsScene = true
		scene   = 'off'
		switchDevice("Variable:manual_light", "0")
		debugLog('Woonkamer verlichting uitgeschakeld, niemand aanwezig....')
	end
	
--
-- **********************************************************
-- Living lights ON/OFF when lux is higher/lower then threshold
-- **********************************************************
--

	if devicechanged["Time Trigger 1min"] == 'Off' and otherdevices["Personen"] == 'Aanwezig' and uservariables["manual_light"] == 0 and powerFailsave('false') then

		if dark('false', 'Woonkamer_LUX', 20) and dark('false', 'Woonkamer_LUX', 15) and lastSeenVar("woonkamer_verlichting_auto", ">", 300) and uservariables["woonkamer_verlichting_auto"] ~= 1 then
			IsScene = true
			scene   = 'one'
			
		elseif dark('true', 'Woonkamer_LUX', 20) and dark('false', 'Woonkamer_LUX', 15) and lastSeenVar("woonkamer_verlichting_auto", ">", 300) and uservariables["woonkamer_verlichting_auto"] ~= 2 then
			IsScene = true
			scene   = 'two'
			
		elseif dark('true', 'Woonkamer_LUX', 20) and dark('true', 'Woonkamer_LUX', 15) and lastSeenVar("woonkamer_verlichting_auto", ">", 300) and uservariables["woonkamer_verlichting_auto"] ~= 3 then
			IsScene = true
			scene   = 'three'
			
		end

	end

--
-- **********************************************************
-- Reset manual override
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On' and uservariables["manual_light"] == 1 and timedifference(uservariables_lastupdate["manual_light"]) > 3600 and powerFailsave('false') then
		switchDevice("Variable:manual_light", "0")	
	end
	
--
-- **********************************************************
-- What to do when lights are manualy toggled
-- **********************************************************
--

	if (devicechanged["Woonkamer_Verlichting AAN"] == 'On' or devicechanged["Garage_Controler_Woonkamer AAN"] == 'On') and powerFailsave('false') then
		IsScene = true
		scene   = 'three'
		switchDevice("Personen", "Set Level 10")
		switchDevice("Variable:manual_light", "1")
		debugLog('Woonkamer verlichting manueel ingeschakeld')
	end

-- **********************************************************
		
	if (devicechanged["Woonkamer_Verlichting UIT"] == 'On' or devicechanged["Garage_Controler_Woonkamer UIT"] == 'On') and powerFailsave('false') then	
		IsScene = true
		scene   = 'off'
		if dark('true', 'Woonkamer_LUX', 15) then
			switchDevice("Personen", "Set Level 30")
		end
		switchDevice("Variable:manual_light", "1")
		debugLog('Woonkamer verlichting manueel uitgeschakeld')
	end

--
-- **********************************************************
-- Scenes
-- **********************************************************
--
	
	if IsScene == true and scene == 'one' and powerFailsave('false') then
		switchDevice("Woonkamer_Spotjes-TV-Kast", "On")
		switchDevice("Woonkamer_Spotjes", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "Off")

		switchDevice("Bijkeuken_Spots_Verlichting", "Off")
		switchDevice("Keuken_NIS_Verlichting", "Off")
		switchDevice("Keuken_Cabinet_Verlichting", "On")
		kitchen_spots('On', 10)
			
		switchDevice("Variable:woonkamer_verlichting_auto", "1")
		debugLog('Woonkamer Scene 1 ingeschakeld')
			
	elseif IsScene == true and scene == 'two' and powerFailsave('false') then
		
		switchDevice("Woonkamer_Spotjes-TV-Kast", "On")
		switchDevice("Woonkamer_Spotjes", "Set Level 50")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "Off")

		switchDevice("Bijkeuken_Spots_Verlichting", "Off")
		switchDevice("Keuken_NIS_Verlichting", "Off")
		switchDevice("Keuken_Cabinet_Verlichting", "On")
		kitchen_spots('On', 10)
			
		switchDevice("Variable:woonkamer_verlichting_auto", "2")

		debugLog('Woonkamer Scene 2 ingeschakeld')
		
	elseif IsScene == true and scene == 'three' and powerFailsave('false') then
		switchDevice("Woonkamer_Spotjes-TV-Kast", "On")
		switchDevice("Woonkamer_Spotjes", "Set Level 40")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "On")
		switchDevice("Woonkamer_Vloerlamp_Links", "On")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "On")

		switchDevice("Bijkeuken_Spots_Verlichting", "Set Level 5")
		switchDevice("Keuken_NIS_Verlichting", "Set Level 5")	
		switchDevice("Keuken_Cabinet_Verlichting", "On")
		kitchen_spots('On', 10)
			
		switchDevice("Variable:woonkamer_verlichting_auto", "3")
		debugLog('Woonkamer Scene 3 ingeschakeld')
		
	elseif IsScene == true and scene == 'off' and powerFailsave('false') then
		switchDevice("Woonkamer_Spotjes-TV-Kast", "Off")
		switchDevice("Woonkamer_Spotjes", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "Off")
		
		switchDevice("Bijkeuken_Spots_Verlichting", "Off")
		switchDevice("Keuken_NIS_Verlichting", "Off")
		switchDevice("Keuken_Cabinet_Verlichting", "Off")
		kitchen_spots('Off', 10)

		switchDevice("Variable:woonkamer_verlichting_auto", "0")
		debugLog('Woonkamer verlichting uitgeschakeld')
		
	end