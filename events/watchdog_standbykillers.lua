--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Personen", "Time Trigger 10min"}) then return end

--
-- **********************************************************
-- Standbykillers ON
-- **********************************************************
--

	if (devicechanged["Personen"] == 'Aanwezig')
		--and otherdevices["Aanrecht_WCD1"] == 'Off'
		and otherdevices["Aanrecht_WCD2"] == 'Off'
		and otherdevices["Afzuigkap_WCD"] == 'Off'
		and otherdevices["TV-Kast_WCD"] == 'Off'
		and otherdevices["Droger_WCD"] == 'Off'
		and otherdevices["Stofzuiger_WCD"] == 'Off'
		and otherdevices["Speaker_Keuken_WCD"] == 'Off'
		and otherdevices["Woonkamer_Bank_WCD"] == 'Off'
		and otherdevices["Woonkamer_Fauteuil_WCD"] == 'Off'
		--and otherdevices["Voordeur_WCD"] == 'Off'
		and otherdevices["Achterdeur_WCD"] == 'Off'
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Scene:Standbykillers AAN"] = "On"}
		
		if otherdevices["Oven_WCD"] == 'Off' then
		switchDevice("Oven_WCD", "On", "delayed")
		debugLog('Oven was vergeten? Is nu ingeschakeld')		
		end
		
		if otherdevices["Voordeur_WCD"] == 'Off' and xmasseason('false') then
		switchDevice("Voordeur_WCD", "On", "delayed")		
		end
		
		debugLog('Standbykillers ingeschakeld')
	end
	
--
-- **********************************************************
-- Standbykillers OFF
-- **********************************************************
--

	if (devicechanged["Personen"] == 'Weg' or devicechanged["Personen"] == 'Slapen' or devicechanged["Time Trigger 10min"] == 'On') then

		if (otherdevices["Personen"] == 'Weg' or otherdevices["Personen"] == 'Slapen')
			--and (otherdevices["Aanrecht_WCD1"] == 'On'
			and (otherdevices["Aanrecht_WCD2"] == 'On'
			or otherdevices["Afzuigkap_WCD"] == 'On'
			or otherdevices["TV-Kast_WCD"] == 'On'
			or otherdevices["Droger_WCD"] == 'On'
			or otherdevices["Stofzuiger_WCD"] == 'On'
			or otherdevices["Speaker_Keuken_WCD"] == 'On'
			or otherdevices["Woonkamer_Bank_WCD"] == 'On'
			or otherdevices["Woonkamer_Fauteuil_WCD"] == 'On'
			--or otherdevices["Voordeur_WCD"] == 'On'
			or otherdevices["Achterdeur_WCD"] == 'On')
			and powerFailsave('false')
		then
			commandArray[#commandArray+1]={["Scene:Standbykillers UIT"] = "On"}
			
			if otherdevices["Oven_WCD"] == 'On' and sensorValue('Oven_Huidige_Verbruik') >= 100 then
			switchDevice("Oven_WCD", "Off")
			debugLog('Oven vergeten? Is nu uitgeschakeld')		
			end
			
			if otherdevices["Voordeur_WCD"] == 'On' and xmasseason('false') then
			switchDevice("Voordeur_WCD", "Off", "delayed")		
			end
		
			debugLog('Standbykillers uitgeschakeld')
		end
		
	end