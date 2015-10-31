_DELAY_LIST = 3000
_DELAY_BLINK = 250
_TIMER_SCAN = 1
_PIN_LED = 4
_TIME_BWTN_BLINKS_EXT=1200

wifi.setmode(wifi.STATION)


gpio.mode(_PIN_LED, gpio.OUTPUT)
gpio.write(_PIN_LED, gpio.LOW)

function ledON()
      gpio.write(_PIN_LED, gpio.HIGH)
      tmr.alarm(5, 20, 0, ledOFF) 
end


function ledOFF()
  gpio.write(_PIN_LED, gpio.LOW)
  tmr.alarm(6, _TIME_BWTN_BLINKS_EXT, 0, ledON) 
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
tmr.alarm(_TIMER_SCAN, _DELAY_LIST, 1, repeatList)
ledON()
tmr.alarm(4, 10000, 1, blueLED) 
wifi.sta.getap(listap)
