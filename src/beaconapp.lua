_DELAY_STARTUP = 3000 

_EXT_LED_PIN = 4

_DEFAULT_INITIAL_STRENGTH = -100
_SIGNAL_STRENGTH_OPEN = _DEFAULT_INITIAL_STRENGTH 
_SIGNAL_STRENGTH_TARGET = _DEFAULT_INITIAL_STRENGTH  

_SIGNAL_CUTOFF_STRENGTH = -65

_IMPULSE_DURATION = 40  
_BLUE_LED_INTERVAL = 6000  

_DEFAULT_BLINKING_INTERVAL_EXT = 5000 


_TIMER_INDEX_SCAN = 1
_TIMER_INDEX_BLUE_LED = 4
_TIMER_INDEX_EXT_LED_ON = 5
_TIMER_INDEX_EXT_LED_OFF = 6


_TARGET_SSID_STRING = 'ESP_' 

_CACHE_MODE = false 

function initImpulse()
  print("Starting the impulse")
	ledON()
end

function computeInterval(db)
	interval = math.floor(((db * db) / 2) + 15 * db + 130)
	return interval
end

function ledON()
      gpio.write(_EXT_LED_PIN, gpio.HIGH)
      tmr.alarm(_TIMER_INDEX_EXT_LED_ON, _IMPULSE_DURATION, 0, ledOFF) 
end

function containz(what,where)
  if string.find(where,what) then
    return true
  else 
    return false
  end
end



function ledOFF()
  gpio.write(_EXT_LED_PIN, gpio.LOW)

  if(_CACHE_MODE) then  
    if(_SIGNAL_STRENGTH_TARGET>_SIGNAL_CUTOFF_STRENGTH) then
      nextDelay = computeInterval(_SIGNAL_STRENGTH_TARGET)
    else
      print("No targets in range")
      nextDelay = _DEFAULT_BLINKING_INTERVAL_EXT
    end
  else 
     if(_SIGNAL_STRENGTH_OPEN>_DEFAULT_INITIAL_STRENGTH) then 
      nextDelay = computeInterval(_SIGNAL_STRENGTH_OPEN)
     else
      print("No openwifi in range")
      nextDelay = _DEFAULT_BLINKING_INTERVAL_EXT
    end
  end

  print("cacheMode:".. tostring(_CACHE_MODE) .." ,nextDelay:" .. nextDelay)
  tmr.alarm(_TIMER_INDEX_EXT_LED_OFF, nextDelay, 0, ledON) 
end


function blueLED()
	if _CACHE_MODE then
    print('.') 
  end
end                                      


function processAPlist(t)
  local foundSomeTarget = false
  local targetStrength = _DEFAULT_INITIAL_STRENGTH
  local targetSSID = ""

  local foundSomeOpenNetwork = false
  local openStrength = _DEFAULT_INITIAL_STRENGTH
  local openWifiSSID = ""

  for k,v in pairs(t) do
	authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
    
    if (containz(_TARGET_SSID_STRING,k)) then
      foundSomeTarget = true
      if (targetStrength <  tonumber(rssi)) then
        targetStrength = tonumber(rssi)
        targetSSID = k
      end
    end

    if(foundSomeTarget==false) then 
      if (authmode=="0") then
        foundSomeOpenNetwork = true
        if (openStrength <  tonumber(rssi)) then
          openStrength = tonumber(rssi)
          openWifiSSID = k
        end
      end
    end

  end 


  if (foundSomeTarget) then 
    _CACHE_MODE = true
		_SIGNAL_STRENGTH_TARGET =  targetStrength  
    print("SSID:" .. targetSSID ..", targetStrength:" .. targetStrength)
  elseif (foundSomeOpenNetwork) then            
    _SIGNAL_STRENGTH_OPEN =  openStrength
    print("SSID:" .. openWifiSSID ..", openStrength:" .. openStrength)
  else 
    _SIGNAL_STRENGTH_TARGET = _DEFAULT_INITIAL_STRENGTH
  end

 end 



function scanWifi()
  wifi.sta.getap(processAPlist)
end



print("Startup sequence initiated")

wifi.setmode(wifi.STATION) 
gpio.mode(_EXT_LED_PIN, gpio.OUTPUT) 
gpio.write(_EXT_LED_PIN, gpio.LOW) 

print('Perform initial WiFi signal scan') 
wifi.sta.getap(processAPlist)
print('Scheduling WiFi signal scanner every ' .. _TIMER_INDEX_SCAN ..' ms') 
tmr.alarm(_TIMER_INDEX_SCAN, _DELAY_STARTUP, 1, scanWifi)
print('Initiating the external LED blinking') 
initImpulse()
print('Scheduling blue LED blinking every ' .. _BLUE_LED_INTERVAL ..' ms') 
tmr.alarm(_TIMER_INDEX_BLUE_LED, _BLUE_LED_INTERVAL, 1, blueLED) 

