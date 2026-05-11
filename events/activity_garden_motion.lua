--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Voor_Deur", "Voordeur_Motion", "Achter_Deur", "Garage_Deur", "Achterdeur_Motion", "Fietsenschuur_Deur", "Time Trigger 5min" }) then return end
	
--
-- **********************************************************
-- Garden lights ON @ motion
-- **********************************************************
--
	
	if (devicechanged["Voor_Deur"] == 'Open' or devicechanged["Voordeur_Motion"] == 'On' or devicechanged["Achter_Deur"] == 'Open' or devicechanged["Garage_Deur"] == 'Open' or devicechanged["Achterdeur_Motion"] == 'On' or devicechanged["Fietsenschuur_Deur"] == 'Open')
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and (timebetween(sunTime("sunset"),"23:59:59") or timebetween("00:00:00",sunTime("sunrise")))
		and uservariables["tuin_activity"] == 0
		and uservariables["tuin_verlichting_auto"] == 0
		and sensorValue('Tuin_Gem_Lux') < 1
		--and dark('true', 'garden', 5)
		and powerFailsave('false')
	then
		switchDevice("Scene:Tuinverlichting AAN", "On")
		switchDevice("Variable:tuin_activity", "1")
		debugLog('Iemand in de tuin gezien')			
	end
	
--
-- **********************************************************
-- Garden lights OFF @ no motion
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Voordeur_Verlichting"] ~= 'Off'
		and uservariables["tuin_activity"] == 1
		and uservariables["tuin_verlichting_auto"] == 0
		and motionGarden('false', 240)
		and powerFailsave('false')
	then
		switchDevice("Scene:Tuinverlichting UIT", "On")
		switchDevice("Variable:tuin_activity", "0")
		debugLog('Niemand meer in de tuin')			
	end
