--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--

	if not isMyTrigger({"Time Trigger 30min", "Dummy"}) then return end
		if (devicechanged["Time Trigger 30min"] == "Off" or devicechanged["Dummy"] == "Off") then
--
-- *********************************************************************
-- Living Airco Mode Decision Based on Matching Historical Conditions
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
	local logFile = "/opt/domoticz/userdata/scripts/lua/logs/climate/living_history_" .. season .. ".csv"
	local f = io.open(logFile, "r")
	if not f then debugLogClima("Kan logbestand niet openen."); return end

-- Devices/Switches
	local presence       	= otherdevices["Personen"] or "Aanwezig"
	
-- Sensors
	local insideLiving1Temp = sensorValue("Woonkamer_Hum_Temp")
	local insideKitchenTemp	= sensorValue("Keuken_Motion_Temp")
	local insideLiving2Temp	= sensorValue("Woonkamer_Motion_Temp")
	local outsideFrontTemp 	= sensorValue("Voortuin_Temp")
	local outsideBackTemp 	= sensorValue("Achtertuin_Temp")

	local insideHumidity 	= humidity("living")
	local frontdoorLux 		= sensorValue("Voordeur_LUX")
	local backdoorLux 		= sensorValue("Achterdeur_LUX")
	local aircoState 		= otherdevices["Woonkamer_Airco_Power"] or "Off"
	local aircoMode 		= otherdevices["Woonkamer_Airco_Mode"] or "None"
	local aircoSetpoint 	= tonumber(otherdevices["Woonkamer_Airco_Setpoint"]) or 20

-- Average Inside temperature
	local avgInsideTemp     = roundToHalf(((tonumber(insideLiving1Temp) or 20) + (tonumber(insideLiving2Temp) or 20) + (tonumber(insideKitchenTemp) or 20)) / 3)

-- Average outside temperature
	local avgOutsideTemp 	= roundToHalf(((tonumber(outsideFrontTemp) or 18) + (tonumber(outsideBackTemp) or 18)) / 2)
	
-- Average outside lux
	local avgLux 			= roundToHalf(((tonumber(frontdoorLux) or 0) + (tonumber(backdoorLux) or 0)) / 2)

-- Current climate
	local insideTemp 		= avgInsideTemp
	local outsideTemp 		= avgOutsideTemp
	local insideHum 		= insideHumidity
	local setpoint 			= aircoSetpoint
	local seasonNow 		= season
	
-- Tolerances
	local tTol, oTol, spTol

	if seasonNow == "summer" then
		tTol 				= 0.5   -- Inside Temperature
		oTol 				= 4.0   -- Outside Temperature
		spTol 				= 0.5   -- Setpoint
	elseif seasonNow == "winter" then
		tTol 				= 0.5   -- Inside Temperature
		oTol 				= 2.0  -- Outside Temperature
		spTol 				= 0.5   -- Setpoint
	else
		tTol 				= 0.5   -- Inside Temperature
		oTol 				= 2.0   -- Outside Temperature
		spTol 				= 0.5   -- Setpoint
	end

-- Votes + setpoint tracking
	local votes = {Heat = 0, Cool = 0, Off = 0}
	local spHeatSum, spCoolSum = 0, 0
	local spHeatCount, spCoolCount = 0, 0
	local matches = 0

-- Create Decision
	for line in f:lines() do
		local ts, inT, outT, hum, lux, sp, state, mode, season, presenceLog = line:match("([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")
		inT, outT, lux, sp = tonumber(inT), tonumber(outT), tonumber(lux), tonumber(sp)

		if inT and outT and lux and sp and season == seasonNow and presenceLog == presence then
			--local luxConditionMatch =
			--	(avgLux <= 1 and lux <= 1) or
			--	(avgLux > 1 and lux > 1)

			--if luxConditionMatch then
				local inMatch = math.abs(inT - insideTemp) <= tTol
				local outMatch = math.abs(outT - outsideTemp) <= oTol
				local spMatch = math.abs(sp - tonumber(setpoint)) <= spTol

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
			--end
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
	switchDevice("Variable:woonkamer_airco_decision", ""..decision.."")
	if setpointLearned then
	local roundedSetpoint = roundToHalf(setpointLearned)
	switchDevice("Variable:woonkamer_airco_dec_setpoint", string.format("%0.1f", roundedSetpoint))
	end

-- Write to LogFile
	local decisionLogPath = "/opt/domoticz/userdata/scripts/lua/logs/climate/living_dec_" .. season .. ".csv"
	local now = os.date("%Y-%m-%d %H:%M:%S")
	local logLine = string.format("%s,%s,%d,%d,%d,%d\n", now, decision, matches, votes.Heat, votes.Cool, votes.Off)
	appendToFile(decisionLogPath, logLine)


--
-- *********************************************************************
-- Living Airco Mode Based on Matching Historical Conditions
-- *********************************************************************
--	
		IsSceneLiving = false
		sceneLiving   = 'none'
		
			if uservariables["Woonkamer_Airco_auto"] == 1
				and uservariables["woonkamer_airco_decision"] == "Cool"
				and (otherdevices["Woonkamer_Airco_Power"] == 'Off' or otherdevices["Woonkamer_Airco_Mode"] ~= 'Cool')
				and lastSeen('Woonkamer_Airco_Power', '>=', '1800')
				and powerFailsave('false')
			then
				IsSceneLiving = true
				sceneLiving = 'cooling'

			elseif uservariables["Woonkamer_Airco_auto"] == 1
				and uservariables["woonkamer_airco_decision"] == "Heat"
				and (otherdevices["Woonkamer_Airco_Power"] == 'Off' or otherdevices["Woonkamer_Airco_Mode"] ~= 'Heat')
				and lastSeen('Woonkamer_Airco_Power', '>=', '1800')
				and powerFailsave('false')
			then
				IsSceneLiving = true
				sceneLiving = 'heating'
				
			elseif uservariables["Woonkamer_Airco_auto"] == 1
				and uservariables["woonkamer_airco_decision"] == "Off"
				and otherdevices["Woonkamer_Airco_Power"] ~= 'Off'
				and lastSeen('Woonkamer_Airco_Power', '>=', '1800')
				and powerFailsave('false')
			then
				IsSceneLiving = true
				sceneLiving = 'off'
				
			end

--
-- **********************************************************
-- Scenes
-- **********************************************************
--

		if IsSceneLiving == true and sceneLiving == 'cooling' then
			--[[
			switchDevice("SetSetPoint:4055", setpoint)
			switchDevice("Woonkamer_Airco_Mode", "Set Level 10")
			switchDevice("Woonkamer_Airco_Fan_Mode", "Set Level 0")
			switchDevice("Woonkamer_Airco_Swing_Mode(Up/Down)", "Set Level 10")
			switchDevice("Woonkamer_Airco_Swing_Mode(Left/Right)", "Set Level 50")
			--]]
			debugLogClima(string.format(
				"Living Airco ON (Cooling Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Off=%d → decision: %s",
				matches, votes.Heat, votes.Cool, votes.Off, decision
			))
			
		elseif IsSceneLiving == true and sceneLiving == 'heating' then
		    --[[
			switchDevice("SetSetPoint:4055", setpoint)
			switchDevice("Woonkamer_Airco_Mode", "Set Level 20")
			switchDevice("Woonkamer_Airco_Fan_Mode", "Set Level 10")
			switchDevice("Woonkamer_Airco_Swing_Mode(Up/Down)", "Set Level 10")
			switchDevice("Woonkamer_Airco_Swing_Mode(Left/Right)", "Set Level 0")
			--]]
			debugLogClima(string.format(
				"Living Airco ON (Heating Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Off=%d → decision: %s",
				matches, votes.Heat, votes.Cool, votes.Off, decision
			))

		elseif IsSceneLiving == true and sceneLiving == 'off' then
			--[[
			switchDevice("Woonkamer_Airco_Power", "Off")
			--]]
			debugLogClima(string.format(
				"Living Airco OFF (Comfort Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Off=%d → decision: %s",
				matches, votes.Heat, votes.Cool, votes.Off, decision
			))
		end

end
