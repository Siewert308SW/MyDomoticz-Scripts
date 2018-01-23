# MyDomoticz-Welcome:
Here you'll find my Domoticz scripts which keeps my household up and running.<br />
I am not a coder so those script could be not the cleanest sollution but as long as they work i'm happy.<br />
I share my scripts over here so that it can be a inspiration or guide for you all.<br />
<br />

# MyDomoticz-Hardware:
RPi3 - PIco hv3.0A Plus / Domoticz Beta Custom 3.8XXX / RFXtrx433E / Aeotec Gen5<br /> 
RPi3 - PIco hv3.0A Plus / PiHole / Youless Elec and Gas<br /> 
FI9803P Cams<br /> 
KD101 detectors<br /> 
KaKu/Z-Wave stuff<br />
Both my setups are running its /rootfs from a unpowered USB HDD<br />
<br />

# MyDomoticz-Scripts:
You'll notice that most of all my event scripts have a ON/OFF REPEAT - INTERVAL commandArray.<br />
As my current home automation system is mostly based on KaKu/CoCo 433Mhz modules.<br />
Which are a one way system serving the AC protocol and there for not giving any feedback to Domoticz if the device is really ON or OFF<br />
By using a REPEAT / INTERVAL commandArray i try to overrule the possibility of a missed signal.<br /> 
It aint ideal but for now it suites me.<br />
Slowly converting to Z-Wave until then i send double commands to 433Mhz devices.<br />
<br />
You will also notice i don't use the coventional Lua scripting way.<br />
Meaning that normally all your event and timer scripts are situated in one folder (/lua) under Domoticz.<br />
Which is then checked by Domoticz and triggered if needed.<br />
I took a different path which started back in the Pi2 days and where Domoticz just started developing.<br />
And i never tried any other way as this worked for me.<br />
Maybe there are better or cleaner ways but for this works fine.<br />
<br />
The base is simple, normally you have all your Lua scripts in /home/pi/domoticz/scripts/lua/<br />
All those scripts contained a commandArray = {} & return commandArray.<br />
Which can take a lot of CPU usage and resources if you have a lot of scripts.<br />
Also when running a lot the reaction time decreases.<br />
<br />
The base is simple, effective and maybe not the cleanest way.<br />
I just run two scripts, "script_device_main.lua" and "script_time_main.lua"<br />
From those two files i call several hard coded lua files.<br />
Those event scripts are located outside Domoticz and don't contain commandArray = {} & return commandArray.<br />
As it controlled by the main device script.<br />
<br />
"script_device_main.lua" looks for devices who changed their status.<br />
If that device is defined in settings.lua then it may trigger a lua script.<br />
Meanwhile it calls a function libary, a file with functions which i use lua globally.<br />
<br />
"script_time_main.lua" looks for a string match.<br />
It looks for a string like script_time_name_10minutes.lua and if it finds a match then it may trigger that lua timer event.<br />
Meanwhile it calls a function libary, a file with functions which i use lua globally.<br />
<br />
This way it will saved a lot of commandArray = {} & return commandArray and there for CPU Usage.<br />
Back in my Pi2 days i had a CPU Usage of 80/90% but after converting to this method it decreased to 10%<br />
As for RAM resources, it decreased more then 80%.<br />
Although running i'm currently running Domoticz on a RPi3 i never stopped using this method.<br />
<br />

# MyDomoticz-Sidenote:
In general i won't provide any install guides and such.<br />
I assume you have some basic knowledge about Raspberry, Domoticz and scripting.<br />
if not, then... #oops ;-)<br />
<br />

# MyDomoticz-GitHub Repository:
This repository is reflecting my folder structure.<br />
Which contains my Lua, Bash, Python and other scripts.<br />
Some of those are my own and others found or borrowed from other users.<br />
My script repository can be in handy for you to do some inspiration or act as guide.<br />
<br />

# MyDomoticz-Screenshots:
MOTD login screen:<br />
![alt text](screenshots/motd.png "motd")
<br />
Auto Weather Tweet:<br />
![alt text](screenshots/tweet.png "tweet")
