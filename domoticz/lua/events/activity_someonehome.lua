--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_someonehome.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 24-03-2019
	@ Script for switching SomeOneHome ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- SomeOneHome
-- **********************************************************
--

	if (devicechanged[door.front]
		or devicechanged[door.back]
		or devicechanged[door.garden]
		or devicechanged[door.living]
		or devicechanged[door.scullery]
		or devicechanged[window.living]
		or devicechanged[light.natalya_light_on]
		or devicechanged[light.natalya_reading_on])
		and otherdevices[someone.home] ~= 'Thuis'
		and otherdevices[someone.home] ~= 'Douchen'
		and otherdevices[someone.home] ~= 'Off'		
	then
	
		if otherdevices[someone.home] == 'Slapen' then
			commandArray[someone.home]='Set Level 10 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_sleep.. ""]='On AFTER 5'
		end
		
		if otherdevices[someone.home] == 'Weg' then
			commandArray[someone.home]='Set Level 10 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='On AFTER 5'
		end
		
	end

	if devicechanged[door.living] == 'Open'
		and otherdevices[someone.home] ~= 'Thuis'
		and otherdevices[someone.home] ~= 'Douchen'
		and otherdevices[someone.home] == 'Off'		
	then
		commandArray[someone.home]='Set Level 10 AFTER 1'
		commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='On AFTER 5'	
	end	

--
-- *********************************************************************
-- SomeOneHome Away GeoFence based
-- *********************************************************************
--

	if (devicechanged[geophone.jerina] == 'Off' or devicechanged[geophone.siewert] == 'Off' or devicechanged[geophone.natalya] == 'Off')  
		and otherdevices[someone.home] == 'Thuis'
		and onlinedevices(findstring.geodevice) == 0
	then
		commandArray[someone.home]='Set Level 20 AFTER 1'
		commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='Off'		
		commandArray["Scene:" ..scene.nobodyhome.. ""]='On AFTER 15 REPEAT 2 INTERVAL 15'
	end	
	
--
-- *********************************************************************
-- SomeOneHome OFF when no sensor or device is triggered for x minutes
-- *********************************************************************
--

	if devicechanged[lux_sensor.hallway]  
		and otherdevices[someone.home] == 'Thuis'
		and motion('false', 1200)
	then
	
		if otherdevices[someone.home] ~= 'Slapen'
			and phones_online('true')
			and motion('false', 10800)			
		then
			commandArray[someone.home]='Set Level 30 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_sleep.. ""]='Off'				
			commandArray["Scene:" ..scene.nobodyhome.. ""]='On AFTER 15 REPEAT 2 INTERVAL 15'			
		end

-- *********************************************************************
		
		if otherdevices[someone.home] ~= 'Weg'
			and phones_online('false')
			and motion('false', 600)
			and geo('false')			
		then
			commandArray[someone.home]='Set Level 20 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='Off'		
			commandArray["Scene:" ..scene.nobodyhome.. ""]='On AFTER 15 REPEAT 2 INTERVAL 15'			
		end
		
	end

--
-- *********************************************************************
-- SomeOneHome Away or Sleeping when no motion for x minutes
-- *********************************************************************
--

	if devicechanged[lux_sensor.living] 
		and otherdevices[someone.home] == 'Off'	
		and motion('false', 300)
	then
	
		if otherdevices[someone.home] ~= 'Slapen'
			and phones_online('true')
			and motion('false', 300)
			and geo('true')			
		then
			commandArray[someone.home]='Set Level 30 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_sleep.. ""]='Off'			
			commandArray["Scene:" ..scene.nobodyhome.. ""]='On AFTER 15 REPEAT 2 INTERVAL 15'			
		end

-- *********************************************************************
		
		if otherdevices[someone.home] ~= 'Weg'
			and phones_online('false')
			and motion('false', 300)
			and geo('false')			
		then
			commandArray[someone.home]='Set Level 20 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='Off'		
			commandArray["Scene:" ..scene.nobodyhome.. ""]='On AFTER 15 REPEAT 2 INTERVAL 15'			
		end

	end
	
--
-- *********************************************************************
-- Switch sleep state to away when sleep state is ON longer then needed
-- *********************************************************************
--

		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Slapen'
			and phones_online('false')
			and geo('false')
			and motion('false', 3600)
		then
			commandArray[someone.home]='Set Level 20 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='Off'
		end
		