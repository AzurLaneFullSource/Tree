ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleCubeCldComponent", var0_0.Battle.BattleCldComponent)

var0_0.Battle.BattleCubeCldComponent = var1_0
var1_0.__name = "BattleCubeCldComponent"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	var0_0.Battle.BattleCubeCldComponent.super.Ctor(arg0_1)

	arg0_1._offsetX = arg4_1
	arg0_1._offsetZ = arg5_1
	arg0_1._offset = Vector3(arg4_1, 0, arg5_1)
	arg0_1._boxSize = Vector3.zero
	arg0_1._min = Vector3.zero
	arg0_1._max = Vector3.zero

	arg0_1:ResetSize(arg1_1, arg2_1, arg3_1)

	arg0_1._box = pg.CldNode.New()
end

function var1_0.ResetSize(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg1_2 * 0.5
	local var1_2 = arg2_2 * 0.5
	local var2_2 = arg3_2 * 0.5

	arg0_2._boxSize.x = var0_2
	arg0_2._boxSize.y = var1_2
	arg0_2._boxSize.z = var2_2
	arg0_2._min.x = arg0_2._offsetX - var0_2
	arg0_2._min.y = -var1_2
	arg0_2._min.z = arg0_2._offsetZ - var2_2
	arg0_2._max.x = arg0_2._offsetX + var0_2
	arg0_2._max.y = var1_2
	arg0_2._max.z = arg0_2._offsetZ + var2_2
end

function var1_0.GetCldBox(arg0_3, arg1_3)
	if arg1_3 then
		arg0_3._cldData.LeftBound = arg1_3.x - math.abs(arg0_3._min.x)
		arg0_3._cldData.RightBound = arg1_3.x + math.abs(arg0_3._max.x)
		arg0_3._cldData.LowerBound = arg1_3.z - math.abs(arg0_3._min.z)
		arg0_3._cldData.UpperBound = arg1_3.z + math.abs(arg0_3._max.z)
	end

	return arg0_3._box:UpdateBox(arg0_3._min, arg0_3._max, arg1_3)
end

function var1_0.GetCldBoxSize(arg0_4)
	return arg0_4._boxSize
end
