--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"BijkeukenContr_Garage_AAN", "BijkeukenContr_Garage_UIT", "Bijkeuken_Deur", "Garage_Deur", "Garage_Motion", "Time Trigger 5min"}) then return end

--
-- **********************************************************
-- Garage lights ON
-- **********************************************************
--
	if (devicechanged["Bijkeuken_Deur"] == 'Open' or devicechanged["Garage_Deur"] == 'Open' or devicechanged["Garage_Motion"] == 'On' or devicechanged["BijkeukenContr_Garage_AAN"] == 'On')
		and otherdevices["Garage_Verlichting"] == 'Off'
		and otherdevices["Personen"] == 'Aanwezig'
		and powerFailsave('false')		
	then
		switchDevice("Garage_Verlichting", "On")
		debugLog('Iemand in de garage')
	end

	if (devicechanged["Garage_Deur"] == 'Open')
		and otherdevices["Garage_Verlichting"] == 'Off'
		and otherdevices["Personen"] ~= 'Aanwezig'
		and lastSeen('Garage_Motion', '>', '10')
		and powerFailsave('false')		
	then
		switchDevice("Garage_Verlichting", "On")
		debugLog('Iemand thuis gekomen via de garage')
	end
	
--
-- **********************************************************
-- Garage lights OFF
-- **********************************************************
--
	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Garage_Verlichting"] == 'On'
		and otherdevices["Garage_Motion"] == 'Off'
		and lastSeen('Garage_Verlichting', '>=', '300')
		and lastSeen('Garage_Motion', '>=', '300')
		and powerFailsave('false')
	then
	
		if otherdevices["Garage_Deur"] == 'Closed' and lastSeen('Garage_Motion', '>=', '300') then
		switchDevice("Garage_Verlichting", "Off")
		debugLog('Garage verlichting UIT na 300s #Failsave')
		end

		if otherdevices["Garage_Deur"] == 'Open' and lastSeen('Garage_Motion', '>=', '1800') then
		switchDevice("Garage_Verlichting", "Off")
		debugLog('Garage verlichting UIT na 1800s #Failsave')
		end		
		
	end
	
	if devicechanged["BijkeukenContr_Garage_UIT"] == 'On'
		and otherdevices["Garage_Verlichting"] == 'On'
		and powerFailsave('false')
	then
		switchDevice("Garage_Verlichting", "Off")
		debugLog('Garage verlichting manueel UIT')
	end