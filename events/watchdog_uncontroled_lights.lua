--
-- **********************************************************
-- Lights OFF when nobody home
-- **********************************************************
--

	if devicechanged["Personen"] == 'Slapen' and powerFailsave('false')
	then
		switchDevice("Woonkamer_Salon_Tafel", "Off")
		switchDevice("Keuken_Eettafel_Verlichting", "Off")
		switchDevice("Walking_Verlichting", "Off")
		debugLog('Overige verlichting uitgeschakeld, Iedereen slaapt.')
		
	elseif devicechanged["Personen"] == 'Weg' and powerFailsave('false')
	then
		switchDevice("Woonkamer_Salon_Tafel", "Off")
		switchDevice("Keuken_Eettafel_Verlichting", "Off")
		switchDevice("Slaapkamer_Verlichting", "Off")
		switchDevice("Siewert_Nachtlamp", "Off")
		switchDevice("Jerina_Nachtlamp", "Off")
		switchDevice("Walking_Verlichting", "Off")
		debugLog('Overige verlichting uitgeschakeld, Niemand aanwezig.')
	end