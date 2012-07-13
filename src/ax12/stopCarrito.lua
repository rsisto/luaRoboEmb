--stops the carrito and prints the current voltage

local carritoAPI = require("carrito")
local carrito = carritoAPI:new()

local speed = 700
local time = 1


carrito:forward(0)
print("Motor voltage: " .. carrito.motor_left:getCurrentVoltage())
	
