local var0_0 = class("LoveLetterActivityScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "LoveLetterActivityUI"
end

var0_0.optionsPath = {}

function var0_0.init(arg0_2)
	setText(arg0_2.rtSlider:Find("Text"), i18n("loveactivity_ui_1"))
	setText(arg0_2.textDailyTitle, i18n("mail_boxtitle_information"))
	setText(arg0_2.btnDaily:Find("content/Text"), i18n("loveactivity_ui_2"))
	setText(arg0_2.btnGift:Find("Text"), i18n("loveactivity_ui_3"))
	setText(arg0_2.textUITitle, i18n("activity_ninjia_main_title"))
	setText(arg0_2.btnDailyConfirm:Find("Text"), i18n("mail_box_confirm"))
	onButton(arg0_2, findTF(arg0_2._tf, "adapt/TopPage/top/deco/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.loveactivity_help_tips.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.btnBack, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.btnHome, function()
		arg0_2:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnSwitch, function()
		local var0_6, var1_6 = arg0_2.activity:GetChangeCount()

		if var0_6 < var1_6 then
			arg0_2:emit(LoveLetterActivityMediator.ON_SELECT_GROUP, arg0_2.activity.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnDaily:Find("content"), function()
		arg0_2:ShowDailyPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnDailyConfirm, function()
		local var0_8 = arg0_2.dailyActivity:getNDay()

		for iter0_8 = 1, var0_8 do
			local var1_8 = arg0_2.dailyActivity:getConfig("config_data")[iter0_8]
			local var2_8 = var1_8 and getProxy(TaskProxy):getTaskVO(var1_8) or nil

			if var2_8 and var2_8:getTaskStatus() == 1 then
				arg0_2:emit(LoveLetterActivityMediator.ON_DAILY_LOGIN_REWARD, var1_8)

				return
			end
		end
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2.btnDailyClose, function()
		arg0_2:HideDailyPanel()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.btnGift, function()
		arg0_2:emit(LoveLetterActivityMediator.ON_GO_COLLECTION)
	end, SFX_PANEL)
end

function var0_0.SetActivity(arg0_11, arg1_11)
	arg0_11.activity = arg1_11
	arg0_11.ll = getProxy(LoveLetterProxy):GetGroupData(arg0_11.activity:GetTargetGroupId())

	setText(arg0_11.rtDailyPanel:Find("panel/Text"), string.format("are you sure to add extra exp to character:%d ?", arg0_11.ll.groupId))
end

function var0_0.SetDailyActivity(arg0_12, arg1_12)
	arg0_12.dailyActivity = arg1_12

	local var0_12 = arg1_12:readyToAchieve()

	setActive(arg0_12.btnDaily:Find("got"), not var0_12)

	local var1_12 = Color.NewHex("393939")

	var1_12.a = 0.8

	setBlackMask(arg0_12.btnDaily:Find("content"), not var0_12, {
		color = var1_12
	})
	setActive(arg0_12.btnDaily:Find("pick_up"), var0_12)
end

function var0_0.didEnter(arg0_13)
	arg0_13:UpdateSlider()
	arg0_13:UpdatePainting()
	arg0_13:UpdateLoveLetterMedal()

	local var0_13 = {}
	local var1_13 = pg.NewStoryMgr.GetInstance()
	local var2_13 = arg0_13.activity:getNDay()

	for iter0_13, iter1_13 in ipairs(arg0_13.activity:GetConfigClientSetting("story")) do
		if iter0_13 <= var2_13 and not var1_13:IsPlayed(iter1_13[1]) then
			table.insert(var0_13, function(arg0_14)
				var1_13:Play(iter1_13[1], arg0_14)
			end)
		end
	end

	seriesAsync(var0_13, function()
		if not arg0_13.contextData.checkRalizeGift then
			arg0_13.contextData.checkRalizeGift = true

			if getProxy(LoveLetterProxy):IsTipRealizeGift() then
				arg0_13:emit(LoveLetterActivityMediator.ON_REALIZE_GIFT)
			end
		end

		checkFirstHelpShow("loveactivity_help_tips")
	end)
end

function var0_0.UpdateSlider(arg0_16)
	local var0_16, var1_16 = arg0_16.activity:GetDailyProgress()

	setText(arg0_16.rtSlider:Find("Slider/progress"), var0_16 .. "/" .. var1_16)
	setSlider(arg0_16.rtSlider:Find("Slider"), 0, var1_16, var0_16)

	local var2_16, var3_16 = arg0_16.ll:GetDisplayExp()

	if var3_16 == 0 then
		setSlider(arg0_16.rtNow:Find("Slider"), 0, 1, 1)
	else
		setSlider(arg0_16.rtNow:Find("Slider"), 0, var3_16, var2_16)
	end

	setText(arg0_16.rtNow:Find("Text"), string.format(setColorStr("%d", "#CF90A8") .. "/%d", var2_16, var3_16))
end

function var0_0.UpdatePainting(arg0_17)
	local var0_17, var1_17 = arg0_17.activity:GetChangeCount()

	setText(arg0_17.btnSwitch:Find("Text"), string.format("%d/%d", var1_17 - var0_17, var1_17))

	local var2_17 = arg0_17.ll:GetPainting()

	if arg0_17.paint == var2_17 then
		return
	end

	if arg0_17.paint then
		retPaintingPrefab(arg0_17.rtPainting, arg0_17.paint)

		arg0_17.paint = nil
	end

	arg0_17.paint = var2_17

	setPaintingPrefabAsync(arg0_17.rtPainting, arg0_17.paint, "mainNormal")
end

function var0_0.UpdateLoveLetterMedal(arg0_18, arg1_18)
	setActive(arg0_18.btnGift:Find("tip"), getProxy(LoveLetterProxy):IsTipRealizeGift())

	arg1_18 = arg1_18 or arg0_18.rtNow:Find("medal")

	setLoveLetterMedal(arg1_18, arg0_18.ll, {
		showPickUp = arg0_18.ll:CanLevelUp() and arg0_18.ll.level < arg0_18.ll:GetMaxLevel()
	})
	onButton(arg0_18, arg0_18.rtNow, function()
		arg0_18:emit(LoveLetterActivityMediator.ON_GO_TROPHY)
	end, SFX_PANEL)
end

function var0_0.ShowDailyPanel(arg0_20)
	setActive(arg0_20.rtDailyPanel, true)
	arg0_20:UpdateLoveLetterMedal(arg0_20.rtDailyNow:Find("medal"))

	local var0_20, var1_20 = arg0_20.ll:GetDisplayExp()

	if var1_20 == 0 then
		setSlider(arg0_20.rtDailyNow:Find("Slider"), 0, 1, 1)
	else
		setSlider(arg0_20.rtDailyNow:Find("Slider"), 0, var1_20, var0_20)
	end

	setText(arg0_20.rtDailyNow:Find("Text"), string.format(setColorStr("%d", "#CF90A8") .. "/%d", var0_20, var1_20))

	local var2_20 = arg0_20.dailyActivity:getNDay()
	local var3_20 = 1

	for iter0_20 = 1, var2_20 do
		local var4_20 = arg0_20.dailyActivity:getConfig("config_data")[iter0_20]
		local var5_20 = var4_20 and getProxy(TaskProxy):getTaskVO(var4_20) or nil

		if var5_20 and var5_20:getTaskStatus() == 1 then
			var3_20 = iter0_20

			break
		end
	end

	setText(arg0_20.textDailyContent, i18n("loveactivity_ui_4_" .. var3_20, arg0_20.ll:GetName(), arg0_20.dailyActivity:GetConfigClientSetting("exp")))
	arg0_20:BlurPanel(arg0_20.rtDailyPanel)
end

function var0_0.HideDailyPanel(arg0_21)
	setActive(arg0_21.rtDailyPanel, false)
	arg0_21:UnOverlayPanel(arg0_21.rtDailyPanel)
end

function var0_0.onBackPressed(arg0_22)
	if isActive(arg0_22.rtDailyPanel) then
		arg0_22:HideDailyPanel()
	else
		var0_0.super.onBackPressed(arg0_22)
	end
end

function var0_0.willExit(arg0_23)
	if arg0_23.paint then
		retPaintingPrefab(arg0_23.rtPainting, arg0_23.paint)

		arg0_23.paint = nil
	end

	if arg0_23.rtNow:Find("medal").childCount > 0 then
		eachChild(arg0_23.rtNow:Find("medal"), function(arg0_24, arg1_24)
			returnLoveLetterMedal(arg0_24)
		end)
	end
end

return var0_0
