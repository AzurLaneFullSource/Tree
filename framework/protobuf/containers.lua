local var0_0 = setmetatable
local var1_0 = table
local var2_0 = rawset
local var3_0 = error

module("containers")

local var4_0 = {
	add = function(arg0_1)
		local var0_1 = arg0_1._message_descriptor._concrete_class()
		local var1_1 = arg0_1._listener

		var2_0(arg0_1, #arg0_1 + 1, var0_1)
		var0_1:_SetListener(var1_1)

		if var1_1.dirty == false then
			var1_1:Modified()
		end

		return var0_1
	end,
	remove = function(arg0_2, arg1_2)
		local var0_2 = arg0_2._listener

		var1_0.remove(arg0_2, arg1_2)
		var0_2:Modified()
	end,
	__newindex = function(arg0_3, arg1_3, arg2_3)
		var3_0("RepeatedCompositeFieldContainer Can't set value directly")
	end
}

var4_0.__index = var4_0

function RepeatedCompositeFieldContainer(arg0_4, arg1_4)
	local var0_4 = {
		_listener = arg0_4,
		_message_descriptor = arg1_4
	}

	return var0_0(var0_4, var4_0)
end

local var5_0 = {
	append = function(arg0_5, arg1_5)
		arg0_5._type_checker(arg1_5)
		var2_0(arg0_5, #arg0_5 + 1, arg1_5)
		arg0_5._listener:Modified()
	end,
	remove = function(arg0_6, arg1_6)
		var1_0.remove(arg0_6, arg1_6)
		arg0_6._listener:Modified()
	end,
	__newindex = function(arg0_7, arg1_7, arg2_7)
		var3_0("RepeatedCompositeFieldContainer Can't set value directly")
	end
}

var5_0.__index = var5_0

function RepeatedScalarFieldContainer(arg0_8, arg1_8)
	local var0_8 = {
		_listener = arg0_8,
		_type_checker = arg1_8
	}

	return var0_0(var0_8, var5_0)
end
