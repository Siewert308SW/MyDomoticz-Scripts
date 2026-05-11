--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************

	if not isMyTrigger({"Time Trigger 10min", "EB_Chargers_WCD"}) then return end
	
--
-- **********************************************************
-- EB Charger IDLE when only bicycle charged
-- **********************************************************
--
 
	if devicechanged["Time Trigger 10min"] == 'Off'
		and uservariables["ebchargers_standby"] == 0
		and otherdevices["EB_Chargers_WCD"] == 'On'
		and sensorValue('EB_Chargers_Huidige_Verbruik') >= 1
		and sensorValue('EB_Chargers_Huidige_Verbruik') < 130
		and lastSeen("EB_Chargers_WCD", ">=", 7200)
    then
		switchDevice("Variable:ebchargers_standby", "1")
		debugLog('Opladen fietsen/scooter voltooid, Laders idle')
	end
	
--
-- **********************************************************
-- EB Charger IDLE when scooter/bicycle charged
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and uservariables["ebchargers_standby"] == 1
		and otherdevices["EB_Chargers_WCD"] == 'On'
		and sensorValue('EB_Chargers_Huidige_Verbruik') >= 1
		and sensorValue('EB_Chargers_Huidige_Verbruik') < 130
		and lastSeen("EB_Chargers_WCD", ">=", 10800)
    then
		switchDevice("EB_Chargers_WCD", "Off")
		switchDevice("Variable:ebchargers_standby", "0")
		debugLog('Opladen scooter/fietsen voltooid, laders uitgeschakeld')
	end

--
-- **********************************************************
-- EB Chargers manual OFF?
-- **********************************************************
--
	if devicechanged["EB_Chargers_WCD"] == 'Off'
    then
	
		if uservariables["ebchargers_standby"] == 1 then
			switchDevice("Variable:ebchargers_standby", "0")
		end
		
		debugLog('Laders scooter/fietsen manueel uitgeschakeld')
	end	