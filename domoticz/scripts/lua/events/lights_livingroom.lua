--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ lights_livingroom.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 9-4-2017
	@ Script to switch various livingroom light scenes and Standby Killer events ON/OFF
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- IsDark Switches															-- Light Switches
	local isdark_living_room_trigger1	= 'IsDonker_Woonkamer_1'				local livingroom_vase_light			= 'Woonkamer Vaas Lamp'
	local isdark_living_room_trigger2	= 'IsDonker_Woonkamer_2'				local livingroom_wall_lights		= 'Woonkamer Wandlampen'
	local isdark_standby				= 'IsDonker - Standby'					local twilight						= 'Woonkamer Schemerlamp'
	local isdark_sunset					= 'Sunrise/Sunset'						local twilight2						= 'Woonkamer Schemerlamp (koper)'
																				local livingroom_standing_light		= 'Woonkamer Sta Lamp'
																				local livingroom_coffee_table_light	= 'Woonkamer Salon Tafel Lamp'

-- Scenes																	-- Standby Killers
	local stage_1						= 'Woonkamer_Stage_1'					local tv_corner_killer 				= 'Standby Killer (T.V Hoek)'
	local stage_2						= 'Woonkamer_Stage_2'					local boiler						= 'Standby Killer (Water Koker)'
	local stage_3						= 'Woonkamer_Stage_3'
	local stage_1_killer				= 'Woonkamer_Stage_1_killers'		-- Media Devices
	local stage_2_killer				= 'Woonkamer_Stage_2_killers'			local television 					= 'Televisie'
	local stage_3_killer				= 'Woonkamer_Stage_3_killers'			local mediabox 						= 'MediaBox'	
	local stage_4						= 'Romantic'							local laptop_switch 				= 'Laptops'
	local stage_5_tv					= 'Woonkamer_TV_Scene'					local media_switch 					= 'Media'
	local killer_scene_on				= 'Standby Killers ON'	
	local killer_scene_off_mediaON		= 'Standby Killers OFF - Media ON'	
	local killer_scene_off_mediaOFF		= 'Standby Killers OFF - Media OFF'	
	
-- Various Switches
	local someonehome					= 'Iemand Thuis'
	local someonehome_standby			= 'Iemand Thuis - Standby'	
	local nobody_home					= 'Niemand Thuis'
	local visitors						= 'Visite'	
	local iskerst						= 'Feestdagen'
	local livingroom_light_switch		= 'Woonkamer Verlichting Knop'
	local shower_standby				= 'Douche - Standby'
	local pico_power    				= 'PIco RPi Powered'
	local hallway_light					= 'Gang Wandlamp'
	local rpi_voltage					= 'RPi Voltage'
	local security_activation_type		= 'alarm_ActivationType'
	
deviceChangedON 		= (devicechanged[someonehome] == 'On' or devicechanged[shower_standby] == 'Off')
deviceChangedOFF 		= (devicechanged[someonehome] == 'Off' or devicechanged[shower_standby] == 'On')
lightswitch_condition	= (otherdevices[television] == 'Off' and otherdevices[visitors] == 'Off' and otherdevices[pico_power]   == 'On' and otherdevices[someonehome] == 'On')

--
-- **********************************************************
-- Livingroom lights - Standby Killer ON/OFF when SomeOneHome and IsDark and IsNotXmas
-- **********************************************************
--

	if deviceChangedON
		and otherdevices[isdark_living_room_trigger1]   == 'On'
		and otherdevices[isdark_living_room_trigger2]   == 'Off'	
		and otherdevices[livingroom_vase_light]  == 'Off'
		and otherdevices[isdark_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then
		if otherdevices[boiler] == 'Off' then
		commandArray["Group:" ..stage_1_killer.. ""]='On AFTER 2 REPEAT 2 INTERVAL 20'		
		else
		commandArray["Group:" ..stage_1.. ""]='On'
		end
		event_body = '.............................................................'
		
------------

	elseif deviceChangedON
		and otherdevices[isdark_living_room_trigger1]   == 'On'
		and otherdevices[isdark_living_room_trigger2]   == 'On'	
		and otherdevices[livingroom_vase_light]  == 'Off'				
		and otherdevices[isdark_sunset]   == 'On' 
		and otherdevices[isdark_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'	
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then		
		if otherdevices[boiler] == 'Off' then
		commandArray["Group:" ..stage_2_killer.. ""]='On AFTER 2 REPEAT 2 INTERVAL 20'		
		else
		commandArray["Group:" ..stage_2.. ""]='On'
		end
		if otherdevices[twilight2] == 'On' then	
		commandArray[""..twilight2..""]='Off AFTER 20'		
		end			
		event_body = '.............................................................'	

------------

	elseif deviceChangedON
		and otherdevices[isdark_living_room_trigger1]   == 'On'
		and otherdevices[isdark_living_room_trigger2]   == 'On'	
		and otherdevices[livingroom_standing_light]  == 'Off'				
		and otherdevices[isdark_sunset]   == 'On' 
		and otherdevices[isdark_standby]   == 'On'
		and otherdevices[iskerst] == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then	
		if otherdevices[boiler] == 'Off' then
		commandArray["Group:" ..stage_3_killer.. ""]='On AFTER 2 REPEAT 2 INTERVAL 20'	
		else
		commandArray["Group:" ..stage_3.. ""]='On'
		end
		event_body = '.............................................................'

	else 
	if deviceChangedON 	and uservariables[security_activation_type] == 0 then
		commandArray["Group:" ..killer_scene_off_mediaOFF.. ""]='On AFTER 2 REPEAT 2 INTERVAL 20'
	end	
	end	
--
-- **********************************************************
-- Livingroom lights ON/OFF when IsDark and SomeOneHome and IsNotXmas
-- **********************************************************
--

	if devicechanged[isdark_living_room_trigger1]   == 'On'
		and otherdevices[isdark_living_room_trigger2]   == 'Off'		
		and otherdevices[someonehome]   == 'On'
		and otherdevices[pico_power] == 'On'		
		and otherdevices[shower_standby]   == 'Off'		
		and otherdevices[livingroom_vase_light]  == 'Off'
		and otherdevices[isdark_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'
		and uservariables[security_activation_type] == 0		
	then
		commandArray["Group:" ..stage_1.. ""]='On'
		event_body = '.............................................................'	
	end
	
------------

	if devicechanged[isdark_living_room_trigger2]   == 'On'
		and otherdevices[isdark_living_room_trigger1]   == 'On'
		and otherdevices[someonehome]   == 'On'
		and otherdevices[pico_power] == 'On'		
		and otherdevices[shower_standby]   == 'Off'		
		and otherdevices[livingroom_wall_lights]  == 'Off'
		and otherdevices[visitors]   == 'Off'		
		and otherdevices[isdark_sunset]   == 'On' 
		and otherdevices[isdark_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'	
		and otherdevices[television] == 'Off'
		and uservariables[security_activation_type] == 0 		
	then	
		commandArray["Group:" ..stage_2.. ""]='On'
		event_body = '.............................................................'	
	end
	
	if devicechanged[isdark_living_room_trigger2]   == 'On'
		and otherdevices[isdark_living_room_trigger1]   == 'On'
		and otherdevices[someonehome]   == 'On'
		and otherdevices[pico_power] == 'On'		
		and otherdevices[shower_standby]   == 'Off'		
		and otherdevices[livingroom_wall_lights]  == 'Off'
		and otherdevices[visitors]   == 'Off'		
		and otherdevices[isdark_sunset]   == 'On' 
		and otherdevices[isdark_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'		
		and otherdevices[television] == 'On'
		and uservariables[security_activation_type] == 0 		
	then	
		commandArray["Group:" ..stage_5_tv.. ""]='On'
		if otherdevices[twilight2] == 'Off' then	
		commandArray[""..twilight2..""]='On AFTER 7'		
		end			
		event_body = '.............................................................'
	end	
	
------------

	if devicechanged[isdark_sunset]   == 'On'
		and otherdevices[isdark_living_room_trigger1]   == 'On'
		and otherdevices[isdark_living_room_trigger2]   == 'On' 		
		and otherdevices[someonehome]   == 'On'	
		and otherdevices[pico_power] == 'On'		
		and otherdevices[shower_standby]   == 'Off'		
		and otherdevices[livingroom_wall_lights]  == 'Off'
		and otherdevices[isdark_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'
		and uservariables[security_activation_type] == 0		
	then
		commandArray["Group:" ..stage_2.. ""]='On'
		event_body = '.............................................................'	
	end
	
--
-- **********************************************************
-- Livingroom lights OFF when NOT IsDark and IsNotXmas
-- **********************************************************
--

	if devicechanged[isdark_living_room_trigger1] == 'Off'
		and otherdevices[iskerst] == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then	
		commandArray["Group:" ..stage_2.. ""]='Off'	
		if otherdevices[twilight2] == 'On' then	
		commandArray[""..twilight2..""]='Off AFTER 7'		
		end			
		event_body = '.............................................................'		
	end

--
-- **********************************************************
-- Livingroom lights ON/OFF when SomeOneHome is ON/OFF and IsNotXmas (also activated when toggling light switch)
-- **********************************************************
--

    if deviceChangedOFF 
		and otherdevices[livingroom_standing_light]  ~= 'Off'	
		and otherdevices[iskerst] == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then
	 		commandArray["Group:" ..stage_2.. ""]='Off'
		if otherdevices[twilight2] == 'On' then	
		commandArray[""..twilight2..""]='Off AFTER 7'		
		end				
		event_body = '.............................................................'			
	end


    if devicechanged[someonehome_standby] == 'Off' 
		and otherdevices[someonehome] == 'Off'
		and otherdevices[nobody_home] == 'Off'		
		and otherdevices[iskerst] == 'Off' 
		and otherdevices[mediabox]   == 'On' 
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then
	 		commandArray["Group:" ..killer_scene_off_mediaON.. ""]='Off AFTER 5 REPEAT 2 INTERVAL 20'			
	end
	 
    if devicechanged[someonehome_standby] == 'Off' 
		and otherdevices[someonehome] == 'Off'
		and otherdevices[nobody_home] == 'Off'
		and otherdevices[iskerst] == 'Off' 
		and otherdevices[mediabox]   == 'Off'
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then
	 		commandArray["Group:" ..killer_scene_off_mediaOFF.. ""]='Off AFTER 5 REPEAT 2 INTERVAL 20'			
	end

    if devicechanged[media_switch] == 'Off' 
		and otherdevices[someonehome] == 'Off'
		and otherdevices[iskerst] == 'Off' 
		and otherdevices[someonehome_standby]   == 'Off' 
	    and otherdevices[pico_power]   == 'On'
		and uservariables[security_activation_type] == 0		
	then
	 		commandArray["Group:" ..killer_scene_off_mediaOFF.. ""]='Off AFTER 5 REPEAT 2 INTERVAL 20'			
	end
	
--
-- **********************************************************
-- Livingroom TV Light Scene
-- **********************************************************
--	

	if devicechanged[television] == 'On'
		and otherdevices[pico_power] == 'On'		
		and otherdevices[shower_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'
		and otherdevices[livingroom_wall_lights] ~= 'Off' 
		and otherdevices[isdark_living_room_trigger2] == 'On'
		and otherdevices[someonehome]   == 'On'		
		and otherdevices[livingroom_vase_light]  == 'On'
		and otherdevices[visitors]   == 'Off'
		and uservariables[security_activation_type] == 0		
	then
		event_body = '.............................................................'	
		commandArray["Group:" ..stage_5_tv.. ""]='On'
		if otherdevices[twilight2] == 'Off' then	
		commandArray[""..twilight2..""]='On AFTER 7'		
		end		
	end
	
	if devicechanged[television] == 'Off'
		and otherdevices[pico_power] == 'On'		
		and otherdevices[shower_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'
		and otherdevices[livingroom_wall_lights] == 'Off' 
		and otherdevices[isdark_living_room_trigger2] == 'On'
		and otherdevices[someonehome]   == 'On'		
		and otherdevices[livingroom_vase_light]  == 'On'
		and otherdevices[visitors]   == 'Off'
		and timebetween("15:00:00","22:30:00")	
		and uservariables[security_activation_type] == 0		
	then
		event_body = '.............................................................'
		commandArray["Group:" ..stage_2.. ""]='On'
		if otherdevices[twilight2] == 'On' then	
		commandArray[""..twilight2..""]='Off AFTER 7'		
		end		
	end	
	
	if devicechanged[visitors] == 'On'
		and otherdevices[pico_power] == 'On'		
		and otherdevices[shower_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'
		and otherdevices[livingroom_wall_lights] == 'Off' 
		and otherdevices[isdark_living_room_trigger2] == 'On'
		and otherdevices[someonehome]   == 'On'	
		and otherdevices[livingroom_vase_light]  == 'On'
		and timebetween("15:00:00","23:30:00")	
		and uservariables[security_activation_type] == 0		
	then
		event_body = '.............................................................'
		commandArray["Group:" ..stage_2.. ""]='On'
		if otherdevices[twilight2] == 'On' then	
		commandArray[""..twilight2..""]='Off AFTER 7'		
		end		
	end			

	if devicechanged[visitors] == 'Off'
		and otherdevices[pico_power] == 'On'		
		and otherdevices[shower_standby]   == 'Off'
		and otherdevices[iskerst] == 'Off'
		and otherdevices[livingroom_wall_lights] ~= 'Off' 
		and otherdevices[isdark_living_room_trigger2] == 'On'
		and otherdevices[someonehome]   == 'On'	
		and otherdevices[television]   == 'On'		
		and otherdevices[livingroom_vase_light]  == 'On'
		and timebetween("15:00:00","23:30:00")	
		and uservariables[security_activation_type] == 0		
	then
		event_body = '.............................................................'	
		commandArray["Group:" ..stage_5_tv.. ""]='On'	
		if otherdevices[twilight2] == 'Off' then	
		commandArray[""..twilight2..""]='On AFTER 7'		
		end		
	end
	
--
-- **********************************************************
-- Livingroom lights switch
-- **********************************************************
--

	if devicechanged[livingroom_light_switch] == 'On' and otherdevices[someonehome] == 'On' and otherdevices[pico_power]   == 'On'	
	then
		commandArray["Group:" ..stage_2.. ""]='On'
	elseif devicechanged[livingroom_light_switch] == 'On' and otherdevices[someonehome] == 'Off' and otherdevices[pico_power]   == 'On'
	then
		commandArray[someonehome]='On'	
	end
	
	if devicechanged[livingroom_light_switch] == 'Off' and lightswitch_condition	
	then
		commandArray[someonehome]='Off AFTER 60'
		commandArray["Group:" ..stage_2.. ""]='Off'
		if otherdevices[twilight2] == 'On' then	
		commandArray[""..twilight2..""]='Off AFTER 5'		
		end		
	elseif devicechanged[livingroom_light_switch] == 'Off' and not lightswitch_condition
	then
		commandArray["Group:" ..stage_2.. ""]='Off'
		if otherdevices[twilight2] == 'On' then	
		commandArray[""..twilight2..""]='Off AFTER 5'		
		end			
	end	
