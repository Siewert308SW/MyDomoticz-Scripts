--
-- **********************************************************
-- Garden lights ON @ motion
-- **********************************************************
--
	IsSceneGardenMotion = false
	sceneGardenMotion   = 'none'
	
	if (devicechanged["Voor_Deur"] == 'Open' or devicechanged["Voordeur_Motion"] == 'On')
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and uservariables["tuin_activity"] == 0
		and darkGarden('true', 10)
		and powerFailsave('false')
	then
		IsSceneGardenMotion = true
		sceneGardenMotion   = 'front'
	end

	if (devicechanged["Achter_Deur"] == 'Open' or devicechanged["Garage_Deur"] == 'Open' or devicechanged["Achterdeur_Motion"] == 'On' or devicechanged["Fietsenschuur_Deur"] == 'Open')
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and uservariables["tuin_activity"] == 0
		and darkGarden('true', 10)
		and powerFailsave('false')
	then
		IsSceneGardenMotion = true
		sceneGardenMotion   = 'back'
	end
	
--
-- **********************************************************
-- Garden lights OFF @ no motion
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Voordeur_Verlichting"] ~= 'Off'
		and uservariables["tuin_activity"] == 1 
		and motionGarden('false', 240)
		and powerFailsave('false')
	then
		IsSceneGardenMotion = true
		sceneGardenMotion   = 'off'
	end
	
--
-- **********************************************************
-- Scenes
-- **********************************************************
--
	
	if IsSceneGardenMotion == true and sceneGardenMotion == 'front' and powerFailsave('false') then
		switchDevice("Voordeur_Verlichting", "Set Level 7")	
		switchDevice("Brandgang_Verlichting", "Set Level 7") 
		switchDevice("Fietsenschuur_Buiten_Verlichting", "Set Level 7")		 
		switchDevice("Achterdeur_Verlichting", "Set Level 7")	
		switchDevice("Variable:tuin_activity", "1")
		debugLog('Garden Motion Voortuin: Tuin verlichting ingeschakeld')
			
	elseif IsSceneGardenMotion == true and sceneGardenMotion == 'back' and powerFailsave('false') then
		switchDevice("Achterdeur_Verlichting", "Set Level 7")
		switchDevice("Fietsenschuur_Buiten_Verlichting", "Set Level 7")
		switchDevice("Brandgang_Verlichting", "Set Level 7") 
		switchDevice("Voordeur_Verlichting", "Set Level 7")		 	
		switchDevice("Variable:tuin_activity", "1")
		debugLog('Garden Motion Achtertuin: Tuin verlichting ingeschakeld')

	elseif IsSceneGardenMotion == true and sceneGardenMotion == 'off' and powerFailsave('false') then
		switchDevice("Achterdeur_Verlichting", "Off")
		switchDevice("Fietsenschuur_Buiten_Verlichting", "Off")
		switchDevice("Brandgang_Verlichting", "Off") 
		switchDevice("Voordeur_Verlichting", "Off")		 	
		switchDevice("Variable:tuin_activity", "0")
		debugLog('Garden Motion: Tuin verlichting uitgeschakeld')
	end