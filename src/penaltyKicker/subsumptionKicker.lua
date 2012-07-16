--Penalty kicker subsumption robot 

package.path = package.path .. ";../?.lua;./?.lua;../v4l/?.lua;../ax12/?.lua;../subsumption/?.lua;"
package.cpath = package.cpath ..";../v4l/?.so"

require "ballAndPostsFinder"
require "v4l"
require "socket"
require "v4lCommon"

local arbitratorAPI = require("arbitrator")

local ballFinderBehaviorAPI = require("ballFinderBehavior")
local getNearBallBehaviorAPI = require("getNearBallBehavior")
local circleBallBehaviorAPI = require("circleBallBehavior")
local ballKickerBehaviorAPI = require("ballKickerBehavior")
local stopAtBallBehaviorAPI = require("stopAtBallBehavior")
local ballCenterBehaviorAPI = require("ballCenterBehavior")

local carritoAPI = require("carrito")

colorRef={
	--element={hue, hueThreshold, histogramThreshold}
	--hueThreshold
	ball = {22,5,4},
	post = {182,6,20}
}

camera = "/dev/video0"
dev = v4l.open(camera)
w, h = v4l.widht(), v4l.height()


--global table for sensor data
local sensorData = {
	ball=nil, -- ball position and distance
	ball_hint=nil, -- ball hint position (when the ball is not found, but there are some pixels similar to it)
	posts={} ,-- posts position {left,right}, {one_post} or {} (no post found)
  direction = 'cw'
}

function sense()
	local img = v4l.getframe() 
	--Ball
	local histBall , histPosts = getHistogramForBallAndPosts(img,w,h,colorRef)
	pos, pos_something = getBallPosition(histBall,colorRef.ball[3])
	if pos ~=nil then
		--ball and distance found
		sensorData.ball={pos,pos_something}
		sensorData.ball_hint = nil
	elseif pos_something ~=nil then
		--something found
		sensorData.ball=nil
		sensorData.ball_hint = pos_something		
	else 
		--nothing found
		sensorData.ball=nil
		sensorData.ball_hint = nil
	end
	
	--Posts
	local post_left, post_right = getPostsPositions(histPosts,colorRef.post[3])
	if post_right ~=nil then
		sensorData.posts={post_left,post_right}
	elseif post_left ~=nil then
		sensorData.posts={post_left}
	else 
		sensorData.posts={}
	end
end

--create robot
local carrito = carritoAPI:new()
print("Motor voltage: " .. carrito.motor_left:getCurrentVoltage())

--create behaviors (pass sensorData and robot as arguments)
local finderBehavior = ballFinderBehaviorAPI:new({sensorData=sensorData,robot=carrito})
local getNearBallBehavior = getNearBallBehaviorAPI:new({sensorData=sensorData,robot=carrito})
local ballDanceBehavior = circleBallBehaviorAPI:new({sensorData=sensorData,robot=carrito})
local ballCenterBehavior = ballCenterBehaviorAPI:new({sensorData=sensorData,robot=carrito})
local kickerBehavior = ballKickerBehaviorAPI:new({sensorData=sensorData,robot=carrito})
local stopperBehavior = stopAtBallBehaviorAPI:new({sensorData=sensorData,robot=carrito})

--Construct a priority behaviour Array
--local behaviourArray = {kickerBehavior,ballDanceBehavior,getNearBallBehavior,finderBehavior}
local behaviourArray = {kickerBehavior,ballCenterBehavior,ballDanceBehavior,getNearBallBehavior,finderBehavior}

--Get an arbitrator instance and pass the priority Behaviour Array
local arbitrator = arbitratorAPI:new({behaviourArray=behaviourArray})

while true do
	--sense
	sense()
	--arbitrate one step.
	arbitrator:step()
end

