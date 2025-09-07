--
-- **********************************************************
-- Function to execute os commands and get output
-- **********************************************************
-- Example: os.capture(curl 'http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet')

	function os.capture(cmd, raw)
		
		local f = assert(io.popen(cmd, 'r'))
		local s = assert(f:read('*a'))
		f:close()
		if raw then return s end
		s = string.gsub(s, '^%s+', '')
		s = string.gsub(s, '%s+$', '')
		s = string.gsub(s, '[{}]+', ' ')		
		s = string.gsub(s, '[\n\r]+', ' ')
		s = string.gsub(s, '["]+', ' ')		
		return s
	
	end
	
--
-- **********************************************************
-- Round Numbers
-- **********************************************************
-- 

	function round(value, decimals)
		local nVal = tonumber(value)
		local nDec = ( decimals == nil and 0 ) or tonumber(decimals)
		if nVal >= 0 and nDec > 0 then
			return math.floor( (nVal * 10 ^ nDec) + 0.5) / (10 ^ nDec)
		elseif nVal >=0 then
			return math.floor(nVal + 0.5)
		elseif nDec and nDec > 0 then
			return math.ceil ( (nVal * 10 ^ nDec) - 0.5) / (10 ^ nDec)
		else
			return math.ceil(nVal - 0.5)
		end
	end
	
--
-- **********************************************************
-- Time Difference
-- **********************************************************
-- Example: and timedifference(otherdevices_lastupdate['light.living_standing_light']) >= 15

	function timedifference(s)
		year = string.sub(s, 1, 4)
		month = string.sub(s, 6, 7)
		day = string.sub(s, 9, 10)
		hour = string.sub(s, 12, 13)
		minutes = string.sub(s, 15, 16)
		seconds = string.sub(s, 18, 19)
		t1 = os.time()
		t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
		difference = os.difftime (t1, t2)
		return difference
	end

--
-- **********************************************************
-- Sunset / Sunrise
-- **********************************************************
-- Example: if timebetween(sunTime("sunset"),"23:00:00" then
--
--[[
	function sunTime(input)
	   
		if input == 'sunset' then
			local sunsetCap  = os.capture("curl 'http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet' | grep 'Sunset' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
			suntime = sunsetCap .. ":00"
			
		elseif input == 'sunrise' then 
			local sunriseCap = os.capture("curl 'http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet' | grep 'Sunrise' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
			suntime = sunriseCap .. ":00"
		end
		
		return suntime
		
	 end
--]]
	function sunTime(input)
		local suntime = "00:00:00"
		local offset = 0
		local mode = input

		-- Detecteer input + bepaal offset in minuten
		if input == "sunsetEarly" then
			mode = "sunset"
			offset = -60
		elseif input == "sunsetLate" then
			mode = "sunset"
			offset = 60
		elseif input == "sunriseEarly" then
			mode = "sunrise"
			offset = -60
		elseif input == "sunriseLate" then
			mode = "sunrise"
			offset = 60
		end

		-- Haal de tijd op zoals jij al deed
		if mode == 'sunset' then
			local sunsetCap = os.capture("curl -s 'http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet' | grep 'Sunset' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
			suntime = sunsetCap .. ":00"
		elseif mode == 'sunrise' then
			local sunriseCap = os.capture("curl -s 'http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet' | grep 'Sunrise' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
			suntime = sunriseCap .. ":00"
		end

		-- Offset toepassen als nodig
		if offset ~= 0 then
			local h = tonumber(string.sub(suntime, 1, 2))
			local m = tonumber(string.sub(suntime, 4, 5))
			local total = h * 60 + m + offset

			-- Clamp tussen 0 en 1439 (23:59)
			if total < 0 then total = 0 end
			if total > 1439 then total = 1439 end

			local hh = string.format("%02d", math.floor(total / 60))
			local mm = string.format("%02d", total % 60)
			suntime = hh .. ":" .. mm .. ":00"
		end

		return suntime
	end

--
-- **********************************************************
-- Time Between X hours and X hour
-- **********************************************************
-- Example: and timebetween("03:00:00","11:59:59")

	function timebetween(s,e)
	   timenow = os.date("*t")
	   year = timenow.year
	   month = timenow.month
	   day = timenow.day
	   s = s .. ":00"  
	   e = e .. ":00"
	   shour = string.sub(s, 1, 2)
	   sminutes = string.sub(s, 4, 5)
	   sseconds = string.sub(s, 7, 8)
	   ehour = string.sub(e, 1, 2)
	   eminutes = string.sub(e, 4, 5)
	   eseconds = string.sub(e, 7, 8)
	   t1 = os.time()
	   t2 = os.time{year=year, month=month, day=day, hour=shour, min=sminutes, sec=sseconds}
	   t3 = os.time{year=year, month=month, day=day, hour=ehour, min=eminutes, sec=eseconds}
	   sdifference = os.difftime (t1, t2)
	   edifference = os.difftime (t1, t3)
	   isbetween = false
	   if sdifference >= 0 and edifference <= 0 then
		  isbetween = true
	   end
	   return isbetween
	end
	
--
-- **********************************************************
-- Last Seen
-- **********************************************************
-- Example: lastSeen('device', '>', '300')

	function lastSeen(device, operator, seconds)
		local diff = timedifference(otherdevices_lastupdate[device])
		local f = load("return " .. diff .. " " .. operator .. " " .. tonumber(seconds))
		return f and f() or false
	end

--
-- **********************************************************
-- Last Seen Variable
-- **********************************************************
-- Example: lastSeenVar('variable', '>', '300')

	function lastSeenVar(device, operator, seconds)
		local diff = timedifference(uservariables_lastupdate[device])
		local f = load("return " .. diff .. " " .. operator .. " " .. tonumber(seconds))
		return f and f() or false
	end
	
--
-- **********************************************************
-- Is it Summer Time?
-- **********************************************************
-- Example: if summer('true') then

	function summer(input)
		input = input
		result = false
		
		local tNow = os.date("*t")
		local summertime = tNow.yday
			
			if input == 'true' and (summertime >= 60) and (summertime <= 274) then
				result = true
			end
 
			return result
		
	end
--
-- **********************************************************
-- Phones Online
-- **********************************************************
-- Example: if phonesOnline('true') then

	function phonesOnline(input)
		input = input
		result = false
		gsmonline = false
		
			for i, v in pairs(otherdevices) do
				if string.match(i, "_GSM$") and otherdevices[i] == 'On' then
					gsmonline = true
				end
			end
			
			if input == 'true' and gsmonline == true then
				result = true
			end
					
			if input == 'false' and gsmonline == false then
				result = true
			end
					
		return result		

	end

--
-- **********************************************************
-- Laptops Online
-- **********************************************************
-- Example: if laptopsOnline('true') then

	function laptopsOnline(input)
		input = input
		result = false
		laptopsonline = false
		
			for i, v in pairs(otherdevices) do
				if string.match(i, "_Lapt0p$") and otherdevices[i] == 'On' then
					laptopsonline = true
				end
			end
			
			if input == 'true' and laptopsonline == true then
				result = true
			end
					
			if input == 'false' and laptopsonline == false then
				result = true
			end
					
		return result		

	end
	
--
-- **********************************************************
-- TV Online
-- **********************************************************
-- Example: if mediaOnline('true') then

	function mediaOnline(input)
		input = input
		result = false
		mediaonline = false
		
			for i, v in pairs(otherdevices) do
				if string.match(i, "_tv$") and otherdevices[i] == 'On' then
					mediaonline = true
				end
			end
			
			if input == 'true' and mediaonline == true then
				result = true
			end
					
			if input == 'false' and mediaonline == false then
				result = true
			end
					
		return result		

	end

--
-- **********************************************************
-- Is weekend?
-- **********************************************************
-- Example: if weekend('true') then
-- weekday [0-6 = Sunday-Saturday]
-- day 1 = Mon
-- day 2 = Tue
-- day 3 = Wed
-- day 4 = Thur
-- day 5 = Fri
-- day 6 = Sat
-- day 0 = Sun

	function weekend(input)
		input = input
		result = false
		local dayNow = tonumber(os.date("%w"))
		local t = os.date("*t")

		if input == 'true' and dayNow == 5 and timebetween("19:30:00","23:59:59") then
			result = true
		end
		
		if input == 'true' and (dayNow == 6 or dayNow == 0) then
			result = true
		end
		
		if input == 'true' and dayNow == 1 and timebetween("00:00:00","02:59:59") then
			result = true
		end

-- **********************************************************
		
		if input == 'false' and dayNow == 1 and timebetween("03:00:00","23:59:59") then
			result = true
		end

		if input == 'false' and (dayNow == 2 or dayNow == 3 or dayNow == 4) then
			result = true					
		end
		
		if input == 'false' and dayNow == 5 and timebetween("00:00:00","18:29:59") then
			result = true
		end
		
		return result
	end
	
--
-- **********************************************************
-- Check motion @ home
-- **********************************************************
-- Example: if motionHome('true', 600) then

	function motionHome(input, minutes)
		local IsMotion = true

		for name, lastupdate in pairs(otherdevices_lastupdate) do
			if string.match(name, "_Motion$") or string.match(name, "_Deur$") then
				local diff = timedifference(lastupdate)

				if input == 'false' and diff < minutes then
					IsMotion = false
					break
				elseif input == 'true' and diff >= minutes then
					IsMotion = false
					break
				end
			end
		end

		return IsMotion
	end

--
-- **********************************************************
-- Check overall garden motion
-- **********************************************************
-- Example: if motionGarden('true', 600) then

	function motionGarden(input, minutes)
		input = input
		minutes = minutes
		result = false

			if input == 'false' then
				if timedifference(otherdevices_lastupdate["Voor_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Garage_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Achter_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Voordeur_Motion"]) > minutes
					and timedifference(otherdevices_lastupdate["Achterdeur_Motion"]) > minutes
					and timedifference(otherdevices_lastupdate["Fietsenschuur_Deur"]) > minutes			
				then
					result = true
				end	
			end
			
	
			if input == 'true' then
				if timedifference(otherdevices_lastupdate["Voor_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Garage_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Achter_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Voordeur_Motion"]) <= minutes
					and timedifference(otherdevices_lastupdate["Achterdeur_Motion"]) <= minutes
					and timedifference(otherdevices_lastupdate["Fietsenschuur_Deur"]) <= minutes
				then
					result = true
				end	
			end	
		
		return result

	end

--
-- **********************************************************
-- Get otherdevices_svalues
-- **********************************************************
-- Example: sensorValue('outside_temp_sensor') > 5

	function sensorValue(device)
		return tonumber(otherdevices_svalues[device])
	end

-- **********************************************************
-- Turn ON Kitchen Spots with Voltage Check
-- **********************************************************
-- Tries max 2x to dim correctly (voltage <= 2.0V)
-- Requires: sensorValue('Keuken_Spots_Huidige_Verbruik')
-- **********************************************************

	function kitchen_spots(input, pause)
		local maxAttempts = 1
		local pauseBetweenClicks = pause or 60

		if input == 'On' then
			local voltage = sensorValue('Keuken_Spots_Huidige_Verbruik')
			
			if voltage ~= nil and tonumber(voltage) > 0 and tonumber(voltage) <= 2.0 then
				--debugLog('Keuken Spots zijn al gedimd. (Voltage: ' .. voltage .. 'V) — skipping toggle sequence.')
				return
			end

			if voltage ~= nil and tonumber(voltage) <= 0 then
				maxflicks = 3
			elseif voltage ~= nil and tonumber(voltage) > 0 and tonumber(voltage) < 3 then
				maxflicks = 0
			elseif voltage ~= nil and tonumber(voltage) > 4 and tonumber(voltage) < 8 then
				maxflicks = 1
			elseif voltage ~= nil and tonumber(voltage) > 10 then
				maxflicks = 2
			end
			
			for attempt = 1, maxAttempts do

				for i = 1, maxflicks do
					commandArray[#commandArray+1] = { ["Keuken_Spots"] = 'Off AFTER ' .. pauseBetweenClicks }
					pauseBetweenClicks = pauseBetweenClicks + 1
					commandArray[#commandArray+1] = { ["Keuken_Spots"] = 'On AFTER ' .. pauseBetweenClicks }
					pauseBetweenClicks = pauseBetweenClicks + 1
				end

				--debugLog('Dim-sequentie uitgevoerd voor Keuken Spots. (Voltage: ' .. voltage .. 'V)')
			end

		elseif input == 'Off' then
			local offPause = tonumber(pause or 0)
			commandArray[#commandArray+1] = { ["Keuken_Spots"] = 'Off AFTER ' .. offPause }
		end
	end

--
-- **********************************************************
-- Power FailSave
-- **********************************************************
-- Example: if powerFailsave('true') then

	function powerFailsave(input)
		input = input
		result = false
		failsave = false
		
			if (otherdevices["Power_FailsaveL1"] == 'On' or otherdevices["Power_FailsaveL2"] == 'On' or otherdevices["Power_FailsaveL3"] == 'On' or uservariables["panic"] == 1) then
				failsave = true
			end
			
			if input == 'true' and failsave == true then
				result = true
			end
					
			if input == 'false' and failsave == false then
				result = true
			end
					
		return result		

	end
	
--
-- **********************************************************
-- Get homewizard api output
-- **********************************************************
--	if homewizard("battery") < 1500 then

	function homewizard(device)
		local device = device
		local reading
		local usage

--[[ HomeWizard P1 usage ]]--
			if device == "P1" then
			  reading = os.capture("curl -s 'http://192.168.178.77/api/v1/data' | gron | grep 'active_power_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)
			end

--[[ HomeWizard L1,l2 and l3 usage ]]--			
			if device == "L1" then
			  reading = os.capture("curl -s 'http://192.168.178.77/api/v1/data' | gron | grep 'active_power_l1_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)
			end

			if device == "L2" then
			  reading = os.capture("curl -s 'http://192.168.178.77/api/v1/data' | gron | grep 'active_power_l2_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)
			end

			if device == "L3" then
			  reading = os.capture("curl -s 'http://192.168.178.77/api/v1/data' | gron | grep 'active_power_l3_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)
			end

--[[ HomeWizard kWh Solar prodction ]]--
			if device == "Solar" then
			  reading = os.capture("curl -s 'http://192.168.178.83/api/v1/data' | gron | grep 'active_power_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)
			end

--[[ HomeWizard virtual P1 power available  ]]--			
			if device == "p1Available" then
			  reading_p1 = os.capture("curl -s 'http://192.168.178.77/api/v1/data' | gron | grep 'active_power_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)
			  
			  reading_charger1 = os.capture("curl -s 'http://192.168.178.90/api/v1/data' | gron | grep 'active_power_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)
			  reading_charger2 = os.capture("curl -s 'http://192.168.178.89/api/v1/data' | gron | grep 'active_power_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)
			  reading_charger3 = os.capture("curl -s 'http://192.168.178.91/api/v1/data' | gron | grep 'active_power_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)
			  reading_charger4 = os.capture("curl -s 'http://192.168.178.103/api/v1/data' | gron | grep 'active_power_w' | awk '{print $3}' | sed 's/\"//g' | sed 's/;//g'", false)

			  chargerUsage = reading_charger1 + reading_charger2 + reading_charger3 + reading_charger4
			  reading = reading_p1 - chargerUsage
			  
			end			
			_,_,usage = string.find(reading, "(.+)")
		  current_data = round(tonumber(reading), 0)
		  return current_data
	end
	
-- **********************************************************
-- Toggle device only if needed
-- **********************************************************
-- Example: switchDevice("Switch", "On") or switchDevice("variable:Name", "1") or switchDevice("Scene:Name", "On")

	local autoDelay = 0

	function switchDevice(deviceName, newCommand)
		local needsSwitch = false
		local isSwitch = false

		local currentDeviceStatus = otherdevices[deviceName]
		local currentVarStatus = nil

		-- Check of het om een Variable gaat
		if string.find(deviceName, "^Variable:") then
			local varName = deviceName:match("^Variable:(.+)")
			currentVarStatus = uservariables[varName]
		end

		-- Special handling for SetSetPoint and other custom commands
		if string.find(deviceName, "^SetSetPoint:") or 
		   string.find(deviceName, "^SetSetPoint[^:]*:") or
		   string.find(deviceName, "^OpenURL") then
			needsSwitch = true
			isSwitch = true

		-- Handle Set Level, Group, Scene commands
		elseif string.find(newCommand, "Set Level") or 
			   string.find(newCommand, "Group") or 
			   string.find(newCommand, "Scene") then
			needsSwitch = true
			isSwitch = true

		-- Handle Variable update
		elseif string.find(deviceName, "^Variable:") then
			if currentVarStatus ~= newCommand then
				needsSwitch = true
				isSwitch = false
			end

		-- Standard device switching
		elseif currentDeviceStatus ~= newCommand then
			needsSwitch = true
			isSwitch = true
		end

		-- Uitvoeren indien nodig
		if needsSwitch and isSwitch then
			commandArray[#commandArray+1] = { [deviceName] = newCommand .. " AFTER " .. autoDelay }
			autoDelay = autoDelay + 1
		elseif needsSwitch and not isSwitch then
			commandArray[#commandArray+1] = { [deviceName] = newCommand }
		end
	end

--
-- **********************************************************
-- Get lux threshold IsDark or IsNotDark
-- **********************************************************
-- Example: if dark('true', 'lux_sensor', lux_threshold) then

	function dark(dark, lux_sensor, lux)
		local result = false
		local sensor = sensorValue(lux_sensor)

		if sensor ~= nil then
			if sensor <= lux and dark == 'true' then
				result = true
			elseif sensor > lux and dark == 'false' then
				result = true
			end
		end

		return result
	end

--
-- **********************************************************
-- Get lux threshold Living
-- **********************************************************
-- Example: if darkLiving('true', lux_threshold) then

	function darkLiving(dark, lux)
		local result    = false
		local sensor1 = sensorValue("Woonkamer_LUX")
		local sensor2 = sensorValue("Keuken_LUX")

	if sensor1 ~= nil and sensor2 ~= nil then
		local sensorAvg = (sensor1 + sensor2) / 2
			if sensorAvg <= lux and dark == 'true' then
				result = true
			elseif sensorAvg > lux and dark == 'false' then
				result = true
			end
		end

		return result
	end
	
--
-- **********************************************************
-- Get lux threshold Garden
-- **********************************************************
-- Example: if darkGarden('true', lux_threshold) then

	function darkGarden(dark, lux)
		local result    = false
		local sensor1 = sensorValue("Voordeur_LUX")
		local sensor2 = sensorValue("Achterdeur_LUX")

	if sensor1 ~= nil and sensor2 ~= nil then
		local sensorAvg = (sensor1 + sensor2) / 2
			if sensorAvg <= lux and dark == 'true' then
				result = true
			elseif sensorAvg > lux and dark == 'false' then
				result = true
			end
		end

		return result
	end

--
-- **********************************************************
-- Debug Function
-- **********************************************************
-- Example: debugLog('message')

	function debugLog(message)
		if lua.debugLogging == 'yes' then
			local formattedMessage = tostring(message):gsub("%#", "\n Status: LUA: ")
			
			print(' ')
			print('==========================================')
			print('DebugLog')
			print('==========================================')
			print(' ')
			print("Trigger:")
			print(''..triggerDevice..' == '..triggerValue..'')
			print(' ')
			print("Message:")
			print(formattedMessage)
			
			toggledDevices = {}

			for CommandArrayName, CommandArrayValue in pairs(commandArray) do
				if type(CommandArrayValue) == "table" then
					for CommandArrayTableName, CommandArrayTableValue in pairs(CommandArrayValue) do
						table.insert(toggledDevices, ''..CommandArrayName..', '..CommandArrayTableName..' > '..CommandArrayValue[CommandArrayTableName]..'')
					end		  
				else
					table.insert(toggledDevices, ''..CommandArrayName..' > '..CommandArrayValue..'')
				end		   
			end

			if #toggledDevices > 0 then
				print(' ')
				print("CommandArray:")
				for _, line in ipairs(toggledDevices) do
					print(line)
				end
			end
			
			print(' ')						
			print('==========================================')
			print(' ')
		end
		
		
		
			lua = lua or {}
			lua.debugLogging   = lua.debugLogging   or 'yes' -- console log
			lua.debugLogToFile = lua.debugLogToFile or 'yes' -- file logging
			lua.debugLogDir    = lua.debugLogDir    or '/home/siewert/domoticz/scripts/lua/logs' -- pad naar logmap
			lua.debugLogPrefix = lua.debugLogPrefix or 'Debug' -- bestandsnaam-prefix

    -- File logging
		if lua.debugLogToFile == 'yes' then
			local now      = os.date('%d-%m-%Y %H:%M:%S')
			local daystamp = os.date('%Y-%m-%d')
			local dir      = lua.debugLogDir
			local fileName = string.format('%s/%s_%s.log', dir, lua.debugLogPrefix, daystamp)
			local formattedFiledMessage = tostring(message):gsub("%#", "\n")

			-- Create directory if it doesn't exist
			os.execute('mkdir -p "' .. dir .. '"')

			-- Format lines
			local logLines = {}
			table.insert(logLines,' | DebugLog - '.. now ..'')
			table.insert(logLines,' | ==========================================')
			table.insert(logLines,' |')
			table.insert(logLines,' | Trigger:')
			table.insert(logLines,' | ' .. triggerDevice .. ' == ' .. triggerValue)
			table.insert(logLines,' |')
			table.insert(logLines,' | Message:')
			for line in string.gmatch(formattedFiledMessage, "[^\n]+") do
				line = line:gsub("^%s+", "")  -- trim spatie aan het begin
				table.insert(logLines,' | ' .. line)
			end
			if #toggledDevices > 0 then
				table.insert(logLines,' |')
				table.insert(logLines,' | CommandArray:')
				for _, line in ipairs(toggledDevices) do
					table.insert(logLines,' | ' .. line)
				end
			end
			table.insert(logLines,' |')
			table.insert(logLines,' | ==========================================')
			table.insert(logLines, '')

			-- Write to file
			local f = io.open(fileName, "a")
			if f then
				f:write(table.concat(logLines, '\n'))
				f:close()
				os.execute('chmod 664 "' .. fileName .. '"')
			else
				print("DebugLog: fout bij schrijven naar bestand: " .. fileName)
			end
		end
	end