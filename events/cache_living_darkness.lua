--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Time Trigger 1min"}) then return end

--
-- **********************************************************
-- IsDark or IsNotDark
-- **********************************************************
--

	if devicechanged["Time Trigger 1min"] == 'Off' then
	
		if otherdevices["Feestdagen"] == 'Off' then
			local s1 = sensorValue("Woonkamer_LUX") or 0
			local s2 = sensorValue("Hal_LUX") or 0
			local s3 = sensorValue("Voordeur_LUX") or 0
			local s4 = sensorValue("Achterdeur_LUX") or 0
			
				if uservariables["woonkamer_verlichting_auto"] == 2 then
				sensorLivingTotal = round((s1 + s2 + s3 + s4) / 4, 0)				
				else
				sensorLivingTotal = round((s1 + s2 + s3 + s4) / 5, 0)				
				end
				
		else
			local s1 = sensorValue("Woonkamer_LUX") or 0
			local s2 = sensorValue("Hal_LUX") or 0
			local s3 = sensorValue("Achterdeur_LUX") or 0
			local s4 = sensorValue("Achterdeur_LUX") or 0

				if uservariables["woonkamer_verlichting_auto"] == 2 then
				sensorLivingTotal = round((s1 + s2 + s3 + s4) / 4, 0)				
				else
				sensorLivingTotal = round((s1 + s2 + s3 + s4) / 5, 0)				
				end
		
		end

		if sensorValue('Woonkamer_Gem_Lux') ~= sensorLivingTotal then

			commandArray['UpdateDevice']='6317|nValue|'..sensorLivingTotal..''
		end
	
	end
	