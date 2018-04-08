--[[
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

	@ quake_tweet.lua
	@ author	: Siewert Lameijer
	@ since		: 4-7-2018
	@ updated	: 4-8-2018
	@ Script for scraping data from "Dutch earthquakes" plugin and tweet if a quake occurs in my region
	
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
--]]

--
-- *********************************************************************
--  If a quake occurs in my region then gather data and tweet
-- *********************************************************************
--

if devicechanged[quake.switch] then
	date_return=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid=27' | grep -w 'Data' | awk '{print $3, $4}' | cut -c 2-17", false)

	location_return=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid=27' | grep -w 'Data'", false)
	maps_return=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid=27' | grep -w 'Data' | cut -c 89-148", false)
	magnitude_return=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid=27' | grep -w 'Data' | awk '{print $10, $11}' | cut -c 1-17 | sed 's/Depth://g'", false)

	depth_return=os.capture("curl 'http://127.0.0.1:8080/json.htm?type=devices&rid=27' | grep -w 'Data' | awk '{print $12, $13}' | cut -c 1-6 | sed 's/Depth://g'", false)

	for tableHeader, tableLocation in pairs (locations) do
		if string.find(location_return, '' .. tableLocation) then

			file = io.open(''..quake.file..'', "w+") 
			file:write("#Aardbeving #Zoutkamp e.o. \n\n")
			file:write('Datum: '..date_return..'\n')
			file:write('Locatie: '..tableLocation..'\n')
			file:write('Magnitude: '..magnitude_return..'\n')
			file:write('Diepte: '..depth_return..'\n\n')
			file:write(''..maps_return..'\n\n')
			file:write("Bron: KNMI \n")	
			file:close()
			commandArray['SendNotification']='Aardbeving bij '..tableLocation..'#Datum: '..date_return..' Locatie: '..tableLocation..' Magnitude: '..magnitude_return..''
			os.execute('/usr/bin/python '..quake.tweet..' &')
		end
	end

end