local var0_0 = class("TechnologySettingsLayer", import("..base.BaseUI"))

var0_0.TEC_PAGE_TENDENCY = 1
var0_0.TEC_PAGE_CATCHUP_TARGET1 = 2
var0_0.TEC_PAGE_CATCHUP_TARGET2 = 3
var0_0.TEC_PAGE_CATCHUP_TARGET3 = 4
var0_0.TEC_PAGE_CATCHUP_TARGET4 = 5
var0_0.TEC_PAGE_CATCHUP_TARGET5 = 6
var0_0.TEC_PAGE_CATCHUP_TARGET6 = 7
var0_0.TEC_PAGE_CATCHUP_TARGET7 = 8
var0_0.TEC_PAGE_CATCHUP_ACT = 99
var0_0.PANEL_INTO_TIME = 0.15
var0_0.SELECT_TENDENCY_FADE_TIME = 0.3
var0_0.SELECT_CHAR_LIGHT_FADE_TIME = 0.3
var0_0.CATCHUP_CLASSES = {
	import("view.technology.TargetCatchup.TargetCatchupPanel1"),
	import("view.technology.TargetCatchup.TargetCatchupPanel2"),
	import("view.technology.TargetCatchup.TargetCatchupPanel3"),
	import("view.technology.TargetCatchup.TargetCatchupPanel4"),
	import("view.technology.TargetCatchup.TargetCatchupPanel5"),
	import("view.technology.TargetCatchup.TargetCatchupPanel6"),
	import("view.technology.TargetCatchup.TargetCatchupPanel7")
}
var0_0.CATCHUP_VERSION = 7

function var0_0.getUIName(arg0_1)
	return "TechnologySettingsUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = {}
	local var1_2 = {}

	local function var2_2(arg0_3)
		if noEmptyStr(arg0_3) and not var1_2[arg0_3] then
			var1_2[arg0_3] = true

			table.insert(var0_2, arg0_3)
		end
	end

	var2_2("ui/TechnologySettingsUI")
	var2_2("ui/technologysettingsui_atlas")

	for iter0_2 = 1, var0_0.CATCHUP_VERSION do
		var2_2("ui/TargetCatchupPanel" .. iter0_2)
	end

	local var3_2 = getProxy(TechnologyProxy)

	local function var4_2(arg0_4)
		if arg0_4 then
			var2_2("TecCatchup/QChar" .. arg0_4)
			var2_2("TecCatchup/selbg" .. arg0_4)
		end
	end

	for iter1_2 = 1, var0_0.CATCHUP_VERSION do
		local var5_2 = pg.technology_catchup_template[iter1_2]

		if var5_2 then
			for iter2_2, iter3_2 in ipairs(var5_2.char_choice or {}) do
				var4_2(iter3_2)
			end
		end
	end

	local var6_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

	if var6_2 and not var6_2:isEnd() then
		local var7_2 = var6_2:getConfig("page_info")

		if var7_2 and noEmptyStr(var7_2.ui_name) then
			var2_2("ui/" .. var7_2.ui_name)
		end

		local var8_2 = var6_2:getConfig("config_id")
		local var9_2 = pg.activity_event_blueprint_catchup[var8_2]

		if var9_2 then
			var4_2(var9_2.char_choice)
		end
	end

	return var0_2
end

function var0_0.init(arg0_5)
	arg0_5:initData()
	arg0_5:findUI()
	arg0_5:addListener()
	arg0_5:initTendencyPage()
	arg0_5:initActCatchupPage()
end

function var0_0.didEnter(arg0_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
	arg0_6:resetLeftBtnUnsel()
	arg0_6:updateTendencyBtn(arg0_6.curTendency)
	arg0_6:updateTargetCatchupBtns()
	arg0_6:updateActCatchupBtn()
	triggerButton(arg0_6.leftBtnList[1])
	triggerToggle(arg0_6.showFinish, arg0_6.showFinishFlag == 1 and true or false)
	getProxy(CommanderManualProxy):TaskProgressAdd(2024, 1)
end

function var0_0.willExit(arg0_7)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7._tf)

	if arg0_7.actCatchupTimer then
		arg0_7.actCatchupTimer:Stop()

		arg0_7.actCatchupTimer = nil
	end

	for iter0_7, iter1_7 in pairs(arg0_7.catchupPanels) do
		iter1_7:willExit()
	end

	arg0_7.loader:Clear()
end

function var0_0.initData(arg0_8)
	arg0_8.technologyProxy = getProxy(TechnologyProxy)
	arg0_8.bayProxy = getProxy(BayProxy)
	arg0_8.bagProxy = getProxy(BagProxy)
	arg0_8.curPageID = 0
	arg0_8.curTendency = arg0_8.technologyProxy:getTendency(2)
	arg0_8.curSelectedIndex = 0
	arg0_8.reSelectTag = false
	arg0_8.actCatchup = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)
	arg0_8.isShowActCatchup = arg0_8.actCatchup and not arg0_8.actCatchup:isEnd()
	arg0_8.loader = AutoLoader.New()
end

function var0_0.findUI(arg0_9)
	arg0_9.bg = arg0_9._tf:Find("BG")

	local var0_9 = arg0_9.bg:Find("BackTips/ClickText")

	setText(var0_9, i18n("click_back_tip"))

	local var1_9 = arg0_9._tf:Find("Panel")
	local var2_9 = var1_9:Find("LeftScrollViewMask/LeftScrollView/LeftBtnList")

	arg0_9.leftBtnList = {}
	arg0_9.tendencyBtn = var2_9:Find("TendencyBtn")
	arg0_9.leftBtnList[var0_0.TEC_PAGE_TENDENCY] = arg0_9.tendencyBtn
	arg0_9.catchupBtns = {}

	for iter0_9 = 1, var0_0.CATCHUP_VERSION do
		arg0_9.catchupBtns[iter0_9] = cloneTplTo(var2_9:Find("TargetCatchupBtn_tpl"), var2_9)
		arg0_9.leftBtnList[iter0_9 + 1] = arg0_9.catchupBtns[iter0_9]
	end

	arg0_9.actCatchupBtn = var2_9:Find("ActCatchupBtn")

	arg0_9.actCatchupBtn:SetAsLastSibling()

	arg0_9.leftBtnList[var0_0.TEC_PAGE_CATCHUP_ACT] = arg0_9.actCatchupBtn

	local var3_9 = var1_9:Find("RightPanelContainer")

	arg0_9.rightPageTFList = {}
	arg0_9.tendencyPanel = var3_9:Find("TecTendencyPanel")
	arg0_9.rightPageTFList[var0_0.TEC_PAGE_TENDENCY] = arg0_9.tendencyPanel
	arg0_9.catchupPanels = {}
	arg0_9.actCatchupPanel = var3_9:Find("ActCatchupPanel")
	arg0_9.rightPageTFList[var0_0.TEC_PAGE_CATCHUP_ACT] = arg0_9.actCatchupPanel
	arg0_9.showFinish = arg0_9._tf:Find("ShowFinishToggle")

	setText(arg0_9.showFinish:Find("Label"), i18n("tec_target_catchup_show_the_finished_version"))

	arg0_9.showFinishFlag = PlayerPrefs.GetInt("isShowFinishCatchupVersion") or 0

	if var0_0.CATCHUP_VERSION < 1 then
		setActive(arg0_9.showFinish, false)
	end
end

function var0_0.addListener(arg0_10)
	onButton(arg0_10, arg0_10.bg, function()
		arg0_10:closeView()
	end, SFX_PANEL)

	for iter0_10, iter1_10 in pairs(arg0_10.leftBtnList) do
		onButton(arg0_10, iter1_10, function()
			if arg0_10.onPageSwitchAnim then
				return
			end

			if arg0_10.curPageID ~= iter0_10 then
				arg0_10:resetLeftBtnUnsel()
				setActive(iter1_10:Find("Selected"), true)
				arg0_10:switchRightPage(iter0_10)
			end
		end, SFX_PANEL)
	end

	onToggle(arg0_10, arg0_10.showFinish, function(arg0_13)
		if var0_0.CATCHUP_VERSION < 1 then
			return
		end

		for iter0_13, iter1_13 in pairs(arg0_10.catchupBtns) do
			if iter0_13 <= var0_0.CATCHUP_VERSION then
				if arg0_10.technologyProxy:getCatchupState(iter0_13) == TechnologyCatchup.STATE_FINISHED_ALL and not arg0_13 then
					setActive(iter1_13, false)
				else
					setActive(iter1_13, true)
				end
			end
		end

		arg0_10.showFinishFlag = arg0_13 and 1 or 0

		PlayerPrefs.SetInt("isShowFinishCatchupVersion", arg0_10.showFinishFlag)
		triggerButton(arg0_10.leftBtnList[1])
	end, SFX_PANEL)
end

function var0_0.resetLeftBtnUnsel(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.leftBtnList) do
		local var0_14 = iter1_14:Find("Selected")

		setActive(var0_14, false)
	end
end

function var0_0.switchRightPage(arg0_15, arg1_15)
	seriesAsync({
		function(arg0_16)
			if not arg0_15.rightPageTFList[arg1_15] then
				local var0_16 = arg1_15 - 1
				local var1_16 = arg0_15._tf:Find("Panel/RightPanelContainer")

				arg0_15.catchupPanels[var0_16] = var0_0.CATCHUP_CLASSES[var0_16].New(nil, function()
					arg0_15.rightPageTFList[arg1_15] = arg0_15.catchupPanels[var0_16]._go

					setActive(arg0_15.rightPageTFList[arg1_15], false)
					SetParent(arg0_15.rightPageTFList[arg1_15], var1_16, false)
					arg0_16()
				end)
			else
				arg0_16()
			end
		end,
		function(arg0_18)
			local var0_18 = arg0_15.rightPageTFList[arg0_15.curPageID]
			local var1_18 = arg0_15.rightPageTFList[arg1_15]

			setActive(var1_18, true)

			arg0_15.onPageSwitchAnim = true

			arg0_15:managedTween(LeanTween.alphaCanvas, function()
				arg0_15.onPageSwitchAnim = false
			end, GetOrAddComponent(var1_18, typeof(CanvasGroup)), 1, var0_0.PANEL_INTO_TIME):setFrom(0)

			if var0_18 then
				arg0_15:managedTween(LeanTween.alphaCanvas, function()
					setActive(var0_18, false)
				end, GetOrAddComponent(var0_18, typeof(CanvasGroup)), 0, var0_0.PANEL_INTO_TIME):setFrom(1)
			end

			arg0_15.curPageID = arg1_15

			if arg1_15 == var0_0.TEC_PAGE_TENDENCY then
				arg0_15:updateTendencyPage(arg0_15.curTendency)
			elseif arg1_15 == var0_0.TEC_PAGE_CATCHUP_ACT then
				arg0_15:updateActCatchupPage()
			else
				arg0_15:updateTargetCatchupPage(arg1_15 - 1)
			end
		end
	})
end

function var0_0.initTendencyPage(arg0_21)
	local var0_21 = getProxy(TechnologyProxy):getConfigMaxVersion()
	local var1_21 = arg0_21.tendencyPanel:Find("TecItemList")
	local var2_21 = UIItemList.New(var1_21, var1_21:Find("tpl"))

	var2_21:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = arg1_22 > 0 and i18n("tec_tendency_x", i18n("number_" .. arg1_22)) or i18n("tec_tendency_0")

			setText(arg2_22:Find("UnSelect/Text"), var0_22)
			setText(arg2_22:Find("Selected/Text"), var0_22)
			onButton(arg0_21, arg2_22, function()
				if arg0_21.curTendency ~= arg1_22 then
					arg0_21:emit(TechnologySettingsMediator.CHANGE_TENDENCY, arg1_22)
				end
			end, SFX_PANEL)
		end
	end)
	var2_21:align(var0_21 + 1)
end

function var0_0.updateTendencyPage(arg0_24, arg1_24)
	local var0_24 = arg0_24.tendencyPanel:Find("TecItemList")

	setActive(var0_24:GetChild(arg0_24.curTendency):Find("Selected"), false)

	local var1_24 = var0_24:GetChild(arg1_24):Find("Selected")

	setActive(var1_24, true)
	setImageAlpha(var1_24:Find("Image"), 0)
	arg0_24:managedTween(LeanTween.alpha, nil, var1_24:Find("Image"), 1, var0_0.SELECT_TENDENCY_FADE_TIME):setFrom(0)

	local var2_24 = arg0_24.tendencyPanel:Find("TendencyNum")

	setImageAlpha(var2_24:Find("Image"), 0)

	if arg1_24 > 0 then
		GetImageSpriteFromAtlasAsync("ui/technologysettingsui_atlas", "right_tendency_num_" .. arg1_24, var2_24:Find("Image"), true)
		arg0_24:managedTween(LeanTween.alpha, nil, var2_24:Find("Image"), 1, var0_0.SELECT_TENDENCY_FADE_TIME):setFrom(0)
	end

	arg0_24.curTendency = arg1_24
end

function var0_0.updateTendencyBtn(arg0_25, arg1_25)
	local var0_25 = arg1_25 > 0 and i18n("tec_tendency_cur_x", i18n("number_" .. arg1_25)) or i18n("tec_tendency_cur_0")

	setText(arg0_25.tendencyBtn:Find("UnSelect/Text"), var0_25)
	setText(arg0_25.tendencyBtn:Find("Selected/Text"), var0_25)
end

function var0_0.updateTargetCatchupPage(arg0_26, arg1_26)
	arg0_26.catchupPanels[arg1_26]:updateTargetCatchupPage()
end

function var0_0.updateTargetCatchupBtns(arg0_27)
	for iter0_27, iter1_27 in pairs(arg0_27.catchupBtns) do
		if iter0_27 <= var0_0.CATCHUP_VERSION then
			local var0_27 = arg0_27.technologyProxy:getCatchupState(iter0_27)
			local var1_27 = var0_27 == TechnologyCatchup.STATE_CATCHUPING
			local var2_27 = iter1_27:Find("UnSelect/Text")
			local var3_27 = iter1_27:Find("Selected/Text")
			local var4_27 = iter1_27:Find("UnSelect/CharImg")
			local var5_27 = iter1_27:Find("Selected/CharImg")
			local var6_27 = var4_27:Find("ProgressText")
			local var7_27 = var5_27:Find("ProgressText")

			setActive(var4_27, var1_27)
			setActive(var5_27, var1_27)

			if var1_27 then
				local var8_27 = iter0_27 > 0 and i18n("tec_target_catchup_selected_x", i18n("number_" .. iter0_27)) or i18n("tec_target_catchup_selected_0")

				setText(var2_27, var8_27)
				setText(var3_27, var8_27)

				local var9_27 = arg0_27.technologyProxy:getCurCatchupTecInfo()
				local var10_27 = var9_27.tecID
				local var11_27 = var9_27.groupID
				local var12_27 = var9_27.printNum
				local var13_27 = arg0_27.technologyProxy:getCatchupData(var10_27):isUr(var11_27) and pg.technology_catchup_template[var10_27].obtain_max_per_ur or pg.technology_catchup_template[var10_27].obtain_max

				setImageSprite(var4_27, LoadSprite("TecCatchup/QChar" .. var11_27, tostring(var11_27)))
				setImageSprite(var5_27, LoadSprite("TecCatchup/QChar" .. var11_27, tostring(var11_27)))
				setText(var6_27, var12_27 .. "/" .. var13_27)
				setText(var7_27, var12_27 .. "/" .. var13_27)
			elseif var0_27 == TechnologyCatchup.STATE_UNSELECT then
				local var14_27 = iter0_27 > 0 and i18n("tec_target_catchup_none_x", i18n("number_" .. iter0_27)) or i18n("tec_target_catchup_none_0")

				setText(var2_27, var14_27)
				setText(var3_27, var14_27)
			elseif var0_27 == TechnologyCatchup.STATE_FINISHED_ALL then
				local var15_27 = iter0_27 > 0 and i18n("tec_target_catchup_finish_x", i18n("number_" .. iter0_27)) or i18n("tec_target_catchup_finish_0")

				setText(var2_27, var15_27)
				setText(var3_27, var15_27)
			end
		end
	end
end

function var0_0.initActCatchupPage(arg0_28)
	if arg0_28.isShowActCatchup then
		local var0_28 = arg0_28.actCatchup:getConfig("page_info").ui_name

		arg0_28.loader:GetPrefab("ui/" .. var0_28, "", function(arg0_29)
			setParent(arg0_29, arg0_28.actCatchupPanel)
			setLocalScale(arg0_29, {
				x = 0.925,
				y = 0.923
			})
			setAnchoredPosition(arg0_29, Vector2.zero)

			arg0_28.actCatchupTF = tf(arg0_29):Find("AD")
			arg0_28.actCatchupItemTF = arg0_28.actCatchupTF:Find("Award")
			arg0_28.actCatchupSliderTF = arg0_28.actCatchupTF:Find("Slider")
			arg0_28.actCatchupProgressText = arg0_28.actCatchupTF:Find("Progress")

			local var0_29 = arg0_28.actCatchupTF:Find("GoBtn")

			if var0_29 then
				setActive(var0_29, false)
			end

			local var1_29 = arg0_28.actCatchupTF:Find("FinishBtn")

			if var1_29 then
				setActive(var1_29, false)
			end

			local var2_29 = arg0_28.actCatchup.data1
			local var3_29 = arg0_28.actCatchup:getConfig("config_id")
			local var4_29 = pg.activity_event_blueprint_catchup[var3_29].obtain_max
			local var5_29 = arg0_28.actCatchup:getConfig("config_client").itemid
			local var6_29 = {
				type = DROP_TYPE_ITEM,
				id = var5_29
			}

			updateDrop(arg0_28.actCatchupItemTF, var6_29)
			onButton(arg0_28, arg0_28.actCatchupItemTF, function()
				arg0_28:emit(BaseUI.ON_DROP, var6_29)
			end, SFX_PANEL)
			setSlider(arg0_28.actCatchupSliderTF, 0, var4_29, var2_29)
			setText(arg0_28.actCatchupProgressText, var2_29 .. "/" .. var4_29)
			setActive(arg0_29, true)
		end)
	end
end

function var0_0.updateActCatchupPage(arg0_31)
	return
end

function var0_0.updateActCatchupBtn(arg0_32)
	local var0_32 = arg0_32.actCatchupBtn:Find("UnSelect/Text")
	local var1_32 = arg0_32.actCatchupBtn:Find("Selected/Text")

	setText(var0_32, i18n("tec_act_catchup_btn_word"))
	setText(var1_32, i18n("tec_act_catchup_btn_word"))

	local var2_32 = arg0_32.actCatchupBtn:Find("UnSelect/CharImg")
	local var3_32 = arg0_32.actCatchupBtn:Find("Selected/CharImg")
	local var4_32 = var2_32:Find("ProgressText")
	local var5_32 = var3_32:Find("ProgressText")
	local var6_32 = false
	local var7_32 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

	if var7_32 and not var7_32:isEnd() then
		local var8_32 = var7_32.data1
		local var9_32 = var7_32:getConfig("config_id")
		local var10_32 = pg.activity_event_blueprint_catchup[var9_32].char_choice
		local var11_32 = pg.activity_event_blueprint_catchup[var9_32].obtain_max

		setImageSprite(var2_32, LoadSprite("TecCatchup/QChar" .. var10_32, tostring(var10_32)))
		setImageSprite(var3_32, LoadSprite("TecCatchup/QChar" .. var10_32, tostring(var10_32)))
		setText(var4_32, var8_32 .. "/" .. var11_32)
		setText(var5_32, var8_32 .. "/" .. var11_32)

		local var12_32 = var7_32.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		if arg0_32.actCatchupTimer then
			arg0_32.actCatchupTimer:Stop()

			arg0_32.actCatchupTimer = nil
		end

		local var13_32 = arg0_32.actCatchupBtn:Find("TimeLeft/Day")
		local var14_32 = arg0_32.actCatchupBtn:Find("TimeLeft/Hour")
		local var15_32 = arg0_32.actCatchupBtn:Find("TimeLeft/Min")
		local var16_32 = arg0_32.actCatchupBtn:Find("TimeLeft/NumText")

		local function var17_32()
			local var0_33, var1_33, var2_33, var3_33 = pg.TimeMgr.GetInstance():parseTimeFrom(var12_32)

			var12_32 = var12_32 - 1

			if var0_33 >= 1 then
				setActive(var13_32, true)
				setActive(var14_32, false)
				setActive(var15_32, false)
				setText(var16_32, var0_33)
			elseif var0_33 <= 0 and var1_33 > 0 then
				setActive(var13_32, false)
				setActive(var14_32, true)
				setActive(var15_32, false)
				setText(var16_32, var1_33)
			elseif var0_33 <= 0 and var1_33 <= 0 and (var2_33 > 0 or var3_33 > 0) then
				setActive(var13_32, false)
				setActive(var14_32, false)
				setActive(var15_32, true)
				setText(var16_32, math.max(var2_33, 1))
			elseif var0_33 <= 0 and var1_33 <= 0 and var2_33 <= 0 and var3_33 <= 0 and arg0_32.actCatchupTimer then
				arg0_32.actCatchupTimer:Stop()

				arg0_32.actCatchupTimer = nil

				arg0_32:switchRightPage(var0_0.TEC_PAGE_TENDENCY)
				setActive(arg0_32.actCatchupBtn, false)
			end
		end

		arg0_32.actCatchupTimer = Timer.New(var17_32, 1, -1, 1)

		arg0_32.actCatchupTimer:Start()
		arg0_32.actCatchupTimer.func()

		var6_32 = true
	end

	setActive(arg0_32.actCatchupBtn, var6_32)
end

return var0_0
