ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFleetCardPuzzleCardManageComponent
local var2 = class("BattleCardPuzzleSkillCreateCard", var0.Battle.BattleCardPuzzleSkillEffect)

var0.Battle.BattleCardPuzzleSkillCreateCard = var2
var2.__name = "BattleCardPuzzleSkillCreateCard"
var2.MOVE_OP_Add = "Add"
var2.MOVE_OP_BOTTOM = "Bottom"

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)

	arg0._cardID = arg0._tempData.arg_list.card_id
	arg0._moveTo = arg0._tempData.arg_list.move_to
	arg0._moveOP = arg0._tempData.arg_list.move_op or var1.FUNC_NAME_ADD
	arg0._op = arg0._tempData.arg_list.shuffle or 1
end

function var2.SkillEffectHandler(arg0)
	local var0 = arg0._card:GetClient()
	local var1 = var0:GenerateCard(arg0._cardID)
	local var2 = var0:GetCardPileByIndex(arg0._moveTo)

	var2[arg0._moveOP](var2, var1)

	if arg0._op == 1 then
		var2:Shuffle()
	end

	arg0:Finale()
end
