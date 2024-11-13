--
-- **********************************************************
-- Laptops ON
-- **********************************************************
--
	if devicechanged["Time Trigger 1min"]
		and laptops_online('true')
		and otherdevices["Printer_WCD"] == 'Off'
		and timebetween("08:30:00","21:59:59")
		and powerfailsave("false")
		and uservariables["panic"] == 0			
	then
		commandArray[#commandArray+1]={["Printer_WCD"] = "On"}
		--commandArray[#commandArray+1]={["Opslag_NAS WOL"] = "On"}
	end

--
-- **********************************************************
-- Laptops OFF
-- **********************************************************
--

	if devicechanged["Time Trigger 1min"]
		and laptops_online('false')
		and otherdevices["Printer_WCD"] == 'On'
		and powerfailsave("false")
		and uservariables["panic"] == 0			
	then
		commandArray[#commandArray+1]={["Printer_WCD"] = "Off"}
	end