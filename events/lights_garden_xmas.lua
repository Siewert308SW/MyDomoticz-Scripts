--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 10min"}) then return end
	
--
-- **********************************************************
-- XMAS Garden lights ON when LUX is lower then threshold
-- **********************************************************
--
	
	if devicechanged["Time Trigger 10min"] == 'Off'
		and xmasseason('true')
		and otherdevices["Voordeur_WCD"] == 'Off'
		and dark('true', 'garden', 25)
		and timebetween(sunTime("sunsetEarly"),"23:29:59")
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "On"}
	end

--
-- **********************************************************
-- XMAS Garden light OFF at specific time
-- **********************************************************
--

	if devicechanged["Time Trigger 10min"] == 'Off'
		and xmasseason('true')
		and otherdevices["Voordeur_WCD"] == 'On'
		and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00",sunTime("sunset")))
		and powerFailsave('false')
	then
	
		if weekend('false')
			and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00",sunTime("sunset")))
		then
			commandArray[#commandArray+1]={["Voordeur_WCD"] = "Off"}
			
		elseif weekend('true')
			and otherdevices["Personen"] ~= 'Aanwezig'
			and timebetween("00:00:00",sunTime("sunset"))
		then
			commandArray[#commandArray+1]={["Voordeur_WCD"] = "Off"}
		end
		
	end