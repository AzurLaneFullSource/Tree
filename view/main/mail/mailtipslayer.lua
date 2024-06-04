local var0 = class("MailTipsLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "MailTipLayersMsgBoxUI"
end

function var0.init(arg0)
	arg0.btnBack = arg0._tf:Find("adapt/window/top/btnBack")
	arg0.goBtn = arg0._tf:Find("adapt/window/button_container/btn_ok")
	arg0.title = arg0._tf:Find("adapt/window/top/bg/infomation/title")
	arg0.bgBack = arg0._tf:Find("bg")
	arg0.context = arg0._tf:Find("adapt/window/msg_panel/content"):GetComponent("RichText")
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.bgBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.goBtn, function()
		arg0.contextData.onYes()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.context.text = arg0.contextData.content

	setText(arg0.title, i18n("mail_boxtitle_information"))
	setText(arg0.goBtn:Find("Text"), i18n("mail_box_confirm"))

	if not pg.NewStoryMgr.GetInstance():IsPlayed("NEW_MAIL_GUIDE") then
		pg.NewGuideMgr.GetInstance():Play("NEW_MAIL_GUIDE")
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "NEW_MAIL_GUIDE"
		})
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
