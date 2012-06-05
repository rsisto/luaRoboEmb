

--Atributos
local test ={a=10}

--Constructor
function test:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  
  return o
end


local function algo()
	print("algo")
end

function dos()
	algo()
end
