#!/bin/bash

###########################################################################################################################################

### check_domo_service.sh
### @author	: Siewert Lameijer
### @since	: 29-11-2016
### @updated: 1-30-2017
### Simple script to check if Domoticz is still running, if not then restart Pi
### It's fired up by a cron job every 30min

###########################################################################################################################################

domoticz=`sudo service domoticz.sh status | grep Active | awk '{print $3}'`

if [[ $domoticz != "(running)" ]]
    then
                sudo service domoticz.sh restart
				sleep 15
fi
