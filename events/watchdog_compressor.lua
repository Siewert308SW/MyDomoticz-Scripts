--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************

	if not isMyTrigger({"Personen", "Time Trigger 30min", "FietsenschuurContr_Comp_AAN", "FietsenschuurContr_Comp_UIT"}) then return end

--
-- **********************************************************
-- Compressor IDLE
-- **********************************************************
--
 
	if devicechanged["Time Trigger 30min"] == 'Off'
		and otherdevices["Compressor_WCD"] == 'On'
		and sensorValue('Compressor_Huidige_Verbruik') <= 5
		and lastSeen("Compressor_WCD", ">=", 3600)
		and lastSeen("Fietsenschuur_Deur", ">", 3600)
		and lastSeen("Fietsenschuur_Verlichting", ">", 3600)
		and lastSeen("Fietsenschuur_Motion", ">", 3600)
    then
		switchDevice("Compressor_WCD", "Off")
		debugLog('Compressor_WCD uitgeschakeld #failsave')
	end

--
-- **********************************************************
-- Compressor Manual ON
-- **********************************************************
--	
	if devicechanged["FietsenschuurContr_Comp_AAN"] == 'On'
		and otherdevices["Compressor_WCD"] == 'Off'
    then
		switchDevice("Compressor_WCD", "On")
		debugLog('Compressor AAN')
	end
	
--
-- **********************************************************
-- Compressor Manual OFF
-- **********************************************************
--	
	if (devicechanged["Personen"] == 'Aanwezig' or devicechanged["FietsenschuurContr_Comp_UIT"] == 'On')
		and otherdevices["Compressor_WCD"] == 'On'
    then
		switchDevice("Compressor_WCD", "Off")
		debugLog('Compressor UIT')
	end