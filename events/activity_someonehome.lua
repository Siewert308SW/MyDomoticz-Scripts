--
-- **********************************************************
-- SomeOneHome AtHome
-- **********************************************************
--
		
	if (devicechanged["Voor_Deur"] == 'Open'
		or devicechanged["Garage_Deur"] == 'Open'
		or devicechanged["Achter_Deur"] == 'Open'
		or devicechanged["Hal_Deur"] == 'Open'
		or devicechanged["Bijkeuken_Deur"] == 'Open')
		and otherdevices["Thuis"] == 'Off'
		and timedifference(otherdevices_lastupdate["Woonkamer_Verlichting UIT"]) > 60
		and timedifference(otherdevices_lastupdate["Garage_Controler_Woonkamer UIT"]) > 60
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Thuis"] = "On"}
		commandArray[#commandArray+1]={["Scene:Standbykillers ON"] = "On AFTER 10"}
		commandArray[#commandArray+1]={["CatFlap"] = "On"}
		if lichtweek('false') and otherdevices["Voordeur_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "On AFTER 30"}
		commandArray[#commandArray+1]={["Achterdeur_WCD"] = "On AFTER 31"}
		end
			
	end
	
	if devicechanged["Overloop_Deur"] == 'Open'
		and (uservariables["manual_light"] == 1 or otherdevices["Thuis"] == 'Off')
		and timedifference(otherdevices_lastupdate["Woonkamer_Verlichting UIT"]) > 60
		and timedifference(otherdevices_lastupdate["Garage_Controler_Woonkamer UIT"]) > 60
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Thuis"] = "On"}
		commandArray[#commandArray+1]={["Scene:Standbykillers ON"] = "On AFTER 10"}
		commandArray[#commandArray+1]={["CatFlap"] = "On"}
		commandArray[#commandArray+1]={["Variable:manual_light"] = "0"}
		if lichtweek('false') and otherdevices["Voordeur_WCD"] == 'Off' then
		commandArray[#commandArray+1]={["Voordeur_WCD"] = "On AFTER 30"}
		commandArray[#commandArray+1]={["Achterdeur_WCD"] = "On AFTER 31"}
		end
	end
			
--
-- **********************************************************
-- SomeOneHome: Instant Away
-- **********************************************************
--
	
	if (devicechanged["Jerina_GSM"] == 'Off'
		or devicechanged["Siewert_GSM"] == 'Off'
		or devicechanged["Natalya_GSM"] == 'Off'
		or devicechanged["Jerina_Laptop"] == 'Off'
		or devicechanged["Siewert_Laptop"] == 'Off'
		or devicechanged["Natalya_Laptop"] == 'Off')
		and phones_online('false')
		and laptops_online('false')
		and otherdevices["Thuis"] == 'On'
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Thuis"] = "Off"}
		commandArray[#commandArray+1]={["Scene:Standbykillers OFF"] = "On AFTER 10"}
		commandArray[#commandArray+1]={["CatFlap"] = "Off"}		
		if lichtweek('false') and otherdevices["Voordeur_WCD"] == 'On' then
			commandArray[#commandArray+1]={["Voordeur_WCD"] = "Off AFTER 30"}
			commandArray[#commandArray+1]={["Achterdeur_WCD"] = "Off AFTER 35"}
		end		
	end
		
--
-- **********************************************************
-- SomeOneHome: Away
-- **********************************************************
--
if devicechanged["Time Trigger 1min"] == 'On' and laptops_online('false') and tv_online('false') and otherdevices["Thuis"] == 'On' then

	if otherdevices["Thuis"] == 'On'
		and uservariables["manual_light"] == 1
		--and tv_online('false')
		and motion('false', 120)
		and dark('true', 'inside', 100)
		and uservariables["panic"] == 0
		--and (timebetween("22:00:00","23:59:59") or timebetween("00:00:00","09:59:59"))			
	then
		commandArray[#commandArray+1]={["Thuis"] = "Off"}
		commandArray[#commandArray+1]={["Scene:Standbykillers OFF"] = "On AFTER 10"}
		commandArray[#commandArray+1]={["CatFlap"] = "Off"}		
		if lichtweek('false') and otherdevices["Voordeur_WCD"] == 'On' then
			commandArray[#commandArray+1]={["Voordeur_WCD"] = "Off AFTER 30"}
			commandArray[#commandArray+1]={["Achterdeur_WCD"] = "Off AFTER 35"}
		end		
	end
	
-- **********************************************************


	if otherdevices["Thuis"] == 'On'
		and uservariables["manual_light"] == 0
		--and tv_online('false')
		--and laptops_online('false')
		and motion('false', 3600)
		--and dark('true', 'inside', 100)
		and uservariables["panic"] == 0
		--and (timebetween("22:00:00","23:59:59") or timebetween("00:00:00","09:59:59"))			
	then
		commandArray[#commandArray+1]={["Thuis"] = "Off"}
		commandArray[#commandArray+1]={["Scene:Standbykillers OFF"] = "On AFTER 10"}
		commandArray[#commandArray+1]={["CatFlap"] = "Off"}		
		if lichtweek('false') and otherdevices["Voordeur_WCD"] == 'On' then
			commandArray[#commandArray+1]={["Voordeur_WCD"] = "Off AFTER 30"}
			commandArray[#commandArray+1]={["Achterdeur_WCD"] = "Off AFTER 35"}
		end		
	end

end
		