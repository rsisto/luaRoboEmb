
local motores = require("ax12motor")


--Atributos
local carrito ={
	motor_left=nil,
	motor_right=nil,
	motores_id={3,14}
}

carrito.debugprint = print --for debug
--carrito.debugprint = function() end  --do not print anything by default


--Constructor
function carrito:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  --inicialización específica
  o:init()
  
  return o
end

--Inicialización
function carrito:init()
	if self.motor_left == nil  then 
		--creo motores
		self.motor_left = motores:new({motor_id=self.motores_id[1]})
		self.motor_right = motores:new({motor_id=self.motores_id[2]})
		self.motor_left:initContinuousRotation()
		self.motor_right:initContinuousRotation()
	end	
end

function carrito:forward(speed)
	self.motor_left:setSpeed(speed)
	self.motor_right:setSpeed(-speed)
end
function carrito:backward(speed)
	self.motor_left:setSpeed(-speed)
	self.motor_right:setSpeed(speed)
end
function carrito:left(speed)
	self.motor_left:setSpeed(-speed)
	self.motor_right:setSpeed(-speed)
end
function carrito:right(speed)
	self.motor_left:setSpeed(speed)
	self.motor_right:setSpeed(speed)
end

function carrito:setVels(left,right)
	self.motor_left:setSpeed(left)
	self.motor_right:setSpeed(-right)
end

function carrito:prenderLuces(val)
	self.motor_left:setLedValue(val)
	self.motor_right:setLedValue(val)
end


return carrito
