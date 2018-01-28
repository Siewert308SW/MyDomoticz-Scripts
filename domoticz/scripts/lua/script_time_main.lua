--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_time_main.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ Script to look up and execute time scripts a specific folder
	@ Scripts are called per your timer settings defined in settings.lua
	@ Rename your script to something like script_2min_test.lua
	@ It doesn't matter where _1min_ is located as long it is there.
	@ _1min_ will execute the script every 1 minute, _5min_ will trigger the script every 5 min.
	@ I use three devices (lux sensors) as timer, only use this script as failsave in case those are offline.
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

	local Current_Path = debug.getinfo(1).source:match("@?(.*/)")
	package.path = package.path .. ';' .. Current_Path .. 'config/?.lua'
	require "settings"
	
	local m = os.date('%M')

--
-- **********************************************************
-- Call Timer Events
-- **********************************************************
--

commandArray = {}

	for tablecol, tablerow in pairs(timers) do

		if (m % tablerow == 0) then
			timers_folder = Current_Path .. 'timers/'	
			f = io.popen('ls ' .. timers_folder)
			for name in f:lines() do
				timer = tostring(tablerow)
				findstring = ''..timer..'min'
				
				if string.find(name, '' .. findstring) then
					require "functions" require "switches"
					dofile ('' .. timers_folder .. ''..name..'')
				end
				
			end				
		end
	end	
f:close()


return commandArray
	