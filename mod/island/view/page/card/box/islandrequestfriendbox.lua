local var0_0 = class("IslandRequestFriendBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandRequestFriendBox"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("frame/title"), i18n("word_apply"))
	setText(arg0_2._tf:Find("Text"), i18n("friend_request_msg_title"))

	arg0_2.closeBtn = arg0_2._tf:Find("frame/close")
	arg0_2.requestBtn = arg0_2._tf:Find("request")

	setText(arg0_2.requestBtn:Find("Text"), i18n("word_apply"))

	arg0_2.input = arg0_2._tf:Find("InputField")

	setText(arg0_2.input:Find("Placeholder"), i18n("friend_request_msg_placeholder"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.requestBtn, function()
		local var0_5 = getInputText(arg0_3.input)

		pg.m02:sendNotification(GAME.FRIEND_SEND_REQUEST, {
			id = arg0_3.userId,
			msg = var0_5
		})
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)

	arg0_6.userId = arg1_6

	setInputText(arg0_6.input, "")
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
end

function var0_0.Hide(arg0_7)
	var0_0.super.Hide(arg0_7)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7._tf, arg0_7._parentTf)
end

function var0_0.OnDestroy(arg0_8)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf, arg0_8._parentTf)
end

return var0_0
