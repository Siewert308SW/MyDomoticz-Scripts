--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--

	if not isMyTrigger({"Time Trigger 30min", "Dummy"}) then return end
		if (devicechanged["Time Trigger 30min"] == "Off" or devicechanged["Dummy"] == "Off") then
--
-- *********************************************************************
-- Bedroom2 Airco Mode Decision Based on Matching Historical Conditions
-- *********************************************************************
--

-- Seasons
	local nowMonth = tonumber(os.date("%m"))
	local season =
		nowMonth >= 3 and nowMonth <= 4 and "spring" or
		nowMonth >= 5 and nowMonth <= 8 and "summer" or
		nowMonth >= 9 and nowMonth <= 11 and "autumn" or
		"winter"

-- Path to logfile
	local logFile = "/home/siewert/domoticz/scripts/lua/logs/climate/bedroom2_history_" .. season .. ".csv"
	local f = io.open(logFile, "r")
	if not f then debugLogClima("Kan logbestand niet openen."); return end

-- Sensors
	local insideBedroom1Temp = sensorValue("Natalya_Deur_Master_Temp")
	local insideBedroom2Temp = sensorValue("Natalya_WCD_Temp")
	local outsideFrontTemp 	 = sensorValue("Voortuin_Temp")
	local outsideBackTemp 	 = sensorValue("Achtertuin_Temp")

	local insideHumidity 	 = humidity("living")
	local frontdoorLux 		 = sensorValue("Voordeur_LUX")
	local backdoorLux 		 = sensorValue("Achterdeur_LUX")
	local aircoState 		 = otherdevices["Natalya_Airco_Power"] or "Off"
	local aircoMode 		 = otherdevices["Natalya_Airco_Mode"] or "Off"	
	local aircoSetpoint 	 = tonumber(otherdevices["Natalya_Airco_Setpoint"]) or 20

-- Average Inside temperature
	local avgInsideTemp     = roundToHalf(((tonumber(insideBedroom2Temp) or 20) + (tonumber(insideBedroom2Temp) or 20) + (tonumber(insideKitchenTemp) or 20)) / 3)

-- Average outside temperature
	local avgOutsideTemp 	= roundToHalf(((tonumber(outsideFrontTemp) or 18) + (tonumber(outsideBackTemp) or 18)) / 2)
	
-- Average outside lux
	local avgLux 			= roundToHalf(((tonumber(frontdoorLux) or 0) + (tonumber(backdoorLux) or 0)) / 2)

-- Current climate
	local insideTemp 		= avgInsideTemp
	local outsideTemp 		= avgOutsideTemp
	local insideHum 		= insideHumidity
	local setpointBedroom2 	= aircoSetpoint
	local seasonNow 		= season

-- Tolerances
	local tTol, oTol, spTol

	if seasonNow == "summer" then
		tTol 				= 2.0   -- Inside Temperature
		oTol 				= 5.0   -- Outside Temperature
		spTol 				= 1.0   -- Setpoint
	elseif seasonNow == "winter" then
		tTol 				= 2.0   -- Inside Temperature
		oTol 				= 15.0  -- Outside Temperature
		spTol 				= 1.0   -- Setpoint
	else
		tTol 				= 2.0   -- Inside Temperature
		oTol 				= 5.0   -- Outside Temperature
		spTol 				= 1.0   -- Setpoint
	end

-- Votes + setpoint tracking
	local votes = {Heat = 0, Cool = 0, Off = 0}
	local spHeatSum, spCoolSum = 0, 0
	local spHeatCount, spCoolCount = 0, 0
	local matches = 0

-- Create Decision
	for line in f:lines() do
		local ts, inT, outT, hum, lux, sp, state, mode, season = line:match("([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")
		inT, outT, lux, sp = tonumber(inT), tonumber(outT), tonumber(lux), tonumber(sp)

		if inT and outT and lux and sp and season == seasonNow then
			local luxConditionMatch =
				(avgLux <= 1 and lux <= 1) or
				(avgLux > 1 and lux > 1)

			if luxConditionMatch then
				local inMatch = math.abs(inT - insideTemp) <= tTol
				local outMatch = math.abs(outT - outsideTemp) <= oTol
				local spMatch = math.abs(sp - tonumber(setpointBedroom2)) <= spTol

				if inMatch and outMatch and spMatch then
					mode = mode:lower()
					if mode == "heat" then
						votes.Heat = votes.Heat + 1
						spHeatSum = spHeatSum + sp
						spHeatCount = spHeatCount + 1
					elseif mode == "cool" then
						votes.Cool = votes.Cool + 1
						spCoolSum = spCoolSum + sp
						spCoolCount = spCoolCount + 1
					elseif mode == "none" or mode == "off" then
						votes.Off = votes.Off + 1
					end
					matches = matches + 1
				end
			end
		end
	end
	f:close()

-- Decision
	local decision = "Off"
	local setpointLearned = nil

-- Season lock
	if seasonNow == "winter" then
		votes.Cool = 0
	elseif seasonNow == "summer" then
		votes.Heat = 0
	end

	local bestVotes = math.max(votes.Heat, votes.Cool, votes.Off)
	if bestVotes > 0 then
		if votes.Heat == bestVotes then
			decision = "Heat"
			if spHeatCount > 0 then setpointLearned = spHeatSum / spHeatCount end
		elseif votes.Cool == bestVotes then
			decision = "Cool"
			if spCoolCount > 0 then setpointLearned = spCoolSum / spCoolCount end
		else
			decision = "Off"
		end
	end

-- Extra fallback
	if matches == 0 then
		decision = aircoMode
	end

-- Write Variables
	switchDevice("Variable:natalya_airco_decision", ""..decision.."")
	if setpointLearned then
	local roundedSetpoint = roundToHalf(setpointLearned)
	switchDevice("Variable:natalya_airco_dec_setpoint", string.format("%0.1f", roundedSetpoint))
	end

-- Write to LogFile
	local decisionLogPath = "/home/siewert/domoticz/scripts/lua/logs/climate/bedroom2_dec_" .. season .. ".csv"
	local now = os.date("%Y-%m-%d %H:%M:%S")
	local logLine = string.format("%s,%s,%d,%d,%d,%d\n", now, decision, matches, votes.Heat, votes.Cool, votes.Off)
	appendToFile(decisionLogPath, logLine)


--
-- *********************************************************************
-- Bedroom2 Airco Mode Based on Matching Historical Conditions
-- *********************************************************************
--	

	IsSceneBedroom2 = false
	sceneBedroom2   = 'none'
	local setpointBedroom2 = tonumber(uservariables["natalya_airco_dec_setpoint"]) or 22.0
	
		if uservariables["Natalya_Airco_auto"] == 1
			and uservariables["natalya_airco_decision"] == "Cool"
			and (otherdevices["Natalya_Airco_Power"] == 'Off' or otherdevices["Natalya_Airco_Mode"] ~= 'Cool')
			--and otherdevices["Slaapkamer_Airco_Mode"] == 'Cool'
			and lastSeen('Natalya_Airco_Power', '>=', '1800')
			and powerFailsave('false')
		then
			IsSceneBedroom2 = true
			sceneBedroom2 = 'cooling'

		elseif uservariables["Natalya_Airco_auto"] == 1
			and uservariables["natalya_airco_decision"] == "Heat"			
			and (otherdevices["Natalya_Airco_Power"] == 'Off' or otherdevices["Natalya_Airco_Mode"] ~= 'Heat')
			--and otherdevices["Slaapkamer_Airco_Mode"] == 'Heat'				
			and lastSeen('Natalya_Airco_Power', '>=', '1800')
			and powerFailsave('false')
		then
			IsSceneBedroom2 = true
			sceneBedroom2 = 'heating'
				
		elseif uservariables["Natalya_Airco_auto"] == 1
			and uservariables["natalya_airco_decision"] == "Off"
			and otherdevices["Natalya_Airco_Power"] ~= 'Off'
			and lastSeen('Natalya_Airco_Power', '>=', '1800')
			and powerFailsave('false')
		then
			IsSceneBedroom2 = true
			sceneBedroom2 = 'off'
				
		end

--
-- *********************************************************************
-- Check if Slave Airco_Mode equals Master Airco_Mode
-- *********************************************************************
--
	IsSyncBedroom2 = false
	local aircoMasterState = otherdevices["Slaapkamer_Airco_Mode"] or "None"
	local aircoSlaveState = otherdevices["Natalya_Airco_Mode"] or "None"
	
	if IsSceneBedroom2 == true
		and uservariables["Natalya_Airco_auto"] == 1
		and aircoSlaveState ~= aircoMasterState
		and powerFailsave('false')
	then
		if sceneBedroom2 == 'cooling' and otherdevices["Slaapkamer_Airco_Mode"] ~= 'Cool' then
			--switchDevice("Natalya_Airco_Mode", "Set Level 10")
		elseif sceneBedroom2 == 'heating' and otherdevices["Slaapkamer_Airco_Mode"] ~= 'Heat' then
			--switchDevice("Slaapkamer_Airco_Mode", "Set Level 20")
		end
		IsSyncBedroom2 = true
		debugLogClima('Master sync controle uitgevoerd:# slave = ' .. aircoSlaveState .. ', master = ' .. aircoMasterState)

	end
		
--
-- **********************************************************
-- Scene acties
-- **********************************************************
--

	if IsSceneBedroom2 == true and IsSyncBedroom2 == true and sceneBedroom2 == 'cooling' then
		--[[
			switchDevice("SetSetPoint:4103", setpointBedroom2)
			switchDevice("Natalya_Airco_Mode", "Set Level 10")
			switchDevice("Natalya_Airco_Fan_Mode", "Set Level 0")
			switchDevice("Natalya_Airco_Swing_Mode(Up/Down)", "Set Level 20")
			switchDevice("Natalya_Airco_Swing_Mode(Left/Right)", "Set Level 20")
		--]]
			debugLogClima(string.format(
				"Bedroom2 Airco ON (Cooling Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Off=%d → decision: %s",
				matches, votes.Heat, votes.Cool, votes.Off, decision
			))
			
	elseif IsSceneBedroom2 == true and IsSyncBedroom2 == true and sceneBedroom2 == 'heating' then
	    --[[
			switchDevice("SetSetPoint:4103", setpointBedroom2)
			switchDevice("Natalya_Airco_Mode", "Set Level 20")
			switchDevice("Natalya_Airco_Fan_Mode", "Set Level 10")
			switchDevice("Natalya_Airco_Swing_Mode(Up/Down)", "Set Level 20")
			switchDevice("Natalya_Airco_Swing_Mode(Left/Right)", "Set Level 20")
		--]]
			debugLogClima(string.format(
				"Bedroom2 Airco ON (Heating Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Off=%d → decision: %s",
				matches, votes.Heat, votes.Cool, votes.Off, decision
			))

	elseif IsSceneBedroom2 == true and sceneBedroom2 == 'off' then
		--[[
		switchDevice("Natalya_Airco_Power", "Off")
		--]]
			debugLogClima(string.format(
				"Bedroom2 Airco ON (Comfort Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Off=%d → decision: %s",
				matches, votes.Heat, votes.Cool, votes.Off, decision
			))
	end
end
