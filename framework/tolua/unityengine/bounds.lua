local var0_0 = rawget
local var1_0 = setmetatable
local var2_0 = type
local var3_0 = Vector3
local var4_0 = var3_0.zero
local var5_0 = {
	center = var3_0.zero,
	extents = var3_0.zero
}
local var6_0 = tolua.initget(var5_0)

function var5_0.__index(arg0_1, arg1_1)
	local var0_1 = var0_0(var5_0, arg1_1)

	if var0_1 == nil then
		var0_1 = var0_0(var6_0, arg1_1)

		if var0_1 ~= nil then
			return var0_1(arg0_1)
		end
	end

	return var0_1
end

function var5_0.__call(arg0_2, arg1_2, arg2_2)
	return var1_0({
		center = arg1_2,
		extents = arg2_2 * 0.5
	}, var5_0)
end

function var5_0.New(arg0_3, arg1_3)
	return var1_0({
		center = arg0_3,
		extents = arg1_3 * 0.5
	}, var5_0)
end

function var5_0.Get(arg0_4)
	local var0_4 = arg0_4:GetSize()

	return arg0_4.center, var0_4
end

function var5_0.GetSize(arg0_5)
	return arg0_5.extents * 2
end

function var5_0.SetSize(arg0_6, arg1_6)
	arg0_6.extents = arg1_6 * 0.5
end

function var5_0.GetMin(arg0_7)
	return arg0_7.center - arg0_7.extents
end

function var5_0.SetMin(arg0_8, arg1_8)
	arg0_8:SetMinMax(arg1_8, arg0_8:GetMax())
end

function var5_0.GetMax(arg0_9)
	return arg0_9.center + arg0_9.extents
end

function var5_0.SetMax(arg0_10, arg1_10)
	arg0_10:SetMinMax(arg0_10:GetMin(), arg1_10)
end

function var5_0.SetMinMax(arg0_11, arg1_11, arg2_11)
	arg0_11.extents = (arg2_11 - arg1_11) * 0.5
	arg0_11.center = arg1_11 + arg0_11.extents
end

function var5_0.Encapsulate(arg0_12, arg1_12)
	arg0_12:SetMinMax(var3_0.Min(arg0_12:GetMin(), arg1_12), var3_0.Max(arg0_12:GetMax(), arg1_12))
end

function var5_0.Expand(arg0_13, arg1_13)
	if var2_0(arg1_13) == "number" then
		arg1_13 = arg1_13 * 0.5

		arg0_13.extents:Add(var3_0.New(arg1_13, arg1_13, arg1_13))
	else
		arg0_13.extents:Add(arg1_13 * 0.5)
	end
end

function var5_0.Intersects(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetMin()
	local var1_14 = arg0_14:GetMax()
	local var2_14 = arg1_14:GetMin()
	local var3_14 = arg1_14:GetMax()

	return var0_14.x <= var3_14.x and var1_14.x >= var2_14.x and var0_14.y <= var3_14.y and var1_14.y >= var2_14.y and var0_14.z <= var3_14.z and var1_14.z >= var2_14.z
end

function var5_0.Contains(arg0_15, arg1_15)
	local var0_15 = arg0_15:GetMin()
	local var1_15 = arg0_15:GetMax()

	if arg1_15.x < var0_15.x or arg1_15.y < var0_15.y or arg1_15.z < var0_15.z or arg1_15.x > var1_15.x or arg1_15.y > var1_15.y or arg1_15.z > var1_15.z then
		return false
	end

	return true
end

function var5_0.IntersectRay(arg0_16, arg1_16)
	local var0_16 = -Mathf.Infinity
	local var1_16 = Mathf.Infinity
	local var2_16
	local var3_16
	local var4_16
	local var5_16 = arg0_16:GetCenter() - arg1_16:GetOrigin()
	local var6_16 = {
		var5_16.x,
		var5_16.y,
		var5_16.z
	}
	local var7_16 = arg0_16.extents
	local var8_16 = {
		var7_16.x,
		var7_16.y,
		var7_16.z
	}
	local var9_16 = arg1_16:GetDirection()
	local var10_16 = {
		var9_16.x,
		var9_16.y,
		var9_16.z
	}

	for iter0_16 = 1, 3 do
		local var11_16 = 1 / var10_16[iter0_16]
		local var12_16 = (var6_16[iter0_16] + var8_16[iter0_16]) * var11_16
		local var13_16 = (var6_16[iter0_16] - var8_16[iter0_16]) * var11_16

		if var12_16 < var13_16 then
			if var0_16 < var12_16 then
				var0_16 = var12_16
			end

			if var13_16 < var1_16 then
				var1_16 = var13_16
			end

			if var1_16 < var0_16 then
				return false
			end

			if var1_16 < 0 then
				return false
			end
		else
			if var0_16 < var13_16 then
				var0_16 = var13_16
			end

			if var12_16 < var1_16 then
				var1_16 = var12_16
			end

			if var1_16 < var0_16 then
				return false
			end

			if var1_16 < 0 then
				return false
			end
		end
	end

	return true, var0_16
end

function var5_0.ClosestPoint(arg0_17, arg1_17)
	local var0_17 = arg1_17 - arg0_17:GetCenter()
	local var1_17 = {
		var0_17.x,
		var0_17.y,
		var0_17.z
	}
	local var2_17 = arg0_17.extents
	local var3_17 = {
		var2_17.x,
		var2_17.y,
		var2_17.z
	}
	local var4_17 = 0
	local var5_17

	for iter0_17 = 1, 3 do
		if var1_17[iter0_17] < -var3_17[iter0_17] then
			local var6_17 = var1_17[iter0_17] + var3_17[iter0_17]

			var4_17 = var4_17 + var6_17 * var6_17
			var1_17[iter0_17] = -var3_17[iter0_17]
		elseif var1_17[iter0_17] > var3_17[iter0_17] then
			local var7_17 = var1_17[iter0_17] - var3_17[iter0_17]

			var4_17 = var4_17 + var7_17 * var7_17
			var1_17[iter0_17] = var3_17[iter0_17]
		end
	end

	if var4_17 == 0 then
		return rkPoint, 0
	else
		outPoint = var1_17 + arg0_17:GetCenter()

		return outPoint, var4_17
	end
end

function var5_0.Destroy(arg0_18)
	arg0_18.center = nil
	arg0_18.size = nil
end

function var5_0.__tostring(arg0_19)
	return string.format("Center: %s, Extents %s", tostring(arg0_19.center), tostring(arg0_19.extents))
end

function var5_0.__eq(arg0_20, arg1_20)
	return arg0_20.center == arg1_20.center and arg0_20.extents == arg1_20.extents
end

var6_0.size = var5_0.GetSize
var6_0.min = var5_0.GetMin
var6_0.max = var5_0.GetMax
UnityEngine.Bounds = var5_0

var1_0(var5_0, var5_0)

return var5_0
