ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleCardPuzzleFormulas
local var2_0 = class("BattleCardPuzzleFleetBuffAddFleetAttr", var0_0.Battle.BattleFleetBuffEffect)

var0_0.Battle.BattleCardPuzzleFleetBuffAddFleetAttr = var2_0
var2_0.__name = "BattleCardPuzzleFleetBuffAddFleetAttr"
var2_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._tempData = Clone(arg1_1)
	arg0_1._type = arg0_1._tempData.type

	arg0_1:SetActive()
end

function var2_0.GetEffectType(arg0_2)
	return var2_0.FX_TYPE
end

function var2_0.SetArgs(arg0_3, arg1_3, arg2_3)
	var2_0.super.SetArgs(arg0_3, arg1_3, arg2_3)

	arg0_3._group = arg0_3._tempData.arg_list.group or arg0_3._fleetBuff:GetID()
	arg0_3._attr = arg0_3._tempData.arg_list.attr
	arg0_3._number = arg0_3._tempData.arg_list.number

	if arg0_3._tempData.arg_list.enhance_formula then
		local var0_3 = arg0_3._tempData.arg_list.enhance_formula

		arg0_3._number = var1_0.parseFormula(var0_3, arg1_3:GetAttrManager()) + arg0_3._number
	end

	arg0_3._cache = arg0_3._tempData.arg_list.maintain
	arg0_3._numberBase = arg0_3._number
end

function var2_0.onRemove(arg0_4)
	if arg0_4._cache then
		arg0_4._number = 0
	end

	arg0_4:onTrigger()
end

function var2_0.GetGroup(arg0_5)
	return arg0_5._group
end

function var2_0.GetNumber(arg0_6)
	return arg0_6._number * arg0_6._fleetBuff:GetStack()
end

function var2_0.IsSameAttr(arg0_7, arg1_7)
	return arg0_7._attr == arg1_7
end

function var2_0.onTrigger(arg0_8)
	local var0_8 = arg0_8._cardPuzzleComponent

	if arg0_8._cache then
		local var1_8 = var0_8:GetBuffManager():GetCardPuzzleBuffList()
		local var2_8 = 0
		local var3_8 = 0
		local var4_8 = {}
		local var5_8 = {}

		for iter0_8, iter1_8 in pairs(var1_8) do
			for iter2_8, iter3_8 in ipairs(iter1_8._effectList) do
				if iter3_8:GetEffectType() == var2_0.FX_TYPE and iter3_8:IsSameAttr(arg0_8._attr) then
					local var6_8 = iter3_8:GetNumber()
					local var7_8 = iter3_8:GetGroup()
					local var8_8 = var4_8[var7_8] or 0
					local var9_8 = var5_8[var7_8] or 0

					if var8_8 < var6_8 and var6_8 > 0 then
						var2_8 = var2_8 + var6_8 - var8_8
						var8_8 = var6_8
					end

					if var6_8 < var9_8 and var6_8 < 0 then
						var3_8 = var3_8 + var6_8 - var9_8
						var9_8 = var6_8
					end

					var4_8[var7_8] = var8_8
					var5_8[var7_8] = var9_8
				end
			end
		end

		local var10_8 = var2_8 + var3_8

		var0_8:UpdateAttrByBuff(arg0_8._attr, var10_8)
	else
		var0_8:AddAttrBySkill(arg0_8._attr, arg0_8:GetNumber())
	end
end
