ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleCardPuzzleFleetBuffSetFleetAttr", var0_0.Battle.BattleFleetBuffEffect)

var0_0.Battle.BattleCardPuzzleFleetBuffSetFleetAttr = var1_0
var1_0.__name = "BattleCardPuzzleFleetBuffSetFleetAttr"
var1_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._tempData = Clone(arg1_1)
	arg0_1._type = arg0_1._tempData.type

	arg0_1:SetActive()
end

function var1_0.GetEffectType(arg0_2)
	return var1_0.FX_TYPE
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	var1_0.super.SetArgs(arg0_3, arg1_3, arg2_3)

	arg0_3._group = arg0_3._tempData.arg_list.group or arg0_3._fleetBuff:GetID()
	arg0_3._attr = arg0_3._tempData.arg_list.attr
	arg0_3._number = arg0_3._tempData.arg_list.number

	if arg0_3._tempData.arg_list.enhance_formula then
		local var0_3 = arg0_3._tempData.arg_list.enhance_formula

		arg0_3._number = DBGformula.parseFormula(var0_3, arg1_3:GetAttrManager()) + arg0_3._number
	end

	arg0_3._cache = arg0_3._tempData.arg_list.maintain
	arg0_3._numberBase = arg0_3._number
end

function var1_0.onRemove(arg0_4)
	if arg0_4._cache then
		arg0_4._number = 0
	end

	arg0_4:onTrigger()
end

function var1_0.GetGroup(arg0_5)
	return arg0_5._group
end

function var1_0.GetNumber(arg0_6)
	return arg0_6._number * arg0_6._fleetBuff:GetStack()
end

function var1_0.IsSameAttr(arg0_7, arg1_7)
	return arg0_7._attr == arg1_7
end

function var1_0.onTrigger(arg0_8)
	arg0_8._cardPuzzleComponent:UpdateAttrBySet(arg0_8._attr, arg0_8:GetNumber())
end
