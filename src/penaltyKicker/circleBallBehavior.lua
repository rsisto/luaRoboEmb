--Subsumption behavior. Circles around the ball for a while, when the robot is in front of it and near

require "socket"

local circleBallBehavior ={
  name = 'circleBallBehavior',
  sensorData = nil, --global sensor data
  robot = nil	, --robot control
  --parameters
  robotSpeed = 400, -- rotation speed to search for ball TODO: if changed, variables msPerWholeTurn and msPerMeter need to be recalculated
  ballDistance = 20 ,-- cm from ball when behavior gets triggered
  turnDegrees = 60 ,-- degrees to turn when behavior is triggered (after the ball is not visible anymore)
  forwardDistance = 9, -- forward distance after turning in centimeters
  --behavior variables
  triggerTime = nil,
  timeToTurn = nil,
  timeToGoForward = nil
}

circleBallBehavior.debugprint = print --for debug
--behaviour.debugprint = function() end --do not print anything by default

function circleBallBehavior:new (o)
  o = o or {} -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end


function circleBallBehavior:init()
  --Calculate the approximate time (in miliseconds) the robot needs to turn to turn turnDegrees degrees
  --calculated at 8,8V, speed:400
  local msPerWholeTurn = 12000 --TODO calcular. Desprolijo pero efectivo (TODO: debería estar en función de rad/sec de motor, radio de rueda, diámetro de robot)
  self.timeToTurn = (msPerWholeTurn*self.turnDegrees)/360

  --Calculate the approximate time (in miliseconds) the robot needs to go forward forwardDistance centimeters
  local msPerMeter = 24000 --TODO calcular. Desprolijo pero efectivo (TODO: debería estar en función de rad/sec de motor, radio de rueda, diámetro de robot)
  self.timeToGoForward = (msPerMeter*self.forwardDistance)/100
  circleBallBehavior.debugprint("circleBallBehavior: ttForward " ..self.timeToGoForward .. " ttTurn " ..  self.timeToTurn)
  
  
end

-- step inside a behaviour (it must make a little step and return quickly)
function circleBallBehavior:actionStep()
  --little step to make the behaviour's goal
  local now = socket.gettime()*1000
  local timeElapsed = now - self.triggerTime
  if timeElapsed < self.timeToTurn then
    circleBallBehavior.debugprint('circleBallBehavior:actionStep() - Turn left!!' )
    self.robot:left(self.robotSpeed)
  else
    circleBallBehavior.debugprint('circleBallBehavior:actionStep() - go Forward!')
    self.robot:forward(self.robotSpeed)
  end

end

-- returns if this behaviour wants the control of the robot
function circleBallBehavior:takeControl()
  --return true to the arbitrator if the conditions are met, false if not.
  local now = socket.gettime()*1000
  --If ball is seen and it is inside the distanceThreshold, return true
  if self.sensorData.ball then
	circleBallBehavior.debugprint('circleBallBehavior: distance ' ..  self.sensorData.ball[2])
    if self.sensorData.ball[2] < self.ballDistance then
      
      --if ball is seen, return true
      self.triggerTime = now
      return true
    end
  end  
  --if ball is not seen, return true if the time elapsed is less than the turnTime plus forwardTime
  if self.triggerTime ~= nil then
    local timeElapsed = now - self.triggerTime
    if timeElapsed < self.timeToTurn + self.timeToGoForward then
      return true
    end
  end
  return false
end

-- This function is called by the arbitrator when this behaviour is suppresed
function circleBallBehavior:supress()
  self.triggerTime = nil
end

function circleBallBehavior:getBehaviourName()
return self.name
end

  



return circleBallBehavior
