--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ script_device_activity_heating.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-21-2018
	@ Script to switch ON/OFF heating when someone @ home or not
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Various Switches
	local someonehome					= 'Iemand Thuis'	
	local livingroom_window				= 'Voorraam'
	local sliding_door					= 'Schuifpui'
	local phone_switch					= 'Telefoons'
	
-- Nest Various
	local nest_setpoint					= 'Nest - Setpoint'
	local nest_room_temp				= 'Nest - TempHum'
	local nest_setpoint_idx				= 45
	
	local setpoint_low_summer			= 16.0 --16.3
	local setpoint_low_winter			= 18.0

	local setpoint_high					= 21.8

	local setpoint_trigger_temp			= 22.5	
	
-- Outside Temp Various
	local outside_temperature			= 'Veranda - Temperature'
	local outside_temp_max				= 19
	
-- Scrap Thermostat and outside temperatures	
	nest_setpoint_temp	= tonumber(otherdevices_svalues[nest_setpoint])
	outside_temp		= tonumber(otherdevices_svalues[outside_temperature])
	
	sNestTemp, sNestHumidity = otherdevices_svalues[nest_room_temp]:match("([^;]+);([^;]+)")
    nest_current_temp = tonumber(sNestTemp)
	nest_current_hum = tonumber(sNestHumidity) 	

-- Various Merged	
	windowsCLOSED = (otherdevices[livingroom_window] == 'Closed' or otherdevices[sliding_door] == 'Closed')

--
-- **********************************************************
-- Turn heating ON when SomeOneHome at day time
-- **********************************************************
--

	if otherdevices[someonehome] == 'Thuis'
		and outside_temp < outside_temp_max	
		and nest_current_temp <= setpoint_trigger_temp
		and nest_setpoint_temp ~= setpoint_high	
		and timebetween("08:15:00","21:59:59")
		and weekend('false')
	then		
		commandArray['SetSetPoint:'..nest_setpoint_idx]=tostring(setpoint_high)
	end
	
	if otherdevices[someonehome] == 'Thuis'
		and outside_temp < outside_temp_max	
		and nest_current_temp <= setpoint_trigger_temp
		and nest_setpoint_temp ~= setpoint_high	
		and timebetween("07:30:00","21:59:59")
		and weekend('true')		
	then		
		commandArray['SetSetPoint:'..nest_setpoint_idx]=tostring(setpoint_high)
	end	
	
--
-- **********************************************************
-- Turn heating OFF when SomeOneHome
-- **********************************************************
--

	if otherdevices[someonehome] == 'Thuis'
		and outside_temp > 5	
		and nest_setpoint_temp ~= setpoint_low_summer	
		and timebetween("22:00:00","23:59:59")
		and weekend('false')
	then		
		commandArray['SetSetPoint:'..nest_setpoint_idx]=tostring(setpoint_low_summer)	
	end
	
	if otherdevices[someonehome] == 'Thuis'
		and outside_temp <= 5	
		and nest_setpoint_temp ~= setpoint_low_winter	
		and timebetween("22:00:00","23:59:59")
		and weekend('false')
	then		
		commandArray['SetSetPoint:'..nest_setpoint_idx]=tostring(setpoint_low_winter)	
	end

	if otherdevices[someonehome] == 'Thuis'
		and outside_temp > 5	
		and nest_setpoint_temp ~= setpoint_low_summer	
		and timebetween("22:30:00","23:59:59")
		and weekend('true')
	then		
		commandArray['SetSetPoint:'..nest_setpoint_idx]=tostring(setpoint_low_summer)	
	end	
	
	if otherdevices[someonehome] == 'Thuis'
		and outside_temp <= 5	
		and nest_setpoint_temp ~= setpoint_low_winter	
		and timebetween("22:30:00","23:59:59")
		and weekend('true')
	then		
		commandArray['SetSetPoint:'..nest_setpoint_idx]=tostring(setpoint_low_winter)	
	end
	
--
-- **********************************************************
-- Turn heating OFF when NoBodyHome
-- **********************************************************
--

	if otherdevices[someonehome] ~= 'Thuis'
		and outside_temp > 5	
		and nest_setpoint_temp ~= setpoint_low_summer	
	then
		commandArray['SetSetPoint:'..nest_setpoint_idx]=tostring(setpoint_low_summer)	
	end
	
	if otherdevices[someonehome] ~= 'Thuis'
		and outside_temp <= 5	
		and nest_setpoint_temp ~= setpoint_low_winter		
	then
		commandArray['SetSetPoint:'..nest_setpoint_idx]=tostring(setpoint_low_winter)	
	end	