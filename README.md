# beacon-fi
Software that runs on an ESP8266 (with nodeMCU firmware) which blinks in the presence of open WiFi networks

# Contribute

You may want to first install Lua if you want to test the code
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

Then you will likely want to install a loader to upload your Lua scripts to the ESP8266 through a USB-to-serial connection.

*WARNING: The ESP8266 operates at 3.3v and will not be happy if you use 5v (Arduino and other FTDI boards often operate at 5v)*

You can download one of these tools to help you interact with your ESP8266 (see output, send commands line by line, upload files, format, flash firmware, etc.)
LuaLoader (Only for Windows): http://benlo.com/esp8266/index.html#LuaLoader

ESPlorer (Windows, Linux, Solaris, Mac OSx): http://esp8266.ru/esplorer/

Or if you prefer something more lightweight (without a GUI), check out Luatool: https://github.com/4refr0nt/luatool

# Introduction
This project was inspired by a project by @kstevica: https://medium.com/@kstevica/how-to-build-an-open-wifi-finder-using-esp8266-and-two-coin-batteries-9c31eb6f9859
Another (more advanced) open WiFi detector which is in the same vein:
http://benlo.com/esp8266/esp8266Projects.html#hotspotfinder


# Lua tips
Lua is a light-weight high-level programming language designed for embedded environments. You can find a quick introduction about general Lua syntax here: http://esp8266.co.uk/tutorials/lua-basics/

One important feature of Lua is its Timer API:   
You can use up to 7 timers (index=0-6) which can each execute a function
a) once after a timeout of xxx ms (0)
b)repeating the function with an interval of xxx ms (1)
```
tmr.alarm(index, ms, type, callback) 
tmr.alarm([0-6], [0-100000], (0|1), function_to_execute)
```

http://esp8266.co.uk/tutorials/introduction-to-the-timer-api/ 

## Lua tools


* [LuaLoader](https://github.com/GeoNomad/LuaLoader/) (Win only ; GUI)
* [ESPlorer](http://esp8266.ru/esplorer/) (Win/Linux/Mac ; GUI  )
* [luatool](https://github.com/4refr0nt/luatool) (Win/Linux/Mac ; CLI)
* [esptool](https://github.com/tommie/esptool) (Win/Linux/Mac ; GUI)


