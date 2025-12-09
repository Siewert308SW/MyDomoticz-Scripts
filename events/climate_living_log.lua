--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--

if not isMyTrigger({"Time Trigger 30min"}) then return end
	if devicechanged["Time Trigger 30min"] == "On" then

--
-- *********************************************************************
-- Living Climate Logger
-- *********************************************************************
--

-- Seasons
	local nowMonth 			= tonumber(os.date("%m"))
	local season =
		nowMonth >= 3 and nowMonth <= 5 and "spring" or
		nowMonth >= 6 and nowMonth <= 8 and "summer" or
		nowMonth >= 9 and nowMonth <= 10 and "autumn" or
		"winter"
		
-- Path to logfile
	local logFile = "/opt/domoticz/userdata/scripts/lua/logs/climate/living_history_" .. season .. ".csv"
	
-- Sensors
	local insideLiving1Temp = sensorValue("Woonkamer_Hum_Temp")
	local insideKitchenTemp	= sensorValue("Keuken_Motion_Temp")
	local insideLiving2Temp	= sensorValue("Woonkamer_Motion_Temp")
	local outsideFrontTemp 	= sensorValue("Voortuin_Temp")
	local outsideBackTemp  	= sensorValue("Achtertuin_Temp")

	local aircoState       	= otherdevices["Woonkamer Airco Power"] or "Off"
	local aircoSetpoint    	= tonumber(otherdevices["Woonkamer Airco Setpoint"]) or 18
	local aircoMode        	= otherdevices["Woonkamer Airco Mode"] or "Off"
	
	if aircoState == "Off" then
		aircoMode = "Off"
	end
	
-- Devices/Switches
	local presence       	= otherdevices["Personen"] or "Aanwezig"

	if presence == "Standby" or presence == "Start" or presence == "Stop" then
		presence = "Aanwezig"
	end

-- Average Inside temperature
	local avgInsideTemp     = roundToHalf(((tonumber(insideLiving1Temp) or 20) + (tonumber(insideLiving2Temp) or 20) + (tonumber(insideKitchenTemp) or 20)) / 3)

-- Average outside temperature
	local avgOutsideTemp 	= roundToHalf(((tonumber(outsideFrontTemp) or 18) + (tonumber(outsideBackTemp) or 18)) / 2)
	
-- TimeStamp
	local timestamp 		= os.date("%Y-%m-%d %H:%M")

--
-- *********************************************************************
-- Check previous log to avoid duplicate OFF and write new line
-- *********************************************************************
--

	local function readLastLogLine(path)
		local file = io.open(path, "r")
		if not file then return nil end
		local last
		for line in file:lines() do last = line end
		file:close()
		return last
	end

	local previousLine = readLastLogLine(logFile)

	if previousLine then
		local parts = {}
		for part in string.gmatch(previousLine, "([^,]+)") do
			table.insert(parts, part)
		end
		local prevState = parts[5] or "Off"
		local prevMode  = parts[6] or "Off"
	end

-- Create Log Lines
	local line = string.format(
		"%s,%.1f,%.1f,%.0f,%s,%s,%s,%s\n",
		timestamp,
		tonumber(avgInsideTemp) or 0,
		tonumber(avgOutsideTemp) or 0,
		aircoSetpoint,
		aircoState,
		aircoMode,
		season,
		presence
	)

-- Write to LogFile
	appendToFile(logFile, line)

-- Debug output
	--debugLogClima("ClimateLog Living:# " .. line)

end
