ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAddAttrRatioCommander", var0.Battle.BattleBuffAddAttrRatio)

var0.Battle.BattleBuffAddAttrRatioCommander = var1
var1.__name = "BattleBuffAddAttrRatioCommander"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.GetEffectType(arg0)
	return var0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._group = arg0._tempData.arg_list.group or arg2:GetID()
	arg0._attr = arg0._tempData.arg_list.convertAttr

	local var0 = arg0._tempData.arg_list.ability
	local var1 = arg0._tempData.arg_list.convertRate

	arg0._number = arg0._commander:getAbilitys()[var0].value * var1 * var0.Battle.BattleAttr.GetBase(arg1, arg0._attr) * 0.0001
	arg0._numberBase = arg0._number
end
