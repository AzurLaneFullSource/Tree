local var0 = rawget
local var1 = setmetatable
local var2 = type
local var3 = Vector3
local var4 = var3.zero
local var5 = {
	center = var3.zero,
	extents = var3.zero
}
local var6 = tolua.initget(var5)

function var5.__index(arg0, arg1)
	local var0 = var0(var5, arg1)

	if var0 == nil then
		var0 = var0(var6, arg1)

		if var0 ~= nil then
			return var0(arg0)
		end
	end

	return var0
end

function var5.__call(arg0, arg1, arg2)
	return var1({
		center = arg1,
		extents = arg2 * 0.5
	}, var5)
end

function var5.New(arg0, arg1)
	return var1({
		center = arg0,
		extents = arg1 * 0.5
	}, var5)
end

function var5.Get(arg0)
	local var0 = arg0:GetSize()

	return arg0.center, var0
end

function var5.GetSize(arg0)
	return arg0.extents * 2
end

function var5.SetSize(arg0, arg1)
	arg0.extents = arg1 * 0.5
end

function var5.GetMin(arg0)
	return arg0.center - arg0.extents
end

function var5.SetMin(arg0, arg1)
	arg0:SetMinMax(arg1, arg0:GetMax())
end

function var5.GetMax(arg0)
	return arg0.center + arg0.extents
end

function var5.SetMax(arg0, arg1)
	arg0:SetMinMax(arg0:GetMin(), arg1)
end

function var5.SetMinMax(arg0, arg1, arg2)
	arg0.extents = (arg2 - arg1) * 0.5
	arg0.center = arg1 + arg0.extents
end

function var5.Encapsulate(arg0, arg1)
	arg0:SetMinMax(var3.Min(arg0:GetMin(), arg1), var3.Max(arg0:GetMax(), arg1))
end

function var5.Expand(arg0, arg1)
	if var2(arg1) == "number" then
		arg1 = arg1 * 0.5

		arg0.extents:Add(var3.New(arg1, arg1, arg1))
	else
		arg0.extents:Add(arg1 * 0.5)
	end
end

function var5.Intersects(arg0, arg1)
	local var0 = arg0:GetMin()
	local var1 = arg0:GetMax()
	local var2 = arg1:GetMin()
	local var3 = arg1:GetMax()

	return var0.x <= var3.x and var1.x >= var2.x and var0.y <= var3.y and var1.y >= var2.y and var0.z <= var3.z and var1.z >= var2.z
end

function var5.Contains(arg0, arg1)
	local var0 = arg0:GetMin()
	local var1 = arg0:GetMax()

	if arg1.x < var0.x or arg1.y < var0.y or arg1.z < var0.z or arg1.x > var1.x or arg1.y > var1.y or arg1.z > var1.z then
		return false
	end

	return true
end

function var5.IntersectRay(arg0, arg1)
	local var0 = -Mathf.Infinity
	local var1 = Mathf.Infinity
	local var2
	local var3
	local var4
	local var5 = arg0:GetCenter() - arg1:GetOrigin()
	local var6 = {
		var5.x,
		var5.y,
		var5.z
	}
	local var7 = arg0.extents
	local var8 = {
		var7.x,
		var7.y,
		var7.z
	}
	local var9 = arg1:GetDirection()
	local var10 = {
		var9.x,
		var9.y,
		var9.z
	}

	for iter0 = 1, 3 do
		local var11 = 1 / var10[iter0]
		local var12 = (var6[iter0] + var8[iter0]) * var11
		local var13 = (var6[iter0] - var8[iter0]) * var11

		if var12 < var13 then
			if var0 < var12 then
				var0 = var12
			end

			if var13 < var1 then
				var1 = var13
			end

			if var1 < var0 then
				return false
			end

			if var1 < 0 then
				return false
			end
		else
			if var0 < var13 then
				var0 = var13
			end

			if var12 < var1 then
				var1 = var12
			end

			if var1 < var0 then
				return false
			end

			if var1 < 0 then
				return false
			end
		end
	end

	return true, var0
end

function var5.ClosestPoint(arg0, arg1)
	local var0 = arg1 - arg0:GetCenter()
	local var1 = {
		var0.x,
		var0.y,
		var0.z
	}
	local var2 = arg0.extents
	local var3 = {
		var2.x,
		var2.y,
		var2.z
	}
	local var4 = 0
	local var5

	for iter0 = 1, 3 do
		if var1[iter0] < -var3[iter0] then
			local var6 = var1[iter0] + var3[iter0]

			var4 = var4 + var6 * var6
			var1[iter0] = -var3[iter0]
		elseif var1[iter0] > var3[iter0] then
			local var7 = var1[iter0] - var3[iter0]

			var4 = var4 + var7 * var7
			var1[iter0] = var3[iter0]
		end
	end

	if var4 == 0 then
		return rkPoint, 0
	else
		outPoint = var1 + arg0:GetCenter()

		return outPoint, var4
	end
end

function var5.Destroy(arg0)
	arg0.center = nil
	arg0.size = nil
end

function var5.__tostring(arg0)
	return string.format("Center: %s, Extents %s", tostring(arg0.center), tostring(arg0.extents))
end

function var5.__eq(arg0, arg1)
	return arg0.center == arg1.center and arg0.extents == arg1.extents
end

var6.size = var5.GetSize
var6.min = var5.GetMin
var6.max = var5.GetMax
UnityEngine.Bounds = var5

var1(var5, var5)

return var5
