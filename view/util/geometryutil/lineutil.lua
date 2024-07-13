local var0_0 = {}
local var1_0 = import(".SegmentUtil")
local var2_0 = 1e-06

local function var3_0(arg0_1, arg1_1)
	local var0_1 = arg1_1 - arg0_1
	local var1_1 = arg0_1.x * var0_1.y - arg0_1.y * var0_1.x

	return {
		a = -var0_1.y,
		b = var0_1.x,
		c = var1_1
	}
end

var0_0.GetVerticalCrossPoint, var0_0.TwoPointToCommon = function(arg0_2, arg1_2, arg2_2)
	local var0_2 = var3_0(arg0_2, arg1_2)
	local var1_2 = var0_2.b * arg2_2.x - var0_2.a * arg2_2.y
	local var2_2 = (var0_2.b * var1_2 - var0_2.a * var0_2.c) / (var0_2.a * var0_2.a + var0_2.b * var0_2.b)
	local var3_2

	if var1_0.IsZero(var0_2.b) then
		var3_2 = (var0_2.x * var2_2 + var0_2.c) / -var0_2.b
	else
		var3_2 = arg0_2.y
	end

	return Vector2(var2_2, var3_2)
end, var3_0

return var0_0
