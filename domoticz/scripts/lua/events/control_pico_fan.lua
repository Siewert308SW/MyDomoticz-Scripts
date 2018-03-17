--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ control_pico_fan.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-17-2018
	@ Script for PIco UPS HV3.0A to control PIco Fan Kit and filesave shutdown when overheating
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- PIco Fan ON/OFF
-- **********************************************************
--
	if devicechanged[lux_sensor.living] then	
		-- FAN OFF
		if device_svalue(pico.rpi_temp_sensor) < 55 
			and otherdevices[pico.fan_selector_switch] ~= "Off"
			and timedifference(otherdevices_lastupdate[pico.fan_selector_switch]) > timeout.minutes5
		then
			commandArray[pico.fan_selector_switch]='Off'			
		end
			
		-- FAN @ 25%
		if device_svalue(pico.rpi_temp_sensor) >= 55
			and device_svalue(pico.rpi_temp_sensor) <= 65
			and otherdevices[pico.fan_selector_switch] ~= "25%"
			and timedifference(otherdevices_lastupdate[pico.fan_selector_switch]) > timeout.minutes5
		then
			commandArray[pico.fan_selector_switch]='Set Level 10'			
		end

		-- FAN @ 50%
		if device_svalue(pico.rpi_temp_sensor) > 65
			and device_svalue(pico.rpi_temp_sensor) <= 70	
			and otherdevices[pico.fan_selector_switch] ~= "50%"
			and timedifference(otherdevices_lastupdate[pico.fan_selector_switch]) > timeout.minutes5
		then
			commandArray[pico.fan_selector_switch]='Set Level 20'			
		end

		-- FAN @ 75%
		if device_svalue(pico.rpi_temp_sensor) > 70
			and device_svalue(pico.rpi_temp_sensor) <= 75
			and otherdevices[pico.fan_selector_switch] ~= "75%"
			and timedifference(otherdevices_lastupdate[pico.fan_selector_switch]) > timeout.minutes5
		then
			commandArray[pico.fan_selector_switch]='Set Level 30'			
		end	

		-- FAN @ 100%
		if device_svalue(pico.rpi_temp_sensor) > 75
			and device_svalue(pico.rpi_temp_sensor) <= 80.0	
			and otherdevices[pico.fan_selector_switch] ~= "100%"
			and timedifference(otherdevices_lastupdate[pico.fan_selector_switch]) > timeout.minutes5
		then
			commandArray[pico.fan_selector_switch]='Set Level 40'			
		end			

		-- Shutdown System
		if device_svalue(pico.rpi_temp_sensor) > 80
			and otherdevices[pico.fan_selector_switch] ~= "Shutdown"
			and timedifference(otherdevices_lastupdate[pico.fan_selector_switch]) > timeout.minutes5
		then
			commandArray['SendNotification']='Raspberry to HOT#Your RPi seems to be to hot, System has been shutdown'	
			commandArray[pico.fan_selector_switch]='Set Level 50 AFTER 10'			
		end
	end