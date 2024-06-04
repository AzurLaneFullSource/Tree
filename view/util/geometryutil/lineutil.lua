local var0 = {}
local var1 = import(".SegmentUtil")
local var2 = 1e-06

local function var3(arg0, arg1)
	local var0 = arg1 - arg0
	local var1 = arg0.x * var0.y - arg0.y * var0.x

	return {
		a = -var0.y,
		b = var0.x,
		c = var1
	}
end

var0.GetVerticalCrossPoint, var0.TwoPointToCommon = function(arg0, arg1, arg2)
	local var0 = var3(arg0, arg1)
	local var1 = var0.b * arg2.x - var0.a * arg2.y
	local var2 = (var0.b * var1 - var0.a * var0.c) / (var0.a * var0.a + var0.b * var0.b)
	local var3

	if var1.IsZero(var0.b) then
		var3 = (var0.x * var2 + var0.c) / -var0.b
	else
		var3 = arg0.y
	end

	return Vector2(var2, var3)
end, var3

return var0
