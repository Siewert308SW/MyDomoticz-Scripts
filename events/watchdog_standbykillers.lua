--
-- **********************************************************
-- Non controled lights OFF when no motion detected for x minutes
-- **********************************************************
--



	if devicechanged["Garage Temp Trigger"] == 'Off'
		and otherdevices["Thuis"] == 'On'
		and uservariables["panic"] == 0
		and (otherdevices["Achterdeur_WCD"] == 'Off'
		or otherdevices["Voordeur_WCD"] == 'Off'
		or otherdevices["Jerina_Lapptop_WCD"] == 'Off'
		or otherdevices["Raspberry_Fan_WCD"] == 'Off'	
		or otherdevices["Afzuigkap_WCD"] == 'Off'	
		or otherdevices["Droger_WCD"] == 'Off'	
		or otherdevices["Stofzuiger_WCD"] == 'Off'	
		or otherdevices["TV-Kast_WCD"] == 'Off'	
		or otherdevices["Aanrecht_WCD1"] == 'Off'	
		or otherdevices["Aanrecht_WCD2"] == 'Off'
		or otherdevices["Vaatwasser_WCD"] == 'Off'	
		or otherdevices["Wasmachine_WCD"] == 'Off')
	then
			print("")
			print("-- *********************")
			print("-- Standbykillers: Stond schijnbaar nog eentje uit!")
			print("-- *********************")
			print("")
		if otherdevices["Achterdeur_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Achterdeur_WCD"] = "On"}
		end

		if otherdevices["Voordeur_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "On"}
		end

		if otherdevices["Jerina_Lapptop_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Jerina_Lapptop_WCD"] = "On"}
		end	

		if otherdevices["Raspberry_Fan_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Raspberry_Fan_WCD"] = "On"}
		end	

		if otherdevices["Afzuigkap_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Afzuigkap_WCD"] = "On"}
		end	

		if otherdevices["Droger_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Droger_WCD"] = "On"}
		end	

		if otherdevices["Stofzuiger_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Stofzuiger_WCD"] = "On"}
		end	

		if otherdevices["TV-Kast_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["TV-Kast_WCD"] = "On"}	
		end	

		if otherdevices["Aanrecht_WCD1"] == 'Off' then
		commandArray[#commandArray+1]={["Aanrecht_WCD1"] = "On"}
		end	

		if otherdevices["Aanrecht_WCD2"] == 'Off' then
		commandArray[#commandArray+1]={["Aanrecht_WCD2"] = "On"}
		end

		if otherdevices["Vaatwasser_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Vaatwasser_WCD"] = "On"}
		end	

		if otherdevices["Wasmachine_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Wasmachine_WCD"] = "On"}
		end

	end	