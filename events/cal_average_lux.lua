--
-- **********************************************************
--
-- **********************************************************
--

	if devicechanged["Lux Time Trigger"] == 'On'
		and timedifference(otherdevices_lastupdate["Gemiddelde_LUX_Binnen"]) > 180
	then
		dark_average('true', 'inside', 30000)
	end
	
--
-- **********************************************************
--
-- **********************************************************
--

	if devicechanged["Lux Time Trigger"] == 'Off' 
		and timedifference(otherdevices_lastupdate["Gemiddelde_LUX_Buiten"]) > 180
	then
		dark_average('true', 'outside', 30000)
	end