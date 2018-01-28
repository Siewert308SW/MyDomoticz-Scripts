--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_device_main.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ Main event script on which my entire Lua event system is running. 

	Just one file instead of a dozen lua device and timer scripts.
	Which saves a lot of CPU resources and saves memory
	script_device_main.lua is the only lua event script which is called on device change.
	
	script_device_main.lua keeps track on changed devices.
	If a changed device is set in triggers.lua then it may execute a event script.
	This way Domoticz doesn't have to load and seek true all lua scripts all the time.
	I also use a function libary, in this way i can call my functions once only if needed.
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

	local Current_Path = debug.getinfo(1).source:match("@?(.*/)")
	package.path = package.path .. ';' .. Current_Path .. 'config/?.lua'
	require "settings"
	
commandArray = {}

	for deviceName, deviceValue in pairs(devicechanged) do

		for tableName, tableDevice in pairs (triggers) do
			if deviceName == tableDevice then		
				require "functions" require "switches" require "various"
				event_folder = Current_Path .. 'events/'

				f = io.popen('ls ' .. event_folder)
				for event in f:lines() do
					dofile ('' .. event_folder .. ''..event..'')
				end

				f:close()
			end
		end
	
	end

return commandArray
