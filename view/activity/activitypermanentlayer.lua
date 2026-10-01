local var0_0 = class("ActivityPermanentLayer", import("..base.BaseUI"))

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {}
	local var1_1 = getProxy(ActivityPermanentProxy):getActivityIdsByType(ActivityPermanentProxy.TYPE_NORMAL_ACTIVITY)

	for iter0_1, iter1_1 in ipairs(var1_1) do
		local var2_1 = pg.activity_task_permanent[iter1_1]

		table.insert(var0_1, "activitybanner/" .. var2_1.banner_route)
	end

	table.insertto(var0_1, var0_0.super.getResource(arg0_1, arg1_1))

	return var0_1
end

function var0_0.getUIName(arg0_2)
	return "ActivitySelectUI"
end

function var0_0.onBackPressed(arg0_3)
	arg0_3:closeView()
end

function var0_0.onBackPressed(arg0_4)
	if isActive(arg0_4.rtMsgbox) then
		arg0_4:hideMsgbox()
	else
		var0_0.super.onBackPressed(arg0_4)
	end
end

function var0_0.init(arg0_5)
	arg0_5.bg = arg0_5._tf:Find("bg_back")

	onButton(arg0_5, arg0_5.bg, function()
		arg0_5:closeView()
	end, SFX_CANCEL)

	arg0_5.btnBack = arg0_5._tf:Find("window/inner/top/back")

	onButton(arg0_5, arg0_5.btnBack, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	setText(arg0_5._tf:Find("window/inner/top/back/Text"), i18n("activity_permanent_total"))

	arg0_5.btnHelp = arg0_5._tf:Find("window/inner/top/help")

	onButton(arg0_5, arg0_5.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("activity_permanent_help")
		})
	end, SFX_PANEL)

	arg0_5.content = arg0_5._tf:Find("window/inner/content/scroll_rect")
	arg0_5.itemList = UIItemList.New(arg0_5.content, arg0_5.content:Find("item"))

	local var0_5 = getProxy(ActivityPermanentProxy)

	arg0_5.itemList:make(function(arg0_9, arg1_9, arg2_9)
		arg1_9 = arg1_9 + 1

		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_5.ids[arg1_9]
			local var1_9 = pg.activity_task_permanent[var0_9]

			setText(arg2_9:Find("main/word/Text"), var1_9.gametip)
			setText(arg2_9:Find("main/Image/tip/Text"), var1_9.gametip_extra)
			GetImageSpriteFromAtlasAsync("activitybanner/" .. var1_9.banner_route, "", arg2_9:Find("main/Image"))
			onButton(arg0_5, arg2_9:Find("main"), function()
				arg0_5:showMsgbox(var0_9)
			end, SFX_PANEL)

			local var2_9 = arg2_9:Find("finish")
			local var3_9 = GetOrAddComponent(var2_9, typeof(CanvasGroup))

			if var0_9 == arg0_5.contextData.finishId then
				arg0_5.childFinish = arg2_9
				var3_9.alpha = 0
			else
				var3_9.alpha = 1
			end

			setText(var2_9:Find("Image/Text"), i18n("activity_permanent_finished"))
			setActive(var2_9, var0_5:isActivityFinish(var0_9))
		end
	end)

	arg0_5.rtMsgbox = arg0_5._tf:Find("Msgbox")

	onButton(arg0_5, arg0_5.rtMsgbox:Find("bg"), function()
		arg0_5:hideMsgbox()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.rtMsgbox:Find("window/top/btnBack"), function()
		arg0_5:hideMsgbox()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.rtMsgbox:Find("window/button_container/custom_button_2"), function()
		arg0_5:hideMsgbox()
	end, SFX_CANCEL)
end

function var0_0.didEnter(arg0_14)
	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
	arg0_14.itemList:align(#arg0_14.ids)

	if arg0_14.childFinish then
		local var0_14 = arg0_14.content:GetComponent(typeof(ScrollRect)).viewport

		scrollTo(arg0_14.content, nil, math.clamp(arg0_14.childFinish.anchoredPosition.y / (arg0_14.content.rect.height - var0_14.rect.height), 0, 1))
		arg0_14:doFinishAnim(arg0_14.childFinish)

		arg0_14.childFinish = nil
	end

	if PlayerPrefs.GetInt("permanent_select", 0) ~= 1 then
		PlayerPrefs.SetInt("permanent_select", 1)
		triggerButton(arg0_14.btnHelp)
	end
end

function var0_0.willExit(arg0_15)
	if isActive(arg0_15.rtMsgbox) then
		arg0_15:hideMsgbox()
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._tf)

	if arg0_15.ltId then
		LeanTween.cancel(arg0_15.ltId)

		arg0_15.ltId = nil
	end
end

function var0_0.setActivitys(arg0_16, arg1_16)
	arg0_16.ids = arg1_16

	local var0_16 = getProxy(ActivityPermanentProxy)

	table.sort(arg0_16.ids, function(arg0_17, arg1_17)
		local var0_17 = var0_16:isActivityFinish(arg0_17)
		local var1_17 = var0_16:isActivityFinish(arg1_17)

		if var0_17 == var1_17 then
			return arg0_17 < arg1_17
		else
			return var1_17
		end
	end)
end

function var0_0.doFinishAnim(arg0_18, arg1_18)
	local var0_18 = arg1_18:Find("finish")
	local var1_18 = GetOrAddComponent(var0_18, typeof(CanvasGroup))

	arg0_18.ltId = LeanTween.alphaCanvas(var1_18, 1, 1).uniqueId
end

function var0_0.showMsgbox(arg0_19, arg1_19)
	setText(arg0_19.rtMsgbox:Find("window/button_container/custom_button_1/pic"), i18n("msgbox_text_confirm"))
	setText(arg0_19.rtMsgbox:Find("window/button_container/custom_button_2/pic"), i18n("msgbox_text_cancel"))
	setText(arg0_19.rtMsgbox:Find("window/top/bg/infomation/title"), i18n("words_information"))
	setText(arg0_19.rtMsgbox:Find("window/msg_panel/content"), i18n("activity_permanent_tips1", pg.activity_task_permanent[arg1_19].activity_name))
	setText(arg0_19.rtMsgbox:Find("window/msg_panel/Text"), i18n("activity_permanent_tips4"))
	onButton(arg0_19, arg0_19.rtMsgbox:Find("window/button_container/custom_button_1"), function()
		arg0_19:hideMsgbox()
		arg0_19:emit(ActivityPermanentMediator.START_SELECT, arg1_19)
	end, SFX_CONFIRM)
	setActive(arg0_19.rtMsgbox, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_19.rtMsgbox)
end

function var0_0.hideMsgbox(arg0_21)
	setActive(arg0_21.rtMsgbox, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21.rtMsgbox)
end

return var0_0
