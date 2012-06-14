--read char from /dev/tty0
--Ejecutar con "sudo lua testKeyPressLanes.lua"



--key press codes
local ESCAPE = 1
local LEFT_KEYPAD = 75
local RIGHT_KEYPAD = 77
local UP_KEYPAD = 72
local DOWN_KEYPAD = 80
local LEFT_KEYPAD_UP = 203
local RIGHT_KEYPAD_UP = 205
local UP_KEYPAD_UP = 200
local DOWN_KEYPAD_UP = 208




--how much is max_speed is multiplied when the keys determine a diagonal move
local diagonal = 0.5

local lanes = require "lanes".configure()

local linda= lanes.linda()

function keypadRead()
	print("keypadRead start")
	local keyboard = io.open('/dev/tty0', 'r')
	--status of key
	local left = false
	local right = false
	local up = false
	local down = false
	local direction = 0
	linda:set("direction",0)
	while 1 do	
		--print("porleer" )
		local key = string.byte(keyboard:read(1))
		--print("leido "..key )
		if key == LEFT_KEYPAD then left=true
		elseif key == LEFT_KEYPAD_UP then left=false
		elseif key == RIGHT_KEYPAD then right=true
		elseif key == RIGHT_KEYPAD_UP then right=false
		elseif key == UP_KEYPAD then up=true
		elseif key == UP_KEYPAD_UP then up=false
		elseif key == DOWN_KEYPAD then down=true
		elseif key == DOWN_KEYPAD_UP then down=false
		elseif key == ESCAPE then break
		end
		if up and right then
			--print('↗')
			direction = 2
		elseif right and down then
			--print('↘')
			direction = 4
		elseif left and down then
			--print('↙')
			direction = 6
		elseif up and left then
			--print('↖')
			direction = 8
		elseif up then
			--print('↑')
			direction = 1
		elseif right then
			--print('→')
			direction = 3
		elseif down then
			--print('↓')
			direction = 5
		elseif left then
			--print('←')
			direction = 7
		else 
			direction = 0
			--print("stop")
		end
		--print("dir: " .. direction)
		linda:set("direction",direction)
	end
	--salir
	print("EXITING...")
	linda:set("direction",0)
	os.execute("sleep 1")
	os.exit()
end

function sendSpeeds()
	local carritoAPI = require("carrito")
	local carrito = carritoAPI:new()
	
	--inspección de motores
	local ax12motor = require("ax12motor")
	local m1 = ax12motor:new({motor_id=3})
	local m2 = ax12motor:new({motor_id=14})
	local volt1 = m1:getCurrentVoltage()
	local volt2 = m2:getCurrentVoltage()
	print("voltage motor 1: " .. volt1)
	print("voltage motor 2: ".. volt2)
	if(volt1 < 8 or volt2 <8) then
		print("Voltaje en motores muy bajo")
		os.exit()
	end
	
	local maxSpeed = 700
	local mediumSpeed = maxSpeed * 0.5
	
	local lastDirection = -1
	while 1 do
		local newDirection  = linda:get("direction")		
		if newDirection ~=nil then
			if newDirection ~= lastDirection then
				lastDirection = newDirection
				--mandar
				print("mando " .. newDirection)
				if newDirection == 0 then
					carrito:setVels(0,0)
				elseif newDirection == 1 then
					carrito:setVels(maxSpeed,maxSpeed)
				elseif newDirection == 2 then
					carrito:setVels(maxSpeed,mediumSpeed)
				elseif newDirection == 3 then
					carrito:setVels(maxSpeed,-maxSpeed)
				elseif newDirection == 4 then
					carrito:setVels(-maxSpeed,-mediumSpeed)
				elseif newDirection == 5 then
					carrito:setVels(-maxSpeed,-maxSpeed)
				elseif newDirection == 6 then
					carrito:setVels(-mediumSpeed,-maxSpeed)
				elseif newDirection == 7 then
					carrito:setVels(-maxSpeed,maxSpeed)
				elseif newDirection == 8 then
					carrito:setVels(mediumSpeed,maxSpeed)
				end
			end
		end
	end
end



f= lanes.gen( "*", keypadRead)()
f2= lanes.gen( "*", sendSpeeds)()







