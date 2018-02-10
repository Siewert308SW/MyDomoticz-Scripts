--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ time_xmin_test.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: x-xx-xxxx
	@ Script for testing various trail and errors
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]


--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ time_xmin_test.lua
	@ author	: Siewert Lameijer
	@ since		: 1-1-2015
	@ updated	: x-xx-xxxx
	@ Script for testing various trail and errors
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

-- Switches
	local dummy1 = 'Dummy 1'	

	
--[[
-----------------------------------------------------------------------------------------------------------------------
function toggle(device, cmd)
for i, v in pairs(otherdevices_idx) do

	for CommandArrayName, CommandArrayValue in pairs(commandArray) do

		if CommandArrayName == i then
		
			HardwareName=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid="..v.."' | grep -w 'HardwareName'  | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)
		
			SwitchType=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid="..v.."' | grep -w 'SwitchType'  | awk '{print $3}' | sed 's/\"//g' | sed 's/,//g'", false)

			--print(HardwareName)
			--print(SwitchType)
		print('')
		print('**********************************************************')			
					if HardwareName == 'RFXtrx433E' and SwitchType == 'On/Off' then
					print('Switch:' ..CommandArrayName.. ' switched '..CommandArrayValue..'')
					print('This switch is a RFXtrx433E device')
					--commandArray[CommandArrayName]=''..CommandArrayValue..' REPEAT 2 INTERVAL 1'
					else
					print('Switch:' ..CommandArrayName.. ' switched '..CommandArrayValue..'')
					print('This switch isnt a RFXtrx433E device')					
					--commandArray[CommandArrayName]=''..CommandArrayValue..' REPEAT 2 INTERVAL 1'
					end
		print('**********************************************************')					
		print('')			
		end
	end
end
--]]
-----------------------------------------------------------------------------------------------------------------------	
	
	
	if devicechanged[dummy1] == 'On'
	then
	commandArray['Dummy 1']='Off AFTER 10'
	commandArray['Dummy 2']='On REPEAT 3 INTERVAL 1'	
	end
	
	if devicechanged[dummy1] == 'Off'
	then
	logmessage=('Dit is een test...')
	commandArray['Dummy 2']='Off'	
	end	
	


	