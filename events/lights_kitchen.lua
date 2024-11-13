--
-- **********************************************************
-- Kitchen lights ON when some one gets home
-- **********************************************************
--

	if devicechanged["Thuis"] == 'On' and uservariables["keuken_verlichting_auto"] == 0 then

		if dark('true', 'inside', 5500)
			and dark('false', 'inside', 15)
			and uservariables["panic"] == 0		
		then
			commandArray[#commandArray+1]={["Scene:Keuken Verlichting (dag)"] = "On"}
			kitchen_spots_test('On', 40)
			commandArray["Variable:keuken_verlichting_auto"] = '1'
		end

	-- **********************************************************
		
		if dark('true', 'inside', 5500)
			and dark('true', 'inside', 15)
			--and (timebetween("08:30:00","23:59:59") or timebetween("00:00:00","00:59:59")) 
			and uservariables["panic"] == 0		
		then
			commandArray[#commandArray+1]={["Scene:Keuken Verlichting (avond)"] = "On"}
			kitchen_spots_test('On', 40)
			commandArray["Variable:keuken_verlichting_auto"] = '2'
		end
--[[		
	-- **********************************************************
		
		if dark('true', 'inside', 5500)
			and dark('true', 'inside', 15)
			and timebetween("01:00:00","08:29:59")
			and uservariables["panic"] == 0		
		then
			commandArray[#commandArray+1]={["Scene:Keuken Verlichting (dag)"] = "On"}
			--kitchen_spots_test('On', 10)
			commandArray["Variable:keuken_verlichting_auto"] = '2'
		end	
--]]	
	end
	
--
-- **********************************************************
-- 
-- **********************************************************
--

	if devicechanged["Thuis"] == 'Off'
		and uservariables["keuken_verlichting_auto"] ~= 0
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Keuken Verlichting OFF"] = "On"}
		commandArray["Variable:keuken_verlichting_auto"] = '0'
		commandArray["Fail Trigger Keuken"] = 'Off'
	end
	
--
-- **********************************************************
-- Kitchen light failsave
-- **********************************************************
--

	if devicechanged["Lux Time Trigger"] == 'Off'
		and otherdevices["Thuis"] == 'On'
		and otherdevices["Fail Trigger Keuken"] == 'Off'
		and uservariables["keuken_verlichting_auto"] == 2
		and uservariables["panic"] == 0
	then
		commandArray[#commandArray+1]={["Fail Trigger Keuken"] = "On"}
		if powerusage("Keukenplint_Huidige_Verbruik") > 13.0 then 
		commandArray["Keukenplint_Verlichting"] = 'Off'
		end
	end
	
--
-- **********************************************************
-- Kitchen lights ON when lux is lower then threshold
-- **********************************************************
--

if devicechanged["Lux Time Trigger"] == 'Off' and uservariables["keuken_verlichting_auto"] ~= 2 then

	if otherdevices["Thuis"] == 'On'
		and uservariables["manual_light"] == 0
		and uservariables["keuken_verlichting_auto"] == 0
		and dark('true', 'inside', 5500)
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Keuken Verlichting (dag)"] = "On"}
		if otherdevices["Keuken_Spots"] == 'Off' then
		kitchen_spots_test('On', 40)
		end
		commandArray["Variable:keuken_verlichting_auto"] = '1'
	end

-- **********************************************************

	if otherdevices["Thuis"] == 'On'
		and uservariables["manual_light"] == 0
		and uservariables["keuken_verlichting_auto"] == 1
		and uservariables["woonkamer_verlichting_auto"] ~= 0
		and dark('true', 'inside', 5500)
		and dark('true', 'inside', 15)
		and (timebetween("15:30:00","23:59:59") or timebetween("00:00:00","01:00:00"))
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Keuken Verlichting (avond)"] = "On"}
		if otherdevices["Keuken_Spots"] == 'Off' then
		kitchen_spots_test('On', 40)
		end
		commandArray["Variable:keuken_verlichting_auto"] = '2'
	end

end
	
--
-- **********************************************************
-- Kitchen lights OFF when lux is higher then threshold
-- **********************************************************
--

if devicechanged["Lux Time Trigger"] == 'Off' and uservariables["keuken_verlichting_auto"] ~= 0 then

	if otherdevices["Thuis"] == 'On'
		and uservariables["keuken_verlichting_auto"] == 1
		and dark('false', 'inside', 5500)
		and dark('false', 'inside', 15)
		and hood_usage('false')
		and timedifference(otherdevices_lastupdate["Keuken_Motion"]) > 120
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Keuken Verlichting (uit)"] = "On"}
		commandArray["Variable:keuken_verlichting_auto"] = '0'
		commandArray["Fail Trigger Keuken"] = 'Off'
	end
	
-- **********************************************************
	
	if otherdevices["Thuis"] == 'On'
		and uservariables["keuken_verlichting_auto"] == 2
		and dark('true', 'inside', 5500)
		and dark('false', 'inside', 15)
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Scene:Keuken Verlichting (dag)"] = "On"}
		kitchen_spots_test('On', 40)
		commandArray["Variable:keuken_verlichting_auto"] = '1'
		commandArray["Fail Trigger Keuken"] = 'Off'
	end

end

		
--
-- **********************************************************
-- 
-- **********************************************************
--

	if (devicechanged["Woonkamer_Verlichting AAN"] == 'On' or devicechanged["Garage_Controler_Woonkamer AAN"] == 'On') and uservariables["panic"] == 0 then
		commandArray[#commandArray+1]={["Scene:Keuken Verlichting (avond)"] = "On"}
		kitchen_spots_test('On', 40)		
		commandArray["Variable:keuken_verlichting_auto"] = '2'
		commandArray[#commandArray+1]={["Fail Trigger Keuken"] = "Off"}
	end
		
	if (devicechanged["Woonkamer_Verlichting UIT"] == 'On' or devicechanged["Garage_Controler_Woonkamer UIT"] == 'On') and uservariables["panic"] == 0 then
		commandArray[#commandArray+1]={["Scene:Keuken Verlichting OFF"] = "On"}
		commandArray["Variable:keuken_verlichting_auto"] = '0'	
		commandArray["Fail Trigger Keuken"] = 'Off'
	end
	
--
-- **********************************************************
-- 
-- **********************************************************
--
	
	if devicechanged["Keuken_Spots AAN"]
		and otherdevices["Keuken_Spots"] == 'Off'
    then
		commandArray["Keuken_Spots"]='On'
	end
	
	if devicechanged["Keuken_Spots AAN"]
		and otherdevices["Keuken_Spots"] ~= 'Off'
    then
		kitchen_spots_steps('On')
	end