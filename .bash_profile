#!/bin/bash

# File Location: /home/pi/

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
MODEL=`(tr -d '\0' </proc/device-tree/model)`
CPUTEMP=`vcgencmd measure_temp | /bin/grep "temp" | /usr/bin/cut -d "=" -f 2 | /usr/bin/cut -d " " -f 1`
CPUMHZ=$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq)

HDD1=`df -h | grep 'dev/root' | awk 	'{print $2,   " 	 "    $3,"	    "$4}'`
HDD2=`df -h | grep 'mnt/storage' | awk 	'{print $2," 	 " $3,"	    "$4}'`
MEM=`free -m | awk 'NR==2 { printf "%sM 	 %sM 	    %sM ",$2,$3,$4; }'`
SWAP=`free -m | awk 'NR==3 { printf "%sM 	 %sM 	    %sM ",$2,$3,$4; }'`

LANIP=`sudo hostname -I | awk {'print $1'}`
TUNIP=`sudo hostname -I | awk {'print $2'}`
WANIP=`wget -q -O - http://icanhazip.com/`

BTSERVICE=`sudo systemctl status bluetooth -l | grep Active | awk {'print $2'}`
BTSERVICERUNNING=`sudo systemctl status bluetooth -l | grep Active | awk {'print $3'} | /usr/bin/cut -d "(" -f 2 | /usr/bin/cut -d ")" -f 1`

CUPSSERVICE=`sudo systemctl status cups -l | grep Active | awk {'print $2'}`
CUPSSERVICERUNNING=`sudo systemctl status cups -l | grep Active | awk {'print $3'} | /usr/bin/cut -d "(" -f 2 | /usr/bin/cut -d ")" -f 1`

PIHOLEBLOCKING=`pihole status | grep Pi-hole | awk {'print $3, $4, $5'}`
PIHOLEDNS=`pihole status | grep DNS | awk {'print $2, $3, $4, $5'}`

DOMOSERVICE=`sudo systemctl status domoticz -l | grep Active | awk {'print $2'}`
DOMOSERVICERUNNING=`sudo systemctl status domoticz -l | grep Active | awk {'print $3'} | /usr/bin/cut -d "(" -f 2 | /usr/bin/cut -d ")" -f 1`
PIHOLECURRENTVERS=`cat /mnt/storage/logging/repo_updates/pihole_updates.txt | awk {'print $4'} | /usr/bin/cut -d "v" -f 2`
PIHOLELATESTVERS=`cat /mnt/storage/logging/repo_updates/pihole_updates.txt | awk {'print $6'} | /usr/bin/cut -d ")" -f 1 | /usr/bin/cut -d "v" -f 2`

ADMINLTECURRENTVERS=`cat /mnt/storage/logging/repo_updates/pihole_updates.txt | awk {'print $10'} | /usr/bin/cut -d "v" -f 2`
ADMINLTELATESTVERS=`cat /mnt/storage/logging/repo_updates/pihole_updates.txt | awk {'print $12'} | /usr/bin/cut -d ")" -f 1 | /usr/bin/cut -d "v" -f 2`

FTLCURRENTVERS=`cat /mnt/storage/logging/repo_updates/pihole_updates.txt | awk {'print $16'} | /usr/bin/cut -d "v" -f 2`
FTLLATESTVERS=`cat /mnt/storage/logging/repo_updates/pihole_updates.txt | awk {'print $18'} | /usr/bin/cut -d ")" -f 1 | /usr/bin/cut -d "v" -f 2`

DOMOSERVICEVERSION=`curl -s -X GET "http://127.0.0.1:8080/json.htm?type=command&param=getversion" | /bin/grep '"version" :' | awk {'print $3'} | /usr/bin/cut -d '"' -f 2 | /usr/bin/cut -d '"' -f 1`
DOMOSERVICEHASH=`curl -s -X GET "http://127.0.0.1:8080/json.htm?type=command&param=getversion" | /bin/grep "hash" | awk {'print $3'} | /usr/bin/cut -d '"' -f 2 | /usr/bin/cut -d '"' -f 1`
DOMOSERVICEBUILD=`curl -s -X GET "http://127.0.0.1:8080/json.htm?type=command&param=getversion" | /bin/grep "build_time" | awk {'print $3,$4'} | /usr/bin/cut -d '"' -f 2 | /usr/bin/cut -d '"' -f 1`

DOMOSERVICECHANNEL=`curl -s -X GET "http://127.0.0.1:8080/json.htm?type=command&param=getversion" |grep -Po '(?<=channel=)[^&]*'`
DOMOSERVICEUPTIME=`sudo systemctl status domoticz -l | grep Active | awk {'print $9, $10'}`

REPOUPDATESAVAIL=`cat /mnt/storage/logging/repo_updates/repo_updates.txt`
FIRMWAREUPDATESAVAIL=`cat /mnt/storage/logging/repo_updates/firmware_updates.txt`
DOMOUPDATESAVAIL=`cat /mnt/storage/logging/domo_updates/domo_updates.txt`
DOMOUPDATEFROM=`cat /mnt/storage/logging/domo_updates/domo_update_from.txt`
DOMOUPDATETO=`cat /mnt/storage/logging/domo_updates/domo_update_to.txt`

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
      (  : '~' :  )   $(tput setaf 2)                Welcome back, ${ME}!    		$(tput setaf 1)
       '~ .~~~. ~'    $(tput setaf 2)  						                        $(tput setaf 1)
           '~' $(tput sgr0)$(tput setaf 7)                                         
	$(tput setaf 2)HOME AUTOMATION$(tput sgr0)		
	Domoticz Version....: V${DOMOSERVICEVERSION} - ${DOMOSERVICECHANNEL}
	Domoticz Hash.......: ${DOMOSERVICEHASH} - ${DOMOSERVICEBUILD}
	Domoticz Uptime.....: ${DOMOSERVICE} for ${DOMOSERVICEUPTIME}
	
	$(tput setaf 2)RASPBERRY DATA$(tput sgr0)
	RPi Model...........: ${MODEL}
	OS Release..........: ${RELEASE}
	Kernel..............: ${KERNEL}
	
	$(tput setaf 2)SYSTEM DATA$(tput sgr0)
	System Uptime.......: Up for ${UPTIME}
	Load Averages.......: ${one}, ${five}, ${fifteen} (1, 5, 15 min)
	Processes...........: ${PSA} processes running of which ${PSU} are yours
	CPU Temp............: ${CPUTEMP} @ $(($CPUMHZ/1000)) Mhz
	
	$(tput setaf 2)STORAGE / MEMORY DATA$(tput sgr0)  Total:	 Used:      Free:
	Root................:  ${HDD1}
	Storage.............:  ${HDD2}	
	Memory..............:  ${MEM}
	Swap................:  ${SWAP}

	$(tput setaf 2)CONNECTIVITY$(tput sgr0)
	TUN IP..............: ${TUNIP}	
	LAN IP..............: ${LANIP}
	WAN IP..............: ${WANIP}
	
	$(tput setaf 2)SERVICES$(tput sgr0)
	Bluetooth...........: ${BTSERVICE} and ${BTSERVICERUNNING}
	Domoticz............: ${DOMOSERVICE} and ${DOMOSERVICERUNNING}
	Cups................: ${CUPSSERVICE} and ${CUPSSERVICERUNNING}	
	PiHole..............: ${PIHOLEBLOCKING} and ${PIHOLEDNS}

	$(tput setaf 2)UPDATES$(tput sgr0)
	Domoticz Updates....: $(tput setaf 1)${DOMOUPDATESAVAIL} $(tput sgr0)Domoticz update available ${DOMOUPDATEFROM} ${DOMOUPDATETO} $(tput sgr0)
	Repo Updates........: $(tput setaf 1)${REPOUPDATESAVAIL} $(tput sgr0)updates available
	Firmware Update.....: $(tput setaf 1)${FIRMWAREUPDATESAVAIL} $(tput sgr0)update available	
	Pi-hole version.....: $(tput setaf 2)${PIHOLECURRENTVERS} $(tput sgr0)- Latest: $(tput setaf 1)${PIHOLELATESTVERS} $(tput sgr0)
	AdminLTE version....: $(tput setaf 2)${ADMINLTECURRENTVERS} $(tput sgr0)- Latest: $(tput setaf 1)${ADMINLTELATESTVERS} $(tput sgr0)
	FTL version.........: $(tput setaf 2)${FTLCURRENTVERS} $(tput sgr0)- Latest: $(tput setaf 1)${FTLLATESTVERS} $(tput sgr0)$(tput sgr0)"