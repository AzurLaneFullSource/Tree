ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleCardPuzzleFormulas
local var2 = class("BattleCardPuzzleFleetBuffAddFleetAttr", var0.Battle.BattleFleetBuffEffect)

var0.Battle.BattleCardPuzzleFleetBuffAddFleetAttr = var2
var2.__name = "BattleCardPuzzleFleetBuffAddFleetAttr"
var2.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR

function var2.Ctor(arg0, arg1)
	arg0._tempData = Clone(arg1)
	arg0._type = arg0._tempData.type

	arg0:SetActive()
end

function var2.GetEffectType(arg0)
	return var2.FX_TYPE
end

function var2.SetArgs(arg0, arg1, arg2)
	var2.super.SetArgs(arg0, arg1, arg2)

	arg0._group = arg0._tempData.arg_list.group or arg0._fleetBuff:GetID()
	arg0._attr = arg0._tempData.arg_list.attr
	arg0._number = arg0._tempData.arg_list.number

	if arg0._tempData.arg_list.enhance_formula then
		local var0 = arg0._tempData.arg_list.enhance_formula

		arg0._number = var1.parseFormula(var0, arg1:GetAttrManager()) + arg0._number
	end

	arg0._cache = arg0._tempData.arg_list.maintain
	arg0._numberBase = arg0._number
end

function var2.onRemove(arg0)
	if arg0._cache then
		arg0._number = 0
	end

	arg0:onTrigger()
end

function var2.GetGroup(arg0)
	return arg0._group
end

function var2.GetNumber(arg0)
	return arg0._number * arg0._fleetBuff:GetStack()
end

function var2.IsSameAttr(arg0, arg1)
	return arg0._attr == arg1
end

function var2.onTrigger(arg0)
	local var0 = arg0._cardPuzzleComponent

	if arg0._cache then
		local var1 = var0:GetBuffManager():GetCardPuzzleBuffList()
		local var2 = 0
		local var3 = 0
		local var4 = {}
		local var5 = {}

		for iter0, iter1 in pairs(var1) do
			for iter2, iter3 in ipairs(iter1._effectList) do
				if iter3:GetEffectType() == var2.FX_TYPE and iter3:IsSameAttr(arg0._attr) then
					local var6 = iter3:GetNumber()
					local var7 = iter3:GetGroup()
					local var8 = var4[var7] or 0
					local var9 = var5[var7] or 0

					if var8 < var6 and var6 > 0 then
						var2 = var2 + var6 - var8
						var8 = var6
					end

					if var6 < var9 and var6 < 0 then
						var3 = var3 + var6 - var9
						var9 = var6
					end

					var4[var7] = var8
					var5[var7] = var9
				end
			end
		end

		local var10 = var2 + var3

		var0:UpdateAttrByBuff(arg0._attr, var10)
	else
		var0:AddAttrBySkill(arg0._attr, arg0:GetNumber())
	end
end
