local textNode = setmetatable({} ,{__index = require("main/gui/guiNode")})

function textNode:new(name)
	local currentNode = gui.get_node(name)
	local fields = {
		node = currentNode,
		color = gui.get_color(currentNode),
		scale = gui.get_scale(currentNode)
	}

	return setmetatable(fields, { __index = textNode })
end

function textNode:setText(text)
	gui.set_text(self.node, text)
end

return textNode