--
-- **********************************************************
-- Corridor light ON
-- **********************************************************
--

	if devicechanged["Overloop_Deur"] == 'Open'
		and otherdevices["Thuis"] == 'On'
		and otherdevices["Overloop_Verlichting"] == 'Off'
		and otherdevices["Overloop_Motion"] == 'Off'
		and timedifference(otherdevices_lastupdate["Overloop_Verlichting"]) > 5
		and (timebetween("08:00:00","21:59:59") or otherdevices["Jerina_Laptop"] == 'On')
		and (dark('true', 'inside', 10) or dark_specific('true', 10, "Overloop_LUX"))
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Overloop_Verlichting"] = "On"}
	end
	
-- **********************************************************

	if devicechanged["Overloop_Motion"] == 'On' 
		and otherdevices["Thuis"] == 'On' 
		and otherdevices["Overloop_Verlichting"] == 'Off'
		and timebetween("08:00:00","21:59:59")
		and (dark('true', 'inside', 10) or dark_specific('true', 10, "Overloop_LUX"))
		and uservariables["panic"] == 0	
	then
		commandArray[#commandArray+1]={["Overloop_Verlichting"] = "On"}
	end
	
--
-- *********************************************************************
-- Corridor light OFF
-- *********************************************************************
--

	if devicechanged["Time Trigger 1min"]
		and otherdevices["Overloop_Verlichting"] == 'On'
		and otherdevices["Walking_Verlichting"] == 'Off'
		and otherdevices["Badkamer_Verlichting"] == 'Off'
		and otherdevices["Badkamer_Spiegel_Spots"] == 'Off'
		and timedifference(otherdevices_lastupdate["Overloop_Motion"]) > 120
		and timedifference(otherdevices_lastupdate["Overloop_Deur"]) > 120
		and uservariables["panic"] == 0			
	then		
		commandArray[#commandArray+1]={["Overloop_Verlichting"] = "Off"}
	end