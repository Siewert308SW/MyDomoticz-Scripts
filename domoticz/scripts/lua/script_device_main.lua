--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_device_main.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 09-01-2019
	@ Main event script on which my entire Lua event system is running. 

	Just one file instead of a dozen lua device and timer scripts.
	Which saves a lot of CPU resources and saves memory
	script_device_main.lua is the only lua event script which is called on device change.
	
	script_device_main.lua keeps track on changed devices.
	If a changed device is set in triggers.lua then it may execute a event script.
	This way Domoticz doesn't have to load and seek true all lua scripts all the time.
	I also use a function library, in this way i can call my functions once only if needed.
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

	local Current_Path = debug.getinfo(1).source:match("@?(.*/)")
	package.path = package.path .. ';' .. Current_Path .. 'config/?.lua'
	require "triggers"
	
commandArray = {}

--
-- **********************************************************
-- Call a event if predefined trigger changed status
-- **********************************************************
--

	for deviceName, deviceValue in pairs(devicechanged) do
		for tableName, tableDevice in pairs (triggers) do
			if deviceName == tableDevice then
			
				require "devices"
				if tableDevice == timed.trigger then
				require "settings"
					if otherdevices[lua_system.switch] ~= 'Off' then
						require "functions" require "helper"
						timers_folder = Current_Path .. ''..lua.timer_folder..'/'	
						f = io.popen('ls ' .. timers_folder)
						for name in f:lines() do
							timer = tostring(tablerow)
							if string.find(name, '' .. findstring.trigger) then
								dofile ('' .. timers_folder .. ''..name..'')
							end
						end	

					end
				end
				
				if deviceName == tableDevice and tableDevice ~= timed.trigger then
				require "settings"
					if otherdevices[lua_system.switch] ~= 'Off' then
						require "functions" require "helper" 
						event_folder = Current_Path .. ''..lua.event_folder..'/'
						f = io.popen('ls ' .. event_folder)
						for event in f:lines() do
						dofile ('' .. event_folder .. ''..event..'')
					end
				end
			end	
				
--
-- **********************************************************
-- Send redundant commandArray for 433mhz devices 
-- **********************************************************
--
					
				if redundant_array.command == 'true' and otherdevices[lua_system.switch] ~= 'Off' then
					for CommandArrayName, CommandArrayValue in pairs(commandArray) do
						for i, v in pairs(otherdevices_idx) do
							if CommandArrayName == i then
							
								HardwareName=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid="..v.."' | grep -w 'HardwareName'  | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
									
								SwitchType=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid="..v.."' | grep -w 'SwitchType'  | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
										
								if HardwareName == 'RFXtrx433E' and (SwitchType == 'On/Off' or SwitchType == 'Dimmer') then
									redundantArray = 'true'
									commandArray[CommandArrayName]=''..CommandArrayValue..' REPEAT '..redundant_array.repeats..' INTERVAL '..redundant_array.interval..''
								else
									redundantArray = 'false'
								end
							end
						end
					end
				end
--
-- **********************************************************
-- Print log: Print 2 log and file or both
-- **********************************************************
--
					
				if (lua.verbose == 'true' or otherdevices[lua_system.switch] == 'Logging' or otherdevices[lua_system.switch] == 'Logging & Writing' or otherdevices[lua_system.switch] == 'Writing') and otherdevices[lua_system.switch] ~= 'Off' then
					for CommandArrayName, CommandArrayValue in pairs(commandArray) do
						if type(CommandArrayValue) == "table" then
							for CommandArrayTableName, CommandArrayTableValue in pairs(CommandArrayValue) do
								Array = ''..CommandArrayName.."="..CommandArrayTableName.." = ".. CommandArrayValue[CommandArrayTableName]	
							end		  
						else   
								Array = ''..CommandArrayName..' = '..CommandArrayValue..''	
							end		   
						end
						
						if Array ~= nil then
						
						if deviceName == "Woonkamer - Lux" then
							TriggerDevice = 'Woonkamer Lux Sensor'
						elseif deviceName == "Gang - Lux" then
							TriggerDevice = 'Gang Lux Sensor'
						elseif deviceName == "Overloop - Lux" then
							TriggerDevice = 'Overloop Lux Sensor'						
						elseif deviceName == "Veranda - Lux" then
							TriggerDevice = 'Veranda Lux Sensor'
						elseif deviceName == "Natalya Kamer - Lux" then
							TriggerDevice = 'Natalya Kamer Lux Sensor'							
						elseif deviceName == "Raspberry - CPU Temperatuur" then
							TriggerDevice = '1 minuut trigger'
						else
							TriggerDevice = ''..deviceName..' == '..deviceValue..''
						end

				if otherdevices[lua_system.switch] ~= 'Writing' then						
						print('==============================================================')
						print('')						
						print('Trigger:')
						print(''..TriggerDevice..'')
						print('')
						if logmessage ~= nil then 
						print('Message:')
						print(''..logmessage..'')
						print('')
						end
						print('CommandArray:')
						for CommandArrayName, CommandArrayValue in pairs(commandArray) do
						   if type(CommandArrayValue) == "table" then
							  for CommandArrayTableName, CommandArrayTableValue in pairs(CommandArrayValue) do
								print(''..CommandArrayName.."="..CommandArrayTableName.." = ".. CommandArrayValue[CommandArrayTableName])
							  end		  
						   else   
								print(''..CommandArrayName..' => '..CommandArrayValue..'')
						   end		   
						end
						print('')
						print('==============================================================')
						print('')
				end
				if otherdevices[lua_system.switch] == 'Writing' or otherdevices[lua_system.switch] == 'Logging & Writing' then
								log_year 	= tonumber(os.date("%Y"));
								log_month 	= tonumber(os.date("%m"));
								log_day 	= tonumber(os.date("%d"));
								log_hour 	= tonumber(os.date("%H"));
								log_minutes = tonumber(os.date("%M"));						
								logdate = tostring(''..log_day..'-'..log_month..'-'..log_year..'')
								
								file = io.open(''..lualog.folder..''..lualog.filename..'-'..logdate..''..lualog.fileext..'', 'a+')
								file:write("Time:\n")								
								file:write(year .. "-" .. log_month .. "-"..log_day.."  -  "..log_hour..":"..log_minutes.."\n")
								file:write("\n")
								file:write("Trigger:\n")
								file:write(TriggerDevice.."\n")
								file:write("\n")
								if logmessage ~= nil then 
								file:write("Message:\n")
								file:write(logmessage.."\n")
								file:write("\n")
								end
								file:write("CommandArray:\n")								

									for CommandArrayName, CommandArrayValue in pairs(commandArray) do
									   if type(CommandArrayValue) == "table" then
										  for CommandArrayTableName, CommandArrayTableValue in pairs(CommandArrayValue) do
											file:write(""..CommandArrayName.."="..CommandArrayTableName.." = ".. CommandArrayValue[CommandArrayTableName]"\n")
										  end		  
									   else   
											file:write(""..CommandArrayName.." => "..CommandArrayValue.."\n")
									   end		   
									end								
								
								
								file:write("\n")
								file:write("==============================================================\n")
								file:write("\n")
								file:close()
								
								filepermission=os.capture('sudo ls -la '..lualog.folder..''..lualog.filename..'-'..logdate..''..lualog.fileext..' | awk "{print $1}"', false)
								
								if filepermission ~= '-rwxrwxrwx' then
								os.execute('sudo chmod 777 '..lualog.folder..''..lualog.filename..'-'..logdate..''..lualog.fileext..'')
								end
				end	
							end
						end


			end
		end
	end

return commandArray
