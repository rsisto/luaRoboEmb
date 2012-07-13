--For Windows comments packages and requires :)
--package.path = package.path .. ";../?.lua;./?.lua;../v4l/?.lua;../ax12/?.lua;"
--package.cpath = package.cpath ..";../v4l/?.so"

--require "v4l"
--require "socket"
--require "v4lCommon"

local behaviour ={
	name = 'behaviourName',
	robot = nil
}

behaviour.debugprint = print --for debug
--behaviour.debugprint = function() end  --do not print anything by default

function behaviour:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end


function behaviour:init()
	
end

-- step inside a behaviour (it must make a little step and return quickly)
function behaviour:actionStep()
	--TODO
	--little step to make the behaviour's goal
	behaviour.debugprint('behaviour:actionStep()')
end

-- returns if this behaviour wants the control of the robot 
function behaviour:takeControl()
	--return true to the arbitrator if the conditions are met, false if not.
	return true
end

-- This function is called by the arbitrator when this behaviour is suppresed
function behaviour:supress()

end

function behaviour:getBehaviourName()
	return self.name
end

return behaviour
