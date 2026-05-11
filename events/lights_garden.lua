--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 5min", "Time Trigger 10min"}) then return end
	
--
-- **********************************************************
-- Garden lights ON when LUX is lower then threshold
-- **********************************************************
--
	
	if devicechanged["Time Trigger 5min"] == 'Off'
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and otherdevices["Achterdeur_Verlichting"] == 'Off'
		and otherdevices["Brandgang_Verlichting"] == 'Off'
		and otherdevices["Fietsenschuur_Buiten_Verlichting"] == 'Off'
		and uservariables["tuin_activity"] == 0
		and sensorValue('Tuin_Gem_Lux') < 15
		--and dark('true', 'garden', 5)
		and timebetween(sunTime("sunset"),"23:29:59")
		and powerFailsave('false')
	then
		switchDevice("Scene:Tuinverlichting AAN", "On")
		switchDevice("Variable:tuin_verlichting_auto", "1")
		debugLog('Tuinverlichting ingeschakeld')
	end

--
-- **********************************************************
-- Garden lights OFF when LUX is higher then threshold
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and (otherdevices["Voordeur_Verlichting"] ~= 'Off'
		or otherdevices["Achterdeur_Verlichting"] ~= 'Off'
		or otherdevices["Brandgang_Verlichting"] ~= 'Off'
		or otherdevices["Fietsenschuur_Buiten_Verlichting"] ~= 'Off')
		and uservariables["tuin_activity"] == 0
		and sensorValue('Tuin_Gem_Lux') > 15
		--and dark('false', 'garden', 10)
		and lastSeen('Voordeur_Verlichting', '>', '300')
		and powerFailsave('false')
	then
		switchDevice("Scene:Tuinverlichting UIT", "On")
		switchDevice("Variable:tuin_verlichting_auto", "0")
		debugLog('Tuinverlichting uitgeschakeld')
	end

--
-- **********************************************************
-- Garden light OFF at specific time
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'Off'
		and otherdevices["Personen"] ~= 'Aanwezig'
		and (otherdevices["Voordeur_Verlichting"] ~= 'Off'
		or otherdevices["Achterdeur_Verlichting"] ~= 'Off'
		or otherdevices["Brandgang_Verlichting"] ~= 'Off'
		or otherdevices["Fietsenschuur_Buiten_Verlichting"] ~= 'Off')
		and uservariables["tuin_activity"] == 0
		and motionGarden('false', 300)
		and timebetween("00:00:00",sunTime("sunrise"))
		and powerFailsave('false')
	then
		switchDevice("Scene:Tuinverlichting UIT", "On")
		switchDevice("Variable:tuin_verlichting_auto", "0")
		debugLog('Tuinverlichting uitgeschakeld')
	end
	
--[[
	if devicechanged["Time Trigger 10min"] == 'Off'
		and (otherdevices["Voordeur_Verlichting"] ~= 'Off'
		or otherdevices["Achterdeur_Verlichting"] ~= 'Off'
		or otherdevices["Brandgang_Verlichting"] ~= 'Off'
		or otherdevices["Fietsenschuur_Buiten_Verlichting"] ~= 'Off')
		and uservariables["tuin_activity"] == 0
		and motionGarden('false', 1800)
		and timebetween("00:00:00",sunTime("sunrise"))
		and powerFailsave('false')
		and newYear('false')
	then
	
		if weekend('false') and bankHoliday('false')
			and timebetween("00:00:00",sunTime("sunrise"))
		then
			switchDevice("Scene:Tuinverlichting UIT", "On")
			switchDevice("Variable:tuin_verlichting_auto", "0")
			debugLog('Tuinverlichting uitgeschakeld')
		
		elseif weekend('true') and bankHoliday('false')
			and otherdevices["Personen"] ~= 'Aanwezig'
			and timebetween("00:30:00",sunTime("sunrise"))
		then
			switchDevice("Scene:Tuinverlichting UIT", "On")
			switchDevice("Variable:tuin_verlichting_auto", "0")
			debugLog('Tuinverlichting uitgeschakeld')

		elseif bankHoliday('true')
			and otherdevices["Personen"] ~= 'Aanwezig'
			and timebetween("00:30:00",sunTime("sunrise"))			
		then
			switchDevice("Scene:Tuinverlichting UIT", "On")
			switchDevice("Variable:tuin_verlichting_auto", "0")
			debugLog('Tuinverlichting uitgeschakeld')
			
		end
		
	end
	--]]