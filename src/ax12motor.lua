--AX12 high level methods

local ax12api = require("ax12")

--Atributos
local ax12motor ={
	ax12=nil
}

--Constructor
function ax12:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  
  --inicialización específica
  o:init()
  
  return o
end



--value=1 prende, value=0 apaga
function ax12motorsetLedValue(id,value)
	id = id or BROADCAST_ID
	local paquetePrenderLed = {id,0x04,0x03,0x19,value} -- 0xFE = ID BROADCAST, 0x04 = LENGTH, 0x03 = ESCRIBIR
	local paqueteGenerado=generarPaqueteAX12(paquetePrenderLed)
	writeToFile (comPort,paqueteGenerado)
end

function apagaLed(id)
	id = id or 0xfe
	local paqueteApagaLed = {id,0x04,0x03,0x19,0x00} 
	local paqueteGenerado=generarPaqueteAX12(paqueteApagaLed)
	writeToFile (comPort,paqueteGenerado)
end

function getId()
--mandamos mensaje de broadcast prguntando por el id
--se asume que solo un motor esta conectado
	local paqueteGetId= {0xFE,0x04,0x02,0x03,0x01} -- 0xFE = ID BROADCAST, 0x04 = LENGTH, 0x02 = LEER, 0x03 = ID, 0x01 = 1BYTE
	local paqueteGenerado=generarPaqueteAX12(paqueteGetId)
	writeToFile (comPort,paqueteGenerado)
	--TODO leer lo que volvio!

end


function setId(id)
--se asume que solo un motor esta conectado	
	local paqueteSetId= {0xFE,0x04,0x03,0x03,id} 
	local paqueteGenerado=generarPaqueteAX12(paqueteSetId)
	writeToFile (comPort,paqueteGenerado)
end

function getSpeed()

end

function setSpeed()

end
