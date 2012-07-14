--reads camera and prints the position of the balls

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


camera = "/dev/video1"
dev = v4l.open(camera)
w, h = v4l.widht(), v4l.height()

function sleep(v)
	os.execute("sleep " .. v)
end


while true do
	img = v4l.getframe() 
	local histBall , histPosts = getHistogramForBallAndPosts(img,w,h,colorRef)
	
	--[[ ball
	--]]
	pos, pos_something = getBallPosition(histBall,colorRef.ball[3])
	if pos ~=nil then
		print(" pos: " ..pos .. " dist: " ..pos_something )
	elseif pos_something ~=nil then
		print(" pos_something: " .. pos_something)
	else 
		print(" ball not found..." )
	end
	
	
	--[[ palos
	
	local post_left, post_right = getPostsPositions(histPosts,colorRef.post[3])
	if post_right ~=nil then
		print(" post_left: " ..post_left .. " post_right: " ..post_right )
	elseif post_left ~=nil then
		print(" post_left: " .. post_left)
	else 
		print(" posts not found..." )
	end
	--]]
end

