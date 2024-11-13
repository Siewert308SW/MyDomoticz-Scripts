--
-- **********************************************************
-- Living lights ON when lux is lower then threshold
-- **********************************************************
--

	if devicechanged["Lux Time Trigger"] == 'Off'
		and phones_online('false')
		and otherdevices["Thuis"] == 'Off'
		and dark('true', 'inside', 35)
		and uservariables["manual_light"] == 0
		and uservariables["woonkamer_verlichting_auto"] == 0
		and timebetween("20:30:00","22:59:59")
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Away ON"] = "On"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "3"}
	end
	
--
-- **********************************************************
-- Living lights OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged["Lux Time Trigger"] == 'Off'
		and otherdevices["Thuis"] == 'Off'
		and dark('false', 'inside', 35)
		and uservariables["woonkamer_verlichting_auto"] == 3
		and uservariables["manual_light"] == 0
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Away OFF"] = "On"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "0"}
	end

--
-- **********************************************************
-- Living lights OFF at specific time
-- **********************************************************
--

if devicechanged["Lux Time Trigger"] == 'On' and otherdevices["Thuis"] == 'Off' and uservariables["woonkamer_verlichting_auto"] == 3 and uservariables["tuin_activity"] == 0 and (timebetween("23:00:00","23:59:59") or timebetween("00:00:00","11:29:59")) then

	if weekend("false")
		and (timebetween("23:00:00","23:59:59") or timebetween("00:00:00","11:59:59"))
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Away OFF"] = "On"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "0"}
	end
		
	if weekend("true")
		and (timebetween("23:45:00","23:59:59") or timebetween("00:00:00","11:59:59"))
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Away OFF"] = "On"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "0"}
	end

end