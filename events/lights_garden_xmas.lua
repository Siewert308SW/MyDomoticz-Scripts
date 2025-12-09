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
		and xmasseason('true')
		and otherdevices["Voordeur_WCD"] == 'Off'
		and dark('true', 'garden', 50)
		and timebetween(sunTime("sunsetEarly"),"23:29:59")
		and powerFailsave('false')
	then
		switchDevice("Voordeur_WCD", "On")
		debugLog('Tuinverlichting kerst ingeschakeld')
	end

--
-- **********************************************************
-- XMAS Garden light OFF at specific time
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and xmasseason('true')
		and otherdevices["Voordeur_WCD"] == 'On'
		and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00",sunTime("sunset")))
		and powerFailsave('false')
	then
	
		if weekend('false') and bankHoliday('false')
			and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00",sunTime("sunset")))
		then
			switchDevice("Voordeur_WCD", "Off")
			debugLog('Tuinverlichting kerst uitgeschakeld')	
			
		elseif weekend('true') and bankHoliday('false')
			and otherdevices["Personen"] ~= 'Aanwezig'
			and timebetween("00:00:00",sunTime("sunrise"))
		then
			switchDevice("Voordeur_WCD", "Off")
			debugLog('Tuinverlichting kerst uitgeschakeld')
			
		elseif bankHoliday('true')
			and otherdevices["Personen"] ~= 'Aanwezig'
			and timebetween("02:00:00",sunTime("sunrise"))
		then
			switchDevice("Voordeur_WCD", "Off")
			debugLog('Tuinverlichting kerst uitgeschakeld')
		end
		
	end