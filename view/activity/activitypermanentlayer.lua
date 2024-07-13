local var0_0 = class("ActivityPermanentLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ActivitySelectUI"
end

function var0_0.onBackPressed(arg0_2)
	arg0_2:closeView()
end

function var0_0.onBackPressed(arg0_3)
	if isActive(arg0_3.rtMsgbox) then
		arg0_3:hideMsgbox()
	else
		var0_0.super.onBackPressed(arg0_3)
	end
end

function var0_0.init(arg0_4)
	arg0_4.bg = arg0_4._tf:Find("bg_back")

	onButton(arg0_4, arg0_4.bg, function()
		arg0_4:closeView()
	end, SFX_CANCEL)

	arg0_4.btnBack = arg0_4._tf:Find("window/inner/top/back")

	onButton(arg0_4, arg0_4.btnBack, function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	setText(arg0_4._tf:Find("window/inner/top/back/Text"), i18n("activity_permanent_total"))

	arg0_4.btnHelp = arg0_4._tf:Find("window/inner/top/help")

	onButton(arg0_4, arg0_4.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("activity_permanent_help")
		})
	end, SFX_PANEL)

	arg0_4.content = arg0_4._tf:Find("window/inner/content/scroll_rect")
	arg0_4.itemList = UIItemList.New(arg0_4.content, arg0_4.content:Find("item"))

	local var0_4 = getProxy(ActivityPermanentProxy)

	arg0_4.itemList:make(function(arg0_8, arg1_8, arg2_8)
		arg1_8 = arg1_8 + 1

		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg0_4.ids[arg1_8]
			local var1_8 = pg.activity_task_permanent[var0_8]

			setText(arg2_8:Find("main/word/Text"), var1_8.gametip)
			setText(arg2_8:Find("main/Image/tip/Text"), var1_8.gametip_extra)
			GetImageSpriteFromAtlasAsync("activitybanner/" .. var1_8.banner_route, "", arg2_8:Find("main/Image"))
			onButton(arg0_4, arg2_8:Find("main"), function()
				arg0_4:showMsgbox(var0_8)
			end, SFX_PANEL)

			local var2_8 = arg2_8:Find("finish")
			local var3_8 = GetOrAddComponent(var2_8, typeof(CanvasGroup))

			if var0_8 == arg0_4.contextData.finishId then
				arg0_4.childFinish = arg2_8
				var3_8.alpha = 0
			else
				var3_8.alpha = 1
			end

			setText(var2_8:Find("Image/Text"), i18n("activity_permanent_finished"))
			setActive(var2_8, var0_4:isActivityFinish(var0_8))
		end
	end)

	arg0_4.rtMsgbox = arg0_4._tf:Find("Msgbox")

	onButton(arg0_4, arg0_4.rtMsgbox:Find("bg"), function()
		arg0_4:hideMsgbox()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.rtMsgbox:Find("window/top/btnBack"), function()
		arg0_4:hideMsgbox()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.rtMsgbox:Find("window/button_container/custom_button_2"), function()
		arg0_4:hideMsgbox()
	end, SFX_CANCEL)
end

function var0_0.didEnter(arg0_13)
	pg.UIMgr.GetInstance():BlurPanel(arg0_13._tf)
	arg0_13.itemList:align(#arg0_13.ids)

	if arg0_13.childFinish then
		local var0_13 = arg0_13.content:GetComponent(typeof(ScrollRect)).viewport

		scrollTo(arg0_13.content, nil, math.clamp(arg0_13.childFinish.anchoredPosition.y / (arg0_13.content.rect.height - var0_13.rect.height), 0, 1))
		arg0_13:doFinishAnim(arg0_13.childFinish)

		arg0_13.childFinish = nil
	end

	if PlayerPrefs.GetInt("permanent_select", 0) ~= 1 then
		PlayerPrefs.SetInt("permanent_select", 1)
		triggerButton(arg0_13.btnHelp)
	end
end

function var0_0.willExit(arg0_14)
	if isActive(arg0_14.rtMsgbox) then
		arg0_14:hideMsgbox()
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_14._tf)

	if arg0_14.ltId then
		LeanTween.cancel(arg0_14.ltId)

		arg0_14.ltId = nil
	end
end

function var0_0.setActivitys(arg0_15, arg1_15)
	arg0_15.ids = arg1_15

	local var0_15 = getProxy(ActivityPermanentProxy)

	table.sort(arg0_15.ids, function(arg0_16, arg1_16)
		local var0_16 = var0_15:isActivityFinish(arg0_16)
		local var1_16 = var0_15:isActivityFinish(arg1_16)

		if var0_16 == var1_16 then
			return arg0_16 < arg1_16
		else
			return var1_16
		end
	end)
end

function var0_0.doFinishAnim(arg0_17, arg1_17)
	local var0_17 = arg1_17:Find("finish")
	local var1_17 = GetOrAddComponent(var0_17, typeof(CanvasGroup))

	arg0_17.ltId = LeanTween.alphaCanvas(var1_17, 1, 1).uniqueId
end

function var0_0.showMsgbox(arg0_18, arg1_18)
	setText(arg0_18.rtMsgbox:Find("window/button_container/custom_button_1/pic"), i18n("msgbox_text_confirm"))
	setText(arg0_18.rtMsgbox:Find("window/button_container/custom_button_2/pic"), i18n("msgbox_text_cancel"))
	setText(arg0_18.rtMsgbox:Find("window/top/bg/infomation/title"), i18n("words_information"))
	setText(arg0_18.rtMsgbox:Find("window/msg_panel/content"), i18n("activity_permanent_tips1", pg.activity_task_permanent[arg1_18].activity_name))
	setText(arg0_18.rtMsgbox:Find("window/msg_panel/Text"), i18n("activity_permanent_tips4"))
	onButton(arg0_18, arg0_18.rtMsgbox:Find("window/button_container/custom_button_1"), function()
		arg0_18:hideMsgbox()
		arg0_18:emit(ActivityPermanentMediator.START_SELECT, arg1_18)
	end, SFX_CONFIRM)
	setActive(arg0_18.rtMsgbox, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_18.rtMsgbox)
end

function var0_0.hideMsgbox(arg0_20)
	setActive(arg0_20.rtMsgbox, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_20.rtMsgbox)
end

return var0_0
