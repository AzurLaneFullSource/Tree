local var0 = class("ShipBluePrintScene", import("..base.BaseUI"))
local var1 = pg.ship_data_blueprint
local var2 = pg.ship_data_template
local var3 = pg.ship_data_breakout
local var4 = 3
local var5 = -10
local var6 = 2.3
local var7 = 0.3

function var0.getUIName(arg0)
	return "ShipBluePrintUI"
end

function var0.setVersion(arg0, arg1)
	arg0.version = arg1
end

function var0.setShipVOs(arg0, arg1)
	arg0.shipVOs = arg1
end

function var0.getShipById(arg0, arg1)
	return arg0.shipVOs[arg1]
end

function var0.setTaskVOs(arg0, arg1)
	arg0.taskVOs = arg1
end

function var0.getTaskById(arg0, arg1)
	return arg0.taskVOs[arg1] or Task.New({
		id = arg1
	})
end

function var0.getItemById(arg0, arg1)
	return getProxy(BagProxy):getItemById(arg1) or Item.New({
		count = 0,
		id = arg1
	})
end

function var0.setShipBluePrints(arg0, arg1)
	arg0.bluePrintByIds = arg1
end

function var0.updateShipBluePrintVO(arg0, arg1)
	if arg1 then
		arg0.bluePrintByIds[arg1.id] = arg1
	end

	arg0:initShips()
end

function var0.init(arg0)
	arg0.main = arg0:findTF("main")
	arg0.centerPanel = arg0:findTF("center_panel", arg0.main)
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.top = arg0:findTF("adapt", arg0.blurPanel)
	arg0.topPanel = arg0:findTF("top", arg0.top)
	arg0.topBg = arg0:findTF("top_bg", arg0.blurPanel)
	arg0.backBtn = arg0:findTF("top/back", arg0.top)
	arg0.leftPanle = arg0:findTF("left_panel", arg0.top)
	arg0.bottomPanel = arg0:findTF("bottom_panel", arg0.top)
	arg0.rightPanel = arg0:findTF("right_panel", arg0.top)
	arg0.shipContainer = arg0:findTF("ships/bg/content", arg0.bottomPanel)
	arg0.shipTpl = arg0:findTF("ship_tpl", arg0.bottomPanel)
	arg0.versionBtn = arg0:findTF("ships/bg/version/version_btn", arg0.bottomPanel)
	arg0.eyeTF = arg0:findTF("eye", arg0.leftPanle)
	arg0.painting = arg0:findTF("main/center_panel/painting")
	arg0.nameTF = arg0:findTF("name", arg0.centerPanel)
	arg0.shipName = arg0:findTF("name_mask/Text", arg0.nameTF)
	arg0.shipType = arg0:findTF("type", arg0.nameTF)
	arg0.englishName = arg0:findTF("english_name", arg0.nameTF)
	arg0.shipInfoStarTpl = arg0:findTF("star_tpl", arg0.nameTF)

	setActive(arg0.shipInfoStarTpl, false)

	arg0.stars = arg0:findTF("stars", arg0.nameTF)
	arg0.initBtn = arg0:findTF("property_panel/btns/init_toggle", arg0.leftPanle)
	arg0.attrBtn = arg0:findTF("property_panel/btns/attr_toggle", arg0.leftPanle)
	arg0.attrDisableBtn = arg0:findTF("property_panel/btns/attr_toggle/disable", arg0.leftPanle)
	arg0.initPanel = arg0:findTF("property_panel/init_panel", arg0.leftPanle)
	arg0.propertyPanel = PropertyPanel.New(arg0.initPanel, 32)

	setText(arg0:findTF("property_title1/Text", arg0.initPanel), i18n("blueprint_combatperformance"))
	setText(arg0:findTF("property_title2/Text", arg0.initPanel), i18n("blueprint_shipperformance"))

	arg0.skillRect = arg0:findTF("property_panel/init_panel/skills_rect", arg0.leftPanle)
	arg0.skillPanel = arg0:findTF("property_panel/init_panel/skills_rect/skills", arg0.leftPanle)
	arg0.skillTpl = arg0:findTF("skilltpl", arg0.skillPanel)
	arg0.skillArrLeft = arg0:findTF("property_panel/init_panel/arrow1", arg0.leftPanle)
	arg0.skillArrRight = arg0:findTF("property_panel/init_panel/arrow2", arg0.leftPanle)
	arg0.simulationBtn = arg0:findTF("property_panel/init_panel/property_title2/simulation", arg0.leftPanle)
	arg0.attrPanel = arg0:findTF("property_panel/attr_panel", arg0.leftPanle)
	arg0.modAdditionPanel = arg0:findTF("property_panel/attr_panel", arg0.leftPanle)
	arg0.modAdditionContainer = arg0:findTF("scroll_rect/content", arg0.modAdditionPanel)
	arg0.modAdditionTpl = arg0:findTF("addition_tpl", arg0.modAdditionContainer)
	arg0.preViewBtn = arg0:findTF("pre_view", arg0.attrPanel)
	arg0.stateInfo = arg0:findTF("state_info", arg0.centerPanel)
	arg0.startBtn = arg0:findTF("state_info/start_btn", arg0.centerPanel)
	arg0.lockPanel = arg0:findTF("state_info/lock_panel", arg0.centerPanel)
	arg0.lockBtn = arg0:findTF("lock", arg0.lockPanel)
	arg0.finishedBtn = arg0:findTF("state_info/finished_btn", arg0.centerPanel)
	arg0.progressPanel = arg0:findTF("state_info/progress", arg0.centerPanel)

	setText(arg0:findTF("label", arg0.progressPanel), i18n("blueprint_researching"))

	arg0.progressContainer = arg0:findTF("content", arg0.progressPanel)
	arg0.progressTpl = arg0:findTF("item", arg0.progressContainer)
	arg0.openCondition = arg0:findTF("state_info/open_condition", arg0.centerPanel)
	arg0.speedupBtn = arg0:findTF("main/speedup_btn")
	arg0.taskListPanel = arg0:findTF("task_list", arg0.rightPanel)
	arg0.taskContainer = arg0:findTF("task_list/scroll/content", arg0.rightPanel)
	arg0.taskTpl = arg0:findTF("task_list/task_tpl", arg0.rightPanel)
	arg0.modPanel = arg0:findTF("mod_panel", arg0.rightPanel)
	arg0.attrContainer = arg0:findTF("desc/atrrs", arg0.modPanel)
	arg0.levelSlider = arg0:findTF("title/slider", arg0.modPanel):GetComponent(typeof(Slider))
	arg0.levelSliderTxt = arg0:findTF("title/slider/Text", arg0.modPanel)
	arg0.preLevelSlider = arg0:findTF("title/pre_slider", arg0.modPanel):GetComponent(typeof(Slider))
	arg0.modLevel = arg0:findTF("title/level_bg/Text", arg0.modPanel):GetComponent(typeof(Text))
	arg0.needLevelTxt = arg0:findTF("title/Text", arg0.modPanel):GetComponent(typeof(Text))
	arg0.calcPanel = arg0.modPanel:Find("desc/calc_panel")
	arg0.calcMinusBtn = arg0.calcPanel:Find("calc/base/minus")
	arg0.calcPlusBtn = arg0.calcPanel:Find("calc/base/plus")
	arg0.calcTxt = arg0.calcPanel:Find("calc/base/count/Text")
	arg0.calcMaxBtn = arg0.calcPanel:Find("calc/max")
	arg0.itemInfo = arg0.calcPanel:Find("item_bg")
	arg0.itemInfoIcon = arg0.itemInfo:Find("icon")
	arg0.itemInfoCount = arg0.itemInfo:Find("kc")
	arg0.modBtn = arg0.calcPanel:Find("confirm_btn")
	arg0.fittingBtn = arg0:findTF("desc/fitting_btn", arg0.modPanel)
	arg0.fittingBtnEffect = arg0.fittingBtn:Find("anim/ShipBlue02")
	arg0.fittingPanel = arg0:findTF("fitting_panel", arg0.rightPanel)

	setActive(arg0.fittingPanel, false)

	arg0.fittingAttrPanel = arg0:findTF("desc/middle", arg0.fittingPanel)
	arg0.phasePic = arg0:findTF("title/phase", arg0.fittingPanel)
	arg0.phaseSlider = arg0:findTF("desc/top/slider", arg0.fittingPanel):GetComponent(typeof(Slider))
	arg0.phaseSliderTxt = arg0:findTF("desc/top/precent", arg0.fittingPanel)
	arg0.prePhaseSlider = arg0:findTF("desc/top/pre_slider", arg0.fittingPanel):GetComponent(typeof(Slider))
	arg0.fittingNeedMask = arg0:findTF("desc/top/mask", arg0.fittingPanel)
	arg0.fittingCalcPanel = arg0:findTF("desc/bottom", arg0.fittingPanel)
	arg0.fittingCalcMinusBtn = arg0:findTF("calc/base/minus", arg0.fittingCalcPanel)
	arg0.fittingCalcPlusBtn = arg0:findTF("calc/base/plus", arg0.fittingCalcPanel)
	arg0.fittingCalcTxt = arg0:findTF("calc/base/count/Text", arg0.fittingCalcPanel)
	arg0.fittingCalcMaxBtn = arg0:findTF("calc/max", arg0.fittingCalcPanel)
	arg0.fittingItemInfo = arg0:findTF("item_bg", arg0.fittingCalcPanel)
	arg0.fittingItemInfoIcon = arg0:findTF("icon", arg0.fittingItemInfo)
	arg0.fittingItemInfoCount = arg0:findTF("kc", arg0.fittingItemInfo)
	arg0.fittingConfirmBtn = arg0:findTF("confirm_btn", arg0.fittingCalcPanel)
	arg0.fittingCancelBtn = arg0:findTF("cancel_btn", arg0.fittingCalcPanel)
	arg0.msgPanel = arg0:findTF("msg_panel", arg0.blurPanel)

	setActive(arg0.msgPanel, false)

	arg0.versionPanel = arg0._tf:Find("version_panel")

	setActive(arg0.versionPanel, false)

	arg0.preViewer = arg0:findTF("preview")
	arg0.preViewerFrame = arg0:findTF("preview/frame")

	setText(arg0:findTF("bg/title/Image", arg0.preViewerFrame), i18n("word_preview"))
	setActive(arg0.preViewer, false)

	arg0.sea = arg0:findTF("sea", arg0.preViewerFrame)
	arg0.rawImage = arg0.sea:GetComponent("RawImage")

	setActive(arg0.rawImage, false)

	arg0.seaLoading = arg0:findTF("bg/loading", arg0.preViewerFrame)
	arg0.healTF = arg0:findTF("resources/heal")
	arg0.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0.healTF, false)

	arg0.stages = arg0:findTF("stageScrollRect/stages", arg0.preViewerFrame)
	arg0.breakView = arg0:findTF("content/Text", arg0.preViewerFrame)
	arg0.previewAttrPanel = arg0:findTF("preview/attrs_panel/attr_panel")
	arg0.previewAttrContainer = arg0:findTF("content", arg0.previewAttrPanel)

	setText(arg0:findTF("preview/attrs_panel/Text"), i18n("meta_energy_preview_tip"))
	setText(arg0:findTF("preview/attrs_panel/desc"), i18n("meta_energy_preview_title"))

	arg0.helpBtn = arg0:findTF("helpBtn", arg0.top)
	arg0.exchangeBtn = arg0:findTF("exchangeBtn", arg0.top)
	arg0.itemUnlockBtn = arg0:findTF("itemUnlockBtn", arg0.top)
	arg0.bottomWidth = arg0.bottomPanel.rect.height
	arg0.topWidth = arg0.topPanel.rect.height * 2
	arg0.taskTFs = {}
	arg0.leanTweens = {}
	arg0.unlockPanel = arg0.blurPanel:Find("unlock_panel")

	setActive(arg0.unlockPanel, false)

	arg0.svQuickExchange = BlueprintQuickExchangeView.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	local var0 = getProxy(TechnologyProxy):getConfigMaxVersion()

	if not arg0.contextData.shipBluePrintVO then
		local var1 = {}

		for iter0 = 1, var0 do
			var1[iter0] = 0
		end

		for iter1, iter2 in pairs(arg0.bluePrintByIds) do
			local var2 = iter2:getConfig("blueprint_version")

			var1[var2] = var1[var2] + (iter2.state == ShipBluePrint.STATE_UNLOCK and 1 or 0)

			if iter2.state == ShipBluePrint.STATE_DEV then
				arg0.contextData.shipBluePrintVO = arg0.contextData.shipBluePrintVO or iter2

				break
			end
		end

		if not arg0.contextData.shipBluePrintVO then
			for iter3 = 1, var0 do
				arg0.version = iter3

				if var1[iter3] <= 4 then
					break
				end
			end

			arg0:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, arg0.version)
		end
	end

	arg0:switchHide()
	arg0:initShips()
	onButton(arg0, arg0.speedupBtn, function()
		arg0:emit(ShipBluePrintMediator.ON_CLICK_SPEEDUP_BTN)
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SOUND_BACK)
	onButton(arg0, arg0.startBtn, function()
		if not arg0.contextData.shipBluePrintVO then
			return
		end

		local var0 = arg0.contextData.shipBluePrintVO.id

		arg0:emit(ShipBluePrintMediator.ON_START, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.finishedBtn, function()
		if not arg0.contextData.shipBluePrintVO then
			return
		end

		local var0 = arg0.contextData.shipBluePrintVO.id

		arg0:emit(ShipBluePrintMediator.ON_FINISHED, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.itemUnlockBtn, function()
		if not arg0.contextData.shipBluePrintVO then
			return
		end

		arg0:showUnlockPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.preViewBtn, function()
		arg0:openPreView()
	end, SFX_PANEL)
	onButton(arg0, arg0.seaLoading, function()
		if not arg0.previewer then
			arg0:showBarrage()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.preViewer, function()
		arg0:closePreview()
	end, SFX_PANEL)
	onButton(arg0, arg0.eyeTF, function()
		if arg0.isSwitchAnim then
			return
		end

		arg0:switchHide()
		arg0:switchState(var7, not arg0.flag)
	end, SFX_PANEL)
	onButton(arg0, arg0.main, function()
		if arg0.isSwitchAnim then
			return
		end

		if not arg0.flag then
			arg0:switchHide()
			arg0:switchState(var7, not arg0.flag)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[isActive(arg0.fittingPanel) and "help_shipblueprintui_luck" or "help_shipblueprintui"].tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.exchangeBtn, function()
		arg0.svQuickExchange:Load()
		arg0.svQuickExchange:ActionInvoke("Show")
		arg0.svQuickExchange:ActionInvoke("UpdateBlueprint", arg0.contextData.shipBluePrintVO)
	end)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.blurPanel, {
		pbList = {
			arg0.rightPanel:Find("task_list"),
			arg0.rightPanel:Find("mod_panel"),
			arg0.leftPanle:Find("property_panel"),
			arg0.bottomPanel:Find("ships/bg")
		}
	})
	setText(arg0:findTF("window/top/bg/infomation/title", arg0.msgPanel), i18n("title_info"))
	onButton(arg0, arg0:findTF("window/top/btnBack", arg0.msgPanel), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.msgPanel, arg0.top)
		setActive(arg0.msgPanel, false)
	end, SFX_CANCEL)
	setText(arg0:findTF("window/confirm_btn/Text", arg0.msgPanel), i18n("text_confirm"))
	onButton(arg0, arg0:findTF("window/confirm_btn", arg0.msgPanel), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.msgPanel, arg0.top)
		setActive(arg0.msgPanel, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("bg", arg0.msgPanel), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.msgPanel, arg0.top)
		setActive(arg0.msgPanel, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0.unlockPanel:Find("window/top/btnBack"), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.unlockPanel, arg0.top)
		setActive(arg0.unlockPanel, false)
	end, SFX_CANCEL)
	setText(arg0.unlockPanel:Find("window/confirm_btn/Text"), i18n("text_confirm"))
	setText(arg0.unlockPanel:Find("window/cancel_btn/Text"), i18n("text_cancel"))
	setText(arg0.unlockPanel:Find("window/top/bg/infomation/title"), i18n("title_info"))
	onButton(arg0, arg0.unlockPanel:Find("window/cancel_btn"), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.unlockPanel, arg0.top)
		setActive(arg0.unlockPanel, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0.unlockPanel:Find("bg"), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.unlockPanel, arg0.top)
		setActive(arg0.unlockPanel, false)
	end, SFX_CANCEL)
	GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "version_" .. arg0.version, arg0.versionBtn)
	arg0:updateVersionBtnTip()

	if var0 > 1 then
		onButton(arg0, arg0.versionBtn, function()
			if arg0.cbTimer then
				return
			end

			setActive(arg0.versionPanel, true)
			pg.UIMgr.GetInstance():BlurPanel(arg0.versionPanel)
		end, SFX_PANEL)
		onButton(arg0, arg0.versionPanel:Find("bg"), function()
			pg.UIMgr.GetInstance():UnblurPanel(arg0.versionPanel, arg0._tf)
			setActive(arg0.versionPanel, false)
		end, SFX_CANCEL)

		local var3 = UIItemList.New(arg0.versionPanel:Find("window/content"), arg0.versionPanel:Find("window/content/version_1"))

		var3:make(function(arg0, arg1, arg2)
			arg1 = arg1 + 1

			if arg0 == UIItemList.EventUpdate then
				arg2.name = "version_" .. arg1

				GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "version_" .. arg1, arg2:Find("image"))
				setText(arg2:Find("number/Text"), string.format("%02d", arg1))
				onButton(arg0, arg2, function()
					arg0.version = arg1

					arg0:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, arg0.version)

					arg0.contextData.shipBluePrintVO = nil

					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "version_" .. arg0.version, arg0.versionBtn)
					arg0:initShips()
					arg0:updateVersionBtnTip()
					pg.UIMgr.GetInstance():UnblurPanel(arg0.versionPanel, arg0._tf)
					setActive(arg0.versionPanel, false)
				end, SFX_CANCEL)
			end
		end)
		var3:align(var0)
		arg0:updateVersionPanelBtnTip()
	end

	LeanTween.alpha(rtf(arg0.skillArrLeft), 0.25, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
	LeanTween.alpha(rtf(arg0.skillArrRight), 0.25, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
end

function var0.updateVersionBtnTip(arg0)
	local var0 = getProxy(TechnologyProxy)
	local var1 = var0:getConfigMaxVersion()
	local var2 = {}

	for iter0 = 1, var1 do
		if iter0 ~= arg0.version then
			table.insert(var2, iter0)
		end
	end

	setActive(arg0.versionBtn:Find("tip"), var0:CheckPursuingCostTip(var2))
end

function var0.updateVersionPanelBtnTip(arg0)
	local var0 = getProxy(TechnologyProxy)
	local var1 = var0:getConfigMaxVersion()

	for iter0 = 1, var1 do
		setActive(arg0.versionPanel:Find("window/content/version_" .. iter0 .. "/tip"), var0:CheckPursuingCostTip({
			iter0
		}))
	end
end

function var0.updateAllPursuingCostTip(arg0)
	arg0:updateVersionBtnTip()
	arg0:updateVersionPanelBtnTip()

	for iter0, iter1 in pairs(arg0.bluePrintItems) do
		iter1:updatePursuingTip()
	end
end

function var0.switchHide(arg0)
	local var0 = not arg0.flag

	LeanTween.cancel(arg0.bottomPanel)
	LeanTween.cancel(arg0.topPanel)
	LeanTween.cancel(arg0.topBg)

	if var0 then
		LeanTween.moveY(arg0.bottomPanel, 0, var7)
		LeanTween.moveY(arg0.topPanel, 0, var7)
		LeanTween.moveY(arg0.topBg, 0, var7)
	else
		LeanTween.moveY(arg0.bottomPanel, -arg0.bottomWidth, var7)
		LeanTween.moveY(arg0.topPanel, arg0.topWidth, var7)
		LeanTween.moveY(arg0.topBg, arg0.topWidth, var7)
	end

	setActive(arg0.nameTF, var0)
	setActive(arg0.stateInfo, var0)
	setActive(arg0.helpBtn, var0)
	setActive(arg0.exchangeBtn, var0)
	setImageAlpha(arg0.itemUnlockBtn, var0 and 1 or 0)
	setImageRaycastTarget(arg0.itemUnlockBtn, var0)
	setImageAlpha(arg0.speedupBtn, var0 and 1 or 0)
	setImageRaycastTarget(arg0.speedupBtn, var0)
end

function var0.switchState(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}

	if arg0.flag then
		table.insert(var0, function(arg0)
			arg0.flag = false

			arg0:switchUI(arg1, {
				-arg0.leftPanle.rect.width - 400,
				arg0.rightPanel.rect.width + 400
			}, arg0)
		end)
	end

	table.insert(var0, function(arg0)
		existCall(arg3)

		return arg0()
	end)

	if arg2 then
		table.insert(var0, function(arg0)
			arg0.flag = true

			if arg0.isFate then
				arg0:switchUI(arg1, {
					-arg0.leftPanle.rect.width - 400,
					0,
					-arg0.leftPanle.rect.width / 2
				}, arg0)
			else
				arg0:switchUI(arg1, {
					0,
					0,
					0
				}, arg0)
			end
		end)
	end

	seriesAsync(var0, arg4)
end

function var0.switchUI(arg0, arg1, arg2, arg3)
	LeanTween.cancel(arg0.leftPanle)
	LeanTween.cancel(arg0.rightPanel)
	LeanTween.cancel(arg0.centerPanel)

	arg0.isSwitchAnim = true

	parallelAsync({
		function(arg0)
			LeanTween.moveX(arg0.leftPanle, arg2[1], arg1):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			LeanTween.moveX(arg0.rightPanel, arg2[2], arg1):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			if arg2[3] then
				LeanTween.moveX(arg0.centerPanel, arg2[3], arg1):setOnComplete(System.Action(arg0))
			else
				arg0()
			end
		end
	}, function()
		arg0.isSwitchAnim = false

		return arg3()
	end)
end

function var0.createShipItem(arg0, arg1)
	local var0 = {
		init = function(arg0)
			arg0._go = arg1
			arg0._tf = tf(arg1)
			arg0.icon = arg0._tf:Find("icon")
			arg0.state = arg0._tf:Find("state")
			arg0.count = arg0._tf:Find("count")
			arg0.tip = arg0._tf:Find("tip")
		end,
		update = function(arg0, arg1, arg2)
			SetCompomentEnabled(arg0._tf, typeof(Toggle), arg1.id > 0)

			arg0.shipBluePrintVO = arg1

			setActive(arg0.state, arg0.shipBluePrintVO.id > 0)
			setActive(arg0.count, arg0.shipBluePrintVO.id > 0)

			if arg0.shipBluePrintVO.id > 0 then
				LoadSpriteAsync("shipdesignicon/" .. arg0.shipBluePrintVO:getShipVO():getPainting(), function(arg0)
					if arg0.shipBluePrintVO.id > 0 and string.find(arg0.name, arg0.shipBluePrintVO:getShipVO():getPainting()) then
						setImageSprite(arg0.icon, arg0)
					end
				end)

				local var0 = {
					tip = false,
					pursuing = arg1:isPursuing(),
					fate = arg1:canFateSimulation()
				}

				switch(arg1.state, {
					[ShipBluePrint.STATE_LOCK] = function()
						var0.state = "lock" .. (arg1:getUnlockItem() and "_item" or "")
					end,
					[ShipBluePrint.STATE_DEV] = function()
						var0.state = "research"
					end,
					[ShipBluePrint.STATE_DEV_FINISHED] = function()
						var0.state = var0.fate and "fate" or "dev"
						var0.tip = true
					end,
					[ShipBluePrint.STATE_UNLOCK] = function()
						var0.state = var0.fate and "fate" or "dev"
					end
				})
				setText(arg0.count, arg2.count > 999 and "999+" or arg2.count)
				setActive(arg0.count:Find("icon"), not var0.pursuing)
				setActive(arg0.count:Find("icon_2"), var0.pursuing)
				setText(arg0.state:Find("dev/Text"), arg0.shipBluePrintVO.level)

				if var0.fate then
					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "icon_phase_" .. arg0.shipBluePrintVO.fateLevel, arg0.state:Find("fate/Image"), true)
				end

				eachChild(arg0.state, function(arg0)
					setActive(arg0, arg0.name == var0.state)
				end)
				setActive(arg0.tip, var0.tip)
			else
				LoadSpriteAsync("shipdesignicon/empty", function(arg0)
					if arg0.shipBluePrintVO.id < 0 then
						setImageSprite(arg0.icon, arg0)
					end
				end)
				setActive(arg0.tip, false)
			end
		end,
		updateSelectedStyle = function(arg0, arg1)
			local var0 = arg1 and 0 or -25

			LeanTween.cancel(arg0.icon)
			LeanTween.moveY(arg0.icon, var0, 0.1)
		end,
		updatePursuingTip = function(arg0)
			setActive(arg0.count:Find("icon_2/tip"), arg0.shipBluePrintVO.id > 0 and arg0.shipBluePrintVO:isPursuingCostTip())
		end
	}

	var0:init()
	onButton(arg0, var0.count:Find("icon_2"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("blueprint_catchup_by_gold_help")
		})
	end, SFX_PANEL)

	return var0
end

function var0.initShips(arg0)
	arg0:checkStory()
	arg0:filterBlueprints()

	if not arg0.itemList then
		arg0.bluePrintItems = {}
		arg0.itemList = UIItemList.New(arg0.shipContainer, arg0.shipContainer:Find("ship_tpl"))

		arg0.itemList:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				onToggle(arg0, arg2, function(arg0)
					if arg0 then
						if arg0.cbTimer then
							arg0.cbTimer:Stop()

							arg0.cbTimer = nil
						end

						arg0:clearLeanTween()

						arg0.contextData.shipBluePrintVO = arg0.bluePrintItems[arg2].shipBluePrintVO

						if arg0.nowShipId ~= arg0.contextData.shipBluePrintVO.id then
							arg0.nowShipId = arg0.contextData.shipBluePrintVO.id

							arg0:switchState(var7, true, function()
								arg0:setSelectedBluePrint()
							end)
						else
							arg0:setSelectedBluePrint()
						end
					end

					arg0.bluePrintItems[arg2]:updateSelectedStyle(arg0)
				end, SFX_PANEL)

				arg0.bluePrintItems[arg2] = arg0.bluePrintItems[arg2] or arg0:createShipItem(arg2)

				local var0 = arg0.filterBlueprintVOs[arg1 + 1]

				if var0.id > 0 then
					local var1 = var0:getItemId()
					local var2 = arg0:getItemById(var1)

					arg0.bluePrintItems[arg2]:update(var0, var2)
					arg0.bluePrintItems[arg2]:updatePursuingTip()
				else
					arg0.bluePrintItems[arg2]:update(var0, nil)
				end

				triggerToggle(arg2, false)
			end
		end)
	end

	setActive(arg0.shipContainer, false)
	arg0.itemList:align(#arg0.filterBlueprintVOs)
	setActive(arg0.shipContainer, true)

	if not arg0.contextData.shipBluePrintVO or underscore.all(arg0.filterBlueprintVOs, function(arg0)
		return arg0.contextData.shipBluePrintVO.id ~= arg0.id
	end) then
		arg0.contextData.shipBluePrintVO = arg0.filterBlueprintVOs[1]
	end

	eachChild(arg0.shipContainer, function(arg0)
		if arg0.contextData.shipBluePrintVO.id == arg0.bluePrintItems[arg0].shipBluePrintVO.id then
			triggerToggle(arg0, true)
		end
	end)
end

function var0.filterBlueprints(arg0)
	if arg0.contextData.shipBluePrintVO then
		arg0.version = arg0.contextData.shipBluePrintVO:getConfig("blueprint_version")

		arg0:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, arg0.version)
	end

	arg0.filterBlueprintVOs = {}

	local var0 = 0

	for iter0, iter1 in pairs(arg0.bluePrintByIds) do
		if iter1:getConfig("blueprint_version") == arg0.version then
			table.insert(arg0.filterBlueprintVOs, iter1)

			var0 = var0 + 1
		end
	end

	for iter2 = var0, 5 do
		table.insert(arg0.filterBlueprintVOs, {
			id = -1,
			state = -1
		})
	end

	table.sort(arg0.filterBlueprintVOs, CompareFuncs({
		function(arg0)
			return -arg0.state
		end,
		function(arg0)
			return arg0.id
		end
	}))
end

function var0.setSelectedBluePrint(arg0)
	assert(arg0.contextData.shipBluePrintVO, "should exist blue print")

	local var0 = arg0.contextData.shipBluePrintVO

	arg0:updateInfo()
	arg0:updatePainting()
	arg0:updateProperty()

	local var1 = var0:isUnlock()

	setActive(arg0.taskListPanel, not var1)
	setActive(arg0.attrDisableBtn, not var1)

	if var1 then
		if not var0:canFateSimulation() or not pg.NewStoryMgr.GetInstance():IsPlayed(var0:getConfig("luck_story")) then
			arg0.isFate = false
		end

		arg0:updateMod()
		setActive(arg0.taskListPanel, false)
		setActive(arg0.attrDisableBtn, false)
	else
		arg0.isFate = false

		arg0:updateTaskList()
		triggerToggle(arg0.initBtn, true)
	end

	setActive(arg0.fittingPanel, var1 and arg0.isFate)
	setActive(arg0.modPanel, var1 and not arg0.isFate)
	setActive(arg0.itemUnlockBtn, not var1 and var0:getUnlockItem())

	if var0:isDeving() then
		arg0:emit(ShipBluePrintMediator.ON_CHECK_TAKES, var0.id)
	end
end

function var0.updateMod(arg0)
	if arg0.noUpdateMod then
		return
	end

	arg0:updateModPanel()
	arg0:updateModAdditionPanel()
end

function var0.updateModInfo(arg0, arg1)
	local var0 = arg0:getShipById(arg1.shipId)
	local var1 = arg0.contextData.shipBluePrintVO
	local var2 = intProperties(var1:getShipProperties(var0))
	local var3 = intProperties(arg1:getShipProperties(var0))
	local var4 = Clone(arg1)

	var4.level = var4:getMaxLevel()

	local var5 = intProperties(var4:getShipProperties(var0))

	local function var6(arg0, arg1, arg2, arg3)
		local var0 = arg0:findTF("attr_bg/name", arg0)
		local var1 = arg0:findTF("attr_bg/value", arg0)
		local var2 = arg0:findTF("attr_bg/max", arg0)
		local var3 = arg0:findTF("slider", arg0):GetComponent(typeof(Slider))
		local var4 = arg0:findTF("pre_slider", arg0):GetComponent(typeof(Slider))
		local var5 = arg0:findTF("exp", arg0)

		if arg1:isMaxLevel() then
			arg3 = arg2
		end

		setText(var2, arg3)
		setText(var0, AttributeType.Type2Name(arg1))
		setText(var1, arg2)

		local var6, var7 = var1:getBluePrintAddition(arg1)
		local var8 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, arg1)
		local var9 = var1:getExpRetio(var8)

		var3.value = var7 / var9

		local var10, var11 = arg1:getBluePrintAddition(arg1)
		local var12 = arg1:getExpRetio(var8)

		setText(var5, math.floor(var11) .. "/" .. var9)

		var4.value = math.floor(var10) > math.floor(var6) and 1 or var11 / var12
	end

	local var7 = 0

	for iter0, iter1 in pairs(var3) do
		if table.contains(ShipModAttr.BLUEPRINT_ATTRS, iter0) then
			local var8 = arg0.attrContainer:Find(iter0)

			var7 = var7 + 1

			var6(var8, iter0, iter1, var5[iter0] or 0)
		end
	end

	arg0.modLevel.text = arg0:formatModLvTxt(arg1.level, arg1:getMaxLevel())

	local var9 = var1:getNextLevelExp()

	if var9 == -1 then
		arg0.levelSlider.value = 1
	else
		arg0.levelSlider.value = var1.exp / var9
	end

	local var10 = arg1:getNextLevelExp()

	if var10 == -1 then
		setText(arg0.levelSliderTxt, "MAX")

		arg0.preLevelSlider.value = 1
	else
		setText(arg0.levelSliderTxt, arg1.exp .. "/" .. arg1:getNextLevelExp())

		arg0.preLevelSlider.value = arg1.level > var1.level and 1 or arg1.exp / var10
	end

	local var11, var12 = arg1:isShipModMaxLevel(var0)

	setActive(arg0.needLevelTxt, var11)
	setActive(arg0.levelSliderTxt, not var11)

	if var11 then
		setText(arg0.needLevelTxt, i18n("buleprint_need_level_tip", var12))

		arg0.levelSlider.value = 1
	end
end

function var0.inModAnim(arg0)
	return arg0.inAnim
end

function var0.formatModLvTxt(arg0, arg1, arg2)
	return "<size=45>" .. arg1 .. "</size>/<size=27>" .. arg2 .. "</size>"
end

local var8 = 0.2

function var0.doModAnim(arg0, arg1, arg2)
	arg0:clearLeanTween()

	arg0.inAnim = true

	local var0 = {}
	local var1 = arg2:getMaxLevel()

	if arg1.level ~= var1 then
		local function var2(arg0, arg1, arg2)
			arg0 = Clone(arg0)
			arg0.level = arg1
			arg0.exp = arg2

			return arg0
		end

		arg0.preLevelSlider.value = 0

		for iter0 = arg1.level, arg2.level do
			local var3 = iter0 == arg1.level and arg1.exp / arg1:getNextLevelExp() or 0
			local var4 = iter0 == arg2.level and arg2.level ~= var1 and arg2.exp / arg2:getNextLevelExp() or 1

			table.insert(var0, function(arg0)
				TweenValue(go(arg0.levelSlider), var3, var4, var8, nil, function(arg0)
					arg0.levelSlider.value = arg0
				end, function()
					local var0 = iter0 == arg1.level and arg1 or var2(arg1, iter0, 0)
					local var1 = iter0 == arg2.level and arg2 or var2(arg1, iter0 + 1, 0)

					arg0:doAttrsAinm(var0, var1, arg0)

					arg0.modLevel.text = arg0:formatModLvTxt(var1.level, var1)
				end)
			end)
		end

		table.insert(arg0.leanTweens, arg0.levelSlider)
	else
		var1 = arg2:getMaxFateLevel()

		local function var5(arg0, arg1, arg2)
			arg0 = Clone(arg0)
			arg0.fateLevel = arg1
			arg0.exp = arg2

			return arg0
		end

		arg0.prePhaseSlider.value = 0

		for iter1 = arg1.fateLevel, arg2.fateLevel do
			local var6 = iter1 == arg1.fateLevel and arg1.exp / arg1:getNextFateLevelExp() or 0
			local var7 = iter1 == arg2.fateLevel and arg2.fateLevel ~= var1 and arg2.exp / arg2:getNextFateLevelExp() or 1

			table.insert(var0, function(arg0)
				TweenValue(go(arg0.phaseSlider), var6, var7, var8, nil, function(arg0)
					arg0.phaseSlider.value = arg0
				end, function()
					if iter1 ~= arg1.fateLevel or not arg1 then
						local var0 = var5(arg1, iter1, 0)
					end

					local var1 = iter1 == arg2.fateLevel and arg2 or var5(arg1, iter1 + 1, 0)

					arg0:updateFittingAttrPanel(var1)
					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.min(var1.fateLevel + 1, var1:getMaxFateLevel()), arg0.phasePic, true)
					arg0()
				end)
			end)
		end

		table.insert(arg0.leanTweens, arg0.phaseSlider)
	end

	seriesAsync(var0, function()
		arg0.noUpdateMod = false

		arg0:updateMod()

		arg0.inAnim = false
	end)
end

function var0.doAttrsAinm(arg0, arg1, arg2, arg3)
	local var0 = {}
	local var1 = arg0:getShipById(arg1.shipId)
	local var2 = intProperties(arg1:getShipProperties(var1))
	local var3 = intProperties(arg2:getShipProperties(var1))

	for iter0, iter1 in ipairs(ShipModAttr.BLUEPRINT_ATTRS) do
		if iter1 ~= AttributeType.AntiAircraft then
			local var4 = arg0.attrContainer:Find(iter1)
			local var5 = arg0:findTF("attr_bg/value", var4):GetComponent(typeof(Text))
			local var6 = arg0:findTF("slider", var4):GetComponent(typeof(Slider))
			local var7 = arg0:findTF("pre_slider", var4):GetComponent(typeof(Slider))
			local var8 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, iter1)
			local var9 = arg1:getExpRetio(var8)
			local var10 = var2[iter1]
			local var11 = var3[iter1]
			local var12, var13 = arg1:getBluePrintAddition(iter1)
			local var14, var15 = arg2:getBluePrintAddition(iter1)
			local var16 = var13 / var9
			local var17 = var15 / var9

			var7.value = 0

			table.insert(var0, function(arg0)
				arg0:doAttrAnim(var6, var5, var16, var17, math.floor(var12), math.floor(var14), var10, var11, arg0)
			end)
		end
	end

	parallelAsync(var0, arg3)
end

local var9 = 0.1

function var0.doAttrAnim(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	table.insert(arg0.leanTweens, arg1)

	local var0 = {}

	for iter0 = arg5, arg6 do
		local var1 = iter0 == arg5 and arg3 or 0
		local var2 = iter0 == arg6 and arg4 or 1

		table.insert(var0, function(arg0)
			TweenValue(go(arg1), var1, var2, var9, nil, function(arg0)
				arg1.value = arg0
			end, function()
				arg2.text = arg8 - math.min(arg6 - iter0, arg8 - arg7)

				arg0()
			end)
		end)
	end

	seriesAsync(var0, function()
		arg9()
	end)
end

function var0.clearLeanTween(arg0, arg1)
	for iter0, iter1 in pairs(arg0.leanTweens) do
		if LeanTween.isTweening(go(iter1)) then
			LeanTween.cancel(go(iter1))
		end
	end

	if arg0.inAnim then
		arg0.inAnim = nil

		if not arg1 then
			arg0.noUpdateMod = false
		end
	end

	arg0.leanTweens = {}
end

function var0.updateModPanel(arg0)
	local var0 = arg0.contextData.shipBluePrintVO
	local var1 = arg0:getShipById(var0.shipId)
	local var2 = var0:getConfig("strengthen_item")
	local var3 = arg0:getItemById(var2)
	local var4 = var3.count == 0 and var0:isPursuing()
	local var5 = 0
	local var6
	local var7

	if var4 then
		local var8 = getProxy(TechnologyProxy)

		var6 = math.min(var8:calcMaxPursuingCount(var0), var0:getUseageMaxItem())

		function var7(arg0)
			local var0 = arg0 * var0:getItemExp()
			local var1 = Clone(var0)

			var1:addExp(var0)
			arg0:updateModInfo(var1)
			setText(arg0.calcTxt, arg0)

			local var2 = var0:isRarityUR()
			local var3 = TechnologyProxy.getPursuingDiscount(var8:getPursuingTimes(var2) + var5 + 1, var2)

			setText(arg0.itemInfoIcon:Find("icon_bg/count"), var0:getPursuingPrice(var3))
			setActive(arg0.itemInfo:Find("no_cost"), var3 == 0)
			setActive(arg0.itemInfo:Find("discount"), var3 > 0 and var3 < 100)

			if var3 > 0 and var3 < 100 then
				setText(arg0.itemInfo:Find("discount/Text"), 100 - var3 .. "%OFF")
			end

			setActive(arg0.modBtn:Find("pursuing_cost"), var5 > 0)
			setText(arg0.modBtn:Find("pursuing_cost/Text"), var8:calcPursuingCost(var0, arg0))
		end

		local var9 = {
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		}

		updateDrop(arg0.itemInfoIcon, var9)
		onButton(arg0, arg0.itemInfoIcon, function()
			if LOCK_TECHNOLOGY_PURSUING_TIP then
				arg0:emit(BaseUI.ON_DROP, var9)
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("blueprint_catchup_by_gold_help")
				})
			end
		end, SFX_PANEL)
		setScrollText(findTF(arg0.itemInfo, "name/Text"), var9:getConfig("name"))
		setText(arg0.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold))
		setText(arg0.itemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(arg0.modBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(arg0, arg0.modBtn, function()
			if arg0:inModAnim() then
				return
			end

			if var5 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", var8:calcPursuingCost(var0, var5)),
				onYes = function()
					arg0:emit(ShipBluePrintMediator.ON_PURSUING, var0.id, var5)
				end
			})
		end, SFX_PANEL)
	else
		var6 = math.min(var3.count, var0:getUseageMaxItem())

		function var7(arg0)
			local var0 = arg0 * var0:getItemExp()
			local var1 = Clone(var0)

			var1:addExp(var0)
			arg0:updateModInfo(var1)
			setText(arg0.calcTxt, arg0)
		end

		updateDrop(arg0.itemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = var3.id
		})
		onButton(arg0, arg0.itemInfoIcon, function()
			ItemTipPanel.ShowItemTipbyID(var3.id, i18n("title_item_ways", var3:getConfig("name")))
		end, SFX_PANEL)
		setScrollText(findTF(arg0.itemInfo, "name/Text"), var3:getConfig("name"))
		setText(arg0.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. var3.count)
		setActive(arg0.itemInfo:Find("no_cost"), false)
		setActive(arg0.itemInfo:Find("discount"), false)
		setActive(arg0.modBtn:Find("pursuing_cost"), false)
		onButton(arg0, arg0.modBtn, function()
			if arg0:inModAnim() then
				return
			end

			if var5 == 0 then
				return
			end

			arg0:emit(ShipBluePrintMediator.ON_MOD, var0.id, var5)
		end, SFX_PANEL)
	end

	var7(var5)

	local var10 = 0
	local var11 = Clone(var0)
	local var12 = var0:getItemExp()

	while var11.level < var11:getMaxLevel() and var1.level >= var11:getStrengthenConfig(math.min(var11.level + 1, var11:getMaxLevel())).need_lv do
		var10 = var10 + 1

		var11:addExp(var12)
	end

	local var13 = math.min(var6, var10)

	pressPersistTrigger(arg0.calcMinusBtn, 0.5, function(arg0)
		if arg0:inModAnim() or var0:isMaxLevel() or var5 == 0 then
			arg0()

			return
		end

		var5 = var5 - 1

		var7(var5)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0.calcPlusBtn, 0.5, function(arg0)
		if arg0:inModAnim() or var0:isMaxLevel() or var5 == var13 then
			arg0()

			return
		end

		var5 = var5 + 1

		var7(var5)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0, arg0.calcMaxBtn, function()
		if arg0:inModAnim() or var0:isMaxLevel() or var5 == var13 then
			return
		end

		var5 = var13

		var7(var5)
	end, SFX_PANEL)
	setActive(arg0.calcMaxBtn, not var4)

	local var14 = var0:canFateSimulation()

	if var14 then
		onButton(arg0, arg0.fittingBtn, function()
			if arg0.isSwitchAnim then
				return
			end

			setActive(arg0.fittingBtnEffect, true)

			arg0.cbTimer = Timer.New(function()
				arg0.cbTimer = nil

				setActive(arg0.fittingBtnEffect, false)
				arg0:switchState(var7, true, function()
					arg0.isFate = true

					setActive(arg0.fittingPanel, arg0.isFate)
					setActive(arg0.modPanel, not arg0.isFate)

					if not PlayerPrefs.HasKey("first_fate") then
						triggerButton(arg0.helpBtn)
						PlayerPrefs.SetInt("first_fate", 1)
						PlayerPrefs.Save()
					end
				end)
			end, 0.6)

			arg0.cbTimer:Start()
		end, SFX_PANEL)
		arg0:updateFittingPanel()
		pg.NewStoryMgr.GetInstance():Play(var0:getConfig("luck_story"), function(arg0)
			if arg0 then
				arg0:buildStartAni("fateStartWindow", function()
					triggerButton(arg0.fittingBtn)
				end)
			end
		end)
	end

	setActive(arg0.calcPanel, not var14)
	setActive(arg0.fittingBtn, var14)
	setActive(arg0.fittingBtnEffect, false)
end

function var0.updateFittingPanel(arg0)
	local var0 = arg0.contextData.shipBluePrintVO
	local var1 = arg0:getShipById(var0.shipId)
	local var2 = var0:getConfig("strengthen_item")
	local var3 = arg0:getItemById(var2)
	local var4 = var3.count == 0 and var0:isPursuing()
	local var5 = 0
	local var6
	local var7

	if var4 then
		local var8 = getProxy(TechnologyProxy)

		var6 = math.min(var8:calcMaxPursuingCount(var0), var0:getFateUseageMaxItem())

		function var7(arg0)
			local var0 = arg0 * var0:getItemExp()
			local var1 = Clone(var0)

			var1:addExp(var0)
			arg0:updateFittingInfo(var1)
			setText(arg0.fittingCalcTxt, arg0)

			local var2 = var0:isRarityUR()
			local var3 = TechnologyProxy.getPursuingDiscount(var8:getPursuingTimes(var2) + var5 + 1, var2)

			setText(arg0.fittingItemInfoIcon:Find("icon_bg/count"), var0:getPursuingPrice(var3))
			setActive(arg0.fittingItemInfo:Find("no_cost"), var3 == 0)
			setActive(arg0.fittingItemInfo:Find("discount"), var3 > 0 and var3 < 100)

			if var3 > 0 and var3 < 100 then
				setText(arg0.fittingItemInfo:Find("discount/Text"), 100 - var3 .. "%OFF")
			end

			setActive(arg0.fittingConfirmBtn:Find("pursuing_cost"), arg0 > 0)
			setText(arg0.fittingConfirmBtn:Find("pursuing_cost/Text"), var8:calcPursuingCost(var0, arg0))
		end

		local var9 = {
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		}

		updateDrop(arg0.fittingItemInfoIcon, var9)
		onButton(arg0, arg0.fittingItemInfoIcon, function()
			if LOCK_TECHNOLOGY_PURSUING_TIP then
				arg0:emit(BaseUI.ON_DROP, var9)
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("blueprint_catchup_by_gold_help")
				})
			end
		end, SFX_PANEL)
		setScrollText(findTF(arg0.fittingItemInfo, "name/Text"), var9:getConfig("name"))
		setText(arg0.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold))
		setText(arg0.fittingItemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(arg0.fittingConfirmBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(arg0, arg0.fittingConfirmBtn, function()
			if arg0:inModAnim() then
				return
			end

			if var5 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", var8:calcPursuingCost(var0, var5)),
				onYes = function()
					arg0:emit(ShipBluePrintMediator.ON_PURSUING, var0.id, var5)
				end
			})
		end, SFX_PANEL)
	else
		var6 = math.min(var3.count, var0:getFateUseageMaxItem())

		function var7(arg0)
			local var0 = arg0 * var0:getItemExp()
			local var1 = Clone(var0)

			var1:addExp(var0)
			arg0:updateFittingInfo(var1)
			setText(arg0.fittingCalcTxt, arg0)
		end

		updateDrop(arg0.fittingItemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = var3.id
		})
		onButton(arg0, arg0.fittingItemInfoIcon, function()
			ItemTipPanel.ShowItemTipbyID(var3.id, i18n("title_item_ways", var3:getConfig("name")))
		end, SFX_PANEL)
		setScrollText(arg0.fittingItemInfo:Find("name/Text"), var3:getConfig("name"))
		setText(arg0.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. var3.count)
		setActive(arg0.fittingItemInfo:Find("no_cost"), false)
		setActive(arg0.fittingItemInfo:Find("discount"), false)
		setActive(arg0.fittingConfirmBtn:Find("pursuing_cost"), false)
		onButton(arg0, arg0.fittingConfirmBtn, function()
			if arg0:inModAnim() then
				return
			end

			if var5 == 0 then
				return
			end

			arg0:emit(ShipBluePrintMediator.ON_MOD, var0.id, var5)
		end, SFX_PANEL)
	end

	setText(arg0.fittingAttrPanel:Find("attr/name"), AttributeType.Type2Name(AttributeType.Luck))
	setText(arg0.fittingPanel:Find("desc/top/text/Text"), i18n("fate_phase_word"))
	onButton(arg0, arg0.fittingCancelBtn, function()
		arg0:switchState(var7, true, function()
			arg0.isFate = false

			setActive(arg0.fittingPanel, arg0.isFate)
			setActive(arg0.modPanel, not arg0.isFate)
		end)
	end, SFX_PANEL)

	local var10 = 0
	local var11 = Clone(var0)
	local var12 = var0:getItemExp()

	while var11.fateLevel < var11:getMaxFateLevel() and var1.level >= var11:getFateStrengthenConfig(math.min(var11.fateLevel + 1, var11:getMaxFateLevel())).need_lv do
		var10 = var10 + 1

		var11:addExp(var12)
	end

	local var13 = math.min(var6, var10)

	pressPersistTrigger(arg0.fittingCalcMinusBtn, 0.5, function(arg0)
		if arg0:inModAnim() or var0:isMaxFateLevel() or var5 == 0 then
			arg0()

			return
		end

		var5 = math.max(var5 - 1, 0)

		var7(var5)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0.fittingCalcPlusBtn, 0.5, function(arg0)
		if arg0:inModAnim() or var0:isMaxFateLevel() or var5 == var13 then
			arg0()

			return
		end

		var5 = math.max(math.min(var5 + 1, var13), 0)

		var7(var5)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0, arg0.fittingCalcMaxBtn, function()
		if arg0:inModAnim() or var0:isMaxFateLevel() or var5 == var13 then
			return
		end

		var5 = var13

		var7(var5)
	end, SFX_PANEL)
	setActive(arg0.fittingCalcMaxBtn, not var4)

	local var14 = arg0.fittingAttrPanel:Find("phase_panel")
	local var15 = var14:Find("phase_tpl")

	setActive(var15, false)

	local var16 = {
		0,
		-60,
		0,
		60
	}
	local var17 = {}

	for iter0 = 1, var0:getMaxFateLevel() do
		local var18 = var14:Find("phase_" .. iter0) or cloneTplTo(var15, var14, "phase_" .. iter0)
		local var19 = var0:getFateStrengthenConfig(iter0)

		assert(var19.special == 1 and type(var19.special_effect) == "table", "without fate config")

		local var20 = var19.special_effect
		local var21

		for iter1, iter2 in ipairs(var20) do
			if iter2[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				var21 = iter2[2][2]

				break
			end
		end

		for iter3, iter4 in ipairs({
			"off",
			"on"
		}) do
			setActive(var18:Find(iter4 .. "/icon"), not var21)
			setActive(var18:Find(iter4 .. "/skill"), var21)
			setActive(var18:Find(iter4 .. "/icon/line"), var16[iter0])
			setActive(var18:Find(iter4 .. "/skill/line"), var16[iter0])

			if var16[iter0] then
				var18:Find(iter4 .. "/icon/line").localEulerAngles = Vector3(0, 0, var16[iter0])
				var18:Find(iter4 .. "/skill/line").localEulerAngles = Vector3(0, 0, var16[iter0])

				GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", iter0 .. "_" .. iter4, var18:Find(iter4 .. "/icon/icon"), true)
			end
		end

		if var21 then
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_" .. var21, "", var18:Find("off/skill/icon"), true)
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_on_" .. var21, "", var18:Find("on/skill/icon"), true)

			var17[iter0] = 55
		else
			var17[iter0] = 40
		end

		onButton(arg0, var18, function()
			arg0:showFittingMsgPanel(iter0)
		end, SFX_PANEL)
	end

	local var22 = Vector2.zero
	local var23 = Vector2.zero
	local var24 = Vector2.zero

	for iter5 = 1, var0:getMaxFateLevel() do
		local var25 = var14:Find("phase_" .. iter5)

		setAnchoredPosition(var25, var22)

		var23.x = math.min(var23.x, var22.x)
		var23.y = math.min(var23.y, var22.y)
		var24.x = math.max(var24.x, var22.x)
		var24.y = math.max(var24.y, var22.y)

		if var16[iter5] then
			var22 = var22 + (var17[iter5] + var17[iter5 + 1]) * Vector2(math.cos(math.pi * var16[iter5] / 180), math.sin(math.pi * var16[iter5] / 180))
		end
	end

	setSizeDelta(var14, var24 - var23)
	setAnchoredPosition(var14, {
		y = -var24.y
	})
	var7(var5)
end

function var0.updateFittingInfo(arg0, arg1)
	local var0 = arg0:getShipById(arg1.shipId)
	local var1 = arg0.contextData.shipBluePrintVO

	arg0:updateFittingAttrPanel(var1, arg1)
	GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.max(arg1.fateLevel, 1), arg0.phasePic, true)

	local var2 = var1:getNextFateLevelExp()

	if var2 == -1 then
		arg0.phaseSlider.value = 1
	else
		arg0.phaseSlider.value = var1.exp / var2
	end

	local var3 = arg1:getNextFateLevelExp()

	if var3 == -1 then
		setText(arg0.phaseSliderTxt, "MAX")

		arg0.prePhaseSlider.value = 1
	else
		local var4 = math.floor(arg1.exp / arg1:getNextFateLevelExp() * 100)

		setText(arg0.phaseSliderTxt, tostring(var4) .. "%")

		arg0.prePhaseSlider.value = arg1.fateLevel > var1.fateLevel and 1 or arg1.exp / var3
	end

	local var5, var6 = arg1:isShipModMaxFateLevel(var0)

	setActive(arg0.fittingNeedMask, var5)

	if var5 then
		setText(arg0:findTF("limit", arg0.fittingNeedMask), i18n("buleprint_need_level_tip", var6))

		arg0.phaseSlider.value = 1
	end
end

function var0.updateFittingAttrPanel(arg0, arg1, arg2)
	setText(arg0:findTF("attr/name/Text", arg0.fittingAttrPanel), " + " .. defaultValue((arg2 or arg1):attrSpecialAddition()[AttributeType.Luck], 0))

	arg0.blinkTarget = arg0.blinkTarget or {
		{},
		{}
	}

	for iter0 = 1, arg1:getMaxFateLevel() do
		local var0 = arg0:findTF("phase_panel/phase_" .. iter0, arg0.fittingAttrPanel)
		local var1 = arg0:findTF("off", var0)
		local var2 = arg0:findTF("on", var0)

		if arg2 and iter0 > arg1.fateLevel and iter0 <= arg2.fateLevel then
			setActive(var1, true)
			setActive(var2, true)

			if not table.contains(arg0.blinkTarget[1], var1) then
				table.insert(arg0.blinkTarget[1], var1)
				table.insert(arg0.blinkTarget[2], var2)
			end
		else
			local var3 = table.indexof(arg0.blinkTarget[1], var1)

			if var3 then
				table.remove(arg0.blinkTarget[1], var3)
				table.remove(arg0.blinkTarget[2], var3)
			end

			setActive(var1, iter0 > arg1.fateLevel)
			setActive(var2, iter0 <= arg1.fateLevel)

			var1:GetComponent(typeof(CanvasGroup)).alpha = 1
			var2:GetComponent(typeof(CanvasGroup)).alpha = 1
		end
	end

	if #arg0.blinkTarget[1] == 0 then
		LeanTween.cancel(go(arg0.fittingAttrPanel))
	elseif not LeanTween.isTweening(go(arg0.fittingAttrPanel)) then
		LeanTween.value(go(arg0.fittingAttrPanel), 1, 0, 0.8):setOnUpdate(System.Action_float(function(arg0)
			for iter0, iter1 in ipairs(arg0.blinkTarget[1]) do
				iter1:GetComponent(typeof(CanvasGroup)).alpha = arg0
			end

			for iter2, iter3 in ipairs(arg0.blinkTarget[2]) do
				iter3:GetComponent(typeof(CanvasGroup)).alpha = 1 - arg0
			end
		end)):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(0)
	end
end

function var0.updateModAdditionPanel(arg0)
	local var0 = arg0.contextData.shipBluePrintVO
	local var1 = var0:specialStrengthens()

	for iter0 = arg0.modAdditionContainer.childCount - 1, #var1 do
		arg0:cloneTplTo(arg0.modAdditionTpl, arg0.modAdditionContainer)
	end

	local var2 = arg0.modAdditionContainer.childCount

	for iter1 = 1, var2 do
		local var3 = iter1 <= #var1
		local var4 = arg0.modAdditionContainer:GetChild(iter1 - 1)

		setActive(var4, var3)

		if var3 then
			arg0:updateAdvanceTF(var0, var4, var1[iter1])
		end
	end
end

function var0.updateAdvanceTF(arg0, arg1, arg2, arg3)
	local var0 = arg1.level < arg3.level

	setActive(arg2:Find("mask"), var0)

	if var0 then
		setText(arg2:Find("mask/content/Text"), i18n("blueprint_mod_addition_lock", arg3.level))
	end

	local var1 = arg3.des
	local var2 = arg3.extraDes or {}
	local var3 = arg2:Find("additions")

	removeAllChildren(var3)

	local var4 = arg0:findTF("scroll_rect/info", arg0.modAdditionPanel)

	local function var5(arg0, arg1)
		local var0 = arg1[2]
		local var1 = pg.ship_data_breakout[var0].pre_id
		local var2 = Ship.New({
			configId = var0
		})
		local var3 = Ship.New({
			configId = var1
		}):getStar()
		local var4 = var2:getStar()
		local var5 = arg0:Find("star_tpl")
		local var6 = arg0:Find("stars")
		local var7 = arg0:Find("pre_stars")

		removeAllChildren(var6)
		removeAllChildren(var7)

		for iter0 = 1, var3 do
			cloneTplTo(var5, var6)
		end

		for iter1 = 1, var4 do
			cloneTplTo(var5, var7)
		end
	end

	for iter0 = 1, #var1 do
		local var6 = cloneTplTo(var4, var3)
		local var7 = var6:Find("text_tpl")
		local var8 = var6:Find("breakout_tpl")

		setActive(var7, false)
		setActive(var6:Find("attr_tpl"), false)
		setActive(var8, false)
		setActive(var6:Find("empty_tpl"), false)

		if var1[iter0] then
			if var1[iter0][1] == ShipBluePrint.STRENGTHEN_TYPE_BREAKOUT then
				setActive(var8, true)
				var5(var8, var1[iter0])
			else
				setActive(var7, true)
				setScrollText(var7:Find("Text"), var1[iter0][3])
			end
		end
	end

	for iter1 = 1, #var2 do
		local var9 = cloneTplTo(var4, var3)
		local var10 = var9:Find("text_tpl")

		setActive(var10, true)
		setActive(var9:Find("attr_tpl"), false)
		setActive(var9:Find("breakout_tpl"), false)
		setActive(var9:Find("empty_tpl"), false)
		setScrollText(var10:Find("Text"), var2[iter1])
	end
end

function var0.updateInfo(arg0)
	local var0 = arg0.contextData.shipBluePrintVO
	local var1

	if var0:isFetched() then
		var1 = arg0.shipVOs[var0.shipId]
	end

	var1 = var1 or var0:getShipVO()

	local var2 = var1:getConfigTable()
	local var3 = var1:getName()

	setText(arg0.shipName, var3)
	setText(arg0.englishName, var2.english_name)
	removeAllChildren(arg0.stars)

	local var4 = var1:getStar()
	local var5 = var1:getMaxStar()

	for iter0 = 1, var5 do
		cloneTplTo(arg0.shipInfoStarTpl, arg0.stars, "star_" .. iter0)
	end

	local var6 = var5 - var4

	for iter1 = 1, var6 do
		local var7 = arg0.stars:GetChild(var5 - iter1)

		setActive(var7:Find("star_tpl"), false)
		setActive(var7:Find("empty_star_tpl"), true)
	end

	local var8 = GetSpriteFromAtlas("shiptype", var1:getShipType())

	if not var8 then
		warning("找不到船形, shipConfigId: " .. var1.configId)
	end

	setImageSprite(arg0.shipType, var8, true)

	local var9 = var0:isLock()

	setActive(arg0.finishedBtn, var0:isFinished())

	local var10 = var0:isDeving()

	setActive(arg0.progressPanel, var10)

	if not var10 then
		setActive(arg0.speedupBtn, false)
	end

	if var10 then
		arg0:updateTasksProgress()
	end

	local var11, var12 = var0:isFinishPrevTask()

	if var9 and not var12 then
		if var11 then
			for iter2, iter3 in ipairs(var0:getOpenTaskList()) do
				arg0:emit(ShipBluePrintMediator.ON_FINISH_TASK, iter3)
			end

			var12 = true
		else
			local var13 = getProxy(TaskProxy)
			local var14 = var0:getOpenTaskList()

			for iter4, iter5 in ipairs(var14) do
				local var15 = var13:getTaskVO(iter5)
				local var16 = iter4 > arg0.lockPanel.childCount and cloneTplTo(arg0.lockBtn, arg0.lockPanel) or arg0.lockPanel:GetChild(iter4 - 1)

				setActive(var16, true)

				local var17 = var15:getProgress()
				local var18 = var15:getConfig("target_num")

				setText(arg0:findTF("Text", var16), (var18 <= var17 and setColorStr(var17, COLOR_GREEN) or var17) .. "/" .. var18)
			end

			for iter6 = #var14 + 1, arg0.lockPanel.childCount do
				setActive(arg0.lockPanel:GetChild(iter6 - 1), false)
			end
		end
	end

	setText(arg0:findTF("Text", arg0.openCondition), var0:getConfig("unlock_word"))
	setActive(arg0.openCondition, var9)
	setActive(arg0.startBtn, var9 and var12)
	setActive(arg0.lockPanel, var9 and not var12)
end

function var0.updateTasksProgress(arg0)
	local var0 = arg0.contextData.shipBluePrintVO
	local var1 = var0:getTaskIds()

	for iter0 = arg0.progressContainer.childCount, #var1 do
		cloneTplTo(arg0.progressTpl, arg0.progressContainer)
	end

	local var2 = arg0.progressContainer.childCount

	for iter1 = 1, var2 do
		local var3 = arg0.progressContainer:GetChild(iter1 - 1)
		local var4 = iter1 <= #var1

		setActive(var3, var4)

		if var4 then
			local var5 = var0:getTaskStateById(var1[iter1])

			setActive(findTF(var3, "complete"), var5 == ShipBluePrint.TASK_STATE_FINISHED)
			setActive(findTF(var3, "lock"), var5 == ShipBluePrint.TASK_STATE_LOCK or var5 == ShipBluePrint.TASK_STATE_WAIT)
			setActive(findTF(var3, "working"), var5 == ShipBluePrint.TASK_STATE_ACHIEVED or var5 == ShipBluePrint.TASK_STATE_OPENING or var5 == ShipBluePrint.TASK_STATE_START)
		end
	end

	local var6 = var0:getConfig("blueprint_version")
	local var7 = pg.gameset.technology_catchup_itemid.description[var6]

	if var7 then
		local var8 = var0:getTaskStateById(var1[1])
		local var9 = var0:getTaskStateById(var1[4])
		local var10 = var7[1]
		local var11 = getProxy(BagProxy):getItemCountById(var10)

		setActive(arg0.speedupBtn, (var8 == ShipBluePrint.TASK_STATE_START or var9 == ShipBluePrint.TASK_STATE_START) and var11 > 0)
	else
		setActive(arg0.speedupBtn, false)
	end
end

function var0.updatePainting(arg0)
	local var0 = arg0.contextData.shipBluePrintVO:getShipVO()

	if arg0.lastPaintingName and arg0.lastPaintingName ~= var0:getPainting() then
		retPaintingPrefab(arg0.painting, arg0.lastPaintingName)
	end

	local var1 = var0:getPainting()

	setPaintingPrefab(arg0.painting, var1, "tuzhi")

	arg0.lastPaintingName = var1

	arg0:paintBreath()
end

function var0.updateProperty(arg0)
	local var0 = arg0.contextData.shipBluePrintVO
	local var1 = var0:getShipVO()

	arg0.propertyPanel:initProperty(var1.configId, PropertyPanel.TypeFlat)

	local var2 = var2[var1.configId].buff_list_display

	for iter0 = arg0.skillPanel.childCount, #var2 - 1 do
		cloneTplTo(arg0.skillTpl, arg0.skillPanel)
	end

	local var3 = arg0.skillPanel.childCount

	for iter1 = 1, var3 do
		local var4 = arg0.skillPanel:GetChild(iter1 - 1)
		local var5 = iter1 <= #var2
		local var6 = findTF(var4, "icon")

		if var5 then
			local var7 = var2[iter1]
			local var8 = getSkillConfig(var7)

			LoadImageSpriteAsync("skillicon/" .. var8.icon, var6)
			onButton(arg0, var4, function()
				arg0:emit(ShipBluePrintMediator.SHOW_SKILL_INFO, var8.id, {
					id = var8.id,
					level = pg.skill_data_template[var8.id].max_level
				}, function()
					return
				end)
			end, SFX_PANEL)
		end

		setActive(var4, var5)
	end

	setActive(arg0.skillArrLeft, #var2 > 3)
	setActive(arg0.skillArrRight, #var2 > 3)

	if #var2 > 3 then
		onScroll(arg0, arg0.skillRect, function(arg0)
			setActive(arg0.skillArrLeft, arg0.x > 0.01)
			setActive(arg0.skillArrRight, arg0.x < 0.99)
		end)
	else
		GetComponent(arg0.skillRect, typeof(ScrollRect)).onValueChanged:RemoveAllListeners()
	end

	setAnchoredPosition(arg0.skillPanel, {
		x = 0
	})

	local var9 = var0:getConfig("simulate_dungeon")

	setActive(arg0.simulationBtn, var9 ~= 0)
	onButton(arg0, arg0.simulationBtn, function()
		if var9 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tech_simulate_closed"))
		else
			local var0 = i18n("blueprint_simulation_confirm_" .. var0.id)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0,
				onYes = function()
					arg0:emit(ShipBluePrintMediator.SIMULATION_BATTLE, var9)
				end
			})
		end
	end, SFX_CONFIRM)
end

function var0.updateTaskList(arg0)
	local var0 = arg0.contextData.shipBluePrintVO
	local var1 = var0:getTaskIds()

	for iter0 = arg0.taskContainer.childCount, #var1 do
		cloneTplTo(arg0.taskTpl, arg0.taskContainer)
	end

	local var2 = arg0.taskContainer.childCount

	for iter1 = 1, var2 do
		local var3 = arg0.taskContainer:GetChild(iter1 - 1)

		setActive(var3, iter1 <= #var1)

		if arg0.taskTFs[iter1] then
			arg0.taskTFs[iter1]:clear()
		end

		if iter1 <= #var1 then
			if not arg0.taskTFs[iter1] then
				arg0.taskTFs[iter1] = arg0:createTask(var3)
			end

			local var4 = var1[iter1]
			local var5 = arg0:getTaskById(var4)

			if var0.duration > 0 then
				var5.leftTime = var0:getTaskOpenTimeStamp(var4) - var0.duration
			end

			var5.taskState = var0:getTaskStateById(var4)
			var5.dueTime = var0:getTaskOpenTimeStamp(var4)
			var5.index = iter1

			arg0.taskTFs[iter1]:update(var5)
		end
	end
end

function var0.createTask(arg0, arg1)
	local var0 = {
		title = arg0:findTF("title/name", arg1),
		desc = arg0:findTF("desc/Text", arg1),
		timerTF = arg0:findTF("title/timer", arg1),
		timerTFTxt = arg0:findTF("title/timer/Text", arg1),
		timerOpen = arg0:findTF("title/timer/open", arg1),
		timerClose = arg0:findTF("title/timer/close", arg1),
		maskAchieved = arg0:findTF("title/slider/complete", arg1),
		tip = arg0:findTF("title/tip", arg1),
		commitBtn = arg0:findTF("desc/commit_panel/commit_btn", arg1),
		itemInfo = arg0:findTF("desc/item_info", arg1)
	}

	var0.itemContainer = arg0:findTF("items", var0.itemInfo)
	var0.itemTpl = arg0:findTF("item_tpl", var0.itemContainer)
	var0.numberTF = arg0:findTF("title/number", arg1)
	var0.progressTF = arg0:findTF("title/slider", arg1)
	var0.progessSlider = var0.progressTF:GetComponent(typeof(Slider))
	var0.lockBtn = arg0:findTF("desc/commit_panel/lock_btn", arg1)
	var0.itemCount = var0.itemTpl:Find("award/icon_bg/count")
	var0.progres = arg0:findTF("desc/commit_panel/progress", arg1)
	var0.progreshadow = arg0:findTF("title/shadow", arg1)
	var0.check = findTF(arg1, "title/complete")
	var0.lock = findTF(arg1, "title/lock")
	var0.working = findTF(arg1, "title/working")
	var0.pause = findTF(arg1, "title/pause")
	var0.pauseLock = findTF(arg1, "title/pause_lock")
	var0.view = arg0

	onToggle(arg0, arg1, function(arg0)
		setActive(var0.desc, arg0)
		setActive(var0.progreshadow, arg0)

		if arg0 then
			Canvas.ForceUpdateCanvases()

			local var0 = arg0.taskContainer.parent.transform:InverseTransformPoint(arg1.position).y
			local var1 = var0 - arg1.rect.height
			local var2 = arg0.taskContainer.parent.transform.rect
			local var3 = 0

			if var1 < var2.yMin then
				var3 = var2.yMin - var1
			end

			if var0 > var2.yMax then
				var3 = var2.yMax - var0
			end

			local var4 = arg0.taskContainer.localPosition

			var4.y = var4.y + var3
			arg0.taskContainer.localPosition = var4
			var0.progreshadow.localPosition = Vector3(39, -(148 + var0.desc.rect.height - 150))
		end
	end, SFX_PANEL)

	function var0.update(arg0, arg1)
		arg0:clearTimer()

		arg0.autoCommit = true
		arg0.isExpTask = false

		removeOnButton(arg0.commitBtn)
		arg0:updateItemInfo(arg1)
		arg0:updateView(arg1)
		arg0:updateProgress(arg1)
	end

	function var0.updateItemInfo(arg0, arg1)
		arg0.taskVO = arg1

		changeToScrollText(arg0.title, arg1:getConfig("name"))
		setText(arg0.desc, arg1:getConfig("desc") .. "\n\n")

		local var0
		local var1 = arg1:getConfig("target_num")
		local var2 = arg1:getConfig("sub_type")

		if var2 == TASK_SUB_TYPE_GIVE_ITEM then
			arg0.autoCommit = false
			var0 = tonumber(arg1:getConfig("target_id"))
		elseif var2 == TASK_SUB_TYPE_PLAYER_RES then
			arg0.autoCommit = false
			var0 = id2ItemId(tonumber(arg1:getConfig("target_id")))
		elseif var2 == TASK_SUB_TYPE_BATTLE_EXP then
			arg0.isExpTask = true
			var0 = 59000
		end

		setActive(arg0.itemContainer, not arg0.autoCommit or arg0.isExpTask)

		if var0 then
			updateDrop(arg0.itemTpl:Find("award"), {
				type = 2,
				id = var0,
				count = var1
			})
			setText(arg0.itemCount, var1 > 1000 and math.floor(var1 / 1000) .. "K" or var1)
		end

		setText(arg0.numberTF, arg1.index)
	end

	function var0.updateView(arg0, arg1)
		local var0 = arg1.taskState
		local var1 = false
		local var2 = false
		local var3 = false

		if var0 == ShipBluePrint.TASK_STATE_PAUSE and arg1.leftTime then
			local var4 = getProxy(TaskProxy):getTaskVO(arg1.id)

			var1 = var4 and var4:isFinish()
			var3 = arg1.leftTime > 0
			var2 = var4 and var4:isReceive()

			if arg1.leftTime > 0 then
				setText(var0.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(arg1.leftTime))
			end
		end

		setActive(arg0.pause, ShipBluePrint.TASK_STATE_PAUSE == var0 and not var1 and not var3 or ShipBluePrint.TASK_STATE_PAUSE == var0 and not var3 and var1 and not arg0.autoCommit)
		setActive(arg0.pauseLock, ShipBluePrint.TASK_STATE_PAUSE == var0 and not var1 and var3)
		setActive(arg0.lockBtn, var0 ~= ShipBluePrint.TASK_STATE_ACHIEVED and (var0 ~= ShipBluePrint.TASK_STATE_START or not not arg0.autoCommit))
		setActive(arg0.commitBtn, var0 == ShipBluePrint.TASK_STATE_ACHIEVED or var0 == ShipBluePrint.TASK_STATE_START and not arg0.autoCommit)
		setActive(arg0.progressTF, var0 == ShipBluePrint.TASK_STATE_ACHIEVED or var0 == ShipBluePrint.TASK_STATE_START or var0 == ShipBluePrint.TASK_STATE_FINISHED or var0 == ShipBluePrint.TASK_STATE_PAUSE and not var3)
		setActive(arg0.lock, var0 == ShipBluePrint.TASK_STATE_LOCK or var0 == ShipBluePrint.TASK_STATE_WAIT)
		setActive(arg0.working, var0 == ShipBluePrint.TASK_STATE_OPENING or var0 == ShipBluePrint.TASK_STATE_START or var0 == ShipBluePrint.TASK_STATE_ACHIEVED)
		setActive(arg0.maskAchieved, var0 == ShipBluePrint.TASK_STATE_FINISHED or var0 == ShipBluePrint.TASK_STATE_PAUSE and var2)
		setActive(arg0.timerTF, var0 == ShipBluePrint.TASK_STATE_WAIT or var0 == ShipBluePrint.TASK_STATE_PAUSE and arg1.leftTime and arg1.leftTime > 0)
		setActive(arg0.check, arg0.autoCommit and var0 == ShipBluePrint.TASK_STATE_ACHIEVED or var0 == ShipBluePrint.TASK_STATE_FINISHED or var0 == ShipBluePrint.TASK_STATE_PAUSE and var2)
		setActive(arg0.tip, var0 == ShipBluePrint.TASK_STATE_ACHIEVED)
		setActive(arg0.timerOpen, var0 == ShipBluePrint.TASK_STATE_WAIT)
		setActive(arg0.timerClose, var0 == ShipBluePrint.TASK_STATE_PAUSE and arg1.leftTime and arg1.leftTime > 0)
	end

	function var0.updateProgress(arg0, arg1)
		local var0 = arg1.taskState
		local var1 = arg1:getProgress() / arg1:getConfig("target_num")

		if var0 == ShipBluePrint.TASK_STATE_WAIT then
			arg0:addTimer(arg1, arg1.dueTime)

			var1 = 0
		elseif var0 == ShipBluePrint.TASK_STATE_OPENING then
			var1 = 0

			arg0.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, arg1.id)
		elseif var0 == ShipBluePrint.TASK_STATE_PAUSE then
			if arg1:isReceive() then
				var1 = 1
			end
		elseif var0 == ShipBluePrint.TASK_STATE_LOCK then
			var1 = 0
		elseif var0 == ShipBluePrint.TASK_STATE_ACHIEVED then
			onButton(arg0.view, arg0.commitBtn, function()
				arg0.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, arg1.id)
			end, SFX_PANEL)

			var1 = 1
		elseif var0 == ShipBluePrint.TASK_STATE_FINISHED then
			var1 = 1
		elseif var0 == ShipBluePrint.TASK_STATE_START and not arg0.autoCommit then
			onButton(arg0.view, arg0.commitBtn, function()
				arg0.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, arg1.id)
			end, SFX_PANEL)

			var1 = 0
		end

		if var1 > 0 then
			arg0.itemSliderLT = LeanTween.value(go(arg0.progressTF), 0, math.min(var1, 1), 0.5 * math.min(var1, 1)):setOnUpdate(System.Action_float(function(arg0)
				arg0.progessSlider.value = arg0
			end)).uniqueId
		else
			arg0.progessSlider.value = var1
		end

		local var2 = math.floor(var1 * 100)

		setText(arg0.progres, math.ceil(math.min(var2, 100)) .. "%")
		setText(arg0.progreshadow, math.min(var2, 100) .. "%")
	end

	function var0.addTimer(arg0, arg1, arg2)
		arg0:clearTimer()

		arg0.taskTimer = Timer.New(function()
			local var0 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1 = arg2 - var0

			if var1 > 0 then
				setText(arg0.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(var1))
			else
				arg0:clearTimer()
				setText(arg0.timerTFTxt, "00:00:00")
				arg0.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, arg1.id)
			end
		end, 1, -1)

		arg0.taskTimer:Start()
		arg0.taskTimer.func()
	end

	function var0.clearTimer(arg0)
		if arg0.taskTimer then
			arg0.taskTimer:Stop()

			arg0.taskTimer = nil
		end
	end

	function var0.clear(arg0)
		arg0:clearTimer()

		if arg0.itemSliderLT then
			LeanTween.cancel(arg0.itemSliderLT)

			arg0.itemSliderLT = nil
		end
	end

	return var0
end

function var0.openPreView(arg0)
	local var0 = arg0.contextData.shipBluePrintVO

	if var0 then
		setActive(arg0.preViewer, true)
		setParent(arg0.blurPanel, arg0._tf)
		pg.UIMgr.GetInstance():BlurPanel(arg0.preViewer)
		arg0:playLoadingAni()

		arg0.viewShipVO = var0:getShipVO()
		arg0.breakIds = arg0:getStages(arg0.viewShipVO)

		for iter0 = 1, var4 do
			local var1 = arg0.breakIds[iter0]
			local var2 = var3[var1]
			local var3 = arg0:findTF("stage" .. iter0, arg0.stages)

			onToggle(arg0, var3, function(arg0)
				if arg0 then
					setText(arg0.breakView, var3[var1].breakout_view)
					arg0:switchStage(var1)
				end
			end, SFX_PANEL)

			if iter0 == 1 then
				triggerToggle(var3, true)
			end
		end

		arg0.isShowPreview = true

		arg0:updateMaxLevelAttrs(var0)
	end
end

var0.MAX_LEVEL_ATTRS = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.Air,
	AttributeType.Reload,
	AttributeType.ArmorType,
	AttributeType.Dodge
}

function var0.updateMaxLevelAttrs(arg0, arg1)
	if not arg1:isFetched() then
		return
	end

	local var0 = arg0.shipVOs[arg1.shipId]
	local var1 = Clone(var0)

	var1.level = 125

	local var2 = Clone(arg1)

	var2.level = arg1:getMaxLevel()

	local var3 = intProperties(var2:getShipProperties(var1, false))

	for iter0, iter1 in ipairs(var0.MAX_LEVEL_ATTRS) do
		local var4 = arg0.previewAttrContainer:Find(iter1)

		if iter1 == AttributeType.ArmorType then
			setText(var4:Find("bg/value"), var0:getShipArmorName())
		else
			setText(var4:Find("bg/value"), var3[iter1] or 0)
		end

		setText(var4:Find("bg/name"), AttributeType.Type2Name(iter1))
	end
end

function var0.closePreview(arg0, arg1)
	if arg0.previewer then
		arg0.previewer:clear()

		arg0.previewer = nil
	end

	setActive(arg0.preViewer, false)
	setActive(arg0.rawImage, false)

	if not arg1 then
		SetParent(arg0.blurPanel, pg.UIMgr.GetInstance().OverlayMain)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0.preViewer, arg0._tf)

	arg0.isShowPreview = nil
end

function var0.playLoadingAni(arg0)
	setActive(arg0.seaLoading, true)
end

function var0.stopLoadingAni(arg0)
	setActive(arg0.seaLoading, false)
end

function var0.showBarrage(arg0)
	arg0.previewer = WeaponPreviewer.New(arg0.rawImage)

	arg0.previewer:configUI(arg0.healTF)
	arg0.previewer:setDisplayWeapon(arg0:getWaponIdsById(arg0.breakOutId))
	arg0.previewer:load(40000, arg0.viewShipVO, arg0:getAllWeaponIds(), function()
		arg0:stopLoadingAni()
	end)
end

function var0.getWaponIdsById(arg0, arg1)
	return var3[arg1].weapon_ids
end

function var0.getAllWeaponIds(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.breakIds) do
		local var1 = Clone(var3[iter1].weapon_ids)
		local var2 = {
			__add = function(arg0, arg1)
				for iter0, iter1 in ipairs(arg0) do
					if not table.contains(arg1, iter1) then
						table.insert(arg1, iter1)
					end
				end

				return arg1
			end
		}

		setmetatable(var0, var2)

		var0 = var0 + var1
	end

	return var0
end

function var0.getStages(arg0, arg1)
	local var0 = {}
	local var1 = math.floor(arg1.configId / 10)

	for iter0 = 1, 4 do
		local var2 = tonumber(var1 .. iter0)

		assert(var3[var2], "必须存在配置" .. var2)
		table.insert(var0, var2)
	end

	return var0
end

function var0.switchStage(arg0, arg1)
	if arg0.breakOutId == arg1 then
		return
	end

	arg0.breakOutId = arg1

	if arg0.previewer then
		arg0.previewer:setDisplayWeapon(arg0:getWaponIdsById(arg0.breakOutId))
	end
end

function var0.clearTimers(arg0)
	for iter0, iter1 in pairs(arg0.taskTFs or {}) do
		iter1:clear()
	end
end

function var0.cloneTplTo(arg0, arg1, arg2)
	local var0 = tf(Instantiate(arg1))

	SetActive(var0, true)
	var0:SetParent(tf(arg2), false)

	return var0
end

function var0.onBackPressed(arg0)
	if isActive(arg0.msgPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.msgPanel, arg0.top)
		setActive(arg0.msgPanel, false)
	elseif isActive(arg0.unlockPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.unlockPanel, arg0.top)
		setActive(arg0.unlockPanel, false)
	elseif isActive(arg0.versionPanel) then
		triggerButton(arg0.versionPanel:Find("bg"))
	elseif arg0.isShowPreview then
		arg0:closePreview(true)
	elseif arg0.svQuickExchange:isShowing() then
		arg0.svQuickExchange:Hide()
	elseif arg0.awakenPlay or arg0:inModAnim() then
		-- block empty
	else
		arg0:emit(var0.ON_BACK_PRESSED)
	end
end

function var0.willExit(arg0)
	if isActive(arg0.msgPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.msgPanel, arg0.top)
		setActive(arg0.msgPanel, false)
	end

	if isActive(arg0.unlockPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.unlockPanel, arg0.top)
		setActive(arg0.unlockPanel, false)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
	LeanTween.cancel(go(arg0.fittingAttrPanel))

	if arg0.lastPaintingName then
		retPaintingPrefab(arg0.painting, arg0.lastPaintingName)
	end

	for iter0, iter1 in pairs(arg0.taskTFs or {}) do
		iter1:clear()
	end

	arg0:closePreview(true)
	arg0:clearLeanTween(true)

	if arg0.previewer then
		arg0.previewer:clear()

		arg0.previewer = nil
	end

	if arg0.cbTimer then
		arg0.cbTimer:Stop()

		arg0.cbTimer = nil
	end

	arg0.svQuickExchange:Destroy()
end

function var0.paintBreath(arg0)
	LeanTween.cancel(go(arg0.painting))
	LeanTween.moveY(rtf(arg0.painting), var5, var6):setLoopPingPong():setEase(LeanTweenType.easeInOutCubic):setFrom(0)
end

function var0.buildStartAni(arg0, arg1, arg2)
	if arg1 == "researchStartWindow" then
		arg0.progressPanel.localScale = Vector3(0, 1, 1)

		LeanTween.scale(arg0.progressPanel, Vector3(1, 1, 1), 0.2):setDelay(2)
	end

	local function var0()
		arg0.awakenAni:SetActive(true)

		arg0.awakenPlay = true

		local var0 = tf(arg0.awakenAni)

		pg.UIMgr.GetInstance():BlurPanel(var0)
		var0:SetAsLastSibling()
		var0:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			if not IsNil(arg0.awakenAni) then
				pg.UIMgr.GetInstance():UnblurPanel(var0, arg0.blurPanel)
				arg0.awakenAni:SetActive(false)

				arg0.awakenPlay = false

				if arg2 then
					arg2()
				end
			end
		end)
	end

	local var1 = arg0:findTF(arg1 .. "(Clone)")

	arg0.awakenAni = var1 and go(var1)

	if not arg0.awakenAni then
		PoolMgr.GetInstance():GetUI(arg1, true, function(arg0)
			arg0:SetActive(true)

			arg0.awakenAni = arg0

			var0()
		end)
	else
		var0()
	end
end

function var0.showFittingMsgPanel(arg0, arg1)
	pg.UIMgr.GetInstance():BlurPanel(arg0.msgPanel)
	setActive(arg0.msgPanel, true)

	local var0 = arg0.contextData.shipBluePrintVO
	local var1 = var0:getMaxFateLevel()
	local var2 = arg0:findTF("window/content", arg0.msgPanel)
	local var3 = arg0:findTF("pre_btn", var2)
	local var4 = arg0:findTF("next_btn", var2)
	local var5 = arg0:findTF("attrl_panel", var2)
	local var6 = arg0:findTF("skill_panel", var2)
	local var7 = arg0:findTF("phase", var2)
	local var8 = {
		"I",
		"II",
		"III",
		"IV",
		"V"
	}

	local function var9()
		setActive(var3, arg1 > 1)
		setActive(var4, arg1 < var1)
		setText(var7, "PHASE." .. var8[arg1])

		local var0 = var0:getFateStrengthenConfig(arg1)

		assert(var0.special == 1 and type(var0.special_effect) == "table", "without fate config")

		local var1 = var0.special_effect
		local var2
		local var3 = {}

		for iter0, iter1 in ipairs(var1) do
			local var4 = iter1[1]

			if var4 == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				var2 = iter1[2][2]
			elseif var4 == ShipBluePrint.STRENGTHEN_TYPE_ATTR then
				table.insert(var3, iter1[2])
			end
		end

		setActive(var5, #var3 > 0)
		setActive(var6, var2)

		if var2 then
			local var5 = getSkillConfig(var2)

			GetImageSpriteFromAtlasAsync("skillicon/" .. var5.icon, "", arg0:findTF("skill_icon", var6))
			setText(arg0:findTF("skill_name", var6), getSkillName(var2))

			local var6 = 1

			setText(arg0:findTF("skill_lv", var6), "Lv." .. var6)
			setText(arg0:findTF("help_panel/skill_intro", var6), getSkillDescGet(var2))
		end

		if #var3 > 0 then
			for iter2, iter3 in ipairs(var3) do
				local var7 = iter2 < var5.childCount and var5:GetChild(iter2) or cloneTplTo(var5:GetChild(iter2 - 1), var5)

				setText(var7:Find("name"), AttributeType.Type2Name(iter3[1]))
				setText(var7:Find("number"), " + " .. iter3[2])
			end

			for iter4 = #var3 + 1, var5.childCount - 1 do
				setActive(var5:GetChild(iter4), false)
			end
		end
	end

	onButton(arg0, var3, function()
		arg1 = arg1 - 1

		var9()
	end)
	onButton(arg0, var4, function()
		arg1 = arg1 + 1

		var9()
	end)
	setText(arg0:findTF("desc", var5), i18n("fate_attr_word"))
	var9()
end

function var0.showUnlockPanel(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0.unlockPanel)
	setActive(arg0.unlockPanel, true)

	local var0 = arg0.contextData.shipBluePrintVO.id
	local var1 = arg0.contextData.shipBluePrintVO:getUnlockItem()
	local var2 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = var1
	})
	local var3 = arg0.contextData.shipBluePrintVO:getShipVO()
	local var4 = var3:getPainting()
	local var5 = arg0.unlockPanel:Find("window/content")

	GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var4, var4, var5:Find("Image/mask/icon"), true)
	setText(var5:Find("words/Text"), i18n("techpackage_item_use_1", var3:getName()))
	setText(var5:Find("words/Text_2"), i18n("techpackage_item_use_2", var2:getName()))
	GetImageSpriteFromAtlasAsync(var2:getIcon(), "", arg0.unlockPanel:Find("window/confirm_btn/Image/Image"))
	setText(arg0.unlockPanel:Find("window/confirm_btn/Image/Text"), i18n("event_ui_consume"))
	onButton(arg0, arg0.unlockPanel:Find("window/confirm_btn"), function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.unlockPanel, arg0.top)
		setActive(arg0.unlockPanel, false)
		arg0:emit(ShipBluePrintMediator.ON_ITEM_UNLOCK, var0, var1)
	end, SFX_CANCEL)
end

function var0.checkStory(arg0)
	local var0 = {
		nil,
		"FANGAN3"
	}

	arg0.storyMgr = arg0.storyMgr or pg.NewStoryMgr.GetInstance()

	if var0[arg0.version] and not arg0.storyMgr:IsPlayed(var0[arg0.version]) then
		arg0.storyMgr:Play(var0[arg0.version])
	end
end

return var0
