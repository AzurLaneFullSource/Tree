local var0_0 = class("CourtYardCalcUtil")
local var1_0 = 78.2
local var2_0 = 39

function var0_0.Screen2Local(arg0_1, arg1_1)
	local var0_1 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_1 = arg0_1:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1_1, arg1_1, var0_1))
end

function var0_0.Map2Local(arg0_2)
	local var0_2 = (arg0_2.x - arg0_2.y) * (var1_0 / 2)
	local var1_2 = (arg0_2.x + arg0_2.y) * (var2_0 / 2)

	return Vector2(var0_2, var1_2)
end

function var0_0.Local2Map(arg0_3)
	local var0_3 = math.floor(arg0_3.x / var1_0 + arg0_3.y / var2_0)
	local var1_3 = math.floor(arg0_3.y / var2_0 - arg0_3.x / var1_0)

	return Vector2(var0_3, var1_3)
end

function var0_0.World2Local(arg0_4, arg1_4)
	local var0_4 = arg0_4:InverseTransformPoint(arg1_4)

	return Vector3(var0_4.x, var0_4.y, 0)
end

function var0_0.local2RelativeLocal(arg0_5, arg1_5, arg2_5)
	return arg0_5 + var0_0.Map2Local(Vector2(arg1_5, arg2_5))
end

function var0_0.TrPosition2LocalPos(arg0_6, arg1_6, arg2_6)
	if arg0_6 == arg1_6 then
		return arg2_6
	else
		local var0_6 = arg0_6:TransformPoint(arg2_6)
		local var1_6 = arg1_6:InverseTransformPoint(var0_6)

		return Vector3(var1_6.x, var1_6.y, 0)
	end
end

function var0_0.IsHappen(arg0_7)
	return arg0_7 >= math.random(0, 100)
end

function var0_0.HalfProbability()
	return var0_0.IsHappen(50)
end

function var0_0.GetSign(arg0_9)
	if arg0_9 <= 0 then
		return -1
	else
		return 1
	end
end

function var0_0.GetTransformSign(arg0_10, arg1_10)
	local var0_10 = arg0_10
	local var1_10 = arg1_10.localScale.x * arg0_10.localScale.x

	while var0_10.parent ~= arg1_10 do
		var0_10 = var0_10.parent
		var1_10 = var1_10 * var0_10.localScale.x
	end

	return var0_0.GetSign(var1_10)
end

return var0_0
