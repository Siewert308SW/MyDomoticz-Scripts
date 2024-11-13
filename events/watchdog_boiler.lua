--
-- **********************************************************
-- Boiler ON Time triggered
-- **********************************************************
--

	if devicechanged["Time Trigger 1min"] == 'On'
		and otherdevices["E-Boiler_WCD"] == 'Off'
		and p1NetUsageDeliv("2760") >= 1
		and timedifference(otherdevices_lastupdate["E-Boiler_WCD"]) >= 3600
		and (timebetween("09:00:00","23:59:59") or timebetween("00:00:00","08:59:59"))
		and powerfailsave("false")
		and uservariables["panic"] == 0
	then

		if p1NetUsageDeliv("2760") >= 2000
			and timedifference(otherdevices_lastupdate["E-Boiler_WCD"]) >= 3600 
		then
			commandArray[#commandArray+1]={["E-Boiler_WCD"] = "On"}
			print("")
			print("-- *********************")
			print("-- Boiler AAN (Zonnestroom)")
			print("-- *********************")
			print("")		
		end

-- **********************************************************
	
		if p1NetUsageDeliv("2760") >= 1
			and timedifference(otherdevices_lastupdate["E-Boiler_WCD"]) >= 57600
		then
			commandArray[#commandArray+1]={["E-Boiler_WCD"] = "On"}
			commandArray[#commandArray+1]={["Variable:Water_Usage_Trigger"] = "0"}
			print("")
			print("-- *********************")
			print("-- Boiler AAN - Tijd 16uur")
			print("-- *********************")
			print("")			
		end
		
-- **********************************************************
		
		if p1NetUsageDeliv("2760") > 1000
			and timebetween("08:00:00","21:59:59")
			and uservariables["Water_Usage_Trigger"] ~= 0
			--and (otherdevices_humidity['Badkamer_Humidity'] > 90 or uservariables["Water_Usage_Trigger"] ~= 0)
			and timedifference(otherdevices_lastupdate["E-Boiler_WCD"]) >= 3600
		then
			commandArray[#commandArray+1]={["E-Boiler_WCD"] = "On"}
			commandArray[#commandArray+1]={["Variable:Water_Usage_Trigger"] = "0"}
				print("")
				print("-- *********************")
				print("-- Boiler AAN - Humidity")
				print("-- *********************")
				print("")
		end

	end

--
-- **********************************************************
-- Boiler OFF
-- **********************************************************
--
	
	if devicechanged["Time Trigger 5min"] == 'Off'
		and solarwinter('false')
		and otherdevices["E-Boiler_WCD"] == 'On'
		and p1NetUsageDeliv("2760") == 0
		and (timebetween("18:00:00","23:59:59") or timebetween("00:00:00","05:59:59"))
		and powerusage("E-Boiler_Huidige_Verbruik") <= 1
		and timedifference(otherdevices_lastupdate["E-Boiler_WCD"]) >= 3600
		and powerfailsave("false")
		and uservariables["panic"] == 0
    then
		commandArray[#commandArray+1]={["E-Boiler_WCD"] = "Off"}
		commandArray[#commandArray+1]={["Variable:Water_Usage_Trigger"] = "0"}
		print("")
		print("-- *********************")
		print("-- Boiler UIT")
		print("-- *********************")
		print("")
	end

