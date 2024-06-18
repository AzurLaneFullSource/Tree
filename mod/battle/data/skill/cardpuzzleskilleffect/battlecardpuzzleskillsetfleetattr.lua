ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleCardPuzzleFormulas
local var2_0 = class("BattleCardPuzzleSkillSetFleetAttr", var0_0.Battle.BattleCardPuzzleSkillEffect)

var0_0.Battle.BattleCardPuzzleSkillSetFleetAttr = var2_0
var2_0.__name = "BattleCardPuzzleSkillSetFleetAttr"

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._attr = arg0_1._tempData.arg_list.attr
	arg0_1._number = arg0_1._tempData.arg_list.number
	arg0_1._enhance = arg0_1._tempData.arg_list.enhance_formula
end

function var2_0.SkillEffectHandler(arg0_2, arg1_2)
	local var0_2 = arg0_2._number

	if arg0_2._enhance then
		var0_2 = var0_2 + var1_0.parseFormula(arg0_2._enhance, arg0_2:GetCardPuzzleComponent():GetAttrManager())
	end

	arg0_2:GetCardPuzzleComponent():UpdateAttrBySet(arg0_2._attr, var0_2)
	arg0_2:Finale()
end
