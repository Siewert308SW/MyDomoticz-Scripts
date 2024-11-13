--
-- **********************************************************
-- Hallway light ON
-- **********************************************************
--

	if (devicechanged["Voor_Deur"] == 'Open' or devicechanged["Hal_Deur"] == 'Open')
		and otherdevices["Hal_Verlichting"] == 'Off'
		and otherdevices["Hal_Motion"] == 'Off'
		and timedifference(otherdevices_lastupdate["Hal_Motion"]) > 30
		and dark('true', 'inside', 10)
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Hal_Verlichting"] = 'On'}
	end

-- **********************************************************

	if devicechanged["Hal_Motion"] == 'On'
		and otherdevices["Hal_Verlichting"] == 'Off'
		and otherdevices["Thuis"] == 'On'
		and dark('true', 'inside', 10)
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Hal_Verlichting"] = "On"}
	end
	
--
-- **********************************************************
-- Hallway Light OFF
-- **********************************************************
--

	if devicechanged["Time Trigger 1min"]
		and otherdevices["Hal_Verlichting"] == 'On'
		and otherdevices["Voor_Deur"] == 'Closed'
		and otherdevices["Hal_Deur"] == 'Closed'
		and otherdevices["Hal_Motion"] == 'Off'
		and timedifference(otherdevices_lastupdate["Hal_Motion"]) > 90
		and timedifference(otherdevices_lastupdate["Hal_Deur"]) > 90
		and timedifference(otherdevices_lastupdate["Voor_Deur"]) > 90
		and timedifference(otherdevices_lastupdate["Hal_Verlichting"]) > 90
		and uservariables["panic"] == 0			
	then
		commandArray[#commandArray+1]={["Hal_Verlichting"] = "Off"}
	end	