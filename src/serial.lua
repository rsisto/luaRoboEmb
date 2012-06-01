
local serial ={ttyFile = "/dev/ttyUSB0" , 
	sendCommFile = nil, 
	receiveCommFile = nil,
	speed = 1000000,
	ttyParams='-parenb -parodd cs8 hupcl -cstopb cread -clocal -crtscts -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8 -opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0 -isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt -echoctl -echoke'
}


--Writes 
function serial:write (packet)
	self.sendComFile:write(packet)
	self.sendComFile:flush()	
end

function serial:read() 
	local fileString = ""
	--se leen los primeros 2 caracteres, tienen que ser 0xFF 0xFF
	local char = self.receiveComFile:read(1)
	if string.byte(char) == 0xFF then
		fileString = fileString .. char
		char = self.receiveComFile:read(1)
		if string.byte(char) == 0xFF then
			fileString = fileString .. char
			--leo 2 chars, el primero es el id, el otro el largo
			char = self.receiveComFile:read(2)
			fileString = fileString .. char
			char = self.receiveComFile:read(string.byte(char,2) )
			fileString = fileString .. char
			print("respuesta id: " ..  string.byte(fileString,3) .. " error: " .. string.byte(fileString,5) )
		end		
	end
	
	return fileString
end


function serial:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  
  --inicialización específica
  o:init()
  
  return o
end

function serial:init()
	if self.sendComFile == nil  then 
		--configurar puerto serial
		local initSerialportString ='stty -F ' .. self.ttyFile .. ' ' .. self.speed .. ' ' .. self.ttyParams
		print("configurando tty: " .. initSerialportString)
		os.execute(initSerialportString)

		--inicializar archivos para envío y recepción.
		self.sendComFile = io.open(self.ttyFile, 'w')
		self.receiveComFile = io.open(self.ttyFile, 'r')
		self.receiveComFile:flush()
	end
end

return serial
