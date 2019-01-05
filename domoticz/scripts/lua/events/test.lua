--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ test.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 14-11-2018
	@ Global Lua script used for testing stuff
	and os.capture('date --date="0 days ago " +"%-d-%-m"', false) == 24-12
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

	if (devicechanged[test.dummy1] == 'On' or devicechanged[test.dummy2] == 'On') and otherdevices[light.kitchen_cabinet2] == 'Off' then
		commandArray[light.kitchen_cabinet2]='On'
	end
	if (devicechanged[test.dummy1] == 'Off' or devicechanged[test.dummy2] == 'Off') and otherdevices[light.kitchen_cabinet2] == 'On' then
		commandArray[light.kitchen_cabinet2]='Off'
	end
	
--[[
	if (devicechanged[test.dummy1] == 'On' or devicechanged[test.dummy2] == 'On') and otherdevices[light.toilet] == 'Off' then
		commandArray[light.toilet]='On'
		print('AAN')
	end
	if (devicechanged[test.dummy1] == 'Off' or devicechanged[test.dummy2] == 'Off') and otherdevices[light.toilet] == 'On' then
		commandArray[light.toilet]='Off'
		print('UIT')
	end
--]]

