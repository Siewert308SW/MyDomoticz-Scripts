--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 1min"}) then return end
	
--
-- **********************************************************
-- Shed Heater ON/OFF Variables
-- **********************************************************
--
	if devicechanged["Time Trigger 1min"] == 'Off' then
	
		hysteresis						  = 0.5                             			-- Wiggle room for temperature, else relays/switch gets used too much
		setpoint         				  = 14										-- setpoint
		switch     						  = 'Fietsenschuur_Heater_WCD'               	-- heater wcd_plug switch name
		faseMaxPowerUsage				  = 5000
		
	-- Get Temp Values
		shed_temp1						  = otherdevices_temperature["Fietsenschuur_Deur_Temp"]
		shed_temp2						  = otherdevices_temperature["Fietsenschuur_Motion_Temp"]
		shed_temp3						  = otherdevices_temperature["Fietsenschuur_Heater_Temp"]
		sensor_outside1    				  = otherdevices_temperature["Voortuin_Temp"]
		sensor_outside2   				  = otherdevices_temperature["Achtertuin_Temp"]
		heater_setpoint    				  = tonumber(otherdevices["Fietsenschuur_Setpoint"]) or setpoint
		fasePowerAvailable			      = tonumber(faseMaxPowerUsage - homewizard('L2'))
		
		
	-- Create table
		shed_sensors					  = {shed_temp2, shed_temp3}
		outside_sensors					  = {sensor_outside1, sensor_outside2}
		
	-- Calculate Average		
		inside_temp_elements_average 	  = 0
		outside_temp_elements_average     = 0
		inside_sum_temp_average 		  = 0
		outside_sum_temp_average 	      = 0
		
		for k,v in pairs(shed_sensors) do
			inside_sum_temp_average 	  = inside_sum_temp_average + v
			inside_temp_elements_average  = inside_temp_elements_average + 1
		end

		inside_temp_average 			  = inside_sum_temp_average / inside_temp_elements_average
		inside_temp			 			  = round(inside_temp_average,1)

		for k,v in pairs(outside_sensors) do
			outside_sum_temp_average 	  = outside_sum_temp_average + v
			outside_temp_elements_average = outside_temp_elements_average + 1
		end

		outside_temp_average 			  = outside_sum_temp_average / outside_temp_elements_average
		outside_temp		 			  = round(outside_temp_average,1)	
--
-- **********************************************************
-- Shed Heater ON/OFF Failsaves
-- **********************************************************
--

	heating_allowed = true

-- Fase te zwaar of deur te lang open → niet verwarmen
		if fasePowerAvailable < 1100 and otherdevices[switch] == 'Off' then
			heating_allowed = false

		elseif fasePowerAvailable <= 0 and otherdevices[switch] == 'On' then
			heating_allowed = false
			
		elseif otherdevices["Fietsenschuur_Deur"] == 'Open' and lastSeen("Fietsenschuur_Deur", ">", 120) then
			heating_allowed = false
			
		elseif outside_temp_average >= 14 then
			heating_allowed = false

		end

		print("--------------------------")
		print(" ")
		print("Setpoint: "..heater_setpoint.."")
		print("Binnen Temp: "..inside_temp.."")
		print("Buiten Temp: "..outside_temp.."")
		if heating_allowed == true then
		print("heating_allowed == true")
		else
		print("heating_allowed == false")
		end

		if otherdevices[switch] == 'On' then
		print("heating: AAN")
		else
		print("heating: UIT")
		end
		
--
-- **********************************************************
-- Shed Heater ON/OFF and sensorValue('Fietsenschuur_Heater_Huidige_Verbruik') <= 800
-- **********************************************************
--
		if heating_allowed == false and otherdevices[switch] == 'On' then
			switchDevice(switch, "Off")
			debugLog('Kachel UIT #heating_Allowed = false')
		print("Kachel UIT #heating_Allowed = false")
		
		elseif heating_allowed == true and lastSeen(switch, ">", 600) and inside_temp <= (heater_setpoint - hysteresis) and otherdevices[switch] == 'Off' and otherdevices["Fietsenschuur_Deur"] == 'Closed' and powerFailsave('false') then
			switchDevice(switch, "On")
			debugLog('Kachel AAN #heating_Allowed = true')
		print("Kachel AAN #heating_Allowed = true")
		
		elseif heating_allowed == true and lastSeen(switch, ">", 600) and inside_temp >= (heater_setpoint + hysteresis) and otherdevices[switch] == 'On' then
			switchDevice(switch, "Off")
			debugLog('Kachel UIT #Setpoint behaald')
		print("Kachel UIT #Setpoint behaald")
		
		end

		print(" ")
		print("--------------------------")
	end