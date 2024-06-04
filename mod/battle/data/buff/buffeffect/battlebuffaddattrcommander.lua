ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAddAttrCommander", var0.Battle.BattleBuffAddAttr)

var0.Battle.BattleBuffAddAttrCommander = var1
var1.__name = "BattleBuffAddAttrCommander"

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

	arg0._number = arg0._commander:getAbilitys()[var0].value * var1
	arg0._numberBase = arg0._number
end
