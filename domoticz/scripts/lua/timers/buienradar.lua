--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ buienradar.lua
	@ author	: Siewert Lameijer
	@ since		: 17-4-2017
	@ updated	: 18-4-2017
	@ Script for predicting rainfall in the upcoming hours
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Buienradar
-- **********************************************************
--	

	local RainTextIDX = 192   --your domoticz text device
	local Rain60TextIDX = 193   --your domoticz text device	
	local Rain120TextIDX = 194   --your domoticz text device		
	local m = os.date('%M')
	totalrain = 0
	rainlines = 0



if (m % 15 == 0) then -- run once in 15 min

	   minuten=30
	   minuten60=60
	   minuten120=100
	   
	   RainPrediction = IsItGonnaRain(minuten)
	   RainmmHour=10^((RainPrediction-109)/32)	   

--
-- **********************************************************
-- Buienradar - Update virtual text device
-- **********************************************************
--	   

	   if (RainPrediction > 5  ) then
		  verw = 3
		RainPredictionText=('Komende 30min wordt er een buitje verwacht!')
			RainPredictionText60=('Komende uur wordt er een buitje verwacht!')
				RainPredictionText120=('Na het komende uur word er een buitje verwacht!')			  
	   elseif (RainPrediction > 12  ) then
		  verw = 2
		RainPredictionText=('Komende 30min ('..round(RainmmHour, 1)..' mm) regen verwacht!')
			RainPredictionText60=('Komende uur ('..round(RainmmHour, 1)..' mm) regen verwacht!')
				RainPredictionText120=('Na het komende uur word er ('..round(RainmmHour, 1)..' mm) regen verwacht!')			
			
	   else
		  verw = 1
		RainPredictionText=('Komende 30min blijft het voorlopig droog!')
		  	RainPredictionText60=('Komende uur blijft het voorlopig droog!')
				RainPredictionText120=('Na het komende uur blijft het voorlopig droog!')			
	   end	   


	   commandArray[1] = {['UpdateDevice'] = RainTextIDX .. '|0|' .. tostring(RainPredictionText)}	   
	   commandArray[2] = {['UpdateDevice'] = Rain60TextIDX .. '|0|' .. tostring(RainPredictionText60)}
	   commandArray[3] = {['UpdateDevice'] = Rain120TextIDX .. '|0|' .. tostring(RainPredictionText120)}	   

end