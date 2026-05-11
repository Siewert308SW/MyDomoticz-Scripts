--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 5min", "Time Trigger 10min"}) then return end
	
--
-- **********************************************************
-- Boiler ON - Sun Surplus triggered E-Boiler_WCD
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["E-Boiler_WCD"] == 'Off'
		and otherdevices["Badkamer_Spiegel_Spots"] == 'Off'
		and otherdevices["Badkamer_Verlichting"] == 'Off'
		and lastSeen("Badkamer_Spiegel_Spots", ">=", "300")
		and lastSeen("Badkamer_Verlichting", ">=", "300")
		--and timebetween(sunTime("sunriseLate"),sunTime("sunsetEarly"))
		and timebetween("09:00:00",sunTime("sunsetEarly"))
		and lastSeen("E-Boiler_WCD", ">=", "3600")
		and boilerSmartStart('true')		
		and powerFailsave('false')
	then
		switchDevice("E-Boiler_WCD", "On")
		switchDevice("Variable:Water_Usage_Trigger", "0")
		debugLog('Boiler AAN')
	end
	
--
-- **********************************************************
-- Boiler OFF
-- **********************************************************
--	
	if devicechanged["Time Trigger 5min"] == 'Off'
		and otherdevices["E-Boiler_WCD"] == 'On'
		and otherdevices["Badkamer_Spiegel_Spots"] == 'Off'
		and otherdevices["Badkamer_Verlichting"] == 'Off'
		and lastSeen("Badkamer_Spiegel_Spots", ">=", "300")
		and lastSeen("Badkamer_Verlichting", ">=", "300")
		and (timebetween(sunTime("sunsetEarly"),"23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
		and lastSeen("E-Boiler_WCD", ">=", "3600")
		and homewizard("p1Available") >= -2000
		and homewizard("Solar") >= -2000
		and uservariables["SunScoreTomorrow"] >= 35
		and sensorValue('E-Boiler_Huidige_Verbruik') <= 2
		and summer('true')
		and powerFailsave('false')
    then
		switchDevice("E-Boiler_WCD", "Off")
		debugLog('Boiler UIT')
	end
