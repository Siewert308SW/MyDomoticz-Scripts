--
-- **********************************************************
-- Calculate Temp Average Garage
-- **********************************************************
--

	if devicechanged["Garage Temp Trigger"] == 'On' then

	-- Get Temp Values
		local garage_smoketemp	= tonumber(otherdevices_svalues["Garage_Rookmelder_Temp"])
		local garage_motiontemp = tonumber(otherdevices_svalues["Garage_Motion_Temp"])
		local wasmachine_temp   = tonumber(otherdevices_svalues["Wasmachine_WCD_Temp"])
		local boiler_temp 		= tonumber(otherdevices_svalues["E-Boiler_WCD_Temp"])
		local dryer_temp 		= tonumber(otherdevices_svalues["Droger_Temp"])
		local heater_temp 		= tonumber(otherdevices_svalues["Garage_Heater_Temp"])
		
	-- Create table
		--local garage_sensors={garage_smoketemp, garage_motiontemp, wasmachine_temp, boiler_temp, dryer_temp, heater_temp}
		local garage_sensors={--[[garage_motiontemp, --]]garage_smoketemp, heater_temp, boiler_temp}
						
	-- Calculate Average		
		local temp_elements_average = 0
		local sum_temp_average = 0
			
		for k,v in pairs(garage_sensors) do
			sum_temp_average = sum_temp_average + v
			temp_elements_average = temp_elements_average + 1
		end

		local temp_ave_average = sum_temp_average / temp_elements_average
		local temp_average = round(temp_ave_average,2)
		local tempsensor_output_average = tonumber(otherdevices_svalues["Gemiddelde_Temp_Garage"])
		local tempsensor_output_average_round = round(tempsensor_output_average,2)
		
	--Write Average Temp

		if tempsensor_output_average_round ~= temp_average then
			commandArray[#commandArray+1]={['UpdateDevice']='1002|nValue|'..temp_average..''}
		end
	end	
	
