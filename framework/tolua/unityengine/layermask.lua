local var0_0 = Layer
local var1_0 = rawget
local var2_0 = setmetatable
local var3_0 = {}

function var3_0.__index(arg0_1, arg1_1)
	return var1_0(var3_0, arg1_1)
end

function var3_0.__call(arg0_2, arg1_2)
	return var2_0({
		value = arg1_2 or 0
	}, var3_0)
end

function var3_0.New(arg0_3)
	return var2_0({
		value = arg0_3 or 0
	}, var3_0)
end

function var3_0.Get(arg0_4)
	return arg0_4.value
end

function var3_0.NameToLayer(arg0_5)
	return var0_0[arg0_5]
end

function var3_0.GetMask(...)
	local var0_6 = {
		...
	}
	local var1_6 = 0

	for iter0_6 = 1, #var0_6 do
		local var2_6 = var3_0.NameToLayer(var0_6[iter0_6])

		if var2_6 ~= nil then
			var1_6 = var1_6 + 2^var2_6
		end
	end

	return var1_6
end

UnityEngine.LayerMask = var3_0

var2_0(var3_0, var3_0)

return var3_0
