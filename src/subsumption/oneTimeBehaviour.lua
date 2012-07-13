--For Windows comments packages and requires :)
--package.path = package.path .. ";../?.lua;./?.lua;../v4l/?.lua;../ax12/?.lua;"
--package.cpath = package.cpath ..";../v4l/?.so"

--require "v4l"
--require "socket"
--require "v4lCommon"

local oneTimeBehaviour ={
	name = 'oneTimeBehaviour',
	robot = nil,
	stepsUsed = 0,
	neededSteps = 2
}

oneTimeBehaviour.debugprint = print --for debug
--behaviour.debugprint = function() end  --do not print anything by default

function oneTimeBehaviour:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end


function oneTimeBehaviour:init()
	
end

-- step inside a behaviour (it must make a little step and return quickly)
function oneTimeBehaviour:actionStep()
	--TODO
	--little step to make the behaviour's goal
	oneTimeBehaviour.debugprint('oneTimeBehaviour:actionStep()')
	self.stepsUsed = self.stepsUsed + 1
end

-- returns if this behaviour wants the control of the robot 
function oneTimeBehaviour:takeControl()
	--return true when self.stepsUsed < self.neededSteps, false if not
	if self.stepsUsed < self.neededSteps then 
		return true
	else 
		return false
	end
end

-- This function is called by the arbitrator when this behaviour is suppresed
function oneTimeBehaviour:supress()
	oneTimeBehaviour.debugprint('oneTimeBehaviour:SUPRESS()')
end

-- returns the needed steps to finish this behaviour
function oneTimeBehaviour:stepsNeeded()
	return self.neededSteps
end

function oneTimeBehaviour:getBehaviourName()
	return self.name
end

return oneTimeBehaviour
