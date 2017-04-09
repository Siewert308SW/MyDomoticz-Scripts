--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ pico_fan_control.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-4-2017
	@ Script for PIco UPS HV3.0A to control PIco Fan Kit and filesave shutdown at power outage
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

	local m = os.date('%M')

-- PIco Devices
	local pico_voltage 						= 'PIco BAT Voltage'
	local pico_fan_speed 					= 'PIco FAN Speed'
	local fan_selector 						= 'PIco Fan Control'
	local pico_selector						= 'PIco Control'
	local pico_power						= 'PIco RPi Powered'
	
-- PIco/RPi Variables
	local pico_fan_control_timeout 			= 599 -- 10 minutes
	local pico_ups_control_timeout 			= 299 -- 5 minutes
	local pico_ups_control_reset_timeout 	= 899 -- 15 minutes	
	local pico_min_volt						= 3.7 --'3.1'
	local pico_power_switch					= 'IsPIco_Power_Switch'
	local pico_power_state 					= 'IsPIco_Power_State'
	
-- RPi Devices
	local rpi_temp							= 'Raspberry Temperature'	
	local rpi_voltage						= 'RPi Voltage'
	
-- Various Switches	
	local router							= '192.168.178.0'
	local timeout_power_outage				= 60

	rpi_cpu_temp							= tonumber(otherdevices_svalues[rpi_temp])
	ups_current_voltage 					= tonumber (otherdevices_svalues[pico_voltage])		
	rpi_current_voltage 					= tonumber (otherdevices_svalues[rpi_voltage])
	
--
-- **********************************************************
-- PIco filesave system shutdown @ power outage
-- **********************************************************
--


		if rpi_current_voltage == 0 and uservariables[pico_power_switch] == 0 then
		ping_router_success=os.execute('sudo ping -q -c1 -W 1 '..router..'')

			if ping_router_success and ups_current_voltage > pico_min_volt then	
				timer_body  = 'RPi voltage @ '..rpi_current_voltage..''
				timer_body0  = 'UPS voltage @ '..ups_current_voltage..''			
				timer_body1 = 'Router still online, Asuming this is a false alarm!'		
				
			elseif ping_router_success and ups_current_voltage <= pico_min_volt then	
				timer_body  = 'RPi voltage @ '..rpi_current_voltage..''
				timer_body0  = 'UPS voltage @ '..ups_current_voltage..''			
				timer_body1 = 'Router still online!'	
				timer_body2 = 'Battery voltage is getting critical'	
				timer_body3 = 'System shutdown...'				
				commandArray[pico_power]='Off'
				commandArray['Variable:' .. pico_power_switch]='1'					
				commandArray[pico_selector]='Set Level 20 AFTER 15'			

			elseif not ping_router_success and ups_current_voltage > pico_min_volt then	
				timer_body  = 'RPi voltage @ '..rpi_current_voltage..''
				timer_body0  = 'UPS voltage @ '..ups_current_voltage..''			
				timer_body1 = 'Your region is suffering a power outage'	
				timer_body2 = 'Rpi running on battery power'
				if otherdevices[pico_power] == 'On' then
				commandArray[pico_power]='Off'
				end

			elseif not ping_router_success and ups_current_voltage <= pico_min_volt then	
				timer_body  = 'RPi voltage @ '..rpi_current_voltage..''
				timer_body0  = 'UPS voltage @ '..ups_current_voltage..''			
				timer_body1 = 'Still no 220v power'	
				timer_body2 = 'Battery voltage is getting critical'	
				timer_body3 = 'System shutdown...'				
				commandArray[pico_power]='Off'
				commandArray['Variable:' .. pico_power_switch]='1'					
				commandArray[pico_selector]='Set Level 20 AFTER 15'							
			end	
		
		end
		
		if rpi_current_voltage > 0 and otherdevices[pico_power] == 'Off' then
			timer_body  = 'RPi voltage @ '..rpi_current_voltage..''
			timer_body0  = 'UPS voltage @ '..ups_current_voltage..''			
			timer_body1 = 'Looks power has been restored'			
			commandArray[pico_power]='On'
		    commandArray['Variable:' .. pico_power_switch]='0'			
		end	
		
--
-- **********************************************************
-- PIco Fan ON/OFF depending on RPI and UPS pcb temp
-- **********************************************************
--
	
		-- FAN OFF
		if (tonumber(otherdevices_svalues[rpi_temp]) <= 45.5) 
			and (otherdevices[fan_selector] ~= "Off")
			and (timedifference(otherdevices_lastupdate[fan_selector]) > pico_fan_control_timeout)
		then
			commandArray[fan_selector]='Off'
			timer_body = 'RPi temperature is okay @ '..rpi_cpu_temp..''
			timer_body0 = 'Fan switched OFF...'			
		end
		
		-- FAN @ 25%
		if (tonumber(otherdevices_svalues[rpi_temp]) > 45.5) and (tonumber(otherdevices_svalues[rpi_temp]) <= 55.5)
			and (tonumber(otherdevices_svalues[fan_selector]) ~= 10)
			and (timedifference(otherdevices_lastupdate[fan_selector]) > pico_fan_control_timeout)
		then
			commandArray[fan_selector]='Set Level 10'
			timer_body = 'RPi temperature is okay @ '..rpi_cpu_temp..''
			timer_body0 = 'Fan speed switched to 25%...'			
		end

		-- FAN @ 50%
		if (tonumber(otherdevices_svalues[rpi_temp]) > 55.5) and (tonumber(otherdevices_svalues[rpi_temp]) <= 60.5)
			and (tonumber(otherdevices_svalues[fan_selector]) ~= 20)
			and (timedifference(otherdevices_lastupdate[fan_selector]) > pico_fan_control_timeout)
		then
			commandArray[fan_selector]='Set Level 20'
			timer_body  = 'RPi temperature @ '..rpi_cpu_temp..''
			timer_body0 = 'Rpi temperature is getting a bit high!'
			timer_body1 = 'Fan speed switched to 50%...'			
		end

		-- FAN @ 75%
		if (tonumber(otherdevices_svalues[rpi_temp]) > 60.5) and (tonumber(otherdevices_svalues[rpi_temp]) <= 70.5)
			and (tonumber(otherdevices_svalues[fan_selector]) ~= 30)
			and (timedifference(otherdevices_lastupdate[fan_selector]) > pico_fan_control_timeout)
		then
			commandArray[fan_selector]='Set Level 30'	
			timer_body  = 'RPi temperature @ '..rpi_cpu_temp..''
			timer_body0 = 'Rpi temperature is getting a bit to high!'
			timer_body1 = 'Fan speed switched to 75%...'	
		end

		-- FAN @ 100%
		if (tonumber(otherdevices_svalues[rpi_temp]) > 70.5) and (tonumber(otherdevices_svalues[rpi_temp]) <= 79.5)
			and (tonumber(otherdevices_svalues[fan_selector]) ~= 40)
			and (timedifference(otherdevices_lastupdate[fan_selector]) > pico_fan_control_timeout)
		then
			commandArray[fan_selector]='Set Level 40'	
			timer_body  = 'RPi temperature @ '..rpi_cpu_temp..''
			timer_body0 = 'Rpi temperature is to high!'
			timer_body1 = 'Fan speed switched to 75%...'	
		end			

		-- Shutdown System
		if (tonumber(otherdevices_svalues[rpi_temp]) > 79.5)
			and (timedifference(otherdevices_lastupdate[fan_selector]) > 119)
		then
			commandArray['SendNotification']='Raspberry to HOT#Your RPi seems to be to hot, System has been shutdown'			
			commandArray[pico_selector]='Set Level 20'
			timer_body  = 'RPi temperature @ '..rpi_cpu_temp..''
			timer_body0 = 'Rpi temperature is way to high!'
			timer_body1 = 'System shutdown...'				
		end

--
-- **********************************************************
-- Sync date 2 hwclock
-- **********************************************************
--	
if (m % 60 == 0) then --run once a hour
		local hwclock_handle = io.popen("sudo hwclock --test | grep CEST | awk {'print $5'}")
		local hwclock = hwclock_handle:read("*all")
		hwclock_handle:close()
		
		local clock_handle = io.popen("date | grep CEST | awk {'print $4'}")
		local clk = clock_handle:read("*all")
		clock_handle:close()
		
		if hwclock < clk and hwclock < clk then
		timer_body  = 'hwclock @ '..hwclock..''
		timer_body0  = 'clock @ '..clk..''
		timer_body1 = 'hwclock out off sync'
		timer_body2 = 'It has been synced to match the actual ntp time...'		
		os.execute("sudo hwclock -w")		
		elseif hwclock == nil then
		timer_body = 'hwclock not available'		
		end
end