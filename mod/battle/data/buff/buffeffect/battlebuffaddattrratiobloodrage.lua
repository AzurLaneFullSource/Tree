ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAddAttrRatioBloodrage", var0.Battle.BattleBuffAddAttr)

var0.Battle.BattleBuffAddAttrRatioBloodrage = var1
var1.__name = "BattleBuffAddAttrRatioBloodrage"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.GetEffectType(arg0)
	return var0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._group = arg0._tempData.arg_list.group or arg2:GetID()
	arg0._attr = arg0._tempData.arg_list.attr
	arg0._threshold = arg0._tempData.arg_list.threshold
	arg0._value = arg0._tempData.arg_list.value
	arg0._attrBound = arg0._tempData.arg_list.attrBound
	arg0._number = 0
end

function var1.doOnHPRatioUpdate(arg0, arg1, arg2)
	arg0:UpdateAttr(arg1)
end

function var1.calcBloodRageNumber(arg0, arg1)
	local var0 = arg1:GetHPRate()

	if var0 > arg0._threshold then
		arg0._number = 0
	else
		local var1 = var0.Battle.BattleAttr.GetBase(arg1, arg0._attr)

		arg0._number = (arg0._threshold - var0) / arg0._value * var1 * 0.0001

		if arg0._attrBound then
			arg0._number = math.min(arg0._number, arg0._attrBound)
		end
	end
end

function var1.doOnHPRatioUpdate(arg0, arg1, arg2)
	arg0:calcBloodRageNumber(arg1)
	arg0:UpdateAttr(arg1)
end

function var1.onRemove(arg0, arg1, arg2)
	arg0._number = 0

	arg0:UpdateAttr(arg1)
end
