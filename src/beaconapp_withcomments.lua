_DELAY_STARTUP = 3000 --Wait at startup 

_EXT_LED_PIN = 4 --The pin where the external LED is connected

_DEFAULT_INITIAL_STRENGTH = -100 --[dB] lowest strength
_SIGNAL_STRENGTH_OPEN = _DEFAULT_INITIAL_STRENGTH --[dB] 
_SIGNAL_STRENGTH_TARGET = _DEFAULT_INITIAL_STRENGTH --[dB] 

_SIGNAL_CUTOFF_STRENGTH = -65 --[dB]Minimum signal strength that cause blinking to go faster

_IMPULSE_DURATION = 40  --[ms] Duration of an impulse of light
_BLUE_LED_INTERVAL = 6000  --[ms] Interval of blue LED blinking 

_DEFAULT_BLINKING_INTERVAL_EXT = 5000  --[ms] Default interval of external LED blinking when seeking

--Define the index of timers
_TIMER_INDEX_SCAN = 1
_TIMER_INDEX_BLUE_LED = 4
_TIMER_INDEX_EXT_LED_ON = 5
_TIMER_INDEX_EXT_LED_OFF = 6


_TARGET_SSID_STRING = 'ESP_' --SSID prefix to identify the cache-mode Access Points

_CACHE_MODE = false -- If set to false will seek the strongest open wifi. If set true will seek the target string in SSID (and blink blue)

--This function starts the impulse
function initImpulse()
  print("Starting the impulse")
	ledON()
end

function computeInterval(db)
	interval = math.floor((db * db) /5)
	return interval
end

-- START Blinking main loop 
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

  if(_CACHE_MODE) then  --Cache mode
    if(_SIGNAL_STRENGTH_TARGET>_SIGNAL_CUTOFF_STRENGTH) then --Only take into account strong-ish signals
      nextDelay = computeInterval(_SIGNAL_STRENGTH_TARGET)
    else
      print("No targets in range")
      nextDelay = _DEFAULT_BLINKING_INTERVAL_EXT
    end
  else --OpenWifiMode
     if(_SIGNAL_STRENGTH_OPEN>_DEFAULT_INITIAL_STRENGTH) then --Take into account any signal > default
      nextDelay = computeInterval(_SIGNAL_STRENGTH_OPEN)
     else
      print("No openwifi in range")
      nextDelay = _DEFAULT_BLINKING_INTERVAL_EXT
    end
  end

  print("cacheMode:".. tostring(_CACHE_MODE) .." ,nextDelay:" .. nextDelay)
  tmr.alarm(_TIMER_INDEX_EXT_LED_OFF, nextDelay, 0, ledON) 
end
-- END Blinking main loop


--Simple trick to make the blue LED blink
function blueLED()
	if _CACHE_MODE then
    print('.') 
  end
end                                      


function processAPlist(t)
  local foundSomeTarget = false
  local targetStrength = _DEFAULT_INITIAL_STRENGTH

  local foundSomeOpenNetwork = false
  local openStrength = _DEFAULT_INITIAL_STRENGTH

  for k,v in pairs(t) do
	authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
    
    --Check for target SSIDs to determine if cache mode and store the highest value
    if (containz(_TARGET_SSID_STRING,k)) then
      foundSomeTarget = true
      if (targetStrength <  tonumber(rssi)) then
        targetStrength = tonumber(rssi)
      end
    end

    --Check for OpenWifi networks and store the highest value
    if(foundSomeTarget==false) then --execute only if not in caching mode
      if (authmode=="0") then
        foundSomeOpenNetwork = true
        if (openStrength <  tonumber(rssi)) then
          openStrength = tonumber(rssi)
        end
      end
    end

  end --End of foor loop


  if (foundSomeTarget) then 
    _CACHE_MODE = true
		_SIGNAL_STRENGTH_TARGET =  targetStrength  --Update the strength variable for cacheMode
    print("targetStrength:" .. targetStrength)
  elseif (foundSomeOpenNetwork) then            --Update the strength variable for openWifiMode
    _SIGNAL_STRENGTH_OPEN =  openStrength
    print("openStrength:" .. openStrength)
  else 
    _SIGNAL_STRENGTH_TARGET = _DEFAULT_INITIAL_STRENGTH
  end

 end --End processAPlist function




function scanWifi()
  wifi.sta.getap(processAPlist)
end



-- Main Procedure 



print("Startup sequence initiated")

wifi.setmode(wifi.STATION) 
gpio.mode(_EXT_LED_PIN, gpio.OUTPUT) --Initialise external LED
gpio.write(_EXT_LED_PIN, gpio.LOW) --Turn off LED

print('Perform initial WiFi signal scan') 
wifi.sta.getap(processAPlist)
print('Scheduling WiFi signal scanner every ' .. _TIMER_INDEX_SCAN ..' ms') 
tmr.alarm(_TIMER_INDEX_SCAN, _DELAY_STARTUP, 1, scanWifi)
print('Initiating the external LED blinking') 
initImpulse()
print('Scheduling blue LED blinking every ' .. _BLUE_LED_INTERVAL ..' ms') 
tmr.alarm(_TIMER_INDEX_BLUE_LED, _BLUE_LED_INTERVAL, 1, blueLED) 

