--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_time_main.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-14-2018
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
			
if uservariables[var.lua_error] == 0 and uservariables[var.lua_logging] ~= 5	then		
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
				
---
--
-- **********************************************************
-- Print log 
-- **********************************************************
--
					
					if lua.verbose == 'true' or uservariables[var.lua_logging] >= 1 then

						for CommandArrayName, CommandArrayValue in pairs(commandArray) do	
							Array = ''..CommandArrayName..' = '..CommandArrayValue..''
						end
	
						if Array ~= nil then
						print_color(''..msgcolor.header..'', '==============================================================')
						print ''
						
						print_color(''..msgcolor.triggerTitle..'', 'Trigger:')
						print_color(''..msgcolor.trigger..'', '' .. timers_folder .. ''..name..'')
						print ''
						
						if logmessage ~= nil then
						print_color(''..msgcolor.messageTitle..'', 'Message:')
						print_color(''..msgcolor.message..'', ''..logmessage..'')
						print ''
						end
						
						
--
-- **********************************************************
-- Redundant commands and log message for 433mhz devices 
-- **********************************************************
--
					
					if redundant_array.command == 'true' or uservariables[var.lua_logging] >= 2 then
						if redundant_array.verbose == 'true' then
						print_color(''..msgcolor.redundantarrayTitle..'', 'Redundant:')
						end
						
						for CommandArrayName, CommandArrayValue in pairs(commandArray) do
								for i, v in pairs(otherdevices_idx) do
									if CommandArrayName == i then
							
										HardwareName=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid="..v.."' | grep -w 'HardwareName'  | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
									
										SwitchType=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid="..v.."' | grep -w 'SwitchType'  | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
										
										if HardwareName == 'RFXtrx433E' and (SwitchType == 'On/Off' or SwitchType == 'Dimmer') then
										if redundant_array.verbose == 'true' then
										print_color(''..msgcolor.redundantarray..'',''..CommandArrayName..' is a '..HardwareName..' device, redundant command enabled')
										end
										commandArray[CommandArrayName]=''..CommandArrayValue..' REPEAT '..redundant_array.repeats..' INTERVAL '..redundant_array.interval..''
										
										elseif HardwareName == 'Dummy' and SwitchType == 'On/Off' then
										if redundant_array.verbose == 'true' then
										print_color(''..msgcolor.redundantarray..'',''..CommandArrayName..' is a '..HardwareName..' device, redundant command enabled')
										end
										commandArray[CommandArrayName]=''..CommandArrayValue..' REPEAT '..redundant_array.repeats..' INTERVAL '..redundant_array.interval..''
										else
										if redundant_array.verbose == 'true' then
										print_color(''..msgcolor.redundantarray..'',''..CommandArrayName..' doesnt need a redundant command')
										end									
										end			
									end
								end
							end
						end						
						
						if redundant_array.verbose == 'true' then
						print ''
						end						

						
						print_color(''..msgcolor.commandarrayTitle..'', 'commandArray:')	
						for CommandArrayName, CommandArrayValue in pairs(commandArray) do
						print_color(''..msgcolor.commandarray..'', ''..CommandArrayName..' ==> '..CommandArrayValue..'')
						end
						print ''
						print_color(''..msgcolor.footer..'', '==============================================================')

						end	
					end		
---				
				end
			end
		end
	end
end

return commandArray
	