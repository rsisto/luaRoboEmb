
local carritoAPI = require("carrito")
local carrito = carritoAPI:new()

local speed = 700
local time = 1
function sleep(v)
	os.execute("sleep " .. v)
end

print("adelante")
carrito:forward(speed)
sleep(time)
print("atras")
carrito:backward(speed)
sleep(time)
print("izquierda")
carrito:left(speed)
sleep(time)
print("derecha")
carrito:right(speed)
sleep(time)

carrito:forward(0)
	
