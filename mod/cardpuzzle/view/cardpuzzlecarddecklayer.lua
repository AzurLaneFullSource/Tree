local var0 = class("CardPuzzleCardDeckLayer", BaseUI)

function var0.getUIName(arg0)
	return "CardTowerCardDeckUI"
end

function var0.isLayer(arg0)
	return false
end

function var0.init(arg0)
	arg0.cardListRect = arg0:findTF("Container")
	arg0.cardListComp = arg0.cardListRect:GetComponent("LScrollRect")

	function arg0.cardListComp.onUpdateItem(arg0, arg1)
		local var0 = tf(arg1):GetChild(0)
		local var1 = CardPuzzleCardView.New(var0)

		var1:SetData(arg0.cards[arg0 + 1])
		var1:UpdateView()
		onButton(arg0, arg1, function()
			arg0:ShowCardDetail(arg0)
		end, SFX_PANEL)
	end
end

function var0.ShowCardDetail(arg0, arg1)
	arg0:emit(CardPuzzleCardDeckMediator.SHOW_CARD, {
		cardData = arg0.cards[arg1 + 1]
	})
end

function var0.SetCards(arg0, arg1)
	arg0.cards = arg1
end

function var0.didEnter(arg0)
	arg0:RefreshCards()
end

function var0.RefreshCards(arg0)
	arg0.cardListComp:SetTotalCount(#arg0.cards)
end

function var0.OnBackward(arg0)
	arg0:closeView()

	return true
end

function var0.willExit(arg0)
	pg.m02:sendNotification(CardTowerStageMediator.CARDTOWER_STAGE_REMOVE_SUBVIEW, arg0._tf)
end

return var0
