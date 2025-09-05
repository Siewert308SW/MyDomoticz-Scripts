--
-- **********************************************************
-- Printer ON
-- **********************************************************
--
	if devicechanged["Time Trigger 1min"] == 'On'
		and laptopsOnline('true')
		and otherdevices["Printer_WCD"] == 'Off'
		and timebetween("08:30:00","21:59:59")
		and powerFailsave('false')		
	then
		switchDevice("Printer_WCD", "On")
		--debugLog('Printer_WCD AAN')
	end

--
-- **********************************************************
-- Printer OFF
-- **********************************************************
--

	if devicechanged["Time Trigger 1min"] == 'On'
		and laptopsOnline('false')
		and otherdevices["Printer_WCD"] == 'On'
		and powerFailsave('false')		
	then
		switchDevice("Printer_WCD", "Off")
		--debugLog('Printer_WCD UIT')
	end