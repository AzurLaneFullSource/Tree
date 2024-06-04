ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleCardPuzzleFormulas
local var2 = class("BattleCardPuzzleSkillSetFleetAttr", var0.Battle.BattleCardPuzzleSkillEffect)

var0.Battle.BattleCardPuzzleSkillSetFleetAttr = var2
var2.__name = "BattleCardPuzzleSkillSetFleetAttr"

function var2.Ctor(arg0, arg1, arg2)
	var2.super.Ctor(arg0, arg1, arg2)

	arg0._attr = arg0._tempData.arg_list.attr
	arg0._number = arg0._tempData.arg_list.number
	arg0._enhance = arg0._tempData.arg_list.enhance_formula
end

function var2.SkillEffectHandler(arg0, arg1)
	local var0 = arg0._number

	if arg0._enhance then
		var0 = var0 + var1.parseFormula(arg0._enhance, arg0:GetCardPuzzleComponent():GetAttrManager())
	end

	arg0:GetCardPuzzleComponent():UpdateAttrBySet(arg0._attr, var0)
	arg0:Finale()
end
