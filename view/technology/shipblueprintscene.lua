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
				local var0_54 = "shipdesignicon/" .. arg0_54.shipBluePrintVO:getShipVO():getPainting()

				LoadSpriteAsync(var0_54, function(arg0_55)
					if arg0_54.shipBluePrintVO.id > 0 and string.find(arg0_55.name, arg0_54.shipBluePrintVO:getShipVO():getPainting()) then
						setImageSprite(arg0_54.icon, arg0_55)
					end
				end)

				local var1_54 = {
					tip = false,
					pursuing = arg1_54:isPursuing(),
					fate = arg1_54:canFateSimulation()
				}

				switch(arg1_54.state, {
					[ShipBluePrint.STATE_LOCK] = function()
						var1_54.state = "lock" .. (arg1_54:getUnlockItem() and "_item" or "")
					end,
					[ShipBluePrint.STATE_DEV] = function()
						var1_54.state = "research"
					end,
					[ShipBluePrint.STATE_DEV_FINISHED] = function()
						var1_54.state = var1_54.fate and "fate" or "dev"
						var1_54.tip = true
					end,
					[ShipBluePrint.STATE_UNLOCK] = function()
						var1_54.state = var1_54.fate and "fate" or "dev"
					end
				})
				setText(arg0_54.count, arg2_54.count > 999 and "999+" or arg2_54.count)
				setActive(arg0_54.count:Find("icon"), not var1_54.pursuing)
				setActive(arg0_54.count:Find("icon_2"), var1_54.pursuing)
				setText(arg0_54.state:Find("dev/Text"), arg0_54.shipBluePrintVO.level)

				if var1_54.fate then
					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "icon_phase_" .. arg0_54.shipBluePrintVO.fateLevel, arg0_54.state:Find("fate/Image"), true)
				end

				eachChild(arg0_54.state, function(arg0_60)
					setActive(arg0_60, arg0_60.name == var1_54.state)
				end)
				setActive(arg0_54.tip, var1_54.tip)
			else
				local var2_54 = "shipdesignicon/empty"

				LoadSpriteAsync(var2_54, function(arg0_61)
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

function var0_0.getSelectedBluePrintResList(arg0_74, arg1_74)
	local var0_74 = {}
	local var1_74 = arg1_74:getShipVO():getPainting()
	local var2_74 = arg1_74:getTaskIds()

	table.insert(var0_74, "painting/" .. var1_74)

	if checkABExist("painting/" .. var1_74 .. "_blueprint") then
		table.insert(var0_74, "painting/" .. var1_74 .. "_blueprint")
	end

	if PLATFORM_CODE == PLATFORM_CH then
		if checkABExist("painting/" .. var1_74 .. "_hx") then
			table.insert(var0_74, "painting/" .. var1_74 .. "_hx")
		end

		if checkABExist("painting/" .. var1_74 .. "n_hx") then
			table.insert(var0_74, "painting/" .. var1_74 .. "n_hx")
		end

		if checkABExist("painting/" .. var1_74 .. "n") then
			table.insert(var0_74, "painting/" .. var1_74 .. "n")
		end
	end

	if arg1_74:canFateSimulation() then
		for iter0_74 = 1, arg1_74:getMaxFateLevel() do
			local var3_74 = arg1_74:getFateStrengthenConfig(iter0_74)

			if var3_74 and var3_74.special == 1 and type(var3_74.special_effect) == "table" then
				for iter1_74, iter2_74 in ipairs(var3_74.special_effect) do
					if iter2_74[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
						local var4_74 = iter2_74[2][2]

						if var4_74 then
							table.insert(var0_74, "tecfateskillicon/skill_" .. var4_74)
							table.insert(var0_74, "tecfateskillicon/skill_on_" .. var4_74)
						end

						break
					end
				end
			end
		end
	end

	return var0_74
end

function var0_0.downloadSelectedBluePrintResList(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg0_75:getSelectedBluePrintResList(arg1_75)

	SplitPackConst.DownloadByLuaArr(var0_75, function()
		if arg0_75.exited then
			return
		end

		arg2_75()
	end)
end

function var0_0.setSelectedBluePrint(arg0_77)
	assert(arg0_77.contextData.shipBluePrintVO, "should exist blue print")

	local var0_77 = arg0_77.contextData.shipBluePrintVO

	arg0_77:downloadSelectedBluePrintResList(var0_77, function()
		arg0_77:updateInfo()
		arg0_77:updatePainting()
		arg0_77:updateProperty()

		local var0_78 = var0_77:isUnlock()

		setActive(arg0_77.taskListPanel, not var0_78)
		setActive(arg0_77.attrDisableBtn, not var0_78)

		if var0_78 then
			if not var0_77:canFateSimulation() or not pg.NewStoryMgr.GetInstance():IsPlayed(var0_77:getConfig("luck_story")) then
				arg0_77.isFate = false
			end

			arg0_77:updateMod()
			arg0_77:updatePhantomQuest()
		else
			arg0_77.isFate = false

			arg0_77:updateTaskList()
			triggerToggle(arg0_77.initBtn, true)
		end

		setActive(arg0_77.phantomPanel, var0_78 and arg0_77.isPhantom)
		setActive(arg0_77.fittingPanel, var0_78 and arg0_77.isFate)
		setActive(arg0_77.modPanel, var0_78 and not arg0_77.isFate and not arg0_77.isPhantom)
		setActive(arg0_77.itemUnlockBtn, not var0_78 and var0_77:getUnlockItem())

		if var0_77:isDeving() then
			arg0_77:emit(ShipBluePrintMediator.ON_CHECK_TAKES, var0_77.id)
		end
	end)
end

function var0_0.updateMod(arg0_79)
	if arg0_79.noUpdateMod then
		return
	end

	local var0_79 = arg0_79.contextData.shipBluePrintVO

	if not var0_79 or not var0_79:isUnlock() or not var0_79:isFetched() then
		return
	end

	arg0_79:updateModPanel()
	arg0_79:updateModAdditionPanel()
end

function var0_0.updateModInfo(arg0_80, arg1_80)
	local var0_80 = arg0_80:getShipById(arg1_80.shipId)
	local var1_80 = arg0_80.contextData.shipBluePrintVO
	local var2_80 = intProperties(var1_80:getShipProperties(var0_80))
	local var3_80 = intProperties(arg1_80:getShipProperties(var0_80))
	local var4_80 = Clone(arg1_80)

	var4_80.level = var4_80:getMaxLevel()

	local var5_80 = intProperties(var4_80:getShipProperties(var0_80))

	local function var6_80(arg0_81, arg1_81, arg2_81, arg3_81)
		local var0_81 = arg0_81:Find("attr_bg/name")
		local var1_81 = arg0_81:Find("attr_bg/value")
		local var2_81 = arg0_81:Find("attr_bg/max")
		local var3_81 = arg0_81:Find("slider"):GetComponent(typeof(Slider))
		local var4_81 = arg0_81:Find("pre_slider"):GetComponent(typeof(Slider))
		local var5_81 = arg0_81:Find("exp")

		if arg1_80:isMaxLevel() then
			arg3_81 = arg2_81
		end

		setText(var2_81, arg3_81)
		setText(var0_81, AttributeType.Type2Name(arg1_81))
		setText(var1_81, arg2_81)

		local var6_81, var7_81 = var1_80:getBluePrintAddition(arg1_81)
		local var8_81 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, arg1_81)
		local var9_81 = var1_80:getExpRetio(var8_81)

		var3_81.value = var7_81 / var9_81

		local var10_81, var11_81 = arg1_80:getBluePrintAddition(arg1_81)
		local var12_81 = arg1_80:getExpRetio(var8_81)

		setText(var5_81, math.floor(var11_81) .. "/" .. var9_81)

		var4_81.value = math.floor(var10_81) > math.floor(var6_81) and 1 or var11_81 / var12_81
	end

	local var7_80 = 0

	for iter0_80, iter1_80 in pairs(var3_80) do
		if table.contains(ShipModAttr.BLUEPRINT_ATTRS, iter0_80) then
			local var8_80 = arg0_80.attrContainer:Find(iter0_80)

			var7_80 = var7_80 + 1

			var6_80(var8_80, iter0_80, iter1_80, var5_80[iter0_80] or 0)
		end
	end

	arg0_80.modLevel.text = arg0_80:formatModLvTxt(arg1_80.level, arg1_80:getMaxLevel())

	local var9_80 = var1_80:getNextLevelExp()

	if var9_80 == -1 then
		arg0_80.levelSlider.value = 1
	else
		arg0_80.levelSlider.value = var1_80.exp / var9_80
	end

	local var10_80 = arg1_80:getNextLevelExp()

	if var10_80 == -1 then
		setText(arg0_80.levelSliderTxt, "MAX")

		arg0_80.preLevelSlider.value = 1
	else
		setText(arg0_80.levelSliderTxt, arg1_80.exp .. "/" .. arg1_80:getNextLevelExp())

		arg0_80.preLevelSlider.value = arg1_80.level > var1_80.level and 1 or arg1_80.exp / var10_80
	end

	local var11_80, var12_80 = arg1_80:isShipModMaxLevel(var0_80)

	setActive(arg0_80.needLevelTxt, var11_80)
	setActive(arg0_80.levelSliderTxt, not var11_80)

	if var11_80 then
		setText(arg0_80.needLevelTxt, i18n("buleprint_need_level_tip", var12_80))

		arg0_80.levelSlider.value = 1
	end
end

function var0_0.inModAnim(arg0_82)
	return arg0_82.inAnim
end

function var0_0.formatModLvTxt(arg0_83, arg1_83, arg2_83)
	return "<size=45>" .. arg1_83 .. "</size>/<size=27>" .. arg2_83 .. "</size>"
end

local var8_0 = 0.2

function var0_0.doModAnim(arg0_84, arg1_84, arg2_84)
	arg0_84:clearLeanTween()

	arg0_84.inAnim = true

	local var0_84 = {}
	local var1_84 = arg2_84:getMaxLevel()

	if arg1_84.level ~= var1_84 then
		local function var2_84(arg0_85, arg1_85, arg2_85)
			arg0_85 = Clone(arg0_85)
			arg0_85.level = arg1_85
			arg0_85.exp = arg2_85

			return arg0_85
		end

		arg0_84.preLevelSlider.value = 0

		for iter0_84 = arg1_84.level, arg2_84.level do
			local var3_84 = iter0_84 == arg1_84.level and arg1_84.exp / arg1_84:getNextLevelExp() or 0
			local var4_84 = iter0_84 == arg2_84.level and arg2_84.level ~= var1_84 and arg2_84.exp / arg2_84:getNextLevelExp() or 1

			table.insert(var0_84, function(arg0_86)
				TweenValue(go(arg0_84.levelSlider), var3_84, var4_84, var8_0, nil, function(arg0_87)
					arg0_84.levelSlider.value = arg0_87
				end, function()
					local var0_88 = iter0_84 == arg1_84.level and arg1_84 or var2_84(arg1_84, iter0_84, 0)
					local var1_88 = iter0_84 == arg2_84.level and arg2_84 or var2_84(arg1_84, iter0_84 + 1, 0)

					arg0_84:doAttrsAinm(var0_88, var1_88, arg0_86)

					arg0_84.modLevel.text = arg0_84:formatModLvTxt(var1_88.level, var1_84)
				end)
			end)
		end

		table.insert(arg0_84.leanTweens, arg0_84.levelSlider)
	else
		var1_84 = arg2_84:getMaxFateLevel()

		local function var5_84(arg0_89, arg1_89, arg2_89)
			arg0_89 = Clone(arg0_89)
			arg0_89.fateLevel = arg1_89
			arg0_89.exp = arg2_89

			return arg0_89
		end

		arg0_84.prePhaseSlider.value = 0

		for iter1_84 = arg1_84.fateLevel, arg2_84.fateLevel do
			local var6_84 = iter1_84 == arg1_84.fateLevel and arg1_84.exp / arg1_84:getNextFateLevelExp() or 0
			local var7_84 = iter1_84 == arg2_84.fateLevel and arg2_84.fateLevel ~= var1_84 and arg2_84.exp / arg2_84:getNextFateLevelExp() or 1

			table.insert(var0_84, function(arg0_90)
				TweenValue(go(arg0_84.phaseSlider), var6_84, var7_84, var8_0, nil, function(arg0_91)
					arg0_84.phaseSlider.value = arg0_91
				end, function()
					if iter1_84 ~= arg1_84.fateLevel or not arg1_84 then
						local var0_92 = var5_84(arg1_84, iter1_84, 0)
					end

					local var1_92 = iter1_84 == arg2_84.fateLevel and arg2_84 or var5_84(arg1_84, iter1_84 + 1, 0)

					arg0_84:updateFittingAttrPanel(var1_92)
					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.min(var1_92.fateLevel + 1, var1_92:getMaxFateLevel()), arg0_84.phasePic, true)
					arg0_90()
				end)
			end)
		end

		table.insert(arg0_84.leanTweens, arg0_84.phaseSlider)
	end

	seriesAsync(var0_84, function()
		arg0_84.noUpdateMod = false

		arg0_84:updateMod()

		arg0_84.inAnim = false
	end)
end

function var0_0.doAttrsAinm(arg0_94, arg1_94, arg2_94, arg3_94)
	local var0_94 = {}
	local var1_94 = arg0_94:getShipById(arg1_94.shipId)
	local var2_94 = intProperties(arg1_94:getShipProperties(var1_94))
	local var3_94 = intProperties(arg2_94:getShipProperties(var1_94))

	for iter0_94, iter1_94 in ipairs(ShipModAttr.BLUEPRINT_ATTRS) do
		if iter1_94 ~= AttributeType.AntiAircraft then
			local var4_94 = arg0_94.attrContainer:Find(iter1_94)
			local var5_94 = var4_94:Find("attr_bg/value"):GetComponent(typeof(Text))
			local var6_94 = var4_94:Find("slider"):GetComponent(typeof(Slider))
			local var7_94 = var4_94:Find("pre_slider"):GetComponent(typeof(Slider))
			local var8_94 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, iter1_94)
			local var9_94 = arg1_94:getExpRetio(var8_94)
			local var10_94 = var2_94[iter1_94]
			local var11_94 = var3_94[iter1_94]
			local var12_94, var13_94 = arg1_94:getBluePrintAddition(iter1_94)
			local var14_94, var15_94 = arg2_94:getBluePrintAddition(iter1_94)
			local var16_94 = var13_94 / var9_94
			local var17_94 = var15_94 / var9_94

			var7_94.value = 0

			table.insert(var0_94, function(arg0_95)
				arg0_94:doAttrAnim(var6_94, var5_94, var16_94, var17_94, math.floor(var12_94), math.floor(var14_94), var10_94, var11_94, arg0_95)
			end)
		end
	end

	parallelAsync(var0_94, arg3_94)
end

local var9_0 = 0.1

function var0_0.doAttrAnim(arg0_96, arg1_96, arg2_96, arg3_96, arg4_96, arg5_96, arg6_96, arg7_96, arg8_96, arg9_96)
	table.insert(arg0_96.leanTweens, arg1_96)

	local var0_96 = {}

	for iter0_96 = arg5_96, arg6_96 do
		local var1_96 = iter0_96 == arg5_96 and arg3_96 or 0
		local var2_96 = iter0_96 == arg6_96 and arg4_96 or 1

		table.insert(var0_96, function(arg0_97)
			TweenValue(go(arg1_96), var1_96, var2_96, var9_0, nil, function(arg0_98)
				arg1_96.value = arg0_98
			end, function()
				arg2_96.text = arg8_96 - math.min(arg6_96 - iter0_96, arg8_96 - arg7_96)

				arg0_97()
			end)
		end)
	end

	seriesAsync(var0_96, function()
		arg9_96()
	end)
end

function var0_0.clearLeanTween(arg0_101, arg1_101)
	for iter0_101, iter1_101 in pairs(arg0_101.leanTweens) do
		if LeanTween.isTweening(go(iter1_101)) then
			LeanTween.cancel(go(iter1_101))
		end
	end

	if arg0_101.inAnim then
		arg0_101.inAnim = nil

		if not arg1_101 then
			arg0_101.noUpdateMod = false
		end
	end

	arg0_101.leanTweens = {}
end

function var0_0.updateModPanel(arg0_102)
	local var0_102 = arg0_102.contextData.shipBluePrintVO
	local var1_102 = arg0_102:getShipById(var0_102.shipId)
	local var2_102 = var0_102:getConfig("strengthen_item")
	local var3_102 = arg0_102:getItemById(var2_102)
	local var4_102 = var3_102.count == 0 and var0_102:isPursuing()
	local var5_102 = 0
	local var6_102
	local var7_102

	if var4_102 then
		local var8_102 = getProxy(TechnologyProxy)

		var6_102 = math.min(var8_102:calcMaxPursuingCount(var0_102), var0_102:getUseageMaxItem())

		function var7_102(arg0_103)
			local var0_103 = arg0_103 * var0_102:getItemExp()
			local var1_103 = Clone(var0_102)

			var1_103:addExp(var0_103)
			arg0_102:updateModInfo(var1_103)
			setText(arg0_102.calcTxt, arg0_103)

			local var2_103 = var0_102:isRarityUR()
			local var3_103 = TechnologyProxy.getPursuingDiscount(var8_102:getPursuingTimes(var2_103) + var5_102 + 1, var2_103)

			setText(arg0_102.itemInfoIcon:Find("icon_bg/count"), var0_102:getPursuingPrice(var3_103))
			setActive(arg0_102.itemInfo:Find("no_cost"), var3_103 == 0)
			setActive(arg0_102.itemInfo:Find("discount"), var3_103 > 0 and var3_103 < 100)

			if var3_103 > 0 and var3_103 < 100 then
				setText(arg0_102.itemInfo:Find("discount/Text"), 100 - var3_103 .. "%OFF")
			end

			setActive(arg0_102.modBtn:Find("pursuing_cost"), var5_102 > 0)
			setText(arg0_102.modBtn:Find("pursuing_cost/Text"), var8_102:calcPursuingCost(var0_102, arg0_103))
		end

		local var9_102 = {
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		}

		updateDrop(arg0_102.itemInfoIcon, var9_102)
		onButton(arg0_102, arg0_102.itemInfoIcon, function()
			if LOCK_TECHNOLOGY_PURSUING_TIP then
				arg0_102:emit(BaseUI.ON_DROP, var9_102)
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("blueprint_catchup_by_gold_help")
				})
			end
		end, SFX_PANEL)
		setScrollText(findTF(arg0_102.itemInfo, "name/Text"), var9_102:getConfig("name"))
		setText(arg0_102.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold))
		setText(arg0_102.itemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(arg0_102.modBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(arg0_102, arg0_102.modBtn, function()
			if arg0_102:inModAnim() then
				return
			end

			if var5_102 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", var8_102:calcPursuingCost(var0_102, var5_102)),
				onYes = function()
					arg0_102:emit(ShipBluePrintMediator.ON_PURSUING, var0_102.id, var5_102)
				end
			})
		end, SFX_PANEL)
	else
		var6_102 = math.min(var3_102.count, var0_102:getUseageMaxItem())

		function var7_102(arg0_107)
			local var0_107 = arg0_107 * var0_102:getItemExp()
			local var1_107 = Clone(var0_102)

			var1_107:addExp(var0_107)
			arg0_102:updateModInfo(var1_107)
			setText(arg0_102.calcTxt, arg0_107)
		end

		updateDrop(arg0_102.itemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = var3_102.id
		})
		onButton(arg0_102, arg0_102.itemInfoIcon, function()
			ItemTipPanel.ShowItemTipbyID(var3_102.id, i18n("title_item_ways", var3_102:getConfig("name")))
		end, SFX_PANEL)
		setScrollText(findTF(arg0_102.itemInfo, "name/Text"), var3_102:getConfig("name"))
		setText(arg0_102.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. var3_102.count)
		setActive(arg0_102.itemInfo:Find("no_cost"), false)
		setActive(arg0_102.itemInfo:Find("discount"), false)
		setActive(arg0_102.modBtn:Find("pursuing_cost"), false)
		onButton(arg0_102, arg0_102.modBtn, function()
			if arg0_102:inModAnim() then
				return
			end

			if var5_102 == 0 then
				return
			end

			arg0_102:emit(ShipBluePrintMediator.ON_MOD, var0_102.id, var5_102)
		end, SFX_PANEL)
	end

	var7_102(var5_102)

	local var10_102 = 0
	local var11_102 = Clone(var0_102)
	local var12_102 = var0_102:getItemExp()

	while var11_102.level < var11_102:getMaxLevel() and var1_102.level >= var11_102:getStrengthenConfig(math.min(var11_102.level + 1, var11_102:getMaxLevel())).need_lv do
		var10_102 = var10_102 + 1

		var11_102:addExp(var12_102)
	end

	local var13_102 = math.min(var6_102, var10_102)

	pressPersistTrigger(arg0_102.calcMinusBtn, 0.5, function(arg0_110)
		if arg0_102:inModAnim() or var0_102:isMaxLevel() or var5_102 == 0 then
			arg0_110()

			return
		end

		var5_102 = var5_102 - 1

		var7_102(var5_102)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_102.calcPlusBtn, 0.5, function(arg0_111)
		if arg0_102:inModAnim() or var0_102:isMaxLevel() or var5_102 == var13_102 then
			arg0_111()

			return
		end

		var5_102 = var5_102 + 1

		var7_102(var5_102)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_102, arg0_102.calcMaxBtn, function()
		if arg0_102:inModAnim() or var0_102:isMaxLevel() or var5_102 == var13_102 then
			return
		end

		var5_102 = var13_102

		var7_102(var5_102)
	end, SFX_PANEL)
	setActive(arg0_102.calcMaxBtn, not var4_102)

	local var14_102 = var0_102:canFateSimulation()

	if var14_102 then
		onButton(arg0_102, arg0_102.fittingBtn, function()
			if arg0_102.isSwitchAnim then
				return
			end

			setActive(arg0_102.fittingBtnEffect, true)

			arg0_102.cbTimer = Timer.New(function()
				arg0_102.cbTimer = nil

				setActive(arg0_102.fittingBtnEffect, false)
				arg0_102:switchState(var7_0, true, function()
					arg0_102.isFate = true

					setActive(arg0_102.fittingPanel, arg0_102.isFate)
					setActive(arg0_102.modPanel, not arg0_102.isFate)

					if not PlayerPrefs.HasKey("first_fate") then
						triggerButton(arg0_102.helpBtn)
						PlayerPrefs.SetInt("first_fate", 1)
						PlayerPrefs.Save()
					end
				end)
			end, 0.6)

			arg0_102.cbTimer:Start()
		end, SFX_PANEL)
		arg0_102:updateFittingPanel()

		if not inGuide then
			pg.NewStoryMgr.GetInstance():Play(var0_102:getConfig("luck_story"), function(arg0_116)
				if arg0_116 then
					arg0_102:buildStartAni("fateStartWindow", function()
						triggerButton(arg0_102.fittingBtn)
					end)
				end
			end)
		end
	end

	setActive(arg0_102.calcPanel, not var14_102)
	setActive(arg0_102.fittingBtn, var14_102)
	setActive(arg0_102.fittingBtnEffect, false)
end

function var0_0.updateFittingPanel(arg0_118)
	local var0_118 = arg0_118.contextData.shipBluePrintVO
	local var1_118 = arg0_118:getShipById(var0_118.shipId)
	local var2_118 = var0_118:getConfig("strengthen_item")
	local var3_118 = arg0_118:getItemById(var2_118)
	local var4_118 = var3_118.count == 0 and var0_118:isPursuing()
	local var5_118 = 0
	local var6_118
	local var7_118

	if var4_118 then
		local var8_118 = getProxy(TechnologyProxy)

		var6_118 = math.min(var8_118:calcMaxPursuingCount(var0_118), var0_118:getFateUseageMaxItem())

		function var7_118(arg0_119)
			local var0_119 = arg0_119 * var0_118:getItemExp()
			local var1_119 = Clone(var0_118)

			var1_119:addExp(var0_119)
			arg0_118:updateFittingInfo(var1_119)
			setText(arg0_118.fittingCalcTxt, arg0_119)

			local var2_119 = var0_118:isRarityUR()
			local var3_119 = TechnologyProxy.getPursuingDiscount(var8_118:getPursuingTimes(var2_119) + var5_118 + 1, var2_119)

			setText(arg0_118.fittingItemInfoIcon:Find("icon_bg/count"), var0_118:getPursuingPrice(var3_119))
			setActive(arg0_118.fittingItemInfo:Find("no_cost"), var3_119 == 0)
			setActive(arg0_118.fittingItemInfo:Find("discount"), var3_119 > 0 and var3_119 < 100)

			if var3_119 > 0 and var3_119 < 100 then
				setText(arg0_118.fittingItemInfo:Find("discount/Text"), 100 - var3_119 .. "%OFF")
			end

			setActive(arg0_118.fittingConfirmBtn:Find("pursuing_cost"), arg0_119 > 0)
			setText(arg0_118.fittingConfirmBtn:Find("pursuing_cost/Text"), var8_118:calcPursuingCost(var0_118, arg0_119))
		end

		local var9_118 = {
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		}

		updateDrop(arg0_118.fittingItemInfoIcon, var9_118)
		onButton(arg0_118, arg0_118.fittingItemInfoIcon, function()
			if LOCK_TECHNOLOGY_PURSUING_TIP then
				arg0_118:emit(BaseUI.ON_DROP, var9_118)
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("blueprint_catchup_by_gold_help")
				})
			end
		end, SFX_PANEL)
		setScrollText(findTF(arg0_118.fittingItemInfo, "name/Text"), var9_118:getConfig("name"))
		setText(arg0_118.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold))
		setText(arg0_118.fittingItemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(arg0_118.fittingConfirmBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(arg0_118, arg0_118.fittingConfirmBtn, function()
			if arg0_118:inModAnim() then
				return
			end

			if var5_118 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", var8_118:calcPursuingCost(var0_118, var5_118)),
				onYes = function()
					arg0_118:emit(ShipBluePrintMediator.ON_PURSUING, var0_118.id, var5_118)
				end
			})
		end, SFX_PANEL)
	else
		var6_118 = math.min(var3_118.count, var0_118:getFateUseageMaxItem())

		function var7_118(arg0_123)
			local var0_123 = arg0_123 * var0_118:getItemExp()
			local var1_123 = Clone(var0_118)

			var1_123:addExp(var0_123)
			arg0_118:updateFittingInfo(var1_123)
			setText(arg0_118.fittingCalcTxt, arg0_123)
		end

		updateDrop(arg0_118.fittingItemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = var3_118.id
		})
		onButton(arg0_118, arg0_118.fittingItemInfoIcon, function()
			ItemTipPanel.ShowItemTipbyID(var3_118.id, i18n("title_item_ways", var3_118:getConfig("name")))
		end, SFX_PANEL)
		setScrollText(arg0_118.fittingItemInfo:Find("name/Text"), var3_118:getConfig("name"))
		setText(arg0_118.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. var3_118.count)
		setActive(arg0_118.fittingItemInfo:Find("no_cost"), false)
		setActive(arg0_118.fittingItemInfo:Find("discount"), false)
		setActive(arg0_118.fittingConfirmBtn:Find("pursuing_cost"), false)
		onButton(arg0_118, arg0_118.fittingConfirmBtn, function()
			if arg0_118:inModAnim() then
				return
			end

			if var5_118 == 0 then
				return
			end

			arg0_118:emit(ShipBluePrintMediator.ON_MOD, var0_118.id, var5_118)
		end, SFX_PANEL)
	end

	setText(arg0_118.fittingAttrPanel:Find("attr/name"), AttributeType.Type2Name(AttributeType.Luck))
	setText(arg0_118.fittingPanel:Find("desc/top/text/Text"), i18n("fate_phase_word"))
	onButton(arg0_118, arg0_118.fittingCancelBtn, function()
		arg0_118:switchState(var7_0, true, function()
			arg0_118.isFate = false

			setActive(arg0_118.fittingPanel, arg0_118.isFate)
			setActive(arg0_118.modPanel, not arg0_118.isFate)
		end)
	end, SFX_PANEL)

	local var10_118 = 0
	local var11_118 = Clone(var0_118)
	local var12_118 = var0_118:getItemExp()

	while var11_118.fateLevel < var11_118:getMaxFateLevel() and var1_118.level >= var11_118:getFateStrengthenConfig(math.min(var11_118.fateLevel + 1, var11_118:getMaxFateLevel())).need_lv do
		var10_118 = var10_118 + 1

		var11_118:addExp(var12_118)
	end

	local var13_118 = math.min(var6_118, var10_118)

	pressPersistTrigger(arg0_118.fittingCalcMinusBtn, 0.5, function(arg0_128)
		if arg0_118:inModAnim() or var0_118:isMaxFateLevel() or var5_118 == 0 then
			arg0_128()

			return
		end

		var5_118 = math.max(var5_118 - 1, 0)

		var7_118(var5_118)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_118.fittingCalcPlusBtn, 0.5, function(arg0_129)
		if arg0_118:inModAnim() or var0_118:isMaxFateLevel() or var5_118 == var13_118 then
			arg0_129()

			return
		end

		var5_118 = math.max(math.min(var5_118 + 1, var13_118), 0)

		var7_118(var5_118)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_118, arg0_118.fittingCalcMaxBtn, function()
		if arg0_118:inModAnim() or var0_118:isMaxFateLevel() or var5_118 == var13_118 then
			return
		end

		var5_118 = var13_118

		var7_118(var5_118)
	end, SFX_PANEL)
	setActive(arg0_118.fittingCalcMaxBtn, not var4_118)

	local var14_118 = arg0_118.fittingAttrPanel:Find("phase_panel")
	local var15_118 = var14_118:Find("phase_tpl")

	setActive(var15_118, false)

	local var16_118 = {
		0,
		-60,
		0,
		60
	}
	local var17_118 = {}

	for iter0_118 = 1, var0_118:getMaxFateLevel() do
		local var18_118 = var14_118:Find("phase_" .. iter0_118) or cloneTplTo(var15_118, var14_118, "phase_" .. iter0_118)
		local var19_118 = var0_118:getFateStrengthenConfig(iter0_118)

		assert(var19_118.special == 1 and type(var19_118.special_effect) == "table", "without fate config")

		local var20_118 = var19_118.special_effect
		local var21_118

		for iter1_118, iter2_118 in ipairs(var20_118) do
			if iter2_118[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				var21_118 = iter2_118[2][2]

				break
			end
		end

		for iter3_118, iter4_118 in ipairs({
			"off",
			"on"
		}) do
			setActive(var18_118:Find(iter4_118 .. "/icon"), not var21_118)
			setActive(var18_118:Find(iter4_118 .. "/skill"), var21_118)
			setActive(var18_118:Find(iter4_118 .. "/icon/line"), var16_118[iter0_118])
			setActive(var18_118:Find(iter4_118 .. "/skill/line"), var16_118[iter0_118])

			if var16_118[iter0_118] then
				var18_118:Find(iter4_118 .. "/icon/line").localEulerAngles = Vector3(0, 0, var16_118[iter0_118])
				var18_118:Find(iter4_118 .. "/skill/line").localEulerAngles = Vector3(0, 0, var16_118[iter0_118])

				GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", iter0_118 .. "_" .. iter4_118, var18_118:Find(iter4_118 .. "/icon/icon"), true)
			end
		end

		if var21_118 then
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_" .. var21_118, "", var18_118:Find("off/skill/icon"), true)
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_on_" .. var21_118, "", var18_118:Find("on/skill/icon"), true)

			var17_118[iter0_118] = 55
		else
			var17_118[iter0_118] = 40
		end

		onButton(arg0_118, var18_118, function()
			arg0_118:showFittingMsgPanel(iter0_118)
		end, SFX_PANEL)
	end

	local var22_118 = Vector2.zero
	local var23_118 = Vector2.zero
	local var24_118 = Vector2.zero

	for iter5_118 = 1, var0_118:getMaxFateLevel() do
		local var25_118 = var14_118:Find("phase_" .. iter5_118)

		setAnchoredPosition(var25_118, var22_118)

		var23_118.x = math.min(var23_118.x, var22_118.x)
		var23_118.y = math.min(var23_118.y, var22_118.y)
		var24_118.x = math.max(var24_118.x, var22_118.x)
		var24_118.y = math.max(var24_118.y, var22_118.y)

		if var16_118[iter5_118] then
			var22_118 = var22_118 + (var17_118[iter5_118] + var17_118[iter5_118 + 1]) * Vector2(math.cos(math.pi * var16_118[iter5_118] / 180), math.sin(math.pi * var16_118[iter5_118] / 180))
		end
	end

	setSizeDelta(var14_118, var24_118 - var23_118)
	setAnchoredPosition(var14_118, {
		y = -var24_118.y
	})
	var7_118(var5_118)
end

function var0_0.updateFittingInfo(arg0_132, arg1_132)
	local var0_132 = arg0_132:getShipById(arg1_132.shipId)
	local var1_132 = arg0_132.contextData.shipBluePrintVO

	arg0_132:updateFittingAttrPanel(var1_132, arg1_132)
	GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.max(arg1_132.fateLevel, 1), arg0_132.phasePic, true)

	local var2_132 = var1_132:getNextFateLevelExp()

	if var2_132 == -1 then
		arg0_132.phaseSlider.value = 1
	else
		arg0_132.phaseSlider.value = var1_132.exp / var2_132
	end

	local var3_132 = arg1_132:getNextFateLevelExp()

	if var3_132 == -1 then
		setText(arg0_132.phaseSliderTxt, "MAX")

		arg0_132.prePhaseSlider.value = 1
	else
		local var4_132 = math.floor(arg1_132.exp / arg1_132:getNextFateLevelExp() * 100)

		setText(arg0_132.phaseSliderTxt, tostring(var4_132) .. "%")

		arg0_132.prePhaseSlider.value = arg1_132.fateLevel > var1_132.fateLevel and 1 or arg1_132.exp / var3_132
	end

	local var5_132, var6_132 = arg1_132:isShipModMaxFateLevel(var0_132)

	setActive(arg0_132.fittingNeedMask, var5_132)

	if var5_132 then
		setText(arg0_132.fittingNeedMask:Find("limit"), i18n("buleprint_need_level_tip", var6_132))

		arg0_132.phaseSlider.value = 1
	end
end

function var0_0.updateFittingAttrPanel(arg0_133, arg1_133, arg2_133)
	setText(arg0_133.fittingAttrPanel:Find("attr/name/Text"), " + " .. defaultValue((arg2_133 or arg1_133):attrSpecialAddition()[AttributeType.Luck], 0))

	arg0_133.blinkTarget = arg0_133.blinkTarget or {
		{},
		{}
	}

	for iter0_133 = 1, arg1_133:getMaxFateLevel() do
		local var0_133 = arg0_133.fittingAttrPanel:Find("phase_panel/phase_" .. iter0_133)
		local var1_133 = var0_133:Find("off")
		local var2_133 = var0_133:Find("on")

		if arg2_133 and iter0_133 > arg1_133.fateLevel and iter0_133 <= arg2_133.fateLevel then
			setActive(var1_133, true)
			setActive(var2_133, true)

			if not table.contains(arg0_133.blinkTarget[1], var1_133) then
				table.insert(arg0_133.blinkTarget[1], var1_133)
				table.insert(arg0_133.blinkTarget[2], var2_133)
			end
		else
			local var3_133 = table.indexof(arg0_133.blinkTarget[1], var1_133)

			if var3_133 then
				table.remove(arg0_133.blinkTarget[1], var3_133)
				table.remove(arg0_133.blinkTarget[2], var3_133)
			end

			setActive(var1_133, iter0_133 > arg1_133.fateLevel)
			setActive(var2_133, iter0_133 <= arg1_133.fateLevel)

			var1_133:GetComponent(typeof(CanvasGroup)).alpha = 1
			var2_133:GetComponent(typeof(CanvasGroup)).alpha = 1
		end
	end

	if #arg0_133.blinkTarget[1] == 0 then
		LeanTween.cancel(go(arg0_133.fittingAttrPanel))
	elseif not LeanTween.isTweening(go(arg0_133.fittingAttrPanel)) then
		LeanTween.value(go(arg0_133.fittingAttrPanel), 1, 0, 0.8):setOnUpdate(System.Action_float(function(arg0_134)
			for iter0_134, iter1_134 in ipairs(arg0_133.blinkTarget[1]) do
				iter1_134:GetComponent(typeof(CanvasGroup)).alpha = arg0_134
			end

			for iter2_134, iter3_134 in ipairs(arg0_133.blinkTarget[2]) do
				iter3_134:GetComponent(typeof(CanvasGroup)).alpha = 1 - arg0_134
			end
		end)):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(0)
	end
end

function var0_0.updateModAdditionPanel(arg0_135)
	local var0_135 = arg0_135.contextData.shipBluePrintVO
	local var1_135 = var0_135:specialStrengthens()

	for iter0_135 = arg0_135.modAdditionContainer.childCount - 1, #var1_135 do
		arg0_135:cloneTplTo(arg0_135.modAdditionTpl, arg0_135.modAdditionContainer)
	end

	local var2_135 = arg0_135.modAdditionContainer.childCount

	for iter1_135 = 1, var2_135 do
		local var3_135 = iter1_135 <= #var1_135
		local var4_135 = arg0_135.modAdditionContainer:GetChild(iter1_135 - 1)

		setActive(var4_135, var3_135)

		if var3_135 then
			arg0_135:updateAdvanceTF(var0_135, var4_135, var1_135[iter1_135])
		end
	end
end

function var0_0.updateAdvanceTF(arg0_136, arg1_136, arg2_136, arg3_136)
	local var0_136 = arg1_136.level < arg3_136.level

	setActive(arg2_136:Find("mask"), var0_136)

	if var0_136 then
		setText(arg2_136:Find("mask/content/Text"), i18n("blueprint_mod_addition_lock", arg3_136.level))
	end

	local var1_136 = arg3_136.des
	local var2_136 = arg3_136.extraDes or {}
	local var3_136 = arg2_136:Find("additions")

	removeAllChildren(var3_136)

	local var4_136 = arg0_136.modAdditionPanel:Find("scroll_rect/info")

	local function var5_136(arg0_137, arg1_137)
		local var0_137 = arg1_137[2]
		local var1_137 = pg.ship_data_breakout[var0_137].pre_id
		local var2_137 = Ship.New({
			configId = var0_137
		})
		local var3_137 = Ship.New({
			configId = var1_137
		}):getStar()
		local var4_137 = var2_137:getStar()
		local var5_137 = arg0_137:Find("star_tpl")
		local var6_137 = arg0_137:Find("stars")
		local var7_137 = arg0_137:Find("pre_stars")

		removeAllChildren(var6_137)
		removeAllChildren(var7_137)

		for iter0_137 = 1, var3_137 do
			cloneTplTo(var5_137, var6_137)
		end

		for iter1_137 = 1, var4_137 do
			cloneTplTo(var5_137, var7_137)
		end
	end

	for iter0_136 = 1, #var1_136 do
		local var6_136 = cloneTplTo(var4_136, var3_136)
		local var7_136 = var6_136:Find("text_tpl")
		local var8_136 = var6_136:Find("breakout_tpl")

		setActive(var7_136, false)
		setActive(var6_136:Find("attr_tpl"), false)
		setActive(var8_136, false)
		setActive(var6_136:Find("empty_tpl"), false)

		if var1_136[iter0_136] then
			if var1_136[iter0_136][1] == ShipBluePrint.STRENGTHEN_TYPE_BREAKOUT then
				setActive(var8_136, true)
				var5_136(var8_136, var1_136[iter0_136])
			else
				setActive(var7_136, true)
				setScrollText(var7_136:Find("Text"), var1_136[iter0_136][3])
			end
		end
	end

	for iter1_136 = 1, #var2_136 do
		local var9_136 = cloneTplTo(var4_136, var3_136)
		local var10_136 = var9_136:Find("text_tpl")

		setActive(var10_136, true)
		setActive(var9_136:Find("attr_tpl"), false)
		setActive(var9_136:Find("breakout_tpl"), false)
		setActive(var9_136:Find("empty_tpl"), false)
		setScrollText(var10_136:Find("Text"), var2_136[iter1_136])
	end
end

function var0_0.updateInfo(arg0_138)
	local var0_138 = arg0_138.contextData.shipBluePrintVO
	local var1_138

	if var0_138:isFetched() then
		var1_138 = arg0_138.shipVOs[var0_138.shipId]
	end

	var1_138 = var1_138 or var0_138:getShipVO()

	local var2_138 = var1_138:getConfigTable()
	local var3_138 = var1_138:getName()

	setText(arg0_138.shipName, var3_138)
	setText(arg0_138.englishName, var2_138.english_name)
	removeAllChildren(arg0_138.stars)

	local var4_138 = var1_138:getStar()
	local var5_138 = var1_138:getMaxStar()

	for iter0_138 = 1, var5_138 do
		cloneTplTo(arg0_138.shipInfoStarTpl, arg0_138.stars, "star_" .. iter0_138)
	end

	local var6_138 = var5_138 - var4_138

	for iter1_138 = 1, var6_138 do
		local var7_138 = arg0_138.stars:GetChild(var5_138 - iter1_138)

		setActive(var7_138:Find("star_tpl"), false)
		setActive(var7_138:Find("empty_star_tpl"), true)
	end

	local var8_138 = GetSpriteFromAtlas("shiptype", var1_138:getShipType())

	if not var8_138 then
		warning("找不到船形, shipConfigId: " .. var1_138.configId)
	end

	setImageSprite(arg0_138.shipType, var8_138, true)

	local var9_138 = var0_138:isLock()

	setActive(arg0_138.finishedBtn, var0_138:isFinished())

	local var10_138 = var0_138:isDeving()

	setActive(arg0_138.progressPanel, var10_138)

	if not var10_138 then
		setActive(arg0_138.speedupBtn, false)
	end

	if var10_138 then
		arg0_138:updateTasksProgress()
	end

	local var11_138, var12_138 = var0_138:isFinishPrevTask()

	if var9_138 and not var12_138 then
		if var11_138 then
			for iter2_138, iter3_138 in ipairs(var0_138:getOpenTaskList()) do
				arg0_138:emit(ShipBluePrintMediator.ON_FINISH_TASK, iter3_138)
			end

			var12_138 = true
		else
			local var13_138 = getProxy(TaskProxy)
			local var14_138 = var0_138:getOpenTaskList()

			for iter4_138, iter5_138 in ipairs(var14_138) do
				local var15_138 = var13_138:getTaskVO(iter5_138)
				local var16_138 = iter4_138 > arg0_138.lockPanel.childCount and cloneTplTo(arg0_138.lockBtn, arg0_138.lockPanel) or arg0_138.lockPanel:GetChild(iter4_138 - 1)

				setActive(var16_138, true)

				local var17_138 = var15_138:getProgress()
				local var18_138 = var15_138:getConfig("target_num")

				setText(var16_138:Find("Text"), (var18_138 <= var17_138 and setColorStr(var17_138, COLOR_GREEN) or var17_138) .. "/" .. var18_138)
			end

			for iter6_138 = #var14_138 + 1, arg0_138.lockPanel.childCount do
				setActive(arg0_138.lockPanel:GetChild(iter6_138 - 1), false)
			end
		end
	end

	setText(arg0_138.openCondition:Find("Text"), var0_138:getConfig("unlock_word"))
	setActive(arg0_138.openCondition, var9_138)
	setActive(arg0_138.startBtn, var9_138 and var12_138)
	setActive(arg0_138.lockPanel, var9_138 and not var12_138)
end

function var0_0.updateTasksProgress(arg0_139)
	local var0_139 = arg0_139.contextData.shipBluePrintVO

	if not var0_139:isDeving() then
		return
	end

	local var1_139 = var0_139:getTaskIds()

	for iter0_139 = arg0_139.progressContainer.childCount, #var1_139 do
		cloneTplTo(arg0_139.progressTpl, arg0_139.progressContainer)
	end

	local var2_139 = arg0_139.progressContainer.childCount

	for iter1_139 = 1, var2_139 do
		local var3_139 = arg0_139.progressContainer:GetChild(iter1_139 - 1)
		local var4_139 = iter1_139 <= #var1_139

		setActive(var3_139, var4_139)

		if var4_139 then
			local var5_139 = var0_139:getTaskStateById(var1_139[iter1_139])

			setActive(findTF(var3_139, "complete"), var5_139 == ShipBluePrint.TASK_STATE_FINISHED)
			setActive(findTF(var3_139, "lock"), var5_139 == ShipBluePrint.TASK_STATE_LOCK or var5_139 == ShipBluePrint.TASK_STATE_WAIT)
			setActive(findTF(var3_139, "working"), var5_139 == ShipBluePrint.TASK_STATE_ACHIEVED or var5_139 == ShipBluePrint.TASK_STATE_OPENING or var5_139 == ShipBluePrint.TASK_STATE_START)
		end
	end

	local var6_139 = var0_139:getConfig("blueprint_version")
	local var7_139 = pg.gameset.technology_catchup_itemid.description[var6_139]

	if var7_139 then
		local var8_139 = var0_139:getTaskStateById(var1_139[1])
		local var9_139 = var0_139:getTaskStateById(var1_139[4])
		local var10_139 = var7_139[1]
		local var11_139 = getProxy(BagProxy):getItemCountById(var10_139)

		setActive(arg0_139.speedupBtn, (var8_139 == ShipBluePrint.TASK_STATE_START or var9_139 == ShipBluePrint.TASK_STATE_START) and var11_139 > 0)
	else
		setActive(arg0_139.speedupBtn, false)
	end
end

function var0_0.updatePainting(arg0_140)
	local var0_140 = arg0_140.contextData.shipBluePrintVO:getShipVO():getPainting()

	if PLATFORM_CODE == PLATFORM_CH and checkABExist("painting/" .. var0_140 .. "_blueprint") then
		var0_140 = var0_140 .. "_blueprint"
	end

	if arg0_140.lastPaintingName and arg0_140.lastPaintingName ~= var0_140 then
		retPaintingPrefab(arg0_140.painting, arg0_140.lastPaintingName)
	end

	arg0_140.lastPaintingName = var0_140

	setPaintingPrefab(arg0_140.painting, var0_140, "tuzhi")
	arg0_140:paintBreath()
end

function var0_0.updateProperty(arg0_141)
	local var0_141 = arg0_141.contextData.shipBluePrintVO
	local var1_141 = var0_141:getShipVO()

	arg0_141.propertyPanel:initProperty(var1_141.configId, PropertyPanel.TypeFlat)

	local var2_141 = var2_0[var1_141.configId].buff_list_display

	for iter0_141 = arg0_141.skillPanel.childCount, #var2_141 - 1 do
		cloneTplTo(arg0_141.skillTpl, arg0_141.skillPanel)
	end

	local var3_141 = arg0_141.skillPanel.childCount

	for iter1_141 = 1, var3_141 do
		local var4_141 = arg0_141.skillPanel:GetChild(iter1_141 - 1)
		local var5_141 = iter1_141 <= #var2_141
		local var6_141 = findTF(var4_141, "icon")

		if var5_141 then
			local var7_141 = var2_141[iter1_141]
			local var8_141 = getSkillConfig(var7_141)

			LoadImageSpriteAsync("skillicon/" .. var8_141.icon, var6_141)
			onButton(arg0_141, var4_141, function()
				arg0_141:emit(ShipBluePrintMediator.SHOW_SKILL_INFO, var8_141.id, {
					id = var8_141.id,
					level = pg.skill_data_template[var8_141.id].max_level
				}, function()
					return
				end)
			end, SFX_PANEL)
		end

		setActive(var4_141, var5_141)
	end

	setActive(arg0_141.skillArrLeft, #var2_141 > 3)
	setActive(arg0_141.skillArrRight, #var2_141 > 3)

	if #var2_141 > 3 then
		onScroll(arg0_141, arg0_141.skillRect, function(arg0_144)
			setActive(arg0_141.skillArrLeft, arg0_144.x > 0.01)
			setActive(arg0_141.skillArrRight, arg0_144.x < 0.99)
		end)
	else
		GetComponent(arg0_141.skillRect, typeof(ScrollRect)).onValueChanged:RemoveAllListeners()
	end

	setAnchoredPosition(arg0_141.skillPanel, {
		x = 0
	})

	local var9_141 = var0_141:getConfig("simulate_dungeon")

	setActive(arg0_141.simulationBtn, var9_141 ~= 0)
	onButton(arg0_141, arg0_141.simulationBtn, function()
		if var9_141 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tech_simulate_closed"))
		else
			local var0_145 = i18n("blueprint_simulation_confirm_" .. var0_141.id)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0_145,
				onYes = function()
					arg0_141:emit(ShipBluePrintMediator.SIMULATION_BATTLE, var9_141)
				end
			})
		end
	end, SFX_CONFIRM)
end

function var0_0.updateTaskList(arg0_147)
	local var0_147 = arg0_147.contextData.shipBluePrintVO
	local var1_147 = var0_147:getTaskIds()

	UIItemList.StaticAlign(arg0_147.taskContainer, arg0_147.taskTpl, #var1_147, function(arg0_148, arg1_148, arg2_148)
		arg1_148 = arg1_148 + 1

		if arg0_148 == UIItemList.EventUpdate then
			if arg0_147.taskTFs[arg1_148] then
				arg0_147.taskTFs[arg1_148]:clear()
			end

			if arg1_148 <= #var1_147 then
				if not arg0_147.taskTFs[arg1_148] then
					arg0_147.taskTFs[arg1_148] = arg0_147:createTask(arg2_148)
				end

				local var0_148 = var1_147[arg1_148]
				local var1_148 = arg0_147:getTaskById(var0_148)

				if var0_147.duration > 0 then
					var1_148.leftTime = var0_147:getTaskOpenTimeStamp(var0_148) - var0_147.duration
				end

				var1_148.taskState = var0_147:getTaskStateById(var0_148)
				var1_148.dueTime = var0_147:getTaskOpenTimeStamp(var0_148)
				var1_148.index = arg1_148

				arg0_147.taskTFs[arg1_148]:update(var1_148)
			end
		end
	end)
end

function var0_0.updatePhantomQuest(arg0_149)
	local var0_149 = arg0_149.contextData.shipBluePrintVO
	local var1_149 = var0_149:isUnlockShipPhantom()

	setActive(arg0_149.phantomPanel:Find("title/bg"), var1_149)
	setActive(arg0_149.phantomPanel:Find("title/bg_lock"), not var1_149)
	setActive(arg0_149.phantomPanel:Find("desc/content"), var1_149)
	setActive(arg0_149.phantomPanel:Find("desc/lock_mask"), not var1_149)
	setText(arg0_149.phantomPanel:Find("desc/lock_mask/Text"), i18n("tech_shadow_limit_text", getGameset("technology_shadow_unlock_lv")[1]))

	if not var1_149 then
		return
	end

	local var2_149 = var0_149:getAllPhantomQuestInfo()

	setText(arg0_149.phantomPanel:Find("title/bg/Text"), string.format("%d/%d", #underscore.filter(var2_149, function(arg0_150)
		return arg0_150.unlocked
	end), #var2_149))
	UIItemList.StaticAlign(arg0_149.rtPhantomQuestContainer, arg0_149.questTpl, #var2_149, function(arg0_151, arg1_151, arg2_151)
		arg1_151 = arg1_151 + 1

		if arg0_151 == UIItemList.EventUpdate then
			local var0_151 = var2_149[arg1_151]

			setActive(arg2_151:Find("title/bg"), var0_151.config.type ~= 5)
			setActive(arg2_151:Find("title/bg_1"), var0_151.config.type == 5)
			setActive(arg2_151:Find("title/complete"), var0_151.unlocked)
			setActive(arg2_151:Find("title/working"), not var0_151.unlocked)
			setText(arg2_151:Find("title/name"), var0_151.config.name)
			setText(arg2_151:Find("title/number"), arg1_151)
			setSlider(arg2_151:Find("title/slider"), 0, var0_151.config.target_num, var0_151.unlocked and var0_151.config.target_num or var0_151.progress)
			setActive(arg2_151:Find("title/slider/complete"), var0_151.unlocked)
			setActive(arg2_151:Find("title/tip"), not var0_151.unlocked and var0_151.progress >= var0_151.config.target_num)

			if var0_151.config.type == 5 then
				setText(arg2_151:Find("desc/info/Text"), stringInset(var0_151.config.desc, var0_151.config.target_num))
			else
				setText(arg2_151:Find("desc/info/Text"), var0_151.config.desc)
			end

			local var1_151 = string.format("%d", math.clamp(var0_151.unlocked and var0_151.config.target_num or var0_151.progress, 0, var0_151.config.target_num) * 100 / var0_151.config.target_num)

			setText(arg2_151:Find("desc/info/progress"), var1_151 .. "%")
			setText(arg2_151:Find("desc/info/progress/shadow"), var1_151 .. "%")

			local var2_151 = ShipBluePrint.getPhantomQuestCostDrop(var0_151)

			setActive(arg2_151:Find("desc/item_info/items"), var2_151)

			if var2_151 then
				updateDrop(arg2_151:Find("desc/item_info/items/item_tpl/award"), var2_151)
			end

			local var3_151 = var0_151.unlocked or var0_151.progress < var0_151.config.target_num

			setActive(arg2_151:Find("desc/commit_panel/commit_btn"), not canCommit)
			setActive(arg2_151:Find("desc/commit_panel/lock_btn"), var3_151)
			onButton(arg0_149, arg2_151:Find("desc/commit_panel/commit_btn"), function()
				local var0_152 = {}

				if var2_151 then
					table.insert(var0_152, function(arg0_153)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("tech_shadow_commit_tip", var2_151:getName() .. "x" .. var2_151.count),
							onYes = arg0_153
						})
					end)
				end

				seriesAsync(var0_152, function()
					arg0_149:emit(ShipBluePrintMediator.FINISH_PHANTOM_QUEST, var0_149.id, arg1_151)
				end)
			end, SFX_CONFIRM)
			onToggle(arg0_149, arg2_151, function(arg0_155)
				if arg0_155 then
					Canvas.ForceUpdateCanvases()

					local var0_155 = arg0_149.rtPhantomQuestContainer.parent.transform:InverseTransformPoint(arg2_151.position).y
					local var1_155 = var0_155 - arg2_151.rect.height
					local var2_155 = arg0_149.rtPhantomQuestContainer.parent.transform.rect
					local var3_155 = 0

					if var1_155 < var2_155.yMin then
						var3_155 = var2_155.yMin - var1_155
					end

					if var0_155 > var2_155.yMax then
						var3_155 = var2_155.yMax - var0_155
					end

					local var4_155 = arg0_149.rtPhantomQuestContainer.localPosition

					var4_155.y = var4_155.y + var3_155
					arg0_149.rtPhantomQuestContainer.localPosition = var4_155
				end
			end, SFX_PANEL)
		end
	end)
end

function var0_0.createTask(arg0_156, arg1_156)
	local var0_156 = {
		title = arg1_156:Find("title/name"),
		desc = arg1_156:Find("desc/info/Text"),
		timerTF = arg1_156:Find("title/timer"),
		timerTFTxt = arg1_156:Find("title/timer/Text"),
		timerOpen = arg1_156:Find("title/timer/open"),
		timerClose = arg1_156:Find("title/timer/close"),
		maskAchieved = arg1_156:Find("title/slider/complete"),
		tip = arg1_156:Find("title/tip"),
		commitBtn = arg1_156:Find("desc/commit_panel/commit_btn"),
		itemInfo = arg1_156:Find("desc/item_info")
	}

	var0_156.itemContainer = var0_156.itemInfo:Find("items")
	var0_156.itemTpl = var0_156.itemContainer:Find("item_tpl")
	var0_156.numberTF = arg1_156:Find("title/number")
	var0_156.progressTF = arg1_156:Find("title/slider")
	var0_156.progessSlider = var0_156.progressTF:GetComponent(typeof(Slider))
	var0_156.lockBtn = arg1_156:Find("desc/commit_panel/lock_btn")
	var0_156.itemCount = var0_156.itemTpl:Find("award/icon_bg/count")
	var0_156.progres = arg1_156:Find("desc/info/progress")
	var0_156.progreshadow = arg1_156:Find("desc/info/progress/shadow")
	var0_156.check = findTF(arg1_156, "title/complete")
	var0_156.lock = findTF(arg1_156, "title/lock")
	var0_156.working = findTF(arg1_156, "title/working")
	var0_156.pause = findTF(arg1_156, "title/pause")
	var0_156.pauseLock = findTF(arg1_156, "title/pause_lock")
	var0_156.view = arg0_156

	onToggle(arg0_156, arg1_156, function(arg0_157)
		setActive(var0_156.desc, arg0_157)
		setActive(var0_156.progreshadow, arg0_157)

		if arg0_157 then
			Canvas.ForceUpdateCanvases()

			local var0_157 = arg0_156.taskContainer.parent.transform:InverseTransformPoint(arg1_156.position).y
			local var1_157 = var0_157 - arg1_156.rect.height
			local var2_157 = arg0_156.taskContainer.parent.transform.rect
			local var3_157 = 0

			if var1_157 < var2_157.yMin then
				var3_157 = var2_157.yMin - var1_157
			end

			if var0_157 > var2_157.yMax then
				var3_157 = var2_157.yMax - var0_157
			end

			local var4_157 = arg0_156.taskContainer.localPosition

			var4_157.y = var4_157.y + var3_157
			arg0_156.taskContainer.localPosition = var4_157
		end
	end, SFX_PANEL)

	function var0_156.update(arg0_158, arg1_158)
		arg0_158:clearTimer()

		arg0_158.autoCommit = true
		arg0_158.isExpTask = false

		removeOnButton(arg0_158.commitBtn)
		arg0_158:updateItemInfo(arg1_158)
		arg0_158:updateView(arg1_158)
		arg0_158:updateProgress(arg1_158)
	end

	function var0_156.updateItemInfo(arg0_159, arg1_159)
		arg0_159.taskVO = arg1_159

		changeToScrollText(arg0_159.title, arg1_159:getConfig("name"))
		setText(arg0_159.desc, arg1_159:getConfig("desc") .. "\n\n")

		local var0_159
		local var1_159 = arg1_159:getConfig("target_num")
		local var2_159 = arg1_159:getConfig("sub_type")

		if var2_159 == TASK_SUB_TYPE_GIVE_ITEM then
			arg0_159.autoCommit = false
			var0_159 = tonumber(arg1_159:getConfig("target_id"))
		elseif var2_159 == TASK_SUB_TYPE_PLAYER_RES then
			arg0_159.autoCommit = false
			var0_159 = id2ItemId(tonumber(arg1_159:getConfig("target_id")))
		elseif var2_159 == TASK_SUB_TYPE_BATTLE_EXP then
			arg0_159.isExpTask = true
			var0_159 = 59000
		end

		setActive(arg0_159.itemContainer, not arg0_159.autoCommit or arg0_159.isExpTask)

		if var0_159 then
			updateDrop(arg0_159.itemTpl:Find("award"), {
				type = 2,
				id = var0_159,
				count = var1_159
			})
			setText(arg0_159.itemCount, var1_159 > 1000 and math.floor(var1_159 / 1000) .. "K" or var1_159)
		end

		setText(arg0_159.numberTF, arg1_159.index)
	end

	function var0_156.updateView(arg0_160, arg1_160)
		local var0_160 = arg1_160.taskState
		local var1_160 = false
		local var2_160 = false
		local var3_160 = false

		if var0_160 == ShipBluePrint.TASK_STATE_PAUSE and arg1_160.leftTime then
			local var4_160 = getProxy(TaskProxy):getTaskVO(arg1_160.id)

			var1_160 = var4_160 and var4_160:isFinish()
			var3_160 = arg1_160.leftTime > 0
			var2_160 = var4_160 and var4_160:isReceive()

			if arg1_160.leftTime > 0 then
				setText(var0_156.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(arg1_160.leftTime))
			end
		end

		setActive(arg0_160.pause, ShipBluePrint.TASK_STATE_PAUSE == var0_160 and not var1_160 and not var3_160 or ShipBluePrint.TASK_STATE_PAUSE == var0_160 and not var3_160 and var1_160 and not arg0_160.autoCommit)
		setActive(arg0_160.pauseLock, ShipBluePrint.TASK_STATE_PAUSE == var0_160 and not var1_160 and var3_160)
		setActive(arg0_160.lockBtn, var0_160 ~= ShipBluePrint.TASK_STATE_ACHIEVED and (var0_160 ~= ShipBluePrint.TASK_STATE_START or not not arg0_160.autoCommit))
		setActive(arg0_160.commitBtn, var0_160 == ShipBluePrint.TASK_STATE_ACHIEVED or var0_160 == ShipBluePrint.TASK_STATE_START and not arg0_160.autoCommit)
		setActive(arg0_160.progressTF, var0_160 == ShipBluePrint.TASK_STATE_ACHIEVED or var0_160 == ShipBluePrint.TASK_STATE_START or var0_160 == ShipBluePrint.TASK_STATE_FINISHED or var0_160 == ShipBluePrint.TASK_STATE_PAUSE and not var3_160)
		setActive(arg0_160.lock, var0_160 == ShipBluePrint.TASK_STATE_LOCK or var0_160 == ShipBluePrint.TASK_STATE_WAIT)
		setActive(arg0_160.working, var0_160 == ShipBluePrint.TASK_STATE_OPENING or var0_160 == ShipBluePrint.TASK_STATE_START or var0_160 == ShipBluePrint.TASK_STATE_ACHIEVED)
		setActive(arg0_160.maskAchieved, var0_160 == ShipBluePrint.TASK_STATE_FINISHED or var0_160 == ShipBluePrint.TASK_STATE_PAUSE and var2_160)
		setActive(arg0_160.timerTF, var0_160 == ShipBluePrint.TASK_STATE_WAIT or var0_160 == ShipBluePrint.TASK_STATE_PAUSE and arg1_160.leftTime and arg1_160.leftTime > 0)
		setActive(arg0_160.check, arg0_160.autoCommit and var0_160 == ShipBluePrint.TASK_STATE_ACHIEVED or var0_160 == ShipBluePrint.TASK_STATE_FINISHED or var0_160 == ShipBluePrint.TASK_STATE_PAUSE and var2_160)
		setActive(arg0_160.tip, var0_160 == ShipBluePrint.TASK_STATE_ACHIEVED)
		setActive(arg0_160.timerOpen, var0_160 == ShipBluePrint.TASK_STATE_WAIT)
		setActive(arg0_160.timerClose, var0_160 == ShipBluePrint.TASK_STATE_PAUSE and arg1_160.leftTime and arg1_160.leftTime > 0)
	end

	function var0_156.updateProgress(arg0_161, arg1_161)
		local var0_161 = arg1_161.taskState
		local var1_161 = arg1_161:getProgress() / arg1_161:getConfig("target_num")

		if var0_161 == ShipBluePrint.TASK_STATE_WAIT then
			arg0_161:addTimer(arg1_161, arg1_161.dueTime)

			var1_161 = 0
		elseif var0_161 == ShipBluePrint.TASK_STATE_OPENING then
			var1_161 = 0

			arg0_161.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, arg1_161.id)
		elseif var0_161 == ShipBluePrint.TASK_STATE_PAUSE then
			if arg1_161:isReceive() then
				var1_161 = 1
			end
		elseif var0_161 == ShipBluePrint.TASK_STATE_LOCK then
			var1_161 = 0
		elseif var0_161 == ShipBluePrint.TASK_STATE_ACHIEVED then
			onButton(arg0_161.view, arg0_161.commitBtn, function()
				arg0_161.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, arg1_161.id)
			end, SFX_PANEL)

			var1_161 = 1
		elseif var0_161 == ShipBluePrint.TASK_STATE_FINISHED then
			var1_161 = 1
		elseif var0_161 == ShipBluePrint.TASK_STATE_START and not arg0_161.autoCommit then
			onButton(arg0_161.view, arg0_161.commitBtn, function()
				arg0_161.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, arg1_161.id)
			end, SFX_PANEL)

			var1_161 = 0
		end

		if var1_161 > 0 then
			arg0_161.itemSliderLT = LeanTween.value(go(arg0_161.progressTF), 0, math.min(var1_161, 1), 0.5 * math.min(var1_161, 1)):setOnUpdate(System.Action_float(function(arg0_164)
				arg0_161.progessSlider.value = arg0_164
			end)).uniqueId
		else
			arg0_161.progessSlider.value = var1_161
		end

		local var2_161 = math.floor(var1_161 * 100)

		setText(arg0_161.progres, math.ceil(math.min(var2_161, 100)) .. "%")
		setText(arg0_161.progreshadow, math.min(var2_161, 100) .. "%")
	end

	function var0_156.addTimer(arg0_165, arg1_165, arg2_165)
		arg0_165:clearTimer()

		arg0_165.taskTimer = Timer.New(function()
			local var0_166 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_166 = arg2_165 - var0_166

			if var1_166 > 0 then
				setText(arg0_165.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(var1_166))
			else
				arg0_165:clearTimer()
				setText(arg0_165.timerTFTxt, "00:00:00")
				arg0_165.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, arg1_165.id)
			end
		end, 1, -1)

		arg0_165.taskTimer:Start()
		arg0_165.taskTimer.func()
	end

	function var0_156.clearTimer(arg0_167)
		if arg0_167.taskTimer then
			arg0_167.taskTimer:Stop()

			arg0_167.taskTimer = nil
		end
	end

	function var0_156.clear(arg0_168)
		arg0_168:clearTimer()

		if arg0_168.itemSliderLT then
			LeanTween.cancel(arg0_168.itemSliderLT)

			arg0_168.itemSliderLT = nil
		end
	end

	return var0_156
end

function var0_0.openPreView(arg0_169)
	local var0_169 = arg0_169.contextData.shipBluePrintVO

	if var0_169 then
		setActive(arg0_169.preViewer, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_169.preViewer)
		arg0_169:playLoadingAni()

		arg0_169.viewShipVO = var0_169:getShipVO()
		arg0_169.breakIds = arg0_169:getStages(arg0_169.viewShipVO)

		for iter0_169 = 1, var4_0 do
			local var1_169 = arg0_169.breakIds[iter0_169]
			local var2_169 = var3_0[var1_169]
			local var3_169 = arg0_169.stages:Find("stage" .. iter0_169)

			onToggle(arg0_169, var3_169, function(arg0_170)
				if arg0_170 then
					if PLATFORM_CODE == PLATFORM_US then
						changeToScrollText(arg0_169.breakView, var3_0[var1_169].breakout_view)
					else
						setText(arg0_169.breakView, var3_0[var1_169].breakout_view)
					end

					arg0_169:switchStage(var1_169)
				end
			end, SFX_PANEL)

			if iter0_169 == 1 then
				triggerToggle(var3_169, true)
			end
		end

		arg0_169.isShowPreview = true

		arg0_169:updateMaxLevelAttrs(var0_169)
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

function var0_0.updateMaxLevelAttrs(arg0_171, arg1_171)
	if not arg1_171:isFetched() then
		return
	end

	local var0_171 = arg0_171.shipVOs[arg1_171.shipId]
	local var1_171 = Clone(var0_171)

	var1_171.level = 125

	local var2_171 = Clone(arg1_171)

	var2_171.level = arg1_171:getMaxLevel()

	local var3_171 = intProperties(var2_171:getShipProperties(var1_171, false))

	for iter0_171, iter1_171 in ipairs(var0_0.MAX_LEVEL_ATTRS) do
		local var4_171 = arg0_171.previewAttrContainer:Find(iter1_171)

		if iter1_171 == AttributeType.ArmorType then
			setText(var4_171:Find("bg/value"), var0_171:getShipArmorName())
		else
			setText(var4_171:Find("bg/value"), var3_171[iter1_171] or 0)
		end

		setText(var4_171:Find("bg/name"), AttributeType.Type2Name(iter1_171))
	end
end

function var0_0.closePreview(arg0_172, arg1_172)
	if arg0_172.previewer then
		arg0_172.previewer:clear()

		arg0_172.previewer = nil
	end

	setActive(arg0_172.preViewer, false)
	setActive(arg0_172.rawImage, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_172.preViewer, arg0_172._tf)

	arg0_172.isShowPreview = nil
end

function var0_0.playLoadingAni(arg0_173)
	setActive(arg0_173.seaLoading, true)
end

function var0_0.stopLoadingAni(arg0_174)
	setActive(arg0_174.seaLoading, false)
end

function var0_0.showBarrage(arg0_175)
	arg0_175.previewer = WeaponPreviewer.New(arg0_175.rawImage)

	arg0_175.previewer:configUI(arg0_175.healTF)
	arg0_175.previewer:setDisplayWeapon(arg0_175:getWaponIdsById(arg0_175.breakOutId))
	arg0_175.previewer:load(40000, arg0_175.viewShipVO, arg0_175:getAllWeaponIds(), function()
		arg0_175:stopLoadingAni()
	end)
end

function var0_0.getWaponIdsById(arg0_177, arg1_177)
	return var3_0[arg1_177].weapon_ids
end

function var0_0.getAllWeaponIds(arg0_178)
	local var0_178 = {}

	for iter0_178, iter1_178 in ipairs(arg0_178.breakIds) do
		local var1_178 = Clone(var3_0[iter1_178].weapon_ids)
		local var2_178 = {
			__add = function(arg0_179, arg1_179)
				for iter0_179, iter1_179 in ipairs(arg0_179) do
					if not table.contains(arg1_179, iter1_179) then
						table.insert(arg1_179, iter1_179)
					end
				end

				return arg1_179
			end
		}

		setmetatable(var0_178, var2_178)

		var0_178 = var0_178 + var1_178
	end

	return var0_178
end

function var0_0.getStages(arg0_180, arg1_180)
	local var0_180 = {}
	local var1_180 = math.floor(arg1_180.configId / 10)

	for iter0_180 = 1, 4 do
		local var2_180 = tonumber(var1_180 .. iter0_180)

		assert(var3_0[var2_180], "必须存在配置" .. var2_180)
		table.insert(var0_180, var2_180)
	end

	return var0_180
end

function var0_0.switchStage(arg0_181, arg1_181)
	if arg0_181.breakOutId == arg1_181 then
		return
	end

	arg0_181.breakOutId = arg1_181

	if arg0_181.previewer then
		arg0_181.previewer:setDisplayWeapon(arg0_181:getWaponIdsById(arg0_181.breakOutId))
	end
end

function var0_0.clearTimers(arg0_182)
	for iter0_182, iter1_182 in pairs(arg0_182.taskTFs or {}) do
		iter1_182:clear()
	end
end

function var0_0.cloneTplTo(arg0_183, arg1_183, arg2_183)
	local var0_183 = tf(Instantiate(arg1_183))

	SetActive(var0_183, true)
	var0_183:SetParent(tf(arg2_183), false)

	return var0_183
end

function var0_0.onBackPressed(arg0_184)
	if isActive(arg0_184.msgPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_184.msgPanel, arg0_184.top)
		setActive(arg0_184.msgPanel, false)
	elseif isActive(arg0_184.unlockPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_184.unlockPanel, arg0_184.top)
		setActive(arg0_184.unlockPanel, false)
	elseif isActive(arg0_184.versionPanel) then
		triggerButton(arg0_184.versionPanel:Find("bg"))
	elseif arg0_184.isShowPreview then
		arg0_184:closePreview(true)
	elseif arg0_184.svQuickExchange:isShowing() then
		arg0_184.svQuickExchange:Hide()
	elseif arg0_184.awakenPlay or arg0_184:inModAnim() then
		-- block empty
	else
		arg0_184:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.getResource(arg0_185, arg1_185)
	local var0_185 = {
		"ui/shipblueprintui_atlas",
		"shipdesignicon/empty",
		"shiptype",
		"ui/fateStartWindow"
	}

	for iter0_185, iter1_185 in pairs(var1_0.all) do
		local var1_185 = var1_0[iter1_185]
		local var2_185 = tonumber(var1_185.id .. "0")
		local var3_185 = tonumber(var1_185.id .. "1")
		local var4_185

		if pg.ship_skin_template[var2_185] then
			var4_185 = pg.ship_skin_template[var2_185].painting
		end

		if var4_185 then
			if not table.contains(var0_185, "shipdesignicon/" .. var4_185) then
				table.insert(var0_185, "shipdesignicon/" .. var4_185)
			end

			if checkABExist("shipdesignicon/" .. var4_185 .. "_hx") and not table.contains(var0_185, "shipdesignicon/" .. var4_185 .. "_hx") then
				table.insert(var0_185, "shipdesignicon/" .. var4_185 .. "_hx")
			end

			if not table.contains(var0_185, "shipYardIcon/" .. var4_185) then
				table.insert(var0_185, "shipYardIcon/" .. var4_185)
			end
		end

		if pg.ship_data_template[var3_185] then
			local var5_185 = pg.ship_data_template[var3_185].buff_list_display

			if var5_185 then
				for iter2_185, iter3_185 in ipairs(var5_185) do
					local var6_185 = getSkillConfig(iter3_185)

					if var6_185 then
						local var7_185 = "skillicon/" .. var6_185.icon

						if not table.contains(var0_185, var7_185) then
							table.insert(var0_185, var7_185)
						end
					end
				end
			end
		end
	end

	return table.insertto(var0_185, var0_0.super.getResource(arg0_185, arg1_185))
end

function var0_0.willExit(arg0_186)
	if isActive(arg0_186.msgPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_186.msgPanel, arg0_186.top)
		setActive(arg0_186.msgPanel, false)
	end

	if isActive(arg0_186.unlockPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_186.unlockPanel, arg0_186.top)
		setActive(arg0_186.unlockPanel, false)
	end

	arg0_186:UnOverlayPanel(arg0_186.blurPanel, arg0_186._tf)
	LeanTween.cancel(go(arg0_186.fittingAttrPanel))

	if arg0_186.lastPaintingName then
		retPaintingPrefab(arg0_186.painting, arg0_186.lastPaintingName)
	end

	for iter0_186, iter1_186 in pairs(arg0_186.taskTFs or {}) do
		iter1_186:clear()
	end

	arg0_186:closePreview(true)
	arg0_186:clearLeanTween(true)

	if arg0_186.previewer then
		arg0_186.previewer:clear()

		arg0_186.previewer = nil
	end

	if arg0_186.cbTimer then
		arg0_186.cbTimer:Stop()

		arg0_186.cbTimer = nil
	end

	if arg0_186.svQuickExchange:isShowing() then
		arg0_186.svQuickExchange:Hide()
	end

	arg0_186.svQuickExchange:Destroy()
end

function var0_0.paintBreath(arg0_187)
	LeanTween.cancel(go(arg0_187.painting))
	LeanTween.moveY(rtf(arg0_187.painting), var5_0, var6_0):setLoopPingPong():setEase(LeanTweenType.easeInOutCubic):setFrom(0)
end

function var0_0.buildStartAni(arg0_188, arg1_188, arg2_188)
	if arg1_188 == "researchStartWindow" then
		arg0_188.progressPanel.localScale = Vector3(0, 1, 1)

		LeanTween.scale(arg0_188.progressPanel, Vector3(1, 1, 1), 0.2):setDelay(2)
	end

	local function var0_188()
		arg0_188.awakenAni:SetActive(true)

		arg0_188.awakenPlay = true

		local var0_189 = tf(arg0_188.awakenAni)

		pg.UIMgr.GetInstance():BlurPanel(var0_189)
		var0_189:SetAsLastSibling()
		var0_189:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_190)
			if not IsNil(arg0_188.awakenAni) then
				pg.UIMgr.GetInstance():UnOverlayPanel(var0_189, arg0_188.blurPanel)
				arg0_188.awakenAni:SetActive(false)

				arg0_188.awakenPlay = false

				if arg2_188 then
					arg2_188()
				end
			end
		end)
	end

	local var1_188 = arg0_188._tf:Find(arg1_188 .. "(Clone)")

	arg0_188.awakenAni = var1_188 and go(var1_188)

	if not arg0_188.awakenAni then
		PoolMgr.GetInstance():GetUI(arg1_188, true, function(arg0_191)
			arg0_191:SetActive(true)

			arg0_188.awakenAni = arg0_191

			var0_188()
		end)
	else
		var0_188()
	end
end

function var0_0.showFittingMsgPanel(arg0_192, arg1_192)
	pg.UIMgr.GetInstance():BlurPanel(arg0_192.msgPanel)
	setActive(arg0_192.msgPanel, true)

	local var0_192 = arg0_192.contextData.shipBluePrintVO
	local var1_192 = var0_192:getMaxFateLevel()
	local var2_192 = arg0_192.msgPanel:Find("window/content")
	local var3_192 = var2_192:Find("pre_btn")
	local var4_192 = var2_192:Find("next_btn")
	local var5_192 = var2_192:Find("attrl_panel")
	local var6_192 = var2_192:Find("skill_panel")
	local var7_192 = var2_192:Find("phase")
	local var8_192 = {
		"I",
		"II",
		"III",
		"IV",
		"V"
	}

	local function var9_192()
		setActive(var3_192, arg1_192 > 1)
		setActive(var4_192, arg1_192 < var1_192)
		setText(var7_192, "PHASE." .. var8_192[arg1_192])

		local var0_193 = var0_192:getFateStrengthenConfig(arg1_192)

		assert(var0_193.special == 1 and type(var0_193.special_effect) == "table", "without fate config")

		local var1_193 = var0_193.special_effect
		local var2_193
		local var3_193 = {}

		for iter0_193, iter1_193 in ipairs(var1_193) do
			local var4_193 = iter1_193[1]

			if var4_193 == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				var2_193 = iter1_193[2][2]
			elseif var4_193 == ShipBluePrint.STRENGTHEN_TYPE_ATTR then
				table.insert(var3_193, iter1_193[2])
			end
		end

		setActive(var5_192, #var3_193 > 0)
		setActive(var6_192, var2_193)

		if var2_193 then
			local var5_193 = getSkillConfig(var2_193)

			GetImageSpriteFromAtlasAsync("skillicon/" .. var5_193.icon, "", var6_192:Find("skill_icon"))
			setText(var6_192:Find("skill_name"), getSkillName(var2_193))

			local var6_193 = 1

			setText(var6_192:Find("skill_lv"), "Lv." .. var6_193)
			setText(var6_192:Find("help_panel/skill_intro"), getSkillDescGet(var2_193))
		end

		if #var3_193 > 0 then
			for iter2_193, iter3_193 in ipairs(var3_193) do
				local var7_193 = iter2_193 < var5_192.childCount and var5_192:GetChild(iter2_193) or cloneTplTo(var5_192:GetChild(iter2_193 - 1), var5_192)

				setText(var7_193:Find("name"), AttributeType.Type2Name(iter3_193[1]))
				setText(var7_193:Find("number"), " + " .. iter3_193[2])
			end

			for iter4_193 = #var3_193 + 1, var5_192.childCount - 1 do
				setActive(var5_192:GetChild(iter4_193), false)
			end
		end
	end

	onButton(arg0_192, var3_192, function()
		arg1_192 = arg1_192 - 1

		var9_192()
	end)
	onButton(arg0_192, var4_192, function()
		arg1_192 = arg1_192 + 1

		var9_192()
	end)
	setText(var5_192:Find("desc"), i18n("fate_attr_word"))
	var9_192()
end

function var0_0.showUnlockPanel(arg0_196)
	pg.UIMgr.GetInstance():BlurPanel(arg0_196.unlockPanel)
	setActive(arg0_196.unlockPanel, true)

	local var0_196 = arg0_196.contextData.shipBluePrintVO.id
	local var1_196 = arg0_196.contextData.shipBluePrintVO:getUnlockItem()
	local var2_196 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = var1_196
	})
	local var3_196 = arg0_196.contextData.shipBluePrintVO:getShipVO()
	local var4_196 = var3_196:getPainting()
	local var5_196 = arg0_196.unlockPanel:Find("window/content")

	GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var4_196, var4_196, var5_196:Find("Image/mask/icon"), true)
	setText(var5_196:Find("words/Text"), i18n("techpackage_item_use_1", var3_196:getName()))
	setText(var5_196:Find("words/Text_2"), i18n("techpackage_item_use_2", var2_196:getName()))
	GetImageSpriteFromAtlasAsync(var2_196:getIcon(), "", arg0_196.unlockPanel:Find("window/confirm_btn/Image/Image"))
	setText(arg0_196.unlockPanel:Find("window/confirm_btn/Image/Text"), i18n("event_ui_consume"))
	onButton(arg0_196, arg0_196.unlockPanel:Find("window/confirm_btn"), function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_196.unlockPanel, arg0_196.top)
		setActive(arg0_196.unlockPanel, false)
		arg0_196:emit(ShipBluePrintMediator.ON_ITEM_UNLOCK, var0_196, var1_196)
	end, SFX_CANCEL)
end

function var0_0.checkStory(arg0_198)
	local var0_198 = {
		nil,
		"FANGAN3"
	}

	arg0_198.storyMgr = arg0_198.storyMgr or pg.NewStoryMgr.GetInstance()

	if var0_198[arg0_198.version] and not arg0_198.storyMgr:IsPlayed(var0_198[arg0_198.version]) then
		arg0_198.storyMgr:Play(var0_198[arg0_198.version])
	end
end

function var0_0.changeEffectVisible(arg0_199, arg1_199)
	setActive(arg0_199.fittingBtn, arg1_199)
	setActive(arg0_199.initPanel, arg1_199)
end

return var0_0
