lanes = require "lanes".configure()

local linda= lanes.linda()

local function loop(  )
	for i=1,10 do
		--print( "sending: "..i )
		linda:set( "x", i )    -- linda as upvalue
	end
end



function receiver()
	while true do
		print("recibiendo")
		local val= linda:get(  "x" )	     -- timeout in seconds 
		if val==nil then
			print( "es nil" )
			--break
		else
			print( "received: "..val )
			break
		end

	end
end

a= lanes.gen("*",loop)(  )
b= lanes.gen("*",receiver)()
