-- set local variables
local pin = 4            --> equivalent to GPIO2
local LED_state = gpio.LOW
local time_between_blinks = 600    --> 1000ms = 1 second
--timer index to call blink ON function = 5
--timer index inside blink OFF function = 6


-- Function which turns on LED then turns it off after (duration_of_blink) ms

-- Initialise the pin and turn it off to begin with
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.LOW)


function ledON ()
      gpio.write(pin, gpio.HIGH)
      tmr.alarm(5, 20, 0, ledOFF) 
    end


function ledOFF ()
      gpio.write(pin, gpio.LOW)
      tmr.alarm(6, time_between_blinks, 0, ledON) 
    end


ledON ()                                      
