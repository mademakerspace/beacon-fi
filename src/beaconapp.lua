_DELAY_STARTUP = 3000 --Wait at startup 

_EXT_LED_PIN = 4 --The pin where the external LED is connected
_TIME_BWTN_BLINKS_EXT = 1200 --[ms] 

_DEFAULT_INITIAL_STRENGTH = -100 --[dB] 
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

_TARGET_SSID = 'ESP_F38F24' --SSID of the targer



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


function ledOFF()
  gpio.write(_EXT_LED_PIN, gpio.LOW)


  if(_SIGNAL_STRENGTH_TARGET>_SIGNAL_CUTOFF_STRENGTH) then
    nextDelay = computeInterval(_SIGNAL_STRENGTH_TARGET)
  else
    print("No targets in range")
    nextDelay = _DEFAULT_BLINKING_INTERVAL_EXT
  end

  print("nextDelay:" .. nextDelay)
  tmr.alarm(_TIMER_INDEX_EXT_LED_OFF, nextDelay, 0, ledON) 

end
-- END Blinking main loop 




--Simple trick to make the blue LED blink
function blueLED()
	print('.') 
end                                      


function listap(t)
  local foundTarget = false
  local targetStrength = _DEFAULT_INITIAL_STRENGTH
  for k,v in pairs(t) do
	authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
    temp_strength = tonumber(rssi)
    if (k==_TARGET_SSID) then
      foundTarget = true
      targetStrength = temp_strength
    end
  end
  if (foundTarget) then 
		_SIGNAL_STRENGTH_TARGET =  targetStrength
    print("targetStrength:" .. targetStrength)
  
  else
    _SIGNAL_STRENGTH_TARGET = _DEFAULT_INITIAL_STRENGTH
  end

end


function repeatList()
  wifi.sta.getap(listap)
end

-- Main Procedure 


print("Startup sequence initiated")

wifi.setmode(wifi.STATION) 
gpio.mode(_EXT_LED_PIN, gpio.OUTPUT) --Initialise external LED
gpio.write(_EXT_LED_PIN, gpio.LOW) --Turn off LED

print('Perform initial WiFi signal scan') 
wifi.sta.getap(listap)
print('Scheduling WiFi signal scanner every ' .. _TIMER_INDEX_SCAN ..' ms') 
tmr.alarm(_TIMER_INDEX_SCAN, _DELAY_STARTUP, 1, repeatList)
print('Initiating the external LED blinking') 
initImpulse()
print('Scheduling blue LED blinking every ' .. _BLUE_LED_INTERVAL ..' ms') 
tmr.alarm(_TIMER_INDEX_BLUE_LED, _BLUE_LED_INTERVAL, 1, blueLED) 