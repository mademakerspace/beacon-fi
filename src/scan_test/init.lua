-- set local variables
--local pin = 4            --> equivalent to GPIO2
--local LED_state = gpio.LOW
--local duration_of_blink = 200    --> 1000ms = 1 second
--local time_between_blinks = 1500
--timer index to call blink function = 0
--timer index inside blink function = 1

--timer index for scanning function = 2 
local time_between_scans = 1000    -- interval between scans (timer index 2)
local found_open = false
local hide_and_seek = false
local signal_strength = -90
local previous_signal_strength= -90
local strongest_AP = ''



-- Function which scans for available WiFi networks every xxx ms
function scan_for_wifi(t)
	signal_strength = -90  -- resets signal strength so that it doesn't get 'stuck' between scans i.e. always blinking fast after finding a strong signal
	strongest_AP = ''
	for ssid,v in pairs(t) do
		authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
		
		if (hide_and_seek = true) then                                --checks if already in hide_and_seek mide
			if (string.sub(ssid,1,string.len(9))=="LLL_cache") then 
				if (rssi > signal_strength) then
					signal_strength = rssi
					strongest_AP = ssid
				end
			end
		
		elseif (string.sub(ssid,1,string.len(9))=="LLL_cache") then    --if not in hide_and_seek, checks for the SSID starts with 'LLL_cache'
			hide_and_seek = true
			print('Hide-and-seek mode activated')
			signal_strength = rssi                   -- as this is the first time we find a hide_and_seek cache, we don't check if it's the strongest one
			strongest_AP = ssid
		
		elseif (found_open = true) then                                    --if SSID doesn't start with 'LLL_cache', checks for open networks
			if (authmode=="0") then 
				if (rssi > signal_strength) then
					signal_strength = rssi
					strongest_AP = ssid
				end
			else then               -- if it's the first time finding an open network, change found_open to true
				if (authmode=="0") then
				found_open = true
				print('Found open network') 
					signal_strength = rssi
					strongest_AP = ssid
			end
		else then                    -- if there aren't any open networks or hide_and_seek caches, reset variables
			found_open = false
			hide_and_seek = false
			signal_strength = -90
			print ('No open networks found')
		end		
	if (strongest_AP~='') then  --if it found something, we print the SSID and RSSI of the strongest signal (per scan)
  	io.write("Strongest AP:\t", strongest_AP, "\tSignal strength (dB):\t", signal_strength,"\tSmoothed value:\t", (signal_strength + previous_signal_strength) / 2,"\n")
  end
  previous_signal_strength = signal_strength
end

tmr.alarm(2, time_between_scans, 1, scan_for_WiFi)     

wifi.sta.getap(listap)
