local var0 = Layer
local var1 = rawget
local var2 = setmetatable
local var3 = {}

function var3.__index(arg0, arg1)
	return var1(var3, arg1)
end

function var3.__call(arg0, arg1)
	return var2({
		value = arg1 or 0
	}, var3)
end

function var3.New(arg0)
	return var2({
		value = arg0 or 0
	}, var3)
end

function var3.Get(arg0)
	return arg0.value
end

function var3.NameToLayer(arg0)
	return var0[arg0]
end

function var3.GetMask(...)
	local var0 = {
		...
	}
	local var1 = 0

	for iter0 = 1, #var0 do
		local var2 = var3.NameToLayer(var0[iter0])

		if var2 ~= nil then
			var1 = var1 + 2^var2
		end
	end

	return var1
end

UnityEngine.LayerMask = var3

var2(var3, var3)

return var3
