ys = ys or {}

local var0 = ys
local var1 = class("BattleCardPuzzleFleetBuffSetFleetAttr", var0.Battle.BattleFleetBuffEffect)

var0.Battle.BattleCardPuzzleFleetBuffSetFleetAttr = var1
var1.__name = "BattleCardPuzzleFleetBuffSetFleetAttr"
var1.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR

function var1.Ctor(arg0, arg1)
	arg0._tempData = Clone(arg1)
	arg0._type = arg0._tempData.type

	arg0:SetActive()
end

function var1.GetEffectType(arg0)
	return var1.FX_TYPE
end

function var1.SetArgs(arg0, arg1, arg2)
	var1.super.SetArgs(arg0, arg1, arg2)

	arg0._group = arg0._tempData.arg_list.group or arg0._fleetBuff:GetID()
	arg0._attr = arg0._tempData.arg_list.attr
	arg0._number = arg0._tempData.arg_list.number

	if arg0._tempData.arg_list.enhance_formula then
		local var0 = arg0._tempData.arg_list.enhance_formula

		arg0._number = DBGformula.parseFormula(var0, arg1:GetAttrManager()) + arg0._number
	end

	arg0._cache = arg0._tempData.arg_list.maintain
	arg0._numberBase = arg0._number
end

function var1.onRemove(arg0)
	if arg0._cache then
		arg0._number = 0
	end

	arg0:onTrigger()
end

function var1.GetGroup(arg0)
	return arg0._group
end

function var1.GetNumber(arg0)
	return arg0._number * arg0._fleetBuff:GetStack()
end

function var1.IsSameAttr(arg0, arg1)
	return arg0._attr == arg1
end

function var1.onTrigger(arg0)
	arg0._cardPuzzleComponent:UpdateAttrBySet(arg0._attr, arg0:GetNumber())
end
