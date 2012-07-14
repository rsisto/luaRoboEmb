--stops the carrito and prints the current voltage

package.path = package.path .. ";../?.lua;./?.lua;../v4l/?.lua;../ax12/?.lua;../subsumption/?.lua;"
package.cpath = package.cpath ..";../v4l/?.so"


local carritoAPI = require("carrito")
local carrito = carritoAPI:new()

local speed = 400
local time = 1


carrito:forward(speed)
print("Motor voltage: " .. carrito.motor_left:getCurrentVoltage())
	
