local var0 = class("TechnologySettingsLayer", import("..base.BaseUI"))

var0.TEC_PAGE_TENDENCY = 1
var0.TEC_PAGE_CATCHUP_TARGET1 = 2
var0.TEC_PAGE_CATCHUP_TARGET2 = 3
var0.TEC_PAGE_CATCHUP_TARGET3 = 4
var0.TEC_PAGE_CATCHUP_TARGET4 = 5
var0.TEC_PAGE_CATCHUP_TARGET5 = 6
var0.TEC_PAGE_CATCHUP_ACT = 99
var0.PANEL_INTO_TIME = 0.15
var0.SELECT_TENDENCY_FADE_TIME = 0.3
var0.SELECT_CHAR_LIGHT_FADE_TIME = 0.3
var0.CATCHUP_CLASSES = {
	import("view.technology.TargetCatchup.TargetCatchupPanel1"),
	import("view.technology.TargetCatchup.TargetCatchupPanel2"),
	import("view.technology.TargetCatchup.TargetCatchupPanel3"),
	import("view.technology.TargetCatchup.TargetCatchupPanel4"),
	import("view.technology.TargetCatchup.TargetCatchupPanel5")
}
var0.CATCHUP_VERSION = 5

function var0.getUIName(arg0)
	return "TechnologySettingsUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initTendencyPage()
	arg0:initActCatchupPage()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:resetLeftBtnUnsel()
	arg0:updateTendencyBtn(arg0.curTendency)
	arg0:updateTargetCatchupBtns()
	arg0:updateActCatchupBtn()
	triggerButton(arg0.leftBtnList[1])
	triggerToggle(arg0.showFinish, arg0.showFinishFlag == 1 and true or false)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.actCatchupTimer then
		arg0.actCatchupTimer:Stop()

		arg0.actCatchupTimer = nil
	end

	for iter0, iter1 in pairs(arg0.catchupPanels) do
		iter1:willExit()
	end

	arg0.loader:Clear()
end

function var0.initData(arg0)
	arg0.technologyProxy = getProxy(TechnologyProxy)
	arg0.bayProxy = getProxy(BayProxy)
	arg0.bagProxy = getProxy(BagProxy)
	arg0.curPageID = 0
	arg0.curTendency = arg0.technologyProxy:getTendency(2)
	arg0.curSelectedIndex = 0
	arg0.reSelectTag = false
	arg0.actCatchup = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)
	arg0.isShowActCatchup = arg0.actCatchup and not arg0.actCatchup:isEnd()
	arg0.loader = AutoLoader.New()
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")

	local var0 = arg0:findTF("BackTips/ClickText", arg0.bg)

	setText(var0, i18n("click_back_tip"))

	local var1 = arg0:findTF("Panel")
	local var2 = arg0:findTF("LeftScrollViewMask/LeftScrollView/LeftBtnList", var1)

	arg0.leftBtnList = {}
	arg0.tendencyBtn = arg0:findTF("TendencyBtn", var2)
	arg0.leftBtnList[var0.TEC_PAGE_TENDENCY] = arg0.tendencyBtn
	arg0.catchupBtns = {}

	for iter0 = 1, var0.CATCHUP_VERSION do
		arg0.catchupBtns[iter0] = cloneTplTo(arg0:findTF("TargetCatchupBtn_tpl", var2), var2)
		arg0.leftBtnList[iter0 + 1] = arg0.catchupBtns[iter0]
	end

	arg0.actCatchupBtn = arg0:findTF("ActCatchupBtn", var2)

	arg0.actCatchupBtn:SetAsLastSibling()

	arg0.leftBtnList[var0.TEC_PAGE_CATCHUP_ACT] = arg0.actCatchupBtn

	local var3 = arg0:findTF("RightPanelContainer", var1)

	arg0.rightPageTFList = {}
	arg0.tendencyPanel = arg0:findTF("TecTendencyPanel", var3)
	arg0.rightPageTFList[var0.TEC_PAGE_TENDENCY] = arg0.tendencyPanel
	arg0.catchupPanels = {}
	arg0.actCatchupPanel = arg0:findTF("ActCatchupPanel", var3)
	arg0.rightPageTFList[var0.TEC_PAGE_CATCHUP_ACT] = arg0.actCatchupPanel
	arg0.showFinish = arg0:findTF("ShowFinishToggle")

	setText(arg0:findTF("Label", arg0.showFinish), i18n("tec_target_catchup_show_the_finished_version"))

	arg0.showFinishFlag = PlayerPrefs.GetInt("isShowFinishCatchupVersion") or 0

	if var0.CATCHUP_VERSION < 1 then
		setActive(arg0.showFinish, false)
	end
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_PANEL)

	for iter0, iter1 in pairs(arg0.leftBtnList) do
		onButton(arg0, iter1, function()
			if arg0.onPageSwitchAnim then
				return
			end

			if arg0.curPageID ~= iter0 then
				arg0:resetLeftBtnUnsel()
				setActive(arg0:findTF("Selected", iter1), true)
				arg0:switchRightPage(iter0)
			end
		end, SFX_PANEL)
	end

	onToggle(arg0, arg0.showFinish, function(arg0)
		if var0.CATCHUP_VERSION < 1 then
			return
		end

		for iter0, iter1 in pairs(arg0.catchupBtns) do
			if iter0 <= var0.CATCHUP_VERSION then
				if arg0.technologyProxy:getCatchupState(iter0) == TechnologyCatchup.STATE_FINISHED_ALL and not arg0 then
					setActive(iter1, false)
				else
					setActive(iter1, true)
				end
			end
		end

		arg0.showFinishFlag = arg0 and 1 or 0

		PlayerPrefs.SetInt("isShowFinishCatchupVersion", arg0.showFinishFlag)
		triggerButton(arg0.leftBtnList[1])
	end, SFX_PANEL)
end

function var0.resetLeftBtnUnsel(arg0)
	for iter0, iter1 in pairs(arg0.leftBtnList) do
		local var0 = arg0:findTF("Selected", iter1)

		setActive(var0, false)
	end
end

function var0.switchRightPage(arg0, arg1)
	seriesAsync({
		function(arg0)
			if not arg0.rightPageTFList[arg1] then
				local var0 = arg1 - 1
				local var1 = arg0:findTF("Panel/RightPanelContainer")

				arg0.catchupPanels[var0] = var0.CATCHUP_CLASSES[var0].New(nil, function()
					arg0.rightPageTFList[arg1] = arg0.catchupPanels[var0]._go

					setActive(arg0.rightPageTFList[arg1], false)
					SetParent(arg0.rightPageTFList[arg1], var1, false)
					arg0()
				end)
			else
				arg0()
			end
		end,
		function(arg0)
			local var0 = arg0.rightPageTFList[arg0.curPageID]
			local var1 = arg0.rightPageTFList[arg1]

			setActive(var1, true)

			arg0.onPageSwitchAnim = true

			arg0:managedTween(LeanTween.alphaCanvas, function()
				arg0.onPageSwitchAnim = false
			end, GetOrAddComponent(var1, typeof(CanvasGroup)), 1, var0.PANEL_INTO_TIME):setFrom(0)

			if var0 then
				arg0:managedTween(LeanTween.alphaCanvas, function()
					setActive(var0, false)
				end, GetOrAddComponent(var0, typeof(CanvasGroup)), 0, var0.PANEL_INTO_TIME):setFrom(1)
			end

			arg0.curPageID = arg1

			if arg1 == var0.TEC_PAGE_TENDENCY then
				arg0:updateTendencyPage(arg0.curTendency)
			elseif arg1 == var0.TEC_PAGE_CATCHUP_ACT then
				arg0:updateActCatchupPage()
			else
				arg0:updateTargetCatchupPage(arg1 - 1)
			end
		end
	})
end

function var0.initTendencyPage(arg0)
	local var0 = getProxy(TechnologyProxy):getConfigMaxVersion()
	local var1 = arg0:findTF("TecItemList", arg0.tendencyPanel)
	local var2 = UIItemList.New(var1, var1:Find("tpl"))

	var2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 > 0 and i18n("tec_tendency_x", i18n("number_" .. arg1)) or i18n("tec_tendency_0")

			setText(arg2:Find("UnSelect/Text"), var0)
			setText(arg2:Find("Selected/Text"), var0)
			onButton(arg0, arg2, function()
				if arg0.curTendency ~= arg1 then
					arg0:emit(TechnologySettingsMediator.CHANGE_TENDENCY, arg1)
				end
			end, SFX_PANEL)
		end
	end)
	var2:align(var0 + 1)
end

function var0.updateTendencyPage(arg0, arg1)
	local var0 = arg0:findTF("TecItemList", arg0.tendencyPanel)

	setActive(var0:GetChild(arg0.curTendency):Find("Selected"), false)

	local var1 = var0:GetChild(arg1):Find("Selected")

	setActive(var1, true)
	setImageAlpha(var1:Find("Image"), 0)
	arg0:managedTween(LeanTween.alpha, nil, var1:Find("Image"), 1, var0.SELECT_TENDENCY_FADE_TIME):setFrom(0)

	local var2 = arg0:findTF("TendencyNum", arg0.tendencyPanel)

	setImageAlpha(var2:Find("Image"), 0)

	if arg1 > 0 then
		GetImageSpriteFromAtlasAsync("ui/technologysettingsui_atlas", "right_tendency_num_" .. arg1, var2:Find("Image"), true)
		arg0:managedTween(LeanTween.alpha, nil, var2:Find("Image"), 1, var0.SELECT_TENDENCY_FADE_TIME):setFrom(0)
	end

	arg0.curTendency = arg1
end

function var0.updateTendencyBtn(arg0, arg1)
	local var0 = arg1 > 0 and i18n("tec_tendency_cur_x", i18n("number_" .. arg1)) or i18n("tec_tendency_cur_0")

	setText(arg0.tendencyBtn:Find("UnSelect/Text"), var0)
	setText(arg0.tendencyBtn:Find("Selected/Text"), var0)
end

function var0.updateTargetCatchupPage(arg0, arg1)
	arg0.catchupPanels[arg1]:updateTargetCatchupPage()
end

function var0.updateTargetCatchupBtns(arg0)
	for iter0, iter1 in pairs(arg0.catchupBtns) do
		if iter0 <= var0.CATCHUP_VERSION then
			local var0 = arg0.technologyProxy:getCatchupState(iter0)
			local var1 = var0 == TechnologyCatchup.STATE_CATCHUPING
			local var2 = arg0:findTF("UnSelect/Text", iter1)
			local var3 = arg0:findTF("Selected/Text", iter1)
			local var4 = arg0:findTF("UnSelect/CharImg", iter1)
			local var5 = arg0:findTF("Selected/CharImg", iter1)
			local var6 = arg0:findTF("ProgressText", var4)
			local var7 = arg0:findTF("ProgressText", var5)

			setActive(var4, var1)
			setActive(var5, var1)

			if var1 then
				local var8 = iter0 > 0 and i18n("tec_target_catchup_selected_x", i18n("number_" .. iter0)) or i18n("tec_target_catchup_selected_0")

				setText(var2, var8)
				setText(var3, var8)

				local var9 = arg0.technologyProxy:getCurCatchupTecInfo()
				local var10 = var9.tecID
				local var11 = var9.groupID
				local var12 = var9.printNum
				local var13 = arg0.technologyProxy:getCatchupData(var10):isUr(var11) and pg.technology_catchup_template[var10].obtain_max_per_ur or pg.technology_catchup_template[var10].obtain_max

				setImageSprite(var4, LoadSprite("TecCatchup/QChar" .. var11, tostring(var11)))
				setImageSprite(var5, LoadSprite("TecCatchup/QChar" .. var11, tostring(var11)))
				setText(var6, var12 .. "/" .. var13)
				setText(var7, var12 .. "/" .. var13)
			elseif var0 == TechnologyCatchup.STATE_UNSELECT then
				local var14 = iter0 > 0 and i18n("tec_target_catchup_none_x", i18n("number_" .. iter0)) or i18n("tec_target_catchup_none_0")

				setText(var2, var14)
				setText(var3, var14)
			elseif var0 == TechnologyCatchup.STATE_FINISHED_ALL then
				local var15 = iter0 > 0 and i18n("tec_target_catchup_finish_x", i18n("number_" .. iter0)) or i18n("tec_target_catchup_finish_0")

				setText(var2, var15)
				setText(var3, var15)
			end
		end
	end
end

function var0.initActCatchupPage(arg0)
	if arg0.isShowActCatchup then
		local var0 = arg0.actCatchup:getConfig("page_info").ui_name

		arg0.loader:GetPrefab("ui/" .. var0, "", function(arg0)
			setParent(arg0, arg0.actCatchupPanel)
			setLocalScale(arg0, {
				x = 0.925,
				y = 0.923
			})
			setAnchoredPosition(arg0, Vector2.zero)

			arg0.actCatchupTF = arg0:findTF("AD", tf(arg0))
			arg0.actCatchupItemTF = arg0:findTF("Award", arg0.actCatchupTF)
			arg0.actCatchupSliderTF = arg0:findTF("Slider", arg0.actCatchupTF)
			arg0.actCatchupProgressText = arg0:findTF("Progress", arg0.actCatchupTF)

			local var0 = arg0:findTF("GoBtn", arg0.actCatchupTF)

			if var0 then
				setActive(var0, false)
			end

			local var1 = arg0:findTF("FinishBtn", arg0.actCatchupTF)

			if var1 then
				setActive(var1, false)
			end

			local var2 = arg0.actCatchup.data1
			local var3 = arg0.actCatchup:getConfig("config_id")
			local var4 = pg.activity_event_blueprint_catchup[var3].obtain_max
			local var5 = arg0.actCatchup:getConfig("config_client").itemid
			local var6 = {
				type = DROP_TYPE_ITEM,
				id = var5
			}

			updateDrop(arg0.actCatchupItemTF, var6)
			onButton(arg0, arg0.actCatchupItemTF, function()
				arg0:emit(BaseUI.ON_DROP, var6)
			end, SFX_PANEL)
			setSlider(arg0.actCatchupSliderTF, 0, var4, var2)
			setText(arg0.actCatchupProgressText, var2 .. "/" .. var4)
			setActive(arg0, true)
		end)
	end
end

function var0.updateActCatchupPage(arg0)
	return
end

function var0.updateActCatchupBtn(arg0)
	local var0 = arg0:findTF("UnSelect/Text", arg0.actCatchupBtn)
	local var1 = arg0:findTF("Selected/Text", arg0.actCatchupBtn)

	setText(var0, i18n("tec_act_catchup_btn_word"))
	setText(var1, i18n("tec_act_catchup_btn_word"))

	local var2 = arg0:findTF("UnSelect/CharImg", arg0.actCatchupBtn)
	local var3 = arg0:findTF("Selected/CharImg", arg0.actCatchupBtn)
	local var4 = arg0:findTF("ProgressText", var2)
	local var5 = arg0:findTF("ProgressText", var3)
	local var6 = false
	local var7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

	if var7 and not var7:isEnd() then
		local var8 = var7.data1
		local var9 = var7:getConfig("config_id")
		local var10 = pg.activity_event_blueprint_catchup[var9].char_choice
		local var11 = pg.activity_event_blueprint_catchup[var9].obtain_max

		setImageSprite(var2, LoadSprite("TecCatchup/QChar" .. var10, tostring(var10)))
		setImageSprite(var3, LoadSprite("TecCatchup/QChar" .. var10, tostring(var10)))
		setText(var4, var8 .. "/" .. var11)
		setText(var5, var8 .. "/" .. var11)

		local var12 = var7.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		if arg0.actCatchupTimer then
			arg0.actCatchupTimer:Stop()

			arg0.actCatchupTimer = nil
		end

		local var13 = arg0:findTF("TimeLeft/Day", arg0.actCatchupBtn)
		local var14 = arg0:findTF("TimeLeft/Hour", arg0.actCatchupBtn)
		local var15 = arg0:findTF("TimeLeft/Min", arg0.actCatchupBtn)
		local var16 = arg0:findTF("TimeLeft/NumText", arg0.actCatchupBtn)

		local function var17()
			local var0, var1, var2, var3 = pg.TimeMgr.GetInstance():parseTimeFrom(var12)

			var12 = var12 - 1

			if var0 >= 1 then
				setActive(var13, true)
				setActive(var14, false)
				setActive(var15, false)
				setText(var16, var0)
			elseif var0 <= 0 and var1 > 0 then
				setActive(var13, false)
				setActive(var14, true)
				setActive(var15, false)
				setText(var16, var1)
			elseif var0 <= 0 and var1 <= 0 and (var2 > 0 or var3 > 0) then
				setActive(var13, false)
				setActive(var14, false)
				setActive(var15, true)
				setText(var16, math.max(var2, 1))
			elseif var0 <= 0 and var1 <= 0 and var2 <= 0 and var3 <= 0 and arg0.actCatchupTimer then
				arg0.actCatchupTimer:Stop()

				arg0.actCatchupTimer = nil

				arg0:switchRightPage(var0.TEC_PAGE_TENDENCY)
				setActive(arg0.actCatchupBtn, false)
			end
		end

		arg0.actCatchupTimer = Timer.New(var17, 1, -1, 1)

		arg0.actCatchupTimer:Start()
		arg0.actCatchupTimer.func()

		var6 = true
	end

	setActive(arg0.actCatchupBtn, var6)
end

return var0
