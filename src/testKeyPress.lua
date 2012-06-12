--read char from /dev/tty0


local keyboard = assert(io.open('/dev/tty0', 'r'))

--key press codes
local LEFT_KEYPAD = 75
local RIGHT_KEYPAD = 77
local UP_KEYPAD = 72
local DOWN_KEYPAD = 80
local LEFT_KEYPAD_UP = 203
local RIGHT_KEYPAD_UP = 205
local UP_KEYPAD_UP = 200
local DOWN_KEYPAD_UP = 208

--status of key
local left = false
local right = false
local up = false
local down = false

--how much is max_speed is multiplied when the keys determine a diagonal move
local diagonal = 0.5

while 1 do
	local key = string.byte(keyboard:read(1))
	if key == LEFT_KEYPAD then left=true
	elseif key == LEFT_KEYPAD_UP then left=false
	elseif key == RIGHT_KEYPAD then right=true
	elseif key == RIGHT_KEYPAD_UP then right=false
	elseif key == UP_KEYPAD then up=true
	elseif key == UP_KEYPAD_UP then up=false
	elseif key == DOWN_KEYPAD then down=true
	elseif key == DOWN_KEYPAD_UP then down=false
	end
	
	if up and right then
		print('↗')
	elseif right and down then
		print('↘')
	elseif left and down then
		print('↙')
	elseif up and left then
		print('↖')
	elseif up then
		print('↑')
	elseif right then
		print('→')
	elseif down then
		print('↓')
	elseif left then
		print('←')
	else
		print('stop')
	end
	--TODO; enviar velocidades.
	
end

