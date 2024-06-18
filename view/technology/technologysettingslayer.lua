local var0_0 = class("TechnologySettingsLayer", import("..base.BaseUI"))

var0_0.TEC_PAGE_TENDENCY = 1
var0_0.TEC_PAGE_CATCHUP_TARGET1 = 2
var0_0.TEC_PAGE_CATCHUP_TARGET2 = 3
var0_0.TEC_PAGE_CATCHUP_TARGET3 = 4
var0_0.TEC_PAGE_CATCHUP_TARGET4 = 5
var0_0.TEC_PAGE_CATCHUP_TARGET5 = 6
var0_0.TEC_PAGE_CATCHUP_ACT = 99
var0_0.PANEL_INTO_TIME = 0.15
var0_0.SELECT_TENDENCY_FADE_TIME = 0.3
var0_0.SELECT_CHAR_LIGHT_FADE_TIME = 0.3
var0_0.CATCHUP_CLASSES = {
	import("view.technology.TargetCatchup.TargetCatchupPanel1"),
	import("view.technology.TargetCatchup.TargetCatchupPanel2"),
	import("view.technology.TargetCatchup.TargetCatchupPanel3"),
	import("view.technology.TargetCatchup.TargetCatchupPanel4"),
	import("view.technology.TargetCatchup.TargetCatchupPanel5")
}
var0_0.CATCHUP_VERSION = 5

function var0_0.getUIName(arg0_1)
	return "TechnologySettingsUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initTendencyPage()
	arg0_2:initActCatchupPage()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	arg0_3:resetLeftBtnUnsel()
	arg0_3:updateTendencyBtn(arg0_3.curTendency)
	arg0_3:updateTargetCatchupBtns()
	arg0_3:updateActCatchupBtn()
	triggerButton(arg0_3.leftBtnList[1])
	triggerToggle(arg0_3.showFinish, arg0_3.showFinishFlag == 1 and true or false)
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)

	if arg0_4.actCatchupTimer then
		arg0_4.actCatchupTimer:Stop()

		arg0_4.actCatchupTimer = nil
	end

	for iter0_4, iter1_4 in pairs(arg0_4.catchupPanels) do
		iter1_4:willExit()
	end

	arg0_4.loader:Clear()
end

function var0_0.initData(arg0_5)
	arg0_5.technologyProxy = getProxy(TechnologyProxy)
	arg0_5.bayProxy = getProxy(BayProxy)
	arg0_5.bagProxy = getProxy(BagProxy)
	arg0_5.curPageID = 0
	arg0_5.curTendency = arg0_5.technologyProxy:getTendency(2)
	arg0_5.curSelectedIndex = 0
	arg0_5.reSelectTag = false
	arg0_5.actCatchup = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)
	arg0_5.isShowActCatchup = arg0_5.actCatchup and not arg0_5.actCatchup:isEnd()
	arg0_5.loader = AutoLoader.New()
end

function var0_0.findUI(arg0_6)
	arg0_6.bg = arg0_6:findTF("BG")

	local var0_6 = arg0_6:findTF("BackTips/ClickText", arg0_6.bg)

	setText(var0_6, i18n("click_back_tip"))

	local var1_6 = arg0_6:findTF("Panel")
	local var2_6 = arg0_6:findTF("LeftScrollViewMask/LeftScrollView/LeftBtnList", var1_6)

	arg0_6.leftBtnList = {}
	arg0_6.tendencyBtn = arg0_6:findTF("TendencyBtn", var2_6)
	arg0_6.leftBtnList[var0_0.TEC_PAGE_TENDENCY] = arg0_6.tendencyBtn
	arg0_6.catchupBtns = {}

	for iter0_6 = 1, var0_0.CATCHUP_VERSION do
		arg0_6.catchupBtns[iter0_6] = cloneTplTo(arg0_6:findTF("TargetCatchupBtn_tpl", var2_6), var2_6)
		arg0_6.leftBtnList[iter0_6 + 1] = arg0_6.catchupBtns[iter0_6]
	end

	arg0_6.actCatchupBtn = arg0_6:findTF("ActCatchupBtn", var2_6)

	arg0_6.actCatchupBtn:SetAsLastSibling()

	arg0_6.leftBtnList[var0_0.TEC_PAGE_CATCHUP_ACT] = arg0_6.actCatchupBtn

	local var3_6 = arg0_6:findTF("RightPanelContainer", var1_6)

	arg0_6.rightPageTFList = {}
	arg0_6.tendencyPanel = arg0_6:findTF("TecTendencyPanel", var3_6)
	arg0_6.rightPageTFList[var0_0.TEC_PAGE_TENDENCY] = arg0_6.tendencyPanel
	arg0_6.catchupPanels = {}
	arg0_6.actCatchupPanel = arg0_6:findTF("ActCatchupPanel", var3_6)
	arg0_6.rightPageTFList[var0_0.TEC_PAGE_CATCHUP_ACT] = arg0_6.actCatchupPanel
	arg0_6.showFinish = arg0_6:findTF("ShowFinishToggle")

	setText(arg0_6:findTF("Label", arg0_6.showFinish), i18n("tec_target_catchup_show_the_finished_version"))

	arg0_6.showFinishFlag = PlayerPrefs.GetInt("isShowFinishCatchupVersion") or 0

	if var0_0.CATCHUP_VERSION < 1 then
		setActive(arg0_6.showFinish, false)
	end
end

function var0_0.addListener(arg0_7)
	onButton(arg0_7, arg0_7.bg, function()
		arg0_7:closeView()
	end, SFX_PANEL)

	for iter0_7, iter1_7 in pairs(arg0_7.leftBtnList) do
		onButton(arg0_7, iter1_7, function()
			if arg0_7.onPageSwitchAnim then
				return
			end

			if arg0_7.curPageID ~= iter0_7 then
				arg0_7:resetLeftBtnUnsel()
				setActive(arg0_7:findTF("Selected", iter1_7), true)
				arg0_7:switchRightPage(iter0_7)
			end
		end, SFX_PANEL)
	end

	onToggle(arg0_7, arg0_7.showFinish, function(arg0_10)
		if var0_0.CATCHUP_VERSION < 1 then
			return
		end

		for iter0_10, iter1_10 in pairs(arg0_7.catchupBtns) do
			if iter0_10 <= var0_0.CATCHUP_VERSION then
				if arg0_7.technologyProxy:getCatchupState(iter0_10) == TechnologyCatchup.STATE_FINISHED_ALL and not arg0_10 then
					setActive(iter1_10, false)
				else
					setActive(iter1_10, true)
				end
			end
		end

		arg0_7.showFinishFlag = arg0_10 and 1 or 0

		PlayerPrefs.SetInt("isShowFinishCatchupVersion", arg0_7.showFinishFlag)
		triggerButton(arg0_7.leftBtnList[1])
	end, SFX_PANEL)
end

function var0_0.resetLeftBtnUnsel(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.leftBtnList) do
		local var0_11 = arg0_11:findTF("Selected", iter1_11)

		setActive(var0_11, false)
	end
end

function var0_0.switchRightPage(arg0_12, arg1_12)
	seriesAsync({
		function(arg0_13)
			if not arg0_12.rightPageTFList[arg1_12] then
				local var0_13 = arg1_12 - 1
				local var1_13 = arg0_12:findTF("Panel/RightPanelContainer")

				arg0_12.catchupPanels[var0_13] = var0_0.CATCHUP_CLASSES[var0_13].New(nil, function()
					arg0_12.rightPageTFList[arg1_12] = arg0_12.catchupPanels[var0_13]._go

					setActive(arg0_12.rightPageTFList[arg1_12], false)
					SetParent(arg0_12.rightPageTFList[arg1_12], var1_13, false)
					arg0_13()
				end)
			else
				arg0_13()
			end
		end,
		function(arg0_15)
			local var0_15 = arg0_12.rightPageTFList[arg0_12.curPageID]
			local var1_15 = arg0_12.rightPageTFList[arg1_12]

			setActive(var1_15, true)

			arg0_12.onPageSwitchAnim = true

			arg0_12:managedTween(LeanTween.alphaCanvas, function()
				arg0_12.onPageSwitchAnim = false
			end, GetOrAddComponent(var1_15, typeof(CanvasGroup)), 1, var0_0.PANEL_INTO_TIME):setFrom(0)

			if var0_15 then
				arg0_12:managedTween(LeanTween.alphaCanvas, function()
					setActive(var0_15, false)
				end, GetOrAddComponent(var0_15, typeof(CanvasGroup)), 0, var0_0.PANEL_INTO_TIME):setFrom(1)
			end

			arg0_12.curPageID = arg1_12

			if arg1_12 == var0_0.TEC_PAGE_TENDENCY then
				arg0_12:updateTendencyPage(arg0_12.curTendency)
			elseif arg1_12 == var0_0.TEC_PAGE_CATCHUP_ACT then
				arg0_12:updateActCatchupPage()
			else
				arg0_12:updateTargetCatchupPage(arg1_12 - 1)
			end
		end
	})
end

function var0_0.initTendencyPage(arg0_18)
	local var0_18 = getProxy(TechnologyProxy):getConfigMaxVersion()
	local var1_18 = arg0_18:findTF("TecItemList", arg0_18.tendencyPanel)
	local var2_18 = UIItemList.New(var1_18, var1_18:Find("tpl"))

	var2_18:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = arg1_19 > 0 and i18n("tec_tendency_x", i18n("number_" .. arg1_19)) or i18n("tec_tendency_0")

			setText(arg2_19:Find("UnSelect/Text"), var0_19)
			setText(arg2_19:Find("Selected/Text"), var0_19)
			onButton(arg0_18, arg2_19, function()
				if arg0_18.curTendency ~= arg1_19 then
					arg0_18:emit(TechnologySettingsMediator.CHANGE_TENDENCY, arg1_19)
				end
			end, SFX_PANEL)
		end
	end)
	var2_18:align(var0_18 + 1)
end

function var0_0.updateTendencyPage(arg0_21, arg1_21)
	local var0_21 = arg0_21:findTF("TecItemList", arg0_21.tendencyPanel)

	setActive(var0_21:GetChild(arg0_21.curTendency):Find("Selected"), false)

	local var1_21 = var0_21:GetChild(arg1_21):Find("Selected")

	setActive(var1_21, true)
	setImageAlpha(var1_21:Find("Image"), 0)
	arg0_21:managedTween(LeanTween.alpha, nil, var1_21:Find("Image"), 1, var0_0.SELECT_TENDENCY_FADE_TIME):setFrom(0)

	local var2_21 = arg0_21:findTF("TendencyNum", arg0_21.tendencyPanel)

	setImageAlpha(var2_21:Find("Image"), 0)

	if arg1_21 > 0 then
		GetImageSpriteFromAtlasAsync("ui/technologysettingsui_atlas", "right_tendency_num_" .. arg1_21, var2_21:Find("Image"), true)
		arg0_21:managedTween(LeanTween.alpha, nil, var2_21:Find("Image"), 1, var0_0.SELECT_TENDENCY_FADE_TIME):setFrom(0)
	end

	arg0_21.curTendency = arg1_21
end

function var0_0.updateTendencyBtn(arg0_22, arg1_22)
	local var0_22 = arg1_22 > 0 and i18n("tec_tendency_cur_x", i18n("number_" .. arg1_22)) or i18n("tec_tendency_cur_0")

	setText(arg0_22.tendencyBtn:Find("UnSelect/Text"), var0_22)
	setText(arg0_22.tendencyBtn:Find("Selected/Text"), var0_22)
end

function var0_0.updateTargetCatchupPage(arg0_23, arg1_23)
	arg0_23.catchupPanels[arg1_23]:updateTargetCatchupPage()
end

function var0_0.updateTargetCatchupBtns(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.catchupBtns) do
		if iter0_24 <= var0_0.CATCHUP_VERSION then
			local var0_24 = arg0_24.technologyProxy:getCatchupState(iter0_24)
			local var1_24 = var0_24 == TechnologyCatchup.STATE_CATCHUPING
			local var2_24 = arg0_24:findTF("UnSelect/Text", iter1_24)
			local var3_24 = arg0_24:findTF("Selected/Text", iter1_24)
			local var4_24 = arg0_24:findTF("UnSelect/CharImg", iter1_24)
			local var5_24 = arg0_24:findTF("Selected/CharImg", iter1_24)
			local var6_24 = arg0_24:findTF("ProgressText", var4_24)
			local var7_24 = arg0_24:findTF("ProgressText", var5_24)

			setActive(var4_24, var1_24)
			setActive(var5_24, var1_24)

			if var1_24 then
				local var8_24 = iter0_24 > 0 and i18n("tec_target_catchup_selected_x", i18n("number_" .. iter0_24)) or i18n("tec_target_catchup_selected_0")

				setText(var2_24, var8_24)
				setText(var3_24, var8_24)

				local var9_24 = arg0_24.technologyProxy:getCurCatchupTecInfo()
				local var10_24 = var9_24.tecID
				local var11_24 = var9_24.groupID
				local var12_24 = var9_24.printNum
				local var13_24 = arg0_24.technologyProxy:getCatchupData(var10_24):isUr(var11_24) and pg.technology_catchup_template[var10_24].obtain_max_per_ur or pg.technology_catchup_template[var10_24].obtain_max

				setImageSprite(var4_24, LoadSprite("TecCatchup/QChar" .. var11_24, tostring(var11_24)))
				setImageSprite(var5_24, LoadSprite("TecCatchup/QChar" .. var11_24, tostring(var11_24)))
				setText(var6_24, var12_24 .. "/" .. var13_24)
				setText(var7_24, var12_24 .. "/" .. var13_24)
			elseif var0_24 == TechnologyCatchup.STATE_UNSELECT then
				local var14_24 = iter0_24 > 0 and i18n("tec_target_catchup_none_x", i18n("number_" .. iter0_24)) or i18n("tec_target_catchup_none_0")

				setText(var2_24, var14_24)
				setText(var3_24, var14_24)
			elseif var0_24 == TechnologyCatchup.STATE_FINISHED_ALL then
				local var15_24 = iter0_24 > 0 and i18n("tec_target_catchup_finish_x", i18n("number_" .. iter0_24)) or i18n("tec_target_catchup_finish_0")

				setText(var2_24, var15_24)
				setText(var3_24, var15_24)
			end
		end
	end
end

function var0_0.initActCatchupPage(arg0_25)
	if arg0_25.isShowActCatchup then
		local var0_25 = arg0_25.actCatchup:getConfig("page_info").ui_name

		arg0_25.loader:GetPrefab("ui/" .. var0_25, "", function(arg0_26)
			setParent(arg0_26, arg0_25.actCatchupPanel)
			setLocalScale(arg0_26, {
				x = 0.925,
				y = 0.923
			})
			setAnchoredPosition(arg0_26, Vector2.zero)

			arg0_25.actCatchupTF = arg0_25:findTF("AD", tf(arg0_26))
			arg0_25.actCatchupItemTF = arg0_25:findTF("Award", arg0_25.actCatchupTF)
			arg0_25.actCatchupSliderTF = arg0_25:findTF("Slider", arg0_25.actCatchupTF)
			arg0_25.actCatchupProgressText = arg0_25:findTF("Progress", arg0_25.actCatchupTF)

			local var0_26 = arg0_25:findTF("GoBtn", arg0_25.actCatchupTF)

			if var0_26 then
				setActive(var0_26, false)
			end

			local var1_26 = arg0_25:findTF("FinishBtn", arg0_25.actCatchupTF)

			if var1_26 then
				setActive(var1_26, false)
			end

			local var2_26 = arg0_25.actCatchup.data1
			local var3_26 = arg0_25.actCatchup:getConfig("config_id")
			local var4_26 = pg.activity_event_blueprint_catchup[var3_26].obtain_max
			local var5_26 = arg0_25.actCatchup:getConfig("config_client").itemid
			local var6_26 = {
				type = DROP_TYPE_ITEM,
				id = var5_26
			}

			updateDrop(arg0_25.actCatchupItemTF, var6_26)
			onButton(arg0_25, arg0_25.actCatchupItemTF, function()
				arg0_25:emit(BaseUI.ON_DROP, var6_26)
			end, SFX_PANEL)
			setSlider(arg0_25.actCatchupSliderTF, 0, var4_26, var2_26)
			setText(arg0_25.actCatchupProgressText, var2_26 .. "/" .. var4_26)
			setActive(arg0_26, true)
		end)
	end
end

function var0_0.updateActCatchupPage(arg0_28)
	return
end

function var0_0.updateActCatchupBtn(arg0_29)
	local var0_29 = arg0_29:findTF("UnSelect/Text", arg0_29.actCatchupBtn)
	local var1_29 = arg0_29:findTF("Selected/Text", arg0_29.actCatchupBtn)

	setText(var0_29, i18n("tec_act_catchup_btn_word"))
	setText(var1_29, i18n("tec_act_catchup_btn_word"))

	local var2_29 = arg0_29:findTF("UnSelect/CharImg", arg0_29.actCatchupBtn)
	local var3_29 = arg0_29:findTF("Selected/CharImg", arg0_29.actCatchupBtn)
	local var4_29 = arg0_29:findTF("ProgressText", var2_29)
	local var5_29 = arg0_29:findTF("ProgressText", var3_29)
	local var6_29 = false
	local var7_29 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

	if var7_29 and not var7_29:isEnd() then
		local var8_29 = var7_29.data1
		local var9_29 = var7_29:getConfig("config_id")
		local var10_29 = pg.activity_event_blueprint_catchup[var9_29].char_choice
		local var11_29 = pg.activity_event_blueprint_catchup[var9_29].obtain_max

		setImageSprite(var2_29, LoadSprite("TecCatchup/QChar" .. var10_29, tostring(var10_29)))
		setImageSprite(var3_29, LoadSprite("TecCatchup/QChar" .. var10_29, tostring(var10_29)))
		setText(var4_29, var8_29 .. "/" .. var11_29)
		setText(var5_29, var8_29 .. "/" .. var11_29)

		local var12_29 = var7_29.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		if arg0_29.actCatchupTimer then
			arg0_29.actCatchupTimer:Stop()

			arg0_29.actCatchupTimer = nil
		end

		local var13_29 = arg0_29:findTF("TimeLeft/Day", arg0_29.actCatchupBtn)
		local var14_29 = arg0_29:findTF("TimeLeft/Hour", arg0_29.actCatchupBtn)
		local var15_29 = arg0_29:findTF("TimeLeft/Min", arg0_29.actCatchupBtn)
		local var16_29 = arg0_29:findTF("TimeLeft/NumText", arg0_29.actCatchupBtn)

		local function var17_29()
			local var0_30, var1_30, var2_30, var3_30 = pg.TimeMgr.GetInstance():parseTimeFrom(var12_29)

			var12_29 = var12_29 - 1

			if var0_30 >= 1 then
				setActive(var13_29, true)
				setActive(var14_29, false)
				setActive(var15_29, false)
				setText(var16_29, var0_30)
			elseif var0_30 <= 0 and var1_30 > 0 then
				setActive(var13_29, false)
				setActive(var14_29, true)
				setActive(var15_29, false)
				setText(var16_29, var1_30)
			elseif var0_30 <= 0 and var1_30 <= 0 and (var2_30 > 0 or var3_30 > 0) then
				setActive(var13_29, false)
				setActive(var14_29, false)
				setActive(var15_29, true)
				setText(var16_29, math.max(var2_30, 1))
			elseif var0_30 <= 0 and var1_30 <= 0 and var2_30 <= 0 and var3_30 <= 0 and arg0_29.actCatchupTimer then
				arg0_29.actCatchupTimer:Stop()

				arg0_29.actCatchupTimer = nil

				arg0_29:switchRightPage(var0_0.TEC_PAGE_TENDENCY)
				setActive(arg0_29.actCatchupBtn, false)
			end
		end

		arg0_29.actCatchupTimer = Timer.New(var17_29, 1, -1, 1)

		arg0_29.actCatchupTimer:Start()
		arg0_29.actCatchupTimer.func()

		var6_29 = true
	end

	setActive(arg0_29.actCatchupBtn, var6_29)
end

return var0_0
