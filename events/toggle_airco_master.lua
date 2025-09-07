--
-- **********************************************************
-- Air conditioner Bedroom1 (COOL) On setpoint('4947')
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'Off'
		and uservariables["Slaapkamer_Airco_auto"] == 0
		and sensorValue('Voortuin_Temp') > 17.0
		and sensorValue('Slaapkamer_Deur_Master_Temp') >= 22.0
		and lastSeen('Slaapkamer_Airco_Power', '>=', '3600')
		and summer('true')
		and (otherdevices["Slaapkamer_Airco_Power"] ~= 'On' or otherdevices["Slaapkamer_Airco_Mode"] ~= 'Cool')
		and timebetween(sunTime("sunrise"),sunTime("sunset"))
		and powerFailsave('false')
	then
		switchDevice("SetSetPoint:4947", "22.0")
		switchDevice("Slaapkamer_Airco_Mode", "Set Level 10")
		switchDevice("Slaapkamer_Airco_Fan_Mode", "Set Level 10")
		switchDevice("Slaapkamer_Airco_Swing_Mode(Up/Down)", "Set Level 20")
		switchDevice("Slaapkamer_Airco_Swing_Mode(Left/Right)", "Set Level 20")
		switchDevice("Variable:Slaapkamer_Airco_auto", "1")
		debugLog('Slaapkamer Airco AAN')
	end
	
--
-- **********************************************************
-- Air conditioner (COOL) Bedroom1 Off setpoint('4947')
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'On'
		and uservariables["Slaapkamer_Airco_auto"] == 1
		and sensorValue('Voortuin_Temp') <= 17
		and sensorValue('Slaapkamer_Deur_Master_Temp') <= sensorValue('Slaapkamer_Airco_Setpoint')
		and otherdevices["Slaapkamer_Airco_Power"] == 'On'
		and otherdevices["Slaapkamer_Airco_Mode"] == 'Cool'
		and lastSeen('Slaapkamer_Airco_Power', '>', '3600')
		and summer('true')
		and (timebetween(sunTime("sunset"),"23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
		and powerFailsave('false')
	then
		switchDevice("Slaapkamer_Airco_Power", "Off")
		switchDevice("Variable:Slaapkamer_Airco_auto", "0")
		debugLog('Slaapkamer (master) Airco UIT')	
	end

--
-- **********************************************************
-- Air conditioner reset variable
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'Off'
		and uservariables["Slaapkamer_Airco_auto"] == 1
		and otherdevices["Slaapkamer_Airco_Power"] == 'Off'
		and (timebetween(sunTime("sunset"),"23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
		and powerFailsave('false')
	then
		switchDevice("Variable:Slaapkamer_Airco_auto", "0")
		debugLog('Slaapkamer Airco variable reset')	
	end