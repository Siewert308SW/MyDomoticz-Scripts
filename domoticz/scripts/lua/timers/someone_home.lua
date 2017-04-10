--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ someone_home.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 10-4-2017
	@ Script for switching SomeOneHome ON/OFF 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Various
	local security_activation_type		= 'alarm_ActivationType'

	timeout_someonehome_day 			= 7199 -- Assuming when after 120 minutes while no motion then nobody at home @ Day/Evening
	timeout_someonehome_night 			= 599 -- Assuming when after 30 minutes while no motion then nobody at home @ Night
	timeout_someonehome_standby 		= 299  -- After 2 min turn OFF standby which triggers some events
	timeout_someone_away 				= 599  -- Nobody at home trigger to prevent accidental triggers as well to trigger some events
	
	timeout_frontdoor					= 299	
	timeout_backdoor					= 299
	timeout_scullerydoor				= 299
	timeout_phones						= 299	
	
	presence 							= (otherdevices['Laptops'] == 'On' or otherdevices['Televisie'] == 'On' or otherdevices['Visite'] == 'On')	
--
-- **********************************************************
-- No motion = Nobody At Home
-- **********************************************************
--

-- Iemand Thuis - Dag/Avond
	if not presence and otherdevices['Iemand Thuis'] == 'On'
		and otherdevices['Telefoons'] == 'On'
	    and otherdevices['PIco RPi Powered']   == 'On'
	    and otherdevices['IsDonker - Standby']   == 'Off'
	    and otherdevices['Rookmelder - Loop']   == 'Off'
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate['Voor Deur']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Kamer Deur']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Kelder Deur']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Bijkeuken Deur']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Achter Deur']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Schuifpui']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['W.C Motion']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Trap Motion Beneden']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Trap Motion Boven']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Motion Eettafel']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Woonkamer Motion']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Televisie']) > timeout_someonehome_day
		and timedifference(otherdevices_lastupdate['Laptops']) > timeout_someonehome_day	
	then
		commandArray['Iemand Thuis']='Off'
		commandArray['Iemand Thuis - Standby']='Off AFTER 30'
		commandArray['Niemand Thuis']='On AFTER 120'
		timer_body = 'No motion detected for over '..timeout_someonehome_day..' seconds'
		timer_body0 = 'Assuming everyone went away'		
		timer_body1 = 'Deactivating your home now!'				
	end
	
-- Iemand Thuis - Nacht
	if not presence and otherdevices['Iemand Thuis'] == 'On'
		and otherdevices['Telefoons'] == 'On'
	    and otherdevices['PIco RPi Powered']   == 'On'
	    and otherdevices['IsDonker - Standby']   == 'On'
	    and otherdevices['Woonkamer Vaas Lamp']   == 'Off'
	    and otherdevices['Rookmelder - Loop']   == 'Off'	
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate['Voor Deur']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Kamer Deur']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Kelder Deur']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Bijkeuken Deur']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Achter Deur']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Schuifpui']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['W.C Motion']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Trap Motion Beneden']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Trap Motion Boven']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Motion Eettafel']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Woonkamer Motion']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Televisie']) > timeout_someonehome_night
		and timedifference(otherdevices_lastupdate['Laptops']) > timeout_someonehome_night	
		and timedifference(otherdevices_lastupdate['Iemand Thuis']) > timeout_someonehome_night		
		and timedifference(otherdevices_lastupdate['Niemand Thuis']) > timeout_someonehome_night		
	then
		commandArray['Iemand Thuis']='Off'
		commandArray['Iemand Thuis - Standby']='Off AFTER 30'
		commandArray['Niemand Thuis']='On AFTER 120'		
		timer_body = 'No motion detected for over '..timeout_someonehome_night..' seconds'
		timer_body0 = 'Assuming everyone went away'		
		timer_body1 = 'Deactivating your home now!'		 
	end	
	
-- Iemand Thuis - Standby
    if otherdevices['Iemand Thuis - Standby'] == 'On'
		and otherdevices['Iemand Thuis'] == 'Off' 
		and uservariables[security_activation_type] == 0	
		and timedifference(otherdevices_lastupdate['Iemand Thuis']) > timeout_someonehome_standby 
	then	
		commandArray['Iemand Thuis - Standby']='Off'
	end
	

-- Niemand Thuis
    if otherdevices['Niemand Thuis'] == 'Off' 
		and otherdevices['Iemand Thuis'] == 'Off' 
		and otherdevices['Iemand Thuis - Standby'] == 'Off' 
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate['Iemand Thuis - Standby']) > timeout_someone_away  
	then		
		commandArray['Niemand Thuis']='On'	
	end	

    if otherdevices['Niemand Thuis'] == 'On'
		and otherdevices['Iemand Thuis'] == 'On'
		and otherdevices['Iemand Thuis - Standby'] == 'Off'
		and uservariables[security_activation_type] == 0		
	then		
		commandArray['Niemand Thuis']='Off'	
	end	
	
-- Phones offline bluetooth
    if otherdevices['Telefoons'] == 'Off' and otherdevices['Iemand Thuis'] == 'On'
	    and otherdevices['Televisie']   == 'Off'
	    and otherdevices['Laptops']   == 'Off'		
	    and otherdevices['PIco RPi Powered']   == 'On'
	    and otherdevices['Rookmelder - Loop']   == 'Off'
		and uservariables[security_activation_type] == 0		
		and timedifference(otherdevices_lastupdate['Voor Deur']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Kamer Deur']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Kelder Deur']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Bijkeuken Deur']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Achter Deur']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Schuifpui']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['W.C Motion']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Trap Motion Beneden']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Trap Motion Boven']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Motion Eettafel']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Woonkamer Motion']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Televisie']) > timeout_someone_away
		and timedifference(otherdevices_lastupdate['Laptops']) > timeout_someone_away
	then
-- Double check if phones are not detected by BT anymore
	ping_phone1="192.168.178.0" -- Siewert GSM
	ping_phone2="192.168.178.0" -- Jerina GSM
	ping_phone3="192.168.178.0" -- Natalya GSM	
	ping_phone4="192.168.178.0" -- Oma GSM
		ping_phone_1=os.execute('sudo ping -q -c1 -W 1 '..ping_phone1..'')
		if not ping_phone_1 and otherdevices['Iemand Thuis'] == 'On' then
			ping_phone_2=os.execute('sudo ping -q -c1 -W 1 '..ping_phone2..'')		
			if not ping_phone_2 and otherdevices['Iemand Thuis'] == 'On' then
				ping_phone_3=os.execute('sudo ping -q -c1 -W 1 '..ping_phone3..'')		
				if not ping_phone_3 and otherdevices['Iemand Thuis'] == 'On' then
					ping_phone_4=os.execute('sudo ping -q -c1 -W 1 '..ping_phone4..'')		
					if not ping_phone_4 and otherdevices['Iemand Thuis'] == 'On' then		
					timer_body = 'All phones are offline and no motion detected for over '..timeout_someone_away..' seconds'
					timer_body0 = 'Assuming everyone went away'		
					timer_body1 = 'Deactivating your home now!'
					commandArray['Iemand Thuis']='Off'
					commandArray['Iemand Thuis - Standby']='Off AFTER 30'
					commandArray['Niemand Thuis']='On AFTER 60'		
					end			
				end			
			end
		end	
	end