#!/bin/bash

#############################################################################################################################################

### reboot_clean_up.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 3-17-2018
### Script to check for unused files at reboot and remove them
### It's fired up by a cron at every reboot

#############################################################################################################################################

### BACKUP SCRIPT PARAMETERS
    DOMO_IP="127.0.0.1"      						# Domoticz IP
    DOMO_PORT="8080"         					    # Domoticz port
    DOMO_SCRIPT_DIR="/home/pi/domoticz/scripts"	# Domoticz scripts folder
### END OF USER CONFIGURABLE PARAMETERS

### Which unwanted files to remove before backing up
	file1="lua/script_device_demo.lua"
	file2="lua/script_time_demo.lua"
	file3="lua_parsers/example.lua"
	file4="lua_parsers/example_json.lua"
	file5="lua_parsers/example_owm.lua"
	file6="lua_parsers/example_xml.lua"
	file7="buienradar_rain_example.pl"
	file8="python/script_device_demo.py"
	file9="python/script_time_demo.py"
	##file10="lua/JSON.lua"	
	file11="/home/pi/domoticz/plugins/AwoxSMP/plugin.py"
	
		if [ -f $DOMO_SCRIPT_DIR/$file1 ] ; then		
		rm -rf $DOMO_SCRIPT_DIR/$file1
		fi
		
		if [ -f $DOMO_SCRIPT_DIR/$file2 ] ; then		
		rm -rf  $DOMO_SCRIPT_DIR/$file2
		fi
		
		if [ -f $DOMO_SCRIPT_DIR/$file3 ] ; then		
		rm -rf  $DOMO_SCRIPT_DIR/$file3
		fi
		
		if [ -f $DOMO_SCRIPT_DIR/$file4 ] ; then		
		rm -rf  $DOMO_SCRIPT_DIR/$file4
		fi
		
		if [ -f $DOMO_SCRIPT_DIR/$file5 ] ; then		
		rm -rf  $DOMO_SCRIPT_DIR/$file5
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file6 ] ; then		
		rm -rf  $DOMO_SCRIPT_DIR/$file6
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file7 ] ; then		
		rm -rf  $DOMO_SCRIPT_DIR/$file7
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file8 ] ; then		
		rm -rf  $DOMO_SCRIPT_DIR/$file8
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file9 ] ; then		
		rm -rf  $DOMO_SCRIPT_DIR/$file9
		fi

		##if [ -f $DOMO_SCRIPT_DIR/$file10 ] ; then		
		##rm -rf  $DOMO_SCRIPT_DIR/$file10
		##fi	

		if [ -f $file11 ] ; then		
		rm -rf /home/pi/domoticz/plugins/AwoxSMP
		rm -rf /home/pi/domoticz/plugins/examples		
		fi		