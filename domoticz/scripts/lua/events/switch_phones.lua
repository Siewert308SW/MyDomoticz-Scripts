--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switch_phones.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 1-28-2018
	@ Script for switching phone switch to determine if SomeOneHome
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]	
	
--
-- **********************************************************
-- Phones ON/OFF
-- **********************************************************
--
	if (devicechanged[phone.jerina] == 'On' or devicechanged[phone.siewert] == 'On' or devicechanged[phone.natalya] == 'On') 
		and otherdevices[phone.switch] == 'Off'
	then	
		commandArray[phone.switch]='On AFTER 1'	
	end
	
	if (devicechanged[phone.jerina] == 'Off' or devicechanged[phone.siewert] == 'Off' or devicechanged[phone.natalya] == 'Off')	
		and (otherdevices[phone.jerina] == 'Off' and otherdevices[phone.siewert] == 'Off' and otherdevices[phone.natalya] == 'Off')		
		and otherdevices[phone.switch] == 'On'		
	then	
		commandArray[phone.switch]='Off AFTER 1'	
	end