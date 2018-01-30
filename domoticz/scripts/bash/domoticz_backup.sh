#!/bin/bash

###########################################################################################################################################	

### domoticz_backup.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 1-30-2017
### Script to backup up Domoticz database, lua, bash, python script, just incase something goes wrong

# Additional you can install a dropbox uploader so this script can upload your backups to Dropbox as a offside backup
# It aint mandatory, its just a extra service
# Script is looking for it and skips the uploading if you didn't want to use Dropbox
# Installing Dropbox_Uploader is very easy.
# Download dropbox_uploader.sh, install it and your done
# More information here: https://github.com/andreafabrizi/Dropbox-Uploader
	
###########################################################################################################################################
### BEGINNING OF USER CONFIGURABLE PARAMETERS
###########################################################################################################################################
 
### BACKUP SCRIPT PARAMETERS
    DOMO_IP="127.0.0.1"      																	# Domoticz IP
    DOMO_PORT="8080"         																	# Domoticz port
    HOME_DIR="/home/pi"																			# Home folder	
	MOUNT="/mnt/storage"																		# Mount	
	MOUNT_MAX_USAGE="75" 																		# Max percentage for backup disk space usage	
    DOMO_DIR="/home/pi/domoticz"																# Domoticz folder
    DOMO_SCRIPTS_FOLDER="/home/pi/domoticz/scripts" 											# Domoticz Scripts folder	
    DOMO_AUTODATABASE_DIR="/home/pi/domoticz/backups"											# Domoticz Auto database backup folder	
	
### Retrieve current and updated Domoticz version number
	DOMO_JSON_CURRENT=`curl -s -X GET "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=getversion"`
	DOMO_CURRENT_VERSION=$(echo $DOMO_JSON_CURRENT |grep -Po '(?<="version" : "3.)[^"]*')

### Retrieve current Timestamp	
	TIMESTAMP=`/bin/date +%d-%m-%Y_%H-%M`
	TIMESTAMPFOLDER=`/bin/date +%d-%m-%Y_%H%M`	
	
### Domoticz Various Backup Folders	
	DOMO_BACKUP_HOME="domoticz_backups"				
	DOMO_BACKUP_FOLDER="domoticz-$DOMO_CURRENT_VERSION-$TIMESTAMPFOLDER" 						# Domoticz Backup Folder
	DOMO_BACKUP_ZIP="domoticz-$DOMO_CURRENT_VERSION-$TIMESTAMPFOLDER" 							# Domoticz Backup Zip File Name	
	DOMO_BACKUP_BASH_FOLDER="bash" 																# Domoticz bash Backup Folder
	DOMO_BACKUP_BASHPROFILE_FOLDER="bash_profile"												# Domoticz bash_profile Backup Folder
	DOMO_BACKUP_CRON_FOLDER="crontab" 															# Domoticz crontab Backup Folder	
	DOMO_BACKUP_DB_FOLDER="database" 															# Domoticz database Backup Folder	
	DOMO_BACKUP_LUA_FOLDER="lua" 																# Domoticz lua Backup Folder
	DOMO_BACKUP_PYTHON_FOLDER="python" 															# Domoticz python Backup Folder
	DOMO_BACKUP_PYTHONPLUGINS_FOLDER="plugins" 													# Domoticz python plugin Backup Folder
	DOMO_BACKUP_SCRIPTS_FOLDER="scripts" 														# Domoticz scripts Backup Folder
	DOMO_BACKUP_SYSTEM_FOLDER="system"
	DOMO_BACKUP_ZWAVE_FOLDER="Config"	
	DOMO_BACKUP_UPDATE_FOLDER="update_backup" 													# Domoticz Update Backup Folder	
	DROPBOX_UPLOADER="/home/pi/domoticz/scripts/bash/dropbox_uploader.sh"                  		# Dropbox uploader if in use (script checks)
	
### Domoticz Various Folders
	DOMO_CRON_FOLDER="/var/spool/cron/crontabs/*"												# Raspberry crontabs Folder
	
### Which unwanted files to remove from the backup
	file1="lua/script_device_demo.lua"
	file2="lua/script_time_demo.lua"
	file3="python/googlepubsub.py"
	file4="python/script_device_PIRsmarter.py"
	file5="python/check_device_online.py"	
	file6="python/bt_device_online.py"
	file7="lua/JSON.lua"
	file8="python/domoticz.py"
	file9="python/reloader.py"
	file10="python/script_device_demo.py"
	file11="python/script_time_demo.py"	
	file12="plugins/AwoxSMP/plugin.py"	
	file13="plugins/examples/Pinger.py"
	file14="plugins/siewert_gsm/__pycache__/plugin.cpython-34.pyc"	
	file15="plugins/jerina_gsm/__pycache__/plugin.cpython-34.pyc"	
	file16="plugins/natalya_gsm/__pycache__/plugin.cpython-34.pyc"
	
###########################################################################################################################################
### END OF USER CONFIGURABLE PARAMETERS
###########################################################################################################################################

###########################################################################################################################################

### Do not edit anything below this line unless your knowing what to do!

###########################################################################################################################################

echo "
 ____                        _   _              ____             _                
|  _ \  ___  _ __ ___   ___ | |_(_) ___ ____   | __ )  __ _  ___| | ___   _ _ __  
| | | |/ _ \|  _   _ \ / _ \| __| |/ __|_  /   |  _ \ / _  |/ __| |/ / | | |  _ \ 
| |_| | (_) | | | | | | (_) | |_| | (__ / /    | |_) | (_| | (__|   <| |_| | |_) |
|____/ \___/|_| |_| |_|\___/ \__|_|\___/___|   |____/ \____|\___|_|\_\\____|  ___/
                                                                           |_|
"
sleep 2
### Check if location is mounted
		echo "::: Checking dependencies"
if [ -d $MOUNT ] ; then	
		echo "---------------------------------------------------"
		echo "--- $MOUNT is mounted"	
sleep 1
MOUNT_OUTPUT=`df -hT $MOUNT | grep / | awk {'print $6'}`
MOUNT_USED=$(echo $MOUNT_OUTPUT | awk {'print $1'} | /usr/bin/cut -d "%" -f 1)
if [ $MOUNT_USED -ge $MOUNT_MAX_USAGE ] ; then
		echo "--- $MOUNT is running out of space, already $MOUNT_OUTPUT used"
		echo "--- Backup script terminated!"		
		exit
else
		echo "--- $MOUNT has enough free space , only $MOUNT_OUTPUT used" 
fi
		echo "--- Done!"
		echo " "		
		sleep 2
### Check if folders are existing
		echo "::: Checking if backup folders are existing"	
		echo "---------------------------------------------------"		
if [ -d $MOUNT/$DOMO_BACKUP_HOME ] ; then		
		echo "--- $MOUNT/$DOMO_BACKUP_HOME folder exists"
else
		echo "--- $MOUNT/$DOMO_BACKUP_HOME created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME	
fi
sleep 1
#####		
if [ -d $MOUNT/$DOMO_BACKUP_HOME ] ; then		
		echo "--- $MOUNT/$DOMO_BACKUP_HOME folder exists"
else
		echo "--- $MOUNT/$DOMO_BACKUP_HOME created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME
fi
sleep 1
#####
if [ -d $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER ] ; then		
		echo "---------------------------------------------------"	
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER folder exists"
		echo "--- Please check if you didn't ran this script already"
		echo "--- Or remove the /$DOMO_BACKUP_FOLDER folder..."			
		echo " "
		exit 1		
else
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER	
fi			
sleep 1
#####
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_BASH_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_BASH_FOLDER
sleep 1
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_BASHPROFILE_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_BASHPROFILE_FOLDER
sleep 1		
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_CRON_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_CRON_FOLDER
sleep 1
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_DB_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_DB_FOLDER		
sleep 1
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_LUA_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_LUA_FOLDER
sleep 1
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_PYTHON_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_PYTHON_FOLDER
sleep 1
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_PYTHONPLUGINS_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_PYTHONPLUGINS_FOLDER
sleep 1
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_ZWAVE_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_ZWAVE_FOLDER		
sleep 1
		echo "--- $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_SYSTEM_FOLDER created"
		mkdir $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_SYSTEM_FOLDER		
sleep 1
		echo "--- Done!"	
		sleep 2

### Backing up Domoticz scripts and database
		echo " "
		echo "::: Backing up Domoticz"
		echo "---------------------------------------------------"	
sleep 1		
		echo "--- Backing up bash scripts"
		cp -R $DOMO_SCRIPTS_FOLDER/bash/* $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_BASH_FOLDER		
sleep 1
		echo "--- Backing up .bash_profile"
		cp -R $HOME_DIR/.bash_profile $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_BASHPROFILE_FOLDER/.bash_profile	
sleep 1
		echo "--- Backing up crontab"
		cp -R $DOMO_CRON_FOLDER $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_CRON_FOLDER
sleep 1
		echo "--- Backing up database"
		/usr/bin/curl -s http://$DOMO_IP:$DOMO_PORT/backupdatabase.php > $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_DB_FOLDER/domoticz.db
sleep 1
		echo "--- Backing up lua scripts"
		cp -R $DOMO_SCRIPTS_FOLDER/lua/* $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_LUA_FOLDER
sleep 1
		echo "--- Backing up python scripts"
		cp -R $DOMO_SCRIPTS_FOLDER/python/* $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_PYTHON_FOLDER
sleep 1
		echo "--- Backing up python plugin scripts"
		cp -R $DOMO_DIR/plugins/* $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_PYTHONPLUGINS_FOLDER
sleep 1
		echo "--- Backing up Z-Wave Config folder"
		cp -R $DOMO_DIR/Config/* $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_ZWAVE_FOLDER		
sleep 1
		echo "--- Backing up domoticz system file"
		cp -R $DOMO_DIR/domoticz $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$DOMO_BACKUP_SYSTEM_FOLDER/domoticz		
sleep 1
		echo "--- Done!"	
		sleep 2

### Cleaning unused/unwanted file
		echo " "
		echo "::: Garbage cleaning"
		echo "---------------------------------------------------"
sleep 1		
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file1 ] ; then
		echo "--- Removed $file1"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file1
		else
		echo "--- $file1 doesn't exist or already removed!"
		fi
sleep 1		
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file2 ] ; then
		echo "--- Removed $file2"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file2
		else
		echo "--- $file2 doesn't exist or already removed!"		
		fi
sleep 1
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file3 ] ; then
		echo "--- Removed $file3"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file3
		else
		echo "--- $file3 doesn't exist or already removed!"
		fi
sleep 1	
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file4 ] ; then
		echo "--- Removed $file4"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file4
		else
		echo "--- $file4 doesn't exist or already removed!"
		fi
sleep 1	
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file5 ] ; then
		echo "--- Removed $file5"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file5
		else
		echo "--- $file5 doesn't exist or already removed!"
		fi
sleep 1	
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file6 ] ; then
		echo "--- Removed $file6"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file6
		else
		echo "--- $file6 doesn't exist or already removed!"
		fi
sleep 1	
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file7 ] ; then
		echo "--- Removed $file7"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file7
		else
		echo "--- $file7 doesn't exist or already removed!"
		fi
sleep 1	
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file8 ] ; then
		echo "--- Removed $file8"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file8
		else
		echo "--- $file8 doesn't exist or already removed!"
		fi		
sleep 1
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file9 ] ; then
		echo "--- Removed $file9"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file9
		else
		echo "--- $file9 doesn't exist or already removed!"		
		fi
sleep 1
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file10 ] ; then
		echo "--- Removed $file10"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file10
		else
		echo "--- $file10 doesn't exist or already removed!"
		fi
sleep 1	
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file11 ] ; then
		echo "--- Removed $file11"		
		rm $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file11
		else
		echo "--- $file11 doesn't exist or already removed!"
		fi
sleep 1
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file12 ] ; then
		echo "--- Removed $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/plugins/AwoxSMP folder"		
		rm -rf $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/plugins/AwoxSMP
		else
		echo "--- Folder $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/plugins/AwoxSMP doesn't exist or already removed!"
		fi
sleep 1
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file13 ] ; then
		echo "--- Removed $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/plugins/examples folder"		
		rm -rf $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/plugins/examples
		else
		echo "--- Folder $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/plugins/examples doesn't exist or already removed!"
		fi
sleep 1	
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file14 ] ; then
		echo "--- Removed $file14"		
		rm -rf $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/plugins/siewert_gsm/__pycache__
		else
		echo "--- $file14 doesn't exist or already removed!"
		fi
sleep 1	
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file15 ] ; then
		echo "--- Removed $file15"		
		rm -rf $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/plugins/jerina_gsm/__pycache__
		else
		echo "--- $file15 doesn't exist or already removed!"
		fi
sleep 1	
		if [ -f $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/$file16 ] ; then
		echo "--- Removed $file16"		
		rm -rf $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER/plugins/natalya_gsm/__pycache__
		else
		echo "--- $file16 doesn't exist or already removed!"
		fi			
sleep 1

		echo "--- Done!"	
		sleep 2

### Cleaning unused/unwanted file
		echo " "
		echo "::: Zipping backup"
		echo "---------------------------------------------------"
		echo "--- Zipping Domoticz backup files"
		echo "--- Please standby..."
		cd $MOUNT/$DOMO_BACKUP_HOME
		tar pcfz $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_ZIP.tar.gz $DOMO_BACKUP_FOLDER/*
		cd ~
		rm -rf $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_FOLDER		
		echo "--- Done!"	
		sleep 2

		if [ -f $DROPBOX_UPLOADER ] ; then		
### Uploading backup to Dropbox
		echo " "
		echo "::: Dropbox"
		echo "---------------------------------------------------"
		echo "--- Uploading backup to Dropbox"
		echo "--- Please standby..."
		$DROPBOX_UPLOADER upload $MOUNT/$DOMO_BACKUP_HOME/$DOMO_BACKUP_ZIP.tar.gz /
		echo "--- Done!"
		else
		echo " "
		echo "::: Dropbox"
		echo "---------------------------------------------------"
		echo "--- Skipping uploading to Dropbox as it seems it ain't installed"
		echo "--- Skipped!"		
		sleep 2			
		fi
### Removing backups older then 31 days
		echo " "
		echo "::: Removing backups older then 31 days"
		echo "---------------------------------------------------"
		echo "--- Cleaning old backups packages"
		echo "--- Please standby..."
		find $MOUNT/$DOMO_BACKUP_HOME -name '*.gz' -mtime +31 -delete
		echo "--- Done!"	
		echo "--- If no errors occurred then your backup has been created successfully"		
		sleep 2		
else

		echo "---------------------------------------------------"	
		echo "--- Backup location isn't mounted"
		echo "--- Please mount your backup location"			
		echo " "
		exit 1
fi
