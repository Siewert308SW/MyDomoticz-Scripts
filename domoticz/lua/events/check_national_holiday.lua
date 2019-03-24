--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ check_national_holiday.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 3-2-2019
	@ Script to check if it's a national holliday and there for its weekend when ask by function (weekend)
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
--
-- *********************************************************************
-- Check if it's a national holiday
-- *********************************************************************
--


	if devicechanged[lux_sensor.porch] and timebetween("21:59:59","23:59:59") and uservariables[var.holiday_override] == 0 then
		
		today=os.capture('date --date="0 days ago " +"%-d-%-m-%Y"', false)
		tomorrow=os.capture('date --date="tomorrow " +"%-d-%-m-%Y"', false)	
		
		return_today=os.capture("curl -s 'http://www.kayaposoft.com/enrico/json/v2.0/?action=isPublicHoliday&date="..today.."&country=nl'", false)

		return_tomorrow=os.capture("curl -s 'http://www.kayaposoft.com/enrico/json/v2.0/?action=isPublicHoliday&date="..tomorrow.."&country=nl'", false)

-- *********************************************************************
		
		if string.find(return_today, 'true') and string.find(return_tomorrow, 'true') and uservariables[var.holiday] ~= 1 then
			commandArray["Variable:" .. var.holiday .. ""]= '1'
			commandArray["Variable:" .. var.holiday_override .. ""]= '1'			
		end

		if string.find(return_today, 'false') and string.find(return_tomorrow, 'true') and uservariables[var.holiday] ~= 1 then
			commandArray["Variable:" .. var.holiday .. ""]= '1'
			commandArray["Variable:" .. var.holiday_override .. ""]= '1'			
		end

-- *********************************************************************
		
		if string.find(return_today, 'false') and string.find(return_tomorrow, 'false') and uservariables[var.holiday] ~= 0 then
			commandArray["Variable:" .. var.holiday .. ""]= '0'
			commandArray["Variable:" .. var.holiday_override .. ""]= '1'			
		end
		
		if string.find(return_today, 'true') and string.find(return_tomorrow, 'false') and uservariables[var.holiday] ~= 0 then
			commandArray["Variable:" .. var.holiday .. ""]= '0'
			commandArray["Variable:" .. var.holiday_override .. ""]= '1'			
		end		

	end
	
--
-- *********************************************************************
-- Reset Standby
-- *********************************************************************
--


	if devicechanged[lux_sensor.porch] and timebetween("00:00:00","20:59:59") and uservariables[var.holiday_override] == 1 then
		commandArray["Variable:" .. var.holiday_override .. ""]= '0'			
	end
