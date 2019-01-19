--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_garden_motion.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 19-01-2019
	@ Script to switch garden light ON/OFF when IsDark and motion detected
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]	

--
-- **********************************************************
-- BackGarden light @ motion
-- **********************************************************
--

	if devicechanged[motion_sensor.porch] == 'On'
		and uservariables[var.garden_light_motion] == 0	
		and otherdevices[garden.shed_lights] == 'Off'
		and device_svalue(lux_sensor.porch) < lux_trigger.garden_low		
	then
		commandArray["Variable:" .. var.garden_light_motion .. ""]= '1'	
		commandArray[garden.shed_lights]='On'		
	end
	
--
-- **********************************************************
-- Frontdoor light ON @ motion
-- **********************************************************
--

	if devicechanged[door.front] == 'Open'
		and uservariables[var.frontgarden_light_motion] == 0	
		and otherdevices[garden.front_door_light] == 'Off'
		and device_svalue(lux_sensor.porch) < lux_trigger.garden_low
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) < timeout.minute1		
	then
		commandArray["Variable:" .. var.frontgarden_light_motion .. ""]= '1'	
		commandArray[garden.front_door_light]='Set Level 20'		
	end
	
--
-- **********************************************************
-- Front or Back garden light OFF @ no motion
-- **********************************************************
--

	if devicechanged[lux_sensor.hallway]
		and (uservariables[var.frontgarden_light_motion] == 1 or uservariables[var.garden_light_motion] == 1)	
	then
	
		if uservariables[var.frontgarden_light_motion] == 1
			and device_svalue(temp.porch) >= nest.trigger_frost_temp
			and timedifference(otherdevices_lastupdate[garden.front_door_light]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes3
		then
			commandArray["Variable:" .. var.frontgarden_light_motion .. ""]= '0'	
			commandArray[garden.front_door_light]='Off'	
		end
		
		if uservariables[var.garden_light_motion] == 1
			and device_svalue(temp.porch) >= nest.trigger_frost_temp
			and timedifference(otherdevices_lastupdate[garden.front_door_light]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes3
		then
			commandArray["Variable:" .. var.garden_light_motion .. ""]= '0'	
			commandArray[garden.shed_lights]='Off'	
		end

-- **********************************************************
-- **********************************************************

		if uservariables[var.frontgarden_light_motion] == 1
			and device_svalue(temp.porch) < nest.trigger_frost_temp
			and device_svalue(temp.porch) >= 0
			and timedifference(otherdevices_lastupdate[garden.front_door_light]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes5
		then
			commandArray["Variable:" .. var.frontgarden_light_motion .. ""]= '0'	
			commandArray[garden.front_door_light]='Off'	
		end
		
		if uservariables[var.garden_light_motion] == 1
			and device_svalue(temp.porch) < nest.trigger_frost_temp
			and device_svalue(temp.porch) >= 0			
			and timedifference(otherdevices_lastupdate[garden.front_door_light]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes5
		then
			commandArray["Variable:" .. var.garden_light_motion .. ""]= '0'	
			commandArray[garden.shed_lights]='Off'	
		end

-- **********************************************************
-- **********************************************************
		
		if uservariables[var.frontgarden_light_motion] == 1
			and device_svalue(temp.porch) < 0
			and timedifference(otherdevices_lastupdate[garden.front_door_light]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes10
		then
			commandArray["Variable:" .. var.frontgarden_light_motion .. ""]= '0'	
			commandArray[garden.front_door_light]='Off'	
		end
		
		if uservariables[var.garden_light_motion] == 1
			and device_svalue(temp.porch) < 0
			and timedifference(otherdevices_lastupdate[garden.front_door_light]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes10
			and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minutes10
		then
			commandArray["Variable:" .. var.garden_light_motion .. ""]= '0'	
			commandArray[garden.shed_lights]='Off'	
		end		
		
	end	

--
-- **********************************************************
-- Frontdoor or back garden light OFF when a phone leaves
-- **********************************************************
--
	
	if (devicechanged[phone.jerina] == 'Off' or devicechanged[phone.siewert] == 'Off' or devicechanged[phone.natalya] == 'Off' or devicechanged[phone.natalya_eth] == 'Off' or devicechanged[geo.jerina] == 'Off' or devicechanged[geo.siewert] == 'Off' or devicechanged[geo.natalya] == 'Off')
		and (uservariables[var.frontgarden_light_motion] == 1 or uservariables[var.garden_light_motion] == 1)
		and timedifference(otherdevices_lastupdate[garden.front_door_light]) >= timeout.minute1
		and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minute1
		and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minute1
		and timedifference(otherdevices_lastupdate[motion_sensor.porch]) >= timeout.minute1		
	then
	
		if uservariables[var.frontgarden_light_motion] == 1 then
			commandArray["Variable:" .. var.frontgarden_light_motion .. ""]= '0'	
			commandArray[garden.front_door_light]='Off'	
		end
		
		if uservariables[var.garden_light_motion] == 1 then
			commandArray["Variable:" .. var.garden_light_motion .. ""]= '0'	
			commandArray[garden.shed_lights]='Off'	
		end
		
	end

--
-- **********************************************************
-- Frontdoor light ON when DomoFence is activated 
-- **********************************************************
--
		if devicechanged[geo.siewert] == 'On' and otherdevices[phone.siewert] == 'Off'
			and uservariables[var.frontgarden_light_motion] == 0	
			and otherdevices[garden.front_door_light] == 'Off'
			and device_svalue(lux_sensor.porch) < lux_trigger.garden_low		
		then
			commandArray["Variable:" .. var.frontgarden_light_motion .. ""]= '2'	
			commandArray[garden.front_door_light]='Set Level 20'		
		end
		
		if devicechanged[geo.jerina] == 'On' and otherdevices[phone.jerina] == 'Off'
			and uservariables[var.frontgarden_light_motion] == 0	
			and otherdevices[garden.front_door_light] == 'Off'
			and device_svalue(lux_sensor.porch) < lux_trigger.garden_low		
		then
			commandArray["Variable:" .. var.frontgarden_light_motion .. ""]= '2'	
			commandArray[garden.front_door_light]='Set Level 20'		
		end
		
		if devicechanged[geo.natalya] == 'On' and otherdevices[phone.natalya] == 'Off' and otherdevices[phone.natalya_eth] == 'Off'
			and uservariables[var.frontgarden_light_motion] == 0	
			and otherdevices[garden.front_door_light] == 'Off'
			and device_svalue(lux_sensor.porch) < lux_trigger.garden_low		
		then
			commandArray["Variable:" .. var.frontgarden_light_motion .. ""]= '2'	
			commandArray[garden.front_door_light]='Set Level 20'		
		end

--
-- **********************************************************
-- Front or Back garden light OFF after no motion @ DomoFence detection
-- **********************************************************
--
	
	if devicechanged[lux_sensor.hallway]
		and uservariables[var.frontgarden_light_motion] == 2
		and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes20
		and timedifference(otherdevices_lastupdate[geo.siewert]) >= timeout.minutes20
		and timedifference(otherdevices_lastupdate[geo.jerina]) >= timeout.minutes20
		and timedifference(otherdevices_lastupdate[geo.natalya]) >= timeout.minutes20
	then
		commandArray["Variable:" .. var.frontgarden_light_motion .. ""]= '0'	
		commandArray[garden.front_door_light]='Off'	
	end	