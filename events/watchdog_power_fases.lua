--
-- **********************************************************
-- FASE 1 Power OFF Failsave
-- **********************************************************
--
	
	if devicechanged["Power_FailsaveL1"] == 'On'
	then		
		commandArray[#commandArray+1]={["Droger_WCD"] = "Off"}
		commandArray[#commandArray+1]={["Garage_Heater_WCD"] = "Off AFTER 1"}
		commandArray[#commandArray+1]={["Quooker_WCD"] = "Off AFTER 2"}
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "Off AFTER 3"}
			print("")
			print("-- *********************")
			print("-- FASE 1: Hoog verbruik")
			print("-- *********************")
			print("")
		--commandArray['SendNotification'] = "Energie verbruik#Verbruik FASE 1 te hoog###1;2#fcm"	
	end

	
--
-- **********************************************************
-- FASE 2 Power OFF Failsave
-- **********************************************************
--

	if devicechanged["Power_FailsaveL2"] == 'On'
	then
		commandArray[#commandArray+1]={["Wasmachine_WCD"] = "Off"}
		commandArray[#commandArray+1]={["Achterdeur_WCD"] = "Off AFTER 1"}
		commandArray[#commandArray+1]={["BV_Charger_WCD"] = "Off AFTER 2"}
			print("")
			print("-- *********************")
			print("-- FASE 2: Hoog verbruik")
			print("-- *********************")
			print("")
		--commandArray['SendNotification'] = "Energie verbruik#Verbruik FASE 2 te hoog###1;2#fcm"	
	end

--
-- **********************************************************
-- FASE 3 Power OFF Failsave
-- **********************************************************
-- 

	if devicechanged["Power_FailsaveL3"] == 'On'
	then
		commandArray[#commandArray+1]={["Boiler_WCD"] = "Off"}
		commandArray[#commandArray+1]={["Vaatwasser_WCD"] = "Off AFTER 1"}
			print("")
			print("-- *********************")
			print("-- FASE 3: Hoog verbruik")
			print("-- *********************")
			print("")
		--commandArray['SendNotification'] = "Energie verbruik#Verbruik FASE 3 te hoog###1;2#fcm"
	end

--
-- **********************************************************
-- FASE 1 Power ON Failsave
-- **********************************************************
--
	
	if devicechanged["Power_FailsaveL1"] == 'Off'
	then
		commandArray[#commandArray+1]={["Droger_WCD"] = "On"}
		commandArray[#commandArray+1]={["Garage_Heater_WCD"] = "On AFTER 1"}
		commandArray[#commandArray+1]={["Quooker_WCD"] = "On AFTER 2"}
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "On AFTER 3"}
			print("")
			print("-- *********************")
			print("-- FASE 1: Genormaliseerd")
			print("-- *********************")
			print("")
		--commandArray['SendNotification'] = "Energie verbruik#Verbruik FASE 1 genormaliseerd###1;2#fcm"	
	end

	
--
-- **********************************************************
-- FASE 2 Power ON Failsave
-- **********************************************************
--

	if devicechanged["Power_FailsaveL2"] == 'Off'
	then
		commandArray[#commandArray+1]={["Wasmachine_WCD"] = "On"}
		commandArray[#commandArray+1]={["Achterdeur_WCD"] = "On AFTER 1"}
		commandArray[#commandArray+1]={["BV_Charger_WCD"] = "On AFTER 2"}
			print("")
			print("-- *********************")
			print("-- FASE 2: Genormaliseerd")
			print("-- *********************")
			print("")
		--commandArray['SendNotification'] = "Energie verbruik#Verbruik FASE 2 genormaliseerd###1;2#fcm"	
	end

--
-- **********************************************************
-- FASE 3 Power ON Failsave
-- **********************************************************
-- 

	if devicechanged["Power_FailsaveL3"] == 'Off'
	then
		commandArray[#commandArray+1]={["Boiler_WCD"] = "On"}
		commandArray[#commandArray+1]={["Vaatwasser_WCD"] = "On AFTER 1"}
			print("")
			print("-- *********************")
			print("-- FASE 3: Genormaliseerd")
			print("-- *********************")
			print("")
		--commandArray['SendNotification'] = "Energie verbruik#Verbruik FASE 3 genormaliseerd###1;2#fcm"	
	end
	