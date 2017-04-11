--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ timers.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 12-4-2017
	@ Script for switching ON/OFF various sensors and switches when no activity
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Various
	local security_activation_type		= 'alarm_ActivationType'
	local max_idle_current = 90

-- Various timers	
	  timeon     						= 59 

	  timeon_doors 						= 299

	  timeon_toilet_light  				= 179
	  
	  timeon_doorbell  					= 119
	  
	  timeon_leaving_standby  			= 299 
	  
	  timeon_arriving_standby  			= 119
	  
	  timeon_arriving_garden_standby	= 119   
	  
	  timeon_natalya_away_on			= 7199 
	  timeon_natalya_away_off			= 29

	  timeon_shower_light				= 4499 
	 
	  timeon_scullery_light				= 599

	  timeon_topfloor_light				= 599  
	  
	  timeon_dinnertable_light			= 1199   
	  
	  presence   						= (otherdevices['Laptops'] == 'On' or otherdevices['Media'] == 'On' or otherdevices['Visite'] == 'On')

--
-- **********************************************************
-- Doors
-- **********************************************************
--  

-- Back Door
		if otherdevices['Achter Deur'] == 'Open'
			and otherdevices['Iemand Thuis'] == 'Off'
			and timedifference(otherdevices_lastupdate['Achter Deur']) > timeon_doors
			and uservariables[security_activation_type] == 0		
		then	
		commandArray['Achter Deur']='Off'		
		end
		
-- Scullery Door		
		if otherdevices['Bijkeuken Deur'] == 'Open' 
			and timedifference(otherdevices_lastupdate['Bijkeuken Deur']) > timeon_doors 
			and uservariables[security_activation_type] == 0		
		then	
		commandArray['Bijkeuken Deur']='Off'
		end
		
-- pantry Door		
		if otherdevices['Kelder Deur'] == 'Open'
			and timedifference(otherdevices_lastupdate['Kelder Deur']) > timeon_doors 
			and uservariables[security_activation_type] == 0
		then	
		commandArray['Kelder Deur']='Off'
		end		
		
-- Front Door		
		if otherdevices['Voor Deur'] == 'Open' 
			and otherdevices['Iemand Thuis'] == 'Off' 
			and timedifference(otherdevices_lastupdate['Voor Deur']) > timeon_doors 
			and uservariables[security_activation_type] == 0			
		then	
		commandArray['Voor Deur']='Off'
		end

-- Livingroom Door		
		if otherdevices['Kamer Deur'] == 'Open'
			and otherdevices['Iemand Thuis'] == 'Off'
			and timedifference(otherdevices_lastupdate['Kamer Deur']) > timeon_doors
			and uservariables[security_activation_type] == 0		
		then	
		commandArray['Kamer Deur']='Off'
		end
		
--
-- **********************************************************
-- Scullery light
-- **********************************************************
--

		if otherdevices['Bijkeuken Lamp'] ~= 'Off' and otherdevices['PIco RPi Powered']   == 'On'
			and otherdevices['Achter Deur'] == 'Closed'
			and otherdevices['Bijkeuken Deur'] == 'Closed'	
			and timedifference(otherdevices_lastupdate['Bijkeuken Deur']) > timeon_scullery_light	
			and timedifference(otherdevices_lastupdate['Bijkeuken Lamp']) > timeon_scullery_light
			and timedifference(otherdevices_lastupdate['Achter Deur']) > timeon_scullery_light
			and uservariables[security_activation_type] == 0	
		then	
			commandArray['Bijkeuken Lamp']='Off REPEAT 2 INTERVAL 10'
			timer_body = 'Bijkeuken Lamp ON for more then '..timeon_scullery_light..' seconds...'			
		end			
		
--
-- **********************************************************
-- Shower light
-- **********************************************************
--

		if otherdevices['Douche Lamp'] == 'On' and otherdevices['PIco RPi Powered']   == 'On'
			and timedifference(otherdevices_lastupdate['Douche Lamp']) > timeon_shower_light
			and timedifference(otherdevices_lastupdate['Trap Motion Boven']) > timeon_shower_light
			and uservariables[security_activation_type] == 0	
		then	
			commandArray['Douche Lamp']='Off REPEAT 2 INTERVAL 10'
			timer_body = 'Douche Lamp ON for more then '..timeon_shower_light..' seconds...'			
		end
	
--
-- **********************************************************
-- Top floor light
-- **********************************************************
--

		if otherdevices['Gang Lamp Boven'] ~= 'Off' and otherdevices['PIco RPi Powered']   == 'On'
			and timedifference(otherdevices_lastupdate['Gang Lamp Boven - Standby']) > timeon_topfloor_light	
			and timedifference(otherdevices_lastupdate['Douche Lamp']) > timeon_topfloor_light
			and timedifference(otherdevices_lastupdate['Trap Motion Boven']) > timeon_topfloor_light
			and uservariables[security_activation_type] == 0	
		then	
			commandArray['Gang Lamp Boven']='Off REPEAT 2 INTERVAL 10'
			timer_body = 'Top floor light ON for more then '..timeon_topfloor_light..' seconds...'			
		end	
		
--
-- **********************************************************
-- Toilet light
-- **********************************************************
--
		if otherdevices['W.C Lamp'] == 'On' and otherdevices['PIco RPi Powered']   == 'On' 
			and timedifference(otherdevices_lastupdate['W.C Motion']) > timeon_toilet_light
			and uservariables[security_activation_type] == 0	
		then
			commandArray['W.C Lamp']='Off REPEAT 2 INTERVAL 1'
			timer_body = 'No motion detected for more then '..timeon_toilet_light..' seconds'
			timer_body0 = 'Assuming nobody is taking a shit anymore...'		
		end	
	
--
-- **********************************************************
-- Standby triggers
-- **********************************************************
--

-- Deurbel - Standby
		if otherdevices['Deurbel - Standby'] == 'On' 
			and otherdevices['Voor Deur'] == 'Closed'
			and otherdevices['Kamer Deur'] == 'Closed'	
			and timedifference(otherdevices_lastupdate['Deurbel - Standby']) > timeon_doorbell	
			and timedifference(otherdevices_lastupdate['Voor Deur']) > timeon_doorbell
			and timedifference(otherdevices_lastupdate['Kamer Deur']) > timeon_doorbell	
		then		
			commandArray['Deurbel - Standby']='Off'
		end

-- Vertrek - Standby	
		if otherdevices['Vertrek - Standby'] == 'On' 
			and otherdevices['Voor Deur'] == 'Closed' 
			and otherdevices['Achter Deur'] == 'Closed' 
			and otherdevices['Schuifpui'] == 'Closed' 
			and timedifference(otherdevices_lastupdate['Voor Deur']) > timeon_leaving_standby 
			and uservariables[security_activation_type] == 0		
		then		
		commandArray['Vertrek - Standby']='Off'
		end
	
-- Aankomst - Standby
		if otherdevices['Aankomst - Standby'] == 'On' 
			and otherdevices['Gang Wandlamp'] == 'On' 
			and otherdevices['Kamer Deur'] == 'Closed' 
			and otherdevices['Voor Deur'] == 'Closed' 
			and otherdevices['Achter Deur'] == 'Closed'
			and otherdevices['Kelder Deur'] == 'Closed'		
			and otherdevices['Schuifpui'] == 'Closed' 
			and otherdevices['Trap Motion Boven'] == 'Off'
			and otherdevices['Trap Motion Beneden'] == 'Off'		
			and timedifference(otherdevices_lastupdate['Kamer Deur']) > timeon_arriving_standby 
			and timedifference(otherdevices_lastupdate['Voor Deur']) > timeon_arriving_standby
			and timedifference(otherdevices_lastupdate['Kelder Deur']) > timeon_arriving_standby 		
			and timedifference(otherdevices_lastupdate['Trap Motion Boven']) > timeon_arriving_standby 
			and timedifference(otherdevices_lastupdate['Trap Motion Beneden']) > timeon_arriving_standby
			and uservariables[security_activation_type] == 0		
		then		
		commandArray['Aankomst - Standby']='Off'	
		end
		
-- Aankomst Tuin - Standby
		if otherdevices['Aankomst Tuin - Standby'] == 'On'
			and otherdevices['Kamer Deur'] == 'Closed' 
			and otherdevices['Voor Deur'] == 'Closed'
			and otherdevices['Kelder Deur'] == 'Closed' 		
			and otherdevices['Trap Motion Boven'] == 'Off'
			and otherdevices['Trap Motion Beneden'] == 'Off'		
			and timedifference(otherdevices_lastupdate['Kamer Deur']) > timeon_arriving_garden_standby 
			and timedifference(otherdevices_lastupdate['Voor Deur']) > timeon_arriving_garden_standby
			and timedifference(otherdevices_lastupdate['Kelder Deur']) > timeon_arriving_garden_standby
			and timedifference(otherdevices_lastupdate['W.C Motion']) > timeon_arriving_garden_standby		
			and timedifference(otherdevices_lastupdate['Trap Motion Boven']) > timeon_arriving_garden_standby
			and timedifference(otherdevices_lastupdate['Trap Motion Beneden']) > timeon_arriving_garden_standby 	
			and uservariables[security_activation_type] == 0		
		then		
		commandArray['Aankomst Tuin - Standby']='Off'			
		end