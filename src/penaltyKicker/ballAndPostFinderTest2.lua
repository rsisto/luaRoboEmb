--reads images and prints the position of the balls

package.path = package.path .. ";../?.lua;./?.lua;../v4l/?.lua;../ax12/?.lua;"
package.cpath = package.cpath ..";../v4l/?.so"

require "ballAndPostsFinder"
require "v4l"
require "socket"
require "v4lCommon"

colorRef={
	--element={hue, hueThreshold, histogramThreshold}
	--hueThreshold
	ball = {22,5,4},
	post = {182,6,20}
}



for i=0,19 do
	local img,w,h = ppm2mem("image"..i..".ppm")
	local histBall , histPosts = getHistogramForBallAndPosts(img,w,h,colorRef)
	
	pos, pos_something = getBallPosition(histBall,colorRef.ball[3])
	if pos ~=nil then
		print("image"..i .. " pos: " ..pos )
	elseif pos_something ~=nil then
		print("image"..i .. " pos_something: " .. pos_something)
	else 
		print("image"..i .. " ball not found..." )
	end
	
end

