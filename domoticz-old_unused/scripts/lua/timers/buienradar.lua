--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ buienradar.lua
	@ author	: Siewert Lameijer
	@ since		: 17-4-2017
	@ updated	: 24-4-2017
	@ Script for predicting rainfall in the upcoming hour
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- **********************************************************
-- Buienradar
-- **********************************************************
--	

	local RainTextIDX = 192   --your domoticz text device		
	local m = os.date('%M')
	totalrain = 0
	rainlines = 0



if (m % 20 == 0) then -- run once in 20 min

	   minuten=90
	   
	   RainPrediction = IsItGonnaRain(minuten)
	   RainmmHour=10^((RainPrediction-109)/32)	   

--
-- **********************************************************
-- Buienradar - Update virtual text device
-- **********************************************************
--	   

	   if (RainPrediction > 1 and RainPrediction <= 6) then
		  verw = 4
		RainPredictionText=('Kans op een spatje')
	   elseif (RainPrediction > 6 and RainPrediction <= 20) then
		  verw = 3
		RainPredictionText=('Kans op een bui')			  		
	   elseif (RainPrediction > 20  ) then
		  verw = 2
		RainPredictionText=('Neerslag kans ±'..round(RainmmHour, 1)..'mm')
	   else
		  verw = 1
		RainPredictionText=('Geen neerslag verwacht')			
	   end	   
		commandArray['UpdateDevice'] = RainTextIDX .. '|0|' .. tostring(RainPredictionText)
end