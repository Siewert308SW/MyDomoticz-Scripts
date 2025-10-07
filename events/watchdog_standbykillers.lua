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
	
		switchDevice("Aanrecht_WCD1", "On", "delayed")
		switchDevice("Afzuigkap_WCD", "On", "delayed")	 
		switchDevice("TV-Kast_WCD", "On", "delayed")	 
		switchDevice("Droger_WCD", "On", "delayed")	 
		switchDevice("Aanrecht_WCD2", "On", "delayed")
		switchDevice("Stofzuiger_WCD", "On", "delayed")	 
		switchDevice("Speaker_Keuken_WCD", "On", "delayed")
		switchDevice("Woonkamer_Bank_WCD", "On", "delayed") 
		switchDevice("Woonkamer_Fauteuil_WCD", "On", "delayed") 
		switchDevice("Voordeur_WCD", "On", "delayed")	 
		switchDevice("Achterdeur_WCD", "On", "delayed")
		if otherdevices["Oven_WCD"] == 'Off' then
		switchDevice("Oven_WCD", "On", "delayed")
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
		switchDevice("Aanrecht_WCD1", "Off", "delayed")
		switchDevice("Afzuigkap_WCD", "Off", "delayed")	 
		switchDevice("TV-Kast_WCD", "Off", "delayed")	 
		switchDevice("Droger_WCD", "Off", "delayed")	 
		switchDevice("Aanrecht_WCD2", "Off", "delayed")
		switchDevice("Stofzuiger_WCD", "Off", "delayed")	 
		switchDevice("Speaker_Keuken_WCD", "Off", "delayed") 
		switchDevice("Woonkamer_Bank_WCD", "Off", "delayed") 
		switchDevice("Woonkamer_Fauteuil_WCD", "Off", "delayed")
		switchDevice("Voordeur_WCD", "Off", "delayed") 
		switchDevice("Achterdeur_WCD", "Off", "delayed")
		debugLog('Standbykillers uitgeschakeld')
	end