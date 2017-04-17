--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ buienradar.lua
	@ author	: Siewert Lameijer
	@ since		: 17-4-2017
	@ updated	: 17-4-2017
	@ Script for predicting rainfall in the upcoming hours
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]
	
local m = os.date('%M')

--
-- **********************************************************
-- Buienradar
-- **********************************************************
--	

	local RainTextIDX = 192   --your domoticz text device
	local Rain60TextIDX = 193   --your domoticz text device	
	local Rain120TextIDX = 194   --your domoticz text device		

	totalrain = 0
	rainlines = 0



if (m % 30 == 0) then -- run once in 30 min

	   minuten=30
	   minuten60=60
	   minuten120=110
	   
	   RainPrediction = IsItGonnaRain(minuten)
	   RainmmHour=10^((RainPrediction-109)/32)
	   
	   RainPrediction60 = IsItGonnaRain(minuten60)
	   RainmmHour=10^((RainPrediction60-109)/32)

	   RainPrediction120 = IsItGonnaRain(minuten120)
	   RainmmHour=10^((RainPrediction120-109)/32)	   

--
-- **********************************************************
-- Buienradar - komende 30 minuten
-- **********************************************************
--	   

	   if (RainPrediction > 5  ) then
		  verw = 3
		  RainPredictionText=('Komende 30min wordt er een buitje verwacht!')
		  
	   elseif (RainPrediction > 13  ) then
		  verw = 3
		  RainPredictionText=('Komende 30min ('..round(RainmmHour, 1)..' mm) regen verwacht!')	  
	   else
		  verw = 2
		  RainPredictionText=('Komende 30min blijft het voorlopig droog!')
	   end

--
-- **********************************************************
-- Buienradar - komende 60 minuten
-- **********************************************************
--
	   
	   if (RainPrediction60 > 5  ) then
		  verw = 3
		  RainPredictionText60=('Komende uur wordt er een buitje verwacht!')
		  
	   elseif (RainPrediction60 > 13  ) then
		  verw = 3
		  RainPredictionText60=('Komende uur ('..round(RainmmHour, 1)..' mm) regen verwacht!')	  
	   else
		  verw = 2
		  RainPredictionText60=('Komende uur blijft het voorlopig droog!')
	   end

--
-- **********************************************************
-- Buienradar - komende 120 minuten
-- **********************************************************
--
	   
	   if (RainPrediction120 > 10  ) then
		  verw = 3
		  RainPredictionText120=('Na het komende uur word er nog een buitje verwacht!')
		  
	   elseif (RainPrediction120 > 13  ) then
		  verw = 3
		  RainPredictionText120=('Na het komende uur word er nog ('..round(RainmmHour, 1)..' mm) regen verwacht!')	  
	   else
		  verw = 2
		  RainPredictionText120=('Na het komende uur blijft het voorlopig droog!')
	   end		   

--
-- **********************************************************
-- Buienradar - Update virtual text device
-- **********************************************************
--
	   
	   commandArray[1] = {['UpdateDevice'] = RainTextIDX .. '|0|' .. tostring(RainPredictionText)}	   
	   commandArray[2] = {['UpdateDevice'] = Rain60TextIDX .. '|0|' .. tostring(RainPredictionText60)}
	   commandArray[3] = {['UpdateDevice'] = Rain120TextIDX .. '|0|' .. tostring(RainPredictionText120)}	   

end