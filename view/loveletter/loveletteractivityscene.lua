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
	onButton(arg0_2, arg0_2.btnBack, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.btnHome, function()
		arg0_2:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnSwitch, function()
		local var0_5, var1_5 = arg0_2.activity:GetChangeCount()

		if var0_5 < var1_5 then
			arg0_2:emit(LoveLetterActivityMediator.ON_SELECT_GROUP, arg0_2.activity.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnDaily:Find("content"), function()
		arg0_2:ShowDailyPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnDailyConfirm, function()
		local var0_7 = arg0_2.dailyActivity:getNDay()
		local var1_7 = arg0_2.dailyActivity:getConfig("config_data")[var0_7]

		arg0_2:emit(LoveLetterActivityMediator.ON_DAILY_LOGIN_REWARD, var1_7)
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2.btnDailyClose, function()
		arg0_2:HideDailyPanel()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.btnGift, function()
		arg0_2:emit(LoveLetterActivityMediator.ON_GO_COLLECTION)
	end, SFX_PANEL)
end

function var0_0.SetActivity(arg0_10, arg1_10)
	arg0_10.activity = arg1_10
	arg0_10.ll = getProxy(LoveLetterProxy):GetGroupData(arg0_10.activity:GetTargetGroupId())

	setText(arg0_10.rtDailyPanel:Find("panel/Text"), string.format("are you sure to add extra exp to character:%d ?", arg0_10.ll.groupId))
end

function var0_0.SetDailyActivity(arg0_11, arg1_11)
	arg0_11.dailyActivity = arg1_11

	local var0_11 = arg1_11:readyToAchieve()

	setActive(arg0_11.btnDaily:Find("got"), not var0_11)

	local var1_11 = Color.NewHex("393939")

	var1_11.a = 0.8

	setBlackMask(arg0_11.btnDaily:Find("content"), not var0_11, {
		color = var1_11
	})
	setActive(arg0_11.btnDaily:Find("pick_up"), var0_11)
end

function var0_0.didEnter(arg0_12)
	arg0_12:UpdateSlider()
	arg0_12:UpdatePainting()
	arg0_12:UpdateLoveLetterMedal()

	local var0_12 = {}
	local var1_12 = pg.NewStoryMgr.GetInstance()
	local var2_12 = arg0_12.activity:getNDay()

	for iter0_12, iter1_12 in ipairs(arg0_12.activity:GetConfigClientSetting("story")) do
		if iter0_12 <= var2_12 and not var1_12:IsPlayed(iter1_12[1]) then
			table.insert(var0_12, function(arg0_13)
				var1_12:Play(iter1_12[1], arg0_13)
			end)
		end
	end

	seriesAsync(var0_12, function()
		if not arg0_12.contextData.checkRalizeGift then
			arg0_12.contextData.checkRalizeGift = true

			if getProxy(LoveLetterProxy):IsTipRealizeGift() then
				arg0_12:emit(LoveLetterActivityMediator.ON_REALIZE_GIFT)
			end
		end
	end)
end

function var0_0.UpdateSlider(arg0_15)
	local var0_15, var1_15 = arg0_15.activity:GetDailyProgress()

	setText(arg0_15.rtSlider:Find("Slider/progress"), var0_15 .. "/" .. var1_15)
	setSlider(arg0_15.rtSlider:Find("Slider"), 0, var1_15, var0_15)

	local var2_15, var3_15 = arg0_15.ll:GetDisplayExp()

	if var3_15 == 0 then
		setSlider(arg0_15.rtNow:Find("Slider"), 0, 1, 1)
	else
		setSlider(arg0_15.rtNow:Find("Slider"), 0, var3_15, var2_15)
	end

	setText(arg0_15.rtNow:Find("Text"), string.format(setColorStr("%d", "#CF90A8") .. "/%d", var2_15, var3_15))
end

function var0_0.UpdatePainting(arg0_16)
	local var0_16, var1_16 = arg0_16.activity:GetChangeCount()

	setText(arg0_16.btnSwitch:Find("Text"), string.format("%d/%d", var1_16 - var0_16, var1_16))

	local var2_16 = arg0_16.ll:GetPainting()

	if arg0_16.paint == var2_16 then
		return
	end

	if arg0_16.paint then
		retPaintingPrefab(arg0_16.rtPainting, arg0_16.paint)

		arg0_16.paint = nil
	end

	arg0_16.paint = var2_16

	setPaintingPrefabAsync(arg0_16.rtPainting, arg0_16.paint, "mainNormal")
end

function var0_0.UpdateLoveLetterMedal(arg0_17, arg1_17)
	setActive(arg0_17.btnGift:Find("tip"), getProxy(LoveLetterProxy):IsTipRealizeGift())

	arg1_17 = arg1_17 or arg0_17.rtNow:Find("medal")

	setLoveLetterMedal(arg1_17, arg0_17.ll, {
		showPickUp = arg0_17.ll:CanLevelUp() and arg0_17.ll.level < arg0_17.ll:GetMaxLevel()
	})
	onButton(arg0_17, arg0_17.rtNow, function()
		arg0_17:emit(LoveLetterActivityMediator.ON_GO_TROPHY)
	end, SFX_PANEL)
end

function var0_0.ShowDailyPanel(arg0_19)
	setActive(arg0_19.rtDailyPanel, true)
	arg0_19:UpdateLoveLetterMedal(arg0_19.rtDailyNow:Find("medal"))

	local var0_19, var1_19 = arg0_19.ll:GetDisplayExp()

	if var1_19 == 0 then
		setSlider(arg0_19.rtDailyNow:Find("Slider"), 0, 1, 1)
	else
		setSlider(arg0_19.rtDailyNow:Find("Slider"), 0, var1_19, var0_19)
	end

	setText(arg0_19.rtDailyNow:Find("Text"), string.format(setColorStr("%d", "#CF90A8") .. "/%d", var0_19, var1_19))
	setText(arg0_19.textDailyContent, i18n("loveactivity_ui_4", arg0_19.ll:GetName(), arg0_19.dailyActivity:GetConfigClientSetting("exp")))
	arg0_19:BlurPanel(arg0_19.rtDailyPanel)
end

function var0_0.HideDailyPanel(arg0_20)
	setActive(arg0_20.rtDailyPanel, false)
	arg0_20:UnOverlayPanel(arg0_20.rtDailyPanel)
end

function var0_0.onBackPressed(arg0_21)
	if isActive(arg0_21.rtDailyPanel) then
		arg0_21:HideDailyPanel()
	else
		var0_0.super.onBackPressed(arg0_21)
	end
end

function var0_0.willExit(arg0_22)
	if arg0_22.paint then
		retPaintingPrefab(arg0_22.rtPainting, arg0_22.paint)

		arg0_22.paint = nil
	end

	if arg0_22.rtNow:Find("medal").childCount > 0 then
		eachChild(arg0_22.rtNow:Find("medal"), function(arg0_23, arg1_23)
			returnLoveLetterMedal(arg0_23)
		end)
	end
end

return var0_0
