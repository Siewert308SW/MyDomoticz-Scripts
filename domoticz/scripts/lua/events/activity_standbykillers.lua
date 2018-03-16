--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_standbykiller.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-16-2018
	@ Script for switching Standbykillers ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Standbykillers ON
-- **********************************************************
--

	if devicechanged[someone.home] == 'Thuis' and otherdevices[plug.tvcorner] == 'Off' then
		commandArray["Group:" ..group.standy_killers_zwave.. ""]='On AFTER 5'		
		commandArray["Group:" ..group.standy_killers_433mhz.. ""]='On AFTER 10 REPEAT 3 INTERVAL 5'	
	end

--
-- **********************************************************
-- Standbykillers OFF
-- **********************************************************
--
	
	if (devicechanged[someone.home] == 'Weg' or devicechanged[someone.home] == 'Slapen') and otherdevices[plug.tvcorner] == 'On' then
		commandArray["Group:" ..group.standy_killers_zwave.. ""]='Off AFTER 5'		
		commandArray["Group:" ..group.standy_killers_433mhz.. ""]='Off AFTER 10 REPEAT 3 INTERVAL 5'
		commandArray["Scene:" ..scene.nobodyhome.. ""]='On AFTER 20 REPEAT 3 INTERVAL 20'			
	end