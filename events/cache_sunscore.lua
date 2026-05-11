--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 30min"}) then return end

--
-- *********************************************************************
-- Cache SunScore Tomorrow
-- *********************************************************************
--

	if devicechanged["Time Trigger 30min"] == 'On'
		and uservariables["sunscore_override"] == 0
		and timebetween(sunTime("sunrise"),"23:59:59")
	then

-- === Instellingen
	local LAT = "53.30261"
	local LON = "6.60988"
	local TZ  = "Europe/Amsterdam"

	local VAR_SUNSHINE_MIN_TOMORROW = "SunshineMinTomorrow"   -- maak aan als User Variable (Integer)
	local VAR_SOLAR_SUM_TOMORROW    = "SolarSumTomorrow"      -- maak aan als User Variable (Float)
	local VAR_SUN_SCORE_TOMORROW    = "SunScoreTomorrow"      -- maak aan als User Variable (Integer 0-100)

	  local url = "https://api.open-meteo.com/v1/forecast"
		  .. "?latitude=" .. LAT
		  .. "&longitude=" .. LON
		  .. "&daily=sunshine_duration,shortwave_radiation_sum,cloudcover_mean"
		  .. "&forecast_days=2"
		  .. "&timezone=" .. TZ

  -- curl ophalen
	  local cmd = 'curl -s "' .. url .. '"'
	  local handle = io.popen(cmd)
	  local body = handle:read("*a")
	  handle:close()

	  if (body == nil or body == "") then
		print("Zonvoorspelling: geen response")
		return commandArray
	  end

  -- JSON decode via Domoticz json.lua (pure Lua)
	  local JSON = assert(loadfile("/opt/domoticz/userdata/scripts/lua/JSON.lua"))()
	  local data, err = JSON:decode(body)

	  if (data == nil) then
		print("Zonvoorspelling: JSON decode faalde: " .. tostring(err))
		return commandArray
	  end

  -- daily arrays starten bij "vandaag" -> morgen is index 2 (Lua is 1-based)
	  local iTomorrow = 2

	  local sunshine_sec = data.daily and data.daily.sunshine_duration and data.daily.sunshine_duration[iTomorrow] or nil
	  local solar_sum    = data.daily and data.daily.shortwave_radiation_sum and data.daily.shortwave_radiation_sum[iTomorrow] or nil
	  local cloud_mean   = data.daily and data.daily.cloudcover_mean and data.daily.cloudcover_mean[iTomorrow] or nil

	  if (sunshine_sec == nil or solar_sum == nil) then
		print("Zonvoorspelling: ontbrekende daily waarden")
		return commandArray
	  end

	  local sunshine_min = math.floor((sunshine_sec / 60) + 0.5)

  -- Maak een simpele “zon-score” 0..100 (tweak drempels naar jouw smaak)
  -- sunshine: 0..600 min -> 0..60 punten
	local scoreSun = math.max(0, math.min(60, math.floor((sunshine_min / 600) * 60 + 0.5)))
  -- cloudcover_mean: 0..100% -> 40..0 punten
	  local scoreCloud = 20
	  if (cloud_mean ~= nil) then
		scoreCloud = math.max(0, math.min(40, math.floor((100 - cloud_mean) * 0.4 + 0.5)))
	  end
	  local score = scoreSun + scoreCloud
	  if (score > 100) then score = 100 end

  -- Schrijf naar Domoticz user variables

	--if uservariables["SunScoreTomorrow"] < score then
	  commandArray["Variable:" .. VAR_SUNSHINE_MIN_TOMORROW] = tostring(sunshine_min)
	  commandArray["Variable:" .. VAR_SOLAR_SUM_TOMORROW]    = tostring(solar_sum)
	  commandArray["Variable:" .. VAR_SUN_SCORE_TOMORROW]    = tostring(score)
	  commandArray[#commandArray+1] = { ["UpdateDevice"] = "6365|0|" .. score }
	--end
	  
	if uservariables["sunscore_override"] == 0
		and timebetween(sunTime("sunsetEarly"),"23:59:59")
	then
	  switchDevice("Variable:sunscore_override", "1")	
	end
	 -- print(string.format("Zon morgen: %d min, solar_sum=%s, cloud=%s, score=%d",
		--	sunshine_min, tostring(solar_sum), tostring(cloud_mean), score))
	end


--
-- *********************************************************************
-- Reset SunScore Tomorrow Variable
-- *********************************************************************
--

	if devicechanged["Time Trigger 30min"] == 'Off'
		and uservariables["sunscore_override"] == 1
		and timebetween("00:00:00",sunTime("sunrise"))
	then
		switchDevice("Variable:sunscore_override", "0")
	end