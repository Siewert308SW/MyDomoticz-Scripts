--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen", "WoonkamerContr_Verlichting_AAN", "WoonkamerContr_Verlichting_UIT", "BijkeukenContr_Verlichting_UIT"}) then return end

--
-- **********************************************************
-- CatFlap open
-- **********************************************************
--

	if (devicechanged["Personen"] == 'Aanwezig' or devicechanged["WoonkamerContr_Verlichting_AAN"] == 'On')
		and otherdevices["CatFlap"] == 'Off'
		--and timebetween("05:30:00","23:59:59")
		and powerFailsave('false')
	then
		switchDevice("CatFlap", "On")
		debugLog('Kattenluik geopend')
	end
	
--
-- **********************************************************
-- CatFlap closed
-- **********************************************************
--

	if (devicechanged["Personen"] == 'Standby' or devicechanged["Personen"] == 'Weg' or devicechanged["Personen"] == 'Slapen' or devicechanged["WoonkamerContr_Verlichting_UIT"] == 'On' or devicechanged["BijkeukenContr_Verlichting_UIT"] == 'On')
		and otherdevices["CatFlap"] == 'On'
		and powerFailsave('false')
	then
		switchDevice("CatFlap", "Off")
		debugLog('Kattenluik afgesloten')
	end