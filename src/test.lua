require("ax12")

-- Defino las constantes para enviar motor AX12 en el puerto serial.
comPort = '/dev/ttyUSB0'
local speed = 1000000
local initSerialportString ='stty -F ' .. comPort .. ' ' .. speed .. ' ' .. '-parenb -parodd cs8 hupcl -cstopb cread -clocal -crtscts -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8 -opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0 -isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt -echoctl -echoke'
print("configurando tty: " .. initSerialportString)
os.execute(initSerialportString)


local id = 0x03

--Set continuous rotation
--writeData(id,0x06,{0x00,0x00,0x00,0x00})

--Frenar
writeData(id,0x20,{0x00,0x00})
--velocidad antihorario
--writeData(id,0x20,{0x5f,0x00})
--velocidad horario
--writeData(id,0x20,{0xFF,0x04})

--Girar al ángulo xx con velocidad xx
--writeData(id,0x1E,{0x00,0x02,0x00,0x02})

--leer velocidad actual
--readData(id,0x26,2)

while 1 do
	readData(id,0x24,2)
	os.execute("sleep 0.5")
end

print("termino")



