--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen"}) then return end

--
-- **********************************************************
-- Standbykillers ON
-- **********************************************************
--

	if (devicechanged["Personen"] == 'Aanwezig')
		and otherdevices["Aanrecht_WCD1"] == 'Off'
		and powerFailsave('false')
	then
	
		switchDevice("Aanrecht_WCD1", "On")
		switchDevice("Afzuigkap_WCD", "On")	 
		switchDevice("TV-Kast_WCD", "On")	 
		switchDevice("Droger_WCD", "On")	 
		switchDevice("Aanrecht_WCD2", "On")
		switchDevice("Stofzuiger_WCD", "On")	 
		switchDevice("Speaker_Keuken_WCD", "On") 
		switchDevice("Woonkamer_Bank_WCD", "On") 
		switchDevice("Woonkamer_Fauteuil_WCD", "On") 
		switchDevice("Voordeur_WCD", "On")	 
		switchDevice("Achterdeur_WCD", "On")
		if otherdevices["Oven_WCD"] == 'Off' then
		switchDevice("Oven_WCD", "On")
		debugLog('Oven was vergeten? Is nu ingeschakeld')		
		end
		debugLog('Standbykillers ingeschakeld')
	end
	
--
-- **********************************************************
-- Standbykillers OFF
-- **********************************************************
--

	if (devicechanged["Personen"] == 'Weg' or devicechanged["Personen"] == 'Slapen')
		and otherdevices["Aanrecht_WCD1"] == 'On'
		and powerFailsave('false')
	then
		switchDevice("Aanrecht_WCD1", "Off")
		switchDevice("Afzuigkap_WCD", "Off")	 
		switchDevice("TV-Kast_WCD", "Off")	 
		switchDevice("Droger_WCD", "Off")	 
		switchDevice("Aanrecht_WCD2", "Off")
		switchDevice("Stofzuiger_WCD", "Off")	 
		switchDevice("Speaker_Keuken_WCD", "Off") 
		switchDevice("Woonkamer_Bank_WCD", "Off") 
		switchDevice("Woonkamer_Fauteuil_WCD", "Off") 
		switchDevice("Voordeur_WCD", "Off")	 
		switchDevice("Achterdeur_WCD", "Off")
		debugLog('Standbykillers uitgeschakeld')
	end