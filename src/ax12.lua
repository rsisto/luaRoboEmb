
----------- utils -----------
-- agregar al array en el orden
function add(list, element)
    list[#list+1] = element
end


----------- TTY level methods -----------

function generarChecksum(paquete)
	local checksum = 0
	for i,v in ipairs(paquete) do
		checksum = checksum + v
	end
	return 255 - (math.fmod(checksum, 256))
end

function generarPaqueteAX12(paqueteEspecifico)
	local packageStart = {0xFF,0xFF} -- 0xff 0xff inicio de paquete
	local checksum = generarChecksum(paqueteEspecifico)
	add(paqueteEspecifico,checksum)
	
	local tempPaquete = ''
	for i,v in ipairs(packageStart) do
		tempPaquete = tempPaquete..string.char(v)	
	end
	for i,v in ipairs(paqueteEspecifico) do
		tempPaquete = tempPaquete..string.char(v)	
	end
	return tempPaquete
end

--Writes 'what' to 'where'
function writeToFile (where,what)
	if sendComFile == nil  then 
		sendComFile = io.open(where, 'w')
		receiveComFile = io.open(where, 'r')
		receiveComFile:flush()
	end
	sendComFile:write(what)
	sendComFile:flush()	
end

function readFromFile() 
	if receiveComFile==nil then
		receiveComFile = io.open(comPort, 'r')
	end
	local fileString = ""
	--se leen los primeros 2 caracteres, tienen que ser 0xFF 0xFF
	local char = receiveComFile:read(1)
	if string.byte(char) == 0xFF then
		fileString = fileString .. char
		char = receiveComFile:read(1)
		if string.byte(char) == 0xFF then
			fileString = fileString .. char
			--leo 2 chars, el primero es el id, el otro el largo
			char = receiveComFile:read(2)
			fileString = fileString .. char
			char = receiveComFile:read(string.byte(char,2) )
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

function ping(id)
	id = id or BROADCAST_ID
	local paquetePing = {id,0x02,INSTRUCTION_PING} 
	local paqueteGenerado=generarPaqueteAX12(paquetePing)
	writeToFile (comPort,paqueteGenerado)
	if id ~= BROADCAST_ID then
		print("antes de leer")
		local val = readFromFile()
		print("despues de leer")
		return val
	end
end

--id, address, enteros entre 0 y 255
--data, tabla con valores a enviar
function writeData(id,address,data)
	id = id or BROADCAST_ID
	local paqueteWrite = {id,#data+3,INSTRUCTION_WRITE_DATA,address} 
	for _,v in ipairs(data) do
		add(paqueteWrite,v)
	end
	printArray(paqueteWrite)
	local paqueteGenerado=generarPaqueteAX12(paqueteWrite)
	writeToFile (comPort,paqueteGenerado)
	if id ~= BROADCAST_ID then
		local val = readFromFile()
		return val
	end
end

--id, startAddress, length enteros entre 0 y 255
function readData(id,startAddress,length)
	local paqueteRead = {id,4,INSTRUCTION_READ_DATA,startAddress,length} 
	local paqueteGenerado=generarPaqueteAX12(paqueteRead)
	writeToFile (comPort,paqueteGenerado)
	local val = readFromFile()
	
	for i = 6, length+5 do
		print("byte " .. i .. " " .. string.byte(string.sub(val,i,i)))
	end
	return val
end

function printArray(array) 
	for _,v in ipairs(array) do
		print(v)
	end
end

----------- AX12 high level methods -----------



function prendeLed(id)
	id = id or BROADCAST_ID
	local paquetePrenderLed = {id,0x04,0x03,0x19,0x01} -- 0xFE = ID BROADCAST, 0x04 = LENGTH, 0x03 = ESCRIBIR
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


