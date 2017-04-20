--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ worker.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 20-4-2017
	@ All handlers which should/could trigger a event
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

function IsWorker()
--
-- **********************************************************
-- SomeOneHome Triggers
-- **********************************************************
--

	if devicechanged[trigger.someonehome]
		or otherdevices[trigger.visitors]
		or devicechanged[trigger.someonehome_standby] 
		or devicechanged[trigger.nobody_home]	
	then
		dofile(lua.events.."someone_home.lua")	
		dofile(lua.events.."lights_livingroom.lua")
		dofile(lua.events.."lights_livingroom_away.lua")
		dofile(lua.events.."lights_garden.lua")	
		dofile(lua.events.."activity_security_alarm.lua")		
	end
	
--
-- **********************************************************
-- Portable Devices
-- **********************************************************
--

	if devicechanged[trigger.phone_1]
		or devicechanged[trigger.phone_2]
		or devicechanged[trigger.phone_3]
		or devicechanged[trigger.phone_4]		
		or devicechanged[trigger.phone_switch]		
	then
		dofile(lua.events.."switch_phones.lua")
		dofile(lua.events.."someone_leaving.lua")
		dofile(lua.events.."activity_security_alarm.lua")
		dofile(lua.events.."activity_visitors.lua")		
	end
	
--
-- **********************************************************
-- Laptop Devices
-- **********************************************************
--
	
	if devicechanged[trigger.laptop_1]
		or devicechanged[trigger.laptop_2]
		or devicechanged[trigger.laptop_3]
		or devicechanged[trigger.laptop_switch]		
	then
		dofile(lua.events.."switch_laptops.lua")
		dofile(lua.events.."lights_dinnertable.lua")	
		dofile(lua.events.."activity_security_alarm.lua")		
	end
	
--
-- **********************************************************
-- Media Devices
-- **********************************************************
--

	if devicechanged[trigger.television]
		or devicechanged[trigger.mediabox]
		or devicechanged[trigger.media_switch]		
	then	
		dofile(lua.events.."lights_livingroom.lua")	
		dofile(lua.events.."switch_media.lua")		
	end

--
-- **********************************************************
-- Door/Window and motion Sensors
-- **********************************************************
--

	if devicechanged[trigger.frontdoor]
		or devicechanged[trigger.backdoor]
		or devicechanged[trigger.livingroom_door]
		or devicechanged[trigger.sliding_door]
		or devicechanged[trigger.scullery_door]
		or devicechanged[trigger.pantry_door]		
		or devicechanged[trigger.motion_upstairs]
		or devicechanged[trigger.motion_downstairs]
		or devicechanged[trigger.nest_away]
		or devicechanged[trigger.motion_dinnertable]	
		or devicechanged[trigger.motion_dinnertable2]	
		or devicechanged[trigger.motion_garden]		
	then	
		dofile(lua.events.."someone_home.lua")
		dofile(lua.events.."someone_arriving.lua")
		dofile(lua.events.."someone_leaving.lua")
		dofile(lua.events.."lights_dinnertable.lua")		
		dofile(lua.events.."activity_shower.lua")
		dofile(lua.events.."activity_stairs.lua")		
		--dofile(lua.events.."activity_hallway.lua")
		dofile(lua.events.."activity_pantry.lua")
		dofile(lua.events.."activity_scullery.lua")	
		dofile(lua.events.."activity_security_alarm.lua")	
	end	

--
-- **********************************************************
-- IsDark Triggers
-- **********************************************************
--
	
	if devicechanged[trigger.isdark_garden_lights_trigger]
		or devicechanged[trigger.isdark_living_room_trigger_1]
		or devicechanged[trigger.isdark_living_room_trigger_2]
		or devicechanged[trigger.isdark_dinner_table]
		or devicechanged[trigger.isdark_sunset]		
	then
		dofile(lua.events.."lights_livingroom.lua")	
		dofile(lua.events.."lights_livingroom_away.lua")		
		dofile(lua.events.."lights_dinnertable.lua")	
		dofile(lua.events.."lights_garden.lua")		
	end	
	
--
-- **********************************************************
-- Light Switches
-- **********************************************************
--
	if devicechanged[trigger.livingroom_light_switch]
	then
		dofile(lua.events.."lights_livingroom.lua")	
	end

	if devicechanged[trigger.dinnertable_light_switch]
	then
		dofile(lua.events.."lights_dinnertable.lua")		
	end
--
-- **********************************************************
-- Toilet Activity
-- **********************************************************
--	
	
	if devicechanged[trigger.motion_toilet] or devicechanged[trigger.toilet_light]		
	then
		dofile(lua.events.."activity_toilet.lua")	
		--dofile(lua.events.."activity_hallway.lua")		
	end
	
--
-- **********************************************************
-- Doorbell Activity
-- **********************************************************
--	
	
	if devicechanged[trigger.doorbell_button] or devicechanged[trigger.doorbell_standby]
	then
		dofile(lua.events.."activity_doorbell.lua")		
	end

--
-- **********************************************************
-- Shower Activity
-- **********************************************************
--	
	
	if devicechanged[trigger.shower_light] or devicechanged[trigger.shower_standby]
	then
		dofile(lua.events.."activity_shower.lua")
		dofile(lua.events.."lights_livingroom.lua")		
		dofile(lua.events.."lights_dinnertable.lua")		
	end

--
-- **********************************************************
-- Someone Leaving Activity
-- **********************************************************
--		

	if devicechanged[trigger.leaving_standby]		
	then
		dofile(lua.events.."someone_leaving.lua")		
	end	
	
--
-- **********************************************************
-- Someone Arriving Activity
-- **********************************************************
--		
	
	if devicechanged[trigger.arriving_standby] or devicechanged[trigger.arriving_garden_standby] or devicechanged[trigger.car_1]
	then
		dofile(lua.events.."someone_arriving.lua")		
	end

--
-- **********************************************************
-- Power Outage event
-- **********************************************************
--		
	
	if devicechanged[trigger.pico_power]
	then
		dofile(lua.events.."someone_home.lua")
		dofile(lua.events.."lights_livingroom_away.lua")
		dofile(lua.events.."lights_garden.lua")		
	end		
	
--
-- **********************************************************
-- Hallway Activity
-- **********************************************************
--		
--[[
	if devicechanged[trigger.walktrue_standby]	
	then
		dofile(lua.events.."activity_hallway.lua")		
	end	
--]]

--
-- **********************************************************
-- Firealarm Activity
-- **********************************************************
--

	if devicechanged[trigger.sirene_topfloor]
		or devicechanged[trigger.sirene_scullery]
		or devicechanged[trigger.sirene_living]
		or devicechanged[trigger.sirene_pantry]
		or devicechanged[trigger.sirene_remote]
		or devicechanged[trigger.sirene_loop]	
	then
		dofile(lua.events.."activity_security_alarm.lua")
		dofile(lua.events.."activity_fire_alarm.lua")		
	end
end

