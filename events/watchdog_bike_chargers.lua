--
-- **********************************************************
-- BV Charger determine bicycle or e-scooter charging
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["BV_Charger_WCD"] == 'On'
		and sensorValue('BV_Charger_Huidige_Verbruik') >= 1000
		and otherdevices["Scooter"] == 'Off'
		and powerFailsave('false')
    then
		switchDevice("Scooter", "On")
		debugLog('Scooter wordt opgeladen')
	end

--
-- **********************************************************
-- BV Charger OFF when only bicycle charged
-- **********************************************************
--
 
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["BV_Charger_WCD"] == 'On'
		and sensorValue('BV_Charger_Huidige_Verbruik') < 5
		and otherdevices["Scooter"] == 'Off'
		and lastSeen("BV_Charger_WCD", ">=", 3600)
		and powerFailsave('false')
    then
		switchDevice("BV_Charger_WCD", "Off")
		debugLog('Opladen fietsen voltooid')
	end
	
--
-- **********************************************************
-- BV Charger OFF when scooter/bicycle charged
-- **********************************************************
--
 
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["BV_Charger_WCD"] == 'On'
		and sensorValue('BV_Charger_Huidige_Verbruik') < 25
		and otherdevices["Scooter"] == 'On'
		and lastSeen("BV_Charger_WCD", ">=", 5400)
		and powerFailsave('false')
    then
		switchDevice("BV_Charger_WCD", "Off")
		switchDevice("Scooter", "Off")
		debugLog('Opladen scooter/fietsen voltooid')
	end

--[[
-- Manual OFF
	if devicechanged["BV_Charger_WCD"] == 'Off'
		and otherdevices["Scooter"] == 'On'
    then
		commandArray[#commandArray+1]={["Scooter"] = "Off"}
		commandArray[#commandArray+1]={["Variable:bvcharger_override"] = "0"}
	end	
--]]