--
-- **********************************************************
-- Function sleep, give LUA scripts a timeout
-- **********************************************************
-- Example: sleep(5.0) = 5 seconds

function sleep(n)
	os.execute("sleep " .. tonumber(n))
end

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
-- Sun Time
-- **********************************************************
--

	function dayTime(input)
	   input = input
	   IsTime = false
	   
	   if input == 'true' then
		local sunset  = os.capture("curl 'http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet' | grep 'Sunset' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
		local sunset = sunset .. ":00"
		
		local sunrise = os.capture("curl 'http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet' | grep 'Sunrise' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
		local sunrise = sunrise .. ":00"
		
			if timebetween(""..sunrise.."",""..sunset.."") then
			IsTime = true
			end
			
		end
		
		return IsTime
	  end
	
--
-- **********************************************************
-- Powerfailsave
-- **********************************************************
-- Example: if powerfailsave('false') then
--	

	function powerfailsave(input)
		input = input
		IsPowerFailsave = false
		
		if input == 'true'
			and (otherdevices["Power_FailsaveL1"] == 'On'
			or otherdevices["Power_FailsaveL2"] == 'On'
			or otherdevices["Power_FailsaveL3"] == 'On')
		then
			IsPowerFailsave = true
		end
		
		if input == 'false'
			and otherdevices["Power_FailsaveL1"] == 'Off'
			and otherdevices["Power_FailsaveL2"] == 'Off'
			and otherdevices["Power_FailsaveL3"] == 'Off'
		then
			IsPowerFailsave = true
		end
		
		return IsPowerFailsave
		
	end
	
--
-- **********************************************************
-- Phones Online
-- **********************************************************
-- Example: if phones_online('true') then
--

	function phones_online(input)
		input = input
		IsPhonesOnline = false
		gsmonline = false
		
			for i, v in pairs(otherdevices) do
				if string.find(i, "_GSM") and otherdevices[''..i..''] == 'On' then
					gsmonline = true
				end
			end
			
			if input == 'true' and gsmonline == true then
				IsPhonesOnline = true
			end
					
			if input == 'false' and gsmonline == false then
				IsPhonesOnline = true
			end
					
		return IsPhonesOnline		

	end

--
-- **********************************************************
-- Laptops Online
-- **********************************************************
-- Example: if laptops_online('true') then
--

	function laptops_online(input)
		input = input
		IsLaptopsOnline = false
		laptopsonline = false
		
			for i, v in pairs(otherdevices) do
				if string.find(i, '_Laptop') and otherdevices[''..i..''] == 'On' then
					laptopsonline = true
				end
			end
			
			if input == 'true' and laptopsonline == true then
				IsLaptopsOnline = true
			end
					
			if input == 'false' and laptopsonline == false then
				IsLaptopsOnline = true
			end
					
		return IsLaptopsOnline		

	end
	
--
-- **********************************************************
-- TV Online
-- **********************************************************
-- Example: if tv_online('true') then
--

	function tv_online(input)
		input = input
		IsTvOnline = false
		tvonline = false
		
			for i, v in pairs(otherdevices) do
				if string.find(i, '_TV') and otherdevices[''..i..''] == 'On' then
					tvonline = true
				end
			end
			
			if input == 'true' and tvonline == true then
				IsTvOnline = true
			end
					
			if input == 'false' and tvonline == false then
				IsTvOnline = true
			end
					
		return IsTvOnline		

	end

--
-- **********************************************************
-- Get Humidity
-- **********************************************************
--	if humidity("bathroom") < 1500 then

	function humidity(device)
		local device = device
		local reading
		local usage
		local NetHum = '"Humidity"'
			if device == "bathroom" then
			  reading = os.capture("curl 'http://127.0.0.1:8080/json.htm?type=command&param=getdevices&rid=2904' | grep '"..NetHum.."' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g' | sed 's/Humidity//g'", false)
			end
			_,_,usage = string.find(reading, "(.+)")
		  current_humidity = tonumber(reading)
		  return current_humidity
	end

--
-- **********************************************************
-- Get P1 delivery
-- **********************************************************
--	if p1Usage("idx") < 1500 then

	function p1NetUsage(p1device)
		local p1Usage = p1Usage
		local reading
		local usage
		local NetUsage = '"Usage"'
			  reading = os.capture("curl 'http://127.0.0.1:8080/json.htm?type=command&param=getdevices&rid="..p1device.."' | grep '"..NetUsage.."' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
			_,_,usage = string.find(reading, "(.+)")
		  current_usage = tonumber(reading)
		  --print("")
		  --print("P1 van het net")
		  --print(current_usage)
		  --print("")
		  return current_usage
	end
	
--
-- **********************************************************
-- Get P1 delivery
-- **********************************************************
--	if p1UsageDeliv("idx") < 1500 then

	function p1NetUsageDeliv(p1device)
		local p1UsageDeliv = p1UsageDeliv
		local reading
		local usage
			  reading = os.capture("curl 'http://127.0.0.1:8080/json.htm?type=command&param=getdevices&rid="..p1device.."' | grep 'UsageDeliv' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
			_,_,usage = string.find(reading, "(.+)")
		  current_delivery = tonumber(reading)
		 -- print("")
		  --print("P1 naar het net")
		 -- print(current_delivery)
		  --print("")
		  return current_delivery
	end
	
--
-- **********************************************************
-- Get Solar battery voltage volt *10
-- **********************************************************
--	if battvolt("Thuisbatterij_Voltage") > 23.0 then

	function battvolt(device)
		local device = device
		local reading
		local usage
			  reading = otherdevices[device] 
			_,_,usage = string.find(reading, "(.+)")

		  current_voltage = tonumber(reading)
		  return current_voltage
	end
	
--
-- **********************************************************
-- Get Zwave Power Plug current Watts
-- **********************************************************
--	

	function powerusage(powerplug)
		local powerplug = powerplug
		local reading
		local usage
			  reading = otherdevices[powerplug] 
			_,_,usage = string.find(reading, "(.+)")

		  current_usage = tonumber(reading)
		 -- print(powerplug)
		 -- print(current_usage)
		  return current_usage
	end

--
-- **********************************************************
-- Hood PowerUsage
-- **********************************************************
-- Example: if hood_usage('true') then
--

	function hood_usage(input)
		input = input
		IsHoodPowered = false
		
		if input == 'true' and powerusage("Afzuigkap_Huidige_Verbruik") > 3 then
				IsHoodPowered = true	
		end
		
		if input == 'false' and powerusage("Afzuigkap_Huidige_Verbruik") <= 3 then
				IsHoodPowered = true
		end		
		return IsHoodPowered		
	end
	
--
-- **********************************************************
-- Electric PowerUsage
-- **********************************************************
-- Example: if electric_usage('high', device) then
--

	function electric_usage(input, device)
		input = input
		device =  device

		IsElectricHigh = false
		
		if input == 'high' and powerusage(device) > 5500 then
				IsElectricHigh = true	
		end
		
		if input == 'low' and powerusage(device) <= 1500 then
				IsElectricHigh = true
		end
		
		return IsElectricHigh		

	end

--
-- **********************************************************
-- Is it SolarWinter Time?
-- **********************************************************
-- Example: if solarwinter('true') then
--

	function solarwinter(input)
		input = input
		IsSolarWinter = false
		
		local tNow = os.date("*t")
		local solarwinter = tNow.yday
			
			if input == 'true' and (solarwinter >= 275) and (solarwinter <= 366) then
				IsSolarWinter = true
			end

			if input == 'true' and (solarwinter >= 1) and (solarwinter <= 90) then
				IsSolarWinter = true
			end

			if input == 'false' and (solarwinter >= 91) and (solarwinter <= 274) then
				IsSolarWinter = true
			end
 
			return IsSolarWinter
		
	end
	
--
-- **********************************************************
-- Is it Lichtweek?
-- **********************************************************
-- Example: if lichtweekseason('true') then
--

	function lichtweek(input)
		input = input
		IsLichtweek = false
		
		local tNow = os.date("*t")
		local lichtweekseason = tNow.yday
			
		-- Wel Kerst geen Lichtweek
			if input == 'true' and (lichtweekseason >= 1) and (lichtweekseason < 6) then
				IsLichtweek = true
			end

		-- Geen Kerst geen Lichtweek
			if input == 'false' and (lichtweekseason >= 6) and (lichtweekseason < 250) then
				IsLichtweek = true
			end
			
		-- Wel Lichtweek geen kerst
			if input == 'true' and (lichtweekseason >= 250) and (lichtweekseason < 260) then
				IsLichtweek = true
			end
			
		-- Geen kerst geen lichtweek			
			if input == 'false' and (lichtweekseason >= 260) and (lichtweekseason < 340) then
				IsLichtweek = true
			end
			
		-- Wel Kerst geen lichtweek			
			if input == 'true' and (lichtweekseason >= 340) and (lichtweekseason < 366) then
				IsLichtweek = true
			end
 
			return IsLichtweek
		
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
		Isweekend = false
		tHoliday = false
		local dayNow = tonumber(os.date("%w"))
		local t = os.date("*t")

		if (t.month == 12) and ((t.day == 24) or (t.day == 25) or (t.day == 26) or (t.day == 31)) then
		  tHoliday = true
		end
		
		if (t.month == 1) and (t.day == 1) then
		  tHoliday = true
		end
		
-- **********************************************************
				
				if input == 'false' and (dayNow == 1 or dayNow == 2 or dayNow == 3 or dayNow == 5) and tHoliday == false then
					Isweekend = true					
				end

-- **********************************************************				
			
				if input == 'true' and (dayNow == 4 or dayNow == 6 or dayNow == 0 or tHoliday == true) then
					Isweekend = true
				end
				
				return Isweekend
	end
		
--
-- **********************************************************
-- Check overall motion @ home
-- **********************************************************
-- Example: if motion('true', 600) then
--

	function motion(input, minutes)
		input = input
		minutes = minutes

		IsMotion = false

			if input == 'false' then
				if timedifference(otherdevices_lastupdate["Voor_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Hal_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Kelder_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Bijkeuken_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Overloop_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Slaapkamer_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Natalya_Slaapkamer_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Garage_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Achter_Deur"]) > minutes
					
					and timedifference(otherdevices_lastupdate["Woonkamer_Motion"]) > minutes
					and timedifference(otherdevices_lastupdate["Toilet_Motion"]) > minutes		
					and timedifference(otherdevices_lastupdate["Overloop_Motion"]) > minutes
					and timedifference(otherdevices_lastupdate["Badkamer_Motion"]) > minutes
					and timedifference(otherdevices_lastupdate["Voordeur_Motion"]) > minutes
					and timedifference(otherdevices_lastupdate["Keuken_Motion"]) > minutes
					and timedifference(otherdevices_lastupdate["Achterdeur_Motion"]) > minutes
					and timedifference(otherdevices_lastupdate["Hal_Motion"]) > minutes
					and timedifference(otherdevices_lastupdate["Garage_Motion"]) > minutes
					and otherdevices["Achter_Deur"] == 'Closed'
					and otherdevices["Voor_Deur"] == 'Closed'
					and otherdevices["Garage_Deur"] == 'Closed'	
				then
					IsMotion = true
				end	
			end
			
	
			if input == 'true' then
				if timedifference(otherdevices_lastupdate["Voor_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Hal_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Kelder_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Bijkeuken_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Overloop_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Slaapkamer_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Natalya_Slaapkamer_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Garage_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Achter_Deur"]) <= minutes
					
					and timedifference(otherdevices_lastupdate["Woonkamer_Motion"]) <= minutes
					and timedifference(otherdevices_lastupdate["Toilet_Motion"]) <= minutes		
					and timedifference(otherdevices_lastupdate["Overloop_Motion"]) <= minutes
					and timedifference(otherdevices_lastupdate["Badkamer_Motion"]) <= minutes
					and timedifference(otherdevices_lastupdate["Voordeur_Motion"]) <= minutes
					and timedifference(otherdevices_lastupdate["Keuken_Motion"]) <= minutes
					and timedifference(otherdevices_lastupdate["Achterdeur_Motion"]) <= minutes
					and timedifference(otherdevices_lastupdate["Hal_Motion"]) <= minutes
					and timedifference(otherdevices_lastupdate["Garage_Motion"]) <= minutes
					and (otherdevices["Achter_Deur"] ~= 'Closed'
					or otherdevices["Voor_Deur"] ~= 'Closed'
					or otherdevices["Garage_Deur"] ~= 'Closed')	
				then
					IsMotion = true
				end	
			end	
		
		return IsMotion

	end

--
-- **********************************************************
-- Check overall garden motion @ home
-- **********************************************************
-- Example: if garden_motion('true', 600) then
--

	function garden_motion(input, minutes)
		input = input
		minutes = minutes

		IsGardenMotion = false

			if input == 'false' then
				if timedifference(otherdevices_lastupdate["Voor_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Garage_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Achter_Deur"]) > minutes
					and timedifference(otherdevices_lastupdate["Voordeur_Motion"]) > minutes
					--and timedifference(otherdevices_lastupdate["Achterdeur_Motion"]) > minutes
					and otherdevices["Achter_Deur"] == 'Closed'
					and otherdevices["Voor_Deur"] == 'Closed'
					and otherdevices["Garage_Deur"] == 'Closed'				
				then
					IsGardenMotion = true
				end	
			end
			
	
			if input == 'true' then
				if timedifference(otherdevices_lastupdate["Voor_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Garage_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Achter_Deur"]) <= minutes
					and timedifference(otherdevices_lastupdate["Voordeur_Motion"]) <= minutes
					--and timedifference(otherdevices_lastupdate["Achterdeur_Motion"]) <= minutes			
					and (otherdevices["Achter_Deur"] == 'Open' or otherdevices["Voor_Deur"] == 'Open' or otherdevices["Garage_Deur"] == 'Open')
				then
					IsGardenMotion = true
				end	
			end	
		
		return IsGardenMotion

	end

--
-- **********************************************************
-- Get otherdevices_svalues
-- **********************************************************
-- Example: device_svalue('outside_temp_sensor') > 5
	
	function device_svalue(device)
		device = tonumber(otherdevices_svalues[device])
		devices_svalues = device		
		return devices_svalues
	end
	
--
-- **********************************************************
-- Turn ON Kitchen Spots
-- **********************************************************
-- Example: kitchen_spots(times, pause)
--

	function kitchen_spots_test(input, pause)
		input = input
		pause = pause
	   
	   if input == 'On' then
		   times = 3	   
		   cmd1 = 'Off'
		   cmd2 = 'On'
		   
		   for i = 1, times do
		   
			  commandArray[#commandArray+1]={["Keuken_Spots"]=cmd1..' AFTER '..pause }
			  pause = pause + 1
			  commandArray[#commandArray+1]={["Keuken_Spots"]=cmd2..' AFTER '..pause }
			  pause = pause + 1
		   end
		   
		end
		
		if input =='Off' then
		
			if pause == nil then
			pause = 0
			end
			
			local pause = tonumber(pause)
			commandArray["Keuken_Spots"]='Off AFTER '..pause..''
		end
	end
	
--
-- **********************************************************
-- Turn ON Kitchen Spots in steps
-- **********************************************************
-- Example: kitchen_spots(times, pause)
--

	function kitchen_spots_steps(input)
		input = input
		pause = 1
	   
	   if input == 'On' then
		   times = 1
		   
		   cmd1 = 'Off'
		   cmd2 = 'On'

	   if (otherdevices[light] == 'Off') then
		  cmd1 = 'On'
		  cmd2 = 'Off'
	   end 
	   
		   for i = 1, times do
		   
			  commandArray[#commandArray+1]={["Keuken_Spots"]=cmd1..' AFTER '..pause }
			  pause = pause + 1
			  commandArray[#commandArray+1]={["Keuken_Spots"]=cmd2..' AFTER '..pause }
			  pause = pause + 1
		   end
		end
		
		if input =='Off' then
		
			if pause == nil then
			pause = 0
			end
			
			local pause = tonumber(pause)
			commandArray["Keuken_Spots"]='Off AFTER '..pause..''
		end
	end
	
--
-- **********************************************************
-- Function to control my system
-- **********************************************************
-- Example: system('shutdown') or system('reboot')

	function system(cmd)
		cmd = cmd

		if cmd == 'shutdown' then
		os.execute("curl 'http://127.0.0.1:8080/json.htm?type=command&param=system_shutdown'")
		end
		
		if cmd == 'reboot' then
		os.execute("curl 'http://127.0.0.1:8080/json.htm?type=command&param=system_reboot'")
		end
		
	end
	
--
-- **********************************************************
-- Get lux threshold IsDark or IsDay Inside or outside
-- **********************************************************
-- Example: if dark_average('true', 'location', lux_threshold) then

	function dark_average(dark, location, lux)
		dark = dark
		lux = lux
		location = location

	-- Get Lux Value	
		local living_lux 	= tonumber(otherdevices_svalues["Woonkamer_LUX"])
		local hallway_lux  	= tonumber(otherdevices_svalues["Woonkamer_LUX"])
		local kitchen_lux 	= tonumber(otherdevices_svalues["Keuken_LUX"])
		local frontdoor  	= tonumber(otherdevices_svalues["Achterdeur_LUX"])
		local garden_lux 	= tonumber(otherdevices_svalues["Achterdeur_LUX"])
		
	-- Create table
		if location == "inside" then
			sensors={living_lux, hallway_lux, kitchen_lux, frontdoor_lux, garden_lux}
		end

		if location == "outside" then
			sensors={frontdoor_lux, garden_lux}
		end
		
	-- Lux_threshold
		local lux_threshold = tonumber(lux)
		
	-- Calculate Average		
		local elements = 0
		local sum = 0
			
		for k,v in pairs(sensors) do
			sum = sum + v
			elements = elements + 1
		end
	 
		local lux_ave = sum / elements
		local lux_average = round(lux_ave, 1)
		
		--if location == "inside" then
		--	hysteresis = 5
		--end

		--if location == "outside" then
		--	hysteresis = 0
		--end
		
		isdark = false
		
	--IsDay
		if lux_average >= lux_threshold and dark == 'false' then
		isdark = true
		end

	--IsDark		
		if lux_average <= lux_threshold and dark == 'true' then
		isdark = true
		end
		
	--Write Average lUX

		if location == "inside" then
		commandArray[#commandArray+1] = {['UpdateDevice']='509|0|'..lux_average..'' }
		--commandArray['UpdateDevice']='509|nValue|'..lux_average..''			
		end		

		if location == "outside" then
		commandArray[#commandArray+1] = {['UpdateDevice']='1004|0|'..lux_average..'' }
		--commandArray['UpdateDevice']='1004|nValue|'..lux_average..''			
		end	
		
		return isdark	
					
	end
	
--	
-- **********************************************************
-- Get lux threshold IsDark or IsDay device specific
-- **********************************************************
-- Example: if dark_specific('true', 3, luxsensor) then

	function dark_specific(dark, lux, luxsensor)
		dark = dark
		lux = lux
		luxsensor = luxsensor
		
	-- Get Lux Value
		
		sensor = tonumber(otherdevices_svalues[luxsensor])
		
	-- Lux_threshold
			lux_threshold = tonumber(lux)

			isdark = false
		
	--IsDay
		if sensor > lux_threshold and dark == 'false' then
		isdark = true
		end

	--IsDark		
		if sensor <= lux_threshold and dark == 'true' then
		isdark = true
		end
		
		return isdark	
				
	end
	
--
-- **********************************************************
-- Get lux threshold IsDark or IsDay Inside or outside
-- **********************************************************
-- Example: if dark('true', 'location', lux_threshold) then

	function dark(dark, location, lux)
		dark = dark
		location = location
		lux = lux 
		isdark = false
		
	--IsDay INSIDE
		if dark == 'false' and location == "inside" and device_svalue("Gemiddelde_LUX_Binnen") > lux then
		isdark = true
		end

	--IsDark INSIDE	
		if dark == 'true' and location == "inside" and device_svalue("Gemiddelde_LUX_Binnen") <= lux then
		isdark = true
		end
		
	--IsDay OUTSIDE
		if dark == 'false' and location == "outside" and device_svalue("Gemiddelde_LUX_Buiten") > lux then
		isdark = true
		end

	--IsDark OUTSIDE	
		if dark == 'true' and location == "outside" and device_svalue("Gemiddelde_LUX_Buiten") <= lux then
		isdark = true
		end
		
		return isdark	
					
	end
