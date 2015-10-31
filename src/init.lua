
node.compile("beaconapp.lua") 


function launchApp()
	dofile("beaconapp.lua")
end

tmr.alarm(3, 3000, 0, launchApp)     
