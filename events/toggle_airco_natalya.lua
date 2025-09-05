--
-- **********************************************************
-- Air conditioner Bedroom2 (COOL) On setpoint('4103')
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'Off'
		and uservariables["Natalya_Airco_override"] == 0
		and uservariables["Natalya_Airco_auto"] == 0
		and sensorValue('Voortuin_Temp') >= 18.0
		and sensorValue('Slaapkamer_Deur_Natalya_Temp') >= sensorValue('Natalya_Airco_Setpoint')
		and lastSeen('Natalya_Airco_Power', '>=', '3600')
		and summer('true')
		and (otherdevices["Natalya_Airco_Power"] ~= 'On' or otherdevices["Natalya_Airco_Mode"] ~= 'Cool')
		and timebetween("07:00:00","20:59:59")
		and powerFailsave('false')
	then
		switchDevice("SetSetPoint:4103", "23.0")
		switchDevice("Natalya_Airco_Mode", "Set Level 10")
		switchDevice("Natalya_Airco_Fan_Mode", "Set Level 10")
		switchDevice("Natalya_Airco_Swing_Mode(Up/Down)", "Set Level 20")
		switchDevice("Natalya_Airco_Swing_Mode(Left/Right)", "Set Level 20")
		switchDevice("Variable:Natalya_Airco_auto", "1")
		debugLog('Natalya Airco AAN')		
	end

--
-- **********************************************************
-- Set manual override
-- **********************************************************
--

	if devicechanged["Natalya_Airco_Power"] and uservariables["Natalya_Airco_override"] == 0 and uservariables["Natalya_Airco_auto"] == 1 then
		switchDevice("Variable:Natalya_Airco_override", "1")
		--switchDevice("Variable:Natalya_Airco_auto", "0")
	end
	
--
-- **********************************************************
-- Reset manual override
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On' and uservariables["Natalya_Airco_override"] == 1 and timedifference(uservariables_lastupdate["Natalya_Airco_override"]) > 21600 then
		switchDevice("Variable:Natalya_Airco_override", "0")	
	end
	
--[[
--
-- **********************************************************
-- Air conditioner (COOL) Bedroom2 Off setpoint('4103')
-- **********************************************************
--
	if devicechanged["Time Trigger 5min"] == 'On'
	    and otherdevices["Personen"] ~= 'Aanwezig'
		and sensorValue('Gemiddelde_Temp_Buiten') <= sensorValue('Natalya_Airco_Setpoint')
		and sensorValue('Slaapkamer_Deur_Natalya_Temp') <= sensorValue('Natalya_Airco_Setpoint')
		and otherdevices["Natalya_Airco_Power"] == 'On'
		and otherdevices["Natalya_Airco_Mode"] == 'Cool'
		and lastSeen('Natalya_Airco_Power', '>', '3600')
		and summer('true')
		and (timebetween("00:00:00","23:59:59") or timebetween("00:00:00","06:59:59"))
	then
		switchDevice("Natalya_Airco_Power", "Off")
		debugLog('Slaapkamer (natalya) Airco UIT')	
	end
--]]