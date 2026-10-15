local var0_0 = class("FormationSuggestionTeamItem", import("view.base.BasePanel"))

var0_0.ON_HIDE_CARD_ITEM = "FormationSuggestionTeamItem:ON_HIDE_CARD_ITEM"
var0_0.ON_REFRESH_CARD_ITEM = "FormationSuggestionTeamItem:ON_REFRESH_CARD_ITEM"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()

	arg0_1.eventIDList = {
		arg0_1:bind(var0_0.ON_HIDE_CARD_ITEM, handler(arg0_1, arg0_1.OnHideCardItem)),
		arg0_1:bind(var0_0.ON_REFRESH_CARD_ITEM, handler(arg0_1, arg0_1.OnRefreshCardItem))
	}
end

function var0_0.Init(arg0_2)
	arg0_2.mainItemList = {}
	arg0_2.vanguardItemList = {}

	for iter0_2 = 1, 3 do
		arg0_2.mainItemList[iter0_2] = FormationSuggestionCardItem.New(arg0_2[string.format("uiMainShipTf%s", iter0_2)], arg0_2)
		arg0_2.vanguardItemList[iter0_2] = FormationSuggestionCardItem.New(arg0_2[string.format("uiVanguardShipTf%s", iter0_2)], arg0_2)
	end

	arg0_2.animation = arg0_2._tf:GetComponent(typeof(Animation))
end

function var0_0.SetID(arg0_3, arg1_3)
	arg0_3.id = arg1_3

	local var0_3 = pg.chapter_suggestion_formation[arg1_3]

	if var0_3.type == FormationSuggestionScene.SUGGESTION_TYPE.SUBMARINE then
		setActive(arg0_3.uiVanguardTopGo, false)
		setText(arg0_3.uiMainText, i18n("pre_combat_submarine"))

		for iter0_3, iter1_3 in ipairs(var0_3.teamid) do
			arg0_3.mainItemList[iter0_3]:SetData(iter1_3)
		end

		for iter2_3, iter3_3 in ipairs(arg0_3.vanguardItemList) do
			arg0_3.vanguardItemList[iter2_3]:SetData(nil)
		end
	else
		setActive(arg0_3.uiVanguardTopGo, true)
		setText(arg0_3.uiMainText, i18n("pre_combat_main"))
		setText(arg0_3.uiVanguardText, i18n("pre_combat_vanguard"))

		for iter4_3, iter5_3 in ipairs(var0_3.teamid) do
			arg0_3.mainItemList[iter4_3]:SetData(iter5_3, iter4_3)
		end

		for iter6_3, iter7_3 in ipairs(var0_3.teamid1) do
			arg0_3.vanguardItemList[iter6_3]:SetData(iter7_3)
		end
	end
end

function var0_0.OnHideCardItem(arg0_4, arg1_4, arg2_4)
	if arg0_4._go == arg2_4 then
		arg0_4.id = nil
	end
end

function var0_0.OnRefreshCardItem(arg0_5, arg1_5, arg2_5)
	if arg0_5.id ~= arg2_5 then
		arg0_5:OnPlayAnimation()
	end
end

function var0_0.OnPlayAnimation(arg0_6)
	arg0_6.animation:Stop()
	arg0_6.animation:Play("anim_item_in")
end

function var0_0.willExit(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.eventIDList) do
		arg0_7:disconnect(iter1_7)
	end

	arg0_7.eventIDList = nil

	for iter2_7, iter3_7 in ipairs(arg0_7.mainItemList) do
		iter3_7:willExit()
	end

	arg0_7.mainItemList = nil

	for iter4_7, iter5_7 in ipairs(arg0_7.vanguardItemList) do
		iter5_7:willExit()
	end

	arg0_7.vanguardItemList = nil

	arg0_7:detach()
end

return var0_0
