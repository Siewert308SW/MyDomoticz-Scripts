--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_time_triggers.lua
	@ author	: Siewert Lameijer
	@ since		: 01-01-2015
	@ Simple Lua time script to set a time trigger ON/OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
--  Set time selector according minute interval
-- **********************************************************
--

commandArray = {}

local m = os.date('%M')

if (m % 1 == 0) then
	commandArray[#commandArray+1]={["Time Trigger 1min"] = "On AFTER 5"}
end

if (m % 2 == 0) then
	commandArray[#commandArray+1]={["Lux Time Trigger"] = "On"}
	commandArray[#commandArray+1]={["Garage Temp Trigger"] = "On AFTER 10"}
end

if (m % 5 == 0) then
	commandArray[#commandArray+1]={["Time Trigger 5min"] = "On AFTER 30"}
	commandArray[#commandArray+1]={["Outside Temp Trigger"] = "On AFTER 20"}
end

return commandArray