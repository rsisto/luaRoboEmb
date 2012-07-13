--Subsumption behavior. Kicks a ball if seen

local ballKickerBehavior ={
	name = 'ballKickerBehavior',
	sensorData = nil, --global sensor data
	robot = nil	, --robot control
	robotSpeed = 400, -- rotation speed to search for ball
	ballPosThreshold = 40 -- kicks if ball is between [50-ballPosThreshold, 50 +ballPosThreshold ]
}

ballKickerBehavior.debugprint = print --for debug
--behaviour.debugprint = function() end  --do not print anything by default

function ballKickerBehavior:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end


function ballKickerBehavior:init()
	
end

-- step inside a behaviour (it must make a little step and return quickly)
function ballKickerBehavior:actionStep()
	--little step to make the behaviour's goal
	ballKickerBehavior.debugprint('ballKickerBehavior:actionStep()')
	
	self.robot:forward(self.robotSpeed)
end

-- returns if this behaviour wants the control of the robot 
function ballKickerBehavior:takeControl()
	--return true to the arbitrator if the conditions are met, false if not.
	if self.sensorData.ball then
		local distFromCenter = math.abs(self.sensorData.ball[1] - 50)
		if distFromCenter <= self.ballPosThreshold  then
			return true
		end
	end
	return false
end

-- This function is called by the arbitrator when this behaviour is suppresed
function ballKickerBehavior:supress()
end

function ballKickerBehavior:getBehaviourName()
	return self.name
end

return ballKickerBehavior
