--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen", "Slaapkamer_Deur_Master", "Time Trigger 10min"}) then return end

--
-- **********************************************************
-- Siewert Phone ON
-- **********************************************************
--
	if (devicechanged["Personen"] == 'Stop' or devicechanged["Slaapkamer_Deur_Master"])
		and otherdevices["Siewert_GSM"] == 'On'
		and otherdevices["Siewert_Charger_WCD"] == 'Off'
		and (timebetween("22:00:00","23:59:59") or timebetween("00:00:00","04:00:00"))		
	then
		switchDevice("Siewert_Charger_WCD", "On")
		debugLog('Siewert thuis, GSM charger AAN')
	end
	
--
-- **********************************************************
-- Siewert's Phone is charging
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'Off'
		and otherdevices["Siewert_GSM"] == 'On'
		and otherdevices["Siewert_Charger_WCD"] == 'On'
		and uservariables["siewert_charger"] == 0
		and sensorValue('Siewert_Charger_Huidige_Verbruik') >= 5
	then
		switchDevice("Variable:siewert_charger", "1")
		debugLog('Siewert GSM is aan het laden')
	end
	
--
-- **********************************************************
-- Siewert Phone OFFand uservariables["tuin_activity"] == 0
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Siewert_Charger_WCD"] == 'On'
		and (uservariables["siewert_charger"] == 1 or otherdevices["Personen"] == 'Weg')
		and sensorValue('Siewert_Charger_Huidige_Verbruik') < 1
		and lastSeen('Siewert_Charger_WCD', '>=', '10800')
	then
		switchDevice("Siewert_Charger_WCD", "Off")
		switchDevice("Variable:siewert_charger", "0")
		debugLog('Siewert GSM opladen voltooid, charger UIT')
	end