--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_security_alarm.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 6-4-2017
	@ Security script
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Script not finished yet

-- SomeOneHome
	local someonehome					= 'Iemand Thuis'
	local nobody_home					= 'Niemand Thuis'
	local phone_switch					= 'Telefoons'
	local laptop_switch					= 'Laptops'

-- Devices
	local phone_1 						= 'Jerina GSM'
	local phone_2 						= 'Siewert GSM'
	local phone_3 						= 'Natalya GSM'	
	
-- Door/Window Sensors	
	local frontdoor						= 'Voor Deur'			
	local backdoor			 			= 'Achter Deur'
	local livingroom_door				= 'Kamer Deur'
	local sliding_door	 				= 'Schuifpui'
	local scullery_door 				= 'Bijkeuken Deur'
	local motion_living					= 'Woonkamer Motion'
	local motion_upstairs 				= 'Trap Motion Boven'
	local motion_downstairs 			= 'Trap Motion Beneden'
	local motion_toilet					= 'W.C Motion'
	local motion_dinner					= 'Motion Eettafel'
	
-- Sirens
	local sirene_topfloor				= 'Rookmelder - Overloop'
	local sirene_scullery				= 'Rookmelder - Schuur'
	local sirene_living					= 'Rookmelder - Woonkamer'
	local sirene_pantry					= 'Rookmelder - Kelder'
	local sirene_scene					= 'Brandalarm - Melders'
	
-- Security Various Switches
	local security_remote				= 'Alarm AB Knop'
	local sirene_loop					= 'Rookmelder - Loop'

-- Security Variables
	local security_activation_type		= 'alarm_ActivationType'
	local security_activation_phones	= 'alarm_ActivationPhones'
	
-- Security Timeouts	
	local timeout	 					= 30
	local timeout_sirene	 			= 40	
	local timeout_motion_disarm	 		= 120	
	
-- Determine how many phones are at home	
    if otherdevices[phone_1] == 'On' then p1=1 else p1=0 end
	if otherdevices[phone_2] == 'On' then p2=1 else p2=0 end
	if otherdevices[phone_3] == 'On' then p3=1 else p3=0 end
	   phones_home=(p1 + p2 + p3)

	phones_var = tonumber(uservariables[security_activation_phones])	
	phones_var = phones_home
--
-- **********************************************************
--  Security Alarm - Arm
-- **********************************************************
--

if (globalvariables["Security"] ~= 'Armed Home' and otherdevices[phone_switch] == 'On'
	and (devicechanged[nobody_home] == 'On')) 
then
    commandArray['Domoticz Security Panel'] = 'Arm Home'
	commandArray['Variable:' .. security_activation_phones] = tostring(phones_var)
	event_body = '.............................................................'	

elseif (globalvariables["Security"] ~= 'Armed Away' and otherdevices[phone_switch] == 'Off'
	and (devicechanged[nobody_home] == 'On')) 
then
    commandArray['Domoticz Security Panel'] = 'Arm Away'
	event_body = '.............................................................'	

elseif (globalvariables["Security"] ~= 'Armed Away'
	and (devicechanged[security_remote] == 'On')) 
then
	commandArray['Variable:' .. security_activation_phones] = tostring(phones_var)
    commandArray['Domoticz Security Panel'] = 'Arm Away'
	event_body = '.............................................................'	
end

--
-- **********************************************************
--  Security Alarm - Disarm
-- **********************************************************
--

if (globalvariables["Security"] == 'Armed Away' and timedifference(otherdevices_lastupdate[frontdoor]) < timeout_motion_disarm
	and (devicechanged[phone_switch] == 'On' or devicechanged[phone_1] == 'On' or devicechanged[phone_2] == 'On' or devicechanged[phone_3] == 'On' or devicechanged[laptop_switch] == 'On')) 
then
    commandArray['Domoticz Security Panel'] = 'Disarm'
	if uservariables[security_activation_type] ~= 0 then commandArray["Variable:" .. security_activation_type .. ""]= '0' end
    if otherdevices[sirene_loop] ~= 'Off' then commandArray[sirene_loop] = 'Off AFTER 60' end	
	event_body = '.............................................................'

-- **********************************************************

elseif (globalvariables["Security"] == 'Armed Away' and timedifference(otherdevices_lastupdate[backdoor]) < timeout_motion_disarm
	and (devicechanged[phone_switch] == 'On' or devicechanged[phone_1] == 'On' or devicechanged[phone_2] == 'On' or devicechanged[phone_3] == 'On' or devicechanged[laptop_switch] == 'On')) 
then
    commandArray['Domoticz Security Panel'] = 'Disarm'
	if uservariables[security_activation_type] ~= 0 then commandArray["Variable:" .. security_activation_type .. ""]= '0' end
    if otherdevices[sirene_loop] ~= 'Off' then commandArray[sirene_loop] = 'Off AFTER 60' end	
	event_body = '.............................................................'

-- **********************************************************

elseif (globalvariables["Security"] == 'Armed Home' and timedifference(otherdevices_lastupdate[frontdoor]) < timeout_motion_disarm	
	and (devicechanged[phone_switch] == 'On' or devicechanged[phone_1] == 'On' or devicechanged[phone_2] == 'On' or devicechanged[phone_3] == 'On' or devicechanged[laptop_switch] == 'On')) 
then
    commandArray['Domoticz Security Panel'] = 'Disarm'
	if uservariables[security_activation_type] ~= 0 then commandArray["Variable:" .. security_activation_type .. ""]= '0' end
    if otherdevices[sirene_loop] ~= 'Off' then commandArray[sirene_loop] = 'Off AFTER 60' end	
	event_body = '.............................................................'	

-- **********************************************************

elseif (globalvariables["Security"] == 'Armed Home' and timedifference(otherdevices_lastupdate[backdoor]) < timeout_motion_disarm	
	and (devicechanged[phone_switch] == 'On' or devicechanged[phone_1] == 'On' or devicechanged[phone_2] == 'On' or devicechanged[phone_3] == 'On' or devicechanged[laptop_switch] == 'On')) 
then
    commandArray['Domoticz Security Panel'] = 'Disarm'
	if uservariables[security_activation_type] ~= 0 then commandArray["Variable:" .. security_activation_type .. ""]= '0' end
    if otherdevices[sirene_loop] ~= 'Off' then commandArray[sirene_loop] = 'Off AFTER 60' end	
	event_body = '.............................................................'

-- **********************************************************
	
elseif (globalvariables["Security"] == 'Armed Home' and timedifference(otherdevices_lastupdate[motion_downstairs]) > timeout
	and (devicechanged[motion_upstairs])) 
then
    commandArray['Domoticz Security Panel'] = 'Disarm'
	if uservariables[security_activation_type] ~= 0 then commandArray["Variable:" .. security_activation_type .. ""]= '0' end
    if otherdevices[sirene_loop] ~= 'Off' then commandArray[sirene_loop] = 'Off AFTER 60' end	
	event_body = '.............................................................'

-- **********************************************************

elseif (globalvariables["Security"] ~= 'Disarmed'
	and (devicechanged[security_remote] == 'Off')) 
then
    commandArray['Domoticz Security Panel'] = 'Disarm'
	if uservariables[security_activation_type] ~= 0 then commandArray["Variable:" .. security_activation_type .. ""]= '0' end
    if otherdevices[sirene_loop] ~= 'Off' then commandArray[sirene_loop] = 'Off AFTER 60' end	
	event_body = '.............................................................'	
end

--
-- **********************************************************
--  Security Alarm - Check alarm state and compare to presence in case some just took a piss ;-)
-- **********************************************************
--

if (globalvariables["Security"] == 'Disarmed' 
	and timedifference(otherdevices_lastupdate[frontdoor]) > timeout_motion_disarm			
	and timedifference(otherdevices_lastupdate[backdoor]) > timeout_motion_disarm
	and timedifference(otherdevices_lastupdate[livingroom_door]) > timeout_motion_disarm
	and timedifference(otherdevices_lastupdate[sliding_door]) > timeout_motion_disarm
	and timedifference(otherdevices_lastupdate[scullery_door]) > timeout_motion_disarm
	and timedifference(otherdevices_lastupdate[motion_living]) > timeout_motion_disarm
	and timedifference(otherdevices_lastupdate[motion_downstairs]) < timeout_motion_disarm
	and timedifference(otherdevices_lastupdate[motion_toilet]) < timeout_motion_disarm
	and timedifference(otherdevices_lastupdate[motion_dinner]) > timeout_motion_disarm	
	and otherdevices[someonehome]   == 'Off'
	and otherdevices[nobody_home]   == 'On'	
	and (devicechanged[motion_upstairs] == 'On')) 
then
    commandArray['Domoticz Security Panel'] = 'Arm Home'
	if uservariables[security_activation_type] ~= 0 then commandArray["Variable:" .. security_activation_type .. ""]= '0' end
	event_body0 = 'Looks like someone only went to the toilet and back to bed...'	
	event_body = '.............................................................'	
end
--[[
--
-- **********************************************************
--  Security Alarm - Security breached
-- **********************************************************
--

if (globalvariables["Security"] == 'Armed Home'
	and otherdevices[nobody_home]   == 'On'
	and uservariables[security_activation_type] == 0	
	and (devicechanged[frontdoor] == 'Open'	
	or devicechanged[backdoor] == 'Open'
	or devicechanged[sliding_door] == 'Open'
	or devicechanged[scullery_door] == 'Open'))
then
	commandArray["Variable:" .. security_activation_type .. ""]= '1'
    commandArray[sirene_loop] = 'On AFTER 60'	
	event_body0 = 'Security breached!!! alarm standby...'	
	event_body = '.............................................................'
	commandArray['SendNotification']='Security breached!!!#It seems that a thief is sniffing around...'	
end

--
-- **********************************************************
--  Security Alarm - Security breached sound sirene and loop sequence
-- **********************************************************
--	

if devicechanged[sirene_loop] == 'On' and uservariables[security_activation_type] == 1 and timedifference(otherdevices_lastupdate[sirene_topfloor]) > timeout_sirene then
	event_body0 = 'Security breached!!!'
	event_body1 = 'Security breached!!!'
	event_body2 = 'Security breached!!!'	
	event_body = '.............................................................'
    commandArray[sirene_loop] = 'On AFTER 45'
	--commandArray["Group:" ..sirene_scene.. ""]='On'	
end	
--]]

-- Script not finished yet