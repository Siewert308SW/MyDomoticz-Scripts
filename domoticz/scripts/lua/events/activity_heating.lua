--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_heating.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-13-2018
	@ Script to switch ON/OFF heating when someone @ home or not
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Scrap Thermostat and outside temperatures	
	sNestTemp, sNestHumidity = otherdevices_svalues[nest.room_temp]:match("([^;]+);([^;]+)")
    nest_current_temp = tonumber(sNestTemp)
	nest_current_hum = tonumber(sNestHumidity)

	
--
-- **********************************************************
-- Turn heating ON when SomeOneHome at day time
-- **********************************************************
--
	if devicechanged[lux_sensor.living] then
	
		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.summer_temp
			and nest_current_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp	
			and timebetween("08:00:00","21:59:59")
			and weekend('false')	
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp)
		end

-- **********************************************************
		
		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) < nest.summer_temp
			and nest_current_temp <= nest.trigger_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_temp
			and timebetween("08:00:00","22:59:59")
			and weekend('true')
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp)
		end
		
	end
	
--
-- **********************************************************
-- Turn heating OFF when SomeOneHome at midweek
-- **********************************************************
--

	if devicechanged[lux_sensor.upstairs] then

		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) > nest.summer_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and timebetween("22:30:00","23:59:59")
			and weekend('false')
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1			
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

-- **********************************************************
		
		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.summer_temp
			and device_svalue(temp.porch) > nest.autumn_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and timebetween("22:30:00","23:59:59")
			and weekend('false')
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1			
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

-- **********************************************************
		
		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.autumn_temp
			and device_svalue(temp.porch) > nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_autumn
			and timebetween("22:30:00","23:59:59")
			and weekend('false')
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_autumn)
		end

-- **********************************************************
		
		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_winter
			and timebetween("22:30:00","23:59:59")
			and weekend('false')
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_winter)
		end

--
-- **********************************************************
-- Turn heating OFF when SomeOneHome at weekend
-- **********************************************************
--

		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) > nest.summer_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00","07:59:59"))
			and weekend('true')
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

-- **********************************************************
		
		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.summer_temp
			and device_svalue(temp.porch) > nest.autumn_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00","07:59:59"))
			and weekend('true')
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

-- **********************************************************
		
		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.autumn_temp
			and device_svalue(temp.porch) > nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_autumn
			and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00","07:59:59"))
			and weekend('true')
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_autumn)
		end

-- **********************************************************
		
		if otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_winter
			and (timebetween("23:30:00","23:59:59") or timebetween("00:00:00","07:59:59"))
			and weekend('true')
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_winter)
		end
	
--
-- **********************************************************
-- Turn heating OFF when NoBodyHome
-- **********************************************************
--

		if otherdevices[someone.home] ~= 'Thuis'
			and device_svalue(temp.porch) > nest.summer_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

-- **********************************************************
		
		if otherdevices[someone.home] ~= 'Thuis'
			and device_svalue(temp.porch) <= nest.summer_temp
			and device_svalue(temp.porch) > nest.autumn_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_summer
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_summer)
		end

-- **********************************************************
		
		if otherdevices[someone.home] ~= 'Thuis'
			and device_svalue(temp.porch) <= nest.autumn_temp
			and device_svalue(temp.porch) > nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_autumn
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_autumn)
		end

-- **********************************************************
		
		if otherdevices[someone.home] ~= 'Thuis'
			and device_svalue(temp.porch) <= nest.winter_temp
			and device_svalue(nest.setpoint) ~= nest.setpoint_low_winter
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1
		then
			commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_low_winter)
		end
		
end