--
-- **********************************************************
-- Garage Heater ON/OFF (Someone home)
-- **********************************************************
--

	if devicechanged["Garage Temp Trigger"] == 'Off'
	    --and otherdevices["Dummy"] == 'On'
		and otherdevices_temperature["Gemiddelde_Temp_Buiten"] < 15
		and powerusage("BV_Charger_Huidige_Verbruik") <= 700
		and powerusage("Droger_Huidige_Verbruik") <= 300
		and powerfailsave("false")
		and uservariables["panic"] == 0	
	then
	
		temperature_garage 		= otherdevices_temperature["Gemiddelde_Temp_Garage"]
		temperature_garage_round  = round(temperature_garage,2)

		temperature_outside 		= otherdevices_temperature["Gemiddelde_Temp_Buiten"]
		temperature_outside_round = round(temperature_outside,2)

--
-- **********************************************************
-- Garage Heater ON/OFF
-- **********************************************************
--
		
		if temperature_garage_round <= (19.1)
			and otherdevices["Garage_Heater_WCD"] == 'Off'
			and timedifference(otherdevices_lastupdate["Garage_Heater_WCD"]) >= 600
			and otherdevices["Garage_Deur"] == 'Closed'
				
		then
			commandArray[#commandArray+1]={["Garage_Heater_WCD"] = "On"}
		end
		
		if temperature_garage_round >= (20.0)
			and otherdevices["Garage_Heater_WCD"] == 'On'
			and timedifference(otherdevices_lastupdate["Garage_Heater_WCD"]) >= 300
		then
			commandArray[#commandArray+1]={["Garage_Heater_WCD"] = "Off"}
		end
			
	end

	
--
-- **********************************************************
-- Garage Heater ON/OFF
-- **********************************************************
--

	if devicechanged["Garage Temp Trigger"] == 'On'
		and otherdevices["Garage_Heater_WCD"] == 'On'
		and powerusage("Garage_Heater_Huidige_Verbruik") > 500
		and (powerusage("BV_Charger_Huidige_Verbruik") > 700
		or powerusage("Droger_Huidige_Verbruik") > 300
		or timedifference(otherdevices_lastupdate["Garage_Heater_WCD"]) >= 3600)
		and powerfailsave("false")
		and uservariables["panic"] == 0	
	then
		commandArray[#commandArray+1]={["Garage_Heater_WCD"] = "Off"}
	end
	
--[[
	if devicechanged["Garage Temp Trigger"] == 'On'
		and otherdevices["Garage_Heater_WCD"] == 'On'
		and (powerusage("Wasmachine_Huidige_Verbruik") > 165
		or powerusage("BV_Charger_Huidige_Verbruik") > 450
		or powerusage("Voordeur_WCD_Huidige_Verbruik") > 50
		or powerusage("Achterdeur_WCD_Huidige_Verbruik") > 50
		or powerusage("Droger_Huidige_Verbruik") > 300
		or powerusage("E-Boiler_Huidige_Verbruik") > 2
		or powerusage("Vaatwasser_Huidige_Verbruik") > 15
		or otherdevices["Garage_Deur"] == 'Open')
		--and p1NetUsageDeliv("2760") <= 0
		and powerfailsave("false")
		and uservariables["panic"] == 0	
	then
		commandArray[#commandArray+1]={["Garage_Heater_WCD"] = "Off"}
	end
--]]