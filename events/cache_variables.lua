--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 30min"}) then return end

--
-- *********************************************************************
-- Cache various variables
-- *********************************************************************
--

--[[ Cache Sunset/Sunrise ]]--
	
	if devicechanged["Time Trigger 30min"] == 'On'
		and uservariables["suntime_override"] == 0
		and timebetween("00:00:00","01:30:00")
	then
		switchDevice("Variable:suntime_override", "1")
		sunTimeCache("sunsetEarly")
		sunTimeCache("sunsetLate")
		sunTimeCache("sunset")
		sunTimeCache("sunriseEarly")
		sunTimeCache("sunriseLate")
		sunTimeCache("sunrise")
	end

	if devicechanged["Time Trigger 30min"] == 'Off'
		and uservariables["suntime_override"] == 1
		and timebetween("01:30:00","02:30:00")
	then
		switchDevice("Variable:suntime_override", "0")
	end
	