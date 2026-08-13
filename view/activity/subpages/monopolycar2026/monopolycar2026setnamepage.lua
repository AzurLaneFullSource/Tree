local var0_0 = class("MonopolyCar2026SetNamePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MonopolyCar2026SetNameUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.confirmBtn = arg0_2._tf:Find("btn")
	arg0_2.input = arg0_2._tf:Find("main/input")
	arg0_2.bgTr = arg0_2._tf:Find("bg")

	setText(arg0_2.confirmBtn:Find("Text"), i18n("word_ok"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

		if not var0_4 or var0_4:isEnd() then
			if arg0_3.callback then
				arg0_3.callback()
			end

			return
		end

		local var1_4 = var0_4:getConfig("config_client").link_act
		local var2_4 = getInputText(arg0_3.input)

		if var2_4 == "" then
			return
		end

		if not nameValidityCheck(var2_4, 0, 20, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"playerinfo_mask_word"
		}) then
			return
		end

		pg.m02:sendNotification(GAME.ACTIVITY_STORE_DATE, {
			intValue = 0,
			activity_id = var1_4,
			strValue = var2_4 or "",
			callback = function()
				if arg0_3.callback then
					arg0_3.callback()
				end
			end
		})
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	arg0_6.callback = arg1_6

	var0_0.super.Show(arg0_6)
	arg0_6:BlurPanel()
end

function var0_0.BlurPanel(arg0_7)
	setParent(arg0_7.bgTr, pg.NewStoryMgr.GetInstance()._go)
	setParent(pg.NewStoryMgr.GetInstance()._go, pg.UIMgr.GetInstance().UIMain)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
end

function var0_0.UnBlurPanel(arg0_8)
	setParent(arg0_8.bgTr, arg0_8._tf)
	arg0_8.bgTr:SetAsFirstSibling()
	setParent(pg.NewStoryMgr.GetInstance()._go, pg.UIMgr.GetInstance().OverlayToast)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf, arg0_8._parentTf)
end

function var0_0.Hide(arg0_9)
	arg0_9:UnBlurPanel()
	var0_0.super.Hide(arg0_9)
end

function var0_0.OnDestroy(arg0_10)
	arg0_10.callback = nil

	if arg0_10:isShowing() then
		arg0_10:Hide()
	end
end

return var0_0
