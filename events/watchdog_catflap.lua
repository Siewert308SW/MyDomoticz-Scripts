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
		--debugLog('Kattenluik geopend')
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
		--debugLog('Kattenluik afgesloten')
	end