ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFleetCardPuzzleCardManageComponent
local var2 = class("BattleCardPuzzleSkillMoveCard", var0.Battle.BattleCardPuzzleSkillEffect)

var0.Battle.BattleCardPuzzleSkillMoveCard = var2
var2.__name = "BattleCardPuzzleSkillMoveCard"

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)

	arg0._moveFrom = arg0._tempData.arg_list.move_from or 0
	arg0._moveTo = arg0._tempData.arg_list.move_to
	arg0._moveID = arg0._tempData.arg_list.move_ID_list
	arg0._moveLabel = arg0._tempData.arg_list.move_label_list
	arg0._moveOP = arg0._tempData.arg_list.move_op or var1.FUNC_NAME_ADD
	arg0._moveOther = arg0._tempData.arg_list.move_other
	arg0._moveAll = arg0._tempData.arg_list.move_all
	arg0._op = arg0._tempData.arg_list.shuffle or 1
end

function var2.MoveCardAfterCast(arg0)
	if arg0._moveID or arg0._moveLabel then
		return var2.super.MoveCardAfterCast(arg0)
	else
		return arg0._moveTo
	end
end

function var2.SkillEffectHandler(arg0)
	local var0 = arg0._card:GetClient()
	local var1 = var0:GetCardPileByIndex(arg0._moveTo)
	local var2 = var0:GetCardPileByIndex(arg0._moveFrom)

	if arg0._moveID then
		local var3 = {
			value = arg0._moveID,
			type = var1.SEARCH_BY_ID,
			total = arg0._moveAll
		}
		local var4 = var2:Search(var3)

		for iter0, iter1 in ipairs(var4) do
			var1[arg0._moveOP](var1, iter1)
			var2:Remove(iter1, arg0._moveTo)
		end
	elseif arg0._moveLabel then
		local var5 = {
			value = arg0._moveLabel,
			type = var1.SEARCH_BY_LABEL,
			total = arg0._moveAll
		}
		local var6 = var2:Search(var5)

		for iter2, iter3 in ipairs(var6) do
			var1[arg0._moveOP](var1, iter3)
			var2:Remove(iter3, arg0._moveTo)
		end
	elseif arg0._moveOther then
		local var7 = var2:GetCardList()

		for iter4, iter5 in ipairs(var7) do
			if iter5 ~= arg0._card then
				var1[arg0._moveOP](var1, iter5)
				var2:Remove(iter5, arg0._moveTo)
			end
		end
	else
		var1[arg0._moveOP](var1, arg0._card)
	end

	if arg0._op == 1 then
		var1:Shuffle()
	end

	arg0:Finale()
end
