--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_device_main.lua
	@ author	: Siewert Lameijer
	@ since		: 01-01-2015
	@ Main event script on which my entire Lua event system is running. 

	Just one file instead of a dozen lua device and timer scripts.
	Which saves a lot of CPU resources and saves memory
	script_device_main.lua is the only lua event script which is called when a device changed.
	
	script_device_main.lua keeps track on changed devices.
	If a changed device is set in triggers.lua then it may execute a event script.
	This way Domoticz doesn't have to load and seek true all lua scripts all the time.
	I also use a function library, in this way i can call my functions once only if needed.

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Current_Path and Lua extension config/variables
-- **********************************************************
--

Current_Path = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. Current_Path .. 'config/?.lua'
require "triggers"
	
commandArray = {}

--
-- **********************************************************
-- Check if predefined trigger changed status
-- **********************************************************
--

	IsTrigger = false
	
	for deviceName, deviceValue in pairs(devicechanged) do
		for triggerName, triggerDevice in pairs (triggers) do		

			if deviceName == triggerDevice then
				IsTrigger = true
			end
			
		end
	end

--
-- **********************************************************
-- Call a event Lua script if predefined trigger changed status
-- **********************************************************
--

	if IsTrigger == true then
		require "functions"
					
		event_folder = Current_Path .. 'events/'
			f = io.popen('ls ' .. event_folder)
			for event in f:lines() do
				dofile ('' .. event_folder .. ''..event..'')
			end
								
	end
	
--
-- **********************************************************
-- End of Lua 
-- **********************************************************
--			

return commandArray
