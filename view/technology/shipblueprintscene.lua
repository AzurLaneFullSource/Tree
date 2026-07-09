local var0_0 = class("ShipBluePrintScene", import("..base.BaseUI"))
local var1_0 = pg.ship_data_blueprint
local var2_0 = pg.ship_data_template
local var3_0 = pg.ship_data_breakout
local var4_0 = 3
local var5_0 = -10
local var6_0 = 2.3
local var7_0 = 0.3

function var0_0.getUIName(arg0_1)
	return "ShipBluePrintUI"
end

function var0_0.setVersion(arg0_2, arg1_2)
	arg0_2.version = arg1_2
end

function var0_0.setShipVOs(arg0_3, arg1_3)
	arg0_3.shipVOs = arg1_3
end

function var0_0.getShipById(arg0_4, arg1_4)
	return arg0_4.shipVOs[arg1_4]
end

function var0_0.setTaskVOs(arg0_5, arg1_5)
	arg0_5.taskVOs = arg1_5
end

function var0_0.getTaskById(arg0_6, arg1_6)
	return arg0_6.taskVOs[arg1_6] or Task.New({
		id = arg1_6
	})
end

function var0_0.getItemById(arg0_7, arg1_7)
	return getProxy(BagProxy):getItemById(arg1_7) or Item.New({
		count = 0,
		id = arg1_7
	})
end

function var0_0.setShipBluePrints(arg0_8, arg1_8)
	arg0_8.bluePrintByIds = arg1_8
end

function var0_0.updateShipBluePrintVO(arg0_9, arg1_9)
	if arg1_9 then
		arg0_9.bluePrintByIds[arg1_9.id] = arg1_9
	end

	arg0_9:initShips()
end

function var0_0.init(arg0_10)
	arg0_10.main = arg0_10._tf:Find("main")
	arg0_10.centerPanel = arg0_10.main:Find("center_panel")
	arg0_10.blurPanel = arg0_10._tf:Find("blur_panel")
	arg0_10.top = arg0_10.blurPanel:Find("adapt")
	arg0_10.topPanel = arg0_10.top:Find("top")
	arg0_10.topBg = arg0_10.blurPanel:Find("top_bg")
	arg0_10.backBtn = arg0_10.top:Find("top/back")
	arg0_10.leftPanle = arg0_10.top:Find("left_panel")
	arg0_10.bottomPanel = arg0_10.top:Find("bottom_panel")
	arg0_10.rightPanel = arg0_10.top:Find("right_panel")
	arg0_10.shipContainer = arg0_10.bottomPanel:Find("ships/bg/content")
	arg0_10.shipTpl = arg0_10.bottomPanel:Find("ship_tpl")
	arg0_10.versionBtn = arg0_10.bottomPanel:Find("ships/bg/version/version_btn")
	arg0_10.eyeTF = arg0_10.leftPanle:Find("eye")
	arg0_10.painting = arg0_10._tf:Find("main/center_panel/painting")
	arg0_10.nameTF = arg0_10.centerPanel:Find("name")
	arg0_10.shipName = arg0_10.nameTF:Find("name_mask/Text")
	arg0_10.shipType = arg0_10.nameTF:Find("type")
	arg0_10.englishName = arg0_10.nameTF:Find("english_name")
	arg0_10.shipInfoStarTpl = arg0_10.nameTF:Find("star_tpl")

	setActive(arg0_10.shipInfoStarTpl, false)

	arg0_10.stars = arg0_10.nameTF:Find("stars")
	arg0_10.initBtn = arg0_10.leftPanle:Find("property_panel/btns/init_toggle")
	arg0_10.attrBtn = arg0_10.leftPanle:Find("property_panel/btns/attr_toggle")
	arg0_10.attrDisableBtn = arg0_10.leftPanle:Find("property_panel/btns/attr_toggle/disable")
	arg0_10.initPanel = arg0_10.leftPanle:Find("property_panel/init_panel")
	arg0_10.propertyPanel = PropertyPanel.New(arg0_10.initPanel, 32)

	setText(arg0_10.initPanel:Find("property_title1/Text"), i18n("blueprint_combatperformance"))
	setText(arg0_10.initPanel:Find("property_title2/Text"), i18n("blueprint_shipperformance"))

	arg0_10.skillRect = arg0_10.leftPanle:Find("property_panel/init_panel/skills_rect")
	arg0_10.skillPanel = arg0_10.leftPanle:Find("property_panel/init_panel/skills_rect/skills")
	arg0_10.skillTpl = arg0_10.skillPanel:Find("skilltpl")
	arg0_10.skillArrLeft = arg0_10.leftPanle:Find("property_panel/init_panel/arrow1")
	arg0_10.skillArrRight = arg0_10.leftPanle:Find("property_panel/init_panel/arrow2")
	arg0_10.simulationBtn = arg0_10.leftPanle:Find("property_panel/init_panel/property_title2/simulation")
	arg0_10.attrPanel = arg0_10.leftPanle:Find("property_panel/attr_panel")
	arg0_10.modAdditionPanel = arg0_10.leftPanle:Find("property_panel/attr_panel")
	arg0_10.modAdditionContainer = arg0_10.modAdditionPanel:Find("scroll_rect/content")
	arg0_10.modAdditionTpl = arg0_10.modAdditionContainer:Find("addition_tpl")
	arg0_10.preViewBtn = arg0_10.attrPanel:Find("pre_view")
	arg0_10.stateInfo = arg0_10.centerPanel:Find("state_info")
	arg0_10.startBtn = arg0_10.centerPanel:Find("state_info/start_btn")
	arg0_10.lockPanel = arg0_10.centerPanel:Find("state_info/lock_panel")
	arg0_10.lockBtn = arg0_10.lockPanel:Find("lock")
	arg0_10.finishedBtn = arg0_10.centerPanel:Find("state_info/finished_btn")
	arg0_10.progressPanel = arg0_10.centerPanel:Find("state_info/progress")

	setText(arg0_10.progressPanel:Find("label"), i18n("blueprint_researching"))

	arg0_10.progressContainer = arg0_10.progressPanel:Find("content")
	arg0_10.progressTpl = arg0_10.progressContainer:Find("item")
	arg0_10.openCondition = arg0_10.centerPanel:Find("state_info/open_condition")
	arg0_10.speedupBtn = arg0_10._tf:Find("main/speedup_btn")
	arg0_10.taskListPanel = arg0_10.rightPanel:Find("task_list")
	arg0_10.taskContainer = arg0_10.rightPanel:Find("task_list/scroll/content")
	arg0_10.taskTpl = arg0_10.taskContainer:Find("task_tpl")
	arg0_10.modPanel = arg0_10.rightPanel:Find("mod_panel")
	arg0_10.attrContainer = arg0_10.modPanel:Find("desc/atrrs")
	arg0_10.levelSlider = arg0_10.modPanel:Find("title/slider"):GetComponent(typeof(Slider))
	arg0_10.levelSliderTxt = arg0_10.modPanel:Find("title/slider/Text")
	arg0_10.preLevelSlider = arg0_10.modPanel:Find("title/pre_slider"):GetComponent(typeof(Slider))
	arg0_10.modLevel = arg0_10.modPanel:Find("title/level_bg/Text"):GetComponent(typeof(Text))
	arg0_10.needLevelTxt = arg0_10.modPanel:Find("title/Text"):GetComponent(typeof(Text))
	arg0_10.phantomPanel = arg0_10.rightPanel:Find("phantom_panel")
	arg0_10.rtPhantomQuestContainer = arg0_10.phantomPanel:Find("desc/content")
	arg0_10.questTpl = arg0_10.rtPhantomQuestContainer:GetChild(0)
	arg0_10.btnPhantom = arg0_10.top:Find("phantomBtn")
	arg0_10.calcPanel = arg0_10.modPanel:Find("desc/calc_panel")
	arg0_10.calcMinusBtn = arg0_10.calcPanel:Find("calc/base/minus")
	arg0_10.calcPlusBtn = arg0_10.calcPanel:Find("calc/base/plus")
	arg0_10.calcTxt = arg0_10.calcPanel:Find("calc/base/count/Text")
	arg0_10.calcMaxBtn = arg0_10.calcPanel:Find("calc/max")
	arg0_10.itemInfo = arg0_10.calcPanel:Find("item_bg")
	arg0_10.itemInfoIcon = arg0_10.itemInfo:Find("icon")
	arg0_10.itemInfoCount = arg0_10.itemInfo:Find("kc")
	arg0_10.modBtn = arg0_10.calcPanel:Find("confirm_btn")
	arg0_10.fittingBtn = arg0_10.modPanel:Find("desc/fitting_btn")
	arg0_10.fittingBtnEffect = arg0_10.fittingBtn:Find("anim/ShipBlue02")
	arg0_10.fittingPanel = arg0_10.rightPanel:Find("fitting_panel")

	setActive(arg0_10.fittingPanel, false)

	arg0_10.fittingAttrPanel = arg0_10.fittingPanel:Find("desc/middle")
	arg0_10.phasePic = arg0_10.fittingPanel:Find("title/phase")
	arg0_10.phaseSlider = arg0_10.fittingPanel:Find("desc/top/slider"):GetComponent(typeof(Slider))
	arg0_10.phaseSliderTxt = arg0_10.fittingPanel:Find("desc/top/precent")
	arg0_10.prePhaseSlider = arg0_10.fittingPanel:Find("desc/top/pre_slider"):GetComponent(typeof(Slider))
	arg0_10.fittingNeedMask = arg0_10.fittingPanel:Find("desc/top/mask")
	arg0_10.fittingCalcPanel = arg0_10.fittingPanel:Find("desc/bottom")
	arg0_10.fittingCalcMinusBtn = arg0_10.fittingCalcPanel:Find("calc/base/minus")
	arg0_10.fittingCalcPlusBtn = arg0_10.fittingCalcPanel:Find("calc/base/plus")
	arg0_10.fittingCalcTxt = arg0_10.fittingCalcPanel:Find("calc/base/count/Text")
	arg0_10.fittingCalcMaxBtn = arg0_10.fittingCalcPanel:Find("calc/max")
	arg0_10.fittingItemInfo = arg0_10.fittingCalcPanel:Find("item_bg")
	arg0_10.fittingItemInfoIcon = arg0_10.fittingItemInfo:Find("icon")
	arg0_10.fittingItemInfoCount = arg0_10.fittingItemInfo:Find("kc")
	arg0_10.fittingConfirmBtn = arg0_10.fittingCalcPanel:Find("confirm_btn")
	arg0_10.fittingCancelBtn = arg0_10.fittingCalcPanel:Find("cancel_btn")
	arg0_10.msgPanel = arg0_10.blurPanel:Find("msg_panel")

	setActive(arg0_10.msgPanel, false)

	arg0_10.versionPanel = arg0_10._tf:Find("version_panel")

	setActive(arg0_10.versionPanel, false)

	arg0_10.preViewer = arg0_10._tf:Find("preview")
	arg0_10.preViewerFrame = arg0_10._tf:Find("preview/frame")

	setText(arg0_10.preViewerFrame:Find("bg/title/Image"), i18n("word_preview"))
	setActive(arg0_10.preViewer, false)

	arg0_10.sea = arg0_10.preViewerFrame:Find("sea")
	arg0_10.rawImage = arg0_10.sea:GetComponent("RawImage")

	setActive(arg0_10.rawImage, false)

	arg0_10.seaLoading = arg0_10.preViewerFrame:Find("bg/loading")
	arg0_10.healTF = arg0_10._tf:Find("resources/heal")
	arg0_10.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0_10.healTF, false)

	arg0_10.stages = arg0_10.preViewerFrame:Find("stageScrollRect/stages")
	arg0_10.breakView = arg0_10.preViewerFrame:Find("content/Text")
	arg0_10.previewAttrPanel = arg0_10._tf:Find("preview/attrs_panel/attr_panel")
	arg0_10.previewAttrContainer = arg0_10.previewAttrPanel:Find("content")

	setText(arg0_10._tf:Find("preview/attrs_panel/Text"), i18n("meta_energy_preview_tip"))
	setText(arg0_10._tf:Find("preview/attrs_panel/desc"), i18n("meta_energy_preview_title"))

	arg0_10.helpBtn = arg0_10.top:Find("helpBtn")
	arg0_10.exchangeBtn = arg0_10.top:Find("exchangeBtn")
	arg0_10.itemUnlockBtn = arg0_10.top:Find("itemUnlockBtn")
	arg0_10.bottomWidth = arg0_10.bottomPanel.rect.height
	arg0_10.topWidth = arg0_10.topPanel.rect.height * 2
	arg0_10.taskTFs = {}
	arg0_10.leanTweens = {}
	arg0_10.unlockPanel = arg0_10.blurPanel:Find("unlock_panel")

	setActive(arg0_10.unlockPanel, false)

	arg0_10.svQuickExchange = BlueprintQuickExchangeView.New(arg0_10._tf, arg0_10.event)
end

function var0_0.didEnter(arg0_11)
	local var0_11 = getProxy(TechnologyProxy):getConfigMaxVersion()

	if not arg0_11.contextData.shipBluePrintVO then
		local var1_11 = {}

		for iter0_11 = 1, var0_11 do
			var1_11[iter0_11] = 0
		end

		for iter1_11, iter2_11 in pairs(arg0_11.bluePrintByIds) do
			local var2_11 = iter2_11:getConfig("blueprint_version")

			var1_11[var2_11] = var1_11[var2_11] + (iter2_11.state == ShipBluePrint.STATE_UNLOCK and 1 or 0)

			if iter2_11.state == ShipBluePrint.STATE_DEV then
				arg0_11.contextData.shipBluePrintVO = arg0_11.contextData.shipBluePrintVO or iter2_11

				break
			end
		end

		if not arg0_11.contextData.shipBluePrintVO then
			for iter3_11 = 1, var0_11 do
				arg0_11.version = iter3_11

				if var1_11[iter3_11] <= 4 then
					break
				end
			end

			arg0_11:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, arg0_11.version)
		end
	end

	arg0_11:switchHide()
	arg0_11:initShips()
	onButton(arg0_11, arg0_11.speedupBtn, function()
		arg0_11:emit(ShipBluePrintMediator.ON_CLICK_SPEEDUP_BTN)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.backBtn, function()
		arg0_11:closeView()
	end, SOUND_BACK)
	onButton(arg0_11, arg0_11.startBtn, function()
		if not arg0_11.contextData.shipBluePrintVO then
			return
		end

		local var0_14 = arg0_11.contextData.shipBluePrintVO.id

		arg0_11:emit(ShipBluePrintMediator.ON_START, var0_14)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.finishedBtn, function()
		if not arg0_11.contextData.shipBluePrintVO then
			return
		end

		local var0_15 = arg0_11.contextData.shipBluePrintVO.id

		arg0_11:emit(ShipBluePrintMediator.ON_FINISHED, var0_15)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.itemUnlockBtn, function()
		if not arg0_11.contextData.shipBluePrintVO then
			return
		end

		arg0_11:showUnlockPanel()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.preViewBtn, function()
		arg0_11:openPreView()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.seaLoading, function()
		if not arg0_11.previewer then
			arg0_11:showBarrage()
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.preViewer, function()
		arg0_11:closePreview()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.eyeTF, function()
		if arg0_11.isSwitchAnim then
			return
		end

		arg0_11:switchHide()
		arg0_11:switchState(var7_0, not arg0_11.flag)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.main, function()
		if arg0_11.isSwitchAnim then
			return
		end

		if not arg0_11.flag then
			arg0_11:switchHide()
			arg0_11:switchState(var7_0, not arg0_11.flag)
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[isActive(arg0_11.fittingPanel) and "help_shipblueprintui_luck" or "help_shipblueprintui"].tip
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.exchangeBtn, function()
		arg0_11.svQuickExchange:Load()
		arg0_11.svQuickExchange:ActionInvoke("Show")
		arg0_11.svQuickExchange:ActionInvoke("UpdateBlueprint", arg0_11.contextData.shipBluePrintVO)
	end)
	setText(arg0_11.modPanel:Find("switch/Text"), i18n("tech_shadow_change_button_1"))
	onButton(arg0_11, arg0_11.modPanel:Find("switch"), function()
		arg0_11:switchState(var7_0, true, function()
			arg0_11.isPhantom = true

			setActive(arg0_11.phantomPanel, arg0_11.isPhantom)
			setActive(arg0_11.modPanel, not arg0_11.isPhantom)
		end)
	end, SFX_PANEL)
	setText(arg0_11.phantomPanel:Find("switch/Text"), i18n("tech_shadow_change_button_2"))
	onButton(arg0_11, arg0_11.phantomPanel:Find("switch"), function()
		arg0_11:switchState(var7_0, true, function()
			arg0_11.isPhantom = false

			setActive(arg0_11.phantomPanel, arg0_11.isPhantom)
			setActive(arg0_11.modPanel, not arg0_11.isPhantom)
		end)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.btnPhantom, function()
		arg0_11:emit(ShipBluePrintMediator.OPEN_PHANTOM_LAYER, arg0_11.version)
	end, SFX_PANEL)
	arg0_11:OverlayPanel(arg0_11.blurPanel, {
		pbList = {
			arg0_11.rightPanel:Find("task_list"),
			arg0_11.rightPanel:Find("mod_panel"),
			arg0_11.leftPanle:Find("property_panel"),
			arg0_11.bottomPanel:Find("ships/bg")
		}
	})
	setText(arg0_11.msgPanel:Find("window/top/bg/infomation/title"), i18n("title_info"))
	onButton(arg0_11, arg0_11.msgPanel:Find("window/top/btnBack"), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.msgPanel, arg0_11.top)
		setActive(arg0_11.msgPanel, false)
	end, SFX_CANCEL)
	setText(arg0_11.msgPanel:Find("window/confirm_btn/Text"), i18n("text_confirm"))
	onButton(arg0_11, arg0_11.msgPanel:Find("window/confirm_btn"), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.msgPanel, arg0_11.top)
		setActive(arg0_11.msgPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.msgPanel:Find("bg"), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.msgPanel, arg0_11.top)
		setActive(arg0_11.msgPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.unlockPanel:Find("window/top/btnBack"), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.unlockPanel, arg0_11.top)
		setActive(arg0_11.unlockPanel, false)
	end, SFX_CANCEL)
	setText(arg0_11.unlockPanel:Find("window/confirm_btn/Text"), i18n("text_confirm"))
	setText(arg0_11.unlockPanel:Find("window/cancel_btn/Text"), i18n("text_cancel"))
	setText(arg0_11.unlockPanel:Find("window/top/bg/infomation/title"), i18n("title_info"))
	onButton(arg0_11, arg0_11.unlockPanel:Find("window/cancel_btn"), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.unlockPanel, arg0_11.top)
		setActive(arg0_11.unlockPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.unlockPanel:Find("bg"), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.unlockPanel, arg0_11.top)
		setActive(arg0_11.unlockPanel, false)
	end, SFX_CANCEL)
	GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "version_" .. arg0_11.version, arg0_11.versionBtn)
	arg0_11:updateVersionBtnTip()

	if var0_11 > 1 then
		onButton(arg0_11, arg0_11.versionBtn, function()
			if arg0_11.cbTimer then
				return
			end

			setActive(arg0_11.versionPanel, true)
			pg.UIMgr.GetInstance():BlurPanel(arg0_11.versionPanel)
		end, SFX_PANEL)
		onButton(arg0_11, arg0_11.versionPanel:Find("bg"), function()
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.versionPanel, arg0_11._tf)
			setActive(arg0_11.versionPanel, false)
		end, SFX_CANCEL)

		local var3_11 = UIItemList.New(arg0_11.versionPanel:Find("window/content"), arg0_11.versionPanel:Find("window/content/version_1"))

		var3_11:make(function(arg0_37, arg1_37, arg2_37)
			arg1_37 = arg1_37 + 1

			if arg0_37 == UIItemList.EventUpdate then
				arg2_37.name = "version_" .. arg1_37

				GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "newVersion_" .. arg1_37, arg2_37:Find("image"))

				if arg0_11.version == arg1_37 then
					setActive(arg2_37:Find("choose"), true)
				else
					setActive(arg2_37:Find("choose"), false)
				end

				onButton(arg0_11, arg2_37, function()
					arg0_11.version = arg1_37

					arg0_11:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, arg0_11.version)

					arg0_11.contextData.shipBluePrintVO = nil

					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "version_" .. arg0_11.version, arg0_11.versionBtn)
					arg0_11:initShips()
					arg0_11:updateVersionBtnTip()
					var3_11:align(var0_11)
					pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.versionPanel, arg0_11._tf)
					setActive(arg0_11.versionPanel, false)
				end, SFX_CANCEL)
			end
		end)
		var3_11:align(var0_11)
		arg0_11:updateVersionPanelBtnTip()
	end

	LeanTween.alpha(rtf(arg0_11.skillArrLeft), 0.25, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
	LeanTween.alpha(rtf(arg0_11.skillArrRight), 0.25, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
end

function var0_0.updateVersionBtnTip(arg0_39)
	local var0_39 = getProxy(TechnologyProxy)
	local var1_39 = var0_39:getConfigMaxVersion()
	local var2_39 = {}

	for iter0_39 = 1, var1_39 do
		if iter0_39 ~= arg0_39.version then
			table.insert(var2_39, iter0_39)
		end
	end

	setActive(arg0_39.versionBtn:Find("tip"), var0_39:CheckPursuingCostTip(var2_39))
end

function var0_0.updateVersionPanelBtnTip(arg0_40)
	local var0_40 = getProxy(TechnologyProxy)
	local var1_40 = var0_40:getConfigMaxVersion()

	for iter0_40 = 1, var1_40 do
		setActive(arg0_40.versionPanel:Find("window/content/version_" .. iter0_40 .. "/tip"), var0_40:CheckPursuingCostTip({
			iter0_40
		}))
	end
end

function var0_0.updateAllPursuingCostTip(arg0_41)
	arg0_41:updateVersionBtnTip()
	arg0_41:updateVersionPanelBtnTip()

	for iter0_41, iter1_41 in pairs(arg0_41.bluePrintItems) do
		iter1_41:updatePursuingTip()
	end
end

function var0_0.switchHide(arg0_42)
	local var0_42 = not arg0_42.flag

	LeanTween.cancel(arg0_42.bottomPanel)
	LeanTween.cancel(arg0_42.topPanel)
	LeanTween.cancel(arg0_42.topBg)

	if var0_42 then
		LeanTween.moveY(arg0_42.bottomPanel, 0, var7_0)
		LeanTween.moveY(arg0_42.topPanel, 0, var7_0)
		LeanTween.moveY(arg0_42.topBg, 0, var7_0)
	else
		LeanTween.moveY(arg0_42.bottomPanel, -arg0_42.bottomWidth, var7_0)
		LeanTween.moveY(arg0_42.topPanel, arg0_42.topWidth, var7_0)
		LeanTween.moveY(arg0_42.topBg, arg0_42.topWidth, var7_0)
	end

	setActive(arg0_42.nameTF, var0_42)
	setActive(arg0_42.stateInfo, var0_42)
	setActive(arg0_42.helpBtn, var0_42)
	setActive(arg0_42.exchangeBtn, var0_42)
	setActive(arg0_42.btnPhantom, var0_42)
	setImageAlpha(arg0_42.itemUnlockBtn, var0_42 and 1 or 0)
	setImageRaycastTarget(arg0_42.itemUnlockBtn, var0_42)
	setImageAlpha(arg0_42.speedupBtn, var0_42 and 1 or 0)
	setImageRaycastTarget(arg0_42.speedupBtn, var0_42)
end

function var0_0.switchState(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43)
	local var0_43 = {}

	if arg0_43.flag then
		table.insert(var0_43, function(arg0_44)
			arg0_43.flag = false

			arg0_43:switchUI(arg1_43, {
				-arg0_43.leftPanle.rect.width - 400,
				arg0_43.rightPanel.rect.width + 400
			}, arg0_44)
		end)
	end

	table.insert(var0_43, function(arg0_45)
		existCall(arg3_43)

		return arg0_45()
	end)

	if arg2_43 then
		table.insert(var0_43, function(arg0_46)
			arg0_43.flag = true

			if arg0_43.isFate or arg0_43.isPhantom then
				arg0_43:switchUI(arg1_43, {
					-arg0_43.leftPanle.rect.width - 400,
					0,
					-arg0_43.leftPanle.rect.width / 2
				}, arg0_46)
			else
				arg0_43:switchUI(arg1_43, {
					0,
					0,
					0
				}, arg0_46)
			end
		end)
	end

	seriesAsync(var0_43, arg4_43)
end

function var0_0.switchUI(arg0_47, arg1_47, arg2_47, arg3_47)
	LeanTween.cancel(arg0_47.leftPanle)
	LeanTween.cancel(arg0_47.rightPanel)
	LeanTween.cancel(arg0_47.centerPanel)

	arg0_47.isSwitchAnim = true

	parallelAsync({
		function(arg0_48)
			LeanTween.moveX(arg0_47.leftPanle, arg2_47[1], arg1_47):setOnComplete(System.Action(arg0_48))
		end,
		function(arg0_49)
			LeanTween.moveX(arg0_47.rightPanel, arg2_47[2], arg1_47):setOnComplete(System.Action(arg0_49))
		end,
		function(arg0_50)
			if arg2_47[3] then
				LeanTween.moveX(arg0_47.centerPanel, arg2_47[3], arg1_47):setOnComplete(System.Action(arg0_50))
			else
				arg0_50()
			end
		end
	}, function()
		arg0_47.isSwitchAnim = false

		return arg3_47()
	end)
end

function var0_0.createShipItem(arg0_52, arg1_52)
	local var0_52 = {
		init = function(arg0_53)
			arg0_53._go = arg1_52
			arg0_53._tf = tf(arg1_52)
			arg0_53.icon = arg0_53._tf:Find("icon")
			arg0_53.state = arg0_53._tf:Find("state")
			arg0_53.count = arg0_53._tf:Find("count")
			arg0_53.tip = arg0_53._tf:Find("tip")
		end,
		update = function(arg0_54, arg1_54, arg2_54)
			SetCompomentEnabled(arg0_54._tf, typeof(Toggle), arg1_54.id > 0)

			arg0_54.shipBluePrintVO = arg1_54

			setActive(arg0_54.state, arg0_54.shipBluePrintVO.id > 0)
			setActive(arg0_54.count, arg0_54.shipBluePrintVO.id > 0)

			if arg0_54.shipBluePrintVO.id > 0 then
				LoadSpriteAsync("shipdesignicon/" .. arg0_54.shipBluePrintVO:getShipVO():getPainting(), function(arg0_55)
					if arg0_54.shipBluePrintVO.id > 0 and string.find(arg0_55.name, arg0_54.shipBluePrintVO:getShipVO():getPainting()) then
						setImageSprite(arg0_54.icon, arg0_55)
					end
				end)

				local var0_54 = {
					tip = false,
					pursuing = arg1_54:isPursuing(),
					fate = arg1_54:canFateSimulation()
				}

				switch(arg1_54.state, {
					[ShipBluePrint.STATE_LOCK] = function()
						var0_54.state = "lock" .. (arg1_54:getUnlockItem() and "_item" or "")
					end,
					[ShipBluePrint.STATE_DEV] = function()
						var0_54.state = "research"
					end,
					[ShipBluePrint.STATE_DEV_FINISHED] = function()
						var0_54.state = var0_54.fate and "fate" or "dev"
						var0_54.tip = true
					end,
					[ShipBluePrint.STATE_UNLOCK] = function()
						var0_54.state = var0_54.fate and "fate" or "dev"
					end
				})
				setText(arg0_54.count, arg2_54.count > 999 and "999+" or arg2_54.count)
				setActive(arg0_54.count:Find("icon"), not var0_54.pursuing)
				setActive(arg0_54.count:Find("icon_2"), var0_54.pursuing)
				setText(arg0_54.state:Find("dev/Text"), arg0_54.shipBluePrintVO.level)

				if var0_54.fate then
					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "icon_phase_" .. arg0_54.shipBluePrintVO.fateLevel, arg0_54.state:Find("fate/Image"), true)
				end

				eachChild(arg0_54.state, function(arg0_60)
					setActive(arg0_60, arg0_60.name == var0_54.state)
				end)
				setActive(arg0_54.tip, var0_54.tip)
			else
				LoadSpriteAsync("shipdesignicon/empty", function(arg0_61)
					if arg0_54.shipBluePrintVO.id < 0 then
						setImageSprite(arg0_54.icon, arg0_61)
					end
				end)
				setActive(arg0_54.tip, false)
			end
		end,
		updateSelectedStyle = function(arg0_62, arg1_62)
			local var0_62 = arg1_62 and 0 or -25

			LeanTween.cancel(arg0_62.icon)
			LeanTween.moveY(arg0_62.icon, var0_62, 0.1)
		end,
		updatePursuingTip = function(arg0_63)
			setActive(arg0_63.count:Find("icon_2/tip"), arg0_63.shipBluePrintVO.id > 0 and arg0_63.shipBluePrintVO:isPursuingCostTip())
		end
	}

	var0_52:init()
	onButton(arg0_52, var0_52.count:Find("icon_2"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("blueprint_catchup_by_gold_help")
		})
	end, SFX_PANEL)

	return var0_52
end

function var0_0.initShips(arg0_65)
	arg0_65:checkStory()
	arg0_65:filterBlueprints()

	if not arg0_65.itemList then
		arg0_65.bluePrintItems = {}
		arg0_65.itemList = UIItemList.New(arg0_65.shipContainer, arg0_65.shipContainer:Find("ship_tpl"))

		arg0_65.itemList:make(function(arg0_66, arg1_66, arg2_66)
			if arg0_66 == UIItemList.EventUpdate then
				onToggle(arg0_65, arg2_66, function(arg0_67)
					if arg0_67 then
						if arg0_65.cbTimer then
							arg0_65.cbTimer:Stop()

							arg0_65.cbTimer = nil
						end

						arg0_65:clearLeanTween()

						arg0_65.contextData.shipBluePrintVO = arg0_65.bluePrintItems[arg2_66].shipBluePrintVO

						if arg0_65.nowShipId ~= arg0_65.contextData.shipBluePrintVO.id then
							arg0_65.nowShipId = arg0_65.contextData.shipBluePrintVO.id

							arg0_65:switchState(var7_0, true, function()
								arg0_65:setSelectedBluePrint()
							end)
						else
							arg0_65:setSelectedBluePrint()
						end
					end

					arg0_65.bluePrintItems[arg2_66]:updateSelectedStyle(arg0_67)
				end, SFX_PANEL)

				arg0_65.bluePrintItems[arg2_66] = arg0_65.bluePrintItems[arg2_66] or arg0_65:createShipItem(arg2_66)

				local var0_66 = arg0_65.filterBlueprintVOs[arg1_66 + 1]

				if var0_66.id > 0 then
					local var1_66 = var0_66:getItemId()
					local var2_66 = arg0_65:getItemById(var1_66)

					arg0_65.bluePrintItems[arg2_66]:update(var0_66, var2_66)
					arg0_65.bluePrintItems[arg2_66]:updatePursuingTip()
				else
					arg0_65.bluePrintItems[arg2_66]:update(var0_66, nil)
				end

				triggerToggle(arg2_66, false)
			end
		end)
	end

	setActive(arg0_65.shipContainer, false)
	arg0_65.itemList:align(#arg0_65.filterBlueprintVOs)
	setActive(arg0_65.shipContainer, true)

	if not arg0_65.contextData.shipBluePrintVO or underscore.all(arg0_65.filterBlueprintVOs, function(arg0_69)
		return arg0_65.contextData.shipBluePrintVO.id ~= arg0_69.id
	end) then
		arg0_65.contextData.shipBluePrintVO = arg0_65.filterBlueprintVOs[1]
	end

	eachChild(arg0_65.shipContainer, function(arg0_70)
		if arg0_65.contextData.shipBluePrintVO.id == arg0_65.bluePrintItems[arg0_70].shipBluePrintVO.id then
			triggerToggle(arg0_70, true)
		end
	end)
end

function var0_0.filterBlueprints(arg0_71)
	if arg0_71.contextData.shipBluePrintVO then
		arg0_71.version = arg0_71.contextData.shipBluePrintVO:getConfig("blueprint_version")

		arg0_71:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, arg0_71.version)
	end

	arg0_71.filterBlueprintVOs = {}

	local var0_71 = 0

	for iter0_71, iter1_71 in pairs(arg0_71.bluePrintByIds) do
		if iter1_71:getConfig("blueprint_version") == arg0_71.version then
			table.insert(arg0_71.filterBlueprintVOs, iter1_71)

			var0_71 = var0_71 + 1
		end
	end

	for iter2_71 = var0_71, 5 do
		table.insert(arg0_71.filterBlueprintVOs, {
			id = -1,
			state = -1
		})
	end

	table.sort(arg0_71.filterBlueprintVOs, CompareFuncs({
		function(arg0_72)
			return -arg0_72.state
		end,
		function(arg0_73)
			return arg0_73.id
		end
	}))
end

function var0_0.setSelectedBluePrint(arg0_74)
	assert(arg0_74.contextData.shipBluePrintVO, "should exist blue print")

	local var0_74 = arg0_74.contextData.shipBluePrintVO

	arg0_74:updateInfo()
	arg0_74:updatePainting()
	arg0_74:updateProperty()

	local var1_74 = var0_74:isUnlock()

	setActive(arg0_74.taskListPanel, not var1_74)
	setActive(arg0_74.attrDisableBtn, not var1_74)

	if var1_74 then
		if not var0_74:canFateSimulation() or not pg.NewStoryMgr.GetInstance():IsPlayed(var0_74:getConfig("luck_story")) then
			arg0_74.isFate = false
		end

		arg0_74:updateMod()
		arg0_74:updatePhantomQuest()
	else
		arg0_74.isFate = false

		arg0_74:updateTaskList()
		triggerToggle(arg0_74.initBtn, true)
	end

	setActive(arg0_74.phantomPanel, var1_74 and arg0_74.isPhantom)
	setActive(arg0_74.fittingPanel, var1_74 and arg0_74.isFate)
	setActive(arg0_74.modPanel, var1_74 and not arg0_74.isFate and not arg0_74.isPhantom)
	setActive(arg0_74.itemUnlockBtn, not var1_74 and var0_74:getUnlockItem())

	if var0_74:isDeving() then
		arg0_74:emit(ShipBluePrintMediator.ON_CHECK_TAKES, var0_74.id)
	end
end

function var0_0.updateMod(arg0_75)
	if arg0_75.noUpdateMod then
		return
	end

	local var0_75 = arg0_75.contextData.shipBluePrintVO

	if not var0_75 or not var0_75:isUnlock() or not var0_75:isFetched() then
		return
	end

	arg0_75:updateModPanel()
	arg0_75:updateModAdditionPanel()
end

function var0_0.updateModInfo(arg0_76, arg1_76)
	local var0_76 = arg0_76:getShipById(arg1_76.shipId)
	local var1_76 = arg0_76.contextData.shipBluePrintVO
	local var2_76 = intProperties(var1_76:getShipProperties(var0_76))
	local var3_76 = intProperties(arg1_76:getShipProperties(var0_76))
	local var4_76 = Clone(arg1_76)

	var4_76.level = var4_76:getMaxLevel()

	local var5_76 = intProperties(var4_76:getShipProperties(var0_76))

	local function var6_76(arg0_77, arg1_77, arg2_77, arg3_77)
		local var0_77 = arg0_77:Find("attr_bg/name")
		local var1_77 = arg0_77:Find("attr_bg/value")
		local var2_77 = arg0_77:Find("attr_bg/max")
		local var3_77 = arg0_77:Find("slider"):GetComponent(typeof(Slider))
		local var4_77 = arg0_77:Find("pre_slider"):GetComponent(typeof(Slider))
		local var5_77 = arg0_77:Find("exp")

		if arg1_76:isMaxLevel() then
			arg3_77 = arg2_77
		end

		setText(var2_77, arg3_77)
		setText(var0_77, AttributeType.Type2Name(arg1_77))
		setText(var1_77, arg2_77)

		local var6_77, var7_77 = var1_76:getBluePrintAddition(arg1_77)
		local var8_77 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, arg1_77)
		local var9_77 = var1_76:getExpRetio(var8_77)

		var3_77.value = var7_77 / var9_77

		local var10_77, var11_77 = arg1_76:getBluePrintAddition(arg1_77)
		local var12_77 = arg1_76:getExpRetio(var8_77)

		setText(var5_77, math.floor(var11_77) .. "/" .. var9_77)

		var4_77.value = math.floor(var10_77) > math.floor(var6_77) and 1 or var11_77 / var12_77
	end

	local var7_76 = 0

	for iter0_76, iter1_76 in pairs(var3_76) do
		if table.contains(ShipModAttr.BLUEPRINT_ATTRS, iter0_76) then
			local var8_76 = arg0_76.attrContainer:Find(iter0_76)

			var7_76 = var7_76 + 1

			var6_76(var8_76, iter0_76, iter1_76, var5_76[iter0_76] or 0)
		end
	end

	arg0_76.modLevel.text = arg0_76:formatModLvTxt(arg1_76.level, arg1_76:getMaxLevel())

	local var9_76 = var1_76:getNextLevelExp()

	if var9_76 == -1 then
		arg0_76.levelSlider.value = 1
	else
		arg0_76.levelSlider.value = var1_76.exp / var9_76
	end

	local var10_76 = arg1_76:getNextLevelExp()

	if var10_76 == -1 then
		setText(arg0_76.levelSliderTxt, "MAX")

		arg0_76.preLevelSlider.value = 1
	else
		setText(arg0_76.levelSliderTxt, arg1_76.exp .. "/" .. arg1_76:getNextLevelExp())

		arg0_76.preLevelSlider.value = arg1_76.level > var1_76.level and 1 or arg1_76.exp / var10_76
	end

	local var11_76, var12_76 = arg1_76:isShipModMaxLevel(var0_76)

	setActive(arg0_76.needLevelTxt, var11_76)
	setActive(arg0_76.levelSliderTxt, not var11_76)

	if var11_76 then
		setText(arg0_76.needLevelTxt, i18n("buleprint_need_level_tip", var12_76))

		arg0_76.levelSlider.value = 1
	end
end

function var0_0.inModAnim(arg0_78)
	return arg0_78.inAnim
end

function var0_0.formatModLvTxt(arg0_79, arg1_79, arg2_79)
	return "<size=45>" .. arg1_79 .. "</size>/<size=27>" .. arg2_79 .. "</size>"
end

local var8_0 = 0.2

function var0_0.doModAnim(arg0_80, arg1_80, arg2_80)
	arg0_80:clearLeanTween()

	arg0_80.inAnim = true

	local var0_80 = {}
	local var1_80 = arg2_80:getMaxLevel()

	if arg1_80.level ~= var1_80 then
		local function var2_80(arg0_81, arg1_81, arg2_81)
			arg0_81 = Clone(arg0_81)
			arg0_81.level = arg1_81
			arg0_81.exp = arg2_81

			return arg0_81
		end

		arg0_80.preLevelSlider.value = 0

		for iter0_80 = arg1_80.level, arg2_80.level do
			local var3_80 = iter0_80 == arg1_80.level and arg1_80.exp / arg1_80:getNextLevelExp() or 0
			local var4_80 = iter0_80 == arg2_80.level and arg2_80.level ~= var1_80 and arg2_80.exp / arg2_80:getNextLevelExp() or 1

			table.insert(var0_80, function(arg0_82)
				TweenValue(go(arg0_80.levelSlider), var3_80, var4_80, var8_0, nil, function(arg0_83)
					arg0_80.levelSlider.value = arg0_83
				end, function()
					local var0_84 = iter0_80 == arg1_80.level and arg1_80 or var2_80(arg1_80, iter0_80, 0)
					local var1_84 = iter0_80 == arg2_80.level and arg2_80 or var2_80(arg1_80, iter0_80 + 1, 0)

					arg0_80:doAttrsAinm(var0_84, var1_84, arg0_82)

					arg0_80.modLevel.text = arg0_80:formatModLvTxt(var1_84.level, var1_80)
				end)
			end)
		end

		table.insert(arg0_80.leanTweens, arg0_80.levelSlider)
	else
		var1_80 = arg2_80:getMaxFateLevel()

		local function var5_80(arg0_85, arg1_85, arg2_85)
			arg0_85 = Clone(arg0_85)
			arg0_85.fateLevel = arg1_85
			arg0_85.exp = arg2_85

			return arg0_85
		end

		arg0_80.prePhaseSlider.value = 0

		for iter1_80 = arg1_80.fateLevel, arg2_80.fateLevel do
			local var6_80 = iter1_80 == arg1_80.fateLevel and arg1_80.exp / arg1_80:getNextFateLevelExp() or 0
			local var7_80 = iter1_80 == arg2_80.fateLevel and arg2_80.fateLevel ~= var1_80 and arg2_80.exp / arg2_80:getNextFateLevelExp() or 1

			table.insert(var0_80, function(arg0_86)
				TweenValue(go(arg0_80.phaseSlider), var6_80, var7_80, var8_0, nil, function(arg0_87)
					arg0_80.phaseSlider.value = arg0_87
				end, function()
					if iter1_80 ~= arg1_80.fateLevel or not arg1_80 then
						local var0_88 = var5_80(arg1_80, iter1_80, 0)
					end

					local var1_88 = iter1_80 == arg2_80.fateLevel and arg2_80 or var5_80(arg1_80, iter1_80 + 1, 0)

					arg0_80:updateFittingAttrPanel(var1_88)
					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.min(var1_88.fateLevel + 1, var1_88:getMaxFateLevel()), arg0_80.phasePic, true)
					arg0_86()
				end)
			end)
		end

		table.insert(arg0_80.leanTweens, arg0_80.phaseSlider)
	end

	seriesAsync(var0_80, function()
		arg0_80.noUpdateMod = false

		arg0_80:updateMod()

		arg0_80.inAnim = false
	end)
end

function var0_0.doAttrsAinm(arg0_90, arg1_90, arg2_90, arg3_90)
	local var0_90 = {}
	local var1_90 = arg0_90:getShipById(arg1_90.shipId)
	local var2_90 = intProperties(arg1_90:getShipProperties(var1_90))
	local var3_90 = intProperties(arg2_90:getShipProperties(var1_90))

	for iter0_90, iter1_90 in ipairs(ShipModAttr.BLUEPRINT_ATTRS) do
		if iter1_90 ~= AttributeType.AntiAircraft then
			local var4_90 = arg0_90.attrContainer:Find(iter1_90)
			local var5_90 = var4_90:Find("attr_bg/value"):GetComponent(typeof(Text))
			local var6_90 = var4_90:Find("slider"):GetComponent(typeof(Slider))
			local var7_90 = var4_90:Find("pre_slider"):GetComponent(typeof(Slider))
			local var8_90 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, iter1_90)
			local var9_90 = arg1_90:getExpRetio(var8_90)
			local var10_90 = var2_90[iter1_90]
			local var11_90 = var3_90[iter1_90]
			local var12_90, var13_90 = arg1_90:getBluePrintAddition(iter1_90)
			local var14_90, var15_90 = arg2_90:getBluePrintAddition(iter1_90)
			local var16_90 = var13_90 / var9_90
			local var17_90 = var15_90 / var9_90

			var7_90.value = 0

			table.insert(var0_90, function(arg0_91)
				arg0_90:doAttrAnim(var6_90, var5_90, var16_90, var17_90, math.floor(var12_90), math.floor(var14_90), var10_90, var11_90, arg0_91)
			end)
		end
	end

	parallelAsync(var0_90, arg3_90)
end

local var9_0 = 0.1

function var0_0.doAttrAnim(arg0_92, arg1_92, arg2_92, arg3_92, arg4_92, arg5_92, arg6_92, arg7_92, arg8_92, arg9_92)
	table.insert(arg0_92.leanTweens, arg1_92)

	local var0_92 = {}

	for iter0_92 = arg5_92, arg6_92 do
		local var1_92 = iter0_92 == arg5_92 and arg3_92 or 0
		local var2_92 = iter0_92 == arg6_92 and arg4_92 or 1

		table.insert(var0_92, function(arg0_93)
			TweenValue(go(arg1_92), var1_92, var2_92, var9_0, nil, function(arg0_94)
				arg1_92.value = arg0_94
			end, function()
				arg2_92.text = arg8_92 - math.min(arg6_92 - iter0_92, arg8_92 - arg7_92)

				arg0_93()
			end)
		end)
	end

	seriesAsync(var0_92, function()
		arg9_92()
	end)
end

function var0_0.clearLeanTween(arg0_97, arg1_97)
	for iter0_97, iter1_97 in pairs(arg0_97.leanTweens) do
		if LeanTween.isTweening(go(iter1_97)) then
			LeanTween.cancel(go(iter1_97))
		end
	end

	if arg0_97.inAnim then
		arg0_97.inAnim = nil

		if not arg1_97 then
			arg0_97.noUpdateMod = false
		end
	end

	arg0_97.leanTweens = {}
end

function var0_0.updateModPanel(arg0_98)
	local var0_98 = arg0_98.contextData.shipBluePrintVO
	local var1_98 = arg0_98:getShipById(var0_98.shipId)
	local var2_98 = var0_98:getConfig("strengthen_item")
	local var3_98 = arg0_98:getItemById(var2_98)
	local var4_98 = var3_98.count == 0 and var0_98:isPursuing()
	local var5_98 = 0
	local var6_98
	local var7_98

	if var4_98 then
		local var8_98 = getProxy(TechnologyProxy)

		var6_98 = math.min(var8_98:calcMaxPursuingCount(var0_98), var0_98:getUseageMaxItem())

		function var7_98(arg0_99)
			local var0_99 = arg0_99 * var0_98:getItemExp()
			local var1_99 = Clone(var0_98)

			var1_99:addExp(var0_99)
			arg0_98:updateModInfo(var1_99)
			setText(arg0_98.calcTxt, arg0_99)

			local var2_99 = var0_98:isRarityUR()
			local var3_99 = TechnologyProxy.getPursuingDiscount(var8_98:getPursuingTimes(var2_99) + var5_98 + 1, var2_99)

			setText(arg0_98.itemInfoIcon:Find("icon_bg/count"), var0_98:getPursuingPrice(var3_99))
			setActive(arg0_98.itemInfo:Find("no_cost"), var3_99 == 0)
			setActive(arg0_98.itemInfo:Find("discount"), var3_99 > 0 and var3_99 < 100)

			if var3_99 > 0 and var3_99 < 100 then
				setText(arg0_98.itemInfo:Find("discount/Text"), 100 - var3_99 .. "%OFF")
			end

			setActive(arg0_98.modBtn:Find("pursuing_cost"), var5_98 > 0)
			setText(arg0_98.modBtn:Find("pursuing_cost/Text"), var8_98:calcPursuingCost(var0_98, arg0_99))
		end

		local var9_98 = {
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		}

		updateDrop(arg0_98.itemInfoIcon, var9_98)
		onButton(arg0_98, arg0_98.itemInfoIcon, function()
			if LOCK_TECHNOLOGY_PURSUING_TIP then
				arg0_98:emit(BaseUI.ON_DROP, var9_98)
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("blueprint_catchup_by_gold_help")
				})
			end
		end, SFX_PANEL)
		setScrollText(findTF(arg0_98.itemInfo, "name/Text"), var9_98:getConfig("name"))
		setText(arg0_98.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold))
		setText(arg0_98.itemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(arg0_98.modBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(arg0_98, arg0_98.modBtn, function()
			if arg0_98:inModAnim() then
				return
			end

			if var5_98 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", var8_98:calcPursuingCost(var0_98, var5_98)),
				onYes = function()
					arg0_98:emit(ShipBluePrintMediator.ON_PURSUING, var0_98.id, var5_98)
				end
			})
		end, SFX_PANEL)
	else
		var6_98 = math.min(var3_98.count, var0_98:getUseageMaxItem())

		function var7_98(arg0_103)
			local var0_103 = arg0_103 * var0_98:getItemExp()
			local var1_103 = Clone(var0_98)

			var1_103:addExp(var0_103)
			arg0_98:updateModInfo(var1_103)
			setText(arg0_98.calcTxt, arg0_103)
		end

		updateDrop(arg0_98.itemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = var3_98.id
		})
		onButton(arg0_98, arg0_98.itemInfoIcon, function()
			ItemTipPanel.ShowItemTipbyID(var3_98.id, i18n("title_item_ways", var3_98:getConfig("name")))
		end, SFX_PANEL)
		setScrollText(findTF(arg0_98.itemInfo, "name/Text"), var3_98:getConfig("name"))
		setText(arg0_98.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. var3_98.count)
		setActive(arg0_98.itemInfo:Find("no_cost"), false)
		setActive(arg0_98.itemInfo:Find("discount"), false)
		setActive(arg0_98.modBtn:Find("pursuing_cost"), false)
		onButton(arg0_98, arg0_98.modBtn, function()
			if arg0_98:inModAnim() then
				return
			end

			if var5_98 == 0 then
				return
			end

			arg0_98:emit(ShipBluePrintMediator.ON_MOD, var0_98.id, var5_98)
		end, SFX_PANEL)
	end

	var7_98(var5_98)

	local var10_98 = 0
	local var11_98 = Clone(var0_98)
	local var12_98 = var0_98:getItemExp()

	while var11_98.level < var11_98:getMaxLevel() and var1_98.level >= var11_98:getStrengthenConfig(math.min(var11_98.level + 1, var11_98:getMaxLevel())).need_lv do
		var10_98 = var10_98 + 1

		var11_98:addExp(var12_98)
	end

	local var13_98 = math.min(var6_98, var10_98)

	pressPersistTrigger(arg0_98.calcMinusBtn, 0.5, function(arg0_106)
		if arg0_98:inModAnim() or var0_98:isMaxLevel() or var5_98 == 0 then
			arg0_106()

			return
		end

		var5_98 = var5_98 - 1

		var7_98(var5_98)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_98.calcPlusBtn, 0.5, function(arg0_107)
		if arg0_98:inModAnim() or var0_98:isMaxLevel() or var5_98 == var13_98 then
			arg0_107()

			return
		end

		var5_98 = var5_98 + 1

		var7_98(var5_98)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_98, arg0_98.calcMaxBtn, function()
		if arg0_98:inModAnim() or var0_98:isMaxLevel() or var5_98 == var13_98 then
			return
		end

		var5_98 = var13_98

		var7_98(var5_98)
	end, SFX_PANEL)
	setActive(arg0_98.calcMaxBtn, not var4_98)

	local var14_98 = var0_98:canFateSimulation()

	if var14_98 then
		onButton(arg0_98, arg0_98.fittingBtn, function()
			if arg0_98.isSwitchAnim then
				return
			end

			setActive(arg0_98.fittingBtnEffect, true)

			arg0_98.cbTimer = Timer.New(function()
				arg0_98.cbTimer = nil

				setActive(arg0_98.fittingBtnEffect, false)
				arg0_98:switchState(var7_0, true, function()
					arg0_98.isFate = true

					setActive(arg0_98.fittingPanel, arg0_98.isFate)
					setActive(arg0_98.modPanel, not arg0_98.isFate)

					if not PlayerPrefs.HasKey("first_fate") then
						triggerButton(arg0_98.helpBtn)
						PlayerPrefs.SetInt("first_fate", 1)
						PlayerPrefs.Save()
					end
				end)
			end, 0.6)

			arg0_98.cbTimer:Start()
		end, SFX_PANEL)
		arg0_98:updateFittingPanel()

		if not inGuide then
			pg.NewStoryMgr.GetInstance():Play(var0_98:getConfig("luck_story"), function(arg0_112)
				if arg0_112 then
					arg0_98:buildStartAni("fateStartWindow", function()
						triggerButton(arg0_98.fittingBtn)
					end)
				end
			end)
		end
	end

	setActive(arg0_98.calcPanel, not var14_98)
	setActive(arg0_98.fittingBtn, var14_98)
	setActive(arg0_98.fittingBtnEffect, false)
end

function var0_0.updateFittingPanel(arg0_114)
	local var0_114 = arg0_114.contextData.shipBluePrintVO
	local var1_114 = arg0_114:getShipById(var0_114.shipId)
	local var2_114 = var0_114:getConfig("strengthen_item")
	local var3_114 = arg0_114:getItemById(var2_114)
	local var4_114 = var3_114.count == 0 and var0_114:isPursuing()
	local var5_114 = 0
	local var6_114
	local var7_114

	if var4_114 then
		local var8_114 = getProxy(TechnologyProxy)

		var6_114 = math.min(var8_114:calcMaxPursuingCount(var0_114), var0_114:getFateUseageMaxItem())

		function var7_114(arg0_115)
			local var0_115 = arg0_115 * var0_114:getItemExp()
			local var1_115 = Clone(var0_114)

			var1_115:addExp(var0_115)
			arg0_114:updateFittingInfo(var1_115)
			setText(arg0_114.fittingCalcTxt, arg0_115)

			local var2_115 = var0_114:isRarityUR()
			local var3_115 = TechnologyProxy.getPursuingDiscount(var8_114:getPursuingTimes(var2_115) + var5_114 + 1, var2_115)

			setText(arg0_114.fittingItemInfoIcon:Find("icon_bg/count"), var0_114:getPursuingPrice(var3_115))
			setActive(arg0_114.fittingItemInfo:Find("no_cost"), var3_115 == 0)
			setActive(arg0_114.fittingItemInfo:Find("discount"), var3_115 > 0 and var3_115 < 100)

			if var3_115 > 0 and var3_115 < 100 then
				setText(arg0_114.fittingItemInfo:Find("discount/Text"), 100 - var3_115 .. "%OFF")
			end

			setActive(arg0_114.fittingConfirmBtn:Find("pursuing_cost"), arg0_115 > 0)
			setText(arg0_114.fittingConfirmBtn:Find("pursuing_cost/Text"), var8_114:calcPursuingCost(var0_114, arg0_115))
		end

		local var9_114 = {
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		}

		updateDrop(arg0_114.fittingItemInfoIcon, var9_114)
		onButton(arg0_114, arg0_114.fittingItemInfoIcon, function()
			if LOCK_TECHNOLOGY_PURSUING_TIP then
				arg0_114:emit(BaseUI.ON_DROP, var9_114)
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("blueprint_catchup_by_gold_help")
				})
			end
		end, SFX_PANEL)
		setScrollText(findTF(arg0_114.fittingItemInfo, "name/Text"), var9_114:getConfig("name"))
		setText(arg0_114.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold))
		setText(arg0_114.fittingItemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(arg0_114.fittingConfirmBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(arg0_114, arg0_114.fittingConfirmBtn, function()
			if arg0_114:inModAnim() then
				return
			end

			if var5_114 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", var8_114:calcPursuingCost(var0_114, var5_114)),
				onYes = function()
					arg0_114:emit(ShipBluePrintMediator.ON_PURSUING, var0_114.id, var5_114)
				end
			})
		end, SFX_PANEL)
	else
		var6_114 = math.min(var3_114.count, var0_114:getFateUseageMaxItem())

		function var7_114(arg0_119)
			local var0_119 = arg0_119 * var0_114:getItemExp()
			local var1_119 = Clone(var0_114)

			var1_119:addExp(var0_119)
			arg0_114:updateFittingInfo(var1_119)
			setText(arg0_114.fittingCalcTxt, arg0_119)
		end

		updateDrop(arg0_114.fittingItemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = var3_114.id
		})
		onButton(arg0_114, arg0_114.fittingItemInfoIcon, function()
			ItemTipPanel.ShowItemTipbyID(var3_114.id, i18n("title_item_ways", var3_114:getConfig("name")))
		end, SFX_PANEL)
		setScrollText(arg0_114.fittingItemInfo:Find("name/Text"), var3_114:getConfig("name"))
		setText(arg0_114.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. var3_114.count)
		setActive(arg0_114.fittingItemInfo:Find("no_cost"), false)
		setActive(arg0_114.fittingItemInfo:Find("discount"), false)
		setActive(arg0_114.fittingConfirmBtn:Find("pursuing_cost"), false)
		onButton(arg0_114, arg0_114.fittingConfirmBtn, function()
			if arg0_114:inModAnim() then
				return
			end

			if var5_114 == 0 then
				return
			end

			arg0_114:emit(ShipBluePrintMediator.ON_MOD, var0_114.id, var5_114)
		end, SFX_PANEL)
	end

	setText(arg0_114.fittingAttrPanel:Find("attr/name"), AttributeType.Type2Name(AttributeType.Luck))
	setText(arg0_114.fittingPanel:Find("desc/top/text/Text"), i18n("fate_phase_word"))
	onButton(arg0_114, arg0_114.fittingCancelBtn, function()
		arg0_114:switchState(var7_0, true, function()
			arg0_114.isFate = false

			setActive(arg0_114.fittingPanel, arg0_114.isFate)
			setActive(arg0_114.modPanel, not arg0_114.isFate)
		end)
	end, SFX_PANEL)

	local var10_114 = 0
	local var11_114 = Clone(var0_114)
	local var12_114 = var0_114:getItemExp()

	while var11_114.fateLevel < var11_114:getMaxFateLevel() and var1_114.level >= var11_114:getFateStrengthenConfig(math.min(var11_114.fateLevel + 1, var11_114:getMaxFateLevel())).need_lv do
		var10_114 = var10_114 + 1

		var11_114:addExp(var12_114)
	end

	local var13_114 = math.min(var6_114, var10_114)

	pressPersistTrigger(arg0_114.fittingCalcMinusBtn, 0.5, function(arg0_124)
		if arg0_114:inModAnim() or var0_114:isMaxFateLevel() or var5_114 == 0 then
			arg0_124()

			return
		end

		var5_114 = math.max(var5_114 - 1, 0)

		var7_114(var5_114)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_114.fittingCalcPlusBtn, 0.5, function(arg0_125)
		if arg0_114:inModAnim() or var0_114:isMaxFateLevel() or var5_114 == var13_114 then
			arg0_125()

			return
		end

		var5_114 = math.max(math.min(var5_114 + 1, var13_114), 0)

		var7_114(var5_114)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_114, arg0_114.fittingCalcMaxBtn, function()
		if arg0_114:inModAnim() or var0_114:isMaxFateLevel() or var5_114 == var13_114 then
			return
		end

		var5_114 = var13_114

		var7_114(var5_114)
	end, SFX_PANEL)
	setActive(arg0_114.fittingCalcMaxBtn, not var4_114)

	local var14_114 = arg0_114.fittingAttrPanel:Find("phase_panel")
	local var15_114 = var14_114:Find("phase_tpl")

	setActive(var15_114, false)

	local var16_114 = {
		0,
		-60,
		0,
		60
	}
	local var17_114 = {}

	for iter0_114 = 1, var0_114:getMaxFateLevel() do
		local var18_114 = var14_114:Find("phase_" .. iter0_114) or cloneTplTo(var15_114, var14_114, "phase_" .. iter0_114)
		local var19_114 = var0_114:getFateStrengthenConfig(iter0_114)

		assert(var19_114.special == 1 and type(var19_114.special_effect) == "table", "without fate config")

		local var20_114 = var19_114.special_effect
		local var21_114

		for iter1_114, iter2_114 in ipairs(var20_114) do
			if iter2_114[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				var21_114 = iter2_114[2][2]

				break
			end
		end

		for iter3_114, iter4_114 in ipairs({
			"off",
			"on"
		}) do
			setActive(var18_114:Find(iter4_114 .. "/icon"), not var21_114)
			setActive(var18_114:Find(iter4_114 .. "/skill"), var21_114)
			setActive(var18_114:Find(iter4_114 .. "/icon/line"), var16_114[iter0_114])
			setActive(var18_114:Find(iter4_114 .. "/skill/line"), var16_114[iter0_114])

			if var16_114[iter0_114] then
				var18_114:Find(iter4_114 .. "/icon/line").localEulerAngles = Vector3(0, 0, var16_114[iter0_114])
				var18_114:Find(iter4_114 .. "/skill/line").localEulerAngles = Vector3(0, 0, var16_114[iter0_114])

				GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", iter0_114 .. "_" .. iter4_114, var18_114:Find(iter4_114 .. "/icon/icon"), true)
			end
		end

		if var21_114 then
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_" .. var21_114, "", var18_114:Find("off/skill/icon"), true)
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_on_" .. var21_114, "", var18_114:Find("on/skill/icon"), true)

			var17_114[iter0_114] = 55
		else
			var17_114[iter0_114] = 40
		end

		onButton(arg0_114, var18_114, function()
			arg0_114:showFittingMsgPanel(iter0_114)
		end, SFX_PANEL)
	end

	local var22_114 = Vector2.zero
	local var23_114 = Vector2.zero
	local var24_114 = Vector2.zero

	for iter5_114 = 1, var0_114:getMaxFateLevel() do
		local var25_114 = var14_114:Find("phase_" .. iter5_114)

		setAnchoredPosition(var25_114, var22_114)

		var23_114.x = math.min(var23_114.x, var22_114.x)
		var23_114.y = math.min(var23_114.y, var22_114.y)
		var24_114.x = math.max(var24_114.x, var22_114.x)
		var24_114.y = math.max(var24_114.y, var22_114.y)

		if var16_114[iter5_114] then
			var22_114 = var22_114 + (var17_114[iter5_114] + var17_114[iter5_114 + 1]) * Vector2(math.cos(math.pi * var16_114[iter5_114] / 180), math.sin(math.pi * var16_114[iter5_114] / 180))
		end
	end

	setSizeDelta(var14_114, var24_114 - var23_114)
	setAnchoredPosition(var14_114, {
		y = -var24_114.y
	})
	var7_114(var5_114)
end

function var0_0.updateFittingInfo(arg0_128, arg1_128)
	local var0_128 = arg0_128:getShipById(arg1_128.shipId)
	local var1_128 = arg0_128.contextData.shipBluePrintVO

	arg0_128:updateFittingAttrPanel(var1_128, arg1_128)
	GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.max(arg1_128.fateLevel, 1), arg0_128.phasePic, true)

	local var2_128 = var1_128:getNextFateLevelExp()

	if var2_128 == -1 then
		arg0_128.phaseSlider.value = 1
	else
		arg0_128.phaseSlider.value = var1_128.exp / var2_128
	end

	local var3_128 = arg1_128:getNextFateLevelExp()

	if var3_128 == -1 then
		setText(arg0_128.phaseSliderTxt, "MAX")

		arg0_128.prePhaseSlider.value = 1
	else
		local var4_128 = math.floor(arg1_128.exp / arg1_128:getNextFateLevelExp() * 100)

		setText(arg0_128.phaseSliderTxt, tostring(var4_128) .. "%")

		arg0_128.prePhaseSlider.value = arg1_128.fateLevel > var1_128.fateLevel and 1 or arg1_128.exp / var3_128
	end

	local var5_128, var6_128 = arg1_128:isShipModMaxFateLevel(var0_128)

	setActive(arg0_128.fittingNeedMask, var5_128)

	if var5_128 then
		setText(arg0_128.fittingNeedMask:Find("limit"), i18n("buleprint_need_level_tip", var6_128))

		arg0_128.phaseSlider.value = 1
	end
end

function var0_0.updateFittingAttrPanel(arg0_129, arg1_129, arg2_129)
	setText(arg0_129.fittingAttrPanel:Find("attr/name/Text"), " + " .. defaultValue((arg2_129 or arg1_129):attrSpecialAddition()[AttributeType.Luck], 0))

	arg0_129.blinkTarget = arg0_129.blinkTarget or {
		{},
		{}
	}

	for iter0_129 = 1, arg1_129:getMaxFateLevel() do
		local var0_129 = arg0_129.fittingAttrPanel:Find("phase_panel/phase_" .. iter0_129)
		local var1_129 = var0_129:Find("off")
		local var2_129 = var0_129:Find("on")

		if arg2_129 and iter0_129 > arg1_129.fateLevel and iter0_129 <= arg2_129.fateLevel then
			setActive(var1_129, true)
			setActive(var2_129, true)

			if not table.contains(arg0_129.blinkTarget[1], var1_129) then
				table.insert(arg0_129.blinkTarget[1], var1_129)
				table.insert(arg0_129.blinkTarget[2], var2_129)
			end
		else
			local var3_129 = table.indexof(arg0_129.blinkTarget[1], var1_129)

			if var3_129 then
				table.remove(arg0_129.blinkTarget[1], var3_129)
				table.remove(arg0_129.blinkTarget[2], var3_129)
			end

			setActive(var1_129, iter0_129 > arg1_129.fateLevel)
			setActive(var2_129, iter0_129 <= arg1_129.fateLevel)

			var1_129:GetComponent(typeof(CanvasGroup)).alpha = 1
			var2_129:GetComponent(typeof(CanvasGroup)).alpha = 1
		end
	end

	if #arg0_129.blinkTarget[1] == 0 then
		LeanTween.cancel(go(arg0_129.fittingAttrPanel))
	elseif not LeanTween.isTweening(go(arg0_129.fittingAttrPanel)) then
		LeanTween.value(go(arg0_129.fittingAttrPanel), 1, 0, 0.8):setOnUpdate(System.Action_float(function(arg0_130)
			for iter0_130, iter1_130 in ipairs(arg0_129.blinkTarget[1]) do
				iter1_130:GetComponent(typeof(CanvasGroup)).alpha = arg0_130
			end

			for iter2_130, iter3_130 in ipairs(arg0_129.blinkTarget[2]) do
				iter3_130:GetComponent(typeof(CanvasGroup)).alpha = 1 - arg0_130
			end
		end)):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(0)
	end
end

function var0_0.updateModAdditionPanel(arg0_131)
	local var0_131 = arg0_131.contextData.shipBluePrintVO
	local var1_131 = var0_131:specialStrengthens()

	for iter0_131 = arg0_131.modAdditionContainer.childCount - 1, #var1_131 do
		arg0_131:cloneTplTo(arg0_131.modAdditionTpl, arg0_131.modAdditionContainer)
	end

	local var2_131 = arg0_131.modAdditionContainer.childCount

	for iter1_131 = 1, var2_131 do
		local var3_131 = iter1_131 <= #var1_131
		local var4_131 = arg0_131.modAdditionContainer:GetChild(iter1_131 - 1)

		setActive(var4_131, var3_131)

		if var3_131 then
			arg0_131:updateAdvanceTF(var0_131, var4_131, var1_131[iter1_131])
		end
	end
end

function var0_0.updateAdvanceTF(arg0_132, arg1_132, arg2_132, arg3_132)
	local var0_132 = arg1_132.level < arg3_132.level

	setActive(arg2_132:Find("mask"), var0_132)

	if var0_132 then
		setText(arg2_132:Find("mask/content/Text"), i18n("blueprint_mod_addition_lock", arg3_132.level))
	end

	local var1_132 = arg3_132.des
	local var2_132 = arg3_132.extraDes or {}
	local var3_132 = arg2_132:Find("additions")

	removeAllChildren(var3_132)

	local var4_132 = arg0_132.modAdditionPanel:Find("scroll_rect/info")

	local function var5_132(arg0_133, arg1_133)
		local var0_133 = arg1_133[2]
		local var1_133 = pg.ship_data_breakout[var0_133].pre_id
		local var2_133 = Ship.New({
			configId = var0_133
		})
		local var3_133 = Ship.New({
			configId = var1_133
		}):getStar()
		local var4_133 = var2_133:getStar()
		local var5_133 = arg0_133:Find("star_tpl")
		local var6_133 = arg0_133:Find("stars")
		local var7_133 = arg0_133:Find("pre_stars")

		removeAllChildren(var6_133)
		removeAllChildren(var7_133)

		for iter0_133 = 1, var3_133 do
			cloneTplTo(var5_133, var6_133)
		end

		for iter1_133 = 1, var4_133 do
			cloneTplTo(var5_133, var7_133)
		end
	end

	for iter0_132 = 1, #var1_132 do
		local var6_132 = cloneTplTo(var4_132, var3_132)
		local var7_132 = var6_132:Find("text_tpl")
		local var8_132 = var6_132:Find("breakout_tpl")

		setActive(var7_132, false)
		setActive(var6_132:Find("attr_tpl"), false)
		setActive(var8_132, false)
		setActive(var6_132:Find("empty_tpl"), false)

		if var1_132[iter0_132] then
			if var1_132[iter0_132][1] == ShipBluePrint.STRENGTHEN_TYPE_BREAKOUT then
				setActive(var8_132, true)
				var5_132(var8_132, var1_132[iter0_132])
			else
				setActive(var7_132, true)
				setScrollText(var7_132:Find("Text"), var1_132[iter0_132][3])
			end
		end
	end

	for iter1_132 = 1, #var2_132 do
		local var9_132 = cloneTplTo(var4_132, var3_132)
		local var10_132 = var9_132:Find("text_tpl")

		setActive(var10_132, true)
		setActive(var9_132:Find("attr_tpl"), false)
		setActive(var9_132:Find("breakout_tpl"), false)
		setActive(var9_132:Find("empty_tpl"), false)
		setScrollText(var10_132:Find("Text"), var2_132[iter1_132])
	end
end

function var0_0.updateInfo(arg0_134)
	local var0_134 = arg0_134.contextData.shipBluePrintVO
	local var1_134

	if var0_134:isFetched() then
		var1_134 = arg0_134.shipVOs[var0_134.shipId]
	end

	var1_134 = var1_134 or var0_134:getShipVO()

	local var2_134 = var1_134:getConfigTable()
	local var3_134 = var1_134:getName()

	setText(arg0_134.shipName, var3_134)
	setText(arg0_134.englishName, var2_134.english_name)
	removeAllChildren(arg0_134.stars)

	local var4_134 = var1_134:getStar()
	local var5_134 = var1_134:getMaxStar()

	for iter0_134 = 1, var5_134 do
		cloneTplTo(arg0_134.shipInfoStarTpl, arg0_134.stars, "star_" .. iter0_134)
	end

	local var6_134 = var5_134 - var4_134

	for iter1_134 = 1, var6_134 do
		local var7_134 = arg0_134.stars:GetChild(var5_134 - iter1_134)

		setActive(var7_134:Find("star_tpl"), false)
		setActive(var7_134:Find("empty_star_tpl"), true)
	end

	local var8_134 = GetSpriteFromAtlas("shiptype", var1_134:getShipType())

	if not var8_134 then
		warning("找不到船形, shipConfigId: " .. var1_134.configId)
	end

	setImageSprite(arg0_134.shipType, var8_134, true)

	local var9_134 = var0_134:isLock()

	setActive(arg0_134.finishedBtn, var0_134:isFinished())

	local var10_134 = var0_134:isDeving()

	setActive(arg0_134.progressPanel, var10_134)

	if not var10_134 then
		setActive(arg0_134.speedupBtn, false)
	end

	if var10_134 then
		arg0_134:updateTasksProgress()
	end

	local var11_134, var12_134 = var0_134:isFinishPrevTask()

	if var9_134 and not var12_134 then
		if var11_134 then
			for iter2_134, iter3_134 in ipairs(var0_134:getOpenTaskList()) do
				arg0_134:emit(ShipBluePrintMediator.ON_FINISH_TASK, iter3_134)
			end

			var12_134 = true
		else
			local var13_134 = getProxy(TaskProxy)
			local var14_134 = var0_134:getOpenTaskList()

			for iter4_134, iter5_134 in ipairs(var14_134) do
				local var15_134 = var13_134:getTaskVO(iter5_134)
				local var16_134 = iter4_134 > arg0_134.lockPanel.childCount and cloneTplTo(arg0_134.lockBtn, arg0_134.lockPanel) or arg0_134.lockPanel:GetChild(iter4_134 - 1)

				setActive(var16_134, true)

				local var17_134 = var15_134:getProgress()
				local var18_134 = var15_134:getConfig("target_num")

				setText(var16_134:Find("Text"), (var18_134 <= var17_134 and setColorStr(var17_134, COLOR_GREEN) or var17_134) .. "/" .. var18_134)
			end

			for iter6_134 = #var14_134 + 1, arg0_134.lockPanel.childCount do
				setActive(arg0_134.lockPanel:GetChild(iter6_134 - 1), false)
			end
		end
	end

	setText(arg0_134.openCondition:Find("Text"), var0_134:getConfig("unlock_word"))
	setActive(arg0_134.openCondition, var9_134)
	setActive(arg0_134.startBtn, var9_134 and var12_134)
	setActive(arg0_134.lockPanel, var9_134 and not var12_134)
end

function var0_0.updateTasksProgress(arg0_135)
	local var0_135 = arg0_135.contextData.shipBluePrintVO

	if not var0_135:isDeving() then
		return
	end

	local var1_135 = var0_135:getTaskIds()

	for iter0_135 = arg0_135.progressContainer.childCount, #var1_135 do
		cloneTplTo(arg0_135.progressTpl, arg0_135.progressContainer)
	end

	local var2_135 = arg0_135.progressContainer.childCount

	for iter1_135 = 1, var2_135 do
		local var3_135 = arg0_135.progressContainer:GetChild(iter1_135 - 1)
		local var4_135 = iter1_135 <= #var1_135

		setActive(var3_135, var4_135)

		if var4_135 then
			local var5_135 = var0_135:getTaskStateById(var1_135[iter1_135])

			setActive(findTF(var3_135, "complete"), var5_135 == ShipBluePrint.TASK_STATE_FINISHED)
			setActive(findTF(var3_135, "lock"), var5_135 == ShipBluePrint.TASK_STATE_LOCK or var5_135 == ShipBluePrint.TASK_STATE_WAIT)
			setActive(findTF(var3_135, "working"), var5_135 == ShipBluePrint.TASK_STATE_ACHIEVED or var5_135 == ShipBluePrint.TASK_STATE_OPENING or var5_135 == ShipBluePrint.TASK_STATE_START)
		end
	end

	local var6_135 = var0_135:getConfig("blueprint_version")
	local var7_135 = pg.gameset.technology_catchup_itemid.description[var6_135]

	if var7_135 then
		local var8_135 = var0_135:getTaskStateById(var1_135[1])
		local var9_135 = var0_135:getTaskStateById(var1_135[4])
		local var10_135 = var7_135[1]
		local var11_135 = getProxy(BagProxy):getItemCountById(var10_135)

		setActive(arg0_135.speedupBtn, (var8_135 == ShipBluePrint.TASK_STATE_START or var9_135 == ShipBluePrint.TASK_STATE_START) and var11_135 > 0)
	else
		setActive(arg0_135.speedupBtn, false)
	end
end

function var0_0.updatePainting(arg0_136)
	local var0_136 = arg0_136.contextData.shipBluePrintVO:getShipVO():getPainting()

	if PLATFORM_CODE == PLATFORM_CH and checkABExist("painting/" .. var0_136 .. "_blueprint") then
		var0_136 = var0_136 .. "_blueprint"
	end

	if arg0_136.lastPaintingName and arg0_136.lastPaintingName ~= var0_136 then
		retPaintingPrefab(arg0_136.painting, arg0_136.lastPaintingName)
	end

	arg0_136.lastPaintingName = var0_136

	setPaintingPrefab(arg0_136.painting, var0_136, "tuzhi")
	arg0_136:paintBreath()
end

function var0_0.updateProperty(arg0_137)
	local var0_137 = arg0_137.contextData.shipBluePrintVO
	local var1_137 = var0_137:getShipVO()

	arg0_137.propertyPanel:initProperty(var1_137.configId, PropertyPanel.TypeFlat)

	local var2_137 = var2_0[var1_137.configId].buff_list_display

	for iter0_137 = arg0_137.skillPanel.childCount, #var2_137 - 1 do
		cloneTplTo(arg0_137.skillTpl, arg0_137.skillPanel)
	end

	local var3_137 = arg0_137.skillPanel.childCount

	for iter1_137 = 1, var3_137 do
		local var4_137 = arg0_137.skillPanel:GetChild(iter1_137 - 1)
		local var5_137 = iter1_137 <= #var2_137
		local var6_137 = findTF(var4_137, "icon")

		if var5_137 then
			local var7_137 = var2_137[iter1_137]
			local var8_137 = getSkillConfig(var7_137)

			LoadImageSpriteAsync("skillicon/" .. var8_137.icon, var6_137)
			onButton(arg0_137, var4_137, function()
				arg0_137:emit(ShipBluePrintMediator.SHOW_SKILL_INFO, var8_137.id, {
					id = var8_137.id,
					level = pg.skill_data_template[var8_137.id].max_level
				}, function()
					return
				end)
			end, SFX_PANEL)
		end

		setActive(var4_137, var5_137)
	end

	setActive(arg0_137.skillArrLeft, #var2_137 > 3)
	setActive(arg0_137.skillArrRight, #var2_137 > 3)

	if #var2_137 > 3 then
		onScroll(arg0_137, arg0_137.skillRect, function(arg0_140)
			setActive(arg0_137.skillArrLeft, arg0_140.x > 0.01)
			setActive(arg0_137.skillArrRight, arg0_140.x < 0.99)
		end)
	else
		GetComponent(arg0_137.skillRect, typeof(ScrollRect)).onValueChanged:RemoveAllListeners()
	end

	setAnchoredPosition(arg0_137.skillPanel, {
		x = 0
	})

	local var9_137 = var0_137:getConfig("simulate_dungeon")

	setActive(arg0_137.simulationBtn, var9_137 ~= 0)
	onButton(arg0_137, arg0_137.simulationBtn, function()
		if var9_137 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tech_simulate_closed"))
		else
			local var0_141 = i18n("blueprint_simulation_confirm_" .. var0_137.id)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0_141,
				onYes = function()
					arg0_137:emit(ShipBluePrintMediator.SIMULATION_BATTLE, var9_137)
				end
			})
		end
	end, SFX_CONFIRM)
end

function var0_0.updateTaskList(arg0_143)
	local var0_143 = arg0_143.contextData.shipBluePrintVO
	local var1_143 = var0_143:getTaskIds()

	UIItemList.StaticAlign(arg0_143.taskContainer, arg0_143.taskTpl, #var1_143, function(arg0_144, arg1_144, arg2_144)
		arg1_144 = arg1_144 + 1

		if arg0_144 == UIItemList.EventUpdate then
			if arg0_143.taskTFs[arg1_144] then
				arg0_143.taskTFs[arg1_144]:clear()
			end

			if arg1_144 <= #var1_143 then
				if not arg0_143.taskTFs[arg1_144] then
					arg0_143.taskTFs[arg1_144] = arg0_143:createTask(arg2_144)
				end

				local var0_144 = var1_143[arg1_144]
				local var1_144 = arg0_143:getTaskById(var0_144)

				if var0_143.duration > 0 then
					var1_144.leftTime = var0_143:getTaskOpenTimeStamp(var0_144) - var0_143.duration
				end

				var1_144.taskState = var0_143:getTaskStateById(var0_144)
				var1_144.dueTime = var0_143:getTaskOpenTimeStamp(var0_144)
				var1_144.index = arg1_144

				arg0_143.taskTFs[arg1_144]:update(var1_144)
			end
		end
	end)
end

function var0_0.updatePhantomQuest(arg0_145)
	local var0_145 = arg0_145.contextData.shipBluePrintVO
	local var1_145 = var0_145:isUnlockShipPhantom()

	setActive(arg0_145.phantomPanel:Find("title/bg"), var1_145)
	setActive(arg0_145.phantomPanel:Find("title/bg_lock"), not var1_145)
	setActive(arg0_145.phantomPanel:Find("desc/content"), var1_145)
	setActive(arg0_145.phantomPanel:Find("desc/lock_mask"), not var1_145)
	setText(arg0_145.phantomPanel:Find("desc/lock_mask/Text"), i18n("tech_shadow_limit_text", getGameset("technology_shadow_unlock_lv")[1]))

	if not var1_145 then
		return
	end

	local var2_145 = var0_145:getAllPhantomQuestInfo()

	setText(arg0_145.phantomPanel:Find("title/bg/Text"), string.format("%d/%d", #underscore.filter(var2_145, function(arg0_146)
		return arg0_146.unlocked
	end), #var2_145))
	UIItemList.StaticAlign(arg0_145.rtPhantomQuestContainer, arg0_145.questTpl, #var2_145, function(arg0_147, arg1_147, arg2_147)
		arg1_147 = arg1_147 + 1

		if arg0_147 == UIItemList.EventUpdate then
			local var0_147 = var2_145[arg1_147]

			setActive(arg2_147:Find("title/bg"), var0_147.config.type ~= 5)
			setActive(arg2_147:Find("title/bg_1"), var0_147.config.type == 5)
			setActive(arg2_147:Find("title/complete"), var0_147.unlocked)
			setActive(arg2_147:Find("title/working"), not var0_147.unlocked)
			setText(arg2_147:Find("title/name"), var0_147.config.name)
			setText(arg2_147:Find("title/number"), arg1_147)
			setSlider(arg2_147:Find("title/slider"), 0, var0_147.config.target_num, var0_147.unlocked and var0_147.config.target_num or var0_147.progress)
			setActive(arg2_147:Find("title/slider/complete"), var0_147.unlocked)
			setActive(arg2_147:Find("title/tip"), not var0_147.unlocked and var0_147.progress >= var0_147.config.target_num)

			if var0_147.config.type == 5 then
				setText(arg2_147:Find("desc/info/Text"), stringInset(var0_147.config.desc, var0_147.config.target_num))
			else
				setText(arg2_147:Find("desc/info/Text"), var0_147.config.desc)
			end

			local var1_147 = string.format("%d", math.clamp(var0_147.unlocked and var0_147.config.target_num or var0_147.progress, 0, var0_147.config.target_num) * 100 / var0_147.config.target_num)

			setText(arg2_147:Find("desc/info/progress"), var1_147 .. "%")
			setText(arg2_147:Find("desc/info/progress/shadow"), var1_147 .. "%")

			local var2_147 = ShipBluePrint.getPhantomQuestCostDrop(var0_147)

			setActive(arg2_147:Find("desc/item_info/items"), var2_147)

			if var2_147 then
				updateDrop(arg2_147:Find("desc/item_info/items/item_tpl/award"), var2_147)
			end

			local var3_147 = var0_147.unlocked or var0_147.progress < var0_147.config.target_num

			setActive(arg2_147:Find("desc/commit_panel/commit_btn"), not canCommit)
			setActive(arg2_147:Find("desc/commit_panel/lock_btn"), var3_147)
			onButton(arg0_145, arg2_147:Find("desc/commit_panel/commit_btn"), function()
				local var0_148 = {}

				if var2_147 then
					table.insert(var0_148, function(arg0_149)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("tech_shadow_commit_tip", var2_147:getName() .. "x" .. var2_147.count),
							onYes = arg0_149
						})
					end)
				end

				seriesAsync(var0_148, function()
					arg0_145:emit(ShipBluePrintMediator.FINISH_PHANTOM_QUEST, var0_145.id, arg1_147)
				end)
			end, SFX_CONFIRM)
			onToggle(arg0_145, arg2_147, function(arg0_151)
				if arg0_151 then
					Canvas.ForceUpdateCanvases()

					local var0_151 = arg0_145.rtPhantomQuestContainer.parent.transform:InverseTransformPoint(arg2_147.position).y
					local var1_151 = var0_151 - arg2_147.rect.height
					local var2_151 = arg0_145.rtPhantomQuestContainer.parent.transform.rect
					local var3_151 = 0

					if var1_151 < var2_151.yMin then
						var3_151 = var2_151.yMin - var1_151
					end

					if var0_151 > var2_151.yMax then
						var3_151 = var2_151.yMax - var0_151
					end

					local var4_151 = arg0_145.rtPhantomQuestContainer.localPosition

					var4_151.y = var4_151.y + var3_151
					arg0_145.rtPhantomQuestContainer.localPosition = var4_151
				end
			end, SFX_PANEL)
		end
	end)
end

function var0_0.createTask(arg0_152, arg1_152)
	local var0_152 = {
		title = arg1_152:Find("title/name"),
		desc = arg1_152:Find("desc/info/Text"),
		timerTF = arg1_152:Find("title/timer"),
		timerTFTxt = arg1_152:Find("title/timer/Text"),
		timerOpen = arg1_152:Find("title/timer/open"),
		timerClose = arg1_152:Find("title/timer/close"),
		maskAchieved = arg1_152:Find("title/slider/complete"),
		tip = arg1_152:Find("title/tip"),
		commitBtn = arg1_152:Find("desc/commit_panel/commit_btn"),
		itemInfo = arg1_152:Find("desc/item_info")
	}

	var0_152.itemContainer = var0_152.itemInfo:Find("items")
	var0_152.itemTpl = var0_152.itemContainer:Find("item_tpl")
	var0_152.numberTF = arg1_152:Find("title/number")
	var0_152.progressTF = arg1_152:Find("title/slider")
	var0_152.progessSlider = var0_152.progressTF:GetComponent(typeof(Slider))
	var0_152.lockBtn = arg1_152:Find("desc/commit_panel/lock_btn")
	var0_152.itemCount = var0_152.itemTpl:Find("award/icon_bg/count")
	var0_152.progres = arg1_152:Find("desc/info/progress")
	var0_152.progreshadow = arg1_152:Find("desc/info/progress/shadow")
	var0_152.check = findTF(arg1_152, "title/complete")
	var0_152.lock = findTF(arg1_152, "title/lock")
	var0_152.working = findTF(arg1_152, "title/working")
	var0_152.pause = findTF(arg1_152, "title/pause")
	var0_152.pauseLock = findTF(arg1_152, "title/pause_lock")
	var0_152.view = arg0_152

	onToggle(arg0_152, arg1_152, function(arg0_153)
		setActive(var0_152.desc, arg0_153)
		setActive(var0_152.progreshadow, arg0_153)

		if arg0_153 then
			Canvas.ForceUpdateCanvases()

			local var0_153 = arg0_152.taskContainer.parent.transform:InverseTransformPoint(arg1_152.position).y
			local var1_153 = var0_153 - arg1_152.rect.height
			local var2_153 = arg0_152.taskContainer.parent.transform.rect
			local var3_153 = 0

			if var1_153 < var2_153.yMin then
				var3_153 = var2_153.yMin - var1_153
			end

			if var0_153 > var2_153.yMax then
				var3_153 = var2_153.yMax - var0_153
			end

			local var4_153 = arg0_152.taskContainer.localPosition

			var4_153.y = var4_153.y + var3_153
			arg0_152.taskContainer.localPosition = var4_153
		end
	end, SFX_PANEL)

	function var0_152.update(arg0_154, arg1_154)
		arg0_154:clearTimer()

		arg0_154.autoCommit = true
		arg0_154.isExpTask = false

		removeOnButton(arg0_154.commitBtn)
		arg0_154:updateItemInfo(arg1_154)
		arg0_154:updateView(arg1_154)
		arg0_154:updateProgress(arg1_154)
	end

	function var0_152.updateItemInfo(arg0_155, arg1_155)
		arg0_155.taskVO = arg1_155

		changeToScrollText(arg0_155.title, arg1_155:getConfig("name"))
		setText(arg0_155.desc, arg1_155:getConfig("desc") .. "\n\n")

		local var0_155
		local var1_155 = arg1_155:getConfig("target_num")
		local var2_155 = arg1_155:getConfig("sub_type")

		if var2_155 == TASK_SUB_TYPE_GIVE_ITEM then
			arg0_155.autoCommit = false
			var0_155 = tonumber(arg1_155:getConfig("target_id"))
		elseif var2_155 == TASK_SUB_TYPE_PLAYER_RES then
			arg0_155.autoCommit = false
			var0_155 = id2ItemId(tonumber(arg1_155:getConfig("target_id")))
		elseif var2_155 == TASK_SUB_TYPE_BATTLE_EXP then
			arg0_155.isExpTask = true
			var0_155 = 59000
		end

		setActive(arg0_155.itemContainer, not arg0_155.autoCommit or arg0_155.isExpTask)

		if var0_155 then
			updateDrop(arg0_155.itemTpl:Find("award"), {
				type = 2,
				id = var0_155,
				count = var1_155
			})
			setText(arg0_155.itemCount, var1_155 > 1000 and math.floor(var1_155 / 1000) .. "K" or var1_155)
		end

		setText(arg0_155.numberTF, arg1_155.index)
	end

	function var0_152.updateView(arg0_156, arg1_156)
		local var0_156 = arg1_156.taskState
		local var1_156 = false
		local var2_156 = false
		local var3_156 = false

		if var0_156 == ShipBluePrint.TASK_STATE_PAUSE and arg1_156.leftTime then
			local var4_156 = getProxy(TaskProxy):getTaskVO(arg1_156.id)

			var1_156 = var4_156 and var4_156:isFinish()
			var3_156 = arg1_156.leftTime > 0
			var2_156 = var4_156 and var4_156:isReceive()

			if arg1_156.leftTime > 0 then
				setText(var0_152.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(arg1_156.leftTime))
			end
		end

		setActive(arg0_156.pause, ShipBluePrint.TASK_STATE_PAUSE == var0_156 and not var1_156 and not var3_156 or ShipBluePrint.TASK_STATE_PAUSE == var0_156 and not var3_156 and var1_156 and not arg0_156.autoCommit)
		setActive(arg0_156.pauseLock, ShipBluePrint.TASK_STATE_PAUSE == var0_156 and not var1_156 and var3_156)
		setActive(arg0_156.lockBtn, var0_156 ~= ShipBluePrint.TASK_STATE_ACHIEVED and (var0_156 ~= ShipBluePrint.TASK_STATE_START or not not arg0_156.autoCommit))
		setActive(arg0_156.commitBtn, var0_156 == ShipBluePrint.TASK_STATE_ACHIEVED or var0_156 == ShipBluePrint.TASK_STATE_START and not arg0_156.autoCommit)
		setActive(arg0_156.progressTF, var0_156 == ShipBluePrint.TASK_STATE_ACHIEVED or var0_156 == ShipBluePrint.TASK_STATE_START or var0_156 == ShipBluePrint.TASK_STATE_FINISHED or var0_156 == ShipBluePrint.TASK_STATE_PAUSE and not var3_156)
		setActive(arg0_156.lock, var0_156 == ShipBluePrint.TASK_STATE_LOCK or var0_156 == ShipBluePrint.TASK_STATE_WAIT)
		setActive(arg0_156.working, var0_156 == ShipBluePrint.TASK_STATE_OPENING or var0_156 == ShipBluePrint.TASK_STATE_START or var0_156 == ShipBluePrint.TASK_STATE_ACHIEVED)
		setActive(arg0_156.maskAchieved, var0_156 == ShipBluePrint.TASK_STATE_FINISHED or var0_156 == ShipBluePrint.TASK_STATE_PAUSE and var2_156)
		setActive(arg0_156.timerTF, var0_156 == ShipBluePrint.TASK_STATE_WAIT or var0_156 == ShipBluePrint.TASK_STATE_PAUSE and arg1_156.leftTime and arg1_156.leftTime > 0)
		setActive(arg0_156.check, arg0_156.autoCommit and var0_156 == ShipBluePrint.TASK_STATE_ACHIEVED or var0_156 == ShipBluePrint.TASK_STATE_FINISHED or var0_156 == ShipBluePrint.TASK_STATE_PAUSE and var2_156)
		setActive(arg0_156.tip, var0_156 == ShipBluePrint.TASK_STATE_ACHIEVED)
		setActive(arg0_156.timerOpen, var0_156 == ShipBluePrint.TASK_STATE_WAIT)
		setActive(arg0_156.timerClose, var0_156 == ShipBluePrint.TASK_STATE_PAUSE and arg1_156.leftTime and arg1_156.leftTime > 0)
	end

	function var0_152.updateProgress(arg0_157, arg1_157)
		local var0_157 = arg1_157.taskState
		local var1_157 = arg1_157:getProgress() / arg1_157:getConfig("target_num")

		if var0_157 == ShipBluePrint.TASK_STATE_WAIT then
			arg0_157:addTimer(arg1_157, arg1_157.dueTime)

			var1_157 = 0
		elseif var0_157 == ShipBluePrint.TASK_STATE_OPENING then
			var1_157 = 0

			arg0_157.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, arg1_157.id)
		elseif var0_157 == ShipBluePrint.TASK_STATE_PAUSE then
			if arg1_157:isReceive() then
				var1_157 = 1
			end
		elseif var0_157 == ShipBluePrint.TASK_STATE_LOCK then
			var1_157 = 0
		elseif var0_157 == ShipBluePrint.TASK_STATE_ACHIEVED then
			onButton(arg0_157.view, arg0_157.commitBtn, function()
				arg0_157.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, arg1_157.id)
			end, SFX_PANEL)

			var1_157 = 1
		elseif var0_157 == ShipBluePrint.TASK_STATE_FINISHED then
			var1_157 = 1
		elseif var0_157 == ShipBluePrint.TASK_STATE_START and not arg0_157.autoCommit then
			onButton(arg0_157.view, arg0_157.commitBtn, function()
				arg0_157.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, arg1_157.id)
			end, SFX_PANEL)

			var1_157 = 0
		end

		if var1_157 > 0 then
			arg0_157.itemSliderLT = LeanTween.value(go(arg0_157.progressTF), 0, math.min(var1_157, 1), 0.5 * math.min(var1_157, 1)):setOnUpdate(System.Action_float(function(arg0_160)
				arg0_157.progessSlider.value = arg0_160
			end)).uniqueId
		else
			arg0_157.progessSlider.value = var1_157
		end

		local var2_157 = math.floor(var1_157 * 100)

		setText(arg0_157.progres, math.ceil(math.min(var2_157, 100)) .. "%")
		setText(arg0_157.progreshadow, math.min(var2_157, 100) .. "%")
	end

	function var0_152.addTimer(arg0_161, arg1_161, arg2_161)
		arg0_161:clearTimer()

		arg0_161.taskTimer = Timer.New(function()
			local var0_162 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_162 = arg2_161 - var0_162

			if var1_162 > 0 then
				setText(arg0_161.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(var1_162))
			else
				arg0_161:clearTimer()
				setText(arg0_161.timerTFTxt, "00:00:00")
				arg0_161.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, arg1_161.id)
			end
		end, 1, -1)

		arg0_161.taskTimer:Start()
		arg0_161.taskTimer.func()
	end

	function var0_152.clearTimer(arg0_163)
		if arg0_163.taskTimer then
			arg0_163.taskTimer:Stop()

			arg0_163.taskTimer = nil
		end
	end

	function var0_152.clear(arg0_164)
		arg0_164:clearTimer()

		if arg0_164.itemSliderLT then
			LeanTween.cancel(arg0_164.itemSliderLT)

			arg0_164.itemSliderLT = nil
		end
	end

	return var0_152
end

function var0_0.openPreView(arg0_165)
	local var0_165 = arg0_165.contextData.shipBluePrintVO

	if var0_165 then
		setActive(arg0_165.preViewer, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_165.preViewer)
		arg0_165:playLoadingAni()

		arg0_165.viewShipVO = var0_165:getShipVO()
		arg0_165.breakIds = arg0_165:getStages(arg0_165.viewShipVO)

		for iter0_165 = 1, var4_0 do
			local var1_165 = arg0_165.breakIds[iter0_165]
			local var2_165 = var3_0[var1_165]
			local var3_165 = arg0_165.stages:Find("stage" .. iter0_165)

			onToggle(arg0_165, var3_165, function(arg0_166)
				if arg0_166 then
					if PLATFORM_CODE == PLATFORM_US then
						changeToScrollText(arg0_165.breakView, var3_0[var1_165].breakout_view)
					else
						setText(arg0_165.breakView, var3_0[var1_165].breakout_view)
					end

					arg0_165:switchStage(var1_165)
				end
			end, SFX_PANEL)

			if iter0_165 == 1 then
				triggerToggle(var3_165, true)
			end
		end

		arg0_165.isShowPreview = true

		arg0_165:updateMaxLevelAttrs(var0_165)
	end
end

var0_0.MAX_LEVEL_ATTRS = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.Air,
	AttributeType.Reload,
	AttributeType.ArmorType,
	AttributeType.Dodge
}

function var0_0.updateMaxLevelAttrs(arg0_167, arg1_167)
	if not arg1_167:isFetched() then
		return
	end

	local var0_167 = arg0_167.shipVOs[arg1_167.shipId]
	local var1_167 = Clone(var0_167)

	var1_167.level = 125

	local var2_167 = Clone(arg1_167)

	var2_167.level = arg1_167:getMaxLevel()

	local var3_167 = intProperties(var2_167:getShipProperties(var1_167, false))

	for iter0_167, iter1_167 in ipairs(var0_0.MAX_LEVEL_ATTRS) do
		local var4_167 = arg0_167.previewAttrContainer:Find(iter1_167)

		if iter1_167 == AttributeType.ArmorType then
			setText(var4_167:Find("bg/value"), var0_167:getShipArmorName())
		else
			setText(var4_167:Find("bg/value"), var3_167[iter1_167] or 0)
		end

		setText(var4_167:Find("bg/name"), AttributeType.Type2Name(iter1_167))
	end
end

function var0_0.closePreview(arg0_168, arg1_168)
	if arg0_168.previewer then
		arg0_168.previewer:clear()

		arg0_168.previewer = nil
	end

	setActive(arg0_168.preViewer, false)
	setActive(arg0_168.rawImage, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_168.preViewer, arg0_168._tf)

	arg0_168.isShowPreview = nil
end

function var0_0.playLoadingAni(arg0_169)
	setActive(arg0_169.seaLoading, true)
end

function var0_0.stopLoadingAni(arg0_170)
	setActive(arg0_170.seaLoading, false)
end

function var0_0.showBarrage(arg0_171)
	arg0_171.previewer = WeaponPreviewer.New(arg0_171.rawImage)

	arg0_171.previewer:configUI(arg0_171.healTF)
	arg0_171.previewer:setDisplayWeapon(arg0_171:getWaponIdsById(arg0_171.breakOutId))
	arg0_171.previewer:load(40000, arg0_171.viewShipVO, arg0_171:getAllWeaponIds(), function()
		arg0_171:stopLoadingAni()
	end)
end

function var0_0.getWaponIdsById(arg0_173, arg1_173)
	return var3_0[arg1_173].weapon_ids
end

function var0_0.getAllWeaponIds(arg0_174)
	local var0_174 = {}

	for iter0_174, iter1_174 in ipairs(arg0_174.breakIds) do
		local var1_174 = Clone(var3_0[iter1_174].weapon_ids)
		local var2_174 = {
			__add = function(arg0_175, arg1_175)
				for iter0_175, iter1_175 in ipairs(arg0_175) do
					if not table.contains(arg1_175, iter1_175) then
						table.insert(arg1_175, iter1_175)
					end
				end

				return arg1_175
			end
		}

		setmetatable(var0_174, var2_174)

		var0_174 = var0_174 + var1_174
	end

	return var0_174
end

function var0_0.getStages(arg0_176, arg1_176)
	local var0_176 = {}
	local var1_176 = math.floor(arg1_176.configId / 10)

	for iter0_176 = 1, 4 do
		local var2_176 = tonumber(var1_176 .. iter0_176)

		assert(var3_0[var2_176], "必须存在配置" .. var2_176)
		table.insert(var0_176, var2_176)
	end

	return var0_176
end

function var0_0.switchStage(arg0_177, arg1_177)
	if arg0_177.breakOutId == arg1_177 then
		return
	end

	arg0_177.breakOutId = arg1_177

	if arg0_177.previewer then
		arg0_177.previewer:setDisplayWeapon(arg0_177:getWaponIdsById(arg0_177.breakOutId))
	end
end

function var0_0.clearTimers(arg0_178)
	for iter0_178, iter1_178 in pairs(arg0_178.taskTFs or {}) do
		iter1_178:clear()
	end
end

function var0_0.cloneTplTo(arg0_179, arg1_179, arg2_179)
	local var0_179 = tf(Instantiate(arg1_179))

	SetActive(var0_179, true)
	var0_179:SetParent(tf(arg2_179), false)

	return var0_179
end

function var0_0.onBackPressed(arg0_180)
	if isActive(arg0_180.msgPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_180.msgPanel, arg0_180.top)
		setActive(arg0_180.msgPanel, false)
	elseif isActive(arg0_180.unlockPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_180.unlockPanel, arg0_180.top)
		setActive(arg0_180.unlockPanel, false)
	elseif isActive(arg0_180.versionPanel) then
		triggerButton(arg0_180.versionPanel:Find("bg"))
	elseif arg0_180.isShowPreview then
		arg0_180:closePreview(true)
	elseif arg0_180.svQuickExchange:isShowing() then
		arg0_180.svQuickExchange:Hide()
	elseif arg0_180.awakenPlay or arg0_180:inModAnim() then
		-- block empty
	else
		arg0_180:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.willExit(arg0_181)
	if isActive(arg0_181.msgPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_181.msgPanel, arg0_181.top)
		setActive(arg0_181.msgPanel, false)
	end

	if isActive(arg0_181.unlockPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_181.unlockPanel, arg0_181.top)
		setActive(arg0_181.unlockPanel, false)
	end

	arg0_181:UnOverlayPanel(arg0_181.blurPanel, arg0_181._tf)
	LeanTween.cancel(go(arg0_181.fittingAttrPanel))

	if arg0_181.lastPaintingName then
		retPaintingPrefab(arg0_181.painting, arg0_181.lastPaintingName)
	end

	for iter0_181, iter1_181 in pairs(arg0_181.taskTFs or {}) do
		iter1_181:clear()
	end

	arg0_181:closePreview(true)
	arg0_181:clearLeanTween(true)

	if arg0_181.previewer then
		arg0_181.previewer:clear()

		arg0_181.previewer = nil
	end

	if arg0_181.cbTimer then
		arg0_181.cbTimer:Stop()

		arg0_181.cbTimer = nil
	end

	if arg0_181.svQuickExchange:isShowing() then
		arg0_181.svQuickExchange:Hide()
	end

	arg0_181.svQuickExchange:Destroy()
end

function var0_0.paintBreath(arg0_182)
	LeanTween.cancel(go(arg0_182.painting))
	LeanTween.moveY(rtf(arg0_182.painting), var5_0, var6_0):setLoopPingPong():setEase(LeanTweenType.easeInOutCubic):setFrom(0)
end

function var0_0.buildStartAni(arg0_183, arg1_183, arg2_183)
	if arg1_183 == "researchStartWindow" then
		arg0_183.progressPanel.localScale = Vector3(0, 1, 1)

		LeanTween.scale(arg0_183.progressPanel, Vector3(1, 1, 1), 0.2):setDelay(2)
	end

	local function var0_183()
		arg0_183.awakenAni:SetActive(true)

		arg0_183.awakenPlay = true

		local var0_184 = tf(arg0_183.awakenAni)

		pg.UIMgr.GetInstance():BlurPanel(var0_184)
		var0_184:SetAsLastSibling()
		var0_184:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_185)
			if not IsNil(arg0_183.awakenAni) then
				pg.UIMgr.GetInstance():UnOverlayPanel(var0_184, arg0_183.blurPanel)
				arg0_183.awakenAni:SetActive(false)

				arg0_183.awakenPlay = false

				if arg2_183 then
					arg2_183()
				end
			end
		end)
	end

	local var1_183 = arg0_183._tf:Find(arg1_183 .. "(Clone)")

	arg0_183.awakenAni = var1_183 and go(var1_183)

	if not arg0_183.awakenAni then
		PoolMgr.GetInstance():GetUI(arg1_183, true, function(arg0_186)
			arg0_186:SetActive(true)

			arg0_183.awakenAni = arg0_186

			var0_183()
		end)
	else
		var0_183()
	end
end

function var0_0.showFittingMsgPanel(arg0_187, arg1_187)
	pg.UIMgr.GetInstance():BlurPanel(arg0_187.msgPanel)
	setActive(arg0_187.msgPanel, true)

	local var0_187 = arg0_187.contextData.shipBluePrintVO
	local var1_187 = var0_187:getMaxFateLevel()
	local var2_187 = arg0_187.msgPanel:Find("window/content")
	local var3_187 = var2_187:Find("pre_btn")
	local var4_187 = var2_187:Find("next_btn")
	local var5_187 = var2_187:Find("attrl_panel")
	local var6_187 = var2_187:Find("skill_panel")
	local var7_187 = var2_187:Find("phase")
	local var8_187 = {
		"I",
		"II",
		"III",
		"IV",
		"V"
	}

	local function var9_187()
		setActive(var3_187, arg1_187 > 1)
		setActive(var4_187, arg1_187 < var1_187)
		setText(var7_187, "PHASE." .. var8_187[arg1_187])

		local var0_188 = var0_187:getFateStrengthenConfig(arg1_187)

		assert(var0_188.special == 1 and type(var0_188.special_effect) == "table", "without fate config")

		local var1_188 = var0_188.special_effect
		local var2_188
		local var3_188 = {}

		for iter0_188, iter1_188 in ipairs(var1_188) do
			local var4_188 = iter1_188[1]

			if var4_188 == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				var2_188 = iter1_188[2][2]
			elseif var4_188 == ShipBluePrint.STRENGTHEN_TYPE_ATTR then
				table.insert(var3_188, iter1_188[2])
			end
		end

		setActive(var5_187, #var3_188 > 0)
		setActive(var6_187, var2_188)

		if var2_188 then
			local var5_188 = getSkillConfig(var2_188)

			GetImageSpriteFromAtlasAsync("skillicon/" .. var5_188.icon, "", var6_187:Find("skill_icon"))
			setText(var6_187:Find("skill_name"), getSkillName(var2_188))

			local var6_188 = 1

			setText(var6_187:Find("skill_lv"), "Lv." .. var6_188)
			setText(var6_187:Find("help_panel/skill_intro"), getSkillDescGet(var2_188))
		end

		if #var3_188 > 0 then
			for iter2_188, iter3_188 in ipairs(var3_188) do
				local var7_188 = iter2_188 < var5_187.childCount and var5_187:GetChild(iter2_188) or cloneTplTo(var5_187:GetChild(iter2_188 - 1), var5_187)

				setText(var7_188:Find("name"), AttributeType.Type2Name(iter3_188[1]))
				setText(var7_188:Find("number"), " + " .. iter3_188[2])
			end

			for iter4_188 = #var3_188 + 1, var5_187.childCount - 1 do
				setActive(var5_187:GetChild(iter4_188), false)
			end
		end
	end

	onButton(arg0_187, var3_187, function()
		arg1_187 = arg1_187 - 1

		var9_187()
	end)
	onButton(arg0_187, var4_187, function()
		arg1_187 = arg1_187 + 1

		var9_187()
	end)
	setText(var5_187:Find("desc"), i18n("fate_attr_word"))
	var9_187()
end

function var0_0.showUnlockPanel(arg0_191)
	pg.UIMgr.GetInstance():BlurPanel(arg0_191.unlockPanel)
	setActive(arg0_191.unlockPanel, true)

	local var0_191 = arg0_191.contextData.shipBluePrintVO.id
	local var1_191 = arg0_191.contextData.shipBluePrintVO:getUnlockItem()
	local var2_191 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = var1_191
	})
	local var3_191 = arg0_191.contextData.shipBluePrintVO:getShipVO()
	local var4_191 = var3_191:getPainting()
	local var5_191 = arg0_191.unlockPanel:Find("window/content")

	GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var4_191, var4_191, var5_191:Find("Image/mask/icon"), true)
	setText(var5_191:Find("words/Text"), i18n("techpackage_item_use_1", var3_191:getName()))
	setText(var5_191:Find("words/Text_2"), i18n("techpackage_item_use_2", var2_191:getName()))
	GetImageSpriteFromAtlasAsync(var2_191:getIcon(), "", arg0_191.unlockPanel:Find("window/confirm_btn/Image/Image"))
	setText(arg0_191.unlockPanel:Find("window/confirm_btn/Image/Text"), i18n("event_ui_consume"))
	onButton(arg0_191, arg0_191.unlockPanel:Find("window/confirm_btn"), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_191.unlockPanel, arg0_191.top)
		setActive(arg0_191.unlockPanel, false)
		arg0_191:emit(ShipBluePrintMediator.ON_ITEM_UNLOCK, var0_191, var1_191)
	end, SFX_CANCEL)
end

function var0_0.checkStory(arg0_193)
	local var0_193 = {
		nil,
		"FANGAN3"
	}

	arg0_193.storyMgr = arg0_193.storyMgr or pg.NewStoryMgr.GetInstance()

	if var0_193[arg0_193.version] and not arg0_193.storyMgr:IsPlayed(var0_193[arg0_193.version]) then
		arg0_193.storyMgr:Play(var0_193[arg0_193.version])
	end
end

function var0_0.changeEffectVisible(arg0_194, arg1_194)
	setActive(arg0_194.fittingBtn, arg1_194)
	setActive(arg0_194.initPanel, arg1_194)
end

return var0_0
