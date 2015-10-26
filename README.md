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

This project is based off a project by @kstevica: https://medium.com/@kstevica/how-to-build-an-open-wifi-finder-using-esp8266-and-two-coin-batteries-9c31eb6f9859
Another (more advanced) open WiFi detector which is in the same vein:
http://benlo.com/esp8266/esp8266Projects.html#hotspotfinder

