local var0_0 = class("CardPuzzleRelicDeckLayer", BaseUI)

function var0_0.getUIName(arg0_1)
	return "CardTowerGiftDeckUI"
end

function var0_0.isLayer(arg0_2)
	return false
end

function var0_0.init(arg0_3)
	arg0_3.giftListRect = arg0_3:findTF("Container")
	arg0_3.giftListComp = arg0_3.giftListRect:GetComponent("LScrollRect")

	function arg0_3.giftListComp.onUpdateItem(arg0_4, arg1_4)
		local var0_4 = tf(arg1_4)
		local var1_4 = CardPuzzleRelicView.New(var0_4)

		var1_4:SetData(arg0_3.gifts[arg0_4 + 1])
		var1_4:UpdateView()
		onButton(arg0_3, arg1_4, function()
			arg0_3:ShowRelicDetail(arg0_4)
		end, SFX_PANEL)
		TweenItemAlphaAndWhite(arg1_4)
	end
end

function var0_0.ShowRelicDetail(arg0_6, arg1_6)
	arg0_6:emit(CardPuzzleRelicDeckMediator.SHOW_GIFT, {
		giftData = arg0_6.gifts[arg1_6 + 1]
	})
end

function var0_0.SetGifts(arg0_7, arg1_7)
	arg0_7.gifts = arg1_7
end

function var0_0.didEnter(arg0_8)
	arg0_8.giftListComp:SetTotalCount(#arg0_8.gifts)
end

function var0_0.OnBackward(arg0_9)
	arg0_9:closeView()

	return true
end

function var0_0.willExit(arg0_10)
	pg.m02:sendNotification(CardTowerStageMediator.CARDTOWER_STAGE_REMOVE_SUBVIEW, arg0_10._tf)
end

return var0_0
