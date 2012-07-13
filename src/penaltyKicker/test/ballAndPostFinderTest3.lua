--reads images and prints the position of the posts

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
	
	left, right = getPostsPositions(histPosts,colorRef.post[3])
	if right ~=nil then
		print("image"..i .. " left_post: " ..left .. " right: "..right )
	elseif left ~=nil then
		print("image"..i .. " left_post: " ..left )
	else 
		print("image"..i .. " posts not found..." )
	end
	
end

