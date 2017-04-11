--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ isdark.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 12-4-2017
	@ Time script to switch ON/OFF dusk sensor if signal is missed, taking in count WeatherUnderground Solar indication
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- **********************************************************
-- IsDark Settings
-- **********************************************************
--
	
	local isdark_xmas_lights 		= 'IsDonker_Kerst_Verlichting'
	local isdark_dinnertable_light 	= 'IsDonker_Eettafel'
	local isdark_livingroom_lights1	= 'IsDonker_Woonkamer_1'
	local isdark_livingroom_lights2	= 'IsDonker_Woonkamer_2'
	local isdark_garden_lights 		= 'IsDonker_Tuin_Verlichting'
	local dusk_sensor 				= 'Schemer Sensor'
	local dusk_trigger 				= 'Sunrise/Sunset'
	local pico_power    			= 'PIco RPi Powered'
	local security_activation_type	= 'alarm_ActivationType'
	local solar 					= 'Solar'

	local dusk_solarvalue			= '12'
	local dusk_solarvalue_max		= '30'

			timeon_xmas_lights 				= 180	
			timeon_dinnertable_light 		= 180	
			timeon_livingroom_lights1 		= 300
			timeon_livingroom_lights2 		= 900
			timeon_garden_lights 			= 300
			timeon_lights_timeout 			= 120

--
-- **********************************************************
-- Dusk Sensor ON/OFF when Solar lux is higher or lower then threshold
-- **********************************************************
--

    sSolar = otherdevices_svalues[solar]:match("([^;]+)")
    sSolar = tonumber(sSolar);

		if otherdevices[dusk_sensor] =='Off' 
			and otherdevices[dusk_trigger] == 'On'	
			and sSolar <= tonumber (dusk_solarvalue) 
			and timedifference(otherdevices_lastupdate[dusk_sensor]) > timeon_lights_timeout
			and uservariables[security_activation_type] == 0			
		then
			commandArray[dusk_sensor]='On'
			timer_body = 'It is dark outside'	
			timer_body0 = 'Solar radiation at '..sSolar..' Watt/m2'
			timer_body1 = 'Which is below your '..dusk_solarvalue..' Watt/m2 threshold'	
		end	

--------

		if otherdevices[dusk_sensor] =='On'
			and otherdevices[dusk_trigger] == 'Off'	
			and sSolar > tonumber (dusk_solarvalue)
			and sSolar > tonumber (dusk_solarvalue_max) 	
			and timedifference(otherdevices_lastupdate[dusk_sensor]) > timeon_lights_timeout
			and uservariables[security_activation_type] == 0			
		then
			commandArray[dusk_sensor]='Off'
			commandArray[isdark_garden_lights]='Off'
			commandArray[isdark_livingroom_lights2]='Off'	
			commandArray[isdark_livingroom_lights1]='Off'		
			commandArray[isdark_dinnertable_light]='Off'
			commandArray[isdark_xmas_lights]='Off'	
			timer_body = 'It is not dark outside'	
			timer_body0 = 'Solar radiation at '..sSolar..' Watt/m2'
			timer_body1 = 'Which is above your '..dusk_solarvalue..' Watt/m2 threshold'	
		end	

--------

		if otherdevices[dusk_sensor] =='On'
			and otherdevices[dusk_trigger] == 'Off'	
			and sSolar > 5
			and timebetween("06:00:00","12:00:00") 	
			and timedifference(otherdevices_lastupdate[dusk_sensor]) > timeon_lights_timeout
			and uservariables[security_activation_type] == 0			
		then
			commandArray[dusk_sensor]='Off'
			commandArray[isdark_garden_lights]='Off'
			commandArray[isdark_livingroom_lights2]='Off'	
			commandArray[isdark_livingroom_lights1]='Off'		
			commandArray[isdark_dinnertable_light]='Off'
			commandArray[isdark_xmas_lights]='Off'	
			timer_body = 'The sun is up'	
			timer_body0 = 'Solar radiation at '..sSolar..' Watt/m2'		
		end		

--
-- **********************************************************
-- Dusk sensor triggers ON/OFF
-- **********************************************************
--

	    if otherdevices[dusk_sensor] == 'On'		
			and otherdevices[isdark_xmas_lights] == 'Off'
			and otherdevices[isdark_dinnertable_light] == 'Off'
			and otherdevices[isdark_livingroom_lights1] == 'Off'
			and otherdevices[isdark_livingroom_lights2] == 'Off'
			and otherdevices[isdark_garden_lights] == 'Off'
			and otherdevices[pico_power]   == 'On'			
			and timedifference(otherdevices_lastupdate[dusk_sensor]) > timeon_xmas_lights
			and uservariables[security_activation_type] == 0			
		then
			commandArray[isdark_xmas_lights]='On'			
		end	

--------
	    if otherdevices[dusk_sensor] == 'On'		
			and otherdevices[isdark_xmas_lights] == 'On'
			and otherdevices[isdark_dinnertable_light] == 'Off'
			and otherdevices[isdark_livingroom_lights1] == 'Off'
			and otherdevices[isdark_livingroom_lights2] == 'Off'
			and otherdevices[isdark_garden_lights] == 'Off'
			and otherdevices[pico_power]   == 'On'				
			and timedifference(otherdevices_lastupdate[isdark_xmas_lights]) > timeon_dinnertable_light
			and uservariables[security_activation_type] == 0			
		then
			commandArray[isdark_dinnertable_light]='On'			
		end		

--------

	    if otherdevices[dusk_sensor] == 'On'
			and otherdevices[dusk_trigger] == 'On'		
			and otherdevices[isdark_xmas_lights] == 'On'
			and otherdevices[isdark_dinnertable_light] == 'On'
			and otherdevices[isdark_livingroom_lights1] == 'Off'
			and otherdevices[isdark_livingroom_lights2] == 'Off'
			and otherdevices[isdark_garden_lights] == 'Off'
			and otherdevices[pico_power]   == 'On'			
			and timedifference(otherdevices_lastupdate[isdark_dinnertable_light]) > timeon_livingroom_lights1
			and uservariables[security_activation_type] == 0			
		then
			commandArray[isdark_livingroom_lights1]='On'				
		end		

--------

	    if otherdevices[dusk_sensor] == 'On'
			and otherdevices[dusk_trigger] == 'On'
			and otherdevices[isdark_xmas_lights] == 'On'
			and otherdevices[isdark_dinnertable_light] == 'On'
			and otherdevices[isdark_livingroom_lights1] == 'On'
			and otherdevices[isdark_livingroom_lights2] == 'Off'
			and otherdevices[isdark_garden_lights] == 'Off' 
			and otherdevices[pico_power]   == 'On'			
			and timedifference(otherdevices_lastupdate[isdark_livingroom_lights1]) > timeon_livingroom_lights2
			and uservariables[security_activation_type] == 0			
		then
			commandArray[isdark_livingroom_lights2]='On'			
		end		

--------

	    if otherdevices[dusk_sensor] == 'On'
			and otherdevices[dusk_trigger] == 'On'
			and otherdevices[isdark_xmas_lights] == 'On'
			and otherdevices[isdark_dinnertable_light] == 'On'
			and otherdevices[isdark_livingroom_lights1] == 'On'
			and otherdevices[isdark_livingroom_lights2] == 'On'
			and otherdevices[isdark_garden_lights] == 'Off'
			and otherdevices[pico_power]   == 'On'			
			and timedifference(otherdevices_lastupdate[isdark_livingroom_lights2]) > timeon_garden_lights
			and uservariables[security_activation_type] == 0			
		then
			commandArray[isdark_garden_lights]='On'			
		end

--------
		
	    if otherdevices[dusk_sensor] == 'Off'
			and otherdevices[isdark_xmas_lights] == 'On'
			and otherdevices[pico_power]   == 'On'	
			and uservariables[security_activation_type] == 0			
		then
			commandArray[isdark_garden_lights]='Off'
			commandArray[isdark_livingroom_lights2]='Off'	
			commandArray[isdark_livingroom_lights1]='Off'		
			commandArray[isdark_dinnertable_light]='Off'
			commandArray[isdark_xmas_lights]='Off'
			timer_body = 'The sun is up'	
			timer_body0 = 'While Solar radiation at '..sSolar..' Watt/m2'		
		end		