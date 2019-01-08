--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_someonehome.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 08-01-2019
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
		or devicechanged[door.scullery]
		or devicechanged[window.living]
		or devicechanged[light.natalya_light_on]
		or devicechanged[light.natalya_reading_on]
		or devicechanged[motion_sensor.dinner1]
		or devicechanged[motion_sensor.dinner2])
		and otherdevices[someone.home] ~= 'Thuis'
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

-- *********************************************************************
-- *********************************************************************

	if devicechanged[door.living]
		and otherdevices[someone.home] ~= 'Thuis'
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) < timeout.minute1			
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

-- *********************************************************************
-- *********************************************************************

	
	if devicechanged[motion_sensor.living] == 'On'
		and otherdevices[someone.home] ~= 'Thuis'
	then

		if otherdevices[someone.home] == 'Slapen' then
			commandArray[someone.home]='Set Level 10 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_sleep.. ""]='On AFTER 5'
		end
		
		if otherdevices[someone.home] == 'Weg' then
			commandArray[someone.home]='Set Level 10 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='On AFTER 5'
		end
		
		if otherdevices[someone.home] == 'Off' then
			commandArray[someone.home]='Set Level 10 AFTER 1'
			commandArray["Variable:" .. var.living_light_override .. ""]= '0'
			commandArray["Group:" ..group.standy_killers_zwave_sleep.. ""]='On AFTER 5'
		end
		
	end	
	
--
-- *********************************************************************
-- SomeOneHome OFF when no sensor or device is triggered for x minutes
-- *********************************************************************
--

	if devicechanged[lux_sensor.living]  
		and otherdevices[someone.home] == 'Thuis'
		and media_powered('false')
		and laptops_online('false')
		and motion('false', 1800)
	then
	
		if phones_online('true')
			and motion('false', 3600)		
		then
			commandArray[someone.home]='Set Level 0'
		end
		
		if phones_online('false')			
			and motion('false', 1800)		
		then
			commandArray[someone.home]='Set Level 0'
		end
		
	end

--
-- *********************************************************************
-- SomeOneHome Away or Sleeping when no motion for x minutes
-- *********************************************************************
--

	if devicechanged[lux_sensor.living] 
		and otherdevices[someone.home] == 'Off'	
	then
	
		if otherdevices[someone.home] ~= 'Slapen'
			and media_powered('false')				
			and motion('false', 180)
			and phones_online('true')		
		then
			commandArray[someone.home]='Set Level 30'
			commandArray["Group:" ..group.standy_killers_zwave_sleep.. ""]='Off'
			commandArray["Group:" ..group.standy_killers_natalya.. ""]='Off AFTER 10'				
			commandArray["Scene:" ..scene.nobodyhome.. ""]='On AFTER 15 REPEAT 2 INTERVAL 15'			
		end

-- *********************************************************************
		
		if otherdevices[someone.home] ~= 'Weg'
			and media_powered('false')				
			and motion('false', 180)
			and phones_online('false')		
		then
			commandArray[someone.home]='Set Level 20'
			commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='Off'
			commandArray["Group:" ..group.standy_killers_natalya.. ""]='Off AFTER 10'			
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
			and motion('false', 43200)
		then
			commandArray[someone.home]='Set Level 20'
			commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='Off AFTER 5'
		end