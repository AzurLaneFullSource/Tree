local var0_0 = class("AuctionGameMainEventMsgLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainEventMsgUI"
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
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiCancelBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiConfirmBtn, function()
		existCall(arg0_2.contextData.callback)
		arg0_2:closeView()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_7)
	local var0_7 = arg0_7.contextData.eventID
	local var1_7 = pg.auction_event[var0_7]

	setText(arg0_7.uiNameText, var1_7.name)
	setText(arg0_7.uiDescText, var1_7.describe)
	LoadSpriteAsync(var1_7.icon, function(arg0_8)
		if not IsNil(arg0_7.uiIconImage) then
			arg0_7.uiIconImage.sprite = arg0_8
		end
	end)
end

function var0_0.willExit(arg0_9)
	arg0_9:UnOverlayPanel(arg0_9._tf)
end

return var0_0
