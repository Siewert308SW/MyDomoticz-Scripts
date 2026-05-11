--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 10min"}) then return end
	
--
-- **********************************************************
-- XMAS Garden lights ON when LUX is lower then threshold
-- **********************************************************
--
	
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Feestdagen"] ~= 'Off'
		and otherdevices["Voordeur_WCD"] == 'Off'
		and timebetween("16:00:00","23:29:59")
		and sensorValue('Tuin_Gem_Lux') <= 10
		and powerFailsave('false')
	then
		switchDevice("Voordeur_WCD", "On")
		switchDevice("Achterdeur_WCD", "On")
		debugLog('Tuinverlichting kerst ingeschakeld')
	end

--
-- **********************************************************
-- XMAS Garden light OFF at specific time
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Feestdagen"] ~= 'Off'
		and otherdevices["Voordeur_WCD"] == 'On'
		and timebetween("00:00:00",sunTime("sunrise"))
		and powerFailsave('false')
	then
	
		if weekend('false') and bankHoliday('false')
			and timebetween("00:00:00",sunTime("sunrise"))
		then
			switchDevice("Voordeur_WCD", "Off")
			switchDevice("Achterdeur_WCD", "Off")
			debugLog('Tuinverlichting kerst uitgeschakeld')	
			
		elseif weekend('true') and bankHoliday('false')
			and timebetween("01:00:00",sunTime("sunrise"))
		then
			switchDevice("Voordeur_WCD", "Off")
			switchDevice("Achterdeur_WCD", "Off")
			debugLog('Tuinverlichting kerst uitgeschakeld')
			
		elseif bankHoliday('true')
			and otherdevices["Personen"] ~= 'Aanwezig'
			and timebetween("01:00:00",sunTime("sunrise"))
		then
			switchDevice("Voordeur_WCD", "Off")
			switchDevice("Achterdeur_WCD", "Off")
			debugLog('Tuinverlichting kerst uitgeschakeld')
		end
		
	end

--
-- **********************************************************
-- Frontdoor WCD ON/OFF
-- **********************************************************
--
	
	if devicechanged["Time Trigger 10min"] == 'Off'
		and timebetween(sunTime("sunrise"),sunTime("sunset"))
		and otherdevices["Voordeur_WCD"] == 'Off'
		and otherdevices["Feestdagen"] == 'Off'
		and otherdevices["Personen"] == 'Aanwezig'
		and powerFailsave('false')
	then
		switchDevice("Voordeur_WCD", "On")
		switchDevice("Achterdeur_WCD", "On")
		
	elseif devicechanged["Time Trigger 10min"] == 'Off'
		and otherdevices["Voordeur_WCD"] == 'On'
		and otherdevices["Feestdagen"] == 'Off'
		and otherdevices["Personen"] ~= 'Aanwezig'
		and powerFailsave('false')
	then
		switchDevice("Voordeur_WCD", "Off")
		switchDevice("Achterdeur_WCD", "Off")
	end