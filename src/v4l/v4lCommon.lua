
function saveimg(img,w,h,fileName)
 local file = io.open(fileName , "w+")
 file:write("P3\n".. w .. " " .. h .."\n255\n") -- RGB IMAGE
 for i=1,#img do
    local p = img[i] .. "\n"  
    file:write(p)
  end
  file:close()
end


--read a ppm file to an array
function ppm2mem (fileName)
	local file = io.open(fileName, "r")
	file:read("*line") -- descarto P3
	local res = file:read("*line")
	local w = string.gsub(res,"(.*) (.*)","%1")
	local h = string.gsub(res,"(.*) (.*)","%2")
	local line = file:read("*line") -- descarto 255
	local img = {}
	
	
	for i=1,w*h*3 do
		pix = file:read("*line")
		table.insert(img,pix)
	end
	
	return img, w, h
end

--rounds a number
function round(num) 
	if num >= 0 then return math.floor(num+.5) 
	else return math.ceil(num-.5) end
end

--Convertst RGB to Hue
--input r,g,b [0,255], output hsi [0,360]
function rgb2hue (r,g,b)
	--http://en.wikipedia.org/wiki/HSL_and_HSV
	local alpha = (2*r - g - b)/2
	local beta = (math.sqrt(3)/2)*(g-b)
	local h = math.atan2(beta,alpha)
	if h<0 then
		h = h + 2*math.pi
	end
	h = round((h*360)/(math.pi*2))
	--local s = round(math.sqrt(math.pow(alpha,2)+math.pow(beta,2)))
	return h
end

--returns the difference between 2 hues
function hueDiff(h1,h2)
	local d1 = math.abs(h2-h1)
	local d2 = math.abs(360 - d1)
	return math.min(d1,d2)
end
