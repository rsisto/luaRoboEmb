
local carritoAPI = require("carrito")
local carrito = carritoAPI:new()

local speed = 700
local time = 1
function sleep(v)
	os.execute("sleep " .. v)
end

local key = ''
while key ~= 't' do
	key = io.stdin:read(1)
	if key == 'a' then
		print("left")
		carrito:left(speed)
	end
	if key == 's' then
		print("back")
		carrito:backward(speed)
	end
	if key == 'd' then
		print("right")
		carrito:right(speed)
	end
	if key == 'w' then
		print("forward")
		carrito:forward(speed)
	end
	if key == 'q' then
		print("stop")
		carrito:forward(0)
	end
end
carrito:forward(0)

