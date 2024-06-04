local var0 = class("CourtYardCalcUtil")
local var1 = 78.2
local var2 = 39

function var0.Screen2Local(arg0, arg1)
	local var0 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1 = arg0:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1, arg1, var0))
end

function var0.Map2Local(arg0)
	local var0 = (arg0.x - arg0.y) * (var1 / 2)
	local var1 = (arg0.x + arg0.y) * (var2 / 2)

	return Vector2(var0, var1)
end

function var0.Local2Map(arg0)
	local var0 = math.floor(arg0.x / var1 + arg0.y / var2)
	local var1 = math.floor(arg0.y / var2 - arg0.x / var1)

	return Vector2(var0, var1)
end

function var0.World2Local(arg0, arg1)
	local var0 = arg0:InverseTransformPoint(arg1)

	return Vector3(var0.x, var0.y, 0)
end

function var0.local2RelativeLocal(arg0, arg1, arg2)
	return arg0 + var0.Map2Local(Vector2(arg1, arg2))
end

function var0.TrPosition2LocalPos(arg0, arg1, arg2)
	if arg0 == arg1 then
		return arg2
	else
		local var0 = arg0:TransformPoint(arg2)
		local var1 = arg1:InverseTransformPoint(var0)

		return Vector3(var1.x, var1.y, 0)
	end
end

function var0.IsHappen(arg0)
	return arg0 >= math.random(0, 100)
end

function var0.HalfProbability()
	return var0.IsHappen(50)
end

function var0.GetSign(arg0)
	if arg0 <= 0 then
		return -1
	else
		return 1
	end
end

function var0.GetTransformSign(arg0, arg1)
	local var0 = arg0
	local var1 = arg1.localScale.x * arg0.localScale.x

	while var0.parent ~= arg1 do
		var0 = var0.parent
		var1 = var1 * var0.localScale.x
	end

	return var0.GetSign(var1)
end

return var0
