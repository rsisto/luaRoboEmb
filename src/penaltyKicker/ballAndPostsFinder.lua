


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
			--print("x=" .. x .." y="..y.. " " ..r  .. " " ..g .." " .. b ) 
			local hue = rgb2hue(r,g,b)
			--Search for ball only in the lower third of the screen
			if y > (2*h)/3 and hueDiff(hue , colorRef.ball[1]) <= colorRef.ball[2] then
				histBall[x+1] = histBall[x+1] +1 
			end
			if hueDiff(hue , colorRef.post[1]) <= colorRef.post[2] then 
				histPosts[x+1] = histPosts[x+1] +1
			end 
		end
	end
	return histBall, histPosts
end

--prints histogram to console
function printHistogram(hist)
	local maxVal = 0
	for k,v in ipairs(hist) do
		if v > maxVal then
			maxVal = v
		end
	end
	for i=maxVal,1,-1 do
		for j=1,#hist do 
			if hist[j] >= i then
				io.write('*')
			else
				io.write(' ')
			end
		end
		io.write('\n')
	end
end

--generates an image with ball as red and posts as blue
function selectBallAndPosts(img,w,h,colorRef)
	hueimg = {}
	for i=0,w*h-1 do
		local r,g,b = img[i*3+1],img[i*3 +2] ,img[i*3 +3]
		--print(r .. " " .. g .. " " .. b )
		local hue = rgb2hue(r,g,b)
		local isBall = hueDiff(hue , colorRef.ball[1]) <= colorRef.ball[2]
		local isPost = hueDiff(hue , colorRef.post[1]) <= colorRef.post[2]
		
		if isBall  then
			hueimg[i*3] = 255
			hueimg[i*3 +1] =0
			hueimg[i*3 +2] =0
		elseif isPost then
			hueimg[i*3] = 0
			hueimg[i*3 +1] =0
			hueimg[i*3 +2] =255
		else
			hueimg[i*3] = 0
			hueimg[i*3 +1] =0
			hueimg[i*3 +2] =0
		end
	end
	return hueimg
end

--return ball position in percentage. 
--3 return cases:
-- ball found: ball_pos, distance
-- something similar found: nil, something_pos
-- nothing found: nil
function getBallPosition(histBall,threshold) 
	local x_min , x_max = nil
	local x_something =nil -- x of any position with histBall[i] > 0 
	local x_something_val =0
	for i=1,#histBall do
		--search for any clue of the ball
		if histBall[i]>x_something_val then 
			x_something = i 
			x_something_val = histBall[i]
		end
		
		--search for the ball
		if x_min == nil and histBall[i] >= threshold then
			x_min = i
		end
		if x_max == nil and histBall[#histBall-i+1] >= threshold then
			x_max = #histBall-i+1
		end
		
		--optimizations
		if x_min ~= nil and x_max ~= nil then
			break
		end
	end
	
	if x_min ~= nil then
		return (x_min+x_max)*100/(2*#histBall) , 500/((x_max - x_min)*100/#histBall)
	elseif x_something ~=nil then
		return nil , x_something*100/#histBall
	else
		return 
	end
end

--returns posts positions or nils
--3 return cases:
-- both posts found: left_post_pos, right_post_pos
-- One post found: post_pos
-- No post found: nil
function getPostsPositions(histPost,threshold) 
	local left_min , left_max , right_min , right_max = nil
	local inPost = false
	for i=1,#histPost do
		if histPost[i] >= threshold then
			if not inPost then
				inPost=true
				if left_min == nil then
					left_min = i
				else 
					right_min = i
				end
			end
		else
			if inPost then
				inPost=false
				if left_max == nil then
					left_max = i
				else 
					right_max = i
					break
				end
			end
		end	
	end
	if inPost then
		if left_max == nil then
			left_max = #histPost
		else
			right_max = #histPost
		end
	end
	
	if right_max ~= nil then
		return (left_max+left_min)*100/(2*#histPost) , (right_max+right_min)*100/(2*#histPost)
	elseif left_max ~=nil then
		return (left_max+left_min)*100/(2*#histPost)
	else
		return nil
	end
		
end


