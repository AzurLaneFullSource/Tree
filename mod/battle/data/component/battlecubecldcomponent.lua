ys = ys or {}

local var0 = ys
local var1 = class("BattleCubeCldComponent", var0.Battle.BattleCldComponent)

var0.Battle.BattleCubeCldComponent = var1
var1.__name = "BattleCubeCldComponent"

function var1.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	var0.Battle.BattleCubeCldComponent.super.Ctor(arg0)

	arg0._offsetX = arg4
	arg0._offsetZ = arg5
	arg0._offset = Vector3(arg4, 0, arg5)
	arg0._boxSize = Vector3.zero
	arg0._min = Vector3.zero
	arg0._max = Vector3.zero

	arg0:ResetSize(arg1, arg2, arg3)

	arg0._box = pg.CldNode.New()
end

function var1.ResetSize(arg0, arg1, arg2, arg3)
	local var0 = arg1 * 0.5
	local var1 = arg2 * 0.5
	local var2 = arg3 * 0.5

	arg0._boxSize.x = var0
	arg0._boxSize.y = var1
	arg0._boxSize.z = var2
	arg0._min.x = arg0._offsetX - var0
	arg0._min.y = -var1
	arg0._min.z = arg0._offsetZ - var2
	arg0._max.x = arg0._offsetX + var0
	arg0._max.y = var1
	arg0._max.z = arg0._offsetZ + var2
end

function var1.GetCldBox(arg0, arg1)
	if arg1 then
		arg0._cldData.LeftBound = arg1.x - math.abs(arg0._min.x)
		arg0._cldData.RightBound = arg1.x + math.abs(arg0._max.x)
		arg0._cldData.LowerBound = arg1.z - math.abs(arg0._min.z)
		arg0._cldData.UpperBound = arg1.z + math.abs(arg0._max.z)
	end

	return arg0._box:UpdateBox(arg0._min, arg0._max, arg1)
end

function var1.GetCldBoxSize(arg0)
	return arg0._boxSize
end
