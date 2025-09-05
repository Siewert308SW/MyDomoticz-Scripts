-- *********************************************************************
-- Water Usage Detected
-- *********************************************************************

	if devicechanged["Time Trigger 1min"] == "On" 
		and otherdevices["E-Boiler_WCD"] == "Off"
		and lastSeen("Badkamer_Motion", "<=", "300")
		and uservariables["Watermeter_Start"] == "0"
		and sensorValue("Watermeter - Current usage") > 0
		and (otherdevices["Badkamer_Verlichting"] == "On" or otherdevices["Badkamer_Spiegel_Spots"] == "On")
		and powerFailsave('false')
	then
		local waterStart   = round(tonumber(sensorValue("Watermeter")), 1)
		switchDevice("Variable:Watermeter_Start", ""..waterStart.."")
		debugLog("Iemand aan het douchen? Maar de boiler is uit!")
	end

-- *********************************************************************
-- Water Usage Trigger
-- *********************************************************************

	if devicechanged["Time Trigger 1min"] == "Off" 
		and otherdevices["E-Boiler_WCD"] == "Off"
		and uservariables["Watermeter_Start"] ~= "0"
		and sensorValue("Watermeter - Current usage") > 0
		and powerFailsave('false')
	then
		local waterStart   = round(tonumber(uservariables["Watermeter_Start"]), 2)
		local waterEnd     = round(tonumber(sensorValue("Watermeter")), 2)
		local waterCounter = round(waterEnd - waterStart, 2)

		print("")
		print("-- *********************")
		print("-- Water is running")
		print("-- " .. waterCounter .. " Ltr verbruikt")
		print("-- *********************")
		print("")	

		if waterCounter > 75 and uservariables["Water_Usage_Trigger"] == 0 then
			switchDevice("Variable:Water_Usage_Trigger", "1")
		end
	end

-- *********************************************************************
-- Water Usage Reset
-- *********************************************************************

	if devicechanged["Time Trigger 1min"] == "On" 
		and lastSeen("Badkamer_Motion", ">=", 300)
		and uservariables["Watermeter_Start"] ~= "0"
		and sensorValue("Watermeter - Current usage") == 0
		and otherdevices["Badkamer_Verlichting"] == "Off" 
		and otherdevices["Badkamer_Spiegel_Spots"] == "Off"
		and powerFailsave('false')
	then
		local waterStart   = round(tonumber(uservariables["Watermeter_Start"]), 2)
		local waterEnd     = round(tonumber(sensorValue("Watermeter")), 2)
		local waterCounter = round(waterEnd - waterStart, 2)
		debugLog("Niemand meer aan het douchen, " .. waterCounter .. " Ltr verbruikt")
		switchDevice("Variable:Watermeter_Start", "0")
		debugLog("Variabelen zijn gereset")
	end