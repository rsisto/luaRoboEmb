#!/usr/bin/env lua

require "v4l"
require "socket"

camera = #arg

if camera < 1 then
  camera = "/dev/video0"
else
  camera = arg[1]
end


function saveimg(img,num)
 file = io.open("image"..num..".ppm", "w+")
 file:write("P3\n".. w .. " " .. h .."\n255\n") -- RGB IMAGE
 for i=1,#img do
    local p = a[i] .. "\n"  
    file:write(p)
  end
  file:close()
end

function round(num) 
	if num >= 0 then return math.floor(num+.5) 
	else return math.ceil(num-.5) end
end

--input r,g,b [0,255], output hsi [0,255]
function rgb2hsi (r,g,b)
	--http://en.wikipedia.org/wiki/HSL_and_HSV
	local alpha = (2*r - g - b)/2
	local beta = (math.sqrt(3)/2)*(g-b)
	local h = math.atan2(beta,alpha)
	if h<0 then
		h = h + 2*math.pi
	end
	h = round((h*255)/(math.pi*2))
	local s = round(math.sqrt(math.pow(alpha,2)+math.pow(beta,2)))
	return h,s, 0
end

function saveImgHue(img)
	file = io.open("imagehue.ppm", "w+")
	file:write("P3\n".. w .. " " .. h .."\n255\n") -- RGB IMAGE
	for i=1,#img,3 do
		local h = rgb2hsi(a[i],a[i+1],a[i+2])
		local p = h .. "\n"  
		file:write(p)
		file:write(p)
		file:write(p)
	end
	file:close()
end

function hueDiff(h1,h2)
	local d1 = math.abs(h2-h1)
	local d2 = math.abs(256 - d1)
	return math.min(d1,d2)
end

function saveImgHueRange(img,hue,threshold)
	file = io.open("imagehueRange.ppm", "w+")
	file:write("P3\n".. w .. " " .. h .."\n255\n") -- RGB IMAGE
	for i=1,#img,3 do
		local h = rgb2hsi(a[i],a[i+1],a[i+2])
		local p0 = "0\n"
		local p = "0\n"
		if hueDiff(h,hue)<threshold then
			p = h .. "\n"  
		end
		file:write(p)
		file:write(p0)
		file:write(p0)
	end
	file:close()
end


dev = v4l.open(camera)

if dev < 0 then
  print("camera not found")
  os.exit(0)
end

w, h = v4l.widht(), v4l.height()

print(camera .. ": " ..w .. "x" .. h)

for i=0,100 do
   key = io.stdin:read(1)
   t1 = socket.gettime()
   --a = v4l.getframe() 
   a = v4l.getframe() 
   t2 = socket.gettime()
   tdiff = math.floor((t2 - t1)*1000) -- aprox time: 110ms (TODO: is it good enough?)
   print("captura: " .. tdiff .. " ms")
   saveimg(a,i)
   t3 = socket.gettime()
   tdiff = math.floor((t3 - t2)*1000) -- aprox time: 110ms (TODO: is it good enough?)
   print("guardar imagen: " .. tdiff .. " ms")
end



print("length: " .. #a) --3 elements per pixel, rgb
print("some pixels: " .. a[1] .. " ".. a[2] .. " ".. a[3] )

saveimg(a)
a = nil

dev = v4l.close(dev);

if dev == 0 then
  print("File descriptor closed: " .. dev)
end



