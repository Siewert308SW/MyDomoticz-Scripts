--
-- **********************************************************
-- Calculate Temp Average Outside
-- **********************************************************
--

	if devicechanged["Outside Temp Trigger"] == 'On' then

	-- Get Temp Values
		local frontdoor_sensor	  		= tonumber(otherdevices_svalues["Voortuin_Temp"])
		local backdoor_sensor 			= tonumber(otherdevices_svalues["Achtertuin_Temp"])

	-- Create table
	
		local outside_sensors={frontdoor_sensor, backdoor_sensor}
			
	-- Calculate Average		
		local temp_elements_average = 0
		local sum_temp_average = 0
			
		for k,v in pairs(outside_sensors) do
			sum_temp_average = sum_temp_average + v
			temp_elements_average = temp_elements_average + 1
		end

		local temp_ave_average = sum_temp_average / temp_elements_average
		local temp_average = round(temp_ave_average,1)
		local tempsensor_output_average = tonumber(otherdevices_svalues["Gemiddelde_Temp_Buiten"])
		local tempsensor_output_average_round = round(tempsensor_output_average,1)
		
	--Write Average Temp

		if tempsensor_output_average_round ~= temp_average then
			commandArray[#commandArray+1]={['UpdateDevice']='510|nValue|'..temp_average..''}
		end
	end	
	
