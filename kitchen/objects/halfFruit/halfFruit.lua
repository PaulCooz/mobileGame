local halfFruit = setmetatable({} ,{ __index = require("kitchen/objects/fruit/fruit") })

function halfFruit:new(cooked)
	local fields = {
		name = cooked.name,
		movingVector = cooked.movingVector * randReal(0.9, 1.1),
		speed = cooked.speed,
		lifeTime = cooked.lifeTime,
		position = cooked.position,
		angle = cooked.angle,
		minY = cooked.minY,
		touchebal = false
	}
	fields.rotation = cooked.rotation
	fields.id = factory.create(
		"#pushHalf", 
		fields.position, 
		fields.angle,
		{ hashName = hash(fields.name) }, 
		go.get_scale(cooked.id)
	)

	return setmetatable(fields, { __index = halfFruit })
end

function halfFruit:delete(falled)
	msg.post("#", "remove", { id = self.id, falled = false })
	msg.post(self.id, "pop")
end

return halfFruit