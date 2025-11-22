--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************

	if not isMyTrigger({"Time Trigger 10min"}) then return end

--
-- **********************************************************
-- BV Charger determine bicycle or e-scooter charging
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["BV_Charger_WCD"] == 'On'
		and sensorValue('BV_Charger_Huidige_Verbruik') >= 700
		and otherdevices["Scooter"] == 'Off'
		and powerFailsave('false')
    then
		switchDevice("Scooter", "On")
		debugLog('Scooter wordt opgeladen')
	end

--
-- **********************************************************
-- BV Charger IDLE when only bicycle charged
-- **********************************************************
--
 
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["BV_Charger_WCD"] == 'On'
		and sensorValue('BV_Charger_Huidige_Verbruik') < 10
		and otherdevices["Scooter"] == 'Off'
		and uservariables["bvcharger_standby"] == 0
		and lastSeen("BV_Charger_WCD", ">=", 10800)
    then
		--switchDevice("BV_Charger_WCD", "Off")
		switchDevice("Variable:bvcharger_standby", "1")
		debugLog('Opladen fietsen voltooid, Laders idle')
	end
	
--
-- **********************************************************
-- BV Charger IDLE when scooter/bicycle charged
-- **********************************************************
--
 
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["BV_Charger_WCD"] == 'On'
		and sensorValue('BV_Charger_Huidige_Verbruik') < 30
		and otherdevices["Scooter"] == 'On'
		and uservariables["bvcharger_standby"] == 0
		and lastSeen("BV_Charger_WCD", ">=", 10800)
    then
		--switchDevice("BV_Charger_WCD", "Off")
		switchDevice("Scooter", "Off")
		switchDevice("Variable:bvcharger_standby", "1")
		debugLog('Opladen scooter/fietsen voltooid, Laders idle')
	end

--
-- **********************************************************
-- BV Charger OFF when scooter/bicycle charged
-- **********************************************************
--
 
	if devicechanged["Time Trigger 10min"] == 'Off'
		and otherdevices["BV_Charger_WCD"] == 'On'
		and uservariables["bvcharger_standby"] == 1
		and lastSeen("BV_Charger_WCD", ">=", 1800)
		and lastSeenVar("bvcharger_standby", ">=", 1800)
    then
		switchDevice("BV_Charger_WCD", "Off")
		switchDevice("Scooter", "Off")
		switchDevice("Variable:bvcharger_standby", "0")
		debugLog('Opladen scooter/fietsen voltooid')
	end
	