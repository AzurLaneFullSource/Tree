local var0_0 = class("AuctionGameMainMsgLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainMsgUI"
end

function var0_0.init(arg0_2)
	arg0_2:OverlayPanel(arg0_2._tf, {
		pbList = {
			arg0_2.uiBgBtn
		}
	})
	setText(arg0_2.uiCancelText, i18n("auction_cancel"))
	setText(arg0_2.uiConfirmText, i18n("auction_confirm"))
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:OnCloseBtn()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:OnCloseBtn()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiCancelBtn, function()
		arg0_2:OnCloseBtn()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiConfirmBtn, function()
		existCall(arg0_2.contextData.comformCallback)
		arg0_2:closeView()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_7)
	setText(arg0_7.uiContentText, arg0_7.contextData.content)
end

function var0_0.OnCloseBtn(arg0_8)
	existCall(arg0_8.contextData.cancelCallback)
	arg0_8:closeView()
end

function var0_0.willExit(arg0_9)
	arg0_9:UnOverlayPanel(arg0_9._tf)
end

return var0_0
