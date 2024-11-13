--
-- **********************************************************
-- Front or Back Garden lights ON
-- **********************************************************
--

	if (devicechanged["Voordeur_Motion"] == 'On' or devicechanged["Achterdeur_Motion"] == 'On' or devicechanged["Fietsenschuur_Deur"] == 'Open')
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and uservariables["tuin_activity"] == 0
		and dark('true', 'outside', 0)
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Variable:tuin_activity"] = "1"}
		commandArray[#commandArray+1]={["Voordeur_Verlichting"] = "Set Level 7"}
		commandArray[#commandArray+1]={["Brandgang_Verlichting"] = "Set Level 7 AFTER 1"}
		commandArray[#commandArray+1]={["Achterdeur_Verlichting"] = "Set Level 7 AFTER 2"}
		commandArray[#commandArray+1]={["Fietsenschuur_Buiten_Verlichting"] = "Set Level 7 AFTER 3"}
	end
	
--
-- **********************************************************
-- Front or Back Garden lights ON @ leaving
-- **********************************************************
--

	if devicechanged["Voor_Deur"] == 'Open'
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and uservariables["tuin_activity"] == 0
		and dark('true', 'outside', 0)
		and timedifference(otherdevices_lastupdate["Hal_Motion"]) > 60
		and uservariables["panic"] == 0
	then
		commandArray[#commandArray+1]={["Variable:tuin_activity"] = "1"}
		commandArray[#commandArray+1]={["Voordeur_Verlichting"] = "Set Level 7"}
		commandArray[#commandArray+1]={["Brandgang_Verlichting"] = "Set Level 7 AFTER 1"}
		commandArray[#commandArray+1]={["Achterdeur_Verlichting"] = "Set Level 7 AFTER 2"}
		commandArray[#commandArray+1]={["Fietsenschuur_Buiten_Verlichting"] = "Set Level 7 AFTER 3"}
	end
	
	if (devicechanged["Achter_Deur"] == 'Open' or devicechanged["Garage_Deur"] == 'Open')
		and otherdevices["Voordeur_Verlichting"] == 'Off'
		and uservariables["tuin_activity"] == 0
		and dark('true', 'outside', 0)
		and timedifference(otherdevices_lastupdate["Achterdeur_Motion"]) > 60
		and uservariables["panic"] == 0
	then
		commandArray[#commandArray+1]={["Variable:tuin_activity"] = "1"}
		commandArray[#commandArray+1]={["Voordeur_Verlichting"] = "Set Level 7 AFTER 2"}
		commandArray[#commandArray+1]={["Brandgang_Verlichting"] = "Set Level 7 AFTER 1"}
		commandArray[#commandArray+1]={["Achterdeur_Verlichting"] = "Set Level 7"}
		commandArray[#commandArray+1]={["Fietsenschuur_Buiten_Verlichting"] = "Set Level 7 AFTER 3"}
	end

--
-- **********************************************************
-- Front or Back Garden lights OFF
-- **********************************************************
--

if devicechanged["Lux Time Trigger"] == 'On' and otherdevices["Voordeur_Verlichting"] ~= 'Off' and uservariables["tuin_activity"] == 1 then

	if dark('true', 'outside', 10)
		and garden_motion('false', 240)
		and uservariables["panic"] == 0
	then
		commandArray[#commandArray+1]={["Variable:tuin_activity"] = "0"}
		commandArray[#commandArray+1]={["Voordeur_Verlichting"] = "Off"}
		commandArray[#commandArray+1]={["Brandgang_Verlichting"] = "Off AFTER 1"}
		commandArray[#commandArray+1]={["Achterdeur_Verlichting"] = "Off AFTER 2"}
		commandArray[#commandArray+1]={["Fietsenschuur_Buiten_Verlichting"] = "Off AFTER 3"}
	end
	
	if dark('false', 'outside', 10)
		and uservariables["panic"] == 0
	then
		commandArray[#commandArray+1]={["Variable:tuin_activity"] = "0"}
		commandArray[#commandArray+1]={["Voordeur_Verlichting"] = "Off"}
		commandArray[#commandArray+1]={["Brandgang_Verlichting"] = "Off AFTER 1"}
		commandArray[#commandArray+1]={["Achterdeur_Verlichting"] = "Off AFTER 2"}
		commandArray[#commandArray+1]={["Fietsenschuur_Buiten_Verlichting"] = "Off AFTER 3"}
	end

end