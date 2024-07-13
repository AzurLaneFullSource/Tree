local var0_0 = setmetatable

module("protobuf.listener")

local var1_0 = {
	Modified = function()
		return
	end
}

function NullMessageListener()
	return var1_0
end

local var2_0 = {
	Modified = function(arg0_3)
		if arg0_3.dirty then
			return
		end

		if arg0_3._parent_message then
			arg0_3._parent_message:_Modified()
		end
	end
}

var2_0.__index = var2_0

function Listener(arg0_4)
	local var0_4 = {}

	var0_4.__mode = "v"
	var0_4._parent_message = arg0_4
	var0_4.dirty = false

	return var0_0(var0_4, var2_0)
end
