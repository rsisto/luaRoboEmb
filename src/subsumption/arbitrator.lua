--Arbitrator. 
--Decides what behaviour takes the control of the robot.
--Only one behabiour is active at a given moment.


local arbitrator = {
	--state of the arbitrator
	--Active behaviour (behaviour, priority)
	activeBehaviour = {nil,-1},
	--Arrays of behaviuors, ordered the highest priorty first
	--first with heighest priority, then less important
	behaviourArray = {},	
}

arbitrator.debugprint = print --for debug
--arbitrator.debugprint = function() end  --do not print anything by default


function arbitrator:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  o:init()
  return o
end

function arbitrator:init()
	--for debug
	arbitrator.debugprint('Behavious quantity:  ' ..  #self.behaviourArray)
	for i=1,#self.behaviourArray do
		arbitrator.debugprint('behaviourArray[' .. i .. ']:getBehaviourName() = ' .. self.behaviourArray[i]:getBehaviourName())
	end
		
	--inicializo el behaviourIncial como el que tiene menor prioridad
	self.activeBehaviour = {self.behaviourArray[#self.behaviourArray],#self.behaviourArray}
	
	--prints activeBehaviour
	arbitrator.debugprint('First Active Behaviour name = ' .. self.activeBehaviour[1]:getBehaviourName())
	arbitrator.debugprint('First Active Priority = ' .. self.activeBehaviour[2])
	
end

--Run the arbitrator step by step (if sensing needs to be external)
function arbitrator:step()
	self:chooseActiveBehaviour()
	self.activeBehaviour[1]:actionStep()
end

--Start, runs the arbitrator in a continuous loop, use if if your behaviors are self contained (sense and act).
--USE AT YOUR OWN RISK!! bwahahaha
function arbitrator:start()
	while true do
		self:step()
	end
end


-- choose behaviour
function arbitrator:chooseActiveBehaviour()
	-- selects the next behavoiur or next behaviourStep to be executed
	--choose the first behaviour to take the control for one time only
	local prioritySelection = 1 
	local behaviourSelected = nil
	
	while (prioritySelection <= #self.behaviourArray and behaviourSelected~=true ) do
		if self.behaviourArray[prioritySelection]:takeControl() == true and prioritySelection < self.activeBehaviour[2] then 
			--A Higher priority behaviour than the actualBehaviour wants the control
			
			--notify actual Behaviour with a supress call
			self.activeBehaviour[1]:supress()
			
			--set new actual behaviour
			self.activeBehaviour = {self.behaviourArray[prioritySelection],prioritySelection}
		    behaviourSelected = true
		
		elseif  prioritySelection == self.activeBehaviour[2] and self.activeBehaviour[1]:takeControl() then
			--el mismo Behaviour que está activo 
			--sigo en el mismo
			  behaviourSelected = true
		
		elseif self.behaviourArray[prioritySelection]:takeControl() == true and prioritySelection > self.activeBehaviour[2] then 
			--A lower priority behaviour than the actuaBehaviour wants the control
			
			--notify actual Behaviour with a supress call
			--self.activeBehaviour[1]:supress()
			
			--set new actual behaviour
			self.activeBehaviour = {self.behaviourArray[prioritySelection],prioritySelection}
		    behaviourSelected = true
		
		end
		
		prioritySelection = prioritySelection + 1
	end --while 
	if behaviourSelected ~= true then
		--Error: No behavior selected
		print("No behavior selected, the lowest priority behavior must return true for takeControl")
		self.activeBehaviour[1]:supress()
		self.activeBehaviour = {self.behaviourArray[#self.behaviourArray],#self.behaviourArray}
		behaviourSelected = true
	end
	--prints activeBehaviour
	arbitrator.debugprint('Active Behaviour name = ' .. self.activeBehaviour[1]:getBehaviourName() .. " Priority " .. self.activeBehaviour[2])
end

return arbitrator
