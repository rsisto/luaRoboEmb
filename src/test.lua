require("ax12")

-- Defino las constantes para enviar motor AX12 en el puerto serial.




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



