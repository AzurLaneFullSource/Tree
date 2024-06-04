ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAddAttrRatio", var0.Battle.BattleBuffAddAttr)

var0.Battle.BattleBuffAddAttrRatio = var1
var1.__name = "BattleBuffAddAttrRatio"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.GetEffectType(arg0)
	return var0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._group = arg0._tempData.arg_list.group or arg2:GetID()
	arg0._attr = arg0._tempData.arg_list.attr
	arg0._attrBound = arg0._tempData.arg_list.attrBound

	local var0 = arg0._tempData.arg_list.convertAttr or arg0._attr
	local var1 = var0.Battle.BattleAttr.GetBase(arg1, var0)

	if not arg0._tempData.arg_list.gurantee then
		local var2 = 0
	end

	arg0._number = arg0._tempData.arg_list.number * var1 * 0.0001
	arg0._numberBase = arg0._number

	if arg0._attrBound then
		arg0._numberBase = math.min(arg0._numberBase, arg0._attrBound)
	end

	arg0._attrID = arg0._tempData.arg_list.attr_group_ID
end
