--AX12 high level methods
local ax12api = require("ax12")

--Atributos
local ax12motor ={
	ax12=nil,
	ttyFile = "/dev/ttyUSB0",
	motor_id=nil
}

ax12motor.debugprint = print --for debug
--ax12motor.debugprint = function() end  --do not print anything by default


--Constructor
function ax12motor:new (o)
  o = o or {}   -- create object if user does not provide one
  --OO cookbook
  setmetatable(o, self)
  self.__index = self
  --inicialización específica
  o:init()
  
  return o
end

--Inicialización
function ax12motor:init()
	--ax12 es una 'variable de clase'
	if ax12motor.ax12 == nil  then 
		--configurar librería serial
		ax12motor.ax12 = ax12api:new({ttyFile=ttyFile})
	end	
end

--Inicialización para funcionamiento como rotación continua
function ax12motor:initContinuousRotation()
	-- 0x06 dirección de config de límites de ángulos (se setean en 0 los límites)
	self.ax12:writeData(self.motor_id,0x06,{0x00,0x00,0x00,0x00})
end

function ax12motor:ping()
	local err = self.ax12:ping(self.motor_id)
	ax12motor.debugprint("ping return " .. err)
end


--value=1 prende, value=0 apaga
function ax12motor:setLedValue(value)
	self.ax12:writeData(self.motor_id,0x19,{value})
end

function ax12motor:getId()
	--Se lee dirección 0x3, 1 byte
	local ret, err = self.ax12:readData(self.motor_id,0x3,1)
	return ret[1]
end

--metodo de clase (solo funciona con broadcast)
function ax12motor.setId(id)
	--se asume que solo un motor esta conectado	
	ax12api.ax12:writeData(nil,0x3,{id})
end

function ax12motor:getSpeed()
	local velArray , err = self.ax12:readData(self.motor_id,0x26,2)
	local b1 = velArray[1]
	local b2 = velArray[2]
	ax12motor.debugprint("getSpeed " .. b1 .." " .. b2)
	local vel = ( b1 + (b2 % 4)*256) * (-1) ^ (math.floor(b2/4)%2)
	return vel
end

--MAX_VEL = 1023
function ax12motor:setSpeed(vel)
	local b1 = math.abs(vel) % 256
	local b2 = math.floor(math.abs(vel) / 256)
	if b2 > 3 then b2 = 3 end
	if vel < 0 then
		b2 = b2 + 4
	end
	ax12motor.debugprint("setSpeed " .. b1 .." " .. b2)
	self.ax12:writeData(self.motor_id,0x20,{b1,b2})
end

function ax12motor:getOperatingVoltage()
	local voltArr , err = self.ax12:readData(self.motor_id,0x0C,2)
	local voltMin = voltArr[1]/10
	local voltMax = voltArr[2]/10
	ax12motor.debugprint("getOperatingVoltage " .. voltMin .. " - " .. voltMax)
	return voltMin, voltMax
end
function ax12motor:setOperatingVoltage(vMin,vMax)
	local vMinByte = vMin *10
	local vMaxByte = vMax *10
	local err = self.ax12:writeData(self.motor_id,0x0C,{vMinByte,vMaxByte})
	ax12motor.debugprint("setOperatingVoltage " .. vMinByte .." " .. vMaxByte .. " error: " .. err)
end
function ax12motor:getCurrentVoltage()
	local voltArr , err = self.ax12:readData(self.motor_id,0x2A,1)
	local volt = voltArr[1]/10
	ax12motor.debugprint("currentVoltage " .. volt)
	return volt
end

function ax12motor:getMaxTorque()
	local maxTorqueArray , err = self.ax12:readData(self.motor_id,0x0E,2)
	-- TODO checkear como esta esto
	local b1 = maxTorqueArray[1]
	local b2 = maxTorqueArray[2]
	ax12motor.debugprint("getMaxTorque " .. b1 .." " .. b2)
	local maxTorque = "TODO"
	return maxTorque
end

function ax12motor:setMaxTorque(torque)
	-- TODO checkear como esta esto
	local b1 = math.abs(torque) % 256
	local b2 = math.floor(math.abs(torque) / 256)

	ax12motor.debugprint("setSpeed " .. b1 .." " .. b2)
	self.ax12:writeData(self.motor_id,0x0E,{b1,b2})
end

function ax12motor:getPosition()
	local positionArray , err = self.ax12:readData(self.motor_id,0x24,2)
	-- TODO checkear como esta esto
	local b1 = positionArray[1]
	local b2 = positionArray[2]
	ax12motor.debugprint("getPosition " .. b1 .." " .. b2)
	local position = "TODO"
	return position
end

--speeds, array of {id,speed}
--speed is between -1023,1023
--A syncWrite is sent to all involved motors.
function ax12motor.setMultipleSpeeds(speeds)
	syncWritePackage = {}
	for _,speed in ipairs(speeds) do 
		local vel = speed.speed
		local id = speed.id
		local b1 = math.abs(vel) % 256
		local b2 = math.floor(math.abs(vel) / 256)
		if b2 > 3 then b2 = 3 end
		if vel < 0 then
			b2 = b2 + 4
		end
		ax12motor.debugprint("syncWrite speed" .. b1 .." " .. b2 .. " id:"..id)
		table.insert(syncWritePackage,{id=id,data={b1,b2}})
	end
	ax12motor.ax12:syncWrite(0x20,syncWritePackage)
end


return ax12motor
