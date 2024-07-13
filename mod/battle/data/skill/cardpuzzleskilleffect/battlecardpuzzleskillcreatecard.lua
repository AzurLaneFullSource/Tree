ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFleetCardPuzzleCardManageComponent
local var2_0 = class("BattleCardPuzzleSkillCreateCard", var0_0.Battle.BattleCardPuzzleSkillEffect)

var0_0.Battle.BattleCardPuzzleSkillCreateCard = var2_0
var2_0.__name = "BattleCardPuzzleSkillCreateCard"
var2_0.MOVE_OP_Add = "Add"
var2_0.MOVE_OP_BOTTOM = "Bottom"

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._cardID = arg0_1._tempData.arg_list.card_id
	arg0_1._moveTo = arg0_1._tempData.arg_list.move_to
	arg0_1._moveOP = arg0_1._tempData.arg_list.move_op or var1_0.FUNC_NAME_ADD
	arg0_1._op = arg0_1._tempData.arg_list.shuffle or 1
end

function var2_0.SkillEffectHandler(arg0_2)
	local var0_2 = arg0_2._card:GetClient()
	local var1_2 = var0_2:GenerateCard(arg0_2._cardID)
	local var2_2 = var0_2:GetCardPileByIndex(arg0_2._moveTo)

	var2_2[arg0_2._moveOP](var2_2, var1_2)

	if arg0_2._op == 1 then
		var2_2:Shuffle()
	end

	arg0_2:Finale()
end
