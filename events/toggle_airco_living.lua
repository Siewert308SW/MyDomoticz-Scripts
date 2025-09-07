--
-- **********************************************************
-- Air conditioner Living (COOL) On setpoint('4055')
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and uservariables["Woonkamer_Airco_auto"] == 0
		and sensorValue('Achtertuin_Temp') > 17.0
		and sensorValue('Woonkamer_Hum_Temp') > 21.5
		and lastSeen('Woonkamer_Airco_Power', '>=', '3600')
		and summer('true')
		and otherdevices["Woonkamer_Airco_Power"] == 'Off'
		and timebetween(sunTime("sunrise"),sunTime("sunset"))
		and powerFailsave('false')
	then
		switchDevice("SetSetPoint:4055", "22.0")
		switchDevice("Woonkamer_Airco_Mode", "Set Level 10")
		switchDevice("Woonkamer_Airco_Fan_Mode", "Set Level 0")
		switchDevice("Woonkamer_Airco_Swing_Mode(Up/Down)", "Set Level 50")
		switchDevice("Woonkamer_Airco_Swing_Mode(Left/Right)", "Set Level 50")
		switchDevice("Variable:Woonkamer_Airco_auto", "1")
		debugLog('Woonkamer Airco AAN')	
	end
	
--
-- **********************************************************
-- Air conditioner (COOL) Living Off setpoint('4055')
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'On'
		and uservariables["Woonkamer_Airco_auto"] == 1
		and sensorValue('Achtertuin_Temp') <= 17
		and sensorValue('Woonkamer_Hum_Temp') <= sensorValue('Woonkamer_Airco_Setpoint')
		and otherdevices["Woonkamer_Airco_Power"] == 'On'
		and otherdevices["Woonkamer_Airco_Mode"] == 'Cool'
		and lastSeen('Woonkamer_Airco_Power', '>', '3600')
		and summer('true')
		and (timebetween(sunTime("sunset"),"23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
		and powerFailsave('false')
	then
		switchDevice("Woonkamer_Airco_Power", "Off")
		switchDevice("Variable:Woonkamer_Airco_auto", "0")
		debugLog('Woonkamer Airco UIT')	
	end
	
--
-- **********************************************************
-- Air conditioner reset variable
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'Off'
		and uservariables["Woonkamer_Airco_auto"] == 1
		and otherdevices["Woonkamer_Airco_Power"] == 'Off'
		and (timebetween(sunTime("sunset"),"23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
		and powerFailsave('false')
	then
		switchDevice("Variable:Woonkamer_Airco_auto", "0")
		debugLog('Woonkamer Airco variable reset')	
	end