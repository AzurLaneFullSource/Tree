local var0 = class("CardPuzzleRelicDeckLayer", BaseUI)

function var0.getUIName(arg0)
	return "CardTowerGiftDeckUI"
end

function var0.isLayer(arg0)
	return false
end

function var0.init(arg0)
	arg0.giftListRect = arg0:findTF("Container")
	arg0.giftListComp = arg0.giftListRect:GetComponent("LScrollRect")

	function arg0.giftListComp.onUpdateItem(arg0, arg1)
		local var0 = tf(arg1)
		local var1 = CardPuzzleRelicView.New(var0)

		var1:SetData(arg0.gifts[arg0 + 1])
		var1:UpdateView()
		onButton(arg0, arg1, function()
			arg0:ShowRelicDetail(arg0)
		end, SFX_PANEL)
		TweenItemAlphaAndWhite(arg1)
	end
end

function var0.ShowRelicDetail(arg0, arg1)
	arg0:emit(CardPuzzleRelicDeckMediator.SHOW_GIFT, {
		giftData = arg0.gifts[arg1 + 1]
	})
end

function var0.SetGifts(arg0, arg1)
	arg0.gifts = arg1
end

function var0.didEnter(arg0)
	arg0.giftListComp:SetTotalCount(#arg0.gifts)
end

function var0.OnBackward(arg0)
	arg0:closeView()

	return true
end

function var0.willExit(arg0)
	pg.m02:sendNotification(CardTowerStageMediator.CARDTOWER_STAGE_REMOVE_SUBVIEW, arg0._tf)
end

return var0
