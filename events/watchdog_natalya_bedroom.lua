--
-- **********************************************************
-- Natalya Bedroom WCD ON
-- **********************************************************
--

	if devicechanged["Garage Temp Trigger"] == 'On'
		and otherdevices["Natalya_GSM"] == 'On'	
		and otherdevices["Natalya_WCD_1"] == 'Off'	
		and powerfailsave("false")
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Natalya_WCD_1"] = "On"}
	end

--
-- **********************************************************
-- Natalya Bedroom WCD OFF
-- **********************************************************
--

	if devicechanged["Garage Temp Trigger"] == 'Off'
		and otherdevices["Natalya_GSM"] == 'Off'
		and otherdevices["Natalya_WCD_1"] == 'On'
		and timedifference(otherdevices_lastupdate["Natalya_GSM"]) >= 300
		and powerfailsave("false")
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Natalya_WCD_1"] = "Off"}
	end
	
