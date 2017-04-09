--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_time_main.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-4-2016
	@ Main timer script on which the entire Lua timer system is running. 
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
	require "settings" require "functions"
	
--
-- **********************************************************
-- Container Settings End
-- **********************************************************
--

commandArray = {}
IsTimerEvent()
return commandArray
	