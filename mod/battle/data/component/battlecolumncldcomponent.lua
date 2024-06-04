ys = ys or {}

local var0 = ys
local var1 = class("BattleColumnCldComponent", var0.Battle.BattleCldComponent)

var0.Battle.BattleColumnCldComponent = var1
var1.__name = "BattleColumnCldComponent"

function var1.Ctor(arg0, arg1, arg2)
	var0.Battle.BattleColumnCldComponent.super.Ctor(arg0)

	arg0._range = arg1 * 0.5
	arg0._tickness = arg2 * 0.5
	arg0._box = pg.CldNode.New()
end

function var1.GetCldBox(arg0, arg1)
	return arg0._box:UpdateCylinder(arg1, arg0._tickness, arg0._range)
end

function var1.GetCldBoxSize(arg0)
	return {
		range = arg0._range,
		tickness = arg0._tickness
	}
end
