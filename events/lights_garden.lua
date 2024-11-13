--
-- **********************************************************
-- Garden lights ON when LUX is lower then threshold
-- **********************************************************
--

	if devicechanged["Lux Time Trigger"] == 'Off'
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and uservariables["tuin_activity"] == 0
		and dark('true', 'outside', 10)
		and timebetween("16:00:00","22:59:59")
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Tuin Verlichting ON"] = "On"}
		if lichtweek('true') and otherdevices["Voordeur_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "On AFTER 30"}
		commandArray[#commandArray+1]={["Achterdeur_WCD"] = "On AFTER 31"}
		end
	end
	
	if devicechanged["Lux Time Trigger"] == 'On'
		and otherdevices["Voordeur_WCD"] == 'Off'
		and lichtweek('true')
		and uservariables["tuin_activity"] == 0
		and dark('true', 'outside', 100)
		and timebetween("16:00:00","22:59:59")
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "On AFTER 30"}
		commandArray[#commandArray+1]={["Achterdeur_WCD"] = "On AFTER 31"}
	end

--
-- **********************************************************
-- Garden lights OFF when LUX is higher then threshold
-- **********************************************************
--

	if devicechanged["Lux Time Trigger"] == 'On'
		and otherdevices["Voordeur_Verlichting"] ~= 'Off'
		and uservariables["tuin_activity"] == 0
		and dark('false', 'outside', 10)
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Tuin Verlichting OFF"] = "On"}
		if lichtweek('true') and otherdevices["Voordeur_WCD"] == 'On' then
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "Off AFTER 30"}
		commandArray[#commandArray+1]={["Achterdeur_WCD"] = "Off AFTER 31"}
		end
	end

--
-- **********************************************************
-- Garden light OFF at specific time
-- **********************************************************
--

	if devicechanged["Lux Time Trigger"] == 'Off'
		and otherdevices["Thuis"] == 'Off'
		and otherdevices["Voordeur_Verlichting"] ~= 'Off' 
		and uservariables["tuin_activity"] == 0
		and otherdevices["Voor_Deur"] == 'Closed'
		and otherdevices["Achter_Deur"] == 'Closed'
		and otherdevices["Garage_Deur"] == 'Closed'
		and garden_motion('false', 600)
		and uservariables["panic"] == 0	
		and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00","15:59:59"))
	then
		commandArray[#commandArray+1]={["Scene:Tuin Verlichting OFF"] = "On"}
		if lichtweek('true') and otherdevices["Voordeur_WCD"] == 'On' then
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "Off AFTER 30"}
		commandArray[#commandArray+1]={["Achterdeur_WCD"] = "Off AFTER 31"}
		end
	end

