local var0_0 = class("MailTipsLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MailTipLayersMsgBoxUI"
end

function var0_0.init(arg0_2)
	arg0_2.btnBack = arg0_2._tf:Find("adapt/window/top/btnBack")
	arg0_2.goBtn = arg0_2._tf:Find("adapt/window/button_container/btn_ok")
	arg0_2.title = arg0_2._tf:Find("adapt/window/top/bg/infomation/title")
	arg0_2.bgBack = arg0_2._tf:Find("bg")
	arg0_2.context = arg0_2._tf:Find("adapt/window/msg_panel/content"):GetComponent("RichText")
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	onButton(arg0_3, arg0_3.btnBack, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.bgBack, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3.contextData.onYes()
		arg0_3:closeView()
	end, SFX_CANCEL)

	arg0_3.context.text = arg0_3.contextData.content

	setText(arg0_3.title, i18n("mail_boxtitle_information"))
	setText(arg0_3.goBtn:Find("Text"), i18n("mail_box_confirm"))

	if not pg.NewStoryMgr.GetInstance():IsPlayed("NEW_MAIL_GUIDE") then
		pg.NewGuideMgr.GetInstance():Play("NEW_MAIL_GUIDE")
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "NEW_MAIL_GUIDE"
		})
	end
end

function var0_0.willExit(arg0_7)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf)
end

return var0_0
