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
	arg0_10.main = arg0_10:findTF("main")
	arg0_10.centerPanel = arg0_10:findTF("center_panel", arg0_10.main)
	arg0_10.blurPanel = arg0_10:findTF("blur_panel")
	arg0_10.top = arg0_10:findTF("adapt", arg0_10.blurPanel)
	arg0_10.topPanel = arg0_10:findTF("top", arg0_10.top)
	arg0_10.topBg = arg0_10:findTF("top_bg", arg0_10.blurPanel)
	arg0_10.backBtn = arg0_10:findTF("top/back", arg0_10.top)
	arg0_10.leftPanle = arg0_10:findTF("left_panel", arg0_10.top)
	arg0_10.bottomPanel = arg0_10:findTF("bottom_panel", arg0_10.top)
	arg0_10.rightPanel = arg0_10:findTF("right_panel", arg0_10.top)
	arg0_10.shipContainer = arg0_10:findTF("ships/bg/content", arg0_10.bottomPanel)
	arg0_10.shipTpl = arg0_10:findTF("ship_tpl", arg0_10.bottomPanel)
	arg0_10.versionBtn = arg0_10:findTF("ships/bg/version/version_btn", arg0_10.bottomPanel)
	arg0_10.eyeTF = arg0_10:findTF("eye", arg0_10.leftPanle)
	arg0_10.painting = arg0_10:findTF("main/center_panel/painting")
	arg0_10.nameTF = arg0_10:findTF("name", arg0_10.centerPanel)
	arg0_10.shipName = arg0_10:findTF("name_mask/Text", arg0_10.nameTF)
	arg0_10.shipType = arg0_10:findTF("type", arg0_10.nameTF)
	arg0_10.englishName = arg0_10:findTF("english_name", arg0_10.nameTF)
	arg0_10.shipInfoStarTpl = arg0_10:findTF("star_tpl", arg0_10.nameTF)

	setActive(arg0_10.shipInfoStarTpl, false)

	arg0_10.stars = arg0_10:findTF("stars", arg0_10.nameTF)
	arg0_10.initBtn = arg0_10:findTF("property_panel/btns/init_toggle", arg0_10.leftPanle)
	arg0_10.attrBtn = arg0_10:findTF("property_panel/btns/attr_toggle", arg0_10.leftPanle)
	arg0_10.attrDisableBtn = arg0_10:findTF("property_panel/btns/attr_toggle/disable", arg0_10.leftPanle)
	arg0_10.initPanel = arg0_10:findTF("property_panel/init_panel", arg0_10.leftPanle)
	arg0_10.propertyPanel = PropertyPanel.New(arg0_10.initPanel, 32)

	setText(arg0_10:findTF("property_title1/Text", arg0_10.initPanel), i18n("blueprint_combatperformance"))
	setText(arg0_10:findTF("property_title2/Text", arg0_10.initPanel), i18n("blueprint_shipperformance"))

	arg0_10.skillRect = arg0_10:findTF("property_panel/init_panel/skills_rect", arg0_10.leftPanle)
	arg0_10.skillPanel = arg0_10:findTF("property_panel/init_panel/skills_rect/skills", arg0_10.leftPanle)
	arg0_10.skillTpl = arg0_10:findTF("skilltpl", arg0_10.skillPanel)
	arg0_10.skillArrLeft = arg0_10:findTF("property_panel/init_panel/arrow1", arg0_10.leftPanle)
	arg0_10.skillArrRight = arg0_10:findTF("property_panel/init_panel/arrow2", arg0_10.leftPanle)
	arg0_10.simulationBtn = arg0_10:findTF("property_panel/init_panel/property_title2/simulation", arg0_10.leftPanle)
	arg0_10.attrPanel = arg0_10:findTF("property_panel/attr_panel", arg0_10.leftPanle)
	arg0_10.modAdditionPanel = arg0_10:findTF("property_panel/attr_panel", arg0_10.leftPanle)
	arg0_10.modAdditionContainer = arg0_10:findTF("scroll_rect/content", arg0_10.modAdditionPanel)
	arg0_10.modAdditionTpl = arg0_10:findTF("addition_tpl", arg0_10.modAdditionContainer)
	arg0_10.preViewBtn = arg0_10:findTF("pre_view", arg0_10.attrPanel)
	arg0_10.stateInfo = arg0_10:findTF("state_info", arg0_10.centerPanel)
	arg0_10.startBtn = arg0_10:findTF("state_info/start_btn", arg0_10.centerPanel)
	arg0_10.lockPanel = arg0_10:findTF("state_info/lock_panel", arg0_10.centerPanel)
	arg0_10.lockBtn = arg0_10:findTF("lock", arg0_10.lockPanel)
	arg0_10.finishedBtn = arg0_10:findTF("state_info/finished_btn", arg0_10.centerPanel)
	arg0_10.progressPanel = arg0_10:findTF("state_info/progress", arg0_10.centerPanel)

	setText(arg0_10:findTF("label", arg0_10.progressPanel), i18n("blueprint_researching"))

	arg0_10.progressContainer = arg0_10:findTF("content", arg0_10.progressPanel)
	arg0_10.progressTpl = arg0_10:findTF("item", arg0_10.progressContainer)
	arg0_10.openCondition = arg0_10:findTF("state_info/open_condition", arg0_10.centerPanel)
	arg0_10.speedupBtn = arg0_10:findTF("main/speedup_btn")
	arg0_10.taskListPanel = arg0_10:findTF("task_list", arg0_10.rightPanel)
	arg0_10.taskContainer = arg0_10:findTF("task_list/scroll/content", arg0_10.rightPanel)
	arg0_10.taskTpl = arg0_10:findTF("task_list/task_tpl", arg0_10.rightPanel)
	arg0_10.modPanel = arg0_10:findTF("mod_panel", arg0_10.rightPanel)
	arg0_10.attrContainer = arg0_10:findTF("desc/atrrs", arg0_10.modPanel)
	arg0_10.levelSlider = arg0_10:findTF("title/slider", arg0_10.modPanel):GetComponent(typeof(Slider))
	arg0_10.levelSliderTxt = arg0_10:findTF("title/slider/Text", arg0_10.modPanel)
	arg0_10.preLevelSlider = arg0_10:findTF("title/pre_slider", arg0_10.modPanel):GetComponent(typeof(Slider))
	arg0_10.modLevel = arg0_10:findTF("title/level_bg/Text", arg0_10.modPanel):GetComponent(typeof(Text))
	arg0_10.needLevelTxt = arg0_10:findTF("title/Text", arg0_10.modPanel):GetComponent(typeof(Text))
	arg0_10.calcPanel = arg0_10.modPanel:Find("desc/calc_panel")
	arg0_10.calcMinusBtn = arg0_10.calcPanel:Find("calc/base/minus")
	arg0_10.calcPlusBtn = arg0_10.calcPanel:Find("calc/base/plus")
	arg0_10.calcTxt = arg0_10.calcPanel:Find("calc/base/count/Text")
	arg0_10.calcMaxBtn = arg0_10.calcPanel:Find("calc/max")
	arg0_10.itemInfo = arg0_10.calcPanel:Find("item_bg")
	arg0_10.itemInfoIcon = arg0_10.itemInfo:Find("icon")
	arg0_10.itemInfoCount = arg0_10.itemInfo:Find("kc")
	arg0_10.modBtn = arg0_10.calcPanel:Find("confirm_btn")
	arg0_10.fittingBtn = arg0_10:findTF("desc/fitting_btn", arg0_10.modPanel)
	arg0_10.fittingBtnEffect = arg0_10.fittingBtn:Find("anim/ShipBlue02")
	arg0_10.fittingPanel = arg0_10:findTF("fitting_panel", arg0_10.rightPanel)

	setActive(arg0_10.fittingPanel, false)

	arg0_10.fittingAttrPanel = arg0_10:findTF("desc/middle", arg0_10.fittingPanel)
	arg0_10.phasePic = arg0_10:findTF("title/phase", arg0_10.fittingPanel)
	arg0_10.phaseSlider = arg0_10:findTF("desc/top/slider", arg0_10.fittingPanel):GetComponent(typeof(Slider))
	arg0_10.phaseSliderTxt = arg0_10:findTF("desc/top/precent", arg0_10.fittingPanel)
	arg0_10.prePhaseSlider = arg0_10:findTF("desc/top/pre_slider", arg0_10.fittingPanel):GetComponent(typeof(Slider))
	arg0_10.fittingNeedMask = arg0_10:findTF("desc/top/mask", arg0_10.fittingPanel)
	arg0_10.fittingCalcPanel = arg0_10:findTF("desc/bottom", arg0_10.fittingPanel)
	arg0_10.fittingCalcMinusBtn = arg0_10:findTF("calc/base/minus", arg0_10.fittingCalcPanel)
	arg0_10.fittingCalcPlusBtn = arg0_10:findTF("calc/base/plus", arg0_10.fittingCalcPanel)
	arg0_10.fittingCalcTxt = arg0_10:findTF("calc/base/count/Text", arg0_10.fittingCalcPanel)
	arg0_10.fittingCalcMaxBtn = arg0_10:findTF("calc/max", arg0_10.fittingCalcPanel)
	arg0_10.fittingItemInfo = arg0_10:findTF("item_bg", arg0_10.fittingCalcPanel)
	arg0_10.fittingItemInfoIcon = arg0_10:findTF("icon", arg0_10.fittingItemInfo)
	arg0_10.fittingItemInfoCount = arg0_10:findTF("kc", arg0_10.fittingItemInfo)
	arg0_10.fittingConfirmBtn = arg0_10:findTF("confirm_btn", arg0_10.fittingCalcPanel)
	arg0_10.fittingCancelBtn = arg0_10:findTF("cancel_btn", arg0_10.fittingCalcPanel)
	arg0_10.msgPanel = arg0_10:findTF("msg_panel", arg0_10.blurPanel)

	setActive(arg0_10.msgPanel, false)

	arg0_10.versionPanel = arg0_10._tf:Find("version_panel")

	setActive(arg0_10.versionPanel, false)

	arg0_10.preViewer = arg0_10:findTF("preview")
	arg0_10.preViewerFrame = arg0_10:findTF("preview/frame")

	setText(arg0_10:findTF("bg/title/Image", arg0_10.preViewerFrame), i18n("word_preview"))
	setActive(arg0_10.preViewer, false)

	arg0_10.sea = arg0_10:findTF("sea", arg0_10.preViewerFrame)
	arg0_10.rawImage = arg0_10.sea:GetComponent("RawImage")

	setActive(arg0_10.rawImage, false)

	arg0_10.seaLoading = arg0_10:findTF("bg/loading", arg0_10.preViewerFrame)
	arg0_10.healTF = arg0_10:findTF("resources/heal")
	arg0_10.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0_10.healTF, false)

	arg0_10.stages = arg0_10:findTF("stageScrollRect/stages", arg0_10.preViewerFrame)
	arg0_10.breakView = arg0_10:findTF("content/Text", arg0_10.preViewerFrame)
	arg0_10.previewAttrPanel = arg0_10:findTF("preview/attrs_panel/attr_panel")
	arg0_10.previewAttrContainer = arg0_10:findTF("content", arg0_10.previewAttrPanel)

	setText(arg0_10:findTF("preview/attrs_panel/Text"), i18n("meta_energy_preview_tip"))
	setText(arg0_10:findTF("preview/attrs_panel/desc"), i18n("meta_energy_preview_title"))

	arg0_10.helpBtn = arg0_10:findTF("helpBtn", arg0_10.top)
	arg0_10.exchangeBtn = arg0_10:findTF("exchangeBtn", arg0_10.top)
	arg0_10.itemUnlockBtn = arg0_10:findTF("itemUnlockBtn", arg0_10.top)
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
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_11.blurPanel, {
		pbList = {
			arg0_11.rightPanel:Find("task_list"),
			arg0_11.rightPanel:Find("mod_panel"),
			arg0_11.leftPanle:Find("property_panel"),
			arg0_11.bottomPanel:Find("ships/bg")
		}
	})
	setText(arg0_11:findTF("window/top/bg/infomation/title", arg0_11.msgPanel), i18n("title_info"))
	onButton(arg0_11, arg0_11:findTF("window/top/btnBack", arg0_11.msgPanel), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_11.msgPanel, arg0_11.top)
		setActive(arg0_11.msgPanel, false)
	end, SFX_CANCEL)
	setText(arg0_11:findTF("window/confirm_btn/Text", arg0_11.msgPanel), i18n("text_confirm"))
	onButton(arg0_11, arg0_11:findTF("window/confirm_btn", arg0_11.msgPanel), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_11.msgPanel, arg0_11.top)
		setActive(arg0_11.msgPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11:findTF("bg", arg0_11.msgPanel), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_11.msgPanel, arg0_11.top)
		setActive(arg0_11.msgPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.unlockPanel:Find("window/top/btnBack"), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_11.unlockPanel, arg0_11.top)
		setActive(arg0_11.unlockPanel, false)
	end, SFX_CANCEL)
	setText(arg0_11.unlockPanel:Find("window/confirm_btn/Text"), i18n("text_confirm"))
	setText(arg0_11.unlockPanel:Find("window/cancel_btn/Text"), i18n("text_cancel"))
	setText(arg0_11.unlockPanel:Find("window/top/bg/infomation/title"), i18n("title_info"))
	onButton(arg0_11, arg0_11.unlockPanel:Find("window/cancel_btn"), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_11.unlockPanel, arg0_11.top)
		setActive(arg0_11.unlockPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.unlockPanel:Find("bg"), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_11.unlockPanel, arg0_11.top)
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
			pg.UIMgr.GetInstance():UnblurPanel(arg0_11.versionPanel, arg0_11._tf)
			setActive(arg0_11.versionPanel, false)
		end, SFX_CANCEL)

		local var3_11 = UIItemList.New(arg0_11.versionPanel:Find("window/content"), arg0_11.versionPanel:Find("window/content/version_1"))

		var3_11:make(function(arg0_32, arg1_32, arg2_32)
			arg1_32 = arg1_32 + 1

			if arg0_32 == UIItemList.EventUpdate then
				arg2_32.name = "version_" .. arg1_32

				GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "newVersion_" .. arg1_32, arg2_32:Find("image"))

				if arg0_11.version == arg1_32 then
					setActive(arg2_32:Find("choose"), true)
				else
					setActive(arg2_32:Find("choose"), false)
				end

				onButton(arg0_11, arg2_32, function()
					arg0_11.version = arg1_32

					arg0_11:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, arg0_11.version)

					arg0_11.contextData.shipBluePrintVO = nil

					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "version_" .. arg0_11.version, arg0_11.versionBtn)
					arg0_11:initShips()
					arg0_11:updateVersionBtnTip()
					var3_11:align(var0_11)
					pg.UIMgr.GetInstance():UnblurPanel(arg0_11.versionPanel, arg0_11._tf)
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

function var0_0.updateVersionBtnTip(arg0_34)
	local var0_34 = getProxy(TechnologyProxy)
	local var1_34 = var0_34:getConfigMaxVersion()
	local var2_34 = {}

	for iter0_34 = 1, var1_34 do
		if iter0_34 ~= arg0_34.version then
			table.insert(var2_34, iter0_34)
		end
	end

	setActive(arg0_34.versionBtn:Find("tip"), var0_34:CheckPursuingCostTip(var2_34))
end

function var0_0.updateVersionPanelBtnTip(arg0_35)
	local var0_35 = getProxy(TechnologyProxy)
	local var1_35 = var0_35:getConfigMaxVersion()

	for iter0_35 = 1, var1_35 do
		setActive(arg0_35.versionPanel:Find("window/content/version_" .. iter0_35 .. "/tip"), var0_35:CheckPursuingCostTip({
			iter0_35
		}))
	end
end

function var0_0.updateAllPursuingCostTip(arg0_36)
	arg0_36:updateVersionBtnTip()
	arg0_36:updateVersionPanelBtnTip()

	for iter0_36, iter1_36 in pairs(arg0_36.bluePrintItems) do
		iter1_36:updatePursuingTip()
	end
end

function var0_0.switchHide(arg0_37)
	local var0_37 = not arg0_37.flag

	LeanTween.cancel(arg0_37.bottomPanel)
	LeanTween.cancel(arg0_37.topPanel)
	LeanTween.cancel(arg0_37.topBg)

	if var0_37 then
		LeanTween.moveY(arg0_37.bottomPanel, 0, var7_0)
		LeanTween.moveY(arg0_37.topPanel, 0, var7_0)
		LeanTween.moveY(arg0_37.topBg, 0, var7_0)
	else
		LeanTween.moveY(arg0_37.bottomPanel, -arg0_37.bottomWidth, var7_0)
		LeanTween.moveY(arg0_37.topPanel, arg0_37.topWidth, var7_0)
		LeanTween.moveY(arg0_37.topBg, arg0_37.topWidth, var7_0)
	end

	setActive(arg0_37.nameTF, var0_37)
	setActive(arg0_37.stateInfo, var0_37)
	setActive(arg0_37.helpBtn, var0_37)
	setActive(arg0_37.exchangeBtn, var0_37)
	setImageAlpha(arg0_37.itemUnlockBtn, var0_37 and 1 or 0)
	setImageRaycastTarget(arg0_37.itemUnlockBtn, var0_37)
	setImageAlpha(arg0_37.speedupBtn, var0_37 and 1 or 0)
	setImageRaycastTarget(arg0_37.speedupBtn, var0_37)
end

function var0_0.switchState(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	local var0_38 = {}

	if arg0_38.flag then
		table.insert(var0_38, function(arg0_39)
			arg0_38.flag = false

			arg0_38:switchUI(arg1_38, {
				-arg0_38.leftPanle.rect.width - 400,
				arg0_38.rightPanel.rect.width + 400
			}, arg0_39)
		end)
	end

	table.insert(var0_38, function(arg0_40)
		existCall(arg3_38)

		return arg0_40()
	end)

	if arg2_38 then
		table.insert(var0_38, function(arg0_41)
			arg0_38.flag = true

			if arg0_38.isFate then
				arg0_38:switchUI(arg1_38, {
					-arg0_38.leftPanle.rect.width - 400,
					0,
					-arg0_38.leftPanle.rect.width / 2
				}, arg0_41)
			else
				arg0_38:switchUI(arg1_38, {
					0,
					0,
					0
				}, arg0_41)
			end
		end)
	end

	seriesAsync(var0_38, arg4_38)
end

function var0_0.switchUI(arg0_42, arg1_42, arg2_42, arg3_42)
	LeanTween.cancel(arg0_42.leftPanle)
	LeanTween.cancel(arg0_42.rightPanel)
	LeanTween.cancel(arg0_42.centerPanel)

	arg0_42.isSwitchAnim = true

	parallelAsync({
		function(arg0_43)
			LeanTween.moveX(arg0_42.leftPanle, arg2_42[1], arg1_42):setOnComplete(System.Action(arg0_43))
		end,
		function(arg0_44)
			LeanTween.moveX(arg0_42.rightPanel, arg2_42[2], arg1_42):setOnComplete(System.Action(arg0_44))
		end,
		function(arg0_45)
			if arg2_42[3] then
				LeanTween.moveX(arg0_42.centerPanel, arg2_42[3], arg1_42):setOnComplete(System.Action(arg0_45))
			else
				arg0_45()
			end
		end
	}, function()
		arg0_42.isSwitchAnim = false

		return arg3_42()
	end)
end

function var0_0.createShipItem(arg0_47, arg1_47)
	local var0_47 = {
		init = function(arg0_48)
			arg0_48._go = arg1_47
			arg0_48._tf = tf(arg1_47)
			arg0_48.icon = arg0_48._tf:Find("icon")
			arg0_48.state = arg0_48._tf:Find("state")
			arg0_48.count = arg0_48._tf:Find("count")
			arg0_48.tip = arg0_48._tf:Find("tip")
		end,
		update = function(arg0_49, arg1_49, arg2_49)
			SetCompomentEnabled(arg0_49._tf, typeof(Toggle), arg1_49.id > 0)

			arg0_49.shipBluePrintVO = arg1_49

			setActive(arg0_49.state, arg0_49.shipBluePrintVO.id > 0)
			setActive(arg0_49.count, arg0_49.shipBluePrintVO.id > 0)

			if arg0_49.shipBluePrintVO.id > 0 then
				LoadSpriteAsync("shipdesignicon/" .. arg0_49.shipBluePrintVO:getShipVO():getPainting(), function(arg0_50)
					if arg0_49.shipBluePrintVO.id > 0 and string.find(arg0_50.name, arg0_49.shipBluePrintVO:getShipVO():getPainting()) then
						setImageSprite(arg0_49.icon, arg0_50)
					end
				end)

				local var0_49 = {
					tip = false,
					pursuing = arg1_49:isPursuing(),
					fate = arg1_49:canFateSimulation()
				}

				switch(arg1_49.state, {
					[ShipBluePrint.STATE_LOCK] = function()
						var0_49.state = "lock" .. (arg1_49:getUnlockItem() and "_item" or "")
					end,
					[ShipBluePrint.STATE_DEV] = function()
						var0_49.state = "research"
					end,
					[ShipBluePrint.STATE_DEV_FINISHED] = function()
						var0_49.state = var0_49.fate and "fate" or "dev"
						var0_49.tip = true
					end,
					[ShipBluePrint.STATE_UNLOCK] = function()
						var0_49.state = var0_49.fate and "fate" or "dev"
					end
				})
				setText(arg0_49.count, arg2_49.count > 999 and "999+" or arg2_49.count)
				setActive(arg0_49.count:Find("icon"), not var0_49.pursuing)
				setActive(arg0_49.count:Find("icon_2"), var0_49.pursuing)
				setText(arg0_49.state:Find("dev/Text"), arg0_49.shipBluePrintVO.level)

				if var0_49.fate then
					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "icon_phase_" .. arg0_49.shipBluePrintVO.fateLevel, arg0_49.state:Find("fate/Image"), true)
				end

				eachChild(arg0_49.state, function(arg0_55)
					setActive(arg0_55, arg0_55.name == var0_49.state)
				end)
				setActive(arg0_49.tip, var0_49.tip)
			else
				LoadSpriteAsync("shipdesignicon/empty", function(arg0_56)
					if arg0_49.shipBluePrintVO.id < 0 then
						setImageSprite(arg0_49.icon, arg0_56)
					end
				end)
				setActive(arg0_49.tip, false)
			end
		end,
		updateSelectedStyle = function(arg0_57, arg1_57)
			local var0_57 = arg1_57 and 0 or -25

			LeanTween.cancel(arg0_57.icon)
			LeanTween.moveY(arg0_57.icon, var0_57, 0.1)
		end,
		updatePursuingTip = function(arg0_58)
			setActive(arg0_58.count:Find("icon_2/tip"), arg0_58.shipBluePrintVO.id > 0 and arg0_58.shipBluePrintVO:isPursuingCostTip())
		end
	}

	var0_47:init()
	onButton(arg0_47, var0_47.count:Find("icon_2"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("blueprint_catchup_by_gold_help")
		})
	end, SFX_PANEL)

	return var0_47
end

function var0_0.initShips(arg0_60)
	arg0_60:checkStory()
	arg0_60:filterBlueprints()

	if not arg0_60.itemList then
		arg0_60.bluePrintItems = {}
		arg0_60.itemList = UIItemList.New(arg0_60.shipContainer, arg0_60.shipContainer:Find("ship_tpl"))

		arg0_60.itemList:make(function(arg0_61, arg1_61, arg2_61)
			if arg0_61 == UIItemList.EventUpdate then
				onToggle(arg0_60, arg2_61, function(arg0_62)
					if arg0_62 then
						if arg0_60.cbTimer then
							arg0_60.cbTimer:Stop()

							arg0_60.cbTimer = nil
						end

						arg0_60:clearLeanTween()

						arg0_60.contextData.shipBluePrintVO = arg0_60.bluePrintItems[arg2_61].shipBluePrintVO

						if arg0_60.nowShipId ~= arg0_60.contextData.shipBluePrintVO.id then
							arg0_60.nowShipId = arg0_60.contextData.shipBluePrintVO.id

							arg0_60:switchState(var7_0, true, function()
								arg0_60:setSelectedBluePrint()
							end)
						else
							arg0_60:setSelectedBluePrint()
						end
					end

					arg0_60.bluePrintItems[arg2_61]:updateSelectedStyle(arg0_62)
				end, SFX_PANEL)

				arg0_60.bluePrintItems[arg2_61] = arg0_60.bluePrintItems[arg2_61] or arg0_60:createShipItem(arg2_61)

				local var0_61 = arg0_60.filterBlueprintVOs[arg1_61 + 1]

				if var0_61.id > 0 then
					local var1_61 = var0_61:getItemId()
					local var2_61 = arg0_60:getItemById(var1_61)

					arg0_60.bluePrintItems[arg2_61]:update(var0_61, var2_61)
					arg0_60.bluePrintItems[arg2_61]:updatePursuingTip()
				else
					arg0_60.bluePrintItems[arg2_61]:update(var0_61, nil)
				end

				triggerToggle(arg2_61, false)
			end
		end)
	end

	setActive(arg0_60.shipContainer, false)
	arg0_60.itemList:align(#arg0_60.filterBlueprintVOs)
	setActive(arg0_60.shipContainer, true)

	if not arg0_60.contextData.shipBluePrintVO or underscore.all(arg0_60.filterBlueprintVOs, function(arg0_64)
		return arg0_60.contextData.shipBluePrintVO.id ~= arg0_64.id
	end) then
		arg0_60.contextData.shipBluePrintVO = arg0_60.filterBlueprintVOs[1]
	end

	eachChild(arg0_60.shipContainer, function(arg0_65)
		if arg0_60.contextData.shipBluePrintVO.id == arg0_60.bluePrintItems[arg0_65].shipBluePrintVO.id then
			triggerToggle(arg0_65, true)
		end
	end)
end

function var0_0.filterBlueprints(arg0_66)
	if arg0_66.contextData.shipBluePrintVO then
		arg0_66.version = arg0_66.contextData.shipBluePrintVO:getConfig("blueprint_version")

		arg0_66:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, arg0_66.version)
	end

	arg0_66.filterBlueprintVOs = {}

	local var0_66 = 0

	for iter0_66, iter1_66 in pairs(arg0_66.bluePrintByIds) do
		if iter1_66:getConfig("blueprint_version") == arg0_66.version then
			table.insert(arg0_66.filterBlueprintVOs, iter1_66)

			var0_66 = var0_66 + 1
		end
	end

	for iter2_66 = var0_66, 5 do
		table.insert(arg0_66.filterBlueprintVOs, {
			id = -1,
			state = -1
		})
	end

	table.sort(arg0_66.filterBlueprintVOs, CompareFuncs({
		function(arg0_67)
			return -arg0_67.state
		end,
		function(arg0_68)
			return arg0_68.id
		end
	}))
end

function var0_0.setSelectedBluePrint(arg0_69)
	assert(arg0_69.contextData.shipBluePrintVO, "should exist blue print")

	local var0_69 = arg0_69.contextData.shipBluePrintVO

	arg0_69:updateInfo()
	arg0_69:updatePainting()
	arg0_69:updateProperty()

	local var1_69 = var0_69:isUnlock()

	setActive(arg0_69.taskListPanel, not var1_69)
	setActive(arg0_69.attrDisableBtn, not var1_69)

	if var1_69 then
		if not var0_69:canFateSimulation() or not pg.NewStoryMgr.GetInstance():IsPlayed(var0_69:getConfig("luck_story")) then
			arg0_69.isFate = false
		end

		arg0_69:updateMod()
		setActive(arg0_69.taskListPanel, false)
		setActive(arg0_69.attrDisableBtn, false)
	else
		arg0_69.isFate = false

		arg0_69:updateTaskList()
		triggerToggle(arg0_69.initBtn, true)
	end

	setActive(arg0_69.fittingPanel, var1_69 and arg0_69.isFate)
	setActive(arg0_69.modPanel, var1_69 and not arg0_69.isFate)
	setActive(arg0_69.itemUnlockBtn, not var1_69 and var0_69:getUnlockItem())

	if var0_69:isDeving() then
		arg0_69:emit(ShipBluePrintMediator.ON_CHECK_TAKES, var0_69.id)
	end
end

function var0_0.updateMod(arg0_70)
	if arg0_70.noUpdateMod then
		return
	end

	arg0_70:updateModPanel()
	arg0_70:updateModAdditionPanel()
end

function var0_0.updateModInfo(arg0_71, arg1_71)
	local var0_71 = arg0_71:getShipById(arg1_71.shipId)
	local var1_71 = arg0_71.contextData.shipBluePrintVO
	local var2_71 = intProperties(var1_71:getShipProperties(var0_71))
	local var3_71 = intProperties(arg1_71:getShipProperties(var0_71))
	local var4_71 = Clone(arg1_71)

	var4_71.level = var4_71:getMaxLevel()

	local var5_71 = intProperties(var4_71:getShipProperties(var0_71))

	local function var6_71(arg0_72, arg1_72, arg2_72, arg3_72)
		local var0_72 = arg0_71:findTF("attr_bg/name", arg0_72)
		local var1_72 = arg0_71:findTF("attr_bg/value", arg0_72)
		local var2_72 = arg0_71:findTF("attr_bg/max", arg0_72)
		local var3_72 = arg0_71:findTF("slider", arg0_72):GetComponent(typeof(Slider))
		local var4_72 = arg0_71:findTF("pre_slider", arg0_72):GetComponent(typeof(Slider))
		local var5_72 = arg0_71:findTF("exp", arg0_72)

		if arg1_71:isMaxLevel() then
			arg3_72 = arg2_72
		end

		setText(var2_72, arg3_72)
		setText(var0_72, AttributeType.Type2Name(arg1_72))
		setText(var1_72, arg2_72)

		local var6_72, var7_72 = var1_71:getBluePrintAddition(arg1_72)
		local var8_72 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, arg1_72)
		local var9_72 = var1_71:getExpRetio(var8_72)

		var3_72.value = var7_72 / var9_72

		local var10_72, var11_72 = arg1_71:getBluePrintAddition(arg1_72)
		local var12_72 = arg1_71:getExpRetio(var8_72)

		setText(var5_72, math.floor(var11_72) .. "/" .. var9_72)

		var4_72.value = math.floor(var10_72) > math.floor(var6_72) and 1 or var11_72 / var12_72
	end

	local var7_71 = 0

	for iter0_71, iter1_71 in pairs(var3_71) do
		if table.contains(ShipModAttr.BLUEPRINT_ATTRS, iter0_71) then
			local var8_71 = arg0_71.attrContainer:Find(iter0_71)

			var7_71 = var7_71 + 1

			var6_71(var8_71, iter0_71, iter1_71, var5_71[iter0_71] or 0)
		end
	end

	arg0_71.modLevel.text = arg0_71:formatModLvTxt(arg1_71.level, arg1_71:getMaxLevel())

	local var9_71 = var1_71:getNextLevelExp()

	if var9_71 == -1 then
		arg0_71.levelSlider.value = 1
	else
		arg0_71.levelSlider.value = var1_71.exp / var9_71
	end

	local var10_71 = arg1_71:getNextLevelExp()

	if var10_71 == -1 then
		setText(arg0_71.levelSliderTxt, "MAX")

		arg0_71.preLevelSlider.value = 1
	else
		setText(arg0_71.levelSliderTxt, arg1_71.exp .. "/" .. arg1_71:getNextLevelExp())

		arg0_71.preLevelSlider.value = arg1_71.level > var1_71.level and 1 or arg1_71.exp / var10_71
	end

	local var11_71, var12_71 = arg1_71:isShipModMaxLevel(var0_71)

	setActive(arg0_71.needLevelTxt, var11_71)
	setActive(arg0_71.levelSliderTxt, not var11_71)

	if var11_71 then
		setText(arg0_71.needLevelTxt, i18n("buleprint_need_level_tip", var12_71))

		arg0_71.levelSlider.value = 1
	end
end

function var0_0.inModAnim(arg0_73)
	return arg0_73.inAnim
end

function var0_0.formatModLvTxt(arg0_74, arg1_74, arg2_74)
	return "<size=45>" .. arg1_74 .. "</size>/<size=27>" .. arg2_74 .. "</size>"
end

local var8_0 = 0.2

function var0_0.doModAnim(arg0_75, arg1_75, arg2_75)
	arg0_75:clearLeanTween()

	arg0_75.inAnim = true

	local var0_75 = {}
	local var1_75 = arg2_75:getMaxLevel()

	if arg1_75.level ~= var1_75 then
		local function var2_75(arg0_76, arg1_76, arg2_76)
			arg0_76 = Clone(arg0_76)
			arg0_76.level = arg1_76
			arg0_76.exp = arg2_76

			return arg0_76
		end

		arg0_75.preLevelSlider.value = 0

		for iter0_75 = arg1_75.level, arg2_75.level do
			local var3_75 = iter0_75 == arg1_75.level and arg1_75.exp / arg1_75:getNextLevelExp() or 0
			local var4_75 = iter0_75 == arg2_75.level and arg2_75.level ~= var1_75 and arg2_75.exp / arg2_75:getNextLevelExp() or 1

			table.insert(var0_75, function(arg0_77)
				TweenValue(go(arg0_75.levelSlider), var3_75, var4_75, var8_0, nil, function(arg0_78)
					arg0_75.levelSlider.value = arg0_78
				end, function()
					local var0_79 = iter0_75 == arg1_75.level and arg1_75 or var2_75(arg1_75, iter0_75, 0)
					local var1_79 = iter0_75 == arg2_75.level and arg2_75 or var2_75(arg1_75, iter0_75 + 1, 0)

					arg0_75:doAttrsAinm(var0_79, var1_79, arg0_77)

					arg0_75.modLevel.text = arg0_75:formatModLvTxt(var1_79.level, var1_75)
				end)
			end)
		end

		table.insert(arg0_75.leanTweens, arg0_75.levelSlider)
	else
		var1_75 = arg2_75:getMaxFateLevel()

		local function var5_75(arg0_80, arg1_80, arg2_80)
			arg0_80 = Clone(arg0_80)
			arg0_80.fateLevel = arg1_80
			arg0_80.exp = arg2_80

			return arg0_80
		end

		arg0_75.prePhaseSlider.value = 0

		for iter1_75 = arg1_75.fateLevel, arg2_75.fateLevel do
			local var6_75 = iter1_75 == arg1_75.fateLevel and arg1_75.exp / arg1_75:getNextFateLevelExp() or 0
			local var7_75 = iter1_75 == arg2_75.fateLevel and arg2_75.fateLevel ~= var1_75 and arg2_75.exp / arg2_75:getNextFateLevelExp() or 1

			table.insert(var0_75, function(arg0_81)
				TweenValue(go(arg0_75.phaseSlider), var6_75, var7_75, var8_0, nil, function(arg0_82)
					arg0_75.phaseSlider.value = arg0_82
				end, function()
					if iter1_75 ~= arg1_75.fateLevel or not arg1_75 then
						local var0_83 = var5_75(arg1_75, iter1_75, 0)
					end

					local var1_83 = iter1_75 == arg2_75.fateLevel and arg2_75 or var5_75(arg1_75, iter1_75 + 1, 0)

					arg0_75:updateFittingAttrPanel(var1_83)
					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.min(var1_83.fateLevel + 1, var1_83:getMaxFateLevel()), arg0_75.phasePic, true)
					arg0_81()
				end)
			end)
		end

		table.insert(arg0_75.leanTweens, arg0_75.phaseSlider)
	end

	seriesAsync(var0_75, function()
		arg0_75.noUpdateMod = false

		arg0_75:updateMod()

		arg0_75.inAnim = false
	end)
end

function var0_0.doAttrsAinm(arg0_85, arg1_85, arg2_85, arg3_85)
	local var0_85 = {}
	local var1_85 = arg0_85:getShipById(arg1_85.shipId)
	local var2_85 = intProperties(arg1_85:getShipProperties(var1_85))
	local var3_85 = intProperties(arg2_85:getShipProperties(var1_85))

	for iter0_85, iter1_85 in ipairs(ShipModAttr.BLUEPRINT_ATTRS) do
		if iter1_85 ~= AttributeType.AntiAircraft then
			local var4_85 = arg0_85.attrContainer:Find(iter1_85)
			local var5_85 = arg0_85:findTF("attr_bg/value", var4_85):GetComponent(typeof(Text))
			local var6_85 = arg0_85:findTF("slider", var4_85):GetComponent(typeof(Slider))
			local var7_85 = arg0_85:findTF("pre_slider", var4_85):GetComponent(typeof(Slider))
			local var8_85 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, iter1_85)
			local var9_85 = arg1_85:getExpRetio(var8_85)
			local var10_85 = var2_85[iter1_85]
			local var11_85 = var3_85[iter1_85]
			local var12_85, var13_85 = arg1_85:getBluePrintAddition(iter1_85)
			local var14_85, var15_85 = arg2_85:getBluePrintAddition(iter1_85)
			local var16_85 = var13_85 / var9_85
			local var17_85 = var15_85 / var9_85

			var7_85.value = 0

			table.insert(var0_85, function(arg0_86)
				arg0_85:doAttrAnim(var6_85, var5_85, var16_85, var17_85, math.floor(var12_85), math.floor(var14_85), var10_85, var11_85, arg0_86)
			end)
		end
	end

	parallelAsync(var0_85, arg3_85)
end

local var9_0 = 0.1

function var0_0.doAttrAnim(arg0_87, arg1_87, arg2_87, arg3_87, arg4_87, arg5_87, arg6_87, arg7_87, arg8_87, arg9_87)
	table.insert(arg0_87.leanTweens, arg1_87)

	local var0_87 = {}

	for iter0_87 = arg5_87, arg6_87 do
		local var1_87 = iter0_87 == arg5_87 and arg3_87 or 0
		local var2_87 = iter0_87 == arg6_87 and arg4_87 or 1

		table.insert(var0_87, function(arg0_88)
			TweenValue(go(arg1_87), var1_87, var2_87, var9_0, nil, function(arg0_89)
				arg1_87.value = arg0_89
			end, function()
				arg2_87.text = arg8_87 - math.min(arg6_87 - iter0_87, arg8_87 - arg7_87)

				arg0_88()
			end)
		end)
	end

	seriesAsync(var0_87, function()
		arg9_87()
	end)
end

function var0_0.clearLeanTween(arg0_92, arg1_92)
	for iter0_92, iter1_92 in pairs(arg0_92.leanTweens) do
		if LeanTween.isTweening(go(iter1_92)) then
			LeanTween.cancel(go(iter1_92))
		end
	end

	if arg0_92.inAnim then
		arg0_92.inAnim = nil

		if not arg1_92 then
			arg0_92.noUpdateMod = false
		end
	end

	arg0_92.leanTweens = {}
end

function var0_0.updateModPanel(arg0_93)
	local var0_93 = arg0_93.contextData.shipBluePrintVO
	local var1_93 = arg0_93:getShipById(var0_93.shipId)
	local var2_93 = var0_93:getConfig("strengthen_item")
	local var3_93 = arg0_93:getItemById(var2_93)
	local var4_93 = var3_93.count == 0 and var0_93:isPursuing()
	local var5_93 = 0
	local var6_93
	local var7_93

	if var4_93 then
		local var8_93 = getProxy(TechnologyProxy)

		var6_93 = math.min(var8_93:calcMaxPursuingCount(var0_93), var0_93:getUseageMaxItem())

		function var7_93(arg0_94)
			local var0_94 = arg0_94 * var0_93:getItemExp()
			local var1_94 = Clone(var0_93)

			var1_94:addExp(var0_94)
			arg0_93:updateModInfo(var1_94)
			setText(arg0_93.calcTxt, arg0_94)

			local var2_94 = var0_93:isRarityUR()
			local var3_94 = TechnologyProxy.getPursuingDiscount(var8_93:getPursuingTimes(var2_94) + var5_93 + 1, var2_94)

			setText(arg0_93.itemInfoIcon:Find("icon_bg/count"), var0_93:getPursuingPrice(var3_94))
			setActive(arg0_93.itemInfo:Find("no_cost"), var3_94 == 0)
			setActive(arg0_93.itemInfo:Find("discount"), var3_94 > 0 and var3_94 < 100)

			if var3_94 > 0 and var3_94 < 100 then
				setText(arg0_93.itemInfo:Find("discount/Text"), 100 - var3_94 .. "%OFF")
			end

			setActive(arg0_93.modBtn:Find("pursuing_cost"), var5_93 > 0)
			setText(arg0_93.modBtn:Find("pursuing_cost/Text"), var8_93:calcPursuingCost(var0_93, arg0_94))
		end

		local var9_93 = {
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		}

		updateDrop(arg0_93.itemInfoIcon, var9_93)
		onButton(arg0_93, arg0_93.itemInfoIcon, function()
			if LOCK_TECHNOLOGY_PURSUING_TIP then
				arg0_93:emit(BaseUI.ON_DROP, var9_93)
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("blueprint_catchup_by_gold_help")
				})
			end
		end, SFX_PANEL)
		setScrollText(findTF(arg0_93.itemInfo, "name/Text"), var9_93:getConfig("name"))
		setText(arg0_93.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold))
		setText(arg0_93.itemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(arg0_93.modBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(arg0_93, arg0_93.modBtn, function()
			if arg0_93:inModAnim() then
				return
			end

			if var5_93 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", var8_93:calcPursuingCost(var0_93, var5_93)),
				onYes = function()
					arg0_93:emit(ShipBluePrintMediator.ON_PURSUING, var0_93.id, var5_93)
				end
			})
		end, SFX_PANEL)
	else
		var6_93 = math.min(var3_93.count, var0_93:getUseageMaxItem())

		function var7_93(arg0_98)
			local var0_98 = arg0_98 * var0_93:getItemExp()
			local var1_98 = Clone(var0_93)

			var1_98:addExp(var0_98)
			arg0_93:updateModInfo(var1_98)
			setText(arg0_93.calcTxt, arg0_98)
		end

		updateDrop(arg0_93.itemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = var3_93.id
		})
		onButton(arg0_93, arg0_93.itemInfoIcon, function()
			ItemTipPanel.ShowItemTipbyID(var3_93.id, i18n("title_item_ways", var3_93:getConfig("name")))
		end, SFX_PANEL)
		setScrollText(findTF(arg0_93.itemInfo, "name/Text"), var3_93:getConfig("name"))
		setText(arg0_93.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. var3_93.count)
		setActive(arg0_93.itemInfo:Find("no_cost"), false)
		setActive(arg0_93.itemInfo:Find("discount"), false)
		setActive(arg0_93.modBtn:Find("pursuing_cost"), false)
		onButton(arg0_93, arg0_93.modBtn, function()
			if arg0_93:inModAnim() then
				return
			end

			if var5_93 == 0 then
				return
			end

			arg0_93:emit(ShipBluePrintMediator.ON_MOD, var0_93.id, var5_93)
		end, SFX_PANEL)
	end

	var7_93(var5_93)

	local var10_93 = 0
	local var11_93 = Clone(var0_93)
	local var12_93 = var0_93:getItemExp()

	while var11_93.level < var11_93:getMaxLevel() and var1_93.level >= var11_93:getStrengthenConfig(math.min(var11_93.level + 1, var11_93:getMaxLevel())).need_lv do
		var10_93 = var10_93 + 1

		var11_93:addExp(var12_93)
	end

	local var13_93 = math.min(var6_93, var10_93)

	pressPersistTrigger(arg0_93.calcMinusBtn, 0.5, function(arg0_101)
		if arg0_93:inModAnim() or var0_93:isMaxLevel() or var5_93 == 0 then
			arg0_101()

			return
		end

		var5_93 = var5_93 - 1

		var7_93(var5_93)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_93.calcPlusBtn, 0.5, function(arg0_102)
		if arg0_93:inModAnim() or var0_93:isMaxLevel() or var5_93 == var13_93 then
			arg0_102()

			return
		end

		var5_93 = var5_93 + 1

		var7_93(var5_93)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_93, arg0_93.calcMaxBtn, function()
		if arg0_93:inModAnim() or var0_93:isMaxLevel() or var5_93 == var13_93 then
			return
		end

		var5_93 = var13_93

		var7_93(var5_93)
	end, SFX_PANEL)
	setActive(arg0_93.calcMaxBtn, not var4_93)

	local var14_93 = var0_93:canFateSimulation()

	if var14_93 then
		onButton(arg0_93, arg0_93.fittingBtn, function()
			if arg0_93.isSwitchAnim then
				return
			end

			setActive(arg0_93.fittingBtnEffect, true)

			arg0_93.cbTimer = Timer.New(function()
				arg0_93.cbTimer = nil

				setActive(arg0_93.fittingBtnEffect, false)
				arg0_93:switchState(var7_0, true, function()
					arg0_93.isFate = true

					setActive(arg0_93.fittingPanel, arg0_93.isFate)
					setActive(arg0_93.modPanel, not arg0_93.isFate)

					if not PlayerPrefs.HasKey("first_fate") then
						triggerButton(arg0_93.helpBtn)
						PlayerPrefs.SetInt("first_fate", 1)
						PlayerPrefs.Save()
					end
				end)
			end, 0.6)

			arg0_93.cbTimer:Start()
		end, SFX_PANEL)
		arg0_93:updateFittingPanel()
		pg.NewStoryMgr.GetInstance():Play(var0_93:getConfig("luck_story"), function(arg0_107)
			if arg0_107 then
				arg0_93:buildStartAni("fateStartWindow", function()
					triggerButton(arg0_93.fittingBtn)
				end)
			end
		end)
	end

	setActive(arg0_93.calcPanel, not var14_93)
	setActive(arg0_93.fittingBtn, var14_93)
	setActive(arg0_93.fittingBtnEffect, false)
end

function var0_0.updateFittingPanel(arg0_109)
	local var0_109 = arg0_109.contextData.shipBluePrintVO
	local var1_109 = arg0_109:getShipById(var0_109.shipId)
	local var2_109 = var0_109:getConfig("strengthen_item")
	local var3_109 = arg0_109:getItemById(var2_109)
	local var4_109 = var3_109.count == 0 and var0_109:isPursuing()
	local var5_109 = 0
	local var6_109
	local var7_109

	if var4_109 then
		local var8_109 = getProxy(TechnologyProxy)

		var6_109 = math.min(var8_109:calcMaxPursuingCount(var0_109), var0_109:getFateUseageMaxItem())

		function var7_109(arg0_110)
			local var0_110 = arg0_110 * var0_109:getItemExp()
			local var1_110 = Clone(var0_109)

			var1_110:addExp(var0_110)
			arg0_109:updateFittingInfo(var1_110)
			setText(arg0_109.fittingCalcTxt, arg0_110)

			local var2_110 = var0_109:isRarityUR()
			local var3_110 = TechnologyProxy.getPursuingDiscount(var8_109:getPursuingTimes(var2_110) + var5_109 + 1, var2_110)

			setText(arg0_109.fittingItemInfoIcon:Find("icon_bg/count"), var0_109:getPursuingPrice(var3_110))
			setActive(arg0_109.fittingItemInfo:Find("no_cost"), var3_110 == 0)
			setActive(arg0_109.fittingItemInfo:Find("discount"), var3_110 > 0 and var3_110 < 100)

			if var3_110 > 0 and var3_110 < 100 then
				setText(arg0_109.fittingItemInfo:Find("discount/Text"), 100 - var3_110 .. "%OFF")
			end

			setActive(arg0_109.fittingConfirmBtn:Find("pursuing_cost"), arg0_110 > 0)
			setText(arg0_109.fittingConfirmBtn:Find("pursuing_cost/Text"), var8_109:calcPursuingCost(var0_109, arg0_110))
		end

		local var9_109 = {
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		}

		updateDrop(arg0_109.fittingItemInfoIcon, var9_109)
		onButton(arg0_109, arg0_109.fittingItemInfoIcon, function()
			if LOCK_TECHNOLOGY_PURSUING_TIP then
				arg0_109:emit(BaseUI.ON_DROP, var9_109)
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("blueprint_catchup_by_gold_help")
				})
			end
		end, SFX_PANEL)
		setScrollText(findTF(arg0_109.fittingItemInfo, "name/Text"), var9_109:getConfig("name"))
		setText(arg0_109.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold))
		setText(arg0_109.fittingItemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(arg0_109.fittingConfirmBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(arg0_109, arg0_109.fittingConfirmBtn, function()
			if arg0_109:inModAnim() then
				return
			end

			if var5_109 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", var8_109:calcPursuingCost(var0_109, var5_109)),
				onYes = function()
					arg0_109:emit(ShipBluePrintMediator.ON_PURSUING, var0_109.id, var5_109)
				end
			})
		end, SFX_PANEL)
	else
		var6_109 = math.min(var3_109.count, var0_109:getFateUseageMaxItem())

		function var7_109(arg0_114)
			local var0_114 = arg0_114 * var0_109:getItemExp()
			local var1_114 = Clone(var0_109)

			var1_114:addExp(var0_114)
			arg0_109:updateFittingInfo(var1_114)
			setText(arg0_109.fittingCalcTxt, arg0_114)
		end

		updateDrop(arg0_109.fittingItemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = var3_109.id
		})
		onButton(arg0_109, arg0_109.fittingItemInfoIcon, function()
			ItemTipPanel.ShowItemTipbyID(var3_109.id, i18n("title_item_ways", var3_109:getConfig("name")))
		end, SFX_PANEL)
		setScrollText(arg0_109.fittingItemInfo:Find("name/Text"), var3_109:getConfig("name"))
		setText(arg0_109.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. var3_109.count)
		setActive(arg0_109.fittingItemInfo:Find("no_cost"), false)
		setActive(arg0_109.fittingItemInfo:Find("discount"), false)
		setActive(arg0_109.fittingConfirmBtn:Find("pursuing_cost"), false)
		onButton(arg0_109, arg0_109.fittingConfirmBtn, function()
			if arg0_109:inModAnim() then
				return
			end

			if var5_109 == 0 then
				return
			end

			arg0_109:emit(ShipBluePrintMediator.ON_MOD, var0_109.id, var5_109)
		end, SFX_PANEL)
	end

	setText(arg0_109.fittingAttrPanel:Find("attr/name"), AttributeType.Type2Name(AttributeType.Luck))
	setText(arg0_109.fittingPanel:Find("desc/top/text/Text"), i18n("fate_phase_word"))
	onButton(arg0_109, arg0_109.fittingCancelBtn, function()
		arg0_109:switchState(var7_0, true, function()
			arg0_109.isFate = false

			setActive(arg0_109.fittingPanel, arg0_109.isFate)
			setActive(arg0_109.modPanel, not arg0_109.isFate)
		end)
	end, SFX_PANEL)

	local var10_109 = 0
	local var11_109 = Clone(var0_109)
	local var12_109 = var0_109:getItemExp()

	while var11_109.fateLevel < var11_109:getMaxFateLevel() and var1_109.level >= var11_109:getFateStrengthenConfig(math.min(var11_109.fateLevel + 1, var11_109:getMaxFateLevel())).need_lv do
		var10_109 = var10_109 + 1

		var11_109:addExp(var12_109)
	end

	local var13_109 = math.min(var6_109, var10_109)

	pressPersistTrigger(arg0_109.fittingCalcMinusBtn, 0.5, function(arg0_119)
		if arg0_109:inModAnim() or var0_109:isMaxFateLevel() or var5_109 == 0 then
			arg0_119()

			return
		end

		var5_109 = math.max(var5_109 - 1, 0)

		var7_109(var5_109)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_109.fittingCalcPlusBtn, 0.5, function(arg0_120)
		if arg0_109:inModAnim() or var0_109:isMaxFateLevel() or var5_109 == var13_109 then
			arg0_120()

			return
		end

		var5_109 = math.max(math.min(var5_109 + 1, var13_109), 0)

		var7_109(var5_109)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_109, arg0_109.fittingCalcMaxBtn, function()
		if arg0_109:inModAnim() or var0_109:isMaxFateLevel() or var5_109 == var13_109 then
			return
		end

		var5_109 = var13_109

		var7_109(var5_109)
	end, SFX_PANEL)
	setActive(arg0_109.fittingCalcMaxBtn, not var4_109)

	local var14_109 = arg0_109.fittingAttrPanel:Find("phase_panel")
	local var15_109 = var14_109:Find("phase_tpl")

	setActive(var15_109, false)

	local var16_109 = {
		0,
		-60,
		0,
		60
	}
	local var17_109 = {}

	for iter0_109 = 1, var0_109:getMaxFateLevel() do
		local var18_109 = var14_109:Find("phase_" .. iter0_109) or cloneTplTo(var15_109, var14_109, "phase_" .. iter0_109)
		local var19_109 = var0_109:getFateStrengthenConfig(iter0_109)

		assert(var19_109.special == 1 and type(var19_109.special_effect) == "table", "without fate config")

		local var20_109 = var19_109.special_effect
		local var21_109

		for iter1_109, iter2_109 in ipairs(var20_109) do
			if iter2_109[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				var21_109 = iter2_109[2][2]

				break
			end
		end

		for iter3_109, iter4_109 in ipairs({
			"off",
			"on"
		}) do
			setActive(var18_109:Find(iter4_109 .. "/icon"), not var21_109)
			setActive(var18_109:Find(iter4_109 .. "/skill"), var21_109)
			setActive(var18_109:Find(iter4_109 .. "/icon/line"), var16_109[iter0_109])
			setActive(var18_109:Find(iter4_109 .. "/skill/line"), var16_109[iter0_109])

			if var16_109[iter0_109] then
				var18_109:Find(iter4_109 .. "/icon/line").localEulerAngles = Vector3(0, 0, var16_109[iter0_109])
				var18_109:Find(iter4_109 .. "/skill/line").localEulerAngles = Vector3(0, 0, var16_109[iter0_109])

				GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", iter0_109 .. "_" .. iter4_109, var18_109:Find(iter4_109 .. "/icon/icon"), true)
			end
		end

		if var21_109 then
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_" .. var21_109, "", var18_109:Find("off/skill/icon"), true)
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_on_" .. var21_109, "", var18_109:Find("on/skill/icon"), true)

			var17_109[iter0_109] = 55
		else
			var17_109[iter0_109] = 40
		end

		onButton(arg0_109, var18_109, function()
			arg0_109:showFittingMsgPanel(iter0_109)
		end, SFX_PANEL)
	end

	local var22_109 = Vector2.zero
	local var23_109 = Vector2.zero
	local var24_109 = Vector2.zero

	for iter5_109 = 1, var0_109:getMaxFateLevel() do
		local var25_109 = var14_109:Find("phase_" .. iter5_109)

		setAnchoredPosition(var25_109, var22_109)

		var23_109.x = math.min(var23_109.x, var22_109.x)
		var23_109.y = math.min(var23_109.y, var22_109.y)
		var24_109.x = math.max(var24_109.x, var22_109.x)
		var24_109.y = math.max(var24_109.y, var22_109.y)

		if var16_109[iter5_109] then
			var22_109 = var22_109 + (var17_109[iter5_109] + var17_109[iter5_109 + 1]) * Vector2(math.cos(math.pi * var16_109[iter5_109] / 180), math.sin(math.pi * var16_109[iter5_109] / 180))
		end
	end

	setSizeDelta(var14_109, var24_109 - var23_109)
	setAnchoredPosition(var14_109, {
		y = -var24_109.y
	})
	var7_109(var5_109)
end

function var0_0.updateFittingInfo(arg0_123, arg1_123)
	local var0_123 = arg0_123:getShipById(arg1_123.shipId)
	local var1_123 = arg0_123.contextData.shipBluePrintVO

	arg0_123:updateFittingAttrPanel(var1_123, arg1_123)
	GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.max(arg1_123.fateLevel, 1), arg0_123.phasePic, true)

	local var2_123 = var1_123:getNextFateLevelExp()

	if var2_123 == -1 then
		arg0_123.phaseSlider.value = 1
	else
		arg0_123.phaseSlider.value = var1_123.exp / var2_123
	end

	local var3_123 = arg1_123:getNextFateLevelExp()

	if var3_123 == -1 then
		setText(arg0_123.phaseSliderTxt, "MAX")

		arg0_123.prePhaseSlider.value = 1
	else
		local var4_123 = math.floor(arg1_123.exp / arg1_123:getNextFateLevelExp() * 100)

		setText(arg0_123.phaseSliderTxt, tostring(var4_123) .. "%")

		arg0_123.prePhaseSlider.value = arg1_123.fateLevel > var1_123.fateLevel and 1 or arg1_123.exp / var3_123
	end

	local var5_123, var6_123 = arg1_123:isShipModMaxFateLevel(var0_123)

	setActive(arg0_123.fittingNeedMask, var5_123)

	if var5_123 then
		setText(arg0_123:findTF("limit", arg0_123.fittingNeedMask), i18n("buleprint_need_level_tip", var6_123))

		arg0_123.phaseSlider.value = 1
	end
end

function var0_0.updateFittingAttrPanel(arg0_124, arg1_124, arg2_124)
	setText(arg0_124:findTF("attr/name/Text", arg0_124.fittingAttrPanel), " + " .. defaultValue((arg2_124 or arg1_124):attrSpecialAddition()[AttributeType.Luck], 0))

	arg0_124.blinkTarget = arg0_124.blinkTarget or {
		{},
		{}
	}

	for iter0_124 = 1, arg1_124:getMaxFateLevel() do
		local var0_124 = arg0_124:findTF("phase_panel/phase_" .. iter0_124, arg0_124.fittingAttrPanel)
		local var1_124 = arg0_124:findTF("off", var0_124)
		local var2_124 = arg0_124:findTF("on", var0_124)

		if arg2_124 and iter0_124 > arg1_124.fateLevel and iter0_124 <= arg2_124.fateLevel then
			setActive(var1_124, true)
			setActive(var2_124, true)

			if not table.contains(arg0_124.blinkTarget[1], var1_124) then
				table.insert(arg0_124.blinkTarget[1], var1_124)
				table.insert(arg0_124.blinkTarget[2], var2_124)
			end
		else
			local var3_124 = table.indexof(arg0_124.blinkTarget[1], var1_124)

			if var3_124 then
				table.remove(arg0_124.blinkTarget[1], var3_124)
				table.remove(arg0_124.blinkTarget[2], var3_124)
			end

			setActive(var1_124, iter0_124 > arg1_124.fateLevel)
			setActive(var2_124, iter0_124 <= arg1_124.fateLevel)

			var1_124:GetComponent(typeof(CanvasGroup)).alpha = 1
			var2_124:GetComponent(typeof(CanvasGroup)).alpha = 1
		end
	end

	if #arg0_124.blinkTarget[1] == 0 then
		LeanTween.cancel(go(arg0_124.fittingAttrPanel))
	elseif not LeanTween.isTweening(go(arg0_124.fittingAttrPanel)) then
		LeanTween.value(go(arg0_124.fittingAttrPanel), 1, 0, 0.8):setOnUpdate(System.Action_float(function(arg0_125)
			for iter0_125, iter1_125 in ipairs(arg0_124.blinkTarget[1]) do
				iter1_125:GetComponent(typeof(CanvasGroup)).alpha = arg0_125
			end

			for iter2_125, iter3_125 in ipairs(arg0_124.blinkTarget[2]) do
				iter3_125:GetComponent(typeof(CanvasGroup)).alpha = 1 - arg0_125
			end
		end)):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(0)
	end
end

function var0_0.updateModAdditionPanel(arg0_126)
	local var0_126 = arg0_126.contextData.shipBluePrintVO
	local var1_126 = var0_126:specialStrengthens()

	for iter0_126 = arg0_126.modAdditionContainer.childCount - 1, #var1_126 do
		arg0_126:cloneTplTo(arg0_126.modAdditionTpl, arg0_126.modAdditionContainer)
	end

	local var2_126 = arg0_126.modAdditionContainer.childCount

	for iter1_126 = 1, var2_126 do
		local var3_126 = iter1_126 <= #var1_126
		local var4_126 = arg0_126.modAdditionContainer:GetChild(iter1_126 - 1)

		setActive(var4_126, var3_126)

		if var3_126 then
			arg0_126:updateAdvanceTF(var0_126, var4_126, var1_126[iter1_126])
		end
	end
end

function var0_0.updateAdvanceTF(arg0_127, arg1_127, arg2_127, arg3_127)
	local var0_127 = arg1_127.level < arg3_127.level

	setActive(arg2_127:Find("mask"), var0_127)

	if var0_127 then
		setText(arg2_127:Find("mask/content/Text"), i18n("blueprint_mod_addition_lock", arg3_127.level))
	end

	local var1_127 = arg3_127.des
	local var2_127 = arg3_127.extraDes or {}
	local var3_127 = arg2_127:Find("additions")

	removeAllChildren(var3_127)

	local var4_127 = arg0_127:findTF("scroll_rect/info", arg0_127.modAdditionPanel)

	local function var5_127(arg0_128, arg1_128)
		local var0_128 = arg1_128[2]
		local var1_128 = pg.ship_data_breakout[var0_128].pre_id
		local var2_128 = Ship.New({
			configId = var0_128
		})
		local var3_128 = Ship.New({
			configId = var1_128
		}):getStar()
		local var4_128 = var2_128:getStar()
		local var5_128 = arg0_128:Find("star_tpl")
		local var6_128 = arg0_128:Find("stars")
		local var7_128 = arg0_128:Find("pre_stars")

		removeAllChildren(var6_128)
		removeAllChildren(var7_128)

		for iter0_128 = 1, var3_128 do
			cloneTplTo(var5_128, var6_128)
		end

		for iter1_128 = 1, var4_128 do
			cloneTplTo(var5_128, var7_128)
		end
	end

	for iter0_127 = 1, #var1_127 do
		local var6_127 = cloneTplTo(var4_127, var3_127)
		local var7_127 = var6_127:Find("text_tpl")
		local var8_127 = var6_127:Find("breakout_tpl")

		setActive(var7_127, false)
		setActive(var6_127:Find("attr_tpl"), false)
		setActive(var8_127, false)
		setActive(var6_127:Find("empty_tpl"), false)

		if var1_127[iter0_127] then
			if var1_127[iter0_127][1] == ShipBluePrint.STRENGTHEN_TYPE_BREAKOUT then
				setActive(var8_127, true)
				var5_127(var8_127, var1_127[iter0_127])
			else
				setActive(var7_127, true)
				setScrollText(var7_127:Find("Text"), var1_127[iter0_127][3])
			end
		end
	end

	for iter1_127 = 1, #var2_127 do
		local var9_127 = cloneTplTo(var4_127, var3_127)
		local var10_127 = var9_127:Find("text_tpl")

		setActive(var10_127, true)
		setActive(var9_127:Find("attr_tpl"), false)
		setActive(var9_127:Find("breakout_tpl"), false)
		setActive(var9_127:Find("empty_tpl"), false)
		setScrollText(var10_127:Find("Text"), var2_127[iter1_127])
	end
end

function var0_0.updateInfo(arg0_129)
	local var0_129 = arg0_129.contextData.shipBluePrintVO
	local var1_129

	if var0_129:isFetched() then
		var1_129 = arg0_129.shipVOs[var0_129.shipId]
	end

	var1_129 = var1_129 or var0_129:getShipVO()

	local var2_129 = var1_129:getConfigTable()
	local var3_129 = var1_129:getName()

	setText(arg0_129.shipName, var3_129)
	setText(arg0_129.englishName, var2_129.english_name)
	removeAllChildren(arg0_129.stars)

	local var4_129 = var1_129:getStar()
	local var5_129 = var1_129:getMaxStar()

	for iter0_129 = 1, var5_129 do
		cloneTplTo(arg0_129.shipInfoStarTpl, arg0_129.stars, "star_" .. iter0_129)
	end

	local var6_129 = var5_129 - var4_129

	for iter1_129 = 1, var6_129 do
		local var7_129 = arg0_129.stars:GetChild(var5_129 - iter1_129)

		setActive(var7_129:Find("star_tpl"), false)
		setActive(var7_129:Find("empty_star_tpl"), true)
	end

	local var8_129 = GetSpriteFromAtlas("shiptype", var1_129:getShipType())

	if not var8_129 then
		warning("找不到船形, shipConfigId: " .. var1_129.configId)
	end

	setImageSprite(arg0_129.shipType, var8_129, true)

	local var9_129 = var0_129:isLock()

	setActive(arg0_129.finishedBtn, var0_129:isFinished())

	local var10_129 = var0_129:isDeving()

	setActive(arg0_129.progressPanel, var10_129)

	if not var10_129 then
		setActive(arg0_129.speedupBtn, false)
	end

	if var10_129 then
		arg0_129:updateTasksProgress()
	end

	local var11_129, var12_129 = var0_129:isFinishPrevTask()

	if var9_129 and not var12_129 then
		if var11_129 then
			for iter2_129, iter3_129 in ipairs(var0_129:getOpenTaskList()) do
				arg0_129:emit(ShipBluePrintMediator.ON_FINISH_TASK, iter3_129)
			end

			var12_129 = true
		else
			local var13_129 = getProxy(TaskProxy)
			local var14_129 = var0_129:getOpenTaskList()

			for iter4_129, iter5_129 in ipairs(var14_129) do
				local var15_129 = var13_129:getTaskVO(iter5_129)
				local var16_129 = iter4_129 > arg0_129.lockPanel.childCount and cloneTplTo(arg0_129.lockBtn, arg0_129.lockPanel) or arg0_129.lockPanel:GetChild(iter4_129 - 1)

				setActive(var16_129, true)

				local var17_129 = var15_129:getProgress()
				local var18_129 = var15_129:getConfig("target_num")

				setText(arg0_129:findTF("Text", var16_129), (var18_129 <= var17_129 and setColorStr(var17_129, COLOR_GREEN) or var17_129) .. "/" .. var18_129)
			end

			for iter6_129 = #var14_129 + 1, arg0_129.lockPanel.childCount do
				setActive(arg0_129.lockPanel:GetChild(iter6_129 - 1), false)
			end
		end
	end

	setText(arg0_129:findTF("Text", arg0_129.openCondition), var0_129:getConfig("unlock_word"))
	setActive(arg0_129.openCondition, var9_129)
	setActive(arg0_129.startBtn, var9_129 and var12_129)
	setActive(arg0_129.lockPanel, var9_129 and not var12_129)
end

function var0_0.updateTasksProgress(arg0_130)
	local var0_130 = arg0_130.contextData.shipBluePrintVO
	local var1_130 = var0_130:getTaskIds()

	for iter0_130 = arg0_130.progressContainer.childCount, #var1_130 do
		cloneTplTo(arg0_130.progressTpl, arg0_130.progressContainer)
	end

	local var2_130 = arg0_130.progressContainer.childCount

	for iter1_130 = 1, var2_130 do
		local var3_130 = arg0_130.progressContainer:GetChild(iter1_130 - 1)
		local var4_130 = iter1_130 <= #var1_130

		setActive(var3_130, var4_130)

		if var4_130 then
			local var5_130 = var0_130:getTaskStateById(var1_130[iter1_130])

			setActive(findTF(var3_130, "complete"), var5_130 == ShipBluePrint.TASK_STATE_FINISHED)
			setActive(findTF(var3_130, "lock"), var5_130 == ShipBluePrint.TASK_STATE_LOCK or var5_130 == ShipBluePrint.TASK_STATE_WAIT)
			setActive(findTF(var3_130, "working"), var5_130 == ShipBluePrint.TASK_STATE_ACHIEVED or var5_130 == ShipBluePrint.TASK_STATE_OPENING or var5_130 == ShipBluePrint.TASK_STATE_START)
		end
	end

	local var6_130 = var0_130:getConfig("blueprint_version")
	local var7_130 = pg.gameset.technology_catchup_itemid.description[var6_130]

	if var7_130 then
		local var8_130 = var0_130:getTaskStateById(var1_130[1])
		local var9_130 = var0_130:getTaskStateById(var1_130[4])
		local var10_130 = var7_130[1]
		local var11_130 = getProxy(BagProxy):getItemCountById(var10_130)

		setActive(arg0_130.speedupBtn, (var8_130 == ShipBluePrint.TASK_STATE_START or var9_130 == ShipBluePrint.TASK_STATE_START) and var11_130 > 0)
	else
		setActive(arg0_130.speedupBtn, false)
	end
end

function var0_0.updatePainting(arg0_131)
	local var0_131 = arg0_131.contextData.shipBluePrintVO:getShipVO():getPainting()

	if PLATFORM_CODE == PLATFORM_CH and checkABExist("painting/" .. var0_131 .. "_blueprint") then
		var0_131 = var0_131 .. "_blueprint"
	end

	if arg0_131.lastPaintingName and arg0_131.lastPaintingName ~= var0_131 then
		retPaintingPrefab(arg0_131.painting, arg0_131.lastPaintingName)
	end

	arg0_131.lastPaintingName = var0_131

	setPaintingPrefab(arg0_131.painting, var0_131, "tuzhi")
	arg0_131:paintBreath()
end

function var0_0.updateProperty(arg0_132)
	local var0_132 = arg0_132.contextData.shipBluePrintVO
	local var1_132 = var0_132:getShipVO()

	arg0_132.propertyPanel:initProperty(var1_132.configId, PropertyPanel.TypeFlat)

	local var2_132 = var2_0[var1_132.configId].buff_list_display

	for iter0_132 = arg0_132.skillPanel.childCount, #var2_132 - 1 do
		cloneTplTo(arg0_132.skillTpl, arg0_132.skillPanel)
	end

	local var3_132 = arg0_132.skillPanel.childCount

	for iter1_132 = 1, var3_132 do
		local var4_132 = arg0_132.skillPanel:GetChild(iter1_132 - 1)
		local var5_132 = iter1_132 <= #var2_132
		local var6_132 = findTF(var4_132, "icon")

		if var5_132 then
			local var7_132 = var2_132[iter1_132]
			local var8_132 = getSkillConfig(var7_132)

			LoadImageSpriteAsync("skillicon/" .. var8_132.icon, var6_132)
			onButton(arg0_132, var4_132, function()
				arg0_132:emit(ShipBluePrintMediator.SHOW_SKILL_INFO, var8_132.id, {
					id = var8_132.id,
					level = pg.skill_data_template[var8_132.id].max_level
				}, function()
					return
				end)
			end, SFX_PANEL)
		end

		setActive(var4_132, var5_132)
	end

	setActive(arg0_132.skillArrLeft, #var2_132 > 3)
	setActive(arg0_132.skillArrRight, #var2_132 > 3)

	if #var2_132 > 3 then
		onScroll(arg0_132, arg0_132.skillRect, function(arg0_135)
			setActive(arg0_132.skillArrLeft, arg0_135.x > 0.01)
			setActive(arg0_132.skillArrRight, arg0_135.x < 0.99)
		end)
	else
		GetComponent(arg0_132.skillRect, typeof(ScrollRect)).onValueChanged:RemoveAllListeners()
	end

	setAnchoredPosition(arg0_132.skillPanel, {
		x = 0
	})

	local var9_132 = var0_132:getConfig("simulate_dungeon")

	setActive(arg0_132.simulationBtn, var9_132 ~= 0)
	onButton(arg0_132, arg0_132.simulationBtn, function()
		if var9_132 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tech_simulate_closed"))
		else
			local var0_136 = i18n("blueprint_simulation_confirm_" .. var0_132.id)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0_136,
				onYes = function()
					arg0_132:emit(ShipBluePrintMediator.SIMULATION_BATTLE, var9_132)
				end
			})
		end
	end, SFX_CONFIRM)
end

function var0_0.updateTaskList(arg0_138)
	local var0_138 = arg0_138.contextData.shipBluePrintVO
	local var1_138 = var0_138:getTaskIds()

	for iter0_138 = arg0_138.taskContainer.childCount, #var1_138 do
		cloneTplTo(arg0_138.taskTpl, arg0_138.taskContainer)
	end

	local var2_138 = arg0_138.taskContainer.childCount

	for iter1_138 = 1, var2_138 do
		local var3_138 = arg0_138.taskContainer:GetChild(iter1_138 - 1)

		setActive(var3_138, iter1_138 <= #var1_138)

		if arg0_138.taskTFs[iter1_138] then
			arg0_138.taskTFs[iter1_138]:clear()
		end

		if iter1_138 <= #var1_138 then
			if not arg0_138.taskTFs[iter1_138] then
				arg0_138.taskTFs[iter1_138] = arg0_138:createTask(var3_138)
			end

			local var4_138 = var1_138[iter1_138]
			local var5_138 = arg0_138:getTaskById(var4_138)

			if var0_138.duration > 0 then
				var5_138.leftTime = var0_138:getTaskOpenTimeStamp(var4_138) - var0_138.duration
			end

			var5_138.taskState = var0_138:getTaskStateById(var4_138)
			var5_138.dueTime = var0_138:getTaskOpenTimeStamp(var4_138)
			var5_138.index = iter1_138

			arg0_138.taskTFs[iter1_138]:update(var5_138)
		end
	end
end

function var0_0.createTask(arg0_139, arg1_139)
	local var0_139 = {
		title = arg0_139:findTF("title/name", arg1_139),
		desc = arg0_139:findTF("desc/Text", arg1_139),
		timerTF = arg0_139:findTF("title/timer", arg1_139),
		timerTFTxt = arg0_139:findTF("title/timer/Text", arg1_139),
		timerOpen = arg0_139:findTF("title/timer/open", arg1_139),
		timerClose = arg0_139:findTF("title/timer/close", arg1_139),
		maskAchieved = arg0_139:findTF("title/slider/complete", arg1_139),
		tip = arg0_139:findTF("title/tip", arg1_139),
		commitBtn = arg0_139:findTF("desc/commit_panel/commit_btn", arg1_139),
		itemInfo = arg0_139:findTF("desc/item_info", arg1_139)
	}

	var0_139.itemContainer = arg0_139:findTF("items", var0_139.itemInfo)
	var0_139.itemTpl = arg0_139:findTF("item_tpl", var0_139.itemContainer)
	var0_139.numberTF = arg0_139:findTF("title/number", arg1_139)
	var0_139.progressTF = arg0_139:findTF("title/slider", arg1_139)
	var0_139.progessSlider = var0_139.progressTF:GetComponent(typeof(Slider))
	var0_139.lockBtn = arg0_139:findTF("desc/commit_panel/lock_btn", arg1_139)
	var0_139.itemCount = var0_139.itemTpl:Find("award/icon_bg/count")
	var0_139.progres = arg0_139:findTF("desc/commit_panel/progress", arg1_139)
	var0_139.progreshadow = arg0_139:findTF("title/shadow", arg1_139)
	var0_139.check = findTF(arg1_139, "title/complete")
	var0_139.lock = findTF(arg1_139, "title/lock")
	var0_139.working = findTF(arg1_139, "title/working")
	var0_139.pause = findTF(arg1_139, "title/pause")
	var0_139.pauseLock = findTF(arg1_139, "title/pause_lock")
	var0_139.view = arg0_139

	onToggle(arg0_139, arg1_139, function(arg0_140)
		setActive(var0_139.desc, arg0_140)
		setActive(var0_139.progreshadow, arg0_140)

		if arg0_140 then
			Canvas.ForceUpdateCanvases()

			local var0_140 = arg0_139.taskContainer.parent.transform:InverseTransformPoint(arg1_139.position).y
			local var1_140 = var0_140 - arg1_139.rect.height
			local var2_140 = arg0_139.taskContainer.parent.transform.rect
			local var3_140 = 0

			if var1_140 < var2_140.yMin then
				var3_140 = var2_140.yMin - var1_140
			end

			if var0_140 > var2_140.yMax then
				var3_140 = var2_140.yMax - var0_140
			end

			local var4_140 = arg0_139.taskContainer.localPosition

			var4_140.y = var4_140.y + var3_140
			arg0_139.taskContainer.localPosition = var4_140
			var0_139.progreshadow.localPosition = Vector3(39, -(148 + var0_139.desc.rect.height - 150))
		end
	end, SFX_PANEL)

	function var0_139.update(arg0_141, arg1_141)
		arg0_141:clearTimer()

		arg0_141.autoCommit = true
		arg0_141.isExpTask = false

		removeOnButton(arg0_141.commitBtn)
		arg0_141:updateItemInfo(arg1_141)
		arg0_141:updateView(arg1_141)
		arg0_141:updateProgress(arg1_141)
	end

	function var0_139.updateItemInfo(arg0_142, arg1_142)
		arg0_142.taskVO = arg1_142

		changeToScrollText(arg0_142.title, arg1_142:getConfig("name"))
		setText(arg0_142.desc, arg1_142:getConfig("desc") .. "\n\n")

		local var0_142
		local var1_142 = arg1_142:getConfig("target_num")
		local var2_142 = arg1_142:getConfig("sub_type")

		if var2_142 == TASK_SUB_TYPE_GIVE_ITEM then
			arg0_142.autoCommit = false
			var0_142 = tonumber(arg1_142:getConfig("target_id"))
		elseif var2_142 == TASK_SUB_TYPE_PLAYER_RES then
			arg0_142.autoCommit = false
			var0_142 = id2ItemId(tonumber(arg1_142:getConfig("target_id")))
		elseif var2_142 == TASK_SUB_TYPE_BATTLE_EXP then
			arg0_142.isExpTask = true
			var0_142 = 59000
		end

		setActive(arg0_142.itemContainer, not arg0_142.autoCommit or arg0_142.isExpTask)

		if var0_142 then
			updateDrop(arg0_142.itemTpl:Find("award"), {
				type = 2,
				id = var0_142,
				count = var1_142
			})
			setText(arg0_142.itemCount, var1_142 > 1000 and math.floor(var1_142 / 1000) .. "K" or var1_142)
		end

		setText(arg0_142.numberTF, arg1_142.index)
	end

	function var0_139.updateView(arg0_143, arg1_143)
		local var0_143 = arg1_143.taskState
		local var1_143 = false
		local var2_143 = false
		local var3_143 = false

		if var0_143 == ShipBluePrint.TASK_STATE_PAUSE and arg1_143.leftTime then
			local var4_143 = getProxy(TaskProxy):getTaskVO(arg1_143.id)

			var1_143 = var4_143 and var4_143:isFinish()
			var3_143 = arg1_143.leftTime > 0
			var2_143 = var4_143 and var4_143:isReceive()

			if arg1_143.leftTime > 0 then
				setText(var0_139.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(arg1_143.leftTime))
			end
		end

		setActive(arg0_143.pause, ShipBluePrint.TASK_STATE_PAUSE == var0_143 and not var1_143 and not var3_143 or ShipBluePrint.TASK_STATE_PAUSE == var0_143 and not var3_143 and var1_143 and not arg0_143.autoCommit)
		setActive(arg0_143.pauseLock, ShipBluePrint.TASK_STATE_PAUSE == var0_143 and not var1_143 and var3_143)
		setActive(arg0_143.lockBtn, var0_143 ~= ShipBluePrint.TASK_STATE_ACHIEVED and (var0_143 ~= ShipBluePrint.TASK_STATE_START or not not arg0_143.autoCommit))
		setActive(arg0_143.commitBtn, var0_143 == ShipBluePrint.TASK_STATE_ACHIEVED or var0_143 == ShipBluePrint.TASK_STATE_START and not arg0_143.autoCommit)
		setActive(arg0_143.progressTF, var0_143 == ShipBluePrint.TASK_STATE_ACHIEVED or var0_143 == ShipBluePrint.TASK_STATE_START or var0_143 == ShipBluePrint.TASK_STATE_FINISHED or var0_143 == ShipBluePrint.TASK_STATE_PAUSE and not var3_143)
		setActive(arg0_143.lock, var0_143 == ShipBluePrint.TASK_STATE_LOCK or var0_143 == ShipBluePrint.TASK_STATE_WAIT)
		setActive(arg0_143.working, var0_143 == ShipBluePrint.TASK_STATE_OPENING or var0_143 == ShipBluePrint.TASK_STATE_START or var0_143 == ShipBluePrint.TASK_STATE_ACHIEVED)
		setActive(arg0_143.maskAchieved, var0_143 == ShipBluePrint.TASK_STATE_FINISHED or var0_143 == ShipBluePrint.TASK_STATE_PAUSE and var2_143)
		setActive(arg0_143.timerTF, var0_143 == ShipBluePrint.TASK_STATE_WAIT or var0_143 == ShipBluePrint.TASK_STATE_PAUSE and arg1_143.leftTime and arg1_143.leftTime > 0)
		setActive(arg0_143.check, arg0_143.autoCommit and var0_143 == ShipBluePrint.TASK_STATE_ACHIEVED or var0_143 == ShipBluePrint.TASK_STATE_FINISHED or var0_143 == ShipBluePrint.TASK_STATE_PAUSE and var2_143)
		setActive(arg0_143.tip, var0_143 == ShipBluePrint.TASK_STATE_ACHIEVED)
		setActive(arg0_143.timerOpen, var0_143 == ShipBluePrint.TASK_STATE_WAIT)
		setActive(arg0_143.timerClose, var0_143 == ShipBluePrint.TASK_STATE_PAUSE and arg1_143.leftTime and arg1_143.leftTime > 0)
	end

	function var0_139.updateProgress(arg0_144, arg1_144)
		local var0_144 = arg1_144.taskState
		local var1_144 = arg1_144:getProgress() / arg1_144:getConfig("target_num")

		if var0_144 == ShipBluePrint.TASK_STATE_WAIT then
			arg0_144:addTimer(arg1_144, arg1_144.dueTime)

			var1_144 = 0
		elseif var0_144 == ShipBluePrint.TASK_STATE_OPENING then
			var1_144 = 0

			arg0_144.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, arg1_144.id)
		elseif var0_144 == ShipBluePrint.TASK_STATE_PAUSE then
			if arg1_144:isReceive() then
				var1_144 = 1
			end
		elseif var0_144 == ShipBluePrint.TASK_STATE_LOCK then
			var1_144 = 0
		elseif var0_144 == ShipBluePrint.TASK_STATE_ACHIEVED then
			onButton(arg0_144.view, arg0_144.commitBtn, function()
				arg0_144.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, arg1_144.id)
			end, SFX_PANEL)

			var1_144 = 1
		elseif var0_144 == ShipBluePrint.TASK_STATE_FINISHED then
			var1_144 = 1
		elseif var0_144 == ShipBluePrint.TASK_STATE_START and not arg0_144.autoCommit then
			onButton(arg0_144.view, arg0_144.commitBtn, function()
				arg0_144.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, arg1_144.id)
			end, SFX_PANEL)

			var1_144 = 0
		end

		if var1_144 > 0 then
			arg0_144.itemSliderLT = LeanTween.value(go(arg0_144.progressTF), 0, math.min(var1_144, 1), 0.5 * math.min(var1_144, 1)):setOnUpdate(System.Action_float(function(arg0_147)
				arg0_144.progessSlider.value = arg0_147
			end)).uniqueId
		else
			arg0_144.progessSlider.value = var1_144
		end

		local var2_144 = math.floor(var1_144 * 100)

		setText(arg0_144.progres, math.ceil(math.min(var2_144, 100)) .. "%")
		setText(arg0_144.progreshadow, math.min(var2_144, 100) .. "%")
	end

	function var0_139.addTimer(arg0_148, arg1_148, arg2_148)
		arg0_148:clearTimer()

		arg0_148.taskTimer = Timer.New(function()
			local var0_149 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_149 = arg2_148 - var0_149

			if var1_149 > 0 then
				setText(arg0_148.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(var1_149))
			else
				arg0_148:clearTimer()
				setText(arg0_148.timerTFTxt, "00:00:00")
				arg0_148.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, arg1_148.id)
			end
		end, 1, -1)

		arg0_148.taskTimer:Start()
		arg0_148.taskTimer.func()
	end

	function var0_139.clearTimer(arg0_150)
		if arg0_150.taskTimer then
			arg0_150.taskTimer:Stop()

			arg0_150.taskTimer = nil
		end
	end

	function var0_139.clear(arg0_151)
		arg0_151:clearTimer()

		if arg0_151.itemSliderLT then
			LeanTween.cancel(arg0_151.itemSliderLT)

			arg0_151.itemSliderLT = nil
		end
	end

	return var0_139
end

function var0_0.openPreView(arg0_152)
	local var0_152 = arg0_152.contextData.shipBluePrintVO

	if var0_152 then
		setActive(arg0_152.preViewer, true)
		setParent(arg0_152.blurPanel, arg0_152._tf)
		pg.UIMgr.GetInstance():BlurPanel(arg0_152.preViewer)
		arg0_152:playLoadingAni()

		arg0_152.viewShipVO = var0_152:getShipVO()
		arg0_152.breakIds = arg0_152:getStages(arg0_152.viewShipVO)

		for iter0_152 = 1, var4_0 do
			local var1_152 = arg0_152.breakIds[iter0_152]
			local var2_152 = var3_0[var1_152]
			local var3_152 = arg0_152:findTF("stage" .. iter0_152, arg0_152.stages)

			onToggle(arg0_152, var3_152, function(arg0_153)
				if arg0_153 then
					setText(arg0_152.breakView, var3_0[var1_152].breakout_view)
					arg0_152:switchStage(var1_152)
				end
			end, SFX_PANEL)

			if iter0_152 == 1 then
				triggerToggle(var3_152, true)
			end
		end

		arg0_152.isShowPreview = true

		arg0_152:updateMaxLevelAttrs(var0_152)
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

function var0_0.updateMaxLevelAttrs(arg0_154, arg1_154)
	if not arg1_154:isFetched() then
		return
	end

	local var0_154 = arg0_154.shipVOs[arg1_154.shipId]
	local var1_154 = Clone(var0_154)

	var1_154.level = 125

	local var2_154 = Clone(arg1_154)

	var2_154.level = arg1_154:getMaxLevel()

	local var3_154 = intProperties(var2_154:getShipProperties(var1_154, false))

	for iter0_154, iter1_154 in ipairs(var0_0.MAX_LEVEL_ATTRS) do
		local var4_154 = arg0_154.previewAttrContainer:Find(iter1_154)

		if iter1_154 == AttributeType.ArmorType then
			setText(var4_154:Find("bg/value"), var0_154:getShipArmorName())
		else
			setText(var4_154:Find("bg/value"), var3_154[iter1_154] or 0)
		end

		setText(var4_154:Find("bg/name"), AttributeType.Type2Name(iter1_154))
	end
end

function var0_0.closePreview(arg0_155, arg1_155)
	if arg0_155.previewer then
		arg0_155.previewer:clear()

		arg0_155.previewer = nil
	end

	setActive(arg0_155.preViewer, false)
	setActive(arg0_155.rawImage, false)

	if not arg1_155 then
		SetParent(arg0_155.blurPanel, pg.UIMgr.GetInstance().OverlayMain)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_155.preViewer, arg0_155._tf)

	arg0_155.isShowPreview = nil
end

function var0_0.playLoadingAni(arg0_156)
	setActive(arg0_156.seaLoading, true)
end

function var0_0.stopLoadingAni(arg0_157)
	setActive(arg0_157.seaLoading, false)
end

function var0_0.showBarrage(arg0_158)
	arg0_158.previewer = WeaponPreviewer.New(arg0_158.rawImage)

	arg0_158.previewer:configUI(arg0_158.healTF)
	arg0_158.previewer:setDisplayWeapon(arg0_158:getWaponIdsById(arg0_158.breakOutId))
	arg0_158.previewer:load(40000, arg0_158.viewShipVO, arg0_158:getAllWeaponIds(), function()
		arg0_158:stopLoadingAni()
	end)
end

function var0_0.getWaponIdsById(arg0_160, arg1_160)
	return var3_0[arg1_160].weapon_ids
end

function var0_0.getAllWeaponIds(arg0_161)
	local var0_161 = {}

	for iter0_161, iter1_161 in ipairs(arg0_161.breakIds) do
		local var1_161 = Clone(var3_0[iter1_161].weapon_ids)
		local var2_161 = {
			__add = function(arg0_162, arg1_162)
				for iter0_162, iter1_162 in ipairs(arg0_162) do
					if not table.contains(arg1_162, iter1_162) then
						table.insert(arg1_162, iter1_162)
					end
				end

				return arg1_162
			end
		}

		setmetatable(var0_161, var2_161)

		var0_161 = var0_161 + var1_161
	end

	return var0_161
end

function var0_0.getStages(arg0_163, arg1_163)
	local var0_163 = {}
	local var1_163 = math.floor(arg1_163.configId / 10)

	for iter0_163 = 1, 4 do
		local var2_163 = tonumber(var1_163 .. iter0_163)

		assert(var3_0[var2_163], "必须存在配置" .. var2_163)
		table.insert(var0_163, var2_163)
	end

	return var0_163
end

function var0_0.switchStage(arg0_164, arg1_164)
	if arg0_164.breakOutId == arg1_164 then
		return
	end

	arg0_164.breakOutId = arg1_164

	if arg0_164.previewer then
		arg0_164.previewer:setDisplayWeapon(arg0_164:getWaponIdsById(arg0_164.breakOutId))
	end
end

function var0_0.clearTimers(arg0_165)
	for iter0_165, iter1_165 in pairs(arg0_165.taskTFs or {}) do
		iter1_165:clear()
	end
end

function var0_0.cloneTplTo(arg0_166, arg1_166, arg2_166)
	local var0_166 = tf(Instantiate(arg1_166))

	SetActive(var0_166, true)
	var0_166:SetParent(tf(arg2_166), false)

	return var0_166
end

function var0_0.onBackPressed(arg0_167)
	if isActive(arg0_167.msgPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_167.msgPanel, arg0_167.top)
		setActive(arg0_167.msgPanel, false)
	elseif isActive(arg0_167.unlockPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_167.unlockPanel, arg0_167.top)
		setActive(arg0_167.unlockPanel, false)
	elseif isActive(arg0_167.versionPanel) then
		triggerButton(arg0_167.versionPanel:Find("bg"))
	elseif arg0_167.isShowPreview then
		arg0_167:closePreview(true)
	elseif arg0_167.svQuickExchange:isShowing() then
		arg0_167.svQuickExchange:Hide()
	elseif arg0_167.awakenPlay or arg0_167:inModAnim() then
		-- block empty
	else
		arg0_167:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.willExit(arg0_168)
	if isActive(arg0_168.msgPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_168.msgPanel, arg0_168.top)
		setActive(arg0_168.msgPanel, false)
	end

	if isActive(arg0_168.unlockPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_168.unlockPanel, arg0_168.top)
		setActive(arg0_168.unlockPanel, false)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_168.blurPanel, arg0_168._tf)
	LeanTween.cancel(go(arg0_168.fittingAttrPanel))

	if arg0_168.lastPaintingName then
		retPaintingPrefab(arg0_168.painting, arg0_168.lastPaintingName)
	end

	for iter0_168, iter1_168 in pairs(arg0_168.taskTFs or {}) do
		iter1_168:clear()
	end

	arg0_168:closePreview(true)
	arg0_168:clearLeanTween(true)

	if arg0_168.previewer then
		arg0_168.previewer:clear()

		arg0_168.previewer = nil
	end

	if arg0_168.cbTimer then
		arg0_168.cbTimer:Stop()

		arg0_168.cbTimer = nil
	end

	arg0_168.svQuickExchange:Destroy()
end

function var0_0.paintBreath(arg0_169)
	LeanTween.cancel(go(arg0_169.painting))
	LeanTween.moveY(rtf(arg0_169.painting), var5_0, var6_0):setLoopPingPong():setEase(LeanTweenType.easeInOutCubic):setFrom(0)
end

function var0_0.buildStartAni(arg0_170, arg1_170, arg2_170)
	if arg1_170 == "researchStartWindow" then
		arg0_170.progressPanel.localScale = Vector3(0, 1, 1)

		LeanTween.scale(arg0_170.progressPanel, Vector3(1, 1, 1), 0.2):setDelay(2)
	end

	local function var0_170()
		arg0_170.awakenAni:SetActive(true)

		arg0_170.awakenPlay = true

		local var0_171 = tf(arg0_170.awakenAni)

		pg.UIMgr.GetInstance():BlurPanel(var0_171)
		var0_171:SetAsLastSibling()
		var0_171:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_172)
			if not IsNil(arg0_170.awakenAni) then
				pg.UIMgr.GetInstance():UnblurPanel(var0_171, arg0_170.blurPanel)
				arg0_170.awakenAni:SetActive(false)

				arg0_170.awakenPlay = false

				if arg2_170 then
					arg2_170()
				end
			end
		end)
	end

	local var1_170 = arg0_170:findTF(arg1_170 .. "(Clone)")

	arg0_170.awakenAni = var1_170 and go(var1_170)

	if not arg0_170.awakenAni then
		PoolMgr.GetInstance():GetUI(arg1_170, true, function(arg0_173)
			arg0_173:SetActive(true)

			arg0_170.awakenAni = arg0_173

			var0_170()
		end)
	else
		var0_170()
	end
end

function var0_0.showFittingMsgPanel(arg0_174, arg1_174)
	pg.UIMgr.GetInstance():BlurPanel(arg0_174.msgPanel)
	setActive(arg0_174.msgPanel, true)

	local var0_174 = arg0_174.contextData.shipBluePrintVO
	local var1_174 = var0_174:getMaxFateLevel()
	local var2_174 = arg0_174:findTF("window/content", arg0_174.msgPanel)
	local var3_174 = arg0_174:findTF("pre_btn", var2_174)
	local var4_174 = arg0_174:findTF("next_btn", var2_174)
	local var5_174 = arg0_174:findTF("attrl_panel", var2_174)
	local var6_174 = arg0_174:findTF("skill_panel", var2_174)
	local var7_174 = arg0_174:findTF("phase", var2_174)
	local var8_174 = {
		"I",
		"II",
		"III",
		"IV",
		"V"
	}

	local function var9_174()
		setActive(var3_174, arg1_174 > 1)
		setActive(var4_174, arg1_174 < var1_174)
		setText(var7_174, "PHASE." .. var8_174[arg1_174])

		local var0_175 = var0_174:getFateStrengthenConfig(arg1_174)

		assert(var0_175.special == 1 and type(var0_175.special_effect) == "table", "without fate config")

		local var1_175 = var0_175.special_effect
		local var2_175
		local var3_175 = {}

		for iter0_175, iter1_175 in ipairs(var1_175) do
			local var4_175 = iter1_175[1]

			if var4_175 == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				var2_175 = iter1_175[2][2]
			elseif var4_175 == ShipBluePrint.STRENGTHEN_TYPE_ATTR then
				table.insert(var3_175, iter1_175[2])
			end
		end

		setActive(var5_174, #var3_175 > 0)
		setActive(var6_174, var2_175)

		if var2_175 then
			local var5_175 = getSkillConfig(var2_175)

			GetImageSpriteFromAtlasAsync("skillicon/" .. var5_175.icon, "", arg0_174:findTF("skill_icon", var6_174))
			setText(arg0_174:findTF("skill_name", var6_174), getSkillName(var2_175))

			local var6_175 = 1

			setText(arg0_174:findTF("skill_lv", var6_174), "Lv." .. var6_175)
			setText(arg0_174:findTF("help_panel/skill_intro", var6_174), getSkillDescGet(var2_175))
		end

		if #var3_175 > 0 then
			for iter2_175, iter3_175 in ipairs(var3_175) do
				local var7_175 = iter2_175 < var5_174.childCount and var5_174:GetChild(iter2_175) or cloneTplTo(var5_174:GetChild(iter2_175 - 1), var5_174)

				setText(var7_175:Find("name"), AttributeType.Type2Name(iter3_175[1]))
				setText(var7_175:Find("number"), " + " .. iter3_175[2])
			end

			for iter4_175 = #var3_175 + 1, var5_174.childCount - 1 do
				setActive(var5_174:GetChild(iter4_175), false)
			end
		end
	end

	onButton(arg0_174, var3_174, function()
		arg1_174 = arg1_174 - 1

		var9_174()
	end)
	onButton(arg0_174, var4_174, function()
		arg1_174 = arg1_174 + 1

		var9_174()
	end)
	setText(arg0_174:findTF("desc", var5_174), i18n("fate_attr_word"))
	var9_174()
end

function var0_0.showUnlockPanel(arg0_178)
	pg.UIMgr.GetInstance():BlurPanel(arg0_178.unlockPanel)
	setActive(arg0_178.unlockPanel, true)

	local var0_178 = arg0_178.contextData.shipBluePrintVO.id
	local var1_178 = arg0_178.contextData.shipBluePrintVO:getUnlockItem()
	local var2_178 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = var1_178
	})
	local var3_178 = arg0_178.contextData.shipBluePrintVO:getShipVO()
	local var4_178 = var3_178:getPainting()
	local var5_178 = arg0_178.unlockPanel:Find("window/content")

	GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var4_178, var4_178, var5_178:Find("Image/mask/icon"), true)
	setText(var5_178:Find("words/Text"), i18n("techpackage_item_use_1", var3_178:getName()))
	setText(var5_178:Find("words/Text_2"), i18n("techpackage_item_use_2", var2_178:getName()))
	GetImageSpriteFromAtlasAsync(var2_178:getIcon(), "", arg0_178.unlockPanel:Find("window/confirm_btn/Image/Image"))
	setText(arg0_178.unlockPanel:Find("window/confirm_btn/Image/Text"), i18n("event_ui_consume"))
	onButton(arg0_178, arg0_178.unlockPanel:Find("window/confirm_btn"), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_178.unlockPanel, arg0_178.top)
		setActive(arg0_178.unlockPanel, false)
		arg0_178:emit(ShipBluePrintMediator.ON_ITEM_UNLOCK, var0_178, var1_178)
	end, SFX_CANCEL)
end

function var0_0.checkStory(arg0_180)
	local var0_180 = {
		nil,
		"FANGAN3"
	}

	arg0_180.storyMgr = arg0_180.storyMgr or pg.NewStoryMgr.GetInstance()

	if var0_180[arg0_180.version] and not arg0_180.storyMgr:IsPlayed(var0_180[arg0_180.version]) then
		arg0_180.storyMgr:Play(var0_180[arg0_180.version])
	end
end

return var0_0
