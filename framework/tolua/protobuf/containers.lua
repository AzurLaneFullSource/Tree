local var0 = setmetatable
local var1 = table
local var2 = rawset
local var3 = error

module("protobuf.containers")

local var4 = {
	add = function(arg0)
		local var0 = arg0._message_descriptor._concrete_class()
		local var1 = arg0._listener

		var2(arg0, #arg0 + 1, var0)
		var0:_SetListener(var1)

		if var1.dirty == false then
			var1:Modified()
		end

		return var0
	end,
	remove = function(arg0, arg1)
		local var0 = arg0._listener

		var1.remove(arg0, arg1)
		var0:Modified()
	end,
	__newindex = function(arg0, arg1, arg2)
		var3("RepeatedCompositeFieldContainer Can't set value directly")
	end
}

var4.__index = var4

function RepeatedCompositeFieldContainer(arg0, arg1)
	local var0 = {
		_listener = arg0,
		_message_descriptor = arg1
	}

	return var0(var0, var4)
end

local var5 = {
	append = function(arg0, arg1)
		arg0._type_checker(arg1)
		var2(arg0, #arg0 + 1, arg1)
		arg0._listener:Modified()
	end,
	remove = function(arg0, arg1)
		var1.remove(arg0, arg1)
		arg0._listener:Modified()
	end,
	__newindex = function(arg0, arg1, arg2)
		var3("RepeatedCompositeFieldContainer Can't set value directly")
	end
}

var5.__index = var5

function RepeatedScalarFieldContainer(arg0, arg1)
	local var0 = {
		_listener = arg0,
		_type_checker = arg1
	}

	return var0(var0, var5)
end
