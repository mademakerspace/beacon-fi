
node.compile("beaconapp.lua") 


function launchApp()
	dofile("beaconapp.lc")
end

tmr.alarm(3, 3000, 0, launchApp)     
