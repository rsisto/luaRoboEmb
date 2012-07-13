--Subsumption behavior. Finds a ball

local ballFinderBehavior ={
	name = 'ballFinderBehavior',
	sensorData = nil, --global sensor data
	robot = nil	, --robot control
	direction = 'cw', -- rotating direction ('cw','ccw')
	rotationSpeed = 400 -- rotation speed to search for ball
}

ballFinderBehavior.debugprint = print --for debug
--behaviour.debugprint = function() end  --do not print anything by default

function ballFinderBehavior:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end


function ballFinderBehavior:init()
	
end

-- step inside a behaviour (it must make a little step and return quickly)
function ballFinderBehavior:actionStep()
	--little step to make the behaviour's goal
	ballFinderBehavior.debugprint('ballFinderBehavior:actionStep()')
	if self.direction == 'cw' then
		self.robot:right(self.rotationSpeed)
	else
		self.robot:left(self.rotationSpeed)
	end
end

-- returns if this behaviour wants the control of the robot 
function ballFinderBehavior:takeControl()
	--return true to the arbitrator if the conditions are met, false if not.
	--searching for ball
	return true
end

-- This function is called by the arbitrator when this behaviour is suppresed
function ballFinderBehavior:supress()
	if self.direction == 'cw' then
		self.direction = 'ccw'
	else
		self.direction = 'cw'
	end
end

function ballFinderBehavior:getBehaviourName()
	return self.name
end

return ballFinderBehavior
