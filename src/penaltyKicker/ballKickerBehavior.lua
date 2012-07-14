--Subsumption behavior. Kicks a ball if seen

require "socket" 

local ballKickerBehavior ={
	name = 'ballKickerBehavior',
	sensorData = nil, --global sensor data
	robot = nil	, --robot control
  robotSpeed = 1000, -- rotation speed to search for ball
	ballAngleThreshold = 50, -- kicks if ball is between [50-ballAngleThreshold, 50 +ballAngleThreshold ], value between 1 and 50
  msKeepKicking = 10000, -- ms the robot will keep pushing the ball if the posts are not seen any more.
  ballDistanceThreshold = 30,
  --instance variables
  timeStartedKicking = nil
  
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
	--kick the ball and try to align the robot and ball
	local speed_left, speed_right
	if self.sensorData.ball then
		local ballAngleFromCenter = self.sensorData.ball[1] - 50
		local speedDecrease = math.abs(ballAngleFromCenter*self.robotSpeed)/50
		if ballAngleFromCenter < 0 then
			--ball is to the left
			speed_left, speed_right = self.robotSpeed-speedDecrease , self.robotSpeed
		elseif ballAngleFromCenter > 0 then
			--ball is to the right
			speed_left, speed_right = self.robotSpeed , self.robotSpeed -speedDecrease
		end
	else
		speed_left,speed_right = self.robotSpeed , self.robotSpeed
	end
	self.robot:setVels(speed_left, speed_right)
	ballKickerBehavior.debugprint('ballKickerBehavior:actionStep() speed: ' .. speed_left .. ' ' .. speed_right)
end

-- returns if this behaviour wants the control of the robot 
function ballKickerBehavior:takeControl()
	--return true to the arbitrator if the conditions are met, false if not.
  local now = socket.gettime()*1000
  --kicks if the ball and both posts are in range or was already kicking
	if self.sensorData.ball then
		--kick if both posts are in range TODO: check if the ball is between posts? maybe not
		if #self.sensorData.posts == 2 then 
		  --Check if robot is aligned with the ball
		  local ballAngleFromCenter = math.abs(self.sensorData.ball[1] - 50)
		  if ballAngleFromCenter <= self.ballAngleThreshold  then
			--check if ball is 'near'
			--if self.sensorData.ball[1] <= self.ballDistanceThreshold then
			self.timeStartedKicking = now
			return true
			--end
		  end
		end
	end
  --also keep kicking for some time if some post or the ball is not seen
	if self.timeStartedKicking ~= nil then
		local timeKicking = now - self.timeStartedKicking
		if timeKicking <= self.msKeepKicking then
			return true
		end
	end
  self.timeStartedKicking = nil
  return false
end

-- This function is called by the arbitrator when this behaviour is suppresed
function ballKickerBehavior:supress()
  self.timeStartedKicking = nil
end

function ballKickerBehavior:getBehaviourName()
	return self.name
end

return ballKickerBehavior
