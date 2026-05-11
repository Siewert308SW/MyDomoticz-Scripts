--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 1min"}) then return end

--
-- **********************************************************
-- Printer ON
-- **********************************************************
--
	if devicechanged["Time Trigger 1min"] == 'On'
		and otherdevices["Printer_WCD"] == 'Off'
		and laptopsOnline('true', 'all')
		and timebetween("08:30:00","21:59:59")
		and powerFailsave('false')		
	then
		switchDevice("Printer_WCD", "On")
		debugLog('Printer_WCD AAN')
	end

--
-- **********************************************************
-- Printer OFF
-- **********************************************************
--

	if devicechanged["Time Trigger 1min"] == 'On'
		and otherdevices["Printer_WCD"] == 'On'
		and laptopsOnline('false', 'all')
		and powerFailsave('false')		
	then
		switchDevice("Printer_WCD", "Off")
		debugLog('Printer_WCD UIT')
	end