local var0_0 = class("AuctionGameCollectionInfoLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameCollectionInfoUI"
end

function var0_0.init(arg0_2)
	arg0_2:OverlayPanel(arg0_2._tf, {
		pbList = {
			arg0_2.uiBgBtn
		}
	})
	setText(arg0_2.uiCancelText, i18n("auction_cancel"))
	setText(arg0_2.uiConfirmText, i18n("auction_confirm"))
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiCancelBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiConfirmBtn, function()
		arg0_2:closeView()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_7)
	arg0_7.auctionGameCollectionItem = AuctionGameCollectionItem.New(arg0_7.uiItemTf, arg0_7)

	arg0_7.auctionGameCollectionItem:didEnter(arg0_7.contextData.id)
end

function var0_0.willExit(arg0_8)
	arg0_8:UnOverlayPanel(arg0_8._tf)
	arg0_8.auctionGameCollectionItem:willExit()

	arg0_8.auctionGameCollectionItem = nil
end

return var0_0
