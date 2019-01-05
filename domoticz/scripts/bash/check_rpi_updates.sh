#!/bin/bash

###########################################################################################################################################

### check_rpi_updates.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 3-17-2018
### Script to check for domoticz, rpi & repo updated packages to display in motd

###########################################################################################################################################

###########################################################################################################################################	
### BEGINNING OF USER CONFIGURABLE PARAMETERS
###########################################################################################################################################

    DOMO_IP="127.0.0.1"      																	# Domoticz IP
    DOMO_PORT="8080"         																	# Domoticz port
	
### Retrieve current and updated Domoticz version number
	DOMO_JSON_CURRENT=`curl -s -X GET "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=getversion"`
	DOMO_CHANNEL=$(echo $DOMO_JSON_CURRENT |grep -Po '(?<=channel=)[^&]*')
	DOMO_CURRENT_VERSION=$(echo $DOMO_JSON_CURRENT | grep -Po '(?<="version" : "4.)[^"]*')	
	DOMO_JSON_NEW=`curl -s -i -H "Accept: application/json" "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=checkforupdate&forced=true" | grep "Revision" `	
	DOMO_NEW_VERSION=$(echo $DOMO_JSON_NEW | grep -Po '(?<="Revision" : )[^,]*')	
	DOMO_CHANNEL=$(echo $DOMO_JSON_CURRENT | grep -Po '(?<=channel=)[^&]*')	

############################################################################################################################################
### END OF USER CONFIGURABLE PARAMETERS
############################################################################################################################################



	sudo apt-get update > /dev/null 2>&1

	repo=`sudo apt-get upgrade -d -y | grep 'upgraded,' | awk {'print $1'}`
		echo $repo > /mnt/storage/logging/repo_updates/repo_updates.txt

	rpi=`sudo apt-get install rpi-update -d -y | grep 'upgraded,' | awk {'print $1'}`
		echo $rpi > /mnt/storage/logging/repo_updates/rpi_updates.txt

	if [[ $(sudo JUST_CHECK=1 rpi-update | grep '*** Your firmware') = *Your* ]]; then
		echo "0" > /mnt/storage/logging/repo_updates/firmware_updates.txt 
	else
		echo "1" > /mnt/storage/logging/repo_updates/firmware_updates.txt
	fi

	pihole=`sudo pihole -v`
		echo $pihole > /mnt/storage/logging/repo_updates/pihole_updates.txt

############################################################################################################################################

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
	if [ $DOMO_CURRENT_VERSION = $DOMO_NEW_VERSION ] ; then
	echo 0 > /mnt/storage/logging/domo_updates/domo_updates.txt
	echo " " > /mnt/storage/logging/domo_updates/domo_update_from.txt
	echo " " > /mnt/storage/logging/domo_updates/domo_update_to.txt		
	fi	
	
	if  [ $DOMO_CURRENT_VERSION != $DOMO_NEW_VERSION ] ; then		
	echo 1 > /mnt/storage/logging/domo_updates/domo_updates.txt
	echo "- From: $DOMO_CURRENT_VERSION" > /mnt/storage/logging/domo_updates/domo_update_from.txt
	echo " To: $DOMO_NEW_VERSION" > /mnt/storage/logging/domo_updates/domo_update_to.txt		
	fi
