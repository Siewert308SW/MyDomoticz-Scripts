--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ control_heating.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 4-7-2018
	@ Script to switch ON/OFF heating, taking in count weekend
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Scrap Thermostat and outside temperatures	
	sNestTemp, sNestHumidity = otherdevices_svalues[nest.room_temp]:match("([^;]+);([^;]+)")
    nest_temp = tonumber(sNestTemp)
	nest_hum = tonumber(sNestHumidity)
	
--
-- **********************************************************
-- Turn heating ON instant when SomeOneHome at day time
-- **********************************************************
--

		if devicechanged[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.summer_temp
			and device_svalue(temp.porch) >= nest.autumn_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp1	
			and timebetween("09:00:00","22:29:59")
			and weekend('false')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp1)
		end
		
		if devicechanged[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.autumn_temp
			and device_svalue(temp.porch) >= nest.winter_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp2	
			and timebetween("09:00:00","22:29:59")
			and weekend('false')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp2)
		end		
		
		if devicechanged[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp3	
			and timebetween("09:00:00","22:29:59")
			and weekend('false')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp3)
		end

-- **********************************************************
		
		if devicechanged[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.summer_temp
			and device_svalue(temp.porch) >= nest.autumn_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp1	
			and timebetween("07:30:00","22:29:59")
			and weekend('true')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp1)
		end
		
		if devicechanged[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.autumn_temp
			and device_svalue(temp.porch) >= nest.winter_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp2	
			and timebetween("07:30:00","22:29:59")
			and weekend('true')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp2)
		end		
		
		if devicechanged[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp3	
			and timebetween("07:30:00","22:29:59")
			and weekend('true')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp3)
		end

--
-- **********************************************************
-- Turn heating ON when SomeOneHome at day time
-- **********************************************************
--

		if devicechanged[lux_sensor.living]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.summer_temp
			and device_svalue(temp.porch) >= nest.autumn_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp1	
			and timebetween("09:00:00","22:29:59")
			and weekend('false')
			and otherdevices[door.scullery] == 'Closed' 
			and otherdevices[door.garden] == 'Closed'	
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp1)
		end
		
		if devicechanged[lux_sensor.living]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.autumn_temp
			and device_svalue(temp.porch) >= nest.winter_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp2	
			and timebetween("09:00:00","22:29:59")
			and weekend('false')
			and otherdevices[door.scullery] == 'Closed' 
			and otherdevices[door.garden] == 'Closed'		
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp2)
		end		
		
		if devicechanged[lux_sensor.living]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp3	
			and timebetween("09:00:00","22:29:59")
			and weekend('false')
			and otherdevices[door.scullery] == 'Closed' 
			and otherdevices[door.garden] == 'Closed'
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp3)
		end

-- **********************************************************
		
		if devicechanged[lux_sensor.living]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.summer_temp
			and device_svalue(temp.porch) >= nest.autumn_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp1	
			and timebetween("07:30:00","23:29:59")
			and weekend('true')
			and otherdevices[door.scullery] == 'Closed' 
			and otherdevices[door.garden] == 'Closed'	
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp1)
		end
		
		if devicechanged[lux_sensor.living]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.autumn_temp
			and device_svalue(temp.porch) >= nest.winter_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp2	
			and timebetween("07:30:00","23:29:59")
			and weekend('true')
			and otherdevices[door.scullery] == 'Closed' 
			and otherdevices[door.garden] == 'Closed'
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp2)
		end		
		
		if devicechanged[lux_sensor.living]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp			
			and nest_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp3	
			and timebetween("07:30:00","23:29:59")
			and weekend('true')
			and otherdevices[door.scullery] == 'Closed' 
			and otherdevices[door.garden] == 'Closed'
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp3)
		end
	
--
-- **********************************************************
-- Turn heating OFF when SomeOneHome at midweek
-- **********************************************************
--

		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) > nest.summer_temp
			and device_svalue(nest.setpoint) ~= nest.eco_temp
			and timebetween("22:30:00","23:59:59")
			and weekend('false')		
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp)
		end
	
		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.summer_temp
			and device_svalue(temp.porch) > nest.autumn_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and timebetween("22:30:00","23:59:59")
			and weekend('false')		
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.autumn_temp
			and device_svalue(temp.porch) > nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_autumn
			and timebetween("22:30:00","23:59:59")
			and weekend('false')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_autumn)
		end

		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_winter
			and timebetween("22:30:00","23:59:59")
			and weekend('false')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_winter)
		end

--
-- **********************************************************
-- Turn heating OFF when SomeOneHome at weekend
-- **********************************************************
--

		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) > nest.summer_temp
			and device_svalue(nest.setpoint) ~= nest.eco_temp
			and timebetween("23:30:00","23:59:59")
			and weekend('true')		
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp)
		end
	
		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.summer_temp
			and device_svalue(temp.porch) > nest.autumn_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and timebetween("23:30:00","23:59:59")
			and weekend('true')		
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.autumn_temp
			and device_svalue(temp.porch) > nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_autumn
			and timebetween("23:30:00","23:59:59")
			and weekend('true')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_autumn)
		end

		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_winter
			and timebetween("23:30:00","23:59:59")
			and weekend('true')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_winter)
		end
	
--
-- **********************************************************
-- Turn heating OFF when NoBodyHome
-- **********************************************************
--

		if devicechanged[lux_sensor.hallway]
			and otherdevices[someone.home] ~= 'Thuis'
			and device_svalue(temp.porch) > nest.summer_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.minutes30
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

		if devicechanged[lux_sensor.hallway]
			and otherdevices[someone.home] ~= 'Thuis'
			and device_svalue(temp.porch) <= nest.summer_temp
			and device_svalue(temp.porch) > nest.autumn_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.minutes30
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

		if devicechanged[lux_sensor.hallway]
			and otherdevices[someone.home] ~= 'Thuis'
			and device_svalue(temp.porch) <= nest.autumn_temp
			and device_svalue(temp.porch) > nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_autumn
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.minutes30
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_autumn)
		end

		if devicechanged[lux_sensor.hallway]
			and otherdevices[someone.home] ~= 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_winter
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.minutes30
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_winter)
		end
		
--
-- **********************************************************
-- Turn heating OFF when outside temp exceeds threshold
-- **********************************************************
--

		if devicechanged[lux_sensor.porch]
			and device_svalue(temp.porch) >= nest.summer_temp
			and device_svalue(nest.setpoint) ~= nest.eco_temp
			and (device_svalue(nest.setpoint) == nest.setpoint_temp1
			or device_svalue(nest.setpoint) == nest.setpoint_temp2
			or device_svalue(nest.setpoint) == nest.setpoint_temp3
			or device_svalue(nest.setpoint) == nest.setpoint_low_summer
			or device_svalue(nest.setpoint) == nest.setpoint_low_autumn
			or device_svalue(nest.setpoint) == nest.setpoint_low_winter)
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp)
		end
		
--
-- **********************************************************
-- Turn heating OFF when garden and backdoor are open for x minutes
-- **********************************************************
--

		if devicechanged[lux_sensor.porch]
			and device_svalue(temp.porch) >= nest.autumn_temp
			and device_svalue(nest.setpoint) ~= nest.eco_temp
			and timedifference(otherdevices_lastupdate[door.back]) >= timeout.minutes15
			and timedifference(otherdevices_lastupdate[door.garden]) >= timeout.minutes15
			and timedifference(otherdevices_lastupdate[door.scullery]) >= timeout.minutes15			
			and (device_svalue(nest.setpoint) == nest.setpoint_temp1
			or device_svalue(nest.setpoint) == nest.setpoint_temp2
			or device_svalue(nest.setpoint) == nest.setpoint_temp3
			or device_svalue(nest.setpoint) == nest.setpoint_low_summer
			or device_svalue(nest.setpoint) == nest.setpoint_low_autumn
			or device_svalue(nest.setpoint) == nest.setpoint_low_winter)
			and otherdevices[door.back] == 'Open'
			and otherdevices[door.scullery] == 'Open' 
			and otherdevices[door.garden] == 'Closed'
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp)
		end

		if devicechanged[lux_sensor.porch]
			and device_svalue(temp.porch) >= nest.autumn_temp
			and device_svalue(nest.setpoint) ~= nest.eco_temp
			and timedifference(otherdevices_lastupdate[door.back]) >= timeout.minutes15
			and timedifference(otherdevices_lastupdate[door.garden]) >= timeout.minutes15
			and timedifference(otherdevices_lastupdate[door.scullery]) >= timeout.minutes15			
			and (device_svalue(nest.setpoint) == nest.setpoint_temp1
			or device_svalue(nest.setpoint) == nest.setpoint_temp2
			or device_svalue(nest.setpoint) == nest.setpoint_temp3
			or device_svalue(nest.setpoint) == nest.setpoint_low_summer
			or device_svalue(nest.setpoint) == nest.setpoint_low_autumn
			or device_svalue(nest.setpoint) == nest.setpoint_low_winter)
			and otherdevices[door.garden] == 'Open'
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp)
		end			