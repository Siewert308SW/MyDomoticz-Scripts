--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_someone_leaving.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-4-2018
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
		and otherdevices[garden.shed_lights]   == 'Off'
		and dark('true', 2)	
		and uservariables[var.leaving_override] == 0
		and timedifference(otherdevices_lastupdate[motion_sensor.hallway]) < timeout.seconds45	
	then
			commandArray["Variable:" .. var.leaving_override .. ""]= '1'		
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='On AFTER 1 REPEAT 3 INTERVAL 10'		
	end

--
-- **********************************************************
-- Some one left via door.back
-- **********************************************************
--

	if devicechanged[door.back] == 'Open' 
		and otherdevices[door.front] == 'Closed'	
		and otherdevices[garden.shed_lights]   == 'Off'
		and dark('true', 2)	
		and uservariables[var.leaving_override] == 0
		and timedifference(otherdevices_lastupdate[door.scullery]) < timeout.seconds45		
	then
			commandArray["Variable:" .. var.leaving_override .. ""]= '1'
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='On AFTER 1 REPEAT 3 INTERVAL 10'	
	end

--
-- **********************************************************
-- Some one came back via door.back
-- **********************************************************
--

	if  devicechanged[door.scullery] == 'Closed' 
		and otherdevices[door.front] == 'Closed' 
		and otherdevices[door.back] == 'Closed' 
		and uservariables[var.leaving_override] == 1	
	then
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off AFTER 5 REPEAT 3 INTERVAL 5'
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
		and otherdevices[garden.shed_lights]   == 'Off'
		and dark('true', 2)	
		and uservariables[var.leaving_override] == 0
	then	
			commandArray["Variable:" .. var.leaving_override .. ""]= '1'		
			commandArray[garden.shed_lights]='On AFTER 1 REPEAT 3 INTERVAL 1'		
	end

	if  devicechanged[door.garden] == 'Closed' 
		and otherdevices[door.front] == 'Closed' 
		and otherdevices[door.back] == 'Closed' 
		and uservariables[var.leaving_override] == 1	
	then
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off AFTER 15 REPEAT 3 INTERVAL 5'
			commandArray["Variable:" .. var.leaving_override .. ""]= '0'	
	end

--
-- **********************************************************
-- Garden lights OFF When some one left
-- **********************************************************
--

	if (devicechanged[phone.jerina] == 'Off' or devicechanged[phone.siewert] == 'Off' or devicechanged[phone.natalya] == 'Off')
		and uservariables[var.leaving_override] == 1	
	then
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off REPEAT 3 INTERVAL 5'
			commandArray["Variable:" .. var.leaving_override .. ""]= '0'
	end

--
-- **********************************************************
-- Garden lights OFF When some one left
-- **********************************************************
--

	if  devicechanged[lux_sensor.hallway]
		and uservariables[var.leaving_override] == 1
		and timedifference(otherdevices_lastupdate[garden.shed_lights]) > timeout.minutes5
		and timedifference(otherdevices_lastupdate[door.front]) > timeout.minutes5
		and timedifference(otherdevices_lastupdate[door.back]) > timeout.minutes5
		and timedifference(otherdevices_lastupdate[phone.switch]) > timeout.minutes5
	then
			commandArray["Group:" ..group.garden_lights_leaving.. ""]='Off AFTER 5 REPEAT 3 INTERVAL 5'
			commandArray["Variable:" .. var.leaving_override .. ""]= '0'		
	end