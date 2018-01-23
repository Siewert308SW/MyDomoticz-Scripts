--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ activity_fire_alarm.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 10-4-2017
	@ Smoke detector script
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- SomeOneHome
	local someonehome					= 'Iemand Thuis'
	local nobody_home					= 'Niemand Thuis'
	local phone_switch					= 'Telefoons'
	local laptop_switch					= 'Laptops'
	
-- Sirens
	local sirene_topfloor				= 'Rookmelder - Overloop'
	local sirene_scullery				= 'Rookmelder - Schuur'
	local sirene_living					= 'Rookmelder - Woonkamer'
	local sirene_pantry					= 'Rookmelder - Kelder'
	local sirene_scene					= 'Brandalarm - Melders'
	local sirene_light_scene			= 'Brandalarm - Verlichting'
	
-- Security Various Switches
	local security_remote				= 'Alarm AB Knop'
	local sirene_loop					= 'Rookmelder - Loop'
	local isdark_living_room_trigger1	= 'IsDonker_Woonkamer_1'
	local stage_2_killer				= 'Woonkamer_Stage_2_killers'
	local pico_power    				= 'PIco RPi Powered'
	
-- Security Variables
	local security_activation_type		= 'alarm_ActivationType'

-- Security Timeouts
	local timeout_sirene	 			= 40	

	sirene = (devicechanged[dummy1] == 'On' or devicechanged[sirene_topfloor] == 'Panic' or devicechanged[sirene_topfloor] == 'Panic' or devicechanged[sirene_scullery] == 'Panic' or devicechanged[sirene_living] == 'Panic' or devicechanged[sirene_pantry] == 'Panic')		

--
-- **********************************************************
--  Smoke Detected
-- **********************************************************
--

if sirene and otherdevices[sirene_loop] == 'Off' and uservariables[security_activation_type] == 0 then

	commandArray["Variable:" .. security_activation_type .. ""]= '2'
    commandArray[sirene_loop] = 'On AFTER 11'
	
	for deviceName, deviceValue in pairs(devicechanged) do
		for tablename, tabledevice in pairs (trigger) do
			alarm = ''..deviceName..''	
		end
	end

		if otherdevices[someonehome] == 'Off' then
			mail('Rookmelder thuis afgegaan', ''..alarm..' heeft rook gedetecteerd!!!', 'user1@gmail.com')	
			mail('Rookmelder thuis afgegaan', ''..alarm..' heeft rook gedetecteerd!!!', 'user2@gmail.com')
			mail('Rookmelder afgegaan bij Siewert & Jerina', ''..alarm..' heeft rook gedetecteerd bij Siewert & Jerina!!!', 'user3@gmail.com')
		else
			mail('Rookmelder thuis afgegaan', ''..alarm..' heeft rook gedetecteerd!!!', 'user1@gmail.com')		
		end
		
	if otherdevices[pico_power]   == 'On' then		
	commandArray["Group:" ..sirene_light_scene.. ""]='On'
	end	
	event_body0 = 'Evacuate NOW!!!!!'	
	event_body = '.............................................................'
end

--
-- **********************************************************
--  Fire Alarm - Smoke detected sound sirens and loop sequence
-- **********************************************************
--	

if devicechanged[sirene_loop] == 'On' and uservariables[security_activation_type] == 2 then
	event_body0 = 'Fire Alarm!!!'
	event_body1 = 'Fire Alarm!!!'
	event_body2 = 'Fire Alarm!!!'	
	event_body = '.............................................................'
    commandArray[sirene_loop] = 'On AFTER 45'
	commandArray["Group:" ..sirene_scene.. ""]='On'	
end	

--
-- **********************************************************
--  Fire Alarm - Switch OFF Fire Alarm
-- **********************************************************
--	

if devicechanged[security_remote] == 'Off' and otherdevices[sirene_loop] ~= 'Off' and uservariables[security_activation_type] == 2 then
	commandArray["Variable:" .. security_activation_type .. ""]= '0'
	commandArray[sirene_loop] = 'Off AFTER 60'	
	event_body = '.............................................................'

	if otherdevices[isdark_living_room_trigger1]   == 'On' then
		commandArray["Group:" ..sirene_light_scene.. ""]='Off'
		commandArray["Group:" ..stage_2_killer.. ""]='On AFTER 11'		
	else
		commandArray["Group:" ..sirene_light_scene.. ""]='Off'
	end
	
end