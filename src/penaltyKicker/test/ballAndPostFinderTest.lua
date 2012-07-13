--reads images and prints the histogram for each of them. Also, exports an image with the ball and post selected.

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

	local hueimg = selectBallAndPosts(img,w,h,colorRef)
	saveimg(hueimg,w,h,"image"..i.."select.ppm")
	print("image "..i)
	print("ball_hist "..i)
	printHistogram(histBall)
	print("posts_hist "..i)
	printHistogram(histPosts)
end

