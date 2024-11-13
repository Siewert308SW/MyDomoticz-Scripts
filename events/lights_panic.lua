--
-- **********************************************************
-- Panic ON
-- **********************************************************
--

	if (devicechanged["Rookmelder_Woonkamer"]
		or devicechanged["Rookmelder_Hal"]
		or devicechanged["Rookmelder_Overloop"]
		or devicechanged["Rookmelder_Slaapkamer"]
		or devicechanged["Rookmelder_Natalya"]
		or devicechanged["Rookmelder_Garage"]
		or devicechanged["Rookmelder_Zolder"])
		and uservariables["panic"] == 0
	then
		commandArray[#commandArray+1]={["Scene:Paniek WCD OFF"] = "On AFTER 2"}
		commandArray[#commandArray+1]={["Variable:panic"] = "1"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "0"}
		commandArray[#commandArray+1]={["Variable:keuken_verlichting_auto"] = "0"}	
		print('ALARM: Rookmelder afgegaan')
		
		if dark('true', 'inside', 100) and otherdevices["Thuis"] == 'On'
		then
			commandArray[#commandArray+1]={["Scene:Paniek Verlichting"] = "On"}
		end
	end

-- **********************************************************

	if devicechanged["Zolder_Co2_Alarm"]
		and uservariables["panic"] == 0
	then
		commandArray[#commandArray+1]={["Scene:Paniek WCD OFF"] = "On AFTER 2"}
		commandArray[#commandArray+1]={["Variable:panic"] = "1"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "0"}
		commandArray[#commandArray+1]={["Variable:keuken_verlichting_auto"] = "0"}
		print('ALARM: Co2 melder afgegaan')
		
		if dark('true', 'inside', 100) and otherdevices["Thuis"] == 'On'
		then
			commandArray[#commandArray+1]={["Scene:Paniek Verlichting"] = "On"}
		end
	end

--
-- **********************************************************
-- Panic ON
-- **********************************************************
--

	if (devicechanged["Woonkamer_Verlichting UIT"] == 'On' or devicechanged["Garage_Controler_Woonkamer UIT"] == 'On')
		and uservariables["panic"] ~= 0 then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (uit)"] = "On"}
		commandArray[#commandArray+1]={["Scene:Keuken Verlichting (uit)"] = "On"}
		commandArray[#commandArray+1]={["Scene:NonControledOff"] = "On"}
		commandArray[#commandArray+1]={["Scene:Tuin Verlichting OFF"] = "On"}	
		commandArray[#commandArray+1]={["Variable:panic"] = "0"}
		print('ALARM: Reset')
		commandArray['SendNotification'] = "Brandalarm#Alarm is gereset###1;2#fcm"
	end
