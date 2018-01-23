#!/bin/bash

#######################################################################################################################################################	

### reboot_clean_up.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 17-04-2017
### Script to check for unused files at reboot and remove them

#######################################################################################################################################################	

### BACKUP SCRIPT PARAMETERS
    DOMO_IP="127.0.0.1"      						# Domoticz IP
    DOMO_PORT="8080"         					    # Domoticz port
    DOMO_SCRIPT_DIR="/home/pi/domoticz/scripts"		# Domoticz scripts folder
### END OF USER CONFIGURABLE PARAMETERS

### Which unwanted files to remove before backing up
	file1="lua/script_device_demo.lua"
	file2="lua/script_time_demo.lua"
	file3="lua_parsers/example.lua"
	file4="lua_parsers/example_json.lua"
	file5="lua_parsers/example_owm.lua"
	file6="lua_parsers/example_xml.lua"	
	file7="python/googlepubsub.py"
	file8="python/script_device_PIRsmarter.py"	
	file9="buienradar_rain_example.pl"
	file10="readme.txt"	
	file11="python/eth_device_online.py"	
	file12="python/bt_device_online.py"		
	file13="lua/JSON.lua"		
	file14="/home/pi/domoticz/plugins/AwoxSMP/plugin.py"
	file15="/home/pi/domoticz/scripts/dzVents/dzVents_settings_example.lua"	
	
		echo "--- Removing Domoticz demo script files"
		if [ -f $DOMO_SCRIPT_DIR/$file1 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file1
		fi
		
		if [ -f $DOMO_SCRIPT_DIR/$file2 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file2
		fi
		
		if [ -f $DOMO_SCRIPT_DIR/$file3 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file3
		fi
		
		if [ -f $DOMO_SCRIPT_DIR/$file4 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file4
		fi
		
		if [ -f $DOMO_SCRIPT_DIR/$file5 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file5
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file6 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file6
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file7 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file7
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file8 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file8
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file9 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file9
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file10 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file10
		fi
		
		if [ -f $DOMO_SCRIPT_DIR/$file11 ] ; then
		rm -f $DOMO_SCRIPT_DIR/python/eth_device_online.py_*		
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file12 ] ; then
		rm -f $DOMO_SCRIPT_DIR/python/bt_device_online.py_*		
		fi

		if [ -f $DOMO_SCRIPT_DIR/$file13 ] ; then		
		rm $DOMO_SCRIPT_DIR/$file13
		fi

		if [ -f $file14 ] ; then		
		rm -rf /home/pi/domoticz/plugins/AwoxSMP
		rm -rf /home/pi/domoticz/plugins/examples		
		fi

		if [ -f $file15 ] ; then		
		rm -rf /home/pi/domoticz/scripts/dzVents	
		fi		
sleep 1
### Shutdown HDMI - save 30ma
sudo /opt/vc/bin/tvservice -o
sleep 1
exit
