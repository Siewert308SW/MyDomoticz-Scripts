--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_time_main.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-10-2018
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
	require "settings" require "functions" require "switches" require "helper"
	
	local m = os.date('%M')

--
-- **********************************************************
-- Call Timer Events
-- **********************************************************
--

commandArray = {}
if validate() then -- Function call to check predefined devices in switches.lua, if nil then halt events
			if uservariables[var.lua_error] == 1 then
			print_color(''..errorcolor.header..'', '==============================================================')
			print_color(''..errorcolor.title..'', 'Message:')
			print_color(''..errorcolor.message..'', '==> All Event scripts enabled')			
			print_color(''..errorcolor.footer..'', '==============================================================')			
			commandArray["Variable:" .. var.lua_error .. ""]= '0'
			end
	for tablecol, tablerow in pairs(timers) do

		if (m % tablerow == 0) then
			timers_folder = Current_Path .. 'timers/'	
			f = io.popen('ls ' .. timers_folder)
			for name in f:lines() do
				timer = tostring(tablerow)
				findstring = ''..timer..'min'
				
				if string.find(name, '' .. findstring) then
					
					dofile ('' .. timers_folder .. ''..name..'')
				end
				
			end				
		end
	end
end

return commandArray
	