--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_someone_leaving.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-25-2018
	@ Script to switch Garden Lights when OFF and someone is leaving the house
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- Some one left via the livingroom true the door.front
-- **********************************************************
--

	if devicechanged[door.front] == 'Open' 
		and otherdevices[door.back] == 'Closed'
		and otherdevices[garden.shed_lights] == 'Off'
		and device_svalue(lux_sensor.porch) == 0
		and uservariables[var.leaving_override] == 0
		and (timedifference(otherdevices_lastupdate[motion_sensor.hallway]) < timeout.seconds30 
		or otherdevices[motion_sensor.hallway] == 'On')	
	then
		commandArray["Variable:" .. var.leaving_override .. ""]= '1'		
		commandArray["Group:" ..group.garden_lights_leaving.. ""]='On AFTER 1 REPEAT 3 INTERVAL 3'		
	end

--
-- **********************************************************
-- Some one left via door.back
-- **********************************************************
--

	if devicechanged[door.back] == 'Open' 
		and otherdevices[door.front] == 'Closed'	
		and otherdevices[garden.shed_lights] == 'Off'
		and device_svalue(lux_sensor.porch) == 0
		and uservariables[var.leaving_override] == 0
		and timedifference(otherdevices_lastupdate[door.scullery]) < timeout.minute1		
	then
		commandArray["Variable:" .. var.leaving_override .. ""]= '1'
		commandArray["Group:" ..group.garden_lights_leaving.. ""]='On AFTER 1 REPEAT 3 INTERVAL 3'	
	end

--
-- **********************************************************
-- Some one came back via door.back
-- **********************************************************
--

	if devicechanged[door.scullery] == 'Closed' 
		and otherdevices[door.front] == 'Closed' 
		and otherdevices[door.back] == 'Closed' 
		and uservariables[var.leaving_override] == 1
		and timedifference(otherdevices_lastupdate[door.back]) < timeout.minutes2		
	then
		commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off AFTER 5 REPEAT 3 INTERVAL 3'
		commandArray["Variable:" .. var.leaving_override .. ""]= '0'	
	end

--
-- **********************************************************
-- Some one opened the sliding door
-- **********************************************************
--

	if devicechanged[door.garden] == 'Open' 
		and otherdevices[door.back] == 'Closed'
		and otherdevices[door.front] == 'Closed'	
		and otherdevices[garden.shed_lights] == 'Off'
		and device_svalue(lux_sensor.porch) == 0
		and uservariables[var.leaving_override] == 0
	then	
		commandArray["Variable:" .. var.leaving_override .. ""]= '1'		
		commandArray[garden.shed_lights]='On AFTER 1 REPEAT 3 INTERVAL 3'		
	end

	if devicechanged[door.garden] == 'Closed' 
		and otherdevices[door.front] == 'Closed' 
		and otherdevices[door.back] == 'Closed' 
		and uservariables[var.leaving_override] == 1	
	then
		commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off AFTER 15 REPEAT 3 INTERVAL 3'
		commandArray["Variable:" .. var.leaving_override .. ""]= '0'	
	end

--
-- **********************************************************
-- Garden lights OFF When some one left
-- **********************************************************
--
--[[
	if (devicechanged[phone.jerina] == 'Off' or devicechanged[phone.siewert] == 'Off' or devicechanged[phone.natalya] == 'Off')
		and uservariables[var.leaving_override] == 1	
	then
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off REPEAT 3 INTERVAL 5'
			commandArray["Variable:" .. var.leaving_override .. ""]= '0'
	end
--]]

--
-- **********************************************************
-- Garden lights OFF When some one left, taking in count outside temp
-- **********************************************************
--

	if devicechanged[lux_sensor.living] then
	
		if uservariables[var.leaving_override] == 1
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minute1
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minute1
			and timedifference(otherdevices_lastupdate[door.back]) >= timeout.minute1
			and timedifference(otherdevices_lastupdate[phone.jerina]) >= timeout.minute1
			and timedifference(otherdevices_lastupdate[phone.siewert]) >= timeout.minute1
			and timedifference(otherdevices_lastupdate[phone.natalya]) >= timeout.minute1
			and device_svalue(temp.porch) > 15
		then
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off AFTER 1 REPEAT 3 INTERVAL 3'
			commandArray["Variable:" .. var.leaving_override .. ""]= '0'		
		end
	
-- **********************************************************

		if uservariables[var.leaving_override] == 1
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes2
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes2
			and timedifference(otherdevices_lastupdate[door.back]) >= timeout.minutes2
			and timedifference(otherdevices_lastupdate[phone.jerina]) >= timeout.minutes2
			and timedifference(otherdevices_lastupdate[phone.siewert]) >= timeout.minutes2
			and timedifference(otherdevices_lastupdate[phone.natalya]) >= timeout.minutes2
			and device_svalue(temp.porch) <= 15
			and device_svalue(temp.porch) > 5		
		then
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off AFTER 1 REPEAT 3 INTERVAL 3'
			commandArray["Variable:" .. var.leaving_override .. ""]= '0'		
		end

-- **********************************************************

		if uservariables[var.leaving_override] == 1
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[door.back]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[phone.jerina]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[phone.siewert]) >= timeout.minutes3
			and timedifference(otherdevices_lastupdate[phone.natalya]) >= timeout.minutes3
			and device_svalue(temp.porch) <= 5
			and device_svalue(temp.porch) > 1		
		then
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off AFTER 1 REPEAT 3 INTERVAL 3'
			commandArray["Variable:" .. var.leaving_override .. ""]= '0'		
		end

-- **********************************************************

		if uservariables[var.leaving_override] == 1
			and timedifference(otherdevices_lastupdate[garden.shed_lights]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[door.front]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[door.back]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[phone.jerina]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[phone.siewert]) >= timeout.minutes5
			and timedifference(otherdevices_lastupdate[phone.natalya]) >= timeout.minutes5			
			and device_svalue(temp.porch) <= 1		
		then
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off AFTER 1 REPEAT 3 INTERVAL 3'
			commandArray["Variable:" .. var.leaving_override .. ""]= '0'		
		end
	end	