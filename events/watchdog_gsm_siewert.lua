--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Slaapkamer_Deur_Master", "Time Trigger 10min"}) then return end

--
-- **********************************************************
-- Siewert Phone ON
-- **********************************************************
--
	if devicechanged["Slaapkamer_Deur_Master"]
		and otherdevices["Personen"] == 'Standby'
		and otherdevices["Siewert_GSM"] == 'On'
		and otherdevices["Siewert_Charger"] == 'Off'
	then
		switchDevice("Siewert_Charger", "On")
		debugLogVar('Siewert is thuis, GSM charger AAN')
	end


--
-- **********************************************************
-- Siewert's Phone is charging
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'Off'
		and otherdevices["Siewert_GSM"] == 'On'
		and otherdevices["Siewert_Charger"] == 'On'
		and uservariables["siewert_charger"] == 0
		and sensorValue('Siewert_Charger_Huidige_Verbruik') >= 7
	then
		switchDevice("Variable:siewert_charger", "1")
		debugLogVar('Siewert GSM is aan het laden')
	end
	
--
-- **********************************************************
-- Siewert Phone OFFand uservariables["tuin_activity"] == 0
-- **********************************************************
--
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Siewert_Charger"] == 'On'
		and uservariables["siewert_charger"] == 1
		and sensorValue('Siewert_Charger_Huidige_Verbruik') <= 1
		and lastSeen('Siewert_Charger', '>=', '4800')
	then
		switchDevice("Siewert_Charger", "Off")
		debugLogVar('Siewert GSM opladen voltooid, charger UIT')
	end