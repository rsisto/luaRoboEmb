--Requiers for Behaviours
local behaviourAPI = require("behaviour")
local inactivebehaviourAPI = require("inactivebehaviour")
local oneTimeBehaviourAPI = require("oneTimeBehaviour")

--Requier for Arbitrator
local arbitratorAPI = require("arbitrator")

--Get Instances of Behaviours
local behaviour = behaviourAPI:new()
local inactivebehaviour = inactivebehaviourAPI:new()
local oneTimeBehaviour =  oneTimeBehaviourAPI:new()

--Construct a priority behaviour Array
local behaviourArray = {inactivebehaviour,oneTimeBehaviour,behaviour}

--Get an arbitrator instance and pass the priority Behaviour Array
local arbitrator = arbitratorAPI:new({behaviourArray=behaviourArray})

--Starts the arbitrator
arbitrator:start()

print('ejecute bien')