--
-- **********************************************************
-- Air conditioner Living (COOL) On setpoint('4055')
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and uservariables["Woonkamer_Airco_override"] == 0
		and uservariables["Woonkamer_Airco_auto"] == 0
		--and sensorValue('Voortuin_Temp') >= 18.0
		and sensorValue('Woonkamer_Hum_Temp') >= sensorValue('Woonkamer_Airco_Setpoint')
		and lastSeen('Woonkamer_Airco_Power', '>=', '3600')
		and summer('true')
		and otherdevices["Woonkamer_Airco_Power"] == 'Off'
		and timebetween("07:00:00","20:59:59")
		and powerFailsave('false')
	then
		switchDevice("SetSetPoint:4055", "21.0")
		switchDevice("Woonkamer_Airco_Mode", "Set Level 10")
		switchDevice("Woonkamer_Airco_Fan_Mode", "Set Level 0")
		switchDevice("Woonkamer_Airco_Swing_Mode(Up/Down)", "Set Level 50")
		switchDevice("Woonkamer_Airco_Swing_Mode(Left/Right)", "Set Level 50")
		switchDevice("Variable:Woonkamer_Airco_auto", "1")
		debugLog('Woonkamer Airco AAN')	
	end

--
-- **********************************************************
-- Set manual override
-- **********************************************************
--

	if devicechanged["Woonkamer_Airco_Power"] and uservariables["Woonkamer_Airco_override"] == 0 and uservariables["Woonkamer_Airco_auto"] == 1 then
		switchDevice("Variable:Woonkamer_Airco_override", "1")
		--switchDevice("Variable:Woonkamer_Airco_auto", "0")
	end
	
--
-- **********************************************************
-- Reset manual override
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On' and uservariables["Woonkamer_Airco_override"] == 1 and timedifference(uservariables_lastupdate["Woonkamer_Airco_override"]) > 21600 then
		switchDevice("Variable:Woonkamer_Airco_override", "0")
		switchDevice("Variable:Woonkamer_Airco_auto", "0")
	end
	
	
--
-- **********************************************************
-- Air conditioner (COOL) Living Off setpoint('4055')
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'On'
	    and otherdevices["Personen"] ~= 'Aanwezig'
		and sensorValue('Woonkamer_Hum_Temp') < sensorValue('Woonkamer_Airco_Setpoint')
		and sensorValue('Voortuin_Temp') <= sensorValue('Woonkamer_Airco_Setpoint')
		and otherdevices["Woonkamer_Airco_Power"] == 'On'
		and otherdevices["Woonkamer_Airco_Mode"] == 'Cool'
		and lastSeen('Woonkamer_Airco_Power', '>', '3600')
		and summer('true')
		and (timebetween("00:00:00","23:59:59") or timebetween("00:00:00","06:59:59"))
		and powerFailsave('false')
	then
		switchDevice("Woonkamer_Airco_Power", "Off")
		switchDevice("Variable:Woonkamer_Airco_override", "0")
		switchDevice("Variable:Woonkamer_Airco_auto", "0")
		debugLog('Woonkamer Airco UIT')	
	end
	
--[[
--
-- **********************************************************
-- Air conditioner (COOL) Living Off #Failsave
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Woonkamer_Airco_Power"] == 'On'
		and otherdevices["Woonkamer_Airco_Mode"] == 'Cool'
		and otherdevices["Achter_Deur"] == 'Open'
		and summer('true')
		and lastSeen('Achter_Deur', '>', '600')
	then
		switchDevice("Woonkamer_Airco_Power", "Off")
		debugLog('#Failsave: Woonkamer Airco UIT, Achterdeur open!')
		
	end
--]]