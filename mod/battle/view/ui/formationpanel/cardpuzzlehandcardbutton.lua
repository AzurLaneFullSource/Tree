ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.CardPuzzleHandCardButton = class("CardPuzzleHandCardButton")

local var2 = var0.Battle.CardPuzzleHandCardButton

var2.__name = "CardPuzzleHandCardButton"

function var2.Ctor(arg0, arg1)
	arg0._go = arg1

	arg0:init()
end

function var2.SetCardInfo(arg0, arg1)
	arg0._cardInfo = arg1

	arg0:updateCardView()
end

function var2.UpdateTotalCost(arg0)
	if arg0._cardInfo then
		setText(arg0._costTxt, arg0._cardInfo:GetTotalCost())
	end
end

function var2.ConfigCallback(arg0, arg1)
	arg0._callback = arg1
end

function var2.init(arg0)
	arg0._btnTF = arg0._go.transform
	arg0._icon = arg0._btnTF:Find("skill_icon/unfill")
	arg0._costTxt = arg0._btnTF:Find("cost/cost_label")
	arg0._cardName = arg0._btnTF:Find("name")
	arg0._cardType = arg0._btnTF:Find("icon_bg")
	arg0._cardTypeList = {}

	for iter0 = 1, 3 do
		table.insert(arg0._cardTypeList, arg0._cardType:Find("card_type_" .. iter0))
	end

	arg0._cardRarity = arg0._btnTF:Find("bg")
	arg0._cardRarityList = {}

	for iter1 = 0, 4 do
		table.insert(arg0._cardRarityList, arg0._cardRarity:Find("rarity_" .. iter1))
	end

	arg0._tag = arg0._btnTF:Find("tag")

	GetComponent(arg0._btnTF, "EventTriggerListener"):AddPointUpFunc(function()
		if arg0._cardInfo then
			arg0._callback(arg0._cardInfo)
		end
	end)
end

function var2.updateCardView(arg0)
	if arg0._cardInfo then
		setActive(arg0._btnTF, true)
		setText(arg0._costTxt, arg0._cardInfo:GetTotalCost())
		setText(arg0._cardName, arg0._cardInfo:GetCardTemplate().name)
		setText(arg0._tag, "词缀功能TODO")

		local var0 = arg0._cardInfo:GetRarity()
		local var1 = arg0._cardInfo:GetCardType()

		for iter0, iter1 in ipairs(arg0._cardRarityList) do
			setActive(iter1, iter0 == var0 + 1)
		end

		for iter2, iter3 in ipairs(arg0._cardTypeList) do
			setActive(iter3, iter2 == var1)
		end

		GetImageSpriteFromAtlasAsync("skillicon/" .. arg0._cardInfo:GetIconID(), "", arg0._icon)
	else
		setActive(arg0._btnTF, false)
	end
end

function var2.Dispose(arg0)
	return
end
