ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFleetCardPuzzleCardManageComponent
local var2_0 = class("BattleCardPuzzleSkillActiveCard", var0_0.Battle.BattleCardPuzzleSkillEffect)

var0_0.Battle.BattleCardPuzzleSkillActiveCard = var2_0
var2_0.__name = "BattleCardPuzzleSkillActiveCard"

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._activeFrom = arg0_1._tempData.arg_list.active_from or 0
	arg0_1._activeID = arg0_1._tempData.arg_list.active_ID_list
	arg0_1._activeLabel = arg0_1._tempData.arg_list.active_label_list
	arg0_1._activeAll = arg0_1._tempData.arg_list.active_all
end

function var2_0.SkillEffectHandler(arg0_2)
	local var0_2 = arg0_2._card:GetClient():GetCardPileByIndex(arg0_2._activeFrom)
	local var1_2 = {
		value = arg0_2._activeID or arg0_2._activeLabel,
		total = arg0_2._activeAll,
		type = arg0_2._activeID and var1_0.SEARCH_BY_ID or var1_0.SEARCH_BY_LABEL
	}
	local var2_2 = var0_2:Search(var1_2)

	for iter0_2, iter1_2 in ipairs(var2_2) do
		iter1_2:Active()
	end

	arg0_2:Finale()
end
