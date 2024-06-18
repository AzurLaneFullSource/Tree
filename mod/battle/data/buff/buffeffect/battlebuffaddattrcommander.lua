ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAddAttrCommander", var0_0.Battle.BattleBuffAddAttr)

var0_0.Battle.BattleBuffAddAttrCommander = var1_0
var1_0.__name = "BattleBuffAddAttrCommander"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectType(arg0_2)
	return var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._group = arg0_3._tempData.arg_list.group or arg2_3:GetID()
	arg0_3._attr = arg0_3._tempData.arg_list.convertAttr

	local var0_3 = arg0_3._tempData.arg_list.ability
	local var1_3 = arg0_3._tempData.arg_list.convertRate

	arg0_3._number = arg0_3._commander:getAbilitys()[var0_3].value * var1_3
	arg0_3._numberBase = arg0_3._number
end
