ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAddAttrConvert", var0_0.Battle.BattleBuffAddAttr)

var0_0.Battle.BattleBuffAddAttrConvert = var1_0
var1_0.__name = "BattleBuffAddAttrConvert"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectType(arg0_2)
	return var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._group = arg0_3._tempData.arg_list.group or arg2_3:GetID()
	arg0_3._attr = arg0_3._tempData.arg_list.attr
	arg0_3._convertAttr = arg0_3._tempData.arg_list.convertAttr
	arg0_3._convertAttrValue = var0_0.Battle.BattleAttr.GetBase(arg1_3, arg0_3._convertAttr)
	arg0_3._convertRate = arg0_3._tempData.arg_list.convertRate
	arg0_3._number = (arg0_3._tempData.arg_list.number or 0) + arg0_3._convertAttrValue * arg0_3._convertRate
	arg0_3._numberBase = arg0_3._number
end
