--
-- **********************************************************
-- Boiler ON Time triggered
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["E-Boiler_WCD"] == 'Off'
		and homewizard('p1Available') < 0
		and lastSeen("E-Boiler_WCD", ">=", 3600)
		and sensorValue('BV_Charger_Huidige_Verbruik') <= 100
		and sensorValue('Vaatwasser_Huidige_Verbruik') <= 2
		and sensorValue('Wasmachine_Huidige_Verbruik') <= 2
		and sensorValue('Droger_Huidige_Verbruik') <= 2
		and timebetween(sunTime("sunrise"),sunTime("sunset"))
		and powerFailsave('false')
	then

		if homewizard("p1Available") <= -1500
			and uservariables["Water_Usage_Trigger"] == 0
		then
			switchDevice("E-Boiler_WCD", "On")
			switchDevice("Boiler_WCD", "On")
			switchDevice("Variable:Water_Usage_Trigger", "0")
			debugLog('Boiler AAN (Zonnestroom)')	
		end

-- **********************************************************
	
		if homewizard("p1Available") > -1500
			and homewizard("p1Available") < -500
			and uservariables["Water_Usage_Trigger"] ~= 0
		then
			switchDevice("E-Boiler_WCD", "On")
			switchDevice("Boiler_WCD", "On")
			switchDevice("Variable:Water_Usage_Trigger", "0")
			debugLog('Boiler AAN (Water Verbruik)')	
		end

-- **********************************************************

		if homewizard("p1Available") >= -500
			and lastSeen("E-Boiler_WCD", ">=", 57600)
		then
			switchDevice("E-Boiler_WCD", "On")
			switchDevice("Boiler_WCD", "On")
			switchDevice("Variable:Water_Usage_Trigger", "0")
			debugLog('Boiler AAN (> 16hr failsave)')				
		end

	end

--
-- **********************************************************
-- Boiler OFF
-- **********************************************************
	
	if devicechanged["Time Trigger 10min"] == 'Off'
		and summer('true')
		and otherdevices["E-Boiler_WCD"] == 'On'
		and homewizard("p1Available") > -1500
		and sensorValue('E-Boiler_Huidige_Verbruik') <= 2
		and lastSeen("E-Boiler_WCD", ">=", 3600)
		and (timebetween(sunTime("sunsetEarly"),"23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
		and powerFailsave('false')
    then
		switchDevice("E-Boiler_WCD", "Off")
		switchDevice("Boiler_WCD", "Off")
		switchDevice("Variable:Water_Usage_Trigger", "0")
		debugLog('Boiler UIT')	
	end

