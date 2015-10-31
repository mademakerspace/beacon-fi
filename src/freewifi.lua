_DELAY_LIST = 3000
_DELAY_BLINK = 250
_EXT_LED_PIN = 4
_TIME_BWTN_BLINKS_EXT = 1200
_TIMER_INDEX_SCAN = 1
_SIGNAL_STRENGTH_OPEN = -100
_SIGNAL_STRENGTH_TARGET = -100
_TIMER_INDEX_BLUE_LED = 4
_TIMER_INDEX_EXT_LED_ON = 5
_TIMER_INDEX_EXT_LED_OFF = 6

_IMPULSE_DURATION = 40
_BLUE_LED_INTERVAL = 10000

_TARGET_SSID = 'ESP_F38F24'

wifi.setmode(wifi.STATION)


gpio.mode(_EXT_LED_PIN, gpio.OUTPUT)
gpio.write(_EXT_LED_PIN, gpio.LOW)

function initImpulse()
	ledON()
end

function computeInterval(strength)
	inteval= math.floor((strength * strength) /5)
	return interval
end

function ledON()
      gpio.write(_EXT_LED_PIN, gpio.HIGH)
      tmr.alarm(_TIMER_INDEX_EXT_LED_ON, _IMPULSE_DURATION, 0, ledOFF) 
end


function ledOFF()
  gpio.write(_EXT_LED_PIN, gpio.LOW)
  	inteval= math.floor((strength * strength) /5)
	print(interval)
  tmr.alarm(_TIMER_INDEX_EXT_LED_OFF, 1000, 0, ledON) 
end



function blueLED()
	print('.') 
end                                      


function listap(t)
  local foundTarget = false
 
  for k,v in pairs(t) do
	authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
    temp_strength = tonumber(rssi)
    if (k==_TARGET_SSID) then
      foundTarget = true
    end
  end
  if (foundTarget) then 
		print('Found target') 
		_SIGNAL_STRENGTH_TARGET =  tonumber(rssi)
		print(rssi) 
  end
end


function repeatList()
  wifi.sta.getap(listap)
end

tmr.alarm(_TIMER_INDEX_SCAN, _DELAY_LIST, 1, repeatList)
initImpulse()
tmr.alarm(_TIMER_INDEX_BLUE_LED, _BLUE_LED_INTERVAL, 1, blueLED) 
wifi.sta.getap(listap)
