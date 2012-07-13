--Subsumption behavior. Gets near the ball 

local getNearBallBehavior ={
	name = 'getNearBallBehavior',
	sensorData = nil, --global sensor data
	robot = nil	, --robot control
	robotSpeed = 400, -- rotation speed to search for ball
}

getNearBallBehavior.debugprint = print --for debug
--behaviour.debugprint = function() end  --do not print anything by default

function getNearBallBehavior:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end


function getNearBallBehavior:init()
	
end

-- step inside a behaviour (it must make a little step and return quickly)
function getNearBallBehavior:actionStep()
	--little step to make the behaviour's goal
	getNearBallBehavior.debugprint('getNearBallBehavior:actionStep()')
	
	self.robot:forward(self.robotSpeed)
end

-- returns if this behaviour wants the control of the robot 
function getNearBallBehavior:takeControl()
	--return true to the arbitrator if the conditions are met, false if not.
	if self.sensorData.ball or self.sensorData.ball_hint then
		return true
	end
	return false
end

-- This function is called by the arbitrator when this behaviour is suppresed
function getNearBallBehavior:supress()
end

function getNearBallBehavior:getBehaviourName()
	return self.name
end

return getNearBallBehavior
