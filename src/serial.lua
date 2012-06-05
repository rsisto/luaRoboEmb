--atributos
local serial ={ttyFile = "/dev/ttyUSB0" , 
	sendCommFile = nil, 
	receiveCommFile = nil,
	speed = 1000000,
	ttyParams='-parenb -parodd cs8 hupcl -cstopb cread -clocal -crtscts -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8 -opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0 -isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt -echoctl -echoke'
}

--Constructor
function serial:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  
  --inicialización específica
  o:init()
  
  return o
end

--init
function serial:init()
	if self.sendComFile == nil  then 
		--configurar puerto serial
		local initSerialportString ='stty -F ' .. self.ttyFile .. ' ' .. self.speed .. ' ' .. self.ttyParams
		print("configurando tty: " .. initSerialportString)
		os.execute(initSerialportString)

		--inicializar archivos para envío y recepción.
		self.sendComFile = assert(io.open(self.ttyFile, 'w'))
		self.receiveComFile = assert(io.open(self.ttyFile, 'r'))
		self.receiveComFile:flush()
	end
end

--Writes 
function serial:write (packet)
	self.sendComFile:write(packet)
	self.sendComFile:flush()	
end

function serial:read(param) 
	return self.receiveComFile:read(param)
end



return serial
