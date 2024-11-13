--
-- **********************************************************
-- Calculate Temp Average Inside
-- **********************************************************
--

	if devicechanged["Outside Temp Trigger"] == 'Off' then

	-- Get Temp Values
		local sensor1	  		= tonumber(otherdevices_svalues["Woonkamer_Rookmelder_Temp"])
		local sensor2 			= tonumber(otherdevices_svalues["Woonkamer_Motion_Temp"])
		local sensor3	  		= tonumber(otherdevices_svalues["Keuken Motion_Temp"])
		local sensor4 			= tonumber(otherdevices_svalues["Hal_Rookmelder_Temp"])
		local sensor5	  		= tonumber(otherdevices_svalues["Hal_Motion_Temp"])
		--local sensor6 			= tonumber(otherdevices_svalues["Overloop_Rookmelder_Temp"])
		--local sensor7	  		= tonumber(otherdevices_svalues["Overloop_Motion_Temp"])
		local sensor8 			= tonumber(otherdevices_svalues["Toilet_Motion_Temp"])
		--local sensor9	  		= tonumber(otherdevices_svalues["Natalya_Slaapkamer_Rookmelder_Temp"])
		--local sensor10 			= tonumber(otherdevices_svalues["Slaapkamer_Rookmelder_Temp"])
		--local sensor11	  		= tonumber(otherdevices_svalues["Badkamer_Motion_Temp"])
		
	-- Create table
	
		--local inside_sensors={sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7, sensor8, sensor9, sensor10, sensor11}
		local inside_sensors={sensor1, sensor2, sensor3, sensor4, sensor5, sensor8}
						
	-- Calculate Average		
		local temp_elements_average = 0
		local sum_temp_average = 0
			
		for k,v in pairs(inside_sensors) do
			sum_temp_average = sum_temp_average + v
			temp_elements_average = temp_elements_average + 1
		end

		local temp_ave_average = sum_temp_average / temp_elements_average
		local temp_average = round(temp_ave_average,1)
		local tempsensor_output_average = tonumber(otherdevices_svalues["Gemiddelde_Temp_Binnen"])
		local tempsensor_output_average_round = round(tempsensor_output_average,1)
		
	--Write Average Temp

		if tempsensor_output_average_round ~= temp_average then
			commandArray[#commandArray+1]={['UpdateDevice']='1487|nValue|'..temp_average..''}
		end
	end	
	
