require "v4l"
require "socket"
require "v4lCommon"


colorRef={
	--element={hue, threshold}
	ball = {20,3},
	post = {182,6}
}



local img,w,h = ppm2mem("image2.ppm")


--Returns the historgram for the ball and posts color
function getHistogramForBallAndPosts(img,w,h,colorRef)

	histBall={}
	histPosts = {}
	
	for x=0,w-1 do 
		histPosts[x+1] =0
		histBall[x+1] =0
		for y=0,h-1 do
			local i=y*w+x
			local r,g,b = img[i*3+1],img[i*3 +2] ,img[i*3 +3]
			print("x=" .. x .." y="..y.. " " ..r  .. " " ..g .." " .. b ) 
			local hue = rgb2hue(r,g,b)
			--Search for ball only in the lower third of the screen
			if y > (2*h)/3 and hueDiff(hue , colorRef.ball[1]) <= colorRef.ball[2] then
				histBall[x+1] = histBall[x+1] +1 
			end
			if hueDiff(hue , colorRef.post[1]) <= colorRef.post[2] then 
				histPost[x+1] = histPost[x+1] +1
			end 
		end
	end
	return histBall, histPosts
end

histBall = getHistogramForBallAndPosts(img,w,h,colorRef)

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
