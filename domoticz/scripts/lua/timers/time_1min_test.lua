--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ time_xmin_test.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: x-xx-xxxx
	@ Script for testing various trail and errors
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Switches
	local dummy1 = 'Dummy 1'	

	if otherdevices[dummy1] == 'Off'
	then
	commandArray[dummy1]='On FOR 30 SECONDS'
	
--
-- **********************************************************
-- Print average Lux calculated by function (dark)
-- **********************************************************
--

if lua.verbose == "true" then	
		if dark('true', 5) then
		print('')
		print('**********************************************************')
		print('Its dark outside')
		print('Lux Living:'..living..'')
		print('Lux Hallway:'..hallway..'')
		print('Lux Upstairs:'..upstairs..'')
		print('Lux Veranda:'..veranda..'')		
		print('------------------')
		print('Lux Average:'..lux_average..'')		
		elseif dark('false', 5) then
		print('')
		print('**********************************************************')
		print('It aint dark outside')		
		print('Lux Living:'..living..'')
		print('Lux Hallway:'..hallway..'')
		print('Lux Upstairs:'..upstairs..'')
		print('Lux Veranda:'..veranda..'')		
		print('------------------')
		print('Lux Average:'..lux_average..'')			
		end
	end
end
	