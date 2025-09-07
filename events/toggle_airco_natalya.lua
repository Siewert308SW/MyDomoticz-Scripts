--
-- **********************************************************
-- Air conditioner Bedroom2 (COOL) On setpoint('4103')
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'Off'
		and uservariables["Natalya_Airco_auto"] == 0
		and sensorValue('Voortuin_Temp') > 17.0
		and sensorValue('Slaapkamer_Deur_Natalya_Temp') >= 22.0
		and lastSeen('Natalya_Airco_Power', '>=', '3600')
		and summer('true')
		and (otherdevices["Natalya_Airco_Power"] ~= 'On' or otherdevices["Natalya_Airco_Mode"] ~= 'Cool')
		and timebetween(sunTime("sunrise"),sunTime("sunset"))
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
-- Air conditioner (COOL) Bedroom2 Off setpoint('4103')
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'On'
		and uservariables["Slaapkamer_Airco_auto"] == 1
		and sensorValue('Voortuin_Temp') <= 17
		and sensorValue('Slaapkamer_Deur_Natalya_Temp') <= sensorValue('Natalya_Airco_Setpoint')
		and otherdevices["Natalya_Airco_Power"] == 'On'
		and otherdevices["Natalya_Airco_Mode"] == 'Cool'
		and lastSeen('Natalya_Airco_Power', '>', '3600')
		and summer('true')
		and (timebetween(sunTime("sunset"),"23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
		and powerFailsave('false')
	then
		switchDevice("Natalya_Airco_Power", "Off")
		switchDevice("Variable:Natalya_Airco_auto", "0")
		debugLog('Slaapkamer (natalya) Airco UIT')	
	end

--
-- **********************************************************
-- Air conditioner reset variable
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'Off'
		and uservariables["Natalya_Airco_auto"] == 1
		and otherdevices["Natalya_Airco_Power"] == 'Off'
		and (timebetween(sunTime("sunset"),"23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
		and powerFailsave('false')
	then
		switchDevice("Variable:Natalya_Airco_auto", "0")
		debugLog('Natalya Airco variable reset')	
	end
	