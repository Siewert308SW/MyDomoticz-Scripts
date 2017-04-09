--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_heating.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 9-4-2017
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
	local max_nest_trigger_temp			= 20.5	
	
-- Outside Temp Various
	local outside_temp					= 'Temp + Humidity + Baro'
	local outside_temp_max				= 18
	
-- Various	
	local pico_power					= 'PIco RPi Powered'
	local security_activation_type		= 'alarm_ActivationType'

-- Call function weekend	
	weekend = IsWeekend()

-- Scrap Thermostat and outside temperatures	
	setpoint_current_temp	= tonumber(otherdevices_svalues[nest_setpoint])
	
	sNestTemp, sNestHumidity = otherdevices_svalues[nest_room_temp]:match("([^;]+);([^;]+)")
    sNestTemp = tonumber(sNestTemp)
    sNestHumidity = tonumber(sNestHumidity)	
	
	sOutsideTemp = otherdevices_svalues[outside_temp]:match("([^;]+)")
    sOutsideTemp = tonumber(sOutsideTemp)

--
-- **********************************************************
-- Turn heating ON when SomeOneHome and is weekend @daytime
-- **********************************************************
--

	if otherdevices[someonehome] == 'On'
		and otherdevices[pico_power] == 'On' 
		and setpoint_current_temp == setpoint_low
		and sNestTemp < max_nest_trigger_temp
		and sOutsideTemp <= outside_temp_max		
		and timebetween("08:30:00","18:00:00")
		and weekend == 1
		and uservariables[security_activation_type] == 0		
	then
		timer_body = 'Heating turned ON...'
		timer_body0 = 'Current Room Temp: '..sNestTemp..''		
		timer_body1 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body2 = 'New Setpoint: '..setpoint_high..''
		timer_body3 = 'Current Outside Temp: '..sOutsideTemp..''		
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
		and sNestTemp < max_nest_trigger_temp
		and sOutsideTemp <= outside_temp_max		
		and timebetween("08:00:00","18:00:00")
		and weekend == 0
		and uservariables[security_activation_type] == 0		
	then
		timer_body = 'Heating turned ON...'
		timer_body0 = 'Current Room Temp: '..sNestTemp..''		
		timer_body1 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body2 = 'New Setpoint: '..setpoint_high..''
		timer_body3 = 'Current Outside Temp: '..sOutsideTemp..''		
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
		and sOutsideTemp <= outside_temp_max		
		and timebetween("18:00:01","22:30:00")	
		and uservariables[security_activation_type] == 0		
	then
		timer_body = 'Heating turned ON...'
		timer_body0 = 'Current Room Temp: '..sNestTemp..''		
		timer_body1 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body2 = 'New Setpoint: '..setpoint_high..''
		timer_body3 = 'Current Outside Temp: '..sOutsideTemp..''		
		commandArray["OpenURL"]="http://"..domoticz.ip..":"..domoticz.port.."/json.htm?type=command&param=udevice&idx="..nest_setpoint_idx.."&nvalue=0&svalue="..setpoint_high..""		
	end
	
--
-- **********************************************************
-- Turn heating OFF when outside temp reaches specfic max temp
-- **********************************************************
--
	
	if otherdevices[someonehome] == 'On'
		and otherdevices[pico_power] == 'On'
		and setpoint_current_temp == setpoint_high
		and uservariables[security_activation_type] == 0 
		and sOutsideTemp > outside_temp_max		
	then
		timer_body = 'Outside reached trigger point'
		timer_body0 = 'Heating turned OFF'
		timer_body1 = 'Current Room Temp: '..sNestTemp..''		
		timer_body2 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body3 = 'New Setpoint: '..setpoint_low..''
		timer_body4 = 'Current Outside Temp: '..sOutsideTemp..''		
		commandArray["OpenURL"]="http://"..domoticz.ip..":"..domoticz.port.."/json.htm?type=command&param=udevice&idx="..nest_setpoint_idx.."&nvalue=0&svalue="..setpoint_low..""		
	end		
	
--
-- **********************************************************
-- Turn heating OFF when SomeOneHome at specific time trigger
-- **********************************************************
--
	
	if otherdevices[someonehome] == 'On'
		and otherdevices[pico_power] == 'On'
		and setpoint_current_temp == setpoint_high
		and uservariables[security_activation_type] == 0 
		and timebetween("22:30:01","00:00:00")
		and weekend == 0		
	then
		timer_body = 'Someone still at home @ nighttime'
		timer_body0 = 'Heating turned OFF'
		timer_body1 = 'Current Room Temp: '..sNestTemp..''		
		timer_body2 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body3 = 'New Setpoint: '..setpoint_low..''
		timer_body4 = 'Current Outside Temp: '..sOutsideTemp..''		
		commandArray["OpenURL"]="http://"..domoticz.ip..":"..domoticz.port.."/json.htm?type=command&param=udevice&idx="..nest_setpoint_idx.."&nvalue=0&svalue="..setpoint_low..""		
	end	
	
	if otherdevices[someonehome] == 'On'
		and otherdevices[pico_power] == 'On'
		and setpoint_current_temp == setpoint_high
		and uservariables[security_activation_type] == 0 
		and timebetween("23:30:00","00:00:00")
		and weekend == 1		
	then
		timer_body = 'Someone still at home @ nighttime'
		timer_body0 = 'Heating turned OFF'
		timer_body1 = 'Current Room Temp: '..sNestTemp..''		
		timer_body2 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body3 = 'New Setpoint: '..setpoint_low..''
		timer_body4 = 'Current Outside Temp: '..sOutsideTemp..''		
		commandArray["OpenURL"]="http://"..domoticz.ip..":"..domoticz.port.."/json.htm?type=command&param=udevice&idx="..nest_setpoint_idx.."&nvalue=0&svalue="..setpoint_low..""		
	end		

--
-- **********************************************************
-- Turn heating OFF when Nobody at home
-- **********************************************************
--
	
	if otherdevices[someonehome] == 'Off'
		and otherdevices[pico_power] == 'On'
		and setpoint_current_temp ~= setpoint_low
		and uservariables[security_activation_type] == 0
	then
		timer_body = 'Nobody at home or everyone is sleeping'
		timer_body0 = 'Heating turned OFF'
		timer_body1 = 'Current Room Temp: '..sNestTemp..''		
		timer_body2 = 'Current Setpoint: '..setpoint_current_temp..''
		timer_body3 = 'New Setpoint: '..setpoint_low..''
		timer_body4 = 'Current Outside Temp: '..sOutsideTemp..''		
		commandArray["OpenURL"]="http://"..domoticz.ip..":"..domoticz.port.."/json.htm?type=command&param=udevice&idx="..nest_setpoint_idx.."&nvalue=0&svalue="..setpoint_low..""		
	end