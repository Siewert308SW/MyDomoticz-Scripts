--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 5min"}) then return end

--
-- *********************************************************************
-- Cache various variables
-- *********************************************************************
--

--[[ Cache Sunset/Sunrise ]]--
	
	if devicechanged["Time Trigger 5min"] == 'On'
		and uservariables["suntime_override"] == 0
		and timebetween("00:00:00","00:30:00")
	then
		switchDevice("Variable:suntime_override", "1")
		sunTimeCache("sunsetEarly")
		sunTimeCache("sunsetLate")
		sunTimeCache("sunset")
		sunTimeCache("sunriseEarly")
		sunTimeCache("sunriseLate")
		sunTimeCache("sunrise")
	end

	if devicechanged["Time Trigger 5min"] == 'Off'
		and uservariables["suntime_override"] == 1
		and timebetween("00:30:00","01:00:00")
	then
		switchDevice("Variable:suntime_override", "0")
	end
	