local bomb = setmetatable({} ,{ __index = require("kitchen/objects/fruit/fruit") })

function bomb:new(width, height)
	local flyInfo = self:getFlyInfo(width, height)
	local fields = {
		name = "bomb",
		speed = 3,			--!!
		touchebal = true,
		died = false,
		lifeTime = 0,
		movingVector = flyInfo.movingVector,
		minY = flyInfo.minY
	}

	fields.position = vmath.vector3(flyInfo.startX, fields.minY, 0)
	fields.angle = vmath.quat(0, 0, 0, 1) * vmath.quat_rotation_z(randReal(0, 6.28))
	fields.id = factory.create("#pushBomb", fields.position, fields.angle, { hashName = hash(fields.name) })

	return setmetatable(fields, { __index = bomb })
end

function bomb:delete(falled)
	msg.post("#", "remove", { id = self.id, falled = false })
	msg.post(self.id, "pop")
end

return bomb