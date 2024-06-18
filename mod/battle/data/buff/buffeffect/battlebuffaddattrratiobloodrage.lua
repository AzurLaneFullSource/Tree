ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAddAttrRatioBloodrage", var0_0.Battle.BattleBuffAddAttr)

var0_0.Battle.BattleBuffAddAttrRatioBloodrage = var1_0
var1_0.__name = "BattleBuffAddAttrRatioBloodrage"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectType(arg0_2)
	return var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._group = arg0_3._tempData.arg_list.group or arg2_3:GetID()
	arg0_3._attr = arg0_3._tempData.arg_list.attr
	arg0_3._threshold = arg0_3._tempData.arg_list.threshold
	arg0_3._value = arg0_3._tempData.arg_list.value
	arg0_3._attrBound = arg0_3._tempData.arg_list.attrBound
	arg0_3._number = 0
end

function var1_0.doOnHPRatioUpdate(arg0_4, arg1_4, arg2_4)
	arg0_4:UpdateAttr(arg1_4)
end

function var1_0.calcBloodRageNumber(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetHPRate()

	if var0_5 > arg0_5._threshold then
		arg0_5._number = 0
	else
		local var1_5 = var0_0.Battle.BattleAttr.GetBase(arg1_5, arg0_5._attr)

		arg0_5._number = (arg0_5._threshold - var0_5) / arg0_5._value * var1_5 * 0.0001

		if arg0_5._attrBound then
			arg0_5._number = math.min(arg0_5._number, arg0_5._attrBound)
		end
	end
end

function var1_0.doOnHPRatioUpdate(arg0_6, arg1_6, arg2_6)
	arg0_6:calcBloodRageNumber(arg1_6)
	arg0_6:UpdateAttr(arg1_6)
end

function var1_0.onRemove(arg0_7, arg1_7, arg2_7)
	arg0_7._number = 0

	arg0_7:UpdateAttr(arg1_7)
end
