package.path = package.path .. ";../?.lua;./?.lua;../v4l/?.lua;../ax12/?.lua;"
package.cpath = package.cpath ..";../v4l/?.so"

require "v4l"
require "socket"
require "v4lCommon"
local carritoAPI = require "carrito"



colorRef={
	--element={hue, threshold}
	ball = {20,3},
	post = {182,6}
}

camera = "/dev/video0"
dev = v4l.open(camera)
if dev < 0 then
  print("camera not found")
  os.exit(0)
end
w, h = v4l.widht(), v4l.height()
--local carrito = carritoAPI:new()

local speed = 500

function sleep(v)
	os.execute("sleep " .. v)
end

MIN_PIXELS = 5

while true do


	img = v4l.getframe() 

	histBall={}

	for x=0,w-1 do 
		histBall[x+1] =0
		for y=80,h-1 do
			local i=y*w+x
			local r,g,b = img[i*3+1],img[i*3 +2] ,img[i*3 +3]
			
			local hue = rgb2hue(r,g,b)
			local isBall = hueDiff(hue , colorRef.ball[1]) <= colorRef.ball[2]
			
			if isBall then histBall[x+1] = histBall[x+1] +1 end
		end
		
	end

	xBall,maxHistBall = -1 , 0
	for x=1,w do
		if histBall[x] > maxHistBall and histBall[x] > MIN_PIXELS then
			xBall = x
			maxHistBall = histBall[x]
		end
	end
	if xBall ~=-1 then
		ballPos = (xBall/w)*100
		--print("pelota en " .. xBall .." "..ballPos .. "%	")
		if ballPos < 30 then
			print("ir a la izquierda")
			--carrito:left(speed)
		elseif ballPos > 60 then
			print("ir a la derecha")
			--carrito:right(speed)
		else
			print("dalepalante")
			--carrito:forward(speed)
		end
		os.execute("sleep 0.2")
	else
		print("ir a la derecha (no encontré)")
		--carrito:right(speed)
	end
end
