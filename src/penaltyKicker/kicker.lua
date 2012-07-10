package.path = package.path .. ";../?.lua;./?.lua;../v4l/?.lua;../ax12/?.lua;"
package.cpath = package.cpath ..";../v4l/?.so"

require "v4l"
require "socket"
require "v4lCommon"
local carritoAPI = require "carrito"

local kicker ={
	robot = nil,
	-- all behaviours, first with heighest priority, then less important
	behaviours = {
		checkConditionsKick,
		checkConditionsAlign,
		checkConditionsLookForABall
	},
	actions = {
		kick,
		align,
		lookForABall
	}
}

function kicker:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end

function kicker:init()
	self.robot = carrito:new()
end

-- first/most basic behaviour
function kicker:lookForABall()
	--TODO
end

-- always true because is the most basic behaviour
function kicker:checkConditionsLookForABall(camaraImg)
	return true
end

-- second behaviour
function kicker:align()
	--TODO
end

function kicker:checkConditionsAlign(camaraImg)
	local takeControl = false
	-- TODO implementar seeTheBall 
	if seeTheBall then
		takeControl = true
	end
	return takeControl
end

-- third, most important behaviour
-- has the highest priority
function kicker:kick()
	--TODO
end

function kicker:checkConditionsKick(camaraImg)
	local takeControl = false
	-- TODO implementar seeTheBall y ballBetweenPosts
	if seeTheBall and ballBetweenPosts then
		takeControl = true
	end
	return takeControl
end


function kicker:takeDecision()
	camaraImg = getHist()
	-- we are passing the imige that we took and checking if there is a behaviour able to take control
	for k, v in pairs(self.behaviours) do
		if v(camaraImg) then
			self.actions[k]()
		end
	end	
end