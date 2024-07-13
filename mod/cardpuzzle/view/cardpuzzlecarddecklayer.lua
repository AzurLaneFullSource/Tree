local var0_0 = class("CardPuzzleCardDeckLayer", BaseUI)

function var0_0.getUIName(arg0_1)
	return "CardTowerCardDeckUI"
end

function var0_0.isLayer(arg0_2)
	return false
end

function var0_0.init(arg0_3)
	arg0_3.cardListRect = arg0_3:findTF("Container")
	arg0_3.cardListComp = arg0_3.cardListRect:GetComponent("LScrollRect")

	function arg0_3.cardListComp.onUpdateItem(arg0_4, arg1_4)
		local var0_4 = tf(arg1_4):GetChild(0)
		local var1_4 = CardPuzzleCardView.New(var0_4)

		var1_4:SetData(arg0_3.cards[arg0_4 + 1])
		var1_4:UpdateView()
		onButton(arg0_3, arg1_4, function()
			arg0_3:ShowCardDetail(arg0_4)
		end, SFX_PANEL)
	end
end

function var0_0.ShowCardDetail(arg0_6, arg1_6)
	arg0_6:emit(CardPuzzleCardDeckMediator.SHOW_CARD, {
		cardData = arg0_6.cards[arg1_6 + 1]
	})
end

function var0_0.SetCards(arg0_7, arg1_7)
	arg0_7.cards = arg1_7
end

function var0_0.didEnter(arg0_8)
	arg0_8:RefreshCards()
end

function var0_0.RefreshCards(arg0_9)
	arg0_9.cardListComp:SetTotalCount(#arg0_9.cards)
end

function var0_0.OnBackward(arg0_10)
	arg0_10:closeView()

	return true
end

function var0_0.willExit(arg0_11)
	pg.m02:sendNotification(CardTowerStageMediator.CARDTOWER_STAGE_REMOVE_SUBVIEW, arg0_11._tf)
end

return var0_0
