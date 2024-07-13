local var0_0 = class("CardTowerCardDeckLayerCombat", CardPuzzleCardDeckLayer)

function var0_0.getUIName(arg0_1)
	return "CardTowerCardDeckCombat"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.labelCH = arg0_2:findTF("label/ch")
	arg0_2.labelEN = arg0_2:findTF("label/en")

	setText(arg0_2.labelEN, i18n("card_battle_card details"))

	arg0_2.switchToggle = arg0_2:findTF("switch_toggle/toggle")

	setText(arg0_2:findTF("switch_toggle/toggle/hand"), i18n("card_battle_card details_switchto_deck"))
	setText(arg0_2:findTF("switch_toggle/toggle/deck"), i18n("card_battle_card details_switchto_hand"))
	onToggle(arg0_2, arg0_2.switchToggle, function(arg0_3)
		if arg0_3 then
			arg0_2:showHand()
		else
			arg0_2:showDeck()
		end
	end)

	arg0_2.empty = arg0_2:findTF("empty")

	setText(arg0_2:findTF("empty/label_en"), i18n("card_battle_card_empty_en"))
	setText(arg0_2:findTF("empty/label_ch"), i18n("card_battle_card_empty_ch"))
	onButton(arg0_2, arg0_2:findTF("backBtn"), function()
		arg0_2:OnBackward()
	end, SFX_PANEL)
end

function var0_0.showHand(arg0_5)
	setText(arg0_5.labelCH, i18n("card_battle_card details_hand"))

	arg0_5.cards = arg0_5.hand

	arg0_5:RefreshCards()
end

function var0_0.showDeck(arg0_6)
	setText(arg0_6.labelCH, i18n("card_battle_card details_deck"))

	arg0_6.cards = arg0_6.deck

	arg0_6:RefreshCards()
end

function var0_0.didEnter(arg0_7)
	triggerToggle(arg0_7.switchToggle, false)
end

function var0_0.SetCards(arg0_8, arg1_8, arg2_8)
	arg0_8.deck = arg1_8
	arg0_8.hand = arg2_8
end

function var0_0.RefreshCards(arg0_9)
	setActive(arg0_9.empty, #arg0_9.cards == 0)
	arg0_9.cardListComp:SetTotalCount(#arg0_9.cards)
end

function var0_0.OnBackward(arg0_10)
	arg0_10:emit(CardPuzzleCardDeckMediator.CLOSE_LAYER)

	return var0_0.super.OnBackward(arg0_10)
end

function var0_0.willExit(arg0_11)
	return
end

return var0_0
