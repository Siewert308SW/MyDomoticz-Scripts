--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_someonehome.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-13-2018
	@ Script for switching SomeOneHome ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- SomeOneHome ON
-- **********************************************************
--

	if (devicechanged[door.living]
		or devicechanged[door.front]
		or devicechanged[door.back]
		or devicechanged[door.garden]
		or devicechanged[door.scullery]
		or devicechanged[window.living]
		or devicechanged[switch.dinner_light] == 'On'
		or devicechanged[switch.living_light] == 'On')
		and (otherdevices[someone.home] == 'Slapen' or otherdevices[someone.home] == 'Weg') 
	then
		commandArray[someone.home]='Set Level 10 AFTER 1'
	end

-- *********************************************************************
	
	if (devicechanged[motion_sensor.living] == 'On'
		or devicechanged[switch.living_light] == 'On'
		or devicechanged[switch.dinner_light] == 'On')
		and otherdevices[someone.home] == 'Off'
	then
		commandArray[someone.home]='Set Level 10 AFTER 1'
	end
	
--
-- *********************************************************************
-- SomeOneHome OFF when light switch toggled OFF
-- *********************************************************************
--
	
	if devicechanged[switch.living_light] == 'Off' and otherdevices[someone.home] ~= 'Off' then
		commandArray[someone.home]='Set Level 0 AFTER 1'		
	end
	
--
-- *********************************************************************
-- SomeOneHome OFF when no sensor or device is triggered for x minutes
-- *********************************************************************
--

	if devicechanged[lux_sensor.living] then

		if otherdevices[someone.home] == 'Thuis'
			and otherdevices[phone.switch] == 'Off'
			and media_powered('false')
			and laptops_powered('false')	
			and motion('false', 300)
		then
			commandArray[someone.home]='Set Level 20 AFTER 1'
		end

-- *********************************************************************
		
		if otherdevices[someone.home] == 'Thuis'
			and otherdevices[phone.switch] == 'On'	
			and media_powered('false')
			and laptops_powered('false')	
			and motion('false', 3600)
		then	
			commandArray[someone.home]='Set Level 30 AFTER 1'
		end
		
--
-- *********************************************************************
-- SomeOneHome OFF when no sensor or device is triggered for x minutes
-- *********************************************************************
--	

		if otherdevices[someone.home] == 'Off'
			and otherdevices[phone.switch] == 'Off'
			and media_powered('false')
			and laptops_powered('false')	
			and motion('false', 180)
		then
			commandArray[someone.home]='Set Level 20 AFTER 1'
		end

-- *********************************************************************
		
		if otherdevices[someone.home] == 'Off'
			and otherdevices[phone.switch] == 'On'
			and media_powered('false')
			and laptops_powered('false')	
			and motion('false', 180)
		then
			commandArray[someone.home]='Set Level 30 AFTER 1'
		end		

--
-- *********************************************************************
-- Switch sleep state to away when sleep state is ON longer then needed
-- *********************************************************************
--

		if otherdevices[someone.home] == 'Slapen'
			and media_powered('false')
			and laptops_powered('false')	
			and motion('false', 43200)
			and (otherdevices[phone.switch] == 'On' or otherdevices[phone.switch] == 'Off')
		then
			commandArray[someone.home]='Set Level 20 AFTER 1'
		end
		
	end	