--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ switch_visitors.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-5-2018
	@ Script for switching visitor switch to execute special events
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]	
	
--
-- **********************************************************
-- Phones ON/OFF
-- **********************************************************
--
	if (devicechanged[visitor.grandma_gsm] == 'On' or devicechanged[visitor.grandma_tablet] == 'On') 
		and otherdevices[visitor.switch] == 'Off'
		and otherdevices[someone.home] == 'Thuis'		
	then	
		commandArray[visitor.switch]='On AFTER 1'	
	end
	
	if (devicechanged[visitor.grandma_gsm] == 'Off' or devicechanged[visitor.grandma_tablet] == 'Off')	
		and (otherdevices[visitor.grandma_gsm] == 'Off' and otherdevices[visitor.grandma_tablet] == 'Off')	
		and otherdevices[visitor.switch] == 'On'		
	then	
		commandArray[visitor.switch]='Off AFTER 1'	
	end