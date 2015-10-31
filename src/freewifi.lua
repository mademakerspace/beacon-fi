_DELAY_LIST = 3000
_DELAY_BLINK = 250

_EXT_LED_PIN = 4
_TIME_BWTN_BLINKS_EXT = 1200


_SIGNAL_STRENGTH_OPEN = -100
_SIGNAL_STRENGTH_TARGET = -100

_TIMER_INDEX_SCAN = 1
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

function computeInterval(db)
	interval = math.floor((db * db) /5)
	return interval
end


function ledON()
      gpio.write(_EXT_LED_PIN, gpio.HIGH)
      tmr.alarm(_TIMER_INDEX_EXT_LED_ON, _IMPULSE_DURATION, 0, ledOFF) 
end


function ledOFF()
  gpio.write(_EXT_LED_PIN, gpio.LOW)
  nextDelay = computeInterval(_SIGNAL_STRENGTH_TARGET)
	print("nextDelay:" .. nextDelay)
  tmr.alarm(_TIMER_INDEX_EXT_LED_OFF, nextDelay, 0, ledON) 
end


function blueLED()
	print('.') 
end                                      


function listap(t)
  local foundTarget = false
  local targetStrength = -100
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
  end
end


function repeatList()
  wifi.sta.getap(listap)
end

tmr.alarm(_TIMER_INDEX_SCAN, _DELAY_LIST, 1, repeatList)
initImpulse()
tmr.alarm(_TIMER_INDEX_BLUE_LED, _BLUE_LED_INTERVAL, 1, blueLED) 
wifi.sta.getap(listap)
