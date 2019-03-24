--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ check_ups_state.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 18-2-2019
	@ Simple Lua script to check UPS status which is connected to my synology NAS

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]


	if devicechanged[ups.state] == 'ONBATTERY DISCHARGING'
		and uservariables[var.ups_state] == 0
	then
		commandArray["Variable:" .. var.ups_state .. ""]= '1'
		print('UPS - system running on battery')		
	end

	if devicechanged[timed.trigger] and uservariables[var.ups_state] ~= 0 then
	
		if otherdevices[ups.state] == 'ONBATTERY DISCHARGING' 
			and uservariables[var.ups_state] == 1
			and device_svalue(ups.battery) <= 98
		then
			print('UPS - Preparing system shutdown')			
			commandArray["Variable:" .. var.ups_state .. ""]= '2'
		end
		
		if otherdevices[ups.state] == 'ONBATTERY DISCHARGING' 
			and uservariables[var.ups_state] == 2
			and device_svalue(ups.battery) <= 95
		then
			print('UPS - Shutdown lighting scenes')
			commandArray[someone.home]='Set Level 20 AFTER 1'
			commandArray["Group:" ..group.standy_killers_zwave_away.. ""]='Off'
			commandArray["Group:" ..group.standy_killers_natalya.. ""]='Off AFTER 10'			
			commandArray["Scene:" ..scene.nobodyhome.. ""]='On AFTER 15 REPEAT 2 INTERVAL 15'		
			commandArray["Variable:" .. var.ups_state .. ""]= '3'
		end

		if otherdevices[ups.state] == 'ONBATTERY DISCHARGING' 
			and uservariables[var.ups_state] == 3
			and device_svalue(ups.battery) <= 90
		then
			print('UPS - Commence system shutdown')		
			system('shutdown')
		end	

		
		if otherdevices[ups.state] ~= 'ONBATTERY DISCHARGING' 
			and uservariables[var.ups_state] ~= 0
		then
			print('UPS - system running on power, reset variable')	
			commandArray["Variable:" .. var.ups_state .. ""]= '0'
		end

	end