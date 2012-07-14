--Subsumption behavior. Finds a ball

local stopAtBallBehavior ={
	name = 'stopAtBallBehavior',
	sensorData = nil, --global sensor data
	robot = nil	, --robot control
	direction = 'cw', -- rotating direction ('cw','ccw')
	rotationSpeed = 400 -- rotation speed to search for ball
}

stopAtBallBehavior.debugprint = print --for debug
--behaviour.debugprint = function() end  --do not print anything by default

function stopAtBallBehavior:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end


function stopAtBallBehavior:init()
	
end

-- step inside a behaviour (it must make a little step and return quickly)
function stopAtBallBehavior:actionStep()
	
	self.robot:forward(0)
	
end

-- returns if this behaviour wants the control of the robot 
function stopAtBallBehavior:takeControl()
	--return true to the arbitrator if the conditions are met, false if not.
	--searching for ball
	if self.sensorData.ball ~= nil then
		return true
	end
end

-- This function is called by the arbitrator when this behaviour is suppresed
function stopAtBallBehavior:supress()
	--[[
	if self.direction == 'cw' then
		self.direction = 'ccw'
	else
		self.direction = 'cw'
	end
	--]]
end

function stopAtBallBehavior:getBehaviourName()
	return self.name
end

return stopAtBallBehavior
