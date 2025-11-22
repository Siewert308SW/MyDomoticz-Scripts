--
-- *********************************************************************
-- Check trigger before load script, saves resources
-- *********************************************************************
--
	if not isMyTrigger({"Voor_Deur", "Voordeur_Motion", "Achter_Deur", "Garage_Deur", "Achterdeur_Motion", "Fietsenschuur_Deur", "Time Trigger 5min" }) then return end
	
--
-- **********************************************************
-- Garden lights ON @ motion
-- **********************************************************
--
	
	if (devicechanged["Voor_Deur"] == 'Open' or devicechanged["Voordeur_Motion"] == 'On' or devicechanged["Achter_Deur"] == 'Open' or devicechanged["Garage_Deur"] == 'Open' or devicechanged["Achterdeur_Motion"] == 'On' or devicechanged["Fietsenschuur_Deur"] == 'Open')
		and (timebetween(sunTime("sunset"),"23:59:59") or timebetween("00:00:00","12:00:00"))
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and uservariables["tuin_activity"] == 0
		and uservariables["tuin_verlichting_auto"] == 0
		and dark('true', 'garden', 5)
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Scene:Tuinverlichting AAN"] = "On"}
		switchDevice("Variable:tuin_activity", "1")
	end

--[[
	if (devicechanged["Voor_Deur"] == 'Open' or devicechanged["Voordeur_Motion"] == 'On' or devicechanged["Achter_Deur"] == 'Open' or devicechanged["Garage_Deur"] == 'Open' or devicechanged["Achterdeur_Motion"] == 'On' or devicechanged["Fietsenschuur_Deur"] == 'Open')
		and timebetween(sunTime("sunsetEarly"),"23:29:59")
		and otherdevices["Voordeur_Verlichting"] ~= 'Off'
		and uservariables["tuin_activity"] == 0
		and uservariables["tuin_verlichting_auto"] == 1
		and dark('true', 'garden', 5)
		and powerFailsave('false')
	then
		switchDevice("Voordeur_Verlichting", "Set Level 45")	
		switchDevice("Brandgang_Verlichting", "Set Level 45") 
		switchDevice("Fietsenschuur_Buiten_Verlichting", "Set Level 45")		 
		switchDevice("Achterdeur_Verlichting", "Set Level 45")	
		switchDevice("Variable:tuin_activity", "2")
	end
--]]	
--
-- **********************************************************
-- Garden lights OFF @ no motion
-- **********************************************************
--

	if devicechanged["Time Trigger 5min"] == 'On'
		--and otherdevices["Voordeur_Verlichting"] ~= 'Off'
		and uservariables["tuin_activity"] == 1
		and uservariables["tuin_verlichting_auto"] == 0
		and motionGarden('false', 240)
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Scene:Tuinverlichting UIT"] = "On"}
		switchDevice("Variable:tuin_activity", "0")
	end
--[[	
	if devicechanged["Time Trigger 5min"] == 'On'
		--and otherdevices["Voordeur_Verlichting"] ~= 'Off'
		and uservariables["tuin_activity"] == 2
		and uservariables["tuin_verlichting_auto"] == 1
		and motionGarden('false', 120)
		and powerFailsave('false')
	then
		commandArray[#commandArray+1]={["Scene:Tuinverlichting AAN"] = "On"}
		switchDevice("Variable:tuin_activity", "0")
	end
--]]