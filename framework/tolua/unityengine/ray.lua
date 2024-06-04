local var0 = rawget
local var1 = setmetatable
local var2 = Vector3
local var3 = {
	direction = var2.zero,
	origin = var2.zero
}
local var4 = tolua.initget(var3)

function var3.__index(arg0, arg1)
	local var0 = var0(var3, arg1)

	if var0 == nil then
		var0 = var0(var4, arg1)

		if var0 ~= nil then
			return var0(arg0)
		end
	end

	return var0
end

function var3.__call(arg0, arg1, arg2)
	return var3.New(arg1, arg2)
end

function var3.New(arg0, arg1)
	local var0 = {
		direction = arg0:Normalize(),
		origin = arg1
	}

	var1(var0, var3)

	return var0
end

function var3.GetPoint(arg0, arg1)
	local var0 = arg0.direction * arg1

	var0:Add(arg0.origin)

	return var0
end

function var3.Get(arg0)
	local var0 = arg0.origin
	local var1 = arg0.direction

	return var0.x, var0.y, var0.z, var1.x, var1.y, var1.z
end

function var3.__tostring(arg0)
	return string.format("Origin:(%f,%f,%f),Dir:(%f,%f, %f)", arg0.origin.x, arg0.origin.y, arg0.origin.z, arg0.direction.x, arg0.direction.y, arg0.direction.z)
end

UnityEngine.Ray = var3

var1(var3, var3)

return var3
