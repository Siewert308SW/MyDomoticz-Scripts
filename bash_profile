#!/bin/bash

# File Location: /home/pi/
# Rename bash_profile to .bash_profile

let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02d:%02d:%02d" "$days" "$hours" "$mins" "$secs"`

let PSU=`ps U pi h | wc -l`
let PSA=`ps -A h | wc -l`

ME=$(whoami)

RELEASE=`/usr/bin/lsb_release -s -d  | grep Raspbian | awk {'print $1,$3,$4'}`
KERNEL=`uname -srm`
MODEL=`cat /proc/device-tree/model`
CPUTEMP=`vcgencmd measure_temp | /bin/grep "temp" | /usr/bin/cut -d "=" -f 2 | /usr/bin/cut -d " " -f 1`
CPUMHZ=$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq)

HDD1=`df -h | grep 'dev/root' | awk 	'{print $2,   " 	 "    $3,"	    "$4}'`
HDD2=`df -h | grep 'mnt/storage' | awk 	'{print $2," 	 " $3,"	    "$4}'`
HDD3=`df -h | grep 'mnt/backup' | awk 	'{print $2," 	 " $3,"	    "$4}'`
HDD4=`df -h | grep 'mnt/rsynced' | awk 	'{print $2," 	 " $3,"	    "$4}'`
MEM=`free -mo | awk 'NR==2 { printf "%sM 	 %sM 	    %sM ",$2,$3,$4; }'`

# WLANIP=`/sbin/ifconfig wlan0 | /bin/grep "inet addr" | /usr/bin/cut -d ":" -f 2 | /usr/bin/cut -d " " -f 1`
LANIP=`/sbin/ifconfig eth0 | /bin/grep "inet addr" | /usr/bin/cut -d ":" -f 2 | /usr/bin/cut -d " " -f 1`
WANIP=`wget -q -O - http://icanhazip.com/`

BTSERVICE=`sudo systemctl status bluetooth -l | grep Active | awk {'print $2'}`
BTSERVICERUNNING=`sudo systemctl status bluetooth -l | grep Active | awk {'print $3'} | /usr/bin/cut -d "(" -f 2 | /usr/bin/cut -d ")" -f 1`

UPSSERVICE=`sudo systemctl status picofssd -l | grep Active | awk {'print $2'}`
UPSSERVICERUNNING=`sudo systemctl status picofssd -l | grep Active | awk {'print $3'} | /usr/bin/cut -d "(" -f 2 | /usr/bin/cut -d ")" -f 1`

DOMOSERVICE=`sudo service domoticz.sh status | grep Active | awk {'print $2'}`
DOMOSERVICERUNNING=`sudo service domoticz.sh status | grep Active | awk {'print $3'} | /usr/bin/cut -d "(" -f 2 | /usr/bin/cut -d ")" -f 1`

DOMOSERVICEVERSION=`curl -s -X GET "http://127.0.0.1:8080/json.htm?type=command&param=getversion" | /bin/grep "version" | awk {'print $3'} | /usr/bin/cut -d '"' -f 2 | /usr/bin/cut -d '"' -f 1`
DOMOSERVICEHASH=`curl -s -X GET "http://127.0.0.1:8080/json.htm?type=command&param=getversion" | /bin/grep "hash" | awk {'print $3'} | /usr/bin/cut -d '"' -f 2 | /usr/bin/cut -d '"' -f 1`
DOMOSERVICEBUILD=`curl -s -X GET "http://127.0.0.1:8080/json.htm?type=command&param=getversion" | /bin/grep "build_time" | awk {'print $3,$4'} | /usr/bin/cut -d '"' -f 2 | /usr/bin/cut -d '"' -f 1`

DOMOSERVICECHANNEL=`curl -s -X GET "http://127.0.0.1:8080/json.htm?type=command&param=getversion" |grep -Po '(?<=channel=)[^&]*'`
DOMOSERVICEUPTIME=`sudo service domoticz.sh status | grep Active | awk {'print $9, $10'}`

REPOUPDATESAVAIL=`cat /mnt/storage/domoticz_scripts/logging/motd_repo_updates/repo_updates.txt`
RPIUPDATESAVAIL=`cat /mnt/storage/domoticz_scripts/logging/motd_repo_updates/rpi_updates.txt`
FIRMWAREUPDATESAVAIL=`cat /mnt/storage/domoticz_scripts/logging/motd_repo_updates/firmware_updates.txt`
DOMOUPDATESAVAIL=`cat /mnt/storage/domoticz_scripts/logging/motd_domo_updates/domo_updates.txt`
DOMOUPDATEFROM=`cat /mnt/storage/domoticz_scripts/logging/motd_domo_updates/domo_update_from.txt`
DOMOUPDATETO=`cat /mnt/storage/domoticz_scripts/logging/motd_domo_updates/domo_update_to.txt`

# get the load averages
read one five fifteen rest < /proc/loadavg

echo "$(tput setaf 2)
       .~~.   .~~.
      '. \ ' ' / .'$(tput setaf 1)													$(tput setaf 1)
      : .~.'~'.~. :   $(tput setaf 4)   ____                        _   _          	$(tput setaf 1)
      : .~.'~'.~. :   $(tput setaf 4)	|  _ \  ___  _ __ ___   ___ | |_(_) ___ ____$(tput setaf 1)
     ~ (   ) (   ) ~  $(tput setaf 4)  | | | |/ _ \|  _   _ \ / _ \| __| |/ __|_  /	$(tput setaf 1)
    ( : '~'.~.'~' : ) $(tput setaf 4)  | |_| | (_) | | | | | | (_) | |_| | (__ / / 	$(tput setaf 1)
     ~ .~ (   ) ~. ~  $(tput setaf 4)	|____/ \___/|_| |_| |_|\___/ \__|_|\___/___|$(tput setaf 1)
      (  : '~' :  )   $(tput setaf 2)          Welcome back to Domoticz, ${ME}!     $(tput setaf 1)
       '~ .~~~. ~'    $(tput setaf 2)  						                        $(tput setaf 1)
           '~' $(tput sgr0)$(tput setaf 7)                                         
	$(tput setaf 2)HOME AUTOMATION$(tput sgr0)
	RPi Model...........: ${MODEL}		
	Domoticz Version....: V${DOMOSERVICEVERSION} ${DOMOSERVICECHANNEL} - ${DOMOSERVICEHASH} (${DOMOSERVICEBUILD})
	Domoticz Uptime.....: ${DOMOSERVICE} for ${DOMOSERVICEUPTIME}
	
	$(tput setaf 2)SYSTEM DATA$(tput sgr0)
	OS Release..........: ${RELEASE}
	Kernel..............: ${KERNEL}
	System Uptime.......: Up for ${UPTIME}
	Load Averages.......: ${one}, ${five}, ${fifteen} (1, 5, 15 min)
	Processes...........: ${PSA} processes running of which ${PSU} are yours
	CPU Temp............: ${CPUTEMP} @ $(($CPUMHZ/1000)) Mhz
	
	$(tput setaf 2)STORAGE / MEMORY DATA$(tput sgr0)
			     Total:	 Used:      Free:
	Root................:  ${HDD1}
	Rsynced.............:  ${HDD4}	
	Storage.............:  ${HDD2}
	Backup..............:  ${HDD3}
	Memory..............:  ${MEM}
	
	$(tput setaf 2)SERVICES$(tput sgr0)						$(tput setaf 2)CONNECTIVITY$(tput sgr0)
	Bluetooth...........: ${BTSERVICE} and ${BTSERVICERUNNING}	|	WLAN IP.............: # ${WLANIP}
	UPS PIco HV3.0A.....: ${UPSSERVICE} and ${UPSSERVICERUNNING}	|	LAN IP..............: ${LANIP}	
	Domoticz............: ${DOMOSERVICE} and ${DOMOSERVICERUNNING} 	|	WAN IP..............: ${WANIP}
	
	$(tput setaf 2)UPDATES$(tput sgr0)
	Domoticz Updates....: $(tput setaf 1)${DOMOUPDATESAVAIL} $(tput sgr0)Domoticz update available ${DOMOUPDATEFROM} ${DOMOUPDATETO} $(tput sgr0)	
	Repo Updates........: $(tput setaf 1)${REPOUPDATESAVAIL} $(tput sgr0)Repository updates available
	Rpi Updates.........: $(tput setaf 1)${RPIUPDATESAVAIL} $(tput sgr0)Rpi update available
	Firmware Update.....: $(tput sgr0)${FIRMWAREUPDATESAVAIL} $(tput sgr0)"