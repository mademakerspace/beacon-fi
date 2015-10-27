# beacon-fi
Software that runs on an ESP8266 (with nodeMCU firmware) which blinks in the presence of open WiFi networks

# Contribute

You need to install LUA 

Linux: 

```
curl -R -O http://www.lua.org/ftp/lua-5.3.1.tar.gz
tar zxf lua-5.3.1.tar.gz
cd lua-5.3.1
make linux test
```

MacOSx :

```
$ brew install lua
```

# Introduction
This project was inspired by a project by @kstevica: https://medium.com/@kstevica/how-to-build-an-open-wifi-finder-using-esp8266-and-two-coin-batteries-9c31eb6f9859
Another (more advanced) open WiFi detector which is in the same vein:
http://benlo.com/esp8266/esp8266Projects.html#hotspotfinder


# Lua pointers
One important feature of Lua is its Timer API:   
You can use up to 7 timers (index=0-6) which can execute a function once after a timeout of xxx ms (0), or repeating the function with an interval of xxx ms (1).

tmr.alarm(index, ms, type, callback) 
tmr.alarm([0-6], [0-100000], (0|1), function_to_execute)



http://esp8266.co.uk/tutorials/introduction-to-the-timer-api/ 

