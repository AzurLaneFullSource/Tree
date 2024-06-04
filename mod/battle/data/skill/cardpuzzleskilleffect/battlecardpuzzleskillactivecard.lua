ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFleetCardPuzzleCardManageComponent
local var2 = class("BattleCardPuzzleSkillActiveCard", var0.Battle.BattleCardPuzzleSkillEffect)

var0.Battle.BattleCardPuzzleSkillActiveCard = var2
var2.__name = "BattleCardPuzzleSkillActiveCard"

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)

	arg0._activeFrom = arg0._tempData.arg_list.active_from or 0
	arg0._activeID = arg0._tempData.arg_list.active_ID_list
	arg0._activeLabel = arg0._tempData.arg_list.active_label_list
	arg0._activeAll = arg0._tempData.arg_list.active_all
end

function var2.SkillEffectHandler(arg0)
	local var0 = arg0._card:GetClient():GetCardPileByIndex(arg0._activeFrom)
	local var1 = {
		value = arg0._activeID or arg0._activeLabel,
		total = arg0._activeAll,
		type = arg0._activeID and var1.SEARCH_BY_ID or var1.SEARCH_BY_LABEL
	}
	local var2 = var0:Search(var1)

	for iter0, iter1 in ipairs(var2) do
		iter1:Active()
	end

	arg0:Finale()
end
