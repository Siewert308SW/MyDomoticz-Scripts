--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 1min"}) then return end

--
-- *********************************************************************
-- Watchdog PFASE 1,2 and 3 Power usage
-- *********************************************************************
--

	if devicechanged["Time Trigger 1min"] == 'On'
		and (homewizard('L1') > 5000 or homewizard('L2') > 5000 or homewizard('L3') > 5000)
	then

--
-- *********************************************************************
-- Toggle PFASE 1 appliances OFF
-- *********************************************************************
--

    if homewizard('L1') > 5000
        and (otherdevices["Droger_WCD"] == 'On' 
          or otherdevices["Quooker_WCD"] == 'On' 
          or otherdevices["Garage_Heater_WCD"] == 'On' 
          or otherdevices["Voordeur_WCD"] == 'On')
    then
	
--[[ Power_Failsave L1 switch ON ]]--        
        if otherdevices["Power_FailsaveL1"] == 'Off' then
            switchDevice("Power_FailsaveL1", "On")
        end

        -- Bepaal verbruik per kandidaat
        local maxPower = 0
        local maxDevice = nil

        if otherdevices["Garage_Heater_WCD"] == 'On' then
            local p = sensorValue('Garage_Heater_Huidige_Verbruik')
            if p >= 100 and p > maxPower then
                maxPower = p
                maxDevice = "Garage_Heater_WCD"
            end
        end

        if otherdevices["Droger_WCD"] == 'On' then
            local p = sensorValue('Droger_Huidige_Verbruik')
            if p >= 100 and p > maxPower then
                maxPower = p
                maxDevice = "Droger_WCD"
            end
        end

        if otherdevices["Quooker_WCD"] == 'On' then
            local p = sensorValue('Quooker_Huidige_Verbruik')
            if p >= 100 and p > maxPower then
                maxPower = p
                maxDevice = "Quooker_WCD"
            end
        end

        if otherdevices["Voordeur_WCD"] == 'On' then
            local p = sensorValue('Voordeur_WCD_Huidige_Verbruik')
            if p >= 200 and p > maxPower then
                maxPower = p
                maxDevice = "Voordeur_WCD"
            end
        end

        -- Schakel alleen de grootste uit
        if maxDevice ~= nil then
            switchDevice(maxDevice, "Off")
            -- optioneel: debugLog('Power: L1 failsave, ' .. maxDevice .. ' uit (' .. maxPower .. 'W)')
        end
    end

--
-- *********************************************************************
-- Toggle PFASE 2 appliances OFF
-- *********************************************************************
--

		if homewizard('L2') > 5000
			and (otherdevices["Fietsenschuur_Heater_WCD"] == 'On' 
			  or otherdevices["Wasmachine_WCD"] == 'On' 
			  or otherdevices["Achterdeur_WCD"] == 'On' 
			  or otherdevices["BV_Charger_WCD"] == 'On' 
			  or otherdevices["Aanrecht_WCD1"] == 'On' 
			  or otherdevices["Aanrecht_WCD2"] == 'On')
		then
--[[ Power_Failsave L2 switch ON ]]--	
			if otherdevices["Power_FailsaveL2"] == 'Off' then
				switchDevice("Power_FailsaveL2", "On")
			end

			-- Bepaal grootste verbruiker op L2
			local maxPower = 0
			local maxDevice = nil

			-- Fietsenschuur heater
			if otherdevices["Fietsenschuur_Heater_WCD"] == 'On' then
				local p = sensorValue('Fietsenschuur_Heater_Huidige_Verbruik')
				if p >= 100 and p > maxPower then
					maxPower = p
					maxDevice = "Fietsenschuur_Heater_WCD"
				end
			end
			
			-- Wasmachine
			if otherdevices["Wasmachine_WCD"] == 'On' then
				local p = sensorValue('Wasmachine_Huidige_Verbruik')
				if p >= 100 and p > maxPower then
					maxPower = p
					maxDevice = "Wasmachine_WCD"
				end
			end

			-- Achterdeur WCD
			if otherdevices["Achterdeur_WCD"] == 'On' then
				local p = sensorValue('Achterdeur_WCD_Huidige_Verbruik')
				if p >= 200 and p > maxPower then
					maxPower = p
					maxDevice = "Achterdeur_WCD"
				end
			end
			
			-- BV Charger
			if otherdevices["BV_Charger_WCD"] == 'On' then
				local p = sensorValue('BV_Charger_Huidige_Verbruik')
				if p >= 200 and p > maxPower then
					maxPower = p
					maxDevice = "BV_Charger_WCD"
				end
			end

			-- Aanrecht WCD1 (hoge drempel, 1500W)
			if otherdevices["Aanrecht_WCD1"] == 'On' then
				local p = sensorValue('Aanrecht_WCD1_Huidige_Verbruik')
				if p >= 100 and p > maxPower then
					maxPower = p
					maxDevice = "Aanrecht_WCD1"
				end
			end

			-- Aanrecht WCD2 (hoge drempel, 1500W)
			if otherdevices["Aanrecht_WCD2"] == 'On' then
				local p = sensorValue('Aanrecht_WCD2_Huidige_Verbruik')
				if p >= 100 and p > maxPower then
					maxPower = p
					maxDevice = "Aanrecht_WCD2"
				end
			end

        -- Schakel alleen de grootste uit
        if maxDevice ~= nil then
            switchDevice(maxDevice, "Off")
            -- optioneel: debugLog('Power: L2 failsave, ' .. maxDevice .. ' uit (' .. maxPower .. 'W)')
        end
    end

--
-- *********************************************************************
-- Toggle PFASE 3 appliances OFF
-- *********************************************************************
--

		if homewizard('L3') > 5000 
			and (otherdevices["E-Boiler_WCD"] == 'On' or otherdevices["Vaatwasser_WCD"] == 'On')
		then

--[[ Power_Failsave L3 switch ON ]]--			
			if otherdevices["Power_FailsaveL3"] == 'Off' then
				switchDevice("Power_FailsaveL3", "On")
			end

			-- Bepaal grootste verbruiker op L3
			local maxPower = 0
			local maxDevice = nil

			-- Vaatwasser
			if otherdevices["Vaatwasser_WCD"] == 'On' then
				local p = sensorValue('Vaatwasser_Huidige_Verbruik')
				if p >= 100 and p > maxPower then
					maxPower = p
					maxDevice = "Vaatwasser_WCD"
				end
			end
			
			-- E-Boiler
			if otherdevices["E-Boiler_WCD"] == 'On' then
				local p = sensorValue('E-Boiler_Huidige_Verbruik')
				if p >= 100 and p > maxPower then
					maxPower = p
					maxDevice = "E-Boiler_WCD"
				end
			end

			-- Schakel alleen de grootste uit
			if maxDevice ~= nil then
				switchDevice(maxDevice, "Off")
				-- debugLog('Power: L3 failsave, ' .. maxDevice .. ' uit (' .. maxPower .. 'W)')
			end

		end
	end

--
-- *********************************************************************
-- Watchdog PFASE 1,2 or 3 Power Failsave
-- *********************************************************************
--

	if devicechanged["Time Trigger 1min"] == 'Off'
		and (otherdevices["Power_FailsaveL1"] == 'On' or otherdevices["Power_FailsaveL2"] == 'On' or otherdevices["Power_FailsaveL3"] == 'On')
	then

--
-- *********************************************************************
-- Toggle PFASE 1 appliances ON
-- *********************************************************************
--

		if homewizard('L1') <= 4000 
			and lastSeen("Power_FailsaveL1", ">=", 120) 
			and (otherdevices["Droger_WCD"] == 'Off' or otherdevices["Garage_Heater_WCD"] == 'Off' or otherdevices["Quooker_WCD"] == 'Off' or otherdevices["Voordeur_WCD"] == 'Off')
		then

--[[ Switch ON appliance ]]--				
			if otherdevices["Droger_WCD"] == 'Off' and homewizard('L1') <= 2500 then
				switchDevice("Droger_WCD", "On")

			elseif otherdevices["Quooker_WCD"] == 'Off' and homewizard('L1') <= 3500 then
				switchDevice("Quooker_WCD", "On")
				
			elseif otherdevices["Garage_Heater_WCD"] == 'Off' and homewizard('L1') <= 4000 then
				switchDevice("Garage_Heater_WCD", "On")
			
			elseif otherdevices["Voordeur_WCD"] == 'Off' and homewizard('L1') <= 4000 then
				switchDevice("Voordeur_WCD", "On")
				
			end
			
		end

--
-- *********************************************************************
-- Toggle PFASE 2 appliances ON
-- *********************************************************************
--
		
		if homewizard('L2') <= 4000
			and lastSeen("Power_FailsaveL2", ">=", 120)
			and (otherdevices["Wasmachine_WCD"] == 'Off' or otherdevices["Achterdeur_WCD"] == 'Off' or otherdevices["BV_Charger_WCD"] == 'Off' or otherdevices["Aanrecht_WCD1"] == 'Off' or otherdevices["Aanrecht_WCD2"] == 'Off')
		then

--[[ Switch ON appliance ]]--	
			if otherdevices["Aanrecht_WCD1"] == 'Off' and homewizard('L2') <= 4000 then
				switchDevice("Aanrecht_WCD1", "On")
				
			elseif otherdevices["Aanrecht_WCD2"] == 'Off' and homewizard('L2') <= 4000 then
				switchDevice("Aanrecht_WCD2", "On")
				
			elseif otherdevices["Wasmachine_WCD"] == 'Off' and homewizard('L2') <= 3000 then
				switchDevice("Wasmachine_WCD", "On")
				
			elseif otherdevices["Achterdeur_WCD"] == 'Off' and homewizard('L2') <= 4000 then
				switchDevice("Achterdeur_WCD", "On")
				
			elseif otherdevices["BV_Charger_WCD"] == 'Off' and homewizard('L2') <= 4000 then
				switchDevice("BV_Charger_WCD", "On")
				
			end

		end

--
-- *********************************************************************
-- Toggle PFASE 3 appliances ON
-- *********************************************************************
--

		if homewizard('L3') <= 4000
			and lastSeen("Power_FailsaveL3", ">=", 120)
			and (otherdevices["E-Boiler_WCD"] == 'Off' or otherdevices["Vaatwasser_WCD"] == 'Off')
		then

--[[ Switch ON appliance ]]--
			if otherdevices["Vaatwasser_WCD"] == 'Off' and homewizard('L3') <= 3000 then
				switchDevice("Vaatwasser_WCD", "On")

			elseif otherdevices["E-Boiler_WCD"] == 'Off' and homewizard('L3') <= 2500 then
				switchDevice("E-Boiler_WCD", "On")
				
			end

		end	

--[[ Power_Failsave L1 switch OFF ]]--	
			if otherdevices["Power_FailsaveL1"] == 'On' and otherdevices["Droger_WCD"] == 'On' and otherdevices["Garage_Heater_WCD"] == 'On' and otherdevices["Quooker_WCD"] == 'On' and otherdevices["Voordeur_WCD"] == 'On'
			then
				switchDevice("Power_FailsaveL1", "Off")
			end
			
--[[ Power_Failsave L2 switch OFF ]]--
			if otherdevices["Power_FailsaveL2"] == 'On' and otherdevices["Wasmachine_WCD"] == 'On' and otherdevices["Achterdeur_WCD"] == 'On' and otherdevices["Aanrecht_WCD1"] == 'On' and otherdevices["Aanrecht_WCD2"] == 'On' then
				switchDevice("Power_FailsaveL2", "Off")
			end
			
--[[ Power_Failsave L3 switch OFF ]]--			
			if otherdevices["Power_FailsaveL3"] == 'On' and otherdevices["E-Boiler_WCD"] == 'On' and otherdevices["Vaatwasser_WCD"] == 'On' then
				switchDevice("Power_FailsaveL3", "Off")
			end
			
	end