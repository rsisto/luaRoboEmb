--Subsumption behavior. Centers the ball in the camera when ball and posts are seen.

require "socket" 

local ballCenterBehavior ={
	name = 'ballCenterBehavior',
	sensorData = nil, --global sensor data
	robot = nil	, --robot control
	robotSpeed = 200, -- rotation speed to search for ball
	ballAngleThreshold = 50 -- kicks if ball is between [50-ballAngleThreshold, 50 +ballAngleThreshold ], value between 1 and 50
  
  
  
}

ballCenterBehavior.debugprint = print --for debug
--behaviour.debugprint = function() end  --do not print anything by default

function ballCenterBehavior:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end


function ballCenterBehavior:init()
end

-- step inside a behaviour (it must make a little step and return quickly)
function ballCenterBehavior:actionStep()
	--little step to make the behaviour's goal
	--center the ball 
	local speed_left, speed_right
	
	local ballAngleFromCenter = self.sensorData.ball[1] - 50
	if ballAngleFromCenter < 0 then
		--ball is to the left
		ballCenterBehavior.debugprint('ballCenterBehavior:actionStep() align: left '..ballAngleFromCenter .. '%')
		self.robot:left(self.robotSpeed)
	elseif ballAngleFromCenter > 0 then
		--ball is to the right
		ballCenterBehavior.debugprint('ballCenterBehavior:actionStep() align: right ' ..ballAngleFromCenter .. '%')
		self.robot:right(self.robotSpeed)
	end
	
	os.execute("sleep 0.1")
	self.robot:forward(0)
	os.execute("sleep 0.1")
	
end

-- returns if this behaviour wants the control of the robot 
function ballCenterBehavior:takeControl()
	--return true to the arbitrator if the conditions are met, false if not.

	--kicks if the ball and both posts are in range or was already kicking
	if self.sensorData.ball then
		--kick if both posts are in range TODO: check if the ball is between posts? maybe not
		if #self.sensorData.posts == 2 then 
		  --Check if robot is aligned with the ball
		  local ballAngleFromCenter = math.abs(self.sensorData.ball[1] - 50)
		  if ballAngleFromCenter <= self.ballAngleThreshold  then
			--check if ball is 'near'
			--if self.sensorData.ball[1] <= self.ballDistanceThreshold then
			return true
			--end
		  end
		end
	end
  return false
end

-- This function is called by the arbitrator when this behaviour is suppresed
function ballCenterBehavior:supress()
  
end

function ballCenterBehavior:getBehaviourName()
	return self.name
end

return ballCenterBehavior
