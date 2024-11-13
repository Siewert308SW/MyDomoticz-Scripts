--
-- **********************************************************
-- Pantry light ON when door Open
-- **********************************************************
--

	if devicechanged["Kelder_Deur"] == 'Open'
		and otherdevices["Kelder_Verlichting"]  == 'Off'
		and otherdevices["Thuis"] == 'On'		
		and uservariables["panic"] == 0			
	then		
		commandArray[#commandArray+1]={["Kelder_Verlichting"] = "On"}
	end

--
-- **********************************************************
-- Pantry light OFF when door Closed
-- **********************************************************
--

	if devicechanged["Kelder_Deur"] == 'Closed'
		and otherdevices["Kelder_Verlichting"]  == 'On'	
		and uservariables["panic"] == 0			
	then		
		commandArray[#commandArray+1]={["Kelder_Verlichting"] = "Off"}
	end
	
