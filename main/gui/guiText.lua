local commonNode = require("main/gui/guiNode")
local textNode = commonNode

function textNode:new(name)
	local currentNode = gui.get_node(name)
	local fields = {
		node = currentNode,
		color = gui.get_color(currentNode),
		scale = gui.get_scale(currentNode)
	}
	self.__index = self
	return setmetatable(fields, self)
end

function textNode:setText(text)
	gui.set_text(self.node, text)
end

return textNode