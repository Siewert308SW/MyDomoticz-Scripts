--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ functions.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ All global functions needed
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Function to execute os commands and get output
-- **********************************************************
--

	function os.capture(cmd, raw)
		
		local f = assert(io.popen(cmd, 'r'))
		local s = assert(f:read('*a'))
		f:close()
		if raw then return s end
		s = string.gsub(s, '^%s+', '')
		s = string.gsub(s, '%s+$', '')
		s = string.gsub(s, '[\n\r]+', ' ')
		return s

	end	
	
--
-- **********************************************************
-- Time Difference
-- **********************************************************
--

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
--

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
-- Check for motion in home overall for specific time (seconds)
-- **********************************************************
-- example: if motion('true', 600) then
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
					and timedifference(otherdevices_lastupdate[motion_sensor.living]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) > minutes		
					and timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.toilet]) > minutes
					and timedifference(otherdevices_lastupdate[phone.switch]) > minutes
					and timedifference(otherdevices_lastupdate[laptop.switch]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.dinner1]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.dinner2]) > minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.kitchen]) > minutes				
					and timedifference(otherdevices_lastupdate[someone.home]) > minutes
				then
					IsMotion = true
				end	
			end
		
			if input == 'true' then
				if timedifference(otherdevices_lastupdate[door.living]) < minutes
					or timedifference(otherdevices_lastupdate[door.front]) < minutes
					or timedifference(otherdevices_lastupdate[door.back]) < minutes
					or timedifference(otherdevices_lastupdate[door.garden]) < minutes
					or timedifference(otherdevices_lastupdate[door.scullery]) < minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.living]) < minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.downstairs]) < minutes		
					or timedifference(otherdevices_lastupdate[motion_sensor.upstairs]) < minutes
					or timedifference(otherdevices_lastupdate[motion_sensor.toilet]) < minutes
					or timedifference(otherdevices_lastupdate[phone.switch]) < minutes
					or timedifference(otherdevices_lastupdate[laptop.switch]) < minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.dinner1]) < minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.dinner2]) < minutes
					and timedifference(otherdevices_lastupdate[motion_sensor.kitchen]) < minutes				
					or timedifference(otherdevices_lastupdate[someone.home]) < minutes
				then
					IsMotion = true
				end	
			end		
		
		return IsMotion
		end
	end	
		
--
-- **********************************************************
-- Media PowerUsage
-- **********************************************************
-- example: if media_powered('true') then
--

	function media_powered(input)
		input = input
		if input == 'true' or input == 'false' then
		IsMediaPowered = false
		
		if powerusage(watt.tvcorner) > watt.media_usage or powerusage(watt.natalya) > watt.media_usage then
			if input == 'true' then
				IsMediaPowered = true
			end	
		end
		
		if powerusage(watt.tvcorner) <= watt.media_usage and powerusage(watt.natalya) <= watt.media_usage then
			if input == 'false' then
				IsMediaPowered = true
			end	
		end		
		return IsMediaPowered		
		end
	end

--
-- **********************************************************
-- Media ON? if on then do certain light scene
-- **********************************************************
-- example: if media('true') then
--

	function media(input)
		input = input
		if input == 'true' or input == 'false' then
		IsMedia = false
		
		if powerusage(watt.tvcorner) > watt.media_usage or powerusage(watt.siewert) > watt.media_usage or powerusage(watt.jerina) > watt.media_usage then
			if input == 'true' then
				IsMedia = true
			end	
		end
		
		if powerusage(watt.tvcorner) <= watt.media_usage and powerusage(watt.siewert) <= watt.media_usage and powerusage(watt.jerina) <= watt.media_usage then
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
-- example: if laptops_powered('true') then
--

	function laptops_powered(input)
		input = input
		if input == 'true' or input == 'false' then
		IsLaptopPower = false
		
		if powerusage(watt.siewert) > watt.media_usage or powerusage(watt.jerina) > watt.media_usage then
			if input == 'true' then
				IsLaptopPower = true
			end	
		end
		
		if powerusage(watt.siewert) <= watt.media_usage and powerusage(watt.jerina) <= watt.media_usage then
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
-- example: if weekend('true') then
-- weekday [0-6 = Sunday-Saturday]
--

	function weekend(input)
		input = input
		if input == 'true' or input == 'false' then
		Isweekend = false
			local dayNow = tonumber(os.date("%w"))
				if (dayNow == 5) or (dayNow == 6) or (dayNow == 0) then
					 if (input == 'true') then
						Isweekend = true
					 end
				end
				
				if (dayNow == 1) or (dayNow == 2) or (dayNow == 3) or (dayNow == 4) then
					if (input == 'false') then
						Isweekend = true
					end
				end
				return Isweekend	
		end
	end
	
--
-- **********************************************************
-- Get lux threshold IsDark or IsDay
-- **********************************************************
-- Example: if dark('true') then

	function dark(dark, lux)
		dark = dark
		lux = lux

	-- Define Max/Min Lux threshold	as default when no lux is set
		local lux_threshold		= 4

	-- Get Lux Value	
		living = tonumber(otherdevices_svalues[lux_sensor.living])	
		hallway = tonumber(otherdevices_svalues[lux_sensor.hallway])
		upstairs = tonumber(otherdevices_svalues[lux_sensor.upstairs])

	-- Create table (take in count hallway light ON/OFF to avoid false readings)
	-- For now until i have a outside lux sensor i use two lights to overrule the lux reading as they increase the threshold
	
		if otherdevices[light.living_wall_lights] == 'Off' and otherdevices[light.living_twilight] == 'Off' then
			sensors={living, hallway, upstairs}
		end
		
		if otherdevices[light.living_wall_lights] ~= 'Off' or otherdevices[light.living_twilight] ~= 'Off' then
			sensors={1, 0, 0}
		end
		
		--[[
		if (living <= hallway or living <= upstairs) and living > 9 and (hallway >= 15 or upstairs >= 3) then
		sensors={living, hallway, upstairs}
		
		elseif (living <= hallway or living <= upstairs) and living <= 9 and (hallway >= 15 or upstairs >= 3) then
		sensors={living, 2, 1}
		
		elseif (living > hallway and living > upstairs) and living > 9 and (hallway >= 15 or upstairs >= 3) then
		sensors={living, hallway, upstairs}

		elseif (living > hallway and living > upstairs) and living < 9 and (hallway < 15 and upstairs < 3) then
		sensors={living, hallway, upstairs}

		elseif (living > hallway and living > upstairs) and living > 2 and (hallway == 0 and upstairs == 0) then
		sensors={living, hallway, upstairs}				
		
		elseif living == hallway and living == upstairs then
		sensors={living, hallway, upstairs}
		
		else
		sensors={living, hallway, upstairs}		
		end
		--]]
		
	-- Lux_threshold		
		
		if lux ~= nil then
		lux_threshold = lux
		else
		lux_threshold = lux_threshold
		end		

	-- Calculate Average		
		local elements = 0
		local sum = 0
		--local lux_average = 0
			
		for k,v in pairs(sensors) do
			sum = sum + v
			elements = elements + 1
		end
	 
		lux_average = sum / elements

		
	-- Get Sunset
		sunset=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet' | grep 'Sunset' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
		sunset = tostring(""..sunset..":00")

	-- Get Sunrise
		sunrise=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=command&param=getSunRiseSet' | grep 'Sunrise' | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
		sunrise = tostring(""..sunrise..":00")
		
		
	--IsDark_Dawn
		if timebetween("00:00:00",""..sunrise.."")
		and lux_average > lux_threshold
		then
		threshold = 0
		end
		
		if timebetween("00:00:00",""..sunrise.."")
		and lux_average <= lux_threshold
		then
		threshold = 1
		end

	--IsDay_Morning		
		if timebetween(""..sunrise.."","11:59:59")
		and lux_average > lux_threshold				
		then
		threshold = 0
		end
		
		if timebetween(""..sunrise.."","11:59:59")
		and lux_average <= lux_threshold				
		then
		threshold = 1				
		end

	--IsDay_Afternoon		
		if timebetween("12:00:00",""..sunset.."")
		and lux_average > lux_threshold			
		then
		threshold = 0
		end
		
		if timebetween("12:00:00",""..sunset.."")
		and lux_average <= lux_threshold			
		then
		threshold = 1		
		end

	--IsDark_Dusk		
		if timebetween(""..sunset.."","23:59:59")
		and lux_average > lux_threshold
		then
		threshold = 0
		end
		
		if timebetween(""..sunset.."","23:59:59")
		and lux_average <= lux_threshold
		then
		threshold = 1
		end
					
		isdark = false
					
		if threshold == 1 and dark == 'true' then
		isdark = true
		end
		
		if threshold == 0 and dark == 'false' then
		isdark = true
		end
		return isdark	
				
	end