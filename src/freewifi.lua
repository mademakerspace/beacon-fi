--_DELAY_LIST delay between two AP lists
--_DELAY_BLINK blink delay if no free AP found
--_TIMER_BLINK id of blink alarm
--_TIMER_LIST id of list alarm
--_PIN_LED LED pin, nodemcu pin 4, ESP8266 pin GPIO2
-- values in ms for delays
_DELAY_LIST = 3000
_DELAY_BLINK = 2000
_TIMER_BLINK = 0
_TIMER_LIST = 1
_PIN_LED = 4
_SIGNAL_STRENGTH = 500
-- strength is a transformation of -dB to range between 100ms and 2000ms
_RAW_RSSI = 0

wifi.setmode(wifi.STATION) -- sets the ESP into station mode

gpio.mode(_PIN_LED, gpio.OUTPUT)
gpio.write(_PIN_LED, gpio.LOW)

ledState = false

function blinker()
  if (ledState==false) then
    ledState = true
    gpio.write(_PIN_LED, gpio.HIGH)        
  else
    ledState = false
    gpio.write(_PIN_LED, gpio.LOW)
  end
end

--tmr.alarm( _TIMER_BLINK, _DELAY_BLINK, 1, blinker )

function listap(t)
  local foundFree = false
  for ssid,v in pairs(t) do
    authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
    --print(ssid,authmode,rssi,bssid,channel)
    --isFree= authmode
    isFree=ssid
    _RAW_RSSI= rssi
    _SIGNAL_STRENGTH =  math.floor((rssi * rssi) / 5)
	_DELAY_BLINK = _SIGNAL_STRENGTH
    -- change ~= to == ; ~= is not  == is equal
    if (isFree=="made-wing") then
      foundFree = true
    end
  end
  if (foundFree) then  
    print('WiFi network detected!') 
    print(_DELAY_BLINK)
    tmr.stop(_TIMER_BLINK)
    --gpio.write(_PIN_LED, gpio.HIGH)
    tmr.alarm( _TIMER_BLINK, _SIGNAL_STRENGTH, 1, blinker )
  else
    print(':-( network not detected') 
  end
end


function repeatList()
  gpio.write(_PIN_LED, gpio.LOW)        
  ledState = false
  wifi.sta.getap(listap)
end
tmr.alarm(_TIMER_LIST, _DELAY_LIST, 1, repeatList)

wifi.sta.getap(listap)
