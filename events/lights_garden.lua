--
-- **********************************************************
-- Garden lights ON when LUX is lower then threshold
-- **********************************************************
--
	IssceneGarden = false
	sceneGarden = 'none'
	
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and uservariables["tuin_activity"] == 0
		and darkGarden('true', 10)
		and timebetween("16:00:00","22:59:59")
		and powerFailsave('false')
	then
		IsSceneGarden = true
		sceneGarden = 'on'
	end

--
-- **********************************************************
-- Garden lights OFF when LUX is higher then threshold
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Voordeur_Verlichting"] ~= 'Off'
		and uservariables["tuin_activity"] == 0
		and darkGarden('false', 10)
		and powerFailsave('false')
	then
		IsSceneGarden = true
		sceneGarden = 'off'
	end

--
-- **********************************************************
-- Garden light OFF at specific time
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Voordeur_Verlichting"] ~= 'Off' 
		and uservariables["tuin_activity"] == 0
		and motionGarden('false', 1800)
		and (timebetween("23:00:00","23:59:59") or timebetween("00:00:00","15:59:59"))
		and powerFailsave('false')
	then
	
		if weekend('false')
			and (timebetween("23:00:00","23:59:59") or timebetween("00:00:00","15:59:59"))
		then
			IsSceneGarden = true
			sceneGarden = 'off'
			
		elseif weekend('true')
			and otherdevices["Personen"] ~= 'Aanwezig'
			and (timebetween("23:59:59","23:59:59") or timebetween("00:00:00","15:59:59"))
		then
			IsSceneGarden = true
			sceneGarden = 'off'	
		end
		
	end

--
-- **********************************************************
-- Scenes
-- **********************************************************
--
	
	if IsSceneGarden == true and sceneGarden == 'on' and powerFailsave('false') then
		switchDevice("Voordeur_Verlichting", "Set Level 7")	
		switchDevice("Brandgang_Verlichting", "Set Level 7") 
		switchDevice("Fietsenschuur_Buiten_Verlichting", "Set Level 7")		 
		switchDevice("Achterdeur_Verlichting", "Set Level 7")	
		debugLog('Tuin verlichting ingeschakeld')

	elseif IsSceneGarden == true and sceneGarden == 'off' and powerFailsave('false') then
		switchDevice("Achterdeur_Verlichting", "Off")
		switchDevice("Fietsenschuur_Buiten_Verlichting", "Off")
		switchDevice("Brandgang_Verlichting", "Off") 
		switchDevice("Voordeur_Verlichting", "Off")
		debugLog('Tuin verlichting uitgeschakeld')
	end