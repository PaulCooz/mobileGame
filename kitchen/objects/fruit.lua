local fruit = {}

local function randReal(from, to)
	return from + (to - from) * math.random()
end

local function percents(percent)
	if math.random(1, 100) <= percent then
		return true
	else
		return false
	end
end

local function dist(a, b)
	return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local gravity = vmath.vector3(0, -100, 0)
local width = 1136
local height = 640

function fruit:new(name)
	local fields = {
		name = name,
		speed = 2,
		touchebal = true,
		died = false,
		minY = -100,
		lifeTime = 0
	}

	local movingVector = vmath.vector3()

	local maxY = math.sqrt(-2 * gravity.y * height) * randReal(0.5, 0.6)		-- max height 50-60%
	fields.movingVector = vmath.vector3(0, maxY - fields.minY, 0)

	local startX = randReal(width / 5, width / 3)
	fields.movingVector.x = -gravity.y * width / (2 * fields.movingVector.y)
	if percents(30) then													-- throw side
		startX = startX - 2 * width / 3
		fields.movingVector.x = fields.movingVector.x * randReal(1.6, 1.8)
	else																	-- bottom
		fields.movingVector.x = fields.movingVector.x * randReal(0.2, 0.3)
	end
	if percents(50) then
		fields.movingVector.x = -fields.movingVector.x
		startX = width - startX
	end

	fields.position = vmath.vector3(startX, fields.minY, 0)
	fields.id = factory.create("#pusher", fields.position, nil, { hashName = hash(name) })

	self.__index = self
	return setmetatable(fields, self)
end

function fruit:move(externalForces, dt)
	local speed = self.speed * dt
	local move = self.movingVector + externalForces + gravity * self.lifeTime

	self.position = self.position + move * speed

	if self.position.y < self.minY then														--!!!!
		self:delete()
		return
	end

	self.lifeTime = self.lifeTime + speed												--!

	go.set_position(self.position, self.id)
end

function fruit:windowResized(newSize)
	width = newSize.width
	height = newSize.height
	msg.post(self.id, "windowResized", newSize)
end

function fruit:isCuted(point)
	return dist(self.position, point) < 200
end

function fruit:delete()
	msg.post("#", "remove", { id = self.id })
	msg.post(self.id, "pop")
end

return fruit