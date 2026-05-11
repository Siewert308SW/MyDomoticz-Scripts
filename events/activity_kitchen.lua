--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Achter_Deur", "Time Trigger 1min" }) then return end
	
--
-- **********************************************************
-- Kitchen light level up @ motion
-- **********************************************************
--
	
	if devicechanged["Achter_Deur"] == 'Open'
		and otherdevices["Personen"] == 'Aanwezig'
		and lastSeen('Personen', '>', 60)
		and lastSeen('Achterdeur_Motion', '<=', 60)
		and otherdevices["Bijkeuken_Spots_Verlichting"] ~= 'Off'
		and uservariables["bijkeuken_activity"] == 0
		and powerFailsave('false')
	then
		--switchDevice("Bijkeuken_Spots_Verlichting", "Set Level 20")
		switchDevice("Variable:bijkeuken_activity", "1")
		debugLog('Iemand in de bijkeuken?')			
	end

--[[
	if devicechanged["Achter_Deur"] == 'Open'
		and (otherdevices["Personen"] == 'Slapen' or otherdevices["Personen"] == 'Weg')
		and lastSeen('Personen', '>', 60)
		and lastSeen('Achterdeur_Motion', '<=', 60)
		and otherdevices["Bijkeuken_Spots_Verlichting"] ~= 'Off'
		and uservariables["bijkeuken_activity"] == 0
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Bijkeuken_Spots_Verlichting"] = "Set Level 20 AFTER 10"}
		switchDevice("Variable:bijkeuken_activity", "1")
		debugLog('Iemand in de bijkeuken?')			
	end
	--]]
--
-- **********************************************************
-- Kitchen light level down @ no motion
-- **********************************************************
--
--[[
	if devicechanged["Time Trigger 1min"] == 'On'
		and uservariables["bijkeuken_activity"] == 1
		and lastSeenVar("bijkeuken_activity", ">=",60)
		and lastSeen('Achter_Deur', '>=', 60)
		and lastSeen('Achterdeur_Motion', '>=', 120)
		and powerFailsave('false')
	then
		--switchDevice("Bijkeuken_Spots_Verlichting", "Set Level 6")
		switchDevice("Variable:bijkeuken_activity", "0")
		debugLog('Niemand in de bijkeuken?')			
	end
--]]