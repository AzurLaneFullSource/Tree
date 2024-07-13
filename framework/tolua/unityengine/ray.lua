local var0_0 = rawget
local var1_0 = setmetatable
local var2_0 = Vector3
local var3_0 = {
	direction = var2_0.zero,
	origin = var2_0.zero
}
local var4_0 = tolua.initget(var3_0)

function var3_0.__index(arg0_1, arg1_1)
	local var0_1 = var0_0(var3_0, arg1_1)

	if var0_1 == nil then
		var0_1 = var0_0(var4_0, arg1_1)

		if var0_1 ~= nil then
			return var0_1(arg0_1)
		end
	end

	return var0_1
end

function var3_0.__call(arg0_2, arg1_2, arg2_2)
	return var3_0.New(arg1_2, arg2_2)
end

function var3_0.New(arg0_3, arg1_3)
	local var0_3 = {
		direction = arg0_3:Normalize(),
		origin = arg1_3
	}

	var1_0(var0_3, var3_0)

	return var0_3
end

function var3_0.GetPoint(arg0_4, arg1_4)
	local var0_4 = arg0_4.direction * arg1_4

	var0_4:Add(arg0_4.origin)

	return var0_4
end

function var3_0.Get(arg0_5)
	local var0_5 = arg0_5.origin
	local var1_5 = arg0_5.direction

	return var0_5.x, var0_5.y, var0_5.z, var1_5.x, var1_5.y, var1_5.z
end

function var3_0.__tostring(arg0_6)
	return string.format("Origin:(%f,%f,%f),Dir:(%f,%f, %f)", arg0_6.origin.x, arg0_6.origin.y, arg0_6.origin.z, arg0_6.direction.x, arg0_6.direction.y, arg0_6.direction.z)
end

UnityEngine.Ray = var3_0

var1_0(var3_0, var3_0)

return var3_0
