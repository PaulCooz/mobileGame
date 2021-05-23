local fruit = {}

function randReal(from, to)
	return from + (to - from) * math.random()
end

function percents(percent)
	if math.random(1, 100) <= percent then
		return true
	else
		return false
	end
end

function dist(a, b)
	return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

gravity = vmath.vector3(0, -100, 0)													-- just constant

function fruit:getFlyInfo(width, height)
	local result = {}

	local movingVector = vmath.vector3()
	result.minY = -math.max(width, height) / 10										-- Y for delete and start

	local maxY = math.sqrt(-2 * gravity.y * height) * randReal(0.5, 0.6)			-- max height ~50-60%
	result.movingVector = vmath.vector3(0, maxY - result.minY, 0)

	result.startX = randReal(width / 5, width / 3)
	result.movingVector.x = -gravity.y * width / (2 * result.movingVector.y)
	if percents(30) then															-- throw side
		result.startX = result.startX - 2 * width / 3
		result.movingVector.x = result.movingVector.x * randReal(1.6, 1.8)
	else																			-- bottom
		result.movingVector.x = result.movingVector.x * randReal(0.2, 0.3)
	end
	if percents(50) then															-- other side
		result.movingVector.x = -result.movingVector.x
		result.startX = width - result.startX
	end

	return result
end

function fruit:new(name, width, height)
	local flyInfo = fruit:getFlyInfo(width, height)
	local fields = {
		name = name,
		speed = 2,
		touchebal = true,
		died = false,
		lifeTime = 0,
		movingVector = flyInfo.movingVector,
		minY = flyInfo.minY
	}

	fields.position = vmath.vector3(flyInfo.startX, fields.minY, math.random() - 1)
	fields.angle = vmath.quat(0, 0, 0, 1) * vmath.quat_rotation_z(randReal(0, 6.28))-- random angle
	fields.id = factory.create("#pushFruit", fields.position, fields.angle, { hashName = hash(fields.name) })

	return setmetatable(fields, { __index = fruit })
end

function fruit:rotate(speed)
	self.angle = self.angle * vmath.quat_rotation_z(0.5 * speed)
	go.set_rotation(self.angle, self.id)
end

function fruit:move(freeze, dt)
	local speed = self.speed * dt
	if freeze > 0 then																-- speed -33%
		speed = speed * math.max(1 / 3, - 2 * freeze / 3 + 1)
	end

	local move = self.movingVector + gravity * self.lifeTime

	self.position = self.position + move * speed

	if self.position.y < self.minY then												-- fall check
		self:delete(true)
		return
	end

	self.lifeTime = self.lifeTime + speed											-- flies faster - falls faster

	go.set_position(self.position, self.id)

	self:rotate(speed)																-- rotate object
end

function fruit:isCuted(point, edge)
	return dist(self.position, point) < edge / 8
end

function fruit:delete(falled)
	msg.post("#", "remove", { id = self.id, falled = falled or false })
	msg.post(self.id, "pop")
end

return fruit