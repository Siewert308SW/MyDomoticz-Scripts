--
-- **********************************************************
-- Current_Path and Lua extension config/variables
-- **********************************************************
--

	Current_Path = debug.getinfo(1).source:match("@?(.*/)")
	package.path = package.path .. ';' .. Current_Path .. 'config/?.lua'
	event_folder = Current_Path .. 'events/'
	require "triggers"
	
commandArray = {}

-- **********************************************************
-- Globals / Debug vars
-- **********************************************************
	IsTrigger     = false
	deviceName    = nil
	deviceValue   = nil
	triggerDevice = nil
	triggerValue  = nil
	message 	  = nil
	
--
-- **********************************************************
-- Check if predefined trigger changed status
-- **********************************************************
--
	
	for dName, dValue in pairs(devicechanged) do
		for tName, tDevice in pairs(triggers) do
			if dName == tDevice then
				IsTrigger     = true
				deviceName    = dName
				triggerDevice = tDevice
				triggerValue  = dValue
				break
			end
		end
	end

--
-- **********************************************************
-- Call Lua scripts if predefined trigger changed status
-- **********************************************************
--

	if IsTrigger == true then
		require "config"
		require "functions"
		
			f = io.popen('ls ' .. event_folder)
			for event in f:lines() do
				dofile ('' .. event_folder .. ''..event..'')
			end

			if message ~= nil then
				debugLog(message)
			end
			
	end			

return commandArray
