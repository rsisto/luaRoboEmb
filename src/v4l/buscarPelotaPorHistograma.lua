require "v4l"
require "socket"
require "v4lCommon"


colorRef={
	--element={hue, threshold}
	ball = {20,3},
	post = {182,6}
}



img,w,h = ppm2mem("image2.ppm")

histBall={}

for x=0,w-1 do 
	histBall[x+1] =0
	for y=0,h-1 do
		local i=y*w+x
		local r,g,b = img[i*3+1],img[i*3 +2] ,img[i*3 +3]
		print("x=" .. x .." y="..y.. " " ..r  .. " " ..g .." " .. b ) 
		local hue = rgb2hue(r,g,b)
		local isBall = hueDiff(hue , colorRef.ball[1]) <= colorRef.ball[2]
		if isBall and x == 144 then
			print("rgb 144" ..r .." " .. g .. " " .. b .. " hue: " .. hue .. " y  " ..y)
			
		end
		if isBall then histBall[x+1] = histBall[x+1] +1 end
	end
	print("hball "..x .." " .. histBall[x+1])
end

xBall,maxHistBall = -1 , 0
for x=1,w do
	io.write(x.."_")
	for i=1,histBall[x] do
		io.write("*")
	end
	io.write("\n")
	if histBall[x] > maxHistBall then
		xBall = x
		maxHistBall = histBall[x]
	end
end
if xBall ~=-1 then
	ballPos = (xBall/w)*100
	print("pelota en " .. xBall .." "..ballPos .. "%	")
end
