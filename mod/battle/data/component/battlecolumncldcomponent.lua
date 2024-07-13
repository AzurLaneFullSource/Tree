ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleColumnCldComponent", var0_0.Battle.BattleCldComponent)

var0_0.Battle.BattleColumnCldComponent = var1_0
var1_0.__name = "BattleColumnCldComponent"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.Battle.BattleColumnCldComponent.super.Ctor(arg0_1)

	arg0_1._range = arg1_1 * 0.5
	arg0_1._tickness = arg2_1 * 0.5
	arg0_1._box = pg.CldNode.New()
end

function var1_0.GetCldBox(arg0_2, arg1_2)
	return arg0_2._box:UpdateCylinder(arg1_2, arg0_2._tickness, arg0_2._range)
end

function var1_0.GetCldBoxSize(arg0_3)
	return {
		range = arg0_3._range,
		tickness = arg0_3._tickness
	}
end
