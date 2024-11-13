--
-- **********************************************************
-- Quooker ON when some one gets home
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["Quooker_WCD"] == 'Off'
		and powerfailsave("false")
		and uservariables["panic"] == 0	
		and timebetween("04:30:00","22:59:59")		
    then
	
		if phones_online('true') and timebetween("04:30:00","04:59:59") then
		commandArray[#commandArray+1]={["Quooker_WCD"] = "On"}
		end

		if phones_online('false') and timebetween("04:30:00","21:59:59") and p1NetUsageDeliv("2760") >= 1500 then
		commandArray[#commandArray+1]={["Quooker_WCD"] = "On"}
		end		
		
	end
	
--
-- **********************************************************
-- Quooker OFF
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		and solarwinter('false')
		and otherdevices["Quooker_WCD"] == 'On'
		and otherdevices["Thuis"] == 'Off'
		and (timebetween("22:00:00","23:59:59") or timebetween("00:00:00","04:29:59"))
		and powerfailsave("false")
		and uservariables["panic"] == 0	
		and powerusage("Quooker_Huidige_Verbruik") <= 2		
    then
		commandArray[#commandArray+1]={["Quooker_WCD"] = "Off AFTER 60"}
	end
