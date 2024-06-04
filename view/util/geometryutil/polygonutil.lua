local var0 = {}
local var1 = import(".SegmentUtil")
local var2 = UnityEngine.Vector2
local var3 = 1e-06

local function var4(arg0, arg1)
	return (arg0 - 1) % arg1 + 1
end

local function var5(arg0, arg1)
	local var0 = 0
	local var1 = #arg1

	for iter0 = 0, var1 do
		local var2 = arg1[var4(iter0)]
		local var3 = arg1[var4(iter0 + 1)]

		if (var2.y <= arg0.y and var3.y - var3 > arg0.y or var3.y <= arg0.y and var2.y - var3 > arg0.y) and (var2.x >= arg0.x or var3.x >= arg0.x) and arg0.x + var3 < var2.x + (arg0.y - var2.y) / (var3.y - var2.y) * (var3.x - var2.x) then
			var0 = var0 + 1
		end
	end

	return var0
end

local function var6(arg0, arg1)
	local var0 = var5(arg0, arg1)

	return bit.band(var0, 1) > 0
end

local function var7(arg0, arg1, arg2, arg3)
	local var0 = var1.VectorCross(arg0, arg2, arg3)
	local var1 = var1.VectorCross(arg0, arg2, arg1)
	local var2 = var1.VectorCross(arg0, arg1, arg3)

	if var1.IsZero(var0) then
		return var1 <= var1.eps or var2 <= var1.eps
	else
		return var1 <= var1.eps and var2 <= var1.eps
	end
end

local function var8(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg4

	while var0 ~= arg5 do
		local var1 = var4(var0 + 1, #arg3)

		if var1.IsSegamentCross(arg0, arg1, arg2[arg3[var0]], arg2[arg3[var1]]) then
			return true
		end

		var0 = var1
	end

	return false
end

local function var9(arg0)
	if #arg0 < 4 then
		return {
			0,
			1,
			2
		}
	end

	local var0 = {}
	local var1 = {}
	local var2 = {}

	for iter0 = 1, #arg0 do
		local var3 = var1.CycleIndex(iter0 + 2)

		table.insert(var1, iter0)
		table.insert(var2, {
			iter0,
			Vector2.Distance(arg0[iter0], arg0[var3])
		})
	end

	local function var4(arg0, arg1)
		return arg0[2] < arg1[2]
	end

	table.sort(var2, var4)

	while #var1 > 2 and #var2 > 0 do
		local var5 = var2[1][1]
		local var6 = table.indexof(var1, var5)
		local var7 = var4(var6 + 1, #var1)
		local var8 = var4(var6 + 2, #var1)
		local var9 = var1[var7]
		local var10 = var1[var8]

		if var1.VectorCross(arg0[var5], arg0[var10], arg0[var9]) > 0 and not var8(arg0[var5], arg0[var10], arg0, var1, var8, var6) then
			table.insert(var0, var5)
			table.insert(var0, var9)
			table.insert(var0, var10)

			local var11 = var1[var4(var6 - 1, #var1)]
			local var12 = var1[var4(var8 + 1, #var1)]

			for iter1 = #var2, 1, -1 do
				local var13 = var2[iter1][1]

				if var13 == var9 or var13 == var11 then
					table.remove(var2, iter1)
				end
			end

			table.insert(var2, {
				var11,
				Vector2.Distance(arg0[var11], arg0[var10])
			})
			table.insert(var2, {
				var5,
				Vector2.Distance(arg0[var5], arg0[var12])
			})
			table.remove(var1, var9)
			table.sort(var2, var4)
		end

		table.remove(var2, 1)
	end

	return var0
end

local function var10(arg0)
	local var0 = #arg0

	if var0 < 3 then
		return 0
	end

	local var1 = 0
	local var2 = 0

	for iter0 = 1, var0 do
		local var3 = arg0[iter0]
		local var4 = arg0[var4(iter0 + 1, var0)]

		var1 = var1 + var3.x * var4.y
		var2 = var2 + var3.y * var4.x
	end

	return (var1 - var2) / 2
end

local function var11(arg0)
	local var0 = var10(arg0)

	return var1.Sign(var0)
end

var0.CycleIndex = var4
var0.RayCross = var5
var0.Contains = var6
var0.IsPointInAngle = var7
var0.IsCrossAnyEdge = var8
var0.Triangulated = var9
var0.CalculateArea = var10
var0.IsPolygonClockwise = var11

return var0
