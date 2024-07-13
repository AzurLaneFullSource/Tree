ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAddAttrRatio", var0_0.Battle.BattleBuffAddAttr)

var0_0.Battle.BattleBuffAddAttrRatio = var1_0
var1_0.__name = "BattleBuffAddAttrRatio"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectType(arg0_2)
	return var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._group = arg0_3._tempData.arg_list.group or arg2_3:GetID()
	arg0_3._attr = arg0_3._tempData.arg_list.attr
	arg0_3._attrBound = arg0_3._tempData.arg_list.attrBound

	local var0_3 = arg0_3._tempData.arg_list.convertAttr or arg0_3._attr
	local var1_3 = var0_0.Battle.BattleAttr.GetBase(arg1_3, var0_3)

	arg0_3._number = arg0_3._tempData.arg_list.number * var1_3 * 0.0001
	arg0_3._numberBase = arg0_3._number

	if arg0_3._attrBound then
		arg0_3._numberBase = math.min(arg0_3._numberBase, arg0_3._attrBound)
	end

	arg0_3._attrID = arg0_3._tempData.arg_list.attr_group_ID
end
