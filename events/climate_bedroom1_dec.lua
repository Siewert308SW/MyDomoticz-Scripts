--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--

if not isMyTrigger({"Time Trigger 30min", "Dummy"}) then return end
    if devicechanged["Time Trigger 30min"] == "Off" then

--
-- *********************************************************************
-- Bedroom 1 Airco Mode Decision Based on Matching Historical Conditions
-- *********************************************************************
--

-- Seasons
    local nowMonth = tonumber(os.date("%m"))
    local season =
        nowMonth >= 3 and nowMonth <= 5 and "spring" or
        nowMonth >= 6 and nowMonth <= 8 and "summer" or
        nowMonth >= 9 and nowMonth <= 10 and "autumn" or
        "winter"

-- Path to logfile
    local logFile = "/opt/domoticz/userdata/scripts/lua/logs/climate/bedroom1_history_" .. season .. ".csv"
    local f = io.open(logFile, "r")
    if not f then
        debugLogClima("Bedroom1 Decision: kan logbestand niet openen: " .. logFile)
        return
    end

-- Devices/Switches
    local presence = otherdevices["Personen"] or "Aanwezig"
    if presence == "Standby" or presence == "Start" or presence == "Stop" then
        presence = "Aanwezig"
    end

-- Sensors
	local inside1Temp		= sensorValue("Slaapkamer_Deur_Master_Temp")
	local inside2Temp		= sensorValue("Master Airco Temp")
	local outsideFrontTemp 	= sensorValue("Voortuin_Temp")
	local outsideBackTemp  	= sensorValue("Achtertuin_Temp")
	
	local aircoState       	= otherdevices["Master Airco Power"] or "Off"
	local aircoSetpoint    	= tonumber(otherdevices["Master Airco Setpoint"]) or 18
	local aircoMode        	= otherdevices["Master Airco Mode"] or "Off"

-- Average Inside temperature
    local avgInsideTemp 	= roundToHalf(((tonumber(inside1Temp) or 20)
                                    + (tonumber(inside2Temp) or 20)) / 2)

-- Average outside temperature
    local avgOutsideTemp 	= roundToHalf(((tonumber(outsideFrontTemp) or 18)
                                      + (tonumber(outsideBackTemp) or 18)) / 2)

-- Current climate
    local insideTemp 		= avgInsideTemp
    local outsideTemp 		= avgOutsideTemp
    local setpoint 			= aircoSetpoint
    local seasonNow 		= season

-- Tolerances
    local tTol  = 2.0   -- Inside Temperature
    local oTol  = 5.0   -- Outside Temperature
    local spTol = 0.5   -- Setpoint

-- Votes + setpoint tracking (alle modes)
    local votes = {Heat = 0, Cool = 0, Dry = 0, Fan = 0, Auto = 0, Off = 0}

    local spHeatSum, spCoolSum, spDrySum, spFanSum, spAutoSum =
        0, 0, 0, 0, 0
    local spHeatCount, spCoolCount, spDryCount, spFanCount, spAutoCount =
        0, 0, 0, 0, 0

    local matches = 0

-- Create Decision
    for line in f:lines() do
        local ts, inT, outT, sp, stateLog, modeLog, seasonLog, presenceLog =
            line:match("([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")

        inT = tonumber(inT)
        outT = tonumber(outT)
        sp = tonumber(sp)

        if inT and outT and sp
            and seasonLog == seasonNow
            and presenceLog == presence
        then
            local inMatch  = math.abs(inT - insideTemp)   <= tTol
            local outMatch = math.abs(outT - outsideTemp) <= oTol
            local spMatch  = math.abs(sp - setpoint)      <= spTol

            if inMatch and outMatch and spMatch then
                local mode = (modeLog or ""):lower()

                if mode == "heat" then
                    votes.Heat = votes.Heat + 1
                    spHeatSum = spHeatSum + sp
                    spHeatCount = spHeatCount + 1

                elseif mode == "cool" then
                    votes.Cool = votes.Cool + 1
                    spCoolSum = spCoolSum + sp
                    spCoolCount = spCoolCount + 1

                elseif mode == "dry" then
                    votes.Dry = votes.Dry + 1
                    spDrySum = spDrySum + sp
                    spDryCount = spDryCount + 1

                elseif mode == "fan only" or mode == "fan" then
                    votes.Fan = votes.Fan + 1
                    spFanSum = spFanSum + sp
                    spFanCount = spFanCount + 1

                elseif mode == "auto" then
                    votes.Auto = votes.Auto + 1
                    spAutoSum = spAutoSum + sp
                    spAutoCount = spAutoCount + 1

                elseif mode == "none" or mode == "off" then
                    votes.Off = votes.Off + 1

                else
                    -- Onbekende mode telt als Off
                    votes.Off = votes.Off + 1
                end

                matches = matches + 1
            end
        end
    end
    f:close()

-- Decision
    local decision = "Off"
    local setpointLearned = nil

    local bestVotes = math.max(
        votes.Heat, votes.Cool, votes.Dry,
        votes.Fan,  votes.Auto, votes.Off
    )

    if bestVotes > 0 then
        if votes.Heat == bestVotes then
            decision = "Heat"
            if spHeatCount > 0 then setpointLearned = spHeatSum / spHeatCount end

        elseif votes.Cool == bestVotes then
            decision = "Cool"
            if spCoolCount > 0 then setpointLearned = spCoolSum / spCoolCount end

        elseif votes.Dry == bestVotes then
            decision = "Dry"
            if spDryCount > 0 then setpointLearned = spDrySum / spDryCount end

        elseif votes.Fan == bestVotes then
            decision = "Fan Only"
            if spFanCount > 0 then setpointLearned = spFanSum / spFanCount end

        elseif votes.Auto == bestVotes then
            decision = "Auto"
            if spAutoCount > 0 then setpointLearned = spAutoSum / spAutoCount end

        else
            decision = "Off"
        end
    end

-- Extra fallback: geen matches → huidige mode vasthouden
    if matches == 0 then
        decision = aircoMode
    end

-- Write Variables
    switchDevice("Variable:slaapkamer_airco_decision", "" .. decision .. "")
    if setpointLearned then
        local roundedSetpoint = roundToHalf(setpointLearned)
        switchDevice("Variable:slaapkamer_airco_dec_setpoint", string.format("%0.1f", roundedSetpoint))
    end

-- Write to LogFile
    local decisionLogPath = "/opt/domoticz/userdata/scripts/lua/logs/climate/bedroom1_dec_" .. season .. ".csv"
    local now = os.date("%Y-%m-%d %H:%M:%S")
    local logLine = string.format(
        "%s,%s,%d,%d,%d,%d,%d,%d\n",
        now, decision, matches,
        votes.Heat, votes.Cool, votes.Dry,
        votes.Fan, votes.Off
    )
    appendToFile(decisionLogPath, logLine)
--[[
--
-- *********************************************************************
-- Living Airco Mode Based on Matching Historical Conditions
-- *********************************************************************
--
    IsSceneLiving = false
    sceneLiving   = 'none'

    if uservariables["Woonkamer_Airco_auto"] == 1
        and uservariables["woonkamer_airco_decision"] == "Cool"
        and (otherdevices["Woonkamer_Airco_Power"] == 'Off'
             or otherdevices["Woonkamer_Airco_Mode"] ~= 'Cool')
        and lastSeen('Woonkamer_Airco_Power', '>=', '1800')
        and powerFailsave('false')
    then
        IsSceneLiving = true
        sceneLiving = 'cooling'

    elseif uservariables["Woonkamer_Airco_auto"] == 1
        and uservariables["woonkamer_airco_decision"] == "Heat"
        and (otherdevices["Woonkamer_Airco_Power"] == 'Off'
             or otherdevices["Woonkamer_Airco_Mode"] ~= 'Heat')
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
        -- hier setpoint / modes zetten
        debugLogClima(string.format(
            "Living Airco ON (Cooling Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Dry=%d, Fan=%d, Off=%d → decision: %s",
            matches, votes.Heat, votes.Cool, votes.Dry, votes.Fan, votes.Off, decision
        ))

    elseif IsSceneLiving == true and sceneLiving == 'heating' then
        -- hier setpoint / modes zetten
        debugLogClima(string.format(
            "Living Airco ON (Heating Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Dry=%d, Fan=%d, Off=%d → decision: %s",
            matches, votes.Heat, votes.Cool, votes.Dry, votes.Fan, votes.Off, decision
        ))

    elseif IsSceneLiving == true and sceneLiving == 'off' then
        -- switchDevice("Woonkamer_Airco_Power", "Off")
        debugLogClima(string.format(
            "Living Airco OFF (Comfort Mode)# Decision based on %d comparable logs:# Heat=%d, Cool=%d, Dry=%d, Fan=%d, Off=%d → decision: %s",
            matches, votes.Heat, votes.Cool, votes.Dry, votes.Fan, votes.Off, decision
        ))
    end
--]]
end
