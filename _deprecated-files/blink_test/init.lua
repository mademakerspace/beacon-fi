-- set local variables
local pin = 4            --> equivalent to GPIO2
local LED_state = gpio.LOW
local time_between_blinks = 600    --> 1000ms = 1 second
minimum_signal_to_react = -65
signal_strength = -50
hide_and_seek = true
--timer index to call blink ON function = 5
--timer index inside blink OFF function = 6


-- Function which turns on LED then turns it off after (duration_of_blink) ms

-- Initialise the pin and turn it off to begin with
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.LOW)


function ledON()
      gpio.write(pin, gpio.HIGH)
      tmr.alarm(5, 20, 0, ledOFF) 
end


function ledOFF()
      gpio.write(pin, gpio.LOW)
      if signal_strength > minimum_signal_to_react then --if 'best' AP signal is strong enough, react & blink faster 
            time_between_blinks =  math.floor((signal_strength * signal_strength) / 5)  --transform -dB to milliseconds
      else  -- if signal is weaker than minimim_signal_to_react
            time_between_blinks = 10000 -- set time between blinks to 10 seconds
      tmr.alarm(6, time_between_blinks, 0, ledON) 
    end


function impulse()
		ledON ()    
	end

                                  

end

function blueLED()
      if hide_and_seek = true then  --checks if hide_and_seek mode is activated
            print('If I print this string of text, it will make the blue LED connected to TX light up! Dirty programmer tricks...')
      end
      tmr.alarm(4, 15000, 0, blueLED) -- calls itself every 15 seconds
end
blueLED() 

