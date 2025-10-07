--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--

if not isMyTrigger({"Time Trigger 30min", "Dummy"}) then return end
	if devicechanged["Time Trigger 30min"] == "On" or devicechanged["Dummy"] == "On" then

--
-- *********************************************************************
-- Bedroom2 Climate Logger
-- *********************************************************************
--

-- Seasons
	local nowMonth 			= tonumber(os.date("%m"))
	local season =
		nowMonth >= 3 and nowMonth <= 4 and "spring" or
		nowMonth >= 5 and nowMonth <= 8 and "summer" or
		nowMonth >= 9 and nowMonth <= 11 and "autumn" or
		"winter"
		
-- Path to logfile
	local logFile = "/opt/domoticz/userdata/scripts/lua/logs/climate/bedroom2_history_" .. season .. ".csv"
	
-- Sensors
	local insideBedroom1Temp = sensorValue("Natalya_Deur_Master_Temp")
	local insideBedroom2Temp = sensorValue("Natalya_WCD_Temp")
	local outsideFrontTemp 	 = sensorValue("Voortuin_Temp")
	local outsideBackTemp  	 = sensorValue("Achtertuin_Temp")
	
	local insideHumidity   	 = humidity("living")
	local frontdoorLux   	 = sensorValue("Voordeur_LUX")
	local backdoorLux 		 = sensorValue("Achterdeur_LUX")
	local aircoState       	 = otherdevices["Natalya_Airco_Power"] or "Off"
	local aircoSetpoint    	 = tonumber(otherdevices["Natalya_Airco_Setpoint"]) or 0
	local aircoMode        	 = otherdevices["Natalya_Airco_Mode"] or "Off"
	
	if aircoState == "Off" then
		aircoMode = "Off"
	end	

-- Devices/Switches
	local presence       	= otherdevices["Personen"] or "Aanwezig"

	if presence == "Standby" or presence == "Start" or presence == "Stop" then
		presence = "Aanwezig"
	end
	
-- Average Inside temperature
	local avgInsideTemp     = roundToHalf(((tonumber(insideBedroom2Temp) or 20) + (tonumber(insideBedroom2Temp) or 20) + (tonumber(insideKitchenTemp) or 20)) / 3)

-- Average outside temperature
	local avgOutsideTemp 	= roundToHalf(((tonumber(outsideFrontTemp) or 18) + (tonumber(outsideBackTemp) or 18)) / 2)
	
-- Average outside lux
	local avgLux 			= roundToHalf(((tonumber(frontdoorLux) or 0) + (tonumber(backdoorLux) or 0)) / 2)

-- TimeStamp
	local timestamp 		= os.date("%Y-%m-%d %H:%M:%S")

-- Skip unsupported modes (Auto, Dry, Fan Only)
	local unsupported = { ["Dry"] = true, ["Auto"] = true, ["Fan Only"] = true }
	if unsupported[aircoMode] then return end

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
		local prevState = parts[7] or "Off"  -- colom 7 = aircoState
		local prevMode  = parts[8] or "Off" -- colom 8 = aircoMode
	end
	
-- Create Log Lines
	local line = string.format(
		"%s,%.1f,%.1f,%.0f,%.0f,%s,%s,%s,%s,%s\n",
		timestamp,
		tonumber(avgInsideTemp) or 0,
		tonumber(avgOutsideTemp) or 0,
		tonumber(insideHumidity) or 0,
		avgLux,
		aircoSetpoint,
		aircoState,
		aircoMode,
		season,
		presence
	)

-- Write to LogFile
	appendToFile(logFile, line)

-- Debug output
	--debugLogClima("ClimateLog Bedroom2:# " .. line)

end
