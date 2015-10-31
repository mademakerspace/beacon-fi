_DELAY_LIST = 3000
_DELAY_BLINK = 250
_TIMER_BLINK = 0
_TIMER_LIST = 1
_PIN_LED = 4


wifi.setmode(wifi.STATION)


gpio.mode(_PIN_LED, gpio.OUTPUT)
gpio.write(_PIN_LED, gpio.LOW)





function listap(t)
  local foundFree = false
  print('running listap func')
  for k,v in pairs(t) do
	authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
    isFree = authmode
    temp_strength = tonumber(rssi)
    if (isFree=="0") then
      foundFree = true
      print('found an open network!')
      print('strength is')
      print(rssi)
      print(math.floor((temp_strength * temp_strength) / 5))
      print(k)
   
    end
  end
  if (foundFree) then    
  else
    print('didnt find jack shit')
  end
end


function repeatList()
  print('running repeatList func')
  wifi.sta.getap(listap)
end
tmr.alarm(_TIMER_LIST, _DELAY_LIST, 1, repeatList)


wifi.sta.getap(listap)
