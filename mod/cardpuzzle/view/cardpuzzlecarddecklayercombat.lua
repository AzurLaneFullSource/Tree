local var0 = class("CardTowerCardDeckLayerCombat", CardPuzzleCardDeckLayer)

function var0.getUIName(arg0)
	return "CardTowerCardDeckCombat"
end

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.labelCH = arg0:findTF("label/ch")
	arg0.labelEN = arg0:findTF("label/en")

	setText(arg0.labelEN, i18n("card_battle_card details"))

	arg0.switchToggle = arg0:findTF("switch_toggle/toggle")

	setText(arg0:findTF("switch_toggle/toggle/hand"), i18n("card_battle_card details_switchto_deck"))
	setText(arg0:findTF("switch_toggle/toggle/deck"), i18n("card_battle_card details_switchto_hand"))
	onToggle(arg0, arg0.switchToggle, function(arg0)
		if arg0 then
			arg0:showHand()
		else
			arg0:showDeck()
		end
	end)

	arg0.empty = arg0:findTF("empty")

	setText(arg0:findTF("empty/label_en"), i18n("card_battle_card_empty_en"))
	setText(arg0:findTF("empty/label_ch"), i18n("card_battle_card_empty_ch"))
	onButton(arg0, arg0:findTF("backBtn"), function()
		arg0:OnBackward()
	end, SFX_PANEL)
end

function var0.showHand(arg0)
	setText(arg0.labelCH, i18n("card_battle_card details_hand"))

	arg0.cards = arg0.hand

	arg0:RefreshCards()
end

function var0.showDeck(arg0)
	setText(arg0.labelCH, i18n("card_battle_card details_deck"))

	arg0.cards = arg0.deck

	arg0:RefreshCards()
end

function var0.didEnter(arg0)
	triggerToggle(arg0.switchToggle, false)
end

function var0.SetCards(arg0, arg1, arg2)
	arg0.deck = arg1
	arg0.hand = arg2
end

function var0.RefreshCards(arg0)
	setActive(arg0.empty, #arg0.cards == 0)
	arg0.cardListComp:SetTotalCount(#arg0.cards)
end

function var0.OnBackward(arg0)
	arg0:emit(CardPuzzleCardDeckMediator.CLOSE_LAYER)

	return var0.super.OnBackward(arg0)
end

function var0.willExit(arg0)
	return
end

return var0
