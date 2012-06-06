
local carritoAPI = require("carrito")
local carrito = carritoAPI:new()
print("adelante")
carrito:forward(700)
os.execute("sleep 2")
print("atras")
carrito:backward(700)
os.execute("sleep 2")
print("izquierda")
carrito:left(700)
os.execute("sleep 2")
print("derecha")
carrito:right(700)
os.execute("sleep 2")

carrito:forward(0)
	
