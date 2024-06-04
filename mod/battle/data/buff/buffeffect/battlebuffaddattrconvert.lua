ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAddAttrConvert", var0.Battle.BattleBuffAddAttr)

var0.Battle.BattleBuffAddAttrConvert = var1
var1.__name = "BattleBuffAddAttrConvert"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.GetEffectType(arg0)
	return var0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._group = arg0._tempData.arg_list.group or arg2:GetID()
	arg0._attr = arg0._tempData.arg_list.attr
	arg0._convertAttr = arg0._tempData.arg_list.convertAttr
	arg0._convertAttrValue = var0.Battle.BattleAttr.GetBase(arg1, arg0._convertAttr)
	arg0._convertRate = arg0._tempData.arg_list.convertRate
	arg0._number = (arg0._tempData.arg_list.number or 0) + arg0._convertAttrValue * arg0._convertRate
	arg0._numberBase = arg0._number
end
