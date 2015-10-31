wifi.setmode(wifi.STATION)

local time_between_scans = 3000    
local found_open = false
local hide_and_seek = false
local signal_strength = -100
local previous_signal_strength= -100

function listap(t)
     previous_signal_strength = signal_strength   
     temp_strongest_signal = -100 
     strongest_AP = ''      
     for k,v in pairs(t) do
          authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)") 
          rssi=tonumber(rssi)
          if hide_and_seek then                         
               if k=="ESP_F38F24" then      
                    if rssi > temp_strongest_signal then       
                         temp_strongest_signal = rssi                
                         strongest_AP = k
                    end
               end
          
          elseif k=="ESP_F38F24" then  
               hide_and_seek = true                               
               print('Hide-and-seek mode activated')
               temp_strongest_signal = rssi                      
               strongest_AP = k
          
          elseif found_open  then                        
               if authmode==0 then                           
                    if rssi > temp_strongest_signal then           
                         temp_strongest_signal = rssi               
                         strongest_AP = k
                    end
               end
               
          
          elseif authmode ~=0 then               
               if authmode==0 then          
               found_open = true            
               print('Found open network') 
                    temp_strongest_signal = rssi 
                    strongest_AP = k
               end
          else                 
               found_open = false
               print ('No open networks detected')
          end       
     end

end



function scan_WiFi()

     wifi.sta.getap(listap)
end
wifi.sta.getap(listap)
tmr.alarm(2, time_between_scans, 1, scan_WiFi)     
