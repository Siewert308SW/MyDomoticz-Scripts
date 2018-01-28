--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom_away.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ Script to switch ON/OFF Away light scene when nobody at home
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- Twilight Scene ON when IsDark
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and dark('true')		
		and otherdevices[light.living_twilight_tv] == 'Off'
		and otherdevices[someone.home] == 'Weg'			
		and timebetween("16:00:00","22:30:00")	 
	then
		commandArray["Scene:" ..group.nobodyhome.. ""]='On REPEAT 2 INTERVAL 5'			
	end

--
-- **********************************************************
-- Twilight Scene OFF when lux is higher then threshold
-- **********************************************************
--

	if devicechanged[lux_sensor.living]
		and dark('false')		
		and otherdevices[light.living_twilight_tv] ~= 'Off' 
	then
		commandArray["Scene:" ..group.nobodyhome.. ""]='Off REPEAT 2 INTERVAL 5'
	end	

--
-- **********************************************************
-- Twilight Scene OFF when it's time
-- **********************************************************
--

	if devicechanged[lux_sensor.living] 
		and otherdevices[light.living_twilight_tv] ~= 'Off'
		and otherdevices[someone.home] == 'Weg'		
		and timebetween("23:00:00","23:59:00")
		and weekend('false')		
	then
		commandArray["Scene:" ..group.nobodyhome.. ""]='Off REPEAT 2 INTERVAL 5'		
	end
	
	if devicechanged[lux_sensor.living] 
		and otherdevices[light.living_twilight_tv] ~= 'Off'
		and otherdevices[someone.home] == 'Weg'		
		and timebetween("23:50:00","23:59:00")
		and weekend('true')		
	then
		commandArray["Scene:" ..group.nobodyhome.. ""]='Off REPEAT 2 INTERVAL 5'		
	end