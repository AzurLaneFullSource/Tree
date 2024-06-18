ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFleetCardPuzzleCardManageComponent
local var2_0 = class("BattleCardPuzzleSkillMoveCard", var0_0.Battle.BattleCardPuzzleSkillEffect)

var0_0.Battle.BattleCardPuzzleSkillMoveCard = var2_0
var2_0.__name = "BattleCardPuzzleSkillMoveCard"

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._moveFrom = arg0_1._tempData.arg_list.move_from or 0
	arg0_1._moveTo = arg0_1._tempData.arg_list.move_to
	arg0_1._moveID = arg0_1._tempData.arg_list.move_ID_list
	arg0_1._moveLabel = arg0_1._tempData.arg_list.move_label_list
	arg0_1._moveOP = arg0_1._tempData.arg_list.move_op or var1_0.FUNC_NAME_ADD
	arg0_1._moveOther = arg0_1._tempData.arg_list.move_other
	arg0_1._moveAll = arg0_1._tempData.arg_list.move_all
	arg0_1._op = arg0_1._tempData.arg_list.shuffle or 1
end

function var2_0.MoveCardAfterCast(arg0_2)
	if arg0_2._moveID or arg0_2._moveLabel then
		return var2_0.super.MoveCardAfterCast(arg0_2)
	else
		return arg0_2._moveTo
	end
end

function var2_0.SkillEffectHandler(arg0_3)
	local var0_3 = arg0_3._card:GetClient()
	local var1_3 = var0_3:GetCardPileByIndex(arg0_3._moveTo)
	local var2_3 = var0_3:GetCardPileByIndex(arg0_3._moveFrom)

	if arg0_3._moveID then
		local var3_3 = {
			value = arg0_3._moveID,
			type = var1_0.SEARCH_BY_ID,
			total = arg0_3._moveAll
		}
		local var4_3 = var2_3:Search(var3_3)

		for iter0_3, iter1_3 in ipairs(var4_3) do
			var1_3[arg0_3._moveOP](var1_3, iter1_3)
			var2_3:Remove(iter1_3, arg0_3._moveTo)
		end
	elseif arg0_3._moveLabel then
		local var5_3 = {
			value = arg0_3._moveLabel,
			type = var1_0.SEARCH_BY_LABEL,
			total = arg0_3._moveAll
		}
		local var6_3 = var2_3:Search(var5_3)

		for iter2_3, iter3_3 in ipairs(var6_3) do
			var1_3[arg0_3._moveOP](var1_3, iter3_3)
			var2_3:Remove(iter3_3, arg0_3._moveTo)
		end
	elseif arg0_3._moveOther then
		local var7_3 = var2_3:GetCardList()

		for iter4_3, iter5_3 in ipairs(var7_3) do
			if iter5_3 ~= arg0_3._card then
				var1_3[arg0_3._moveOP](var1_3, iter5_3)
				var2_3:Remove(iter5_3, arg0_3._moveTo)
			end
		end
	else
		var1_3[arg0_3._moveOP](var1_3, arg0_3._card)
	end

	if arg0_3._op == 1 then
		var1_3:Shuffle()
	end

	arg0_3:Finale()
end
