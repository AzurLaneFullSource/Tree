local var0 = setmetatable

module("protobuf.listener")

local var1 = {
	Modified = function()
		return
	end
}

function NullMessageListener()
	return var1
end

local var2 = {
	Modified = function(arg0)
		if arg0.dirty then
			return
		end

		if arg0._parent_message then
			arg0._parent_message:_Modified()
		end
	end
}

var2.__index = var2

function Listener(arg0)
	local var0 = {}

	var0.__mode = "v"
	var0._parent_message = arg0
	var0.dirty = false

	return var0(var0, var2)
end
