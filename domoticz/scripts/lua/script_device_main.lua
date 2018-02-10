--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_device_main.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-10-2018
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

--
-- **********************************************************
-- Call any device event if predefined trigger changed status
-- **********************************************************
--

	for deviceName, deviceValue in pairs(devicechanged) do
		if uservariables["lua_error"] == 0 then -- If predefined devices in switches.lua are missing then events will halt
			for tableName, tableDevice in pairs (triggers) do
				if deviceName == tableDevice then		
					require "functions" require "switches" require "various"
					event_folder = Current_Path .. 'events/'

					f = io.popen('ls ' .. event_folder)
					for event in f:lines() do
						dofile ('' .. event_folder .. ''..event..'')
					end
					
--
-- **********************************************************
-- Print log 
-- **********************************************************
--
					
					if lua.verbose == 'true' then

						for CommandArrayName, CommandArrayValue in pairs(commandArray) do	
							Array = ''..CommandArrayName..' = '..CommandArrayValue..''
						end
	
						if deviceName == "Woonkamer - Lux" then
						TriggerDevice = '3 minutes time trigger'
						elseif deviceName == "Overloop - Lux" then
						TriggerDevice = '5 minutes time trigger'	
						elseif deviceName == "Gang - Lux" then
						TriggerDevice = '10 minutes time trigger'
						elseif deviceName == "Gang - Lux" then
						TriggerDevice = '10 minutes time trigger'	
						else

						doorstring = 'Deur'
						motionstring = 'Motion'
						
						if string.find(deviceName, '' .. doorstring) then
							
						TriggerDevice = ''..deviceName..' has been '..deviceValue..''

						elseif string.find(deviceName, '' .. motionstring) and deviceValue == 'On' then
							
						TriggerDevice = ''..deviceName..' detected motion'
						
						elseif string.find(deviceName, '' .. motionstring) and deviceValue == 'Off' then
							
						TriggerDevice = ''..deviceName..' didnt detect motion anymore'

						else
						TriggerDevice = ''..deviceName..' switched '..deviceValue..''				
						end
			
						end
	
						if Array ~= nil then
						print_color(''..msgcolor.header..'', '==============================================================')
						print ''
						print_color(''..msgcolor.triggerTitle..'', 'Trigger:')
						print_color(''..msgcolor.trigger..'', ''..TriggerDevice..'')
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
					
					if redundant_array.command == 'true' then
						if redundant_array.verbose == 'true' then
						print_color(''..msgcolor.redundantarrayTitle..'', 'Redundant:')
						end
						
						for CommandArrayName, CommandArrayValue in pairs(commandArray) do
								for i, v in pairs(otherdevices_idx) do
									if CommandArrayName == i then
							
										HardwareName=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid="..v.."' | grep -w 'HardwareName'  | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
									
										SwitchType=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid="..v.."' | grep -w 'SwitchType'  | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
								
										if HardwareName == 'RFXtrx433E' and (SwitchType == 'On/Off' or SwitchType == 'Dimmer') then
										print_color(''..msgcolor.redundantarray..'',''..CommandArrayName..' is a '..HardwareName..' device, redundant command enabled')
										commandArray[CommandArrayName]=''..CommandArrayValue..' REPEAT '..redundant_array.repeats..' INTERVAL '..redundant_array.interval..''
										
										elseif HardwareName == 'Dummy' and SwitchType == 'On/Off' then
										print_color(''..msgcolor.redundantarray..'',''..CommandArrayName..' is a '..HardwareName..' device, redundant command enabled')
										commandArray[CommandArrayName]=''..CommandArrayValue..' REPEAT '..redundant_array.repeats..' INTERVAL '..redundant_array.interval..''
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

				end
			end
		end
	end

return commandArray
