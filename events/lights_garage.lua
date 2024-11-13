--
-- **********************************************************
-- Garage lights ON
-- **********************************************************
--

	if devicechanged["Garage_Deur"] == 'Open'
		and otherdevices["Garage_Verlichting"] == 'Off'
		and otherdevices["Thuis"] == 'Off'
		and otherdevices["Garage_Motion"] == 'Off'
		and timedifference(otherdevices_lastupdate["Garage_Motion"]) > 30
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Garage_Verlichting"] = "On"}
	end

	if (devicechanged["Bijkeuken_Deur"] == 'Open' or devicechanged["Garage_Deur"] == 'Open' or devicechanged["Garage_Motion"] == 'On')
		and otherdevices["Garage_Verlichting"] == 'Off'
		and otherdevices["Thuis"] == 'On'
		--and otherdevices["Garage_Motion"] == 'Off'
		--and timedifference(otherdevices_lastupdate["Garage_Motion"]) > 5
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Garage_Verlichting"] = "On"}
	end

-- **********************************************************
--[[	
	if devicechanged["Garage_Motion"] == 'On'
		and otherdevices["Garage_Verlichting"] == 'Off'
		and timedifference(otherdevices_lastupdate["Garage_Verlichting"]) <= 600
		and otherdevices["Thuis"] == 'On'
		and uservariables["panic"] == 0		
	then
		commandArray[#commandArray+1]={["Garage_Verlichting"] = "On"}
	end
--]]	
--
-- **********************************************************
-- Garage lights OFF
-- **********************************************************
--
		
	if devicechanged["Time Trigger 1min"]
		and otherdevices["Garage_Verlichting"] == 'On'
		and otherdevices["Garage_Motion"] == 'Off'
		and timedifference(otherdevices_lastupdate["Garage_Motion"]) > 300
		and timedifference(otherdevices_lastupdate["Bijkeuken_Deur"]) > 300
		and timedifference(otherdevices_lastupdate["Garage_Deur"]) > 300
		and uservariables["panic"] == 0		
	then
	
		if otherdevices["Thuis"] == 'On'
			and otherdevices["Bijkeuken_Deur"] == 'Closed'
			and otherdevices["Garage_Deur"] == 'Closed'
			and timedifference(otherdevices_lastupdate["Garage_Motion"]) > 120
			and timedifference(otherdevices_lastupdate["Bijkeuken_Deur"]) > 120
			and timedifference(otherdevices_lastupdate["Garage_Deur"]) > 120
		then
			commandArray[#commandArray+1]={["Garage_Verlichting"] = "Off"}
		end

		if otherdevices["Thuis"] == 'On'
			and otherdevices["Bijkeuken_Deur"] == 'Open'
			and otherdevices["Garage_Deur"] == 'Closed'
			and timedifference(otherdevices_lastupdate["Garage_Motion"]) > 300
			and timedifference(otherdevices_lastupdate["Bijkeuken_Deur"]) > 300
			and timedifference(otherdevices_lastupdate["Garage_Deur"]) > 300
		then
			commandArray[#commandArray+1]={["Garage_Verlichting"] = "Off"}
		end
		
		if otherdevices["Thuis"] == 'On'
			and (otherdevices["Bijkeuken_Deur"] == 'Open' or otherdevices["Garage_Deur"] == 'Open')
			and timedifference(otherdevices_lastupdate["Garage_Motion"]) > 600
			and timedifference(otherdevices_lastupdate["Bijkeuken_Deur"]) > 600
			and timedifference(otherdevices_lastupdate["Garage_Deur"]) > 600
		then
			commandArray[#commandArray+1]={["Garage_Verlichting"] = "Off"}
		end
		
		if otherdevices["Thuis"] == 'Off'
			and timedifference(otherdevices_lastupdate["Garage_Motion"]) > 60
			and timedifference(otherdevices_lastupdate["Bijkeuken_Deur"]) > 60
			and timedifference(otherdevices_lastupdate["Garage_Deur"]) > 60
		then
			commandArray[#commandArray+1]={["Garage_Verlichting"] = "Off"}
		end		
	end