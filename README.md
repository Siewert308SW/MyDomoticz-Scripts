# MyDomoticz-Welcome:
Here you'll find my Domoticz scripts which keep my household up and running.<br />
I am not a coder so those script could be made cleaner but as long as they work I'll be happy with it.<br />
I share my scripts over here so that it can be a guide or maybe to get you new inspiration.<br />
<br />
# MyDomoticz-Hardware:
1x Raspi Pi 3 + RFXtrx433E for Domoticz<br /> 
1x Raspi Pi 3 for running Pi-Hole and do some logging data like gas and electricity as well as storing backups<br />
Both are stacked with a PIco hv3.0A Stack Plus<br />
<br />
3x Foscam FI9803P<br />
2x Youless Elec/Gas<br />
4x KD101 smoke detectors<br />
And a lot of KaKu/Coco devices<br />
<br />
Both my setups are running its /rootfs from a unpowered USB HDD<br />
<br />
# MyDomoticz-Scripts:
You'll notice that most of all my event scripts have a REPEAT / INTERVAL commandArray.<br />
As my current home automation system is based on KaKu/CoCo 433Mhz modules.<br />
Which are a one way system and there for not giving any feedback to Domoticz if the device is really ON or OFF<br />
By using a REPEAT / INTERVAL commandArray i try to overrule the possibility of a missed signal.<br />
It aint ideal but for now it suites me and works fine until i can/will switch to Zwave.<br />
<br />
You will also notice i don't use the coventional Lua scripting way.<br />
Meaning that normally all your event and timer scripts are situated in one folder (/lua) under Domoticz.<br />
Which is then checked by Domoticz and triggered if needed.<br />
I took a different path which started back in the Pi2 days and where Domoticz just started developing.<br />
And i never tried any other way as this worked for me.<br />
Maybe there are better or cleaner ways but for this works fine.<br />
<br />
The base is simple,<br />
Normally you have all your Lua scripts in /home/pi/domoticz/scripts/lua/<br />
All those scripts contained a commandArray = {} & return commandArray.<br />
Which can take a lot of CPU usage and resources if you have a lot of scripts.<br />
Also when running a lot the reaction time decreases.<br />
<br />
The base i use is simple, effective and maybe not the cleanest.<br />
I just run two scripts, script_device_main.lua and "script_time_main.lua"<br />
From those two files i call several hard coded lua files.<br />
I call a function libary, a file with devices who must/can trigger a event and a worker.lua to assign a trigger device to a specific lua event script.<br />
Those event scripts are located outside Domoticz and don't contain commandArray = {} & return commandArray.<br />
As it controlled by the main device script.<br />
<br />
The same counts for timer script with just one side note.<br />
As for where i need to assign specific triggers to the device scripts.<br />
I use a function to seek for timer scripts in my Domoticz setup and run if needed but without the need for a commandArray = {} & return commandArray <br />
<br />
This way it saved a lot of commandArray = {} & return commandArray and there for CPU Usage.<br />
Back in my Pi2 days i had a CPU Usage of 80/90% but after converting to this method it decreased to 10%<br />
And RAM resources decreased more then 80%.<br />
Although running Domoticz on a RPi3 i never stopped using this method.<br />
<br />
# MyDomoticz-Sidenote:
In general i won't provide any install guides and such.<br />
I assume you have some basic knowledge about Raspberry, Domoticz and scripting.<br />
Most Lua scripts contain a header or at every event i explains what is going on, <br />
if not, then... #oops ;-)<br />
<br />
# MyDomoticz-GitHub Repository:
This repository is reflecting my folder structure.<br />
Which contains my Lua, Bash, Python and other scripts.<br />
Some of those are my own and others found or used from other users.<br />
My script repository can be in handy for you to do some inspiration or guide.<br />
<br />
# MyDomoticz-Screenshots:

MOTD login screen:<br />
![alt text](screenshots/motd.png "motd")
<br />
Auto Weather Tweet:<br />
![alt text](screenshots/tweet.png "tweet")
