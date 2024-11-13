--
-- *********************************************************************
-- Shed light ON
-- *********************************************************************
--

	if devicechanged["Fietsenschuur_Deur"] == 'Open'
		and otherdevices["Fietsenschuur_Verlichting"] == 'Off'
		and timedifference(otherdevices_lastupdate["Fietsenschuur_Verlichting"]) > 1
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Fietsenschuur_Verlichting"] = "On"}
	end
	
--
-- *********************************************************************
-- Shed OFF
-- *********************************************************************
--

	if devicechanged["Fietsenschuur_Deur"] == 'Closed'
		and otherdevices["Fietsenschuur_Verlichting"] == 'On'
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Fietsenschuur_Verlichting"] = "Off"}
	end

	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Fietsenschuur_Verlichting"] ~= 'Off'
		and timedifference(otherdevices_lastupdate["Fietsenschuur_Deur"]) > 900
		and timedifference(otherdevices_lastupdate["Fietsenschuur_Verlichting"]) > 900
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Fietsenschuur_Verlichting"] = "Off"}
	end