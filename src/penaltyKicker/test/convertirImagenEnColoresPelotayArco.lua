require "v4l"
require "socket"
require "v4lCommon"


colorRef={
	--element={hue, threshold}
	ball = {20,3},
	post = {182,6}
}



img,w,h = ppm2mem("image2.ppm")
hueimg = {}
for i=0,w*h-1 do
	local r,g,b = img[i*3+1],img[i*3 +2] ,img[i*3 +3]
	print(r .. " " .. g .. " " .. b )
	local hue = rgb2hue(r,g,b)
	local isBall = hueDiff(hue , colorRef.ball[1]) <= colorRef.ball[2]
	local isPost = hueDiff(hue , colorRef.post[1]) <= colorRef.post[2]
	
	if isBall  then
		hueimg[i*3] = 255
		hueimg[i*3 +1] =0
		hueimg[i*3 +2] =0
	elseif isPost then
		hueimg[i*3] = 0
		hueimg[i*3 +1] =255
		hueimg[i*3 +2] =0
	else
		hueimg[i*3] = 0
		hueimg[i*3 +1] =0
		hueimg[i*3 +2] =0
	end
end

saveimg(hueimg,w,h,"image2_ball.ppm")

--TODO: procesar
