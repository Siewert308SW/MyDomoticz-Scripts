--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_heos.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 17-01-2019
	@ Simple Lua script to turn HEOS Speaker OFF

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	if devicechanged[media_device.tv] == 'On' or devicechanged[someone.home] == 'Off' then
	heos('stop')
	end
	
	if devicechanged[timed.trigger] and powerusage(watt.tvcorner) >= watt.tvcorner_usage and otherdevices[media_device.tv] == 'Off' then
	heos('stop')
	end
