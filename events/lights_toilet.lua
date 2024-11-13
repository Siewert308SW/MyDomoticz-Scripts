--
-- *********************************************************************
-- Toilet light ON when motion detection
-- *********************************************************************
--

	if devicechanged["Toilet_Motion"] == 'On'
		and otherdevices["Toilet_Verlichting"] == 'Off'
		and phones_online('true')
		and timedifference(otherdevices_lastupdate["Toilet_Verlichting"]) > 10
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Toilet_Verlichting"] = "On"}
	end
	
--
-- *********************************************************************
-- Toilet light OFF after X minutes when no motion detected
-- *********************************************************************
--

	if devicechanged["Time Trigger 1min"]
		and otherdevices["Toilet_Verlichting"] == 'On'
		and otherdevices["Toilet_Motion"] == 'Off'
		and timedifference(otherdevices_lastupdate["Toilet_Motion"]) > 240
		and timedifference(otherdevices_lastupdate["Toilet_Verlichting"]) > 240
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Toilet_Verlichting"] = "Off"}
	end