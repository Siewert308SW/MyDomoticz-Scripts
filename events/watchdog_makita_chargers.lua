--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************

	if not isMyTrigger({"Time Trigger 30min", "FietsenschuurContr_Makita_AAN", "FietsenschuurContr_Makita_UIT"}) then return end

--
-- **********************************************************
-- Makita Chargers IDLE
-- **********************************************************
--
 
	if devicechanged["Time Trigger 30min"] == 'Off'
		and otherdevices["Fietsenschuur_Makita_WCD"] == 'On'
		and sensorValue('Fietsenschuur_Makita_Verbruik') <= 5
		and lastSeen("Fietsenschuur_Makita_WCD", ">=", 3600)
    then
		switchDevice("Fietsenschuur_Makita_WCD", "Off")
		debugLog('Opladen Makita accu voltooid')
	end

--
-- **********************************************************
-- Makita Chargers Manual ON
-- **********************************************************
--	
	if devicechanged["FietsenschuurContr_Makita_AAN"] == 'On'
		and otherdevices["Fietsenschuur_Makita_WCD"] == 'Off'
    then
		switchDevice("Fietsenschuur_Makita_WCD", "On")
		debugLog('Makita laders AAN')
	end
	
--
-- **********************************************************
-- Makita Chargers Manual OFF
-- **********************************************************
--	
	if devicechanged["FietsenschuurContr_Makita_UIT"] == 'On'
		and otherdevices["Fietsenschuur_Makita_WCD"] == 'On'
    then
		switchDevice("Fietsenschuur_Makita_WCD", "Off")
		debugLog('Makita laders UIT')
	end