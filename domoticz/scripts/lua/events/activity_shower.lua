--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_shower.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 5-4-2017
	@ Script to switch OFF livingroom lights when one person at home and is taking a shower, to let people think i'm not at home ;-)
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Lights																-- IsDark Switches
	local shower_light					= 'Douche Lamp'						local isdark_dinner_table 			= 'IsDonker_Eettafel'
																			local isdark_sunset					= 'Sunrise/Sunset'

-- Devices																-- Variables
	local phone_1 						= 'Jerina GSM'						local shower_standby				= 'Douche - Standby'
	local phone_2 						= 'Siewert GSM'						local iskerst						= 'Var_IsKerst'
	local phone_3 						= 'Natalya GSM'						local livingroom_lights_timeout		= 30
	local television 					= 'Televisie'						local pico_power					= 'PIco RPi Powered'
	local laptop_1 						= 'Siewert Laptop'					local security_activation_type		= 'alarm_ActivationType'
	local laptop_2 						= 'Jerina Laptop'
	local laptop_3						= 'Natalya Laptop'
	
-- Door/Window Sensors													-- Various Switches
	local frontdoor						= 'Voor Deur'						local someonehome					= 'Iemand Thuis'
	local backdoor			 			= 'Achter Deur'
	local livingroom_door				= 'Kamer Deur'
	local sliding_door	 				= 'Schuifpui'
	local scullery_door 				= 'Bijkeuken Deur'

-- Determine how many phones are at home	
    if otherdevices[phone_1] == 'On' then p1=1 else p1=0 end
	if otherdevices[phone_2] == 'On' then p2=1 else p2=0 end
	if otherdevices[phone_3] == 'On' then p3=1 else p3=0 end
	   phones_home=p1 + p2 + p3

-- Determine how many laptops are online	
    if otherdevices[laptop_1] == 'On' then l1=1 else l1=0 end
	if otherdevices[laptop_2] == 'On' then l2=1 else l2=0 end
	if otherdevices[laptop_3] == 'On' then l3=1 else l3=0 end
	   laptops_online=l1 + l2 + l3	 

	doors = (devicechanged[frontdoor] or devicechanged[backdoor] or devicechanged[livingroom_door] or devicechanged[sliding_door] or devicechanged[scullery_door]) 
	   
--
-- **********************************************************
-- Livingroom Lights ON/OFF when 1 person is at home and showering
-- **********************************************************
--

	if devicechanged[shower_light]   == 'On'
		and otherdevices[shower_standby]   == 'Off'
		and otherdevices[someonehome]   == 'On'
		and otherdevices[television]   == 'Off'	
		and otherdevices[frontdoor]   == 'Closed'
		and otherdevices[backdoor]   == 'Closed'
		and otherdevices[scullery_door]   == 'Closed'
		and otherdevices[livingroom_door]   == 'Closed'
		and otherdevices[pico_power]   == 'On'	
		and phones_home == 1 and laptops_online == 1
		and uservariables[security_activation_type] == 0	
	then
		commandArray[shower_standby]='On AFTER 15'
		event_body = '.............................................................'
		event_body0 = 'Seems to be just '..phones_home..' person at home and is probably taking a shower'
	end

-- Someone entering the home and reactivating the light scene
	if doors and otherdevices[shower_standby]   == 'On'	
	then
		commandArray[shower_standby]='Off'
		event_body = '.............................................................'
		event_body0 = 'Somebody just arrived...'			
	end
