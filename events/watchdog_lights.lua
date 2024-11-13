--
-- **********************************************************
-- Non controled lights OFF when no motion detected for x minutes
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and phones_online('false')
		and otherdevices["Thuis"] == 'Off'
		and motion('false', 300)
		and uservariables["panic"] == 0
		and (otherdevices["Slaapkamer_Verlichting"] == 'On'
		or otherdevices["Siewert_Nachtlamp"] == 'On'
		or otherdevices["Jerina_Nachtlamp"] == 'On'
		or otherdevices["Walking_Verlichting"] == 'On'
		or otherdevices["Keuken_Eettafel_Verlichting"] == 'On'
		or otherdevices["Woonkamer_Stalamp"] == 'On'
		or otherdevices["Woonkamer_Salon Tafel"] == 'On'
		or otherdevices["Badkamer_Verlichting"] =='On' 
		or otherdevices["Badkamer_Spiegel_Spots"] =='On'
		or otherdevices["Natalya_Slaapkamer_Verlichting"] == 'On'
		or otherdevices["Kelder_Verlichting"]  == 'On')
	then
		commandArray[#commandArray+1]={["Scene:NonControledOff"] = "On"}
	end	