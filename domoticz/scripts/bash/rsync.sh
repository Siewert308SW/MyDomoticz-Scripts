#!/bin/bash

###############################################################################################################################################################	

### rsync.sh
### @author	: Siewert Lameijer
### @since	: 27-12-2016
### @updated: 13-2-2017
### Script to rsync your Pi in case something screw your system.
### Just switch your current sd-card with the rsynced sd-card and your ready to go...

###############################################################################################################################################################	

# WARNING: Try this script first before putting it in action on your production OS
# rync isn't 100% secure, it can screw things up and there for make your backup unusable, be aware that...
# For installation instructions then visite the link below:
# Wiki: http://domoticz.com/wiki/Rsync_raspberry_bash_script
# Forum: https://www.domoticz.com/forum/viewtopic.php?f=23&t=15086
	
###############################################################################################################################################################	
### BEGINNING OF USER CONFIGURABLE PARAMETERS
###############################################################################################################################################################

MOUNT_LOCATION="/mnt" 													# Choose your desired mount point to start with
MOUNT_DATA_FOLDER="rsynced"												# Choose your desired folder name to rsync to /mnt/backup for example												

BOOT_UUID="EC31-BD2C"													# Get your UUDI for /boot partition from your backup sd-card by sudo blkid in shell
DATA_UUID="5139e494-460e-485f-9f9e-3e5d28660264"						# Get your UUDI for /root partition from your backup sd-card by sudo blkid in shell

EXCLUDE_FILE="/mnt/storage/domoticz/rsync_exclude/rsync_exclude.txt" # exclude file only contains /mnt*/

###############################################################################################################################################################	
### END OF USER CONFIGURABLE PARAMETERS
###############################################################################################################################################################

###############################################################################################################################################################	

### Do not edit anything below this line unless your knowing what to do!

###############################################################################################################################################################	

GREP_BOOT_UUID=`sudo blkid | grep $BOOT_UUID | /usr/bin/cut -d ":" -f 1`
GREP_DATA_UUID=`sudo blkid | grep $DATA_UUID | /usr/bin/cut -d ":" -f 1`
GREP_DATA_PARTUUID=`sudo blkid | grep $DATA_UUID | awk {'print $4'} | /usr/bin/cut -d '"' -f 2 | /usr/bin/cut -d '"' -f 1`

BOOT_MOUNT=$GREP_BOOT_UUID
DATA_MOUNT=$GREP_DATA_UUID

RSYNC=`sudo dpkg-query -l | grep rsync | wc -l`

echo "
 ____                        _   _            ____                       
|  _ \  ___  _ __ ___   ___ | |_(_) ___ ____ |  _ \ ___ _   _ _ __   ___ 
| | | |/ _ \|  _   _ \ / _ \| __| |/ __|_  / | |_) / __| | | |  _ \ / __|
| |_| | (_) | | | | | | (_) | |_| | (__ / /  |  _ <\__ \ |_| | | | | (__ 
|____/ \___/|_| |_| |_|\___/ \__|_|\___/___| |_| \_\___/\___ |_| |_|\___|
                                                        |___/            
"
sleep 1

### Stop Domoticz service
		echo "::: Stop Domoticz Service before rsync OS"
		echo "---------------------------------------------------"
sleep 1
		echo "--- Stopping Domoticz Service"
		echo "--- Please standby!"
	    sudo service domoticz.sh stop
		echo "--- Done!"	
		echo " "		
sleep 2		

### Checking if necessities are existing
		echo "::: Checking necessities"
		echo "---------------------------------------------------"
sleep 1		
		  if [ $RSYNC -eq 1 ]; then
		   echo "--- Rsync seems to be installed!"
sleep 1	   
		  else
		   echo "---- Rsync isn't installed and trying to install it..."
		   echo "---- Please standby!"
		   sudo apt-get update > /dev/null 2>&1
		   sudo apt-get install -y rsync > /dev/null 2>&1
		  fi
		echo "--- Done!"	
		echo " "
sleep 1

### Checking if backup folders are existing
		echo "::: Checking if backup folder exists"
		echo "---------------------------------------------------"
sleep 1		
		if [ -d $MOUNT_LOCATION/$MOUNT_DATA_FOLDER ] ; then	
		echo "--- $MOUNT_LOCATION/$MOUNT_DATA_FOLDER exists"
sleep 1		
		else
		echo "--- $MOUNT_LOCATION/$MOUNT_DATA_FOLDER doesn't exist"
		echo "--- Trying to create $MOUNT_LOCATION/$MOUNT_DATA_FOLDER"
		mkdir $MOUNT_LOCATION/$MOUNT_DATA_FOLDER		
sleep 1		
		if [ -d $MOUNT_LOCATION/$MOUNT_DATA_FOLDER ] ; then
		   echo "--- $MOUNT_LOCATION/$MOUNT_DATA_FOLDER created!"
sleep 1		   
		  else
		   echo "---- Something went wrong when trying to create $MOUNT_LOCATION/$MOUNT_DATA_FOLDER..."
sleep 1		   
		exit	
		  fi 
		fi
		echo " "		  
sleep 1	 
		
### Check if data mount location is mounted		
		if mount | grep $DATA_MOUNT; then
		echo "--- $GREP_DATA_UUID Is mounted"
sleep 1
		else
			echo "--- $DATA_MOUNT Isn't mounted"
			echo "--- Trying to mount!"
sleep 1	
		  sudo mount $DATA_MOUNT $MOUNT_LOCATION/$MOUNT_DATA_FOLDER
		  if [ $? -eq 0 ]; then
		   echo "--- $DATA_MOUNT Mount success!"
sleep 1	   
		  else
		   echo "---- Something went wrong with the mount..."
sleep 1
		exit
		  fi		  
		fi
		echo "--- Done!"	
		echo " "		  
sleep 1	 
		
		
		
### Checking if /boot backup folders are existing
		echo "::: Checking if backup /boot folder exists"
		echo "---------------------------------------------------"
sleep 1		
		if [ -d $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot ] ; then	
		echo "--- $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot exists"
sleep 1		
		else
		echo "--- $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot doesn't exist"
		echo "--- Trying to create $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot"
		mkdir $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot		
sleep 1		
		if [ -d $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot ] ; then
		   echo "--- $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot created!"
sleep 1		   
		  else
		   echo "---- Something went wrong when trying to create $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot..."
sleep 1		   
		exit	
		  fi	  
		fi	
		echo " "			
sleep 1

		
### Check if backup /boot is mounted		
		if mount | grep $BOOT_MOUNT; then
		echo "--- $GREP_BOOT_UUID Is mounted"
sleep 1
		else
			echo "--- $BOOT_MOUNT Isn't mounted"
			echo "--- Trying to mount!"
sleep 1	
		  sudo mount $BOOT_MOUNT $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot
		  if [ $? -eq 0 ]; then
		   echo "--- $BOOT_MOUNT Mount success!"
sleep 1	   
		  else
		   echo "---- Something went wrong with the mount..."
sleep 1
		exit
		  fi	  
		fi		
		echo "--- Done!"
		echo " "		
sleep 1

### Rsyncing to backup location
		echo "::: Rsync in progress"
		echo "---------------------------------------------------"
		echo "--- Rsyncing /boot & /root to mounted backup location"
		echo "--- Please Standby"		
sleep 1
		sudo rsync -ax --delete --info=progress2 / /boot $MOUNT_LOCATION/$MOUNT_DATA_FOLDER
		#sudo rsync -ax --exclude-from $EXCLUDE_FILE --delete --info=progress2 / /boot $MOUNT_LOCATION/$MOUNT_DATA_FOLDER
		echo "--- Done!"
		echo " "
		
sleep 1

### Amending /boot/cmline.txt
		echo "::: Amending /boot/cmline.txt "
		echo "---------------------------------------------------"
		echo "--- Setting new /root location in backuped cmdline.txt"
		echo "--- Please Standby"
		GREP_CURRENT_ROOTFS=`sudo cat $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot/cmdline.txt | grep root | awk {'print $3'}`		
		sudo sed -i "s,$GREP_CURRENT_ROOTFS,root=PARTUUID=aee995c5-01," $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot/cmdline.txt
sleep 1
		echo "--- Done!"
		echo " "
### umount backup location
		echo "::: umount /boot & /root backup location "
		echo "---------------------------------------------------"
		echo "--- Unmounting"
		echo "--- Please Standby"		
		cd ..
		sudo umount $MOUNT_LOCATION/$MOUNT_DATA_FOLDER/boot 
		cd ..	
		#sudo umount $MOUNT_LOCATION/$MOUNT_DATA_FOLDER	
		echo "--- Done!"	
		echo " "		
sleep 1

### Starting Domoticz service
		echo "::: Starting Domoticz Service"
		echo "---------------------------------------------------"
sleep 1
		echo "--- Starting Domoticz Service"
		echo "--- Please standby!"
		sudo service domoticz.sh start
		echo "--- Done!"	
		echo " "		
sleep 3
### Last word
		echo "::: Incase of a emergency"
		echo "---------------------------------------------------"
		echo "> New /rootfs has been set to root=/dev/mmcblk0p2"
		echo "> In case you screwed up you only need to put your Rsynced sdcard in your Pi sdcard slot"
		echo "> And Reboot"
		echo "> Have a nice day, Bye!"
		echo " "		
exit

