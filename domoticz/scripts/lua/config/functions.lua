--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ functions.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: 7-4-2017
	@ All global functions needed
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
--
-- **********************************************************
-- Time Difference
-- **********************************************************
--

function timedifference(s)
	year = string.sub(s, 1, 4)
	month = string.sub(s, 6, 7)
	day = string.sub(s, 9, 10)
	hour = string.sub(s, 12, 13)
	minutes = string.sub(s, 15, 16)
	seconds = string.sub(s, 18, 19)
	t1 = os.time()
	t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
	difference = os.difftime (t1, t2)
	return difference
end

--
-- **********************************************************
-- Time Between
-- **********************************************************
--

function timebetween(s,e)
   timenow = os.date("*t")
   year = timenow.year
   month = timenow.month
   day = timenow.day
   s = s .. ":00"  
   e = e .. ":00"
   shour = string.sub(s, 1, 2)
   sminutes = string.sub(s, 4, 5)
   sseconds = string.sub(s, 7, 8)
   ehour = string.sub(e, 1, 2)
   eminutes = string.sub(e, 4, 5)
   eseconds = string.sub(e, 7, 8)
   t1 = os.time()
   t2 = os.time{year=year, month=month, day=day, hour=shour, min=sminutes, sec=sseconds}
   t3 = os.time{year=year, month=month, day=day, hour=ehour, min=eminutes, sec=eseconds}
   sdifference = os.difftime (t1, t2)
   edifference = os.difftime (t1, t3)
   isbetween = false
   if sdifference >= 0 and edifference <= 0 then
      isbetween = true
   end
   return isbetween
end

--
-- **********************************************************
-- Is weekend?
-- **********************************************************
-- weekday [0-6 = Sunday-Saturday]

function IsWeekend()
	local dayNow = tonumber(os.date("%w"))
		local weekend
			if (dayNow == 0) or (dayNow == 5) or (dayNow == 6) then weekend = 1
			else weekend = 0
			end 
	return weekend
end

--
-- **********************************************************
-- Blink Light IsNotDimmer
-- **********************************************************
--

function blinkLight(light, times)
   times = times or 2
   cmd1 = 'Off'
   cmd2 = 'On'
   pause = 10
   if (otherdevices[light] == 'Off') then
      cmd1 = 'On'
      cmd2 = 'Off'
   end   
   for i = 1, times do
   
      commandArray[#commandArray+1]={[light]=cmd1..' AFTER '..pause }
      pause = pause + 3
      commandArray[#commandArray+1]={[light]=cmd2..' AFTER '..pause }
      pause = pause + 3
   end
end

--
-- **********************************************************
-- SentMail
-- **********************************************************
--
function mail(subject, body, adress)

	if lua.notify == true then
		commandArray[#commandArray+1]={["SendEmail"]=subject.."#"..body.."#"..adress }
	end

end

--
-- **********************************************************
-- Timer Scripts Called
-- **********************************************************
--
function IsTimerEvent()
	f = io.popen('ls ' .. lua.timers)
	for name in f:lines() do
		dofile ('' .. lua.timers .. ''..name..'')
	end
	f:close()
	IsTimerLog()	
end	
	
--
-- **********************************************************
-- Event commandArray
-- **********************************************************
--

function IsEventArray()
	for commandArraydeviceName, commandArraydeviceValue in pairs(commandArray) do	
	   if type(commandArraydeviceValue) == "table" then	   
		  for commandArraydeviceTableName, commandArraydeviceTableValue in pairs(commandArraydeviceValue) do
		  
			if commandArraydeviceTableName ~= 'SendEmail' then
			print('> '..commandArraydeviceName.."="..commandArraydeviceTableName.." switched ".. commandArraydeviceValue[deviceTableName])
			end
			
			if commandArraydeviceTableName == 'SendEmail' then
			print('> "'..commandArraydeviceTableName..'": '..commandArraydeviceTableValue..'')			
			end
			
		  end
	   else
				if commandArraydeviceValue == 'Arm Away' then print('> "'..commandArraydeviceName..'" armed')
				elseif commandArraydeviceValue == 'Arm Home' then print('> "'..commandArraydeviceName..'" armed for the night')
				elseif commandArraydeviceValue == 'Disarm' then print('> "'..commandArraydeviceName..'" disarmed')
				else
				print('> "'..commandArraydeviceName..'" set: '..commandArraydeviceValue..'')
				end
	   end
	end
end


--
-- **********************************************************
-- Trigger commandArray
-- **********************************************************
--

function IsEventTrigger()
	for deviceName, deviceValue in pairs(devicechanged) do
		for tablename, tabledevice in pairs (trigger) do
			if deviceName == tabledevice then
-----------------------------------------------------------------------------------------------				
-----------------------------------------------------------------------------------------------	
				if deviceValue == 'On' then
					if string.find(deviceName, "Laptop") or string.find(deviceName, "GSM") then
						msg = '"'..deviceName..'" has just come online'
						
					elseif string.find(deviceName, "IsDonker") then
						msg = '"'..deviceName..'" dusk sensor switched ON'						
					
					elseif string.find(deviceName, "Motion") then
						msg = '"'..deviceName..'" sensor detected motion'
						
					elseif string.find(deviceName, "Knop") then
						msg = '"'..deviceName..'" toggled ON'						
						
					elseif string.find(deviceName, "Iemand Thuis") then
						msg = 'Somebody just got home, say hi!'						
						
					else
					msg = '"'..deviceName..'" switched ON'
					end				
				end
-----------------------------------------------------------------------------------------------				
				if deviceValue == 'Off' then
					if string.find(deviceName, "Laptop") or string.find(deviceName, "GSM") then
						msg = '"'..deviceName..'" has just gone offline'
						
					elseif string.find(deviceName, "IsDonker") then
						msg = '"'..deviceName..'" dusk sensor switched OFF'
						
					elseif string.find(deviceName, "Motion") then
						msg = '"'..deviceName..'" sensor did not detect motion anymore'
						
					elseif string.find(deviceName, "Knop") then
						msg = '"'..deviceName..'" toggled OFF'						

					elseif string.find(deviceName, "Iemand Thuis") then
						msg = 'Nobody at home anymore, thats sad...'							
						
					else
					msg = '"'..deviceName..'" switched OFF'
					end					
				end
-----------------------------------------------------------------------------------------------	
-----------------------------------------------------------------------------------------------	
				if deviceValue == 'Open' then msg = 'Somebody opened the "'..deviceName..'"' end
				if deviceValue == 'Closed' then msg = 'Somebody closed the "'..deviceName..'"' end				
-----------------------------------------------------------------------------------------------	
-----------------------------------------------------------------------------------------------
				if deviceValue == 'Group On' then msg = 'Somebody pressed the "'..deviceName..'"' end			
-----------------------------------------------------------------------------------------------	
-----------------------------------------------------------------------------------------------
				if deviceValue == 'Arm Away' then msg = '"'..deviceName..'" armed for away' end
				if deviceValue == 'Arm Home' then msg = '"'..deviceName..'" armed for home' end
				if deviceValue == 'Disarm' then msg = '"'..deviceName..'" has been disarmed' end					
-----------------------------------------------------------------------------------------------	
-----------------------------------------------------------------------------------------------
				if deviceName == trigger.sirene_remote and deviceValue == 'On' then msg = '"'..deviceName..'" ON, Alarm armed manually' end
				if deviceName == trigger.sirene_remote and deviceValue == 'Off' then msg = '"'..deviceName..'" OFF, Alarm disarmed manually' end
-----------------------------------------------------------------------------------------------	
-----------------------------------------------------------------------------------------------	
				if deviceValue == 'Panic' then msg = '"'..deviceName..'" detected smoke!!!!!'  end
-----------------------------------------------------------------------------------------------	
-----------------------------------------------------------------------------------------------
			
				if msg ~= nil then
				print(''..msg..'')
				else
				print(''..deviceName..' switched '..deviceValue..'')
				end
	
			end
			
		end
	end
end	

--
-- **********************************************************
-- Event Log
-- **********************************************************
--

function IsEvent()

					require "worker"
					IsWorker()
					
					if event_body ~= nil then	
						if lua.verbose == true then
							print '========================= EVENT LOG ========================='
							print(' ')
							print('Message:')
							print(IsEventTrigger())
if event_body0 ~= nil then	print(''..event_body0..'')	end	
if event_body1 ~= nil then	print(''..event_body1..'')	end
if event_body2 ~= nil then	print(''..event_body2..'')	end
if event_body3 ~= nil then	print(''..event_body3..'')	end							
if event_body ~= nil  then	print(''..event_body..'')	end	
						    print(' ')
							print('Executing:')					
							print (IsEventArray())
							print(' ')
							print '============================================================='
						end
					end	
end

--
-- **********************************************************
-- Timer Log
-- **********************************************************
--

function IsTimerLog()
					if lua.verbose == true then
						if timer_body ~= nil then
							print '========================= TIMER LOG ========================='							
							print(' ')	
if timer_body ~= nil  then	print('Message:') 		    end						
if timer_body ~= nil  then	print('- '..timer_body..'')	end								
if timer_body0 ~= nil then	print('- '..timer_body0..'')	end
if timer_body1 ~= nil then	print('- '..timer_body1..'')	end
if timer_body2 ~= nil then	print('- '..timer_body2..'')	end	
if timer_body3 ~= nil then	print('- '..timer_body3..'')	end
							print(' ')
							print (IsEventArray())							
							print '============================================================='
						end
					end	
end
