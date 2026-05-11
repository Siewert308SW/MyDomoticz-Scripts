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
			local s1 = sensorValue("Voordeur_LUX") or 0
			local s2 = sensorValue("Achterdeur_LUX") or 0
			sensorGardenTotal = round((s1 + s2) / 2, 0)
				
		else
			local s1 = sensorValue("Achterdeur_LUX") or 0
			local s2 = sensorValue("Achterdeur_LUX") or 0
			sensorGardenTotal = round((s1 + s2) / 2, 0)
		end

		if sensorValue('Tuin_Gem_Lux') ~= sensorGardenTotal then

			commandArray['UpdateDevice']='6318|nValue|'..sensorGardenTotal..''
		end
	
	end
	