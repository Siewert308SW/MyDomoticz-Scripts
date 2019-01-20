--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ control_heating.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 20-01-2019
	@ Script to switch ON/OFF heating including a override incase i manual set setpoint higher or lower
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Turn heating ON when SomeOneHome
-- **********************************************************
--

		if devicechanged[lux_sensor.upstairs]
			and otherdevices[someone.home] == 'Thuis'
			and device_svalue(temp.porch) <= nest.trigger_temp_summer
			and nesttemp_svalue(nest.room_temp) < nest.trigger_temp_summer
			and uservariables[var.preheat_override] == 0
			and uservariables[var.heat_override] == 0
			and timebetween("08:30:00","22:29:59")
		then
		
			if device_svalue(nest.setpoint) ~= nest.setpoint_temp_summer
				and device_svalue(temp.porch) < nest.trigger_temp_summer			
				and device_svalue(temp.porch) >= nest.trigger_temp_autumn
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp_summer)
			    commandArray["Variable:" .. var.heat_override .. ""]= '1'
			end
			
-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.setpoint_temp_autumn
				and device_svalue(temp.porch) < nest.trigger_temp_autumn
				and device_svalue(temp.porch) >= nest.trigger_temp_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp_autumn)
			    commandArray["Variable:" .. var.heat_override .. ""]= '1'
			end			

-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.setpoint_temp_winter
				and device_svalue(temp.porch) < nest.trigger_temp_winter
				and device_svalue(temp.porch) >= nest.trigger_temp_artic_winter				
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp_winter)
			    commandArray["Variable:" .. var.heat_override .. ""]= '1'
			end

-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.setpoint_temp_artic_winter
				and device_svalue(temp.porch) < nest.trigger_temp_artic_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_temp_artic_winter)
			    commandArray["Variable:" .. var.heat_override .. ""]= '1'
			end
			
		end	

--
-- **********************************************************
-- Turn heating OFF when SomeBodyHome @ specific time
-- **********************************************************
--

		if devicechanged[lux_sensor.upstairs]				
			and otherdevices[someone.home] == 'Thuis'
			and otherdevices[media_device.tv] == 'Off'				
			and uservariables[var.heat_override] == 1
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hours3			
			and (timebetween("22:30:00","23:59:59") or timebetween("00:00:00","08:59:59"))
			and weekend('false')			
		then
		
			if device_svalue(nest.setpoint) ~= nest.eco_temp_summer			
				and device_svalue(temp.porch) >= nest.trigger_temp_autumn
				and (timebetween("22:30:00","23:59:59") or timebetween("00:00:00","08:59:59"))				
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_summer)
			    commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end

-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.eco_temp_autumn
				and device_svalue(temp.porch) < nest.trigger_temp_autumn
				and device_svalue(temp.porch) >= nest.trigger_temp_winter
				and (timebetween("22:30:00","23:59:59") or timebetween("00:00:00","08:59:59"))					
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_autumn)
			    commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end

-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.eco_temp_winter
				and device_svalue(temp.porch) < nest.trigger_temp_winter
				and device_svalue(temp.porch) >= nest.trigger_temp_artic_winter				
				and (timebetween("22:30:00","23:59:59") or timebetween("00:00:00","08:59:59"))					
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_winter)
			    commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end
			
-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.eco_temp_artic
				and device_svalue(temp.porch) < nest.trigger_temp_artic_winter
				and (timebetween("22:30:00","23:59:59") or timebetween("00:00:00","08:59:59"))					
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_artic)
			    commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end			

		end
		
--
-- **********************************************************
-- Turn heating OFF when NoBodyHome
-- **********************************************************
--

		if devicechanged[lux_sensor.porch]			
			and otherdevices[someone.home] ~= 'Thuis'
			and uservariables[var.heat_override] == 1			
		then
		
			if otherdevices[someone.home] == 'Slapen'
				and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.minute1			
				and device_svalue(nest.setpoint) ~= nest.eco_temp_summer			
				and device_svalue(temp.porch) >= nest.trigger_temp_autumn
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_summer)
				commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end

-- **********************************************************

			if otherdevices[someone.home] == 'Slapen'
				and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.minute1			
				and device_svalue(nest.setpoint) ~= nest.eco_temp_autumn
				and device_svalue(temp.porch) < nest.trigger_temp_autumn
				and device_svalue(temp.porch) >= nest.trigger_temp_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_autumn)
				commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end

-- **********************************************************

			if otherdevices[someone.home] == 'Slapen'
				and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.minute1			
				and device_svalue(nest.setpoint) ~= nest.eco_temp_winter
				and device_svalue(temp.porch) < nest.trigger_temp_winter
				and device_svalue(temp.porch) >= nest.trigger_temp_artic_winter				
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_winter)
				commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end
			

-- **********************************************************

			if otherdevices[someone.home] == 'Slapen'
				and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.minute1			
				and device_svalue(nest.setpoint) ~= nest.eco_temp_artic
				and device_svalue(temp.porch) < nest.trigger_temp_artic_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_artic)
				commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end			

-- **********************************************************
-- **********************************************************
			
			if otherdevices[someone.home] == 'Weg'
				and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1				
				and device_svalue(nest.setpoint) ~= nest.eco_temp_summer			
				and device_svalue(temp.porch) >= nest.trigger_temp_autumn
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_summer)
				commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end

-- **********************************************************

			if otherdevices[someone.home] == 'Weg'
				and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1				
				and device_svalue(nest.setpoint) ~= nest.eco_temp_autumn
				and device_svalue(temp.porch) < nest.trigger_temp_autumn
				and device_svalue(temp.porch) >= nest.trigger_temp_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_autumn)
				commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end

-- **********************************************************

			if otherdevices[someone.home] == 'Weg'
				and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1			
				and device_svalue(nest.setpoint) ~= nest.eco_temp_winter
				and device_svalue(temp.porch) < nest.trigger_temp_winter
				and device_svalue(temp.porch) >= nest.trigger_temp_artic_winter					
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_winter)
				commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end	

-- **********************************************************

			if otherdevices[someone.home] == 'Weg'
				and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hour1			
				and device_svalue(nest.setpoint) ~= nest.eco_temp_artic
				and device_svalue(temp.porch) < nest.trigger_temp_artic_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_artic)
				commandArray["Variable:" .. var.heat_override .. ""]= '0'
			end			

		end
		

-- **********************************************************
-- Turn Preheating ON when NoBodyHome
-- **********************************************************
--

		if devicechanged[lux_sensor.hallway]			
			and otherdevices[someone.home] ~= 'Thuis'
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hours4
			and timedifference(otherdevices_lastupdate[someone.home]) < timeout.hours8			
			and device_svalue(temp.porch) <= nest.trigger_temp_summer
			and nesttemp_svalue(nest.room_temp) < nest.trigger_temp_summer
			and uservariables[var.preheat_override] == 0
			and timebetween("13:00:00","17:59:59")
			and weekend('false')
		then

			if device_svalue(nest.setpoint) ~= nest.setpoint_preheat_autumn
				and device_svalue(temp.porch) < nest.trigger_temp_autumn
				and device_svalue(temp.porch) >= nest.trigger_temp_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_preheat_autumn)
			    commandArray["Variable:" .. var.preheat_override .. ""]= '1'
			end			

-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.setpoint_preheat_winter
				and device_svalue(temp.porch) < nest.trigger_temp_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.setpoint_preheat_winter)
			    commandArray["Variable:" .. var.preheat_override .. ""]= '1'
			end		
			
		end

--
-- **********************************************************
-- Turn Preheating OFF when SomeBodyHome
-- **********************************************************
--
		
		if devicechanged[lux_sensor.upstairs]			
			and otherdevices[someone.home] == 'Thuis'
			and uservariables[var.preheat_override] == 1		
		then
			commandArray["Variable:" .. var.preheat_override .. ""]= '0'
		end


--
-- **********************************************************
-- Turn Preheating OFF while still NoBodyHome
-- **********************************************************
--

		if devicechanged[lux_sensor.hallway]			
			and otherdevices[someone.home] ~= 'Thuis'
			and uservariables[var.preheat_override] == 1		
			and timedifference(otherdevices_lastupdate[someone.home]) >= timeout.hours8			
		then
		
			if device_svalue(nest.setpoint) ~= nest.eco_temp_summer			
				and device_svalue(temp.porch) >= nest.trigger_temp_autumn
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_summer)
			    commandArray["Variable:" .. var.preheat_override .. ""]= '0'
			end

-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.eco_temp_autumn
				and device_svalue(temp.porch) < nest.trigger_temp_autumn
				and device_svalue(temp.porch) >= nest.trigger_temp_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_autumn)
			    commandArray["Variable:" .. var.preheat_override .. ""]= '0'
			end

-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.eco_temp_winter
				and device_svalue(temp.porch) < nest.trigger_temp_winter
				and device_svalue(temp.porch) >= nest.trigger_temp_artic_winter				
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_winter)
			    commandArray["Variable:" .. var.preheat_override .. ""]= '0'
			end

-- **********************************************************

			if device_svalue(nest.setpoint) ~= nest.eco_temp_artic
				and device_svalue(temp.porch) < nest.trigger_temp_artic_winter
			then
				commandArray['SetSetPoint:'..nest.setpoint_idx]=tostring(nest.eco_temp_artic)
			    commandArray["Variable:" .. var.preheat_override .. ""]= '0'
			end
			
		end
