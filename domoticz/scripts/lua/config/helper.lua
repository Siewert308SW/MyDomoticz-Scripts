--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ helper.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 2-14-2018
	@ 
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Function for checking predefined devices for their existance 
-- **********************************************************
--

	function validate() 

		result = true
		if lua.device_check == "true" or uservariables[var.lua_logging] == 3 then		
			for tableName, tableDevice in pairs (triggers) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in settings.lua doesnt exist')
					result = false
				end
			end
			
	-- **********************************************************
			
			for tableName, tableDevice in pairs (someone) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end
			
	-- **********************************************************
			
			for tableName, tableDevice in pairs (laptop) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************
			
			for tableName, tableDevice in pairs (phone) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end
			
	-- **********************************************************
			
			for tableName, tableDevice in pairs (visitor) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end			

	-- **********************************************************
			
			for tableName, tableDevice in pairs (light) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************
			
			for tableName, tableDevice in pairs (garden) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end
			
	-- **********************************************************
			
			for tableName, tableDevice in pairs (switch) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************

			--for tableName, tableDevice in pairs (group) do
				--if not otherdevices["Group:" .. tableDevice .. ""] and tonumber(tableDevice) == nil then	
					--error('Group: [' .. tableDevice .. '] in switches.lua doesnt exist')
					--result = false
				--end
			--end
			
	-- **********************************************************

			--for tableName, tableDevice in pairs (scene) do
				--if not otherdevices["Scene:" .. tableDevice .. ""] and tonumber(tableDevice) == nil then			
				--	error('Scene: [' .. tableDevice .. '] in switches.lua doesnt exist')
				--result = false
				--end
			--end		
			
	-- **********************************************************
			
			for tableName, tableDevice in pairs (door) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end
			
	-- **********************************************************
			
			for tableName, tableDevice in pairs (motion_sensor) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end	

	-- **********************************************************
			
			for tableName, tableDevice in pairs (window) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************
			
			for tableName, tableDevice in pairs (plug) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************
			
			for tableName, tableDevice in pairs (watt) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************
			
			for tableName, tableDevice in pairs (var) do
				if not uservariables[tableDevice] and tonumber(tableDevice) == nil then
					error('User Variable: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************
			
			for tableName, tableDevice in pairs (lux_sensor) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************
			
			for tableName, tableDevice in pairs (doorbell) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************
			
			for tableName, tableDevice in pairs (temp) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end

	-- **********************************************************
			
			for tableName, tableDevice in pairs (nest) do
				if not otherdevices[tableDevice] and tonumber(tableDevice) == nil then
					error('Device: [' .. tableDevice .. '] in switches.lua doesnt exist')
					result = false
				end
			end
		end
		return result

	end

	function error(msg)
		if msg ~= nil then
			if uservariables[var.lua_error] == 0 then 
			
			print_color(''..errorcolor.header..'', '===========================ERROR==============================')
			print_color(''..errorcolor.title..'', 'Message:')
			print_color(''..errorcolor.message..'', '==> All Event scripts disabled')			
			print_color(''..errorcolor.footer..'', '==============================================================')			
			
			commandArray["Variable:" .. var.lua_error .. ""]= '1'
			end
			
			print_color(''..errorcolor.header..'', '===========================ERROR==============================')
			print_color(''..errorcolor.title..'', 'Message:')
			print_color(''..errorcolor.message..'', '==> ' .. msg)			
			print_color(''..errorcolor.footer..'', '==============================================================')
		end
	end