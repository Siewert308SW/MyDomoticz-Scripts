--
-- **********************************************************
-- Living lights ON when some one gets home
-- **********************************************************
--

	--if devicechanged["Thuis"] == 'On'
	--	and dark('false', 'inside', 175)
	--	and dark('false', 'inside', 50)
	--	and uservariables["panic"] == 0	
	--then
		--commandArray[#commandArray+1]={["Scene:Keuken Verlichting (dag)"] = "On AFTER 2"}
		--kitchen_spots('On', 10)
		--commandArray[#commandArray+1]={["Fail Trigger Keuken"] = "Off"}
	--end

-- **********************************************************
	
	if devicechanged["Thuis"] == 'On'
		and dark('true', 'inside', 200)
		and dark('false', 'inside', 50)
		and uservariables["panic"] == 0	
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (dag)"] = "On AFTER 5"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "1"}
	end

-- **********************************************************

	if devicechanged["Thuis"] == 'On'
		and dark('true', 'inside', 200)
		and dark('true', 'inside', 50)
		and uservariables["panic"] == 0	
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (avond)"] = "On AFTER 5"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "2"}
	end

--
-- **********************************************************
-- Living lights OFF when nobody home
-- **********************************************************
--

	if devicechanged["Thuis"] == 'Off'
		and uservariables["panic"] == 0		
		--and (uservariables["manual_light"] ~= 0 or uservariables["woonkamer_verlichting_auto"] ~= 0)
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (uit)"] = "On AFTER 5"}
		commandArray[#commandArray+1]={["Variable:manual_light"] = "0"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "0"}
	end
	
--
-- **********************************************************
-- Living lights ON when lux is lower then threshold
-- **********************************************************
--

if devicechanged["Lux Time Trigger"] == 'On' and otherdevices["Thuis"] == 'On' and dark('true', 'inside', 200) then

	if otherdevices["Thuis"] == 'On'
		and dark('true', 'inside', 200)
		and uservariables["manual_light"] == 0
		and uservariables["woonkamer_verlichting_auto"] == 0
		and timebetween("15:30:00","23:59:59")
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (dag)"] = "On AFTER 5"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "1"}
	end

-- **********************************************************
	
	if otherdevices["Thuis"] == 'On'
		and dark('true', 'inside', 200)
		and dark('true', 'inside', 50)
		and uservariables["manual_light"] == 0
		and uservariables["woonkamer_verlichting_auto"] == 1
		and timebetween("15:30:00","23:59:59")
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (avond)"] = "On AFTER 5"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "2"}
	end

end
	
--
-- **********************************************************
-- Living lights OFF when lux is higher then threshold
-- **********************************************************
--

if devicechanged["Lux Time Trigger"] == 'Off' and otherdevices["Thuis"] == 'On' --[[and dark('false', 'inside', 200)--]] then

	if otherdevices["Thuis"] == 'On'
		and dark('false', 'inside', 200)
		and dark('false', 'inside', 50)
		and uservariables["woonkamer_verlichting_auto"] ~= 0
		and uservariables["manual_light"] == 0
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (uit)"] = "On AFTER 5"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "0"}
	end

-- **********************************************************	

	if otherdevices["Thuis"] == 'On'
		and uservariables["woonkamer_verlichting_auto"] == 2
		and uservariables["manual_light"] == 0
		and dark('true', 'inside', 200)
		and dark('false', 'inside', 15)
		and uservariables["panic"] == 0
		and timebetween("00:00:00","15:29:59")		
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (dag)"] = "On AFTER 5"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "1"}
	end
	
-- **********************************************************	

	if otherdevices["Thuis"] == 'On'
		and uservariables["woonkamer_verlichting_auto"] == 2
		and uservariables["manual_light"] == 0
		and dark('true', 'inside', 200)
		and dark('false', 'inside', 50)
		and uservariables["panic"] == 0
		and timebetween("15:30:00","23:59:59")		
	then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (dag)"] = "On AFTER 5"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "1"}
	end

end

--
-- **********************************************************
-- What to do when lights are manualy toggled
-- **********************************************************
--

	if (devicechanged["Woonkamer_Verlichting AAN"] == 'On' or devicechanged["Garage_Controler_Woonkamer AAN"] == 'On') and uservariables["panic"] == 0 then
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (avond)"] = "On"}
		commandArray[#commandArray+1]={["Variable:manual_light"] = "2"}
		--commandArray[#commandArray+1]={["CatFlap"] = "On"}
	end

-- **********************************************************
		
	if (devicechanged["Woonkamer_Verlichting UIT"] == 'On' or devicechanged["Garage_Controler_Woonkamer UIT"] == 'On') and uservariables["panic"] == 0 then	
		commandArray[#commandArray+1]={["Scene:Woonkamer Verlichting (uit)"] = "On"}
		commandArray[#commandArray+1]={["Variable:woonkamer_verlichting_auto"] = "0"}
		--commandArray[#commandArray+1]={["CatFlap"] = "Off"}
		if dark('true', 'inside', 200) then
		commandArray[#commandArray+1]={["Variable:manual_light"] = "1"}
		end

	end