--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen", "Time Trigger 5min", "Time Trigger 10min", "Woonkamer_Verlichting AAN", "Garage_Controler_Woonkamer AAN", "Woonkamer_Verlichting UIT", "Garage_Controler_Woonkamer UIT"}) then return end

--
-- **********************************************************
-- Living lights ON when some one gets home
-- **********************************************************
--
	IsScene = false
	scene	= 'none'
	
	if devicechanged["Personen"] == 'Start' and lastSeenVar("woonkamer_verlichting_auto", ">", 10) and powerFailsave('false') then

		if dark('false', 'living', 20) and uservariables["woonkamer_verlichting_auto"] ~= 1 then
			IsScene = true
			scene   = 'one'
			switchDevice("Variable:manual_light", "0")
			
		elseif dark('true', 'living', 15) and dark('false', 'living', 10) and uservariables["woonkamer_verlichting_auto"] ~= 2 then
			IsScene = true
			scene   = 'two'
			switchDevice("Variable:manual_light", "0")
			
		elseif dark('true', 'living', 10) and uservariables["woonkamer_verlichting_auto"] ~= 3 then
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

	if (devicechanged["Personen"] == 'Slapen' or devicechanged["Personen"] == 'Weg') and uservariables["manual_light"] ~= 0 and powerFailsave('false')
	then
		IsScene = true
		scene   = 'shutdown'
		switchDevice("Variable:manual_light", "0")
		--debugLog('Woonkamer verlichting uitgeschakeld, niemand aanwezig....')
	end
	
--
-- **********************************************************
-- Living lights ON/OFF when lux is higher/lower then threshold  and timebetween(sunTime("sunsetEarly"),"23:59:59")
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'Off' and otherdevices["Personen"] == 'Aanwezig' and uservariables["manual_light"] == 0 and powerFailsave('false') then

		if dark('false', 'living', 20) and lastSeenVar("woonkamer_verlichting_auto", ">", 300) and uservariables["woonkamer_verlichting_auto"] ~= 1 then
			IsScene = true
			scene   = 'one'
			
		elseif dark('true', 'living', 15) and dark('false', 'living', 13) and lastSeenVar("woonkamer_verlichting_auto", ">", 300) and uservariables["woonkamer_verlichting_auto"] ~= 2 then
			IsScene = true
			scene   = 'two'
			
		elseif dark('true', 'living', 12) and lastSeenVar("woonkamer_verlichting_auto", ">", 300) and uservariables["woonkamer_verlichting_auto"] ~= 3 and timebetween(sunTime("sunsetEarly"),"23:59:59") then
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
		switchDevice("Personen", "Set Level 40") -- START
		switchDevice("Variable:manual_light", "1")
		debugLog('Woonkamer verlichting manueel ingeschakeld')
	end

-- **********************************************************
		
	if (devicechanged["Woonkamer_Verlichting UIT"] == 'On' or devicechanged["Garage_Controler_Woonkamer UIT"] == 'On') and powerFailsave('false') then	
		IsScene = true
		scene   = 'shutdown'
		--if dark('true', 'living', 10) then
			switchDevice("Personen", "Set Level 30") -- STANDBY
		--end
		switchDevice("Variable:manual_light", "1")
		debugLog('Woonkamer verlichting manueel uitgeschakeld')
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
	
--
-- **********************************************************
-- Scenes
-- **********************************************************
--
	
	if IsScene == true and scene == 'one' and uservariables["woonkamer_verlichting_auto"] ~= 1 and powerFailsave('false') then
		switchDevice("Woonkamer_Spotjes-TV-Kast", "On")
		switchDevice("Woonkamer_Spotjes", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "Off")

		switchDevice("Bijkeuken_Spots_Verlichting", "Off")
		switchDevice("Bijkeuken_NIS_Verlichting", "Off")
		switchDevice("Keuken_Cabinet_Verlichting", "On")
		kitchen_spots('On', 35)
		--switchDevice("Keuken_Spots", "On")
		
		switchDevice("Variable:woonkamer_verlichting_auto", "1")
		debugLog('Woonkamer Scene 1 ingeschakeld')
			
	elseif IsScene == true and scene == 'two' and uservariables["woonkamer_verlichting_auto"] ~= 2 and powerFailsave('false') then
		
		switchDevice("Woonkamer_Spotjes-TV-Kast", "On")
		switchDevice("Woonkamer_Spotjes", "Set Level 55")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "Off")

		switchDevice("Bijkeuken_Spots_Verlichting", "Off")
		switchDevice("Bijkeuken_NIS_Verlichting", "Off")
		switchDevice("Keuken_Cabinet_Verlichting", "On")
		kitchen_spots('On', 35)
		--switchDevice("Keuken_Spots", "On")
					
		switchDevice("Variable:woonkamer_verlichting_auto", "2")
		debugLog('Woonkamer Scene 2 ingeschakeld')
		
	elseif IsScene == true and scene == 'three' and uservariables["woonkamer_verlichting_auto"] ~= 3 and powerFailsave('false') then
		switchDevice("Woonkamer_Spotjes-TV-Kast", "On")
		switchDevice("Woonkamer_Spotjes", "Set Level 45")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "On")
		switchDevice("Woonkamer_Vloerlamp_Links", "On")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "On")

		switchDevice("Bijkeuken_Spots_Verlichting", "Set Level 22")
		switchDevice("Bijkeuken_NIS_Verlichting", "Set Level 22")	
		switchDevice("Keuken_Cabinet_Verlichting", "On")
		kitchen_spots('On', 35)
		--switchDevice("Keuken_Spots", "On")
					
		switchDevice("Variable:woonkamer_verlichting_auto", "3")
		debugLog('Woonkamer Scene 3 ingeschakeld')

	elseif IsScene == true and scene == 'away' and powerFailsave('false') then
		switchDevice("Woonkamer_Spotjes-TV-Kast", "On")
		switchDevice("Woonkamer_Spotjes", "Set Level 25")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "Off")

		switchDevice("Bijkeuken_Spots_Verlichting", "Off")
		switchDevice("Bijkeuken_NIS_Verlichting", "Off")	
		switchDevice("Keuken_Cabinet_Verlichting", "Off")
		switchDevice("Keuken_Spots", "Off")
			
		switchDevice("Variable:woonkamer_verlichting_auto", "4")
		debugLog('Woonkamer Scene 4 ingeschakeld')
		
	elseif IsScene == true and scene == 'off' and uservariables["woonkamer_verlichting_auto"] ~= 0 and powerFailsave('false') then
		switchDevice("Woonkamer_Spotjes-TV-Kast", "Off")
		switchDevice("Woonkamer_Spotjes", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "Off")
		
		switchDevice("Bijkeuken_Spots_Verlichting", "Off")
		switchDevice("Bijkeuken_NIS_Verlichting", "Off")
		switchDevice("Keuken_Cabinet_Verlichting", "Off")
		switchDevice("Woonkamer_Salon_Tafel", "Off")
		switchDevice("Keuken_Eettafel_Verlichting", "Off")
		switchDevice("Keuken_Spots", "Off")

		switchDevice("Variable:woonkamer_verlichting_auto", "0")
		debugLog('Woonkamer verlichting uitgeschakeld')

	elseif IsScene == true and scene == 'shutdown' and powerFailsave('false') then
		switchDevice("Woonkamer_Spotjes-TV-Kast", "Off")
		switchDevice("Woonkamer_Spotjes", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "Off")
		switchDevice("Woonkamer_Vloerlamp_Links", "Off")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "Off")
		
		switchDevice("Bijkeuken_Spots_Verlichting", "Off")
		switchDevice("Bijkeuken_NIS_Verlichting", "Off")
		switchDevice("Keuken_Cabinet_Verlichting", "Off")
		switchDevice("Keuken_Spots", "Off")

		switchDevice("Garage_Verlichting", "Off")
		switchDevice("Hal_Verlichting", "Off")
		switchDevice("Woonkamer_Salon_Tafel", "Off")
		switchDevice("Keuken_Eettafel_Verlichting", "Off")
		switchDevice("Keukenplint_Verlichting", "Off")
		
		switchDevice("Variable:woonkamer_verlichting_auto", "0")
		debugLog('Woonkamer verlichting uitgeschakeld')		
	end