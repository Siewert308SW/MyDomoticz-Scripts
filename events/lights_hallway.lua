--
-- **********************************************************
-- Hallway light ON
-- **********************************************************
--

	if (devicechanged["Voor_Deur"] == 'Open' or devicechanged["Hal_Deur"] == 'Open')
		and otherdevices["Hal_Verlichting"] == 'Off'
		and dark('true', 'Hal_LUX', 15)
		and powerFailsave('false')
	then
		switchDevice("Hal_Verlichting", "On")
		--debugLog('Iemand in de hal')
	end
	
	if (devicechanged["Hal_Motion"] == 'On')
		and otherdevices["Hal_Verlichting"] == 'Off'
		and otherdevices["Personen"] == 'Aanwezig'
		and dark('true', 'Hal_LUX', 15)
		and powerFailsave('false')
	then
		switchDevice("Hal_Verlichting", "On")
	end
	
--
-- **********************************************************
-- Hallway Light OFF
-- **********************************************************
--

	if devicechanged["Time Trigger 1min"] == 'Off'
		and otherdevices["Hal_Verlichting"] == 'On'
		and lastSeen("Hal_Motion", ">=", 90)
		and lastSeen("Hal_Deur", ">=", 90)
		and lastSeen("Voor_Deur", ">=", 90)
		and lastSeen("Hal_Verlichting", ">=", 90)
		and powerFailsave('false')		
	then
	
		if otherdevices["Voor_Deur"] == 'Closed'
			and otherdevices["Hal_Deur"] == 'Closed'
			and lastSeen("Hal_Motion", ">=", 90)
			and lastSeen("Hal_Deur", ">=", 90)
			and lastSeen("Voor_Deur", ">=", 90)
			and lastSeen("Hal_Verlichting", ">=", 90)
		then
		switchDevice("Hal_Verlichting", "Off")
		--debugLog('Niemand meer in de hal')
		end

		if (otherdevices["Voor_Deur"] ~= 'Closed'
			or otherdevices["Hal_Deur"] ~= 'Closed')
			and lastSeen("Hal_Motion", ">=", 300)
			and lastSeen("Hal_Deur", ">=", 300)
			and lastSeen("Voor_Deur", ">=", 300)
			and lastSeen("Hal_Verlichting", ">=", 300)
		then
		switchDevice("Hal_Verlichting", "Off")
		--debugLog('Niemand meer in de hal')
		end		
		
	end	