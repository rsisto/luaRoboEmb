--low level ax12 api
--manages only basic set of ax12 instructions

local serial = require("serial")

--Atributos
local ax12 ={
	ttyFile = "/dev/ttyUSB0",
	serial = nil
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


--Inicialización
function ax12:init()
	if self.serial == nil  then 
		--configurar librería serial
		self.serial = serial:new({ttyFile = self.ttyFile})
		self.serial:init()
	end
end


----------- AX12 Packet level methods -----------

function ax12:generarChecksum(paquete)
	local checksum = 0
	for i,v in ipairs(paquete) do
		checksum = checksum + v
	end
	return 255 - (math.fmod(checksum, 256))
end

function ax12:generarPaqueteAX12(paqueteEspecifico)
	local packageStart = {0xFF,0xFF} -- 0xff 0xff inicio de paquete
	local checksum = self:generarChecksum(paqueteEspecifico)
	table.insert(paqueteEspecifico,checksum)
	
	local tempPaquete = ''
	for i,v in ipairs(packageStart) do
		tempPaquete = tempPaquete..string.char(v)	
	end
	for i,v in ipairs(paqueteEspecifico) do
		tempPaquete = tempPaquete..string.char(v)	
	end
	return tempPaquete
end

function ax12:readAx12Packet()
	local fileString = ""
	--se leen los primeros 2 caracteres, tienen que ser 0xFF 0xFF
	local char = self.serial:read(1)
	if string.byte(char) == 0xFF then
		fileString = fileString .. char
		char = self.serial:read(1)
		if string.byte(char) == 0xFF then
			fileString = fileString .. char
			--leo 2 chars, el primero es el id, el otro el largo
			char = self.serial:read(2)
			fileString = fileString .. char
			char = self.serial:read(string.byte(char,2) )
			fileString = fileString .. char
			print("respuesta id: " ..  string.byte(fileString,3) .. " error: " .. string.byte(fileString,5) )
		end		
	end
	
	return fileString
end

----------- AX12 methods -----------

local BROADCAST_ID = 0xfe

local INSTRUCTION_PING = 0x01
local INSTRUCTION_READ_DATA = 0x02
local INSTRUCTION_WRITE_DATA = 0x03
local INSTRUCTION_REG_WRITE = 0x04
local INSTRUCTION_ACTION = 0x05
local INSTRUCTION_RESET = 0x06
local INSTRUCTION_SYNC_WRITE = 0x83

function ax12:ping(id)
	id = id or BROADCAST_ID
	local paquetePing = {id,0x02,INSTRUCTION_PING} 
	local paqueteGenerado= self:generarPaqueteAX12(paquetePing)
	self.serial:write(paqueteGenerado)
	if id ~= BROADCAST_ID then
		print("antes de leer")
		local val = self:readAx12Packet()
		print("despues de leer")
		return val
	end
end

--id, address, enteros entre 0 y 255
--data, tabla con valores a enviar
function ax12:writeData(id,address,data)
	id = id or BROADCAST_ID
	local paqueteWrite = {id,#data+3,INSTRUCTION_WRITE_DATA,address} 
	for _,v in ipairs(data) do
		table.insert(paqueteWrite,v)
	end
	printArray(paqueteWrite)
	local paqueteGenerado=generarPaqueteAX12(paqueteWrite)
	self.serial:write(paqueteGenerado)
	if id ~= BROADCAST_ID then
		local val = self:readAx12Packet()
		return val
	end
end

--id, startAddress, length enteros entre 0 y 255
function ax12:readData(id,startAddress,length)
	local paqueteRead = {id,4,INSTRUCTION_READ_DATA,startAddress,length} 
	local paqueteGenerado=self:generarPaqueteAX12(paqueteRead)
	self.serial:write(paqueteGenerado)
	local val = self:readAx12Packet()
	
	for i = 6, length+5 do
		print("byte " .. i .. " " .. string.byte(string.sub(val,i,i)))
	end
	return val
end

local function printArray(array) 
	for _,v in ipairs(array) do
		print(v)
	end
end




