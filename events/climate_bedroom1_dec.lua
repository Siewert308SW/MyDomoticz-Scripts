--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--

	if not isMyTrigger({"Time Trigger 30min", "Dummy"}) then return end
		if (devicechanged["Time Trigger 30min"] == "Off" or devicechanged["Dummy"] == "Off") then
--
-- *********************************************************************
-- Bedroom1 Airco Mode Decision Based on Matching Historical Conditions
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
	local logFile = "/home/siewert/domoticz/scripts/lua/logs/climate/bedroom1_history_" .. season .. ".csv"
	local f = io.open(logFile, "r")
	if not f then debugLogClima("Kan logbestand niet openen."); return end

-- Sensors
	local insideBedroomTemp = sensorValue("Slaapkamer_Deur_Master_Temp")
	local outsideFrontTemp 	= sensorValue("Voortuin_Temp")
	local outsideBackTemp 	= sensorValue("Achtertuin_Temp")

	local insideHumidity 	= humidity("living")
	local frontdoorLux 		= sensorValue("Voordeur_LUX")
	local backdoorLux 		= sensorValue("Achterdeur_LUX")
	local aircoState 		= otherdevices["Slaapkamer_Airco_Power"] or "Off"
	local aircoMode 		= otherdevices["Slaapkamer_Airco_Mode"] or "Off"
	local aircoSetpoint 	= tonumber(otherdevices["Slaapkamer_Airco_Setpoint"]) or 20

-- Average Inside temperature
	local avgInsideTemp     = roundToHalf(((tonumber(insideBedroomTemp) or 20) or 20))

-- Average outside temperature
	local avgOutsideTemp 	= roundToHalf(((tonumber(outsideFrontTemp) or 18) + (tonumber(outsideBackTemp) or 18)) / 2)
	
-- Average outside lux
	local avgLux 			= roundToHalf(((tonumber(frontdoorLux) or 0) + (tonumber(backdoorLux) or 0)) / 2)

-- Current climate
	local insideTemp 		= avgInsideTemp
	local outsideTemp 		= avgOutsideTemp
	local insideHum 		= insideHumidity
	local setpointBedroom1 	= aircoSetpoint
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
				local spMatch = math.abs(sp - tonumber(setpointBedroom1)) <= spTol

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
	switchDevice("Variable:slaapkamer_airco_decision", ""..decision.."")
	if setpointLearned then
	local roundedSetpoint = roundToHalf(setpointLearned)
	switchDevice("Variable:slaapkamer_airco_dec_setpoint", string.format("%0.1f", roundedSetpoint))
	end

-- Write to LogFile
	local decisionLogPath = "/home/siewert/domoticz/scripts/lua/logs/climate/bedroom1_dec_" .. season .. ".csv"
	local now = os.date("%Y-%m-%d %H:%M:%S")
	local logLine = string.format("%s,%s,%d,%d,%d,%d\n", now, decision, matches, votes.Heat, votes.Cool, votes.Off)
	appendToFile(decisionLogPath, logLine)

--
-- *********************************************************************
-- Bedroom1 Airco Mode Based on Matching Historical Conditions
-- *********************************************************************
--	

	IsSceneBedroom1 = false
	sceneBedroom1   = 'none'
	local setpointBedroom1 = tonumber(uservariables["slaapkamer_airco_dec_setpoint"]) or 22.0
		
		if uservariables["Slaapkamer_Airco_auto"] == 1
			and uservariables["slaapkamer_airco_decision"] == "Cool"
			and (otherdevices["Slaapkamer_Airco_Power"] == 'Off' or otherdevices["Slaapkamer_Airco_Mode"] ~= 'Cool')
			and otherdevices["Natalya_Airco_Mode"] == 'Cool'
			and lastSeen('Slaapkamer_Airco_Power', '>=', '1800')
			and powerFailsave('false')
		then
			IsSceneBedroom1 = true
			sceneBedroom1 = 'cooling'

		elseif uservariables["Slaapkamer_Airco_auto"] == 1
			and uservariables["slaapkamer_airco_decision"] == "Heat"			
			and (otherdevices["Slaapkamer_Airco_Power"] == 'Off' or otherdevices["Slaapkamer_Airco_Mode"] ~= 'Heat')
			and otherdevices["Natalya_Airco_Mode"] == 'Heat'				
			and lastSeen('Slaapkamer_Airco_Power', '>=', '1800')
			and powerFailsave('false')
		then
			IsSceneBedroom1 = true
			sceneBedroom1 = 'heating'
				
		elseif uservariables["Slaapkamer_Airco_auto"] == 1
			and uservariables["slaapkamer_airco_decision"] == "Off"
			and otherdevices["Slaapkamer_Airco_Power"] ~= 'Off'
			and lastSeen('Slaapkamer_Airco_Power', '>=', '1800')
			and powerFailsave('false')
		then
			IsSceneBedroom1 = true
			sceneBedroom1 = 'off'
				
		end

--
-- *********************************************************************
-- Check if Slave Airco_Mode equals Master Airco_Mode
-- *********************************************************************
--
	IsSyncLiving = false
	local aircoMasterState = otherdevices["Slaapkamer_Airco_Mode"] or "None"
	local aircoSlaveState = otherdevices["Natalya_Airco_Mode"] or "None"
	
	if IsSceneBedroom1 == true
		and uservariables["Slaapkamer_Airco_auto"] == 1
		and aircoSlaveState ~= aircoMasterState
		and powerFailsave('false')
	then
		if sceneBedroom1 == 'cooling' and otherdevices["Natalya_Airco_Mode"] ~= 'Cool' then
			--switchDevice("Natalya_Airco_Mode", "Set Level 10")
		elseif sceneBedroom1 == 'heating' and otherdevices["Natalya_Airco_Mode"] ~= 'Heat' then
			--switchDevice("Slaapkamer_Airco_Mode", "Set Level 20")
		end
		IsSyncLiving = true
		debugLogClima('Master sync controle uitgevoerd:# slave = ' .. aircoSlaveState .. ', master = ' .. aircoMasterState)

	end
		
--
-- **********************************************************
-- Scenes
-- **********************************************************
--

	if IsSceneBedroom1 == true and IsSyncLiving == true and sceneBedroom1 == 'cooling' then
		--[[
			switchDevice("SetSetPoint:4947", setpointBedroom1)
			switchDevice("Slaapkamer_Airco_Mode", "Set Level 10")
			switchDevice("Slaapkamer_Airco_Fan_Mode", "Set Level 0")
			switchDevice("Slaapkamer_Airco_Swing_Mode(Up/Down)", "Set Level 20")
			switchDevice("Slaapkamer_Airco_Swing_Mode(Left/Right)", "Set Level 20")
		--]]
			debugLogClima(string.format(
				"Bedroom1 Airco ON (Cooling Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Off=%d → decision: %s",
				matches, votes.Heat, votes.Cool, votes.Off, decision
			))
			
	elseif IsSceneBedroom1 == true and IsSyncLiving == true and sceneBedroom1 == 'heating' then
	    --[[
			switchDevice("SetSetPoint:4947", setpointBedroom1)
			switchDevice("Slaapkamer_Airco_Mode", "Set Level 20")
			switchDevice("Slaapkamer_Airco_Fan_Mode", "Set Level 10")
			switchDevice("Slaapkamer_Airco_Swing_Mode(Up/Down)", "Set Level 20")
			switchDevice("Slaapkamer_Airco_Swing_Mode(Left/Right)", "Set Level 20")
		--]]
			debugLogClima(string.format(
				"Bedroom1 Airco ON (Heating Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Off=%d → decision: %s",
				matches, votes.Heat, votes.Cool, votes.Off, decision
			))

	elseif IsSceneBedroom1 == true and sceneBedroom1 == 'off' then
		--[[
		switchDevice("Slaapkamer_Airco_Power", "Off")
		--]]
			debugLogClima(string.format(
				"Bedroom1 Airco OFF (Comfort Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Off=%d → decision: %s",
				matches, votes.Heat, votes.Cool, votes.Off, decision
			))
	end
	
end
