--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ buienradar.lua
	@ author	: Siewert Lameijer
	@ since		: 17-4-2017
	@ updated	: 19-4-2017
	@ Script for predicting rainfall in the upcoming hour
	
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



if (m % 29 == 0) then -- run once in 30 min

	   minuten=60
	   
	   RainPrediction = IsItGonnaRain(minuten)
	   RainmmHour=10^((RainPrediction-109)/32)	   

--
-- **********************************************************
-- Buienradar - Update virtual text device
-- **********************************************************
--	   

	   if (RainPrediction > 3 and RainPrediction <= 7) then
		  verw = 4
		RainPredictionText=('Het komende uur kan een spatje vallen')
	   elseif (RainPrediction > 7 and RainPrediction <= 14) then
		  verw = 3
		RainPredictionText=('Het komende uur kan een buitje vallen')			  		
	   elseif (RainPrediction > 14  ) then
		  verw = 2
		RainPredictionText=('Het komende uur kan ('..round(RainmmHour, 1)..' mm) regenen')
	   else
		  verw = 1
		RainPredictionText=('Het komende uur blijft het voorlopig droog')			
	   end	   
		commandArray['UpdateDevice'] = RainTextIDX .. '|0|' .. tostring(RainPredictionText)
end