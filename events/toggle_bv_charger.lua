--
-- **********************************************************
-- BV Charger OFF
-- **********************************************************
--
 
	if devicechanged["Time Trigger 5min"] == 'On'
		and otherdevices["BV_Charger_WCD"] == 'On'
		and powerusage("BV_Charger_Huidige_Verbruik") <= 25
		and timedifference(otherdevices_lastupdate["BV_Charger_WCD"]) >= 10800
		and powerfailsave("false")
		and uservariables["panic"] == 0
    then
		if uservariables["bvcharger_override"] == 1
			and timedifference(uservariables_lastupdate["bvcharger_override"]) >= 10800
			and timedifference(otherdevices_lastupdate["BV_Charger_WCD"]) >= 10800
		then
			commandArray[#commandArray+1]={["BV_Charger_WCD"] = "Off"}
			commandArray[#commandArray+1]={["Variable:bvcharger_override"] = "0"}
		end
----------------------------------------------------------------------------------------------------
		if uservariables["bvcharger_override"] == 0
			and timedifference(uservariables_lastupdate["bvcharger_override"]) >= 10800
			and timedifference(otherdevices_lastupdate["BV_Charger_WCD"]) >= 10800
		then
			commandArray[#commandArray+1]={["BV_Charger_WCD"] = "Off"}
			commandArray[#commandArray+1]={["Variable:bvcharger_override"] = "0"}
		end
	end