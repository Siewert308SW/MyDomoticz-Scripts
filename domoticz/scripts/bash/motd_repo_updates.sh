#!/bin/bash

#######################################################################################################################################################	

### motd_updates.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 01-19-2016
### Script to check for rpi, repo updated packages to display in motd

#######################################################################################################################################################	

sudo apt-get update
sudo apt-get upgrade -d -y | grep 'upgraded,' | awk {'print $1'} > /mnt/storage/domoticz_scripts/logging/motd_repo_updates/repo_updates.txt 
sudo apt-get install rpi-update -d -y | grep 'upgraded,' | awk {'print $1'} > /mnt/storage/domoticz_scripts/logging/motd_repo_updates/rpi_updates.txt

if [[ $(sudo JUST_CHECK=1 rpi-update | grep '*** Your firmware') = *Your* ]]; then
  echo "* Your firmware is up to date" > /mnt/storage/domoticz_scripts/logging/motd_repo_updates/firmware_updates.txt
else
  echo "* There is a firmware update available" > /mnt/storage/domoticz_scripts/logging/motd_repo_updates/firmware_updates.txt
fi

###sudo JUST_CHECK=1 rpi-update | grep '*** Your firmware' | awk {'print $2, $3, $4, $5, $6, $7, $8'} > /mnt/storage/domoticz_scripts/logging/motd_repo_updates/firmware_updates.txt
echo "Update Check Complete"

exit 1
