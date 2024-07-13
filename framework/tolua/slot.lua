local var0_0 = setmetatable
local var1_0 = {}

var0_0(var1_0, var1_0)

function var1_0.__call(arg0_1, ...)
	if arg0_1.obj == nil then
		return arg0_1.func(...)
	else
		return arg0_1.func(arg0_1.obj, ...)
	end
end

function var1_0.__eq(arg0_2, arg1_2)
	return arg0_2.func == arg1_2.func and arg0_2.obj == arg1_2.obj
end

function slot(arg0_3, arg1_3)
	return var0_0({
		func = arg0_3,
		obj = arg1_3
	}, var1_0)
end
