--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen"}) then return end

--
-- **********************************************************
-- Devices OFF when nobody home
-- **********************************************************
--

	if devicechanged["Personen"] == 'Weg'
		and powerFailsave('false')
		and (otherdevices["Slaapkamer_Verlichting"] == 'On'
		or otherdevices["Siewert_Nachtlamp"] == 'On'
		or otherdevices["Jerina_Nachtlamp"] == 'On')
	then
		switchDevice("Slaapkamer_Verlichting", "Off")
		switchDevice("Siewert_Nachtlamp", "Off")
		switchDevice("Jerina_Nachtlamp", "Off")
		debugLog('Overige verlichting uitgeschakeld, Niemand aanwezig.')
		
		if otherdevices["Oven_WCD"] == 'On' and sensorValue('Oven_Huidige_Verbruik') >= 100 then
		switchDevice("Oven_WCD", "Off")
		debugLog('Oven vergeten? Is nu uitgeschakeld')		
		end
	end