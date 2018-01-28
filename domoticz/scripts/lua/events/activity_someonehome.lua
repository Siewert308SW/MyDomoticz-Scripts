--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_someonehome.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ Script for switching SomeOneHome ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- SomeOneHome ON
-- **********************************************************
--

	if motion_detected and (otherdevices[someone.home] == 'Slapen' or otherdevices[someone.home] == 'Weg') then
		commandArray[someone.home]='Set Level 10 AFTER 1'	
		if otherdevices[plug.tvcorner] == 'Off' then
		commandArray["Group:" ..group.standy_killers_zwave.. ""]='On'		
		commandArray["Group:" ..group.standy_killers_433mhz.. ""]='On AFTER 10 REPEAT 3 INTERVAL 5'
		end
	end
	
	if devicechanged[motion_sensor.living] == 'On' and otherdevices[someone.home] == 'Off' then
		commandArray[someone.home]='Set Level 10 AFTER 1'		
		if otherdevices[plug.tvcorner] == 'Off' then
		commandArray["Group:" ..group.standy_killers_zwave.. ""]='On'		
		commandArray["Group:" ..group.standy_killers_433mhz.. ""]='On AFTER 10 REPEAT 3 INTERVAL 5'
		end
	end	
	
	if lightswitchON and (otherdevices[someone.home] == 'Slapen' or otherdevices[someone.home] == 'Weg' or otherdevices[someone.home] == 'Off') then
		commandArray[someone.home]='Set Level 10 AFTER 1'		
		if otherdevices[plug.tvcorner] == 'Off' then
		commandArray["Group:" ..group.standy_killers_zwave.. ""]='On'		
		commandArray["Group:" ..group.standy_killers_433mhz.. ""]='On AFTER 10 REPEAT 3 INTERVAL 5'
		end
	end
	
	if devicechanged[switch.living_light] == 'Off' and otherdevices[someone.home] == 'Thuis' then
		commandArray[someone.home]='Set Level 0 AFTER 15'		
	end	
	
--
-- **********************************************************
-- SomeOneHome Away/Sleep
-- **********************************************************
--

	if devicechanged[someone.home] == 'Weg' or devicechanged[someone.home] == 'Slapen' or devicechanged[someone.home] == 'Vakantie' then	 commandArray["Group:" ..group.standy_killers_zwave.. ""]='Off'		
		commandArray["Group:" ..group.standy_killers_433mhz.. ""]='Off AFTER 10 REPEAT 3 INTERVAL 5'
	end	

--
-- *********************************************************************
-- someone.home OFF when no sensor or device is triggered for x minutes
-- *********************************************************************
--
	
	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Thuis'
		and otherdevices[phone.switch] == 'Off'
		and media_powered('false')
		and laptops_powered('false')	
		and motion('false', 300)
	then
		commandArray[someone.home]='Set Level 20 AFTER 1'
	end
	
	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Thuis'
		and otherdevices[phone.switch] == 'On'	
		and media_powered('false')
		and laptops_powered('false')	
		and motion('false', 3600)
	then	
		commandArray[someone.home]='Set Level 0 AFTER 1'
	end

--
-- *********************************************************************
-- NoBodyHome when no sensor or device is triggered for x minutes
-- *********************************************************************
--
	
	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Off'		
		and otherdevices[phone.switch] == 'Off'
		and media_powered('false')
		and laptops_powered('false')	
		and motion('false', 300)
	then	
		commandArray[someone.home]='Set Level 20 AFTER 1'		
	end
	
	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Off'		
		and otherdevices[phone.switch] == 'On'
		and media_powered('false')
		and laptops_powered('false')	
		and motion('false', 300)
	then	
		commandArray[someone.home]='Set Level 30 AFTER 1'		
	end

--
-- *********************************************************************
-- Switch sleep to away when sleeping is On longer then needed
-- *********************************************************************
--	

	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Slapen'
		and otherdevices[phone.switch] == 'Off'	
		and motion('false', 43200)
	then	
		commandArray[someone.home]='Set Level 30 AFTER 1'		
	end

--
-- *********************************************************************
-- Switch Away to Holiday when Away is On longer then needed
-- *********************************************************************
--	

	if devicechanged[lux_sensor.living]
		and otherdevices[someone.home] == 'Weg'
		and otherdevices[phone.switch] == 'Off'	
		and motion('false', 43200)
	then	
		commandArray[someone.home]='Set Level 40 AFTER 1'		
	end	