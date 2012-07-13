--For Windows comments packages and requires :)
--package.path = package.path .. ";../?.lua;./?.lua;../v4l/?.lua;../ax12/?.lua;"
--package.cpath = package.cpath ..";../v4l/?.so"

--require "v4l"
--require "socket"
--require "v4lCommon"

local inactivebehaviour ={
	name = 'INACTIVEbehaviour',
	robot = nil
}

inactivebehaviour.debugprint = print --for debug
--behaviour.debugprint = function() end  --do not print anything by default

function inactivebehaviour:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end


function inactivebehaviour:init()
	
end

-- step inside a behaviour (it must make a little step and return quickly)
function inactivebehaviour:actionStep()
	--TODO
	--little step to make the behaviour's goal
	inactivebehaviour.debugprint('behaviour:actionStep()')
end

-- returns if this behaviour wants the control of the robot 
function inactivebehaviour:takeControl()
	--return FALSE to the arbitrator if the conditions are met, false if not.
	return false
end

-- This function is called by the arbitrator when this behaviour is suppresed
function inactivebehaviour:supress()

end

function inactivebehaviour:getBehaviourName()
	return self.name
end

return inactivebehaviour
