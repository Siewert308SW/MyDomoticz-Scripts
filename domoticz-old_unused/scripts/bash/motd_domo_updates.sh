#!/bin/bash

###############################################################################################################################################################	

### domo_updates.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 26-12-2016
### Script to backup check for Domoticz updates to display in MOTD if a update is available
	
###############################################################################################################################################################	
### BEGINNING OF USER CONFIGURABLE PARAMETERS
###############################################################################################################################################################
 
    DOMO_IP="127.0.0.1"      																	# Domoticz IP
    DOMO_PORT="8080"         																	# Domoticz port
	
###############################################################################################################################################################	
### BEGINNING OF USER CONFIGURABLE PARAMETERS
###############################################################################################################################################################
 
### Retrieve current and updated Domoticz version number
	DOMO_JSON_CURRENT=`curl -s -X GET "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=getversion"`	
	DOMO_CHANNEL=$(echo $DOMO_JSON_CURRENT |grep -Po '(?<=channel=)[^&]*')
	DOMO_CURRENT_VERSION=$(echo $DOMO_JSON_CURRENT |grep -Po '(?<="version" : "3.)[^"]*')	
	DOMO_JSON_NEW=`curl -s -i -H "Accept: application/json" "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=checkforupdate&forced=true" |grep "Revision" `	
	DOMO_NEW_VERSION=$(echo $DOMO_JSON_NEW |grep -Po '(?<="Revision" : )[^,]*')	
	DOMO_CHANNEL=$(echo $DOMO_JSON_CURRENT |grep -Po '(?<=channel=)[^&]*')	

###############################################################################################################################################################	
### END OF USER CONFIGURABLE PARAMETERS
###############################################################################################################################################################

###############################################################################################################################################################	

### Do not edit anything below this line unless you're knowing what to do!

###############################################################################################################################################################	

	lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
	}

	OS=`lowercase \`uname -s\``
	MACH=`uname -m`
	if [ ${MACH} = "armv6l" ]
	then
	MACH="armv7l"
	fi
		
### Domoticz Update Check
		echo " "
		echo "==> Lets see if there is a new $DOMO_CHANNEL update "
		echo "--- Contacting Domoticz GitHub"

		if [ $DOMO_CURRENT_VERSION = $DOMO_NEW_VERSION ] ; then
		echo "--- No Update Available"
		echo 0 > /mnt/storage/domoticz_scripts/logging/motd_domo_updates/domo_updates.txt
		echo " " > /mnt/storage/domoticz_scripts/logging/motd_domo_updates/domo_update_from.txt
		echo " " > /mnt/storage/domoticz_scripts/logging/motd_domo_updates/domo_update_to.txt		
		fi	
		if  [ $DOMO_CURRENT_VERSION != $DOMO_NEW_VERSION ] ; then		
		echo "--- New Update available"
		echo 1 > /mnt/storage/domoticz_scripts/logging/motd_domo_updates/domo_updates.txt
		echo "- From: $DOMO_CURRENT_VERSION" > /mnt/storage/domoticz_scripts/logging/motd_domo_updates/domo_update_from.txt
		echo " To: $DOMO_NEW_VERSION" > /mnt/storage/domoticz_scripts/logging/motd_domo_updates/domo_update_to.txt		
		fi
exit
