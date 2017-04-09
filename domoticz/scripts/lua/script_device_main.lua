--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_device_main.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-4-2017
	@ Main device event script on which the entire Lua event system is running. 
	@ Just one file instead of a dozen lua scripts which doesn't eat CPU resources and saves memory
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Container Settings Begin
-- **********************************************************
--

	local Package_Path = debug.getinfo(1).source:match("@?(.*/)")
	package.path = package.path .. ';' .. Package_Path .. '?.lua'
	package.path = package.path .. ';' .. Package_Path .. 'config/?.lua'
    require "settings" require "triggers"

--
-- **********************************************************
-- Container Settings End
-- **********************************************************
--	

commandArray = {}
	for deviceName, deviceValue in pairs(devicechanged) do
		for tableName, tableDevice in pairs (trigger) do
			if deviceName == tableDevice then
			require "functions"				
			IsEvent()
			end
		end
	end
	
--
-- **********************************************************
-- Timed Triggers
-- **********************************************************
-- to do, create a function for timed scripts
	
	if (time.hour == 22) and (time.min == 45) then
		dofile(lua.events.."lights_garden.lua")		
	end
	
	if (time.hour == 23) and (time.min == 00) then
		dofile(lua.events.."lights_livingroom_away.lua")		
	end

	if (time.hour == 23) and (time.min == 01) then	
		dofile(lua.events.."lights_garden.lua")		
	end	
	
	if (time.hour == 23) and (time.min == 45) then
		dofile(lua.events.."lights_livingroom_away.lua")
	end
	
	if (time.hour == 23) and (time.min == 59) then	
		dofile(lua.events.."lights_garden.lua")		
	end			


return commandArray