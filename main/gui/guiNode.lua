local node = {}

function node:new(name)
	local currentNode = gui.get_node(name)
	local fields = {
		node = currentNode,
		color = gui.get_color(currentNode),
		scale = gui.get_scale(currentNode),
		pos = gui.get_position(currentNode)
	}

	return setmetatable(fields, { __index = node })
end

function node:setAlpha(alpha, duration)
	self.color.w = alpha
	gui.animate(self.node, gui.PROP_COLOR, self.color, gui.EASING_LINEAR, duration or 1)
end

function node:fadein(duration)														-- show node
	self:setAlpha(0, 0)
	timer.delay(0.1, false, function() self:setAlpha(1, duration or 1) end)
end

function node:fadeout(duration)														-- hide node
	self:setAlpha(0, duration or 1)
end

function node:setPosY(newY, duration)
	local pos = gui.get_position(self.node)
	pos.y = newY

	gui.animate(self.node, "position.y", pos, gui.EASING_LINEAR, duration or 1)
end

return node