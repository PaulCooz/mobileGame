local button = setmetatable({} ,{__index = require("main/gui/guiNode")})

function button:new(name)
	local currentNode = gui.get_node(name)
	local fields = {
		node = currentNode,
		color = gui.get_color(currentNode),
		scale = gui.get_scale(currentNode),
		pushed = false
	}

	return setmetatable(fields, { __index = button })
end

function button:push(funct)
	if self.pushed == true then
		return
	end
	self.pushed = true

	local alpha = self.color.w
	self.color = self.color * 0.7
	self.color.w = alpha

	self.scale = self.scale * 0.7

	gui.animate(self.node, gui.PROP_COLOR, self.color, gui.EASING_LINEAR, 0.2)
	gui.animate(self.node, gui.PROP_SCALE, self.scale, gui.EASING_LINEAR, 0.2, 0, 
		function()
			self.color = self.color / 0.7
			self.color.w = alpha

			self.scale = self.scale / 0.7

			gui.animate(self.node, gui.PROP_COLOR, self.color, gui.EASING_LINEAR, 0.1, 0.2)
			gui.animate(self.node, gui.PROP_SCALE, self.scale, gui.EASING_LINEAR, 0.1, 0.2,
				function()
					funct()
					self.pushed = false
				end
			)
		end
	)
end

return button