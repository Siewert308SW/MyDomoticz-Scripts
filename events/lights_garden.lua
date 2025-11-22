--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 10min"}) then return end
	
--
-- **********************************************************
-- Garden lights ON when LUX is lower then threshold
-- **********************************************************
--
	
	if devicechanged["Time Trigger 10min"] == 'On'
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and otherdevices["Achterdeur_Verlichting"] == 'Off'
		and otherdevices["Brandgang_Verlichting"] == 'Off'
		and otherdevices["Fietsenschuur_Buiten_Verlichting"] == 'Off'
		and otherdevices["Voordeur_WCD"] == 'On'
		and uservariables["tuin_activity"] == 0
		and dark('true', 'garden', 15)
		and timebetween(sunTime("sunsetEarly"),"23:29:59")
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Scene:Tuinverlichting AAN"] = "On"}
		switchDevice("Variable:tuin_verlichting_auto", "1")
	end

--
-- **********************************************************
-- Garden lights OFF when LUX is higher then threshold
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and (otherdevices["Voordeur_Verlichting"] ~= 'Off'
		or otherdevices["Achterdeur_Verlichting"] ~= 'Off'
		or otherdevices["Brandgang_Verlichting"] ~= 'Off'
		or otherdevices["Fietsenschuur_Buiten_Verlichting"] ~= 'Off')
		and uservariables["tuin_activity"] == 0
		and dark('false', 'garden', 15)
		and xmasseason('false')
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Scene:Tuinverlichting UIT"] = "On"}
		switchDevice("Variable:tuin_verlichting_auto", "0")
	end

--
-- **********************************************************
-- Garden light OFF at specific time
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'On'
		and (otherdevices["Voordeur_Verlichting"] ~= 'Off'
		or otherdevices["Achterdeur_Verlichting"] ~= 'Off'
		or otherdevices["Brandgang_Verlichting"] ~= 'Off'
		or otherdevices["Fietsenschuur_Buiten_Verlichting"] ~= 'Off')
		and uservariables["tuin_activity"] == 0
		and motionGarden('false', 1800)
		and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00",sunTime("sunset")))
		and powerFailsave('false')
	then
	
		if weekend('false')
			and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00",sunTime("sunset")))
		then
			commandArray[#commandArray+1]={["Scene:Tuinverlichting UIT"] = "On"}
			switchDevice("Variable:tuin_verlichting_auto", "0")		
		elseif weekend('true')
			and otherdevices["Personen"] ~= 'Aanwezig'
			and timebetween("00:00:00",sunTime("sunset"))
		then
			commandArray[#commandArray+1]={["Scene:Tuinverlichting UIT"] = "On"}
			switchDevice("Variable:tuin_verlichting_auto", "0")
		end
		
	end