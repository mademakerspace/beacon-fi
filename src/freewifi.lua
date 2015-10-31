_DELAY_LIST = 3000
_DELAY_BLINK = 250
_EXT_LED_PIN = 4
_TIME_BWTN_BLINKS_EXT = 1200
_TIMER_INDEX_SCAN = 1

_TIMER_INDEX_BLUE_LED = 4
_TIMER_INDEX_EXT_LED_ON = 5
_TIMER_INDEX_EXT_LED_OFF = 6

_IMPULSE_DURATION = 40
_BLUE_LED_INTERVAL = 10000

wifi.setmode(wifi.STATION)


gpio.mode(_EXT_LED_PIN, gpio.OUTPUT)
gpio.write(_EXT_LED_PIN, gpio.LOW)

function ledON()
      gpio.write(_EXT_LED_PIN, gpio.HIGH)
      tmr.alarm(_TIMER_INDEX_EXT_LED_ON, _IMPULSE_DURATION, 0, ledOFF) 
end


function ledOFF()
  gpio.write(_EXT_LED_PIN, gpio.LOW)
  tmr.alarm(_TIMER_INDEX_EXT_LED_OFF, _TIME_BWTN_BLINKS_EXT, 0, ledON) 
end

function blueLED()
	print('If I print.') 
end                                      


function listap(t)
  local foundFree = false
 
  for k,v in pairs(t) do
	authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
    isFree = authmode
    temp_strength = tonumber(rssi)
    if (isFree=="0") then
      foundFree = true
    end
  end
  if (foundFree) then 
		a=1   
  end
end


function repeatList()
  wifi.sta.getap(listap)
end

tmr.alarm(_TIMER_INDEX_SCAN, _DELAY_LIST, 1, repeatList)
ledON()
tmr.alarm(_TIMER_INDEX_BLUE_LED, _BLUE_LED_INTERVAL, 1, blueLED) 
wifi.sta.getap(listap)
