--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ functions.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 22-01-2019
	@ Global Functions
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Round Numbers
-- **********************************************************
-- 

	function round(num, dec)
	   if num == 0 then
		 return 0
	   else
		 local mult = 10^(dec or 0)
		 return math.floor(num * mult + 0.5) / mult
	   end
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
-- Function to control my HEOS By Denon Speakers
-- **********************************************************
-- Example: heos('play') or heos('stop')

	function heos(cmd)
		cmd = cmd
		play_state = os.capture("echo 'heos://player/get_play_state?pid="..heosconf.pid.."' | netcat "..heosconf.host.." "..heosconf.port.." -w2 | awk {'print $7'}", false)

		if string.find(play_state, 'stop') and cmd == 'play' then
		output = os.capture('echo "heos://player/set_play_state?pid='..heosconf.pid..'&state='..cmd..'" | netcat '..heosconf.host..' '..heosconf.port..' -w0')
		end
		
		if string.find(play_state, 'play') and cmd == 'stop' then
		output = os.capture('echo "heos://player/set_play_state?pid='..heosconf.pid..'&state='..cmd..'" | netcat '..heosconf.host..' '..heosconf.port..' -w0')
		end
		
		return output
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
		  return current_usage
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
		if input == 'true' or input == 'false' then
		IsMotion = false

			if input == 'false' then		
				if timedifference(otherdevices_lastupdate[door.living]) > minutes
					and timedifference(otherdevices_lastupdate[door.front]) > minutes
					and timedifference(otherdevices_lastupdate[door.back]) > minutes
					and timedifference(otherdevices_lastupdate[door.garden]) > minutes
					and timedifference(otherdevices_lastupdate[door.scullery]) > minutes
					and timedifference(otherdevices_lastupdate[door.pantry]) > minutes					
					and timedifference(otherdevices_lastupdate[motion_sensor.living]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) > minutes		
					and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.toilet]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.dinner1]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.dinner2]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.kitchen]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.natalya]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.porch]) > minutes

				then
					IsMotion = true
				end	
			end
		
			if input == 'true' then
				if timedifference(otherdevices_lastupdate[door.living]) <= minutes
					or timedifference(otherdevices_lastupdate[door.front]) <= minutes
					or timedifference(otherdevices_lastupdate[door.back]) <= minutes
					or timedifference(otherdevices_lastupdate[door.garden]) <= minutes
					or timedifference(otherdevices_lastupdate[door.scullery]) <= minutes
					or timedifference(otherdevices_lastupdate[door.pantry]) <= minutes					
					or timedifference(otherdevices_lastupdate[motion_sensor.living]) < minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) <= minutes		
					or timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) <= minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.toilet]) <= minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.dinner1]) <= minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.dinner2]) <= minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.kitchen]) <= minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.natalya]) <= minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.hallway]) <= minutes				
					or timedifference(otherdevices_lastupdate[motion_sensor.porch]) <= minutes
			
				then
					IsMotion = true
				end	
			end		
		
		return IsMotion
		end
	end
	
--
-- **********************************************************
-- If Motion detected
-- **********************************************************
-- Example: if motion_detected('true') then
--

	function motion_detected(input, value)
		input = input
		value = value
		IsMotionDetected = false

			if input == 'true' then		
				if devicechanged[door.living] == "Open"
					or devicechanged[door.front] == "Open"
					or devicechanged[door.back] == "Open"
					or devicechanged[door.garden] == "Open"
					or devicechanged[door.scullery] == "Open"					
					or devicechanged[motion_sensor.living] == "On"
					or devicechanged[motion_sensor.dinner1] == "On"
					or devicechanged[motion_sensor.dinner2] == "On"
					or devicechanged[motion_sensor.kitchen] == "On"
				then
					IsMotionDetected = true
				end	
			end		
		
		return IsMotionDetected
	end
	
--
-- **********************************************************
-- Phones GeoFence Closed or Open
-- **********************************************************
-- Example: if geo_fence('true') then
--

	function geo_fence(input)
		input = input
		Isgeofence = false
		nearby = false
		
			for i, v in pairs(otherdevices) do
				if string.find(i, '' .. findstring.geofence) and otherdevices[''..i..''] == 'On' then
					nearby = true
				end
			end
			
			if input == 'true' and nearby == true then
				Isgeofence = true
			end
					
			if input == 'false' and nearby == false then
				Isgeofence = true
			end
					
		return Isgeofence		

	end

--
-- **********************************************************
-- How many devices online
-- **********************************************************
-- Example: if onlinedevices(findstring.gsm) > 1 then
--

	function onlinedevices(device)
		device = device
		numItems = 0
		for i,v in pairs(triggers) do
			if string.find(v, ''.. device) then
				if otherdevices[''..v..''] == 'On' then
				numItems = numItems + 1
				end
			end
		end
			return numItems
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
				if string.find(i, '' .. findstring.gsm) and otherdevices[''..i..''] == 'On' then
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
				if string.find(i, '' .. findstring.laptop) and otherdevices[''..i..''] == 'On' then
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
-- Media PowerUsage
-- **********************************************************
-- Example: if media_powered('true') then
--

	function media_powered(input)
		input = input
		if input == 'true' or input == 'false' then
		IsMediaPowered = false
		
		if powerusage(watt_plug.tvcorner) > watt_usage.media or powerusage(watt_plug.natalya) > watt_usage.media then
			if input == 'true' then
				IsMediaPowered = true
			end	
		end
		
		if powerusage(watt_plug.tvcorner) <= watt_usage.media and powerusage(watt_plug.natalya) <= watt_usage.media then
			if input == 'false' then
				IsMediaPowered = true
			end	
		end		
		return IsMediaPowered		
		end
	end


-- **********************************************************
-- Media ON? if on then do certain light scene
-- **********************************************************
-- Example: if media('true') then
--

	function media(input)
		input = input
		if input == 'true' or input == 'false' then
		IsMedia = false
		
		if powerusage(watt_plug.tvcorner) > watt_usage.media or powerusage(watt_plug.natalya) > watt_usage.media_natalya then
			if input == 'true' then
				IsMedia = true
			end	
		end
		
		if powerusage(watt_plug.tvcorner) <= watt_usage.media or powerusage(watt_plug.natalya) <= watt_usage.media_natalya then
			if input == 'false' then
				IsMedia = true
			end	
		end	
		return IsMedia		
		end
	end

--
-- **********************************************************
-- Laptop PowerUsage
-- **********************************************************
-- Example: if laptops_powered('true') then
--

	function laptops_powered(input)
		input = input
		if input == 'true' or input == 'false' then
		IsLaptopPower = false
		
		if powerusage(watt_plug.siewert) > watt_usage.laptop or powerusage(watt_plug.jerina) > watt_usage.laptop then
			if input == 'true' then
				IsLaptopPower = true
			end	
		end
		
		if powerusage(watt_plug.siewert) <= watt_usage.laptop and powerusage(watt_plug.jerina) <= watt_usage.laptop then
			if input == 'false' then
				IsLaptopPower = true
			end	
		end		
		return IsLaptopPower		
		end
	end
	
--
-- **********************************************************
-- Is weekend?
-- **********************************************************
-- Example: if weekend('true') then
-- weekday [0-6 = Sunday-Saturday]
--

	function weekend(input)
		input = input
		if input == 'true' or input == 'false' then
		Isweekend = false
			local dayNow = tonumber(os.date("%w"))		
			
				if dayNow == 5 and timebetween("00:00:00","11:59:59") and (uservariables[var.holiday] == 0 or uservariables[var.holiday] == 1) then 
					if input == 'false' then
						Isweekend = true
					end
				end

				if dayNow == 5 and timebetween("12:00:00","23:59:59") and (uservariables[var.holiday] == 0 or uservariables[var.holiday] == 1) then
					 if input == 'true' then
						Isweekend = true
					 end
				end				

-- **********************************************************
				
				if dayNow == 6 and timebetween("00:00:00","23:59:59") then
					 if input == 'true' then
						Isweekend = true
					 end	
				end

-- **********************************************************

				if dayNow == 0 and timebetween("00:00:00","23:59:59") then 
					if input == 'true' then
						Isweekend = true
					end
				end				

-- **********************************************************
				
				if (dayNow == 1 or dayNow == 2 or dayNow == 3 or dayNow == 4) and uservariables[var.holiday] == 0 then
					if input == 'false' then
						Isweekend = true
					end
				end
				
				if (dayNow == 1 or dayNow == 2 or dayNow == 3 or dayNow == 4) and uservariables[var.holiday] == 1 then
					if input == 'true' then
						Isweekend = true
					end
				end
				
				return Isweekend	
		end
	end

--
-- **********************************************************
-- Is it Xmas?
-- **********************************************************
-- Example: if xmasseason('true') then
--
	function xmasseason(input)
	
		input = input
		if input == 'true' or input == 'false' then
		IsXmas = false
			local tNow = os.date("*t")
			local xmas = tNow.yday
			
			if (xmas >= 6) and (xmas < 335) then
					if input == 'false' then
						IsXmas = true
					end
			end
			
			if (xmas >= 0) and (xmas < 6) then
			
					if input == 'true' then
						IsXmas = true
					end
			end
			
			if (xmas >= 335) and (xmas < 367) then
			
					if input == 'true' then
						IsXmas = true
					end
			end	 
			return IsXmas
		
		end
	end
	
--
-- **********************************************************
-- Blink Light IsNotDimmer
-- **********************************************************
-- Example: blink('light_living', 3)

	function blink(light, times)
	   times = times or 2
	   cmd1 = 'Off'
	   cmd2 = 'On'
	   pause = 7
	   if (otherdevices[light] == 'Off') then
		  cmd1 = 'On'
		  cmd2 = 'Off'
	   end   
	   for i = 1, times do
	   
		  commandArray[#commandArray+1]={[light]=cmd1..' AFTER '..pause }
		  pause = pause + 1
		  commandArray[#commandArray+1]={[light]=cmd2..' AFTER '..pause }
		  pause = pause + 1
	   end
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
-- Scrap Thermostat and outside temperatures
-- **********************************************************
-- Example: nesttemp_svalue('nest.room_temp') > 5

	function nesttemp_svalue(device)
		local thermostat = device	
		sNestTemp, sNestHumidity = otherdevices_svalues[thermostat]:match("([^;]+);([^;]+)")
		nest_temp = tonumber(sNestTemp)
		nest_hum = tonumber(sNestHumidity)	
		return nest_temp
	end
	
--
-- **********************************************************
-- Scrap Youless counter values
-- **********************************************************
-- Example: youless_svalue('youless.gas') > 1000

	function youless_svalue(device)
		device = device	
		sYoulessTotal, sYoulessUsage = otherdevices_svalues[device]:match("([^;]+);([^;]+)")
		youless_total = tonumber(sYoulessTotal)		
		youless_usage = tonumber(sYoulessUsage)	
		return youless_usage
	end
	
--
-- **********************************************************
-- Send Notification
-- **********************************************************
-- Example: sendmail('Hi','Coming home tonight')

	function sendmail(header,body)
		header = header
		body = body
		
		if header ~= nil and body ~= nil then
			commandArray['SendNotification']=''..header..'#'..body..''
		end
		
	end