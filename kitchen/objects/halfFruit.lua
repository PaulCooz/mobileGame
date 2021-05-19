local fruit = require("kitchen/objects/fruit")
local halfFruit = fruit

local function dist(a, b)
	return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local gravity = vmath.vector3(0, -100, 0)
local width = 1136
local height = 640

function halfFruit:newHalf(name, cooked)
	local fields = cooked
	fields.touchebal = false

	fields.id = factory.create("#pusher", fields.position, nil, { hashName = hash(name) }, cooked.scale)

	self.__index = self
	return setmetatable(fields, self)
end

function halfFruit:delete()
	msg.post("#", "remove", { id = self.id })
end

return halfFruit