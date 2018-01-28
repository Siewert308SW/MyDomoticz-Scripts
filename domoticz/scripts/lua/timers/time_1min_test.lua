--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ time_1min_test.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ Script for showing the calculated average lux between various lux sensors
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Switches
	local dummy1 = 'Dummy 1'	

	if otherdevices[dummy1] == 'Off'
	then
	commandArray[dummy1]='On FOR 30 SECONDS'	
		if dark('true') then
		print('')
		print('**********************************************************')
		print('Its dark outside')		
		print('Lux Living:'..living..'')
		print('Lux Hallway:'..hallway..'')
		print('Lux Upstairs:'..upstairs..'')
		print('------------------')
		print('Lux Average:'..lux_average..'')		
		elseif dark('false') then
		print('')
		print('**********************************************************')
		print('It aint dark outside')		
		print('Lux Living:'..living..'')
		print('Lux Hallway:'..hallway..'')
		print('Lux Upstairs:'..upstairs..'')
		print('------------------')
		print('Lux Average:'..lux_average..'')		
		else
		commandArray[dummy2]='On FOR 1'
		print('')
		print('**********************************************************') 
		print('Cant calculate lux average')
		print('Lux Living:'..living..'')
		print('Lux Hallway:'..hallway..'')
		print('Lux Upstairs:'..upstairs..'')
		print('------------------')
		print('Lux Average:'..lux_average..'')			
		end
	end