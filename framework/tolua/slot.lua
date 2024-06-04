local var0 = setmetatable
local var1 = {}

var0(var1, var1)

function var1.__call(arg0, ...)
	if arg0.obj == nil then
		return arg0.func(...)
	else
		return arg0.func(arg0.obj, ...)
	end
end

function var1.__eq(arg0, arg1)
	return arg0.func == arg1.func and arg0.obj == arg1.obj
end

function slot(arg0, arg1)
	return var0({
		func = arg0,
		obj = arg1
	}, var1)
end
