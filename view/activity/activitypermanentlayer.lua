local var0 = class("ActivityPermanentLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "ActivitySelectUI"
end

function var0.onBackPressed(arg0)
	arg0:closeView()
end

function var0.onBackPressed(arg0)
	if isActive(arg0.rtMsgbox) then
		arg0:hideMsgbox()
	else
		var0.super.onBackPressed(arg0)
	end
end

function var0.init(arg0)
	arg0.bg = arg0._tf:Find("bg_back")

	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.btnBack = arg0._tf:Find("window/inner/top/back")

	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	setText(arg0._tf:Find("window/inner/top/back/Text"), i18n("activity_permanent_total"))

	arg0.btnHelp = arg0._tf:Find("window/inner/top/help")

	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("activity_permanent_help")
		})
	end, SFX_PANEL)

	arg0.content = arg0._tf:Find("window/inner/content/scroll_rect")
	arg0.itemList = UIItemList.New(arg0.content, arg0.content:Find("item"))

	local var0 = getProxy(ActivityPermanentProxy)

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.ids[arg1]
			local var1 = pg.activity_task_permanent[var0]

			setText(arg2:Find("main/word/Text"), var1.gametip)
			setText(arg2:Find("main/Image/tip/Text"), var1.gametip_extra)
			GetImageSpriteFromAtlasAsync("activitybanner/" .. var1.banner_route, "", arg2:Find("main/Image"))
			onButton(arg0, arg2:Find("main"), function()
				arg0:showMsgbox(var0)
			end, SFX_PANEL)

			local var2 = arg2:Find("finish")
			local var3 = GetOrAddComponent(var2, typeof(CanvasGroup))

			if var0 == arg0.contextData.finishId then
				arg0.childFinish = arg2
				var3.alpha = 0
			else
				var3.alpha = 1
			end

			setText(var2:Find("Image/Text"), i18n("activity_permanent_finished"))
			setActive(var2, var0:isActivityFinish(var0))
		end
	end)

	arg0.rtMsgbox = arg0._tf:Find("Msgbox")

	onButton(arg0, arg0.rtMsgbox:Find("bg"), function()
		arg0:hideMsgbox()
	end, SFX_CANCEL)
	onButton(arg0, arg0.rtMsgbox:Find("window/top/btnBack"), function()
		arg0:hideMsgbox()
	end, SFX_CANCEL)
	onButton(arg0, arg0.rtMsgbox:Find("window/button_container/custom_button_2"), function()
		arg0:hideMsgbox()
	end, SFX_CANCEL)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0.itemList:align(#arg0.ids)

	if arg0.childFinish then
		local var0 = arg0.content:GetComponent(typeof(ScrollRect)).viewport

		scrollTo(arg0.content, nil, math.clamp(arg0.childFinish.anchoredPosition.y / (arg0.content.rect.height - var0.rect.height), 0, 1))
		arg0:doFinishAnim(arg0.childFinish)

		arg0.childFinish = nil
	end

	if PlayerPrefs.GetInt("permanent_select", 0) ~= 1 then
		PlayerPrefs.SetInt("permanent_select", 1)
		triggerButton(arg0.btnHelp)
	end
end

function var0.willExit(arg0)
	if isActive(arg0.rtMsgbox) then
		arg0:hideMsgbox()
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.ltId then
		LeanTween.cancel(arg0.ltId)

		arg0.ltId = nil
	end
end

function var0.setActivitys(arg0, arg1)
	arg0.ids = arg1

	local var0 = getProxy(ActivityPermanentProxy)

	table.sort(arg0.ids, function(arg0, arg1)
		local var0 = var0:isActivityFinish(arg0)
		local var1 = var0:isActivityFinish(arg1)

		if var0 == var1 then
			return arg0 < arg1
		else
			return var1
		end
	end)
end

function var0.doFinishAnim(arg0, arg1)
	local var0 = arg1:Find("finish")
	local var1 = GetOrAddComponent(var0, typeof(CanvasGroup))

	arg0.ltId = LeanTween.alphaCanvas(var1, 1, 1).uniqueId
end

function var0.showMsgbox(arg0, arg1)
	setText(arg0.rtMsgbox:Find("window/button_container/custom_button_1/pic"), i18n("msgbox_text_confirm"))
	setText(arg0.rtMsgbox:Find("window/button_container/custom_button_2/pic"), i18n("msgbox_text_cancel"))
	setText(arg0.rtMsgbox:Find("window/top/bg/infomation/title"), i18n("words_information"))
	setText(arg0.rtMsgbox:Find("window/msg_panel/content"), i18n("activity_permanent_tips1", pg.activity_task_permanent[arg1].activity_name))
	setText(arg0.rtMsgbox:Find("window/msg_panel/Text"), i18n("activity_permanent_tips4"))
	onButton(arg0, arg0.rtMsgbox:Find("window/button_container/custom_button_1"), function()
		arg0:hideMsgbox()
		arg0:emit(ActivityPermanentMediator.START_SELECT, arg1)
	end, SFX_CONFIRM)
	setActive(arg0.rtMsgbox, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.rtMsgbox)
end

function var0.hideMsgbox(arg0)
	setActive(arg0.rtMsgbox, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.rtMsgbox)
end

return var0
