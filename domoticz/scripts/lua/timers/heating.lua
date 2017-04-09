--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_heating.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 7-4-2017
	@ Script to switch ON/OFF heating when someone @ home or not
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Someonehome Switch
	local someonehome					= 'Iemand Thuis'
	local nobody_home					= 'Niemand Thuis'
	local laptop_switch					= 'Laptops'
	local phone_switch					= 'Telefoons'
	local television					= 'Televisie'
	local visitors						= 'Visite'
	
-- Nest Various
	local nest_setpoint					= 'Nest - Setpoint'
	local nest_room_temp				= 'Nest - Temp + Hum'
	local nest_setpoint_idx				= 77
	local setpoint_low					= 17
	local setpoint_high					= 21
	local max_trigger_temp_day			= 20.5	
	
-- Various Switches
	local pico_power					= 'PIco RPi Powered'
	local security_activation_type		= 'alarm_ActivationType'
	
	weekend = IsWeekend()
	
	setpoint_current_temp	= tonumber(otherdevices_svalues[nest_setpoint])
	
	sNestTemp, sNestHumidity = otherdevices_svalues[nest_room_temp]:match("([^;]+);([^;]+)")
    sNestTemp = tonumber(sNestTemp)
    sNestHumidity = tonumber(sNestHumidity)	

--
-- **********************************************************
-- Turn heating ON when SomeOneHome and is weekend @daytime
-- **********************************************************
--
	
	if otherdevices[someonehome] == 'On'
		and otherdevices[pico_power] == 'On' 
		and setpoint_current_temp == setpoint_low
		and sNestTemp < max_trigger_temp_day	
		and timebetween("08:30:00","18:00:00")
		and weekend == 1
		and uservariables[security_activation_type] == 0		
	then
		timer_body = 'Heating turned ON...'
		timer_body0 = 'Current Room Temp: '..sNestTemp..''		
		timer_body1 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body2 = 'New Setpoint: '..setpoint_high..''
		commandArray["OpenURL"]="http://"..domoticz.ip..":"..domoticz.port.."/json.htm?type=command&param=udevice&idx="..nest_setpoint_idx.."&nvalue=0&svalue="..setpoint_high..""		
	
	end
	
--
-- **********************************************************
-- Turn heating ON when SomeOneHome and IsNot weekend @daytime
-- **********************************************************
--
	
	if otherdevices[someonehome] == 'On'
		and otherdevices[pico_power] == 'On' 
		and setpoint_current_temp == setpoint_low
		and sNestTemp < max_trigger_temp_day	
		and timebetween("08:00:00","18:00:00")
		and weekend == 0
		and uservariables[security_activation_type] == 0		
	then
		timer_body = 'Heating turned ON...'
		timer_body0 = 'Current Room Temp: '..sNestTemp..''		
		timer_body1 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body2 = 'New Setpoint: '..setpoint_high..''
		commandArray["OpenURL"]="http://"..domoticz.ip..":"..domoticz.port.."/json.htm?type=command&param=udevice&idx="..nest_setpoint_idx.."&nvalue=0&svalue="..setpoint_high..""		
	
	end	

--
-- **********************************************************
-- Turn heating ON when SomeOneHome @nightime
-- **********************************************************
--
	
	if otherdevices[someonehome] == 'On'
		and otherdevices[pico_power] == 'On' 
		and setpoint_current_temp == setpoint_low
		and sNestTemp <= setpoint_high	
		and timebetween("18:00:01","22:30:00")	
		and uservariables[security_activation_type] == 0		
	then
		timer_body = 'Heating turned ON...'
		timer_body0 = 'Current Room Temp: '..sNestTemp..''		
		timer_body1 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body2 = 'New Setpoint: '..setpoint_high..''
		commandArray["OpenURL"]="http://"..domoticz.ip..":"..domoticz.port.."/json.htm?type=command&param=udevice&idx="..nest_setpoint_idx.."&nvalue=0&svalue="..setpoint_high..""		
	end	

--
-- **********************************************************
-- Turn heating OFF when Nobody at home
-- **********************************************************
--
	
	if otherdevices[someonehome] == 'Off' and otherdevices[pico_power] == 'On' and setpoint_current_temp ~= setpoint_low and uservariables[security_activation_type] == 0then
		timer_body = 'Nobody at home or everyone is sleeping'
		timer_body0 = 'Heating turned OFF'
		timer_body1 = 'Current Room Temp: '..sNestTemp..''		
		timer_body2 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body3 = 'New Setpoint: '..setpoint_low..''
		commandArray["OpenURL"]="http://"..domoticz.ip..":"..domoticz.port.."/json.htm?type=command&param=udevice&idx="..nest_setpoint_idx.."&nvalue=0&svalue="..setpoint_low..""		
	end