-- set local variables
local pin = 4            --> equivalent to GPIO2
local LED_state = gpio.LOW
local duration_of_blink = 200    --> 1000ms = 1 second
local time_between_blinks = 1500
--timer index to call blink function = 0
--timer index inside blink function = 1


-- Function which turns on LED then turns it off after (duration_of_blink) ms
function blink_LED ()
    if LED_state == gpio.LOW then
        LED_state = gpio.HIGH
        tmr.alarm(1, duration_of_blink, 0, blink_LED) -- after LED is turned on, calls blink_LED function again in (duration_of_blink) ms to turn it off; runs once
        
    else
        LED_state = gpio.LOW
        tmr.stop(1)
    end

    gpio.write(pin, LED_state)
end


-- Initialise the pin
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, LED_state)


-- Create an interval
tmr.alarm(0, time_between_blinks, 1, blink_LED)     -- tmr.alarm(index, ms, type, callback)   http://esp8266.co.uk/tutorials/introduction-to-the-timer-api/   
									                -- calls blink_LED every (time_between_blinks)ms; repeats
