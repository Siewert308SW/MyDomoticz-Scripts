--
-- *********************************************************************
-- Watchdog PFASE 1,2 and 3 Power usage
-- *********************************************************************
--

	if devicechanged["Time Trigger 1min"] == 'Off'
		and (otherdevices["Power_FailsaveL1"] == 'Off' or otherdevices["Power_FailsaveL2"] == 'Off'	or otherdevices["Power_FailsaveL3"] == 'Off')
		and (homewizard('L1') > 5000 or homewizard('L2') > 5000 or homewizard('L3') > 5000)
		and powerFailsave('false')
	then

--
-- *********************************************************************
-- Toggle PFASE 1 appliances OFF
-- *********************************************************************
--
	
		if homewizard('L1') > 5000 and otherdevices["Power_FailsaveL1"] == 'Off' then
			switchDevice("Power_FailsaveL1", "On")

			if sensorValue('Droger_Huidige_Verbruik') >= 100 then
				switchDevice("Droger_WCD", "Off")
			end

			if sensorValue('Garage_Heater_Huidige_Verbruik') >= 100 then
				switchDevice("Garage_Heater_WCD", "Off")
			end
			
			if sensorValue('Quooker_Huidige_Verbruik') >= 100 then
				switchDevice("Quooker_WCD", "Off")
			end

			if sensorValue('Voordeur_WCD_Huidige_Verbruik') >= 100 then
				switchDevice("Voordeur_WCD", "Off")
			end

			debugLog('Power: Stroomverbruik L1 te hoog')
		end

--
-- *********************************************************************
-- Toggle PFASE 2 appliances OFF
-- *********************************************************************
--
		
		if homewizard('L2') > 5000 and otherdevices["Power_FailsaveL2"] == 'Off' then
			switchDevice("Power_FailsaveL2", "On")
			
			if sensorValue('Wasmachine_Huidige_Verbruik') >= 100 then
				switchDevice("Wasmachine_WCD", "Off")
			end

			if sensorValue('Achterdeur_WCD_Huidige_Verbruik') >= 100 then
				switchDevice("Achterdeur_WCD", "Off")
			end
			
			if sensorValue('BV_Charger_Huidige_Verbruik') >= 100 then
				switchDevice("BV_Charger_WCD", "Off")
			end

			if sensorValue('Aanrecht_WCD1_Huidige_Verbruik') >= 100 then
				switchDevice("Aanrecht_WCD1", "Off")
			end

			if sensorValue('Aanrecht_WCD2_Huidige_Verbruik') >= 100 then
				switchDevice("Aanrecht_WCD2", "Off")
			end

			debugLog('Power: Stroomverbruik L2 te hoog')
		end

--
-- *********************************************************************
-- Toggle PFASE 3 appliances OFF
-- *********************************************************************
--

		if homewizard('L1') > 5000 and otherdevices["Power_FailsaveL3"] == 'Off' then
			switchDevice("Power_FailsaveL3", "On")

			if sensorValue('E-Boiler_Huidige_Verbruik') >= 100 then
				switchDevice("E-Boiler_WCD", "Off")
			end

			if sensorValue('Vaatwasser_Huidige_Verbruik') >= 100 then
				switchDevice("Vaatwasser_WCD", "Off")
			end

			debugLog('Power: Stroomverbruik L3 te hoog')
		end
	end

--
-- *********************************************************************
-- Watchdog PFASE 1,2 or 3 Power Failsave
-- *********************************************************************
--

	if devicechanged["Time Trigger 1min"] == 'Off'
		and (otherdevices["Power_FailsaveL1"] == 'On' or otherdevices["Power_FailsaveL2"] == 'On' or otherdevices["Power_FailsaveL3"] == 'On')
		and homewizard('L1') <= 1000
		and homewizard('L2') <= 1000
		and homewizard('L3') <= 1000
		and lastSeen("Power_FailsaveL1", ">=", 300)
		and lastSeen("Power_FailsaveL2", ">=", 300)
		and lastSeen("Power_FailsaveL3", ">=", 300)
		and powerFailsave('false')
	then

--
-- *********************************************************************
-- Toggle PFASE 1 appliances ON
-- *********************************************************************
--

		if homewizard('L1') <= 1000 and otherdevices["Power_FailsaveL1"] == 'On' then
			switchDevice("Power_FailsaveL1", "On")
			
			if sensorValue('Droger_Huidige_Verbruik') < 100 then
				switchDevice("Droger_WCD", "On")
			end

			if sensorValue('Garage_Heater_Huidige_Verbruik') < 100 then
				switchDevice("Garage_Heater_WCD", "On")
			end
			
			if sensorValue('Quooker_Huidige_Verbruik') < 100 then
				switchDevice("Quooker_WCD", "On")
			end

			if sensorValue('Voordeur_WCD_Huidige_Verbruik') < 100 then
				switchDevice("Voordeur_WCD", "On")
			end

			debugLog('Power: Stroomverbruik L1 gestabaliseerd')
		end

--
-- *********************************************************************
-- Toggle PFASE 2 appliances ON
-- *********************************************************************
--
		
		if homewizard('L2') <= 1000 and otherdevices["Power_FailsaveL2"] == 'On' then
			switchDevice("Power_FailsaveL2", "On")

			if sensorValue('Wasmachine_Huidige_Verbruik') < 100 then
				switchDevice("Wasmachine_WCD", "On")
			end

			if sensorValue('Achterdeur_WCD_Huidige_Verbruik') < 100 then
				switchDevice("Achterdeur_WCD", "On")
			end
			
			if sensorValue('BV_Charger_Huidige_Verbruik') < 100 then
				switchDevice("BV_Charger_WCD", "On")
			end

			if sensorValue('Aanrecht_WCD1_Huidige_Verbruik') < 100 then
				switchDevice("Aanrecht_WCD1", "On")
			end

			if sensorValue('Aanrecht_WCD2_Huidige_Verbruik') < 100 then
				switchDevice("Aanrecht_WCD2", "On")
			end

			debugLog('Power: Stroomverbruik L2 gestabaliseerd')
		end

--
-- *********************************************************************
-- Toggle PFASE 3 appliances ON
-- *********************************************************************
--

		if homewizard('L1') <= 1000 and otherdevices["Power_FailsaveL3"] == 'On' then
			switchDevice("Power_FailsaveL3", "On")
			
			if sensorValue('E-Boiler_Huidige_Verbruik') < 100 then
				switchDevice("E-Boiler_WCD", "On")
			end

			if sensorValue('Vaatwasser_Huidige_Verbruik') < 100 then
				switchDevice("Vaatwasser_WCD", "On")
			end

			debugLog('Power: Stroomverbruik L3 gestabaliseerd')
		end	

	end