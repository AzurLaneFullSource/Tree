ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.CardPuzzleHandCardButton = class("CardPuzzleHandCardButton")

local var2_0 = var0_0.Battle.CardPuzzleHandCardButton

var2_0.__name = "CardPuzzleHandCardButton"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:init()
end

function var2_0.SetCardInfo(arg0_2, arg1_2)
	arg0_2._cardInfo = arg1_2

	arg0_2:updateCardView()
end

function var2_0.UpdateTotalCost(arg0_3)
	if arg0_3._cardInfo then
		setText(arg0_3._costTxt, arg0_3._cardInfo:GetTotalCost())
	end
end

function var2_0.ConfigCallback(arg0_4, arg1_4)
	arg0_4._callback = arg1_4
end

function var2_0.init(arg0_5)
	arg0_5._btnTF = arg0_5._go.transform
	arg0_5._icon = arg0_5._btnTF:Find("skill_icon/unfill")
	arg0_5._costTxt = arg0_5._btnTF:Find("cost/cost_label")
	arg0_5._cardName = arg0_5._btnTF:Find("name")
	arg0_5._cardType = arg0_5._btnTF:Find("icon_bg")
	arg0_5._cardTypeList = {}

	for iter0_5 = 1, 3 do
		table.insert(arg0_5._cardTypeList, arg0_5._cardType:Find("card_type_" .. iter0_5))
	end

	arg0_5._cardRarity = arg0_5._btnTF:Find("bg")
	arg0_5._cardRarityList = {}

	for iter1_5 = 0, 4 do
		table.insert(arg0_5._cardRarityList, arg0_5._cardRarity:Find("rarity_" .. iter1_5))
	end

	arg0_5._tag = arg0_5._btnTF:Find("tag")

	GetComponent(arg0_5._btnTF, "EventTriggerListener"):AddPointUpFunc(function()
		if arg0_5._cardInfo then
			arg0_5._callback(arg0_5._cardInfo)
		end
	end)
end

function var2_0.updateCardView(arg0_7)
	if arg0_7._cardInfo then
		setActive(arg0_7._btnTF, true)
		setText(arg0_7._costTxt, arg0_7._cardInfo:GetTotalCost())
		setText(arg0_7._cardName, arg0_7._cardInfo:GetCardTemplate().name)
		setText(arg0_7._tag, "词缀功能TODO")

		local var0_7 = arg0_7._cardInfo:GetRarity()
		local var1_7 = arg0_7._cardInfo:GetCardType()

		for iter0_7, iter1_7 in ipairs(arg0_7._cardRarityList) do
			setActive(iter1_7, iter0_7 == var0_7 + 1)
		end

		for iter2_7, iter3_7 in ipairs(arg0_7._cardTypeList) do
			setActive(iter3_7, iter2_7 == var1_7)
		end

		GetImageSpriteFromAtlasAsync("skillicon/" .. arg0_7._cardInfo:GetIconID(), "", arg0_7._icon)
	else
		setActive(arg0_7._btnTF, false)
	end
end

function var2_0.Dispose(arg0_8)
	return
end
