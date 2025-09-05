--
-- **********************************************************
-- Air conditioner Bedroom1 (COOL) On setpoint('4947')
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'Off'
		and uservariables["Slaapkamer_Airco_override"] == 0
		and uservariables["Slaapkamer_Airco_auto"] == 0
		and sensorValue('Voortuin_Temp') >= 18.0
		and sensorValue('Slaapkamer_Deur_Master_Temp') >= sensorValue('Slaapkamer_Airco_Setpoint')
		and lastSeen('Slaapkamer_Airco_Power', '>=', '3600')
		and summer('true')
		and (otherdevices["Slaapkamer_Airco_Power"] ~= 'On' or otherdevices["Slaapkamer_Airco_Mode"] ~= 'Cool')
		and timebetween("07:00:00","20:59:59")
		and powerFailsave('false')
	then
		switchDevice("SetSetPoint:4947", "21.5")
		switchDevice("Slaapkamer_Airco_Mode", "Set Level 10")
		switchDevice("Slaapkamer_Airco_Fan_Mode", "Set Level 10")
		switchDevice("Slaapkamer_Airco_Swing_Mode(Up/Down)", "Set Level 20")
		switchDevice("Slaapkamer_Airco_Swing_Mode(Left/Right)", "Set Level 20")
		switchDevice("Variable:Slaapkamer_Airco_auto", "1")
		debugLog('Slaapkamer Airco AAN')
	end

--
-- **********************************************************
-- Set manual override
-- **********************************************************
--

	if devicechanged["Slaapkamer_Airco_Power"] and uservariables["Slaapkamer_Airco_override"] == 0 and uservariables["Slaapkamer_Airco_auto"] == 1 then
		switchDevice("Variable:Slaapkamer_Airco_override", "1")
		--switchDevice("Variable:Slaapkamer_Airco_auto", "0")
	end
	
--
-- **********************************************************
-- Reset manual override
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On' and uservariables["Slaapkamer_Airco_override"] == 1 and timedifference(uservariables_lastupdate["Slaapkamer_Airco_override"]) > 21600 then
		switchDevice("Variable:Slaapkamer_Airco_override", "0")
		switchDevice("Variable:Slaapkamer_Airco_auto", "0")
	end
	
--[[	
--
-- **********************************************************
-- Air conditioner (COOL) Bedroom1 Off setpoint('4947')
-- **********************************************************
--
	if devicechanged["Time Trigger 5min"] == 'On'
	    and otherdevices["Personen"] ~= 'Aanwezig'
		and sensorValue('Gemiddelde_Temp_Buiten') <= sensorValue('Slaapkamer_Airco_Setpoint')
		and sensorValue('Slaapkamer_Deur_Master_Temp') <= sensorValue('Slaapkamer_Airco_Setpoint')
		and otherdevices["Slaapkamer_Airco_Power"] == 'On'
		and otherdevices["Slaapkamer_Airco_Mode"] == 'Cool'
		and lastSeen('Slaapkamer_Airco_Power', '>', '3600')
		and summer('true')
		and (timebetween("00:00:00","23:59:59") or timebetween("00:00:00","06:59:59"))
	then
		switchDevice("Slaapkamer_Airco_Power", "Off")
		debugLog('Slaapkamer (master) Airco UIT')	
	end
--]]