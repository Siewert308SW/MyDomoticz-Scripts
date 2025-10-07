--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"WoonkamerContr_Verlichting_UIT", "BijkeukenContr_Verlichting_UIT", "Rookmelder_Woonkamer", "Rookmelder_Hal", "Rookmelder_Overloop", "Rookmelder_Slaapkamer", "Rookmelder_Natalya", "Rookmelder_Garage", "Rookmelder_Zolder", "Co2-Melder_Zolder" }) then return end

--
-- **********************************************************
-- Panic ON
-- **********************************************************
--
	IsScenePanic = false
	scenePanic	 = 'none'
	
	if (devicechanged["Rookmelder_Woonkamer"]
		or devicechanged["Rookmelder_Hal"]
		or devicechanged["Rookmelder_Overloop"]
		or devicechanged["Rookmelder_Slaapkamer"]
		or devicechanged["Rookmelder_Natalya"]
		or devicechanged["Rookmelder_Garage"]
		or devicechanged["Rookmelder_Zolder"]
		or devicechanged["Co2-Melder_Zolder"])
		and uservariables["panic"] == 0
	then
		IsScenePanic = true
		scenePanic = 'panic_smoke'
	end

--
-- **********************************************************
-- Panic OFF
-- **********************************************************
--

	if (devicechanged["WoonkamerContr_Verlichting_UIT"] == 'On' or devicechanged["BijkeukenContr_Verlichting_UIT"] == 'On')
		and uservariables["panic"] == 1
	then
		IsScenePanic = true
		scenePanic = 'panic_off'
	end

--
-- **********************************************************
-- Scenes
-- **********************************************************
--
	
	if IsScenePanic == true and scenePanic == 'panic_smoke' and uservariables["panic"] == 0 then

--[[ Switch ON all lights ]]--
		switchDevice("Variable:panic", "1")
		
		if otherdevices["Personen"] ~= 'Weg' and dark('true', 'Woonkamer_LUX', 20) then
		switchDevice("Woonkamer_Spotjes-TV-Kast", "On")
		switchDevice("Woonkamer_Spotjes", "Set Level 100")
		switchDevice("Woonkamer_Vloerlamp_Dressoir", "On")
		switchDevice("Woonkamer_Vloerlamp_Links", "On")	 
		switchDevice("Woonkamer_Vloerlamp_Rechts", "On")
		switchDevice("Bijkeuken_Spots_Verlichting", "Set Level 100")
		switchDevice("Keuken_NIS_Verlichting", "Set Level 100")
		switchDevice("Keuken_Cabinet_Verlichting", "On")
		
		switchDevice("Woonkamer_Salon_Tafel", "On")
		switchDevice("Keuken_Eettafel_Verlichting", "On")
		switchDevice("Slaapkamer_Verlichting", "On")
		switchDevice("Siewert_Nachtlamp", "On")
		switchDevice("Jerina_Nachtlamp", "On")
		switchDevice("Walking_Verlichting", "On")
		
		switchDevice("Badkamer_Verlichting", "On")
		switchDevice("Overloop_Verlichting", "On")
		switchDevice("Garage_Verlichting", "On")
		switchDevice("Hal_Verlichting", "On")
		switchDevice("Fietsenschuur_Verlichting", "On")
		switchDevice("Toilet_Verlichting", "On")
		
		switchDevice("Voordeur_Verlichting", "Set Level 100")	
		switchDevice("Brandgang_Verlichting", "Set Level 100") 
		switchDevice("Fietsenschuur_Buiten_Verlichting", "Set Level 100")		 
		switchDevice("Achterdeur_Verlichting", "Set Level 100")
		end
		
--[[ Switch OFF all appliance ]]--
		switchDevice("Aanrecht_WCD1", "Off")
		switchDevice("Afzuigkap_WCD", "Off")	 
		switchDevice("TV-Kast_WCD", "Off")	 
		switchDevice("Droger_WCD", "Off")	 
		switchDevice("Aanrecht_WCD2", "Off")
		switchDevice("Stofzuiger_WCD", "Off")	 
		switchDevice("Speaker_Keuken_WCD", "Off") 
		switchDevice("Woonkamer_Bank_WCD", "Off") 
		switchDevice("Woonkamer_Fauteuil_WCD", "Off") 
		switchDevice("Voordeur_WCD", "Off")	 
		switchDevice("Achterdeur_WCD", "Off")
		switchDevice("Printer_WCD", "Off")
		switchDevice("BV_Charger_WCD", "Off")
		switchDevice("E-Boiler_WCD", "Off")
		switchDevice("Oven_WCD", "Off")
		
		switchDevice("Woonkamer_Airco_Power", "Off")
		switchDevice("Slaapkamer_Airco_Power", "Off")
		switchDevice("Natalya_Airco_Power", "Off")
		switchDevice("CatFlap", "Off")
		
		--commandArray['SendNotification'] = "Brandalarm#Alarm is gereset###1;2#fcm"
		debugLog('Brandalarm: Panic Mode is ingeschakeld')
		
	elseif IsScenePanic == true and scenePanic == 'panic_off' and uservariables["panic"] == 1 then
		switchDevice("Variable:panic", "0")
		debugLog('Brandalarm: Panic Mode is uitgeschakeld')
		
	end