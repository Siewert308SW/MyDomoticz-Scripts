--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen"}) then return end

--
-- **********************************************************
-- CatFlap open
-- **********************************************************
--

	if (devicechanged["Personen"] == 'Aanwezig')
		and otherdevices["CatFlap"] == 'Off'
		and timebetween("05:30:00","23:59:59")
		and powerFailsave('false')
	then
		switchDevice("CatFlap", "On")
		debugLogVar('Kattenluik geopend')
	end
	
--
-- **********************************************************
-- CatFlap closed
-- **********************************************************
--

	if (devicechanged["Personen"] == 'Standby' or devicechanged["Personen"] == 'Weg' or devicechanged["Personen"] == 'Slapen')
		and otherdevices["CatFlap"] == 'On'
		and powerFailsave('false')
	then
		switchDevice("CatFlap", "Off")
		debugLogVar('Kattenluik afgesloten')
	end