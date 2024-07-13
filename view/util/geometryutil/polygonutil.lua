local var0_0 = {}
local var1_0 = import(".SegmentUtil")
local var2_0 = UnityEngine.Vector2
local var3_0 = 1e-06

local function var4_0(arg0_1, arg1_1)
	return (arg0_1 - 1) % arg1_1 + 1
end

local function var5_0(arg0_2, arg1_2)
	local var0_2 = 0
	local var1_2 = #arg1_2

	for iter0_2 = 0, var1_2 do
		local var2_2 = arg1_2[var4_0(iter0_2)]
		local var3_2 = arg1_2[var4_0(iter0_2 + 1)]

		if (var2_2.y <= arg0_2.y and var3_2.y - var3_0 > arg0_2.y or var3_2.y <= arg0_2.y and var2_2.y - var3_0 > arg0_2.y) and (var2_2.x >= arg0_2.x or var3_2.x >= arg0_2.x) and arg0_2.x + var3_0 < var2_2.x + (arg0_2.y - var2_2.y) / (var3_2.y - var2_2.y) * (var3_2.x - var2_2.x) then
			var0_2 = var0_2 + 1
		end
	end

	return var0_2
end

local function var6_0(arg0_3, arg1_3)
	local var0_3 = var5_0(arg0_3, arg1_3)

	return bit.band(var0_3, 1) > 0
end

local function var7_0(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = var1_0.VectorCross(arg0_4, arg2_4, arg3_4)
	local var1_4 = var1_0.VectorCross(arg0_4, arg2_4, arg1_4)
	local var2_4 = var1_0.VectorCross(arg0_4, arg1_4, arg3_4)

	if var1_0.IsZero(var0_4) then
		return var1_4 <= var1_0.eps or var2_4 <= var1_0.eps
	else
		return var1_4 <= var1_0.eps and var2_4 <= var1_0.eps
	end
end

local function var8_0(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	local var0_5 = arg4_5

	while var0_5 ~= arg5_5 do
		local var1_5 = var4_0(var0_5 + 1, #arg3_5)

		if var1_0.IsSegamentCross(arg0_5, arg1_5, arg2_5[arg3_5[var0_5]], arg2_5[arg3_5[var1_5]]) then
			return true
		end

		var0_5 = var1_5
	end

	return false
end

local function var9_0(arg0_6)
	if #arg0_6 < 4 then
		return {
			0,
			1,
			2
		}
	end

	local var0_6 = {}
	local var1_6 = {}
	local var2_6 = {}

	for iter0_6 = 1, #arg0_6 do
		local var3_6 = var1_0.CycleIndex(iter0_6 + 2)

		table.insert(var1_6, iter0_6)
		table.insert(var2_6, {
			iter0_6,
			Vector2.Distance(arg0_6[iter0_6], arg0_6[var3_6])
		})
	end

	local function var4_6(arg0_7, arg1_7)
		return arg0_7[2] < arg1_7[2]
	end

	table.sort(var2_6, var4_6)

	while #var1_6 > 2 and #var2_6 > 0 do
		local var5_6 = var2_6[1][1]
		local var6_6 = table.indexof(var1_6, var5_6)
		local var7_6 = var4_0(var6_6 + 1, #var1_6)
		local var8_6 = var4_0(var6_6 + 2, #var1_6)
		local var9_6 = var1_6[var7_6]
		local var10_6 = var1_6[var8_6]

		if var1_0.VectorCross(arg0_6[var5_6], arg0_6[var10_6], arg0_6[var9_6]) > 0 and not var8_0(arg0_6[var5_6], arg0_6[var10_6], arg0_6, var1_6, var8_6, var6_6) then
			table.insert(var0_6, var5_6)
			table.insert(var0_6, var9_6)
			table.insert(var0_6, var10_6)

			local var11_6 = var1_6[var4_0(var6_6 - 1, #var1_6)]
			local var12_6 = var1_6[var4_0(var8_6 + 1, #var1_6)]

			for iter1_6 = #var2_6, 1, -1 do
				local var13_6 = var2_6[iter1_6][1]

				if var13_6 == var9_6 or var13_6 == var11_6 then
					table.remove(var2_6, iter1_6)
				end
			end

			table.insert(var2_6, {
				var11_6,
				Vector2.Distance(arg0_6[var11_6], arg0_6[var10_6])
			})
			table.insert(var2_6, {
				var5_6,
				Vector2.Distance(arg0_6[var5_6], arg0_6[var12_6])
			})
			table.remove(var1_6, var9_6)
			table.sort(var2_6, var4_6)
		end

		table.remove(var2_6, 1)
	end

	return var0_6
end

local function var10_0(arg0_8)
	local var0_8 = #arg0_8

	if var0_8 < 3 then
		return 0
	end

	local var1_8 = 0
	local var2_8 = 0

	for iter0_8 = 1, var0_8 do
		local var3_8 = arg0_8[iter0_8]
		local var4_8 = arg0_8[var4_0(iter0_8 + 1, var0_8)]

		var1_8 = var1_8 + var3_8.x * var4_8.y
		var2_8 = var2_8 + var3_8.y * var4_8.x
	end

	return (var1_8 - var2_8) / 2
end

local function var11_0(arg0_9)
	local var0_9 = var10_0(arg0_9)

	return var1_0.Sign(var0_9)
end

var0_0.CycleIndex = var4_0
var0_0.RayCross = var5_0
var0_0.Contains = var6_0
var0_0.IsPointInAngle = var7_0
var0_0.IsCrossAnyEdge = var8_0
var0_0.Triangulated = var9_0
var0_0.CalculateArea = var10_0
var0_0.IsPolygonClockwise = var11_0

return var0_0
