local var0 = class("ShipMainScene", import("...base.BaseUI"))
local var1 = 0
local var2 = 0.2
local var3 = 0.3
local var4 = 3
local var5 = 0.5
local var6 = 11

function var0.getUIName(arg0)
	return "ShipMainScene"
end

function var0.ResUISettings(arg0)
	return {
		anim = true,
		showType = PlayerResUI.TYPE_ALL,
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	}
end

function var0.preload(arg0, arg1)
	local var0 = getProxy(BayProxy):getShipById(arg0.contextData.shipId)

	parallelAsync({
		function(arg0)
			GetSpriteFromAtlasAsync("bg/star_level_bg_" .. var0:rarity2bgPrintForGet(), "", arg0)
		end,
		function(arg0)
			if arg0.exited then
				return
			end

			local var0 = PoolMgr.GetInstance()
			local var1 = "ShipDetailView"

			if not var0:HasCacheUI(var1) then
				var0:GetUI(var1, true, function(arg0)
					var0:ReturnUI(var1, arg0)
					arg0()
				end)
			else
				arg0()
			end
		end
	}, arg1)
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1

	arg0:GetShareData():SetPlayer(arg1)
end

function var0.setShipList(arg0, arg1)
	arg0.shipList = arg1
end

function var0.setShip(arg0, arg1)
	arg0:GetShareData():SetShipVO(arg1)

	local var0 = false

	if arg0.shipVO and arg0.shipVO.id ~= arg1.id then
		arg0:StopPreVoice()

		var0 = true
	end

	arg0.shipVO = arg1

	setActive(arg0.npcFlagTF, arg1:isActivityNpc())

	if var0 and not arg0:checkToggleActive(ShipViewConst.currentPage) then
		triggerToggle(arg0.detailToggle, true)
	end

	arg0:setToggleEnable()

	local var1 = pg.ship_skin_template[arg0.shipVO.skinId]

	arg0.isSpBg = var1.rarity_bg and var1.rarity_bg ~= ""

	arg0:updatePreference(arg1)
	arg0.shipDetailView:ActionInvoke("UpdateUI")
	arg0.shipFashionView:ActionInvoke("UpdateUI")
	arg0.shipEquipView:ActionInvoke("UpdateUI")
end

function var0.equipmentChange(arg0)
	if arg0.shipDetailView then
		arg0.shipDetailView:ActionInvoke("UpdateUI")
	end
end

function var0.setToggleEnable(arg0)
	for iter0, iter1 in pairs(arg0.togglesList) do
		setActive(iter1, arg0:checkToggleActive(iter0))
	end

	setActive(arg0.technologyToggle, arg0.shipVO:isBluePrintShip())
	SetActive(arg0.metaToggle, arg0.shipVO:isMetaShip())
end

function var0.checkToggleActive(arg0, arg1)
	if arg1 == ShipViewConst.PAGE.DETAIL then
		return true
	elseif arg1 == ShipViewConst.PAGE.EQUIPMENT then
		return true
	elseif arg1 == ShipViewConst.PAGE.INTENSIFY then
		return not arg0.shipVO:isTestShip() and not arg0.shipVO:isBluePrintShip() and not arg0.shipVO:isMetaShip()
	elseif arg1 == ShipViewConst.PAGE.UPGRADE then
		return not arg0.shipVO:isTestShip() and not arg0.shipVO:isBluePrintShip() and not arg0.shipVO:isMetaShip()
	elseif arg1 == ShipViewConst.PAGE.REMOULD then
		return not arg0.shipVO:isTestShip() and not arg0.shipVO:isBluePrintShip() and pg.ship_data_trans[arg0.shipVO.groupId] and not arg0.shipVO:isMetaShip()
	elseif arg1 == ShipViewConst.PAGE.FASHION then
		if not arg0:hasFashion() then
			return false
		else
			local var0
			local var1

			if not PaintingGroupConst.IsPaintingNeedCheck() then
				var1 = false
			else
				local var2 = PaintingGroupConst.GetPaintingNameListByShipVO(arg0.shipVO)

				var1 = PaintingGroupConst.CalcPaintingListSize(var2) > 0
			end

			return not var1
		end
	else
		return false
	end
end

function var0.setSkinList(arg0, arg1)
	arg0.shipFashionView:ActionInvoke("SetSkinList", arg1)
end

function var0.updateLock(arg0)
	arg0.shipDetailView:ActionInvoke("UpdateLock")
end

function var0.updatePreferenceTag(arg0)
	arg0.shipDetailView:ActionInvoke("UpdatePreferenceTag")
end

function var0.updateFashionTag(arg0)
	arg0.shipDetailView:ActionInvoke("UpdateFashionTag")
end

function var0.closeRecordPanel(arg0)
	arg0.shipDetailView:ActionInvoke("CloseRecordPanel")
end

function var0.updateRecordEquipments(arg0, arg1)
	arg0.shipDetailView:UpdateRecordEquipments(arg1)
	arg0.shipDetailView:UpdateRecordSpWeapons(arg1)
end

function var0.setModPanel(arg0, arg1)
	arg0.modPanel = arg1
end

function var0.setMaxLevelHelpFlag(arg0, arg1)
	arg0.maxLevelHelpFlag = arg1
end

function var0.checkMaxLevelHelp(arg0)
	if not arg0.maxLevelHelpFlag and arg0.shipVO and arg0.shipVO:isReachNextMaxLevel() then
		arg0:openHelpPage()

		arg0.maxLevelHelpFlag = true

		getProxy(SettingsProxy):setMaxLevelHelp(true)
	end
end

function var0.GetShareData(arg0)
	if not arg0.shareData then
		arg0.shareData = ShipViewShareData.New(arg0.contextData)

		arg0.shipDetailView:SetShareData(arg0.shareData)
		arg0.shipFashionView:SetShareData(arg0.shareData)
		arg0.shipEquipView:SetShareData(arg0.shareData)
		arg0.shipEquipView:ActionInvoke("InitEvent")
		arg0.shipHuntingRangeView:SetShareData(arg0.shareData)
		arg0.shipCustomMsgBox:SetShareData(arg0.shareData)
		arg0.shipChangeNameView:SetShareData(arg0.shareData)
	end

	return arg0.shareData
end

function var0.hasFashion(arg0)
	return arg0.shareData:HasFashion()
end

function var0.DisplayRenamePanel(arg0, arg1)
	arg0.shipChangeNameView:Load()
	arg0.shipChangeNameView:ActionInvoke("DisplayRenamePanel", arg1)
end

function var0.init(arg0)
	arg0:initShip()
	arg0:initPages()
	arg0:initEvents()

	arg0.mainCanvasGroup = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.commonCanvasGroup = arg0:findTF("blur_panel/adapt"):GetComponent(typeof(CanvasGroup))
	Input.multiTouchEnabled = false
end

function var0.initShip(arg0)
	arg0.shipInfo = arg0:findTF("main/character")

	setActive(arg0.shipInfo, true)

	arg0.tablePainting = {
		arg0:findTF("painting", arg0.shipInfo),
		arg0:findTF("painting2", arg0.shipInfo)
	}
	arg0.nowPainting = nil
	arg0.isRight = true
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.common = arg0.blurPanel:Find("adapt")
	arg0.npcFlagTF = arg0.common:Find("name/npc")
	arg0.shipName = arg0.common:Find("name")
	arg0.shipInfoStarTpl = arg0.shipName:Find("star_tpl")
	arg0.nameEditFlag = arg0.shipName:Find("nameRect/editFlag")

	setActive(arg0.shipName, true)
	setActive(arg0.shipInfoStarTpl, false)
	setActive(arg0.nameEditFlag, false)

	arg0.energyTF = arg0.shipName:Find("energy")
	arg0.energyDescTF = arg0.energyTF:Find("desc")
	arg0.energyText = arg0.energyTF:Find("desc/desc")

	setActive(arg0.energyDescTF, false)

	arg0.character = arg0:findTF("main/character")
	arg0.chat = arg0:findTF("main/character/chat")
	arg0.chatBg = arg0:findTF("main/character/chat/chatbgtop")
	arg0.chatText = arg0:findTF("Text", arg0.chat)
	rtf(arg0.chat).localScale = Vector3.New(0, 0, 1)
	arg0.initChatBgH = arg0.chatText.sizeDelta.y
	arg0.initfontSize = arg0.chatText:GetComponent(typeof(Text)).fontSize
	arg0.initChatTextH = arg0.chatText.sizeDelta.y
	arg0.initfontSize = arg0.chatText:GetComponent(typeof(Text)).fontSize

	if PLATFORM_CODE == PLATFORM_US then
		local var0 = GetComponent(arg0.chatText, typeof(Text))

		var0.lineSpacing = 1.1
		var0.fontSize = 25
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0.chat, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})
end

function var0.initPages(arg0)
	ShipViewConst.currentPage = nil
	arg0.background = arg0:findTF("background")

	setActive(arg0.background, true)

	arg0.main = arg0:findTF("main")
	arg0.mainMask = arg0.main:GetComponent(typeof(RectMask2D))
	arg0.toggles = arg0:findTF("left_length/frame/root", arg0.common)
	arg0.detailToggle = arg0.toggles:Find("detail_toggle")
	arg0.equipmentToggle = arg0.toggles:Find("equpiment_toggle")
	arg0.intensifyToggle = arg0.toggles:Find("intensify_toggle")
	arg0.upgradeToggle = arg0.toggles:Find("upgrade_toggle")
	arg0.remouldToggle = arg0.toggles:Find("remould_toggle")
	arg0.technologyToggle = arg0.toggles:Find("technology_toggle")
	arg0.metaToggle = arg0.toggles:Find("meta_toggle")
	arg0.togglesList = {}
	arg0.togglesList[ShipViewConst.PAGE.DETAIL] = arg0.detailToggle
	arg0.togglesList[ShipViewConst.PAGE.EQUIPMENT] = arg0.equipmentToggle
	arg0.togglesList[ShipViewConst.PAGE.INTENSIFY] = arg0.intensifyToggle
	arg0.togglesList[ShipViewConst.PAGE.UPGRADE] = arg0.upgradeToggle
	arg0.togglesList[ShipViewConst.PAGE.REMOULD] = arg0.remouldToggle
	arg0.detailContainer = arg0.main:Find("detail_container")

	setAnchoredPosition(arg0.detailContainer, {
		x = 1300
	})

	arg0.fashionContainer = arg0.main:Find("fashion_container")

	setAnchoredPosition(arg0.fashionContainer, {
		x = 900
	})

	arg0.equipContainer = arg0.main:Find("equip_container")
	arg0.equipLCon = arg0.equipContainer:Find("equipment_l_container")
	arg0.equipRCon = arg0.equipContainer:Find("equipment_r_container")
	arg0.equipBCon = arg0.equipContainer:Find("equipment_b_container")

	setAnchoredPosition(arg0.equipRCon, {
		x = 750
	})
	setAnchoredPosition(arg0.equipLCon, {
		x = -700
	})
	setAnchoredPosition(arg0.equipBCon, {
		y = -540
	})

	arg0.shipDetailView = ShipDetailView.New(arg0.detailContainer, arg0.event, arg0.contextData)
	arg0.shipFashionView = ShipFashionView.New(arg0.fashionContainer, arg0.event, arg0.contextData)
	arg0.shipEquipView = ShipEquipView.New(arg0.equipContainer, arg0.event, arg0.contextData)
	arg0.shipHuntingRangeView = ShipHuntingRangeView.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.shipCustomMsgBox = ShipCustomMsgBox.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.shipChangeNameView = ShipChangeNameView.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.expItemUsagePage = ShipExpItemUsagePage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.viewList = {}
	arg0.viewList[ShipViewConst.PAGE.DETAIL] = arg0.shipDetailView
	arg0.viewList[ShipViewConst.PAGE.FASHION] = arg0.shipFashionView
	arg0.viewList[ShipViewConst.PAGE.EQUIPMENT] = arg0.shipEquipView

	onButton(arg0, arg0.shipName, function()
		if arg0.shipVO.propose and not arg0.shipVO:IsXIdol() then
			if not pg.PushNotificationMgr.GetInstance():isEnableShipName() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_switch_tip"))

				return
			end

			local var0 = arg0.shipVO.renameTime + 2592000 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0 > 0 then
				local var1 = math.floor(var0 / 60 / 60 / 24)

				if var1 < 1 then
					var1 = 1
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_time_tip", var1))
			else
				arg0:DisplayRenamePanel(true)
			end
		end
	end, SFX_PANEL)
end

function var0.initEvents(arg0)
	arg0:bind(ShipViewConst.SWITCH_TO_PAGE, function(arg0, arg1)
		arg0:gotoPage(arg1)
	end)
	arg0:bind(ShipViewConst.LOAD_PAINTING, function(arg0, arg1, arg2)
		arg0:loadPainting(arg1, arg2)
	end)
	arg0:bind(ShipViewConst.LOAD_PAINTING_BG, function(arg0, arg1, arg2, arg3)
		arg0:loadSkinBg(arg1, arg2, arg3, arg0.isSpBg)
	end)
	arg0:bind(ShipViewConst.HIDE_SHIP_WORD, function(arg0)
		arg0:hideShipWord()
	end)
	arg0:bind(ShipViewConst.SET_CLICK_ENABLE, function(arg0, arg1)
		arg0.mainCanvasGroup.blocksRaycasts = arg1
		arg0.commonCanvasGroup.blocksRaycasts = arg1
		GetComponent(arg0.detailContainer, "CanvasGroup").blocksRaycasts = arg1
	end)
	arg0:bind(ShipViewConst.SHOW_CUSTOM_MSG, function(arg0, arg1)
		arg0.shipCustomMsgBox:Load()
		arg0.shipCustomMsgBox:ActionInvoke("showCustomMsgBox", arg1)
	end)
	arg0:bind(ShipViewConst.HIDE_CUSTOM_MSG, function(arg0)
		arg0.shipCustomMsgBox:ActionInvoke("hideCustomMsgBox")
	end)
	arg0:bind(ShipViewConst.DISPLAY_HUNTING_RANGE, function(arg0, arg1)
		if arg1 then
			arg0.shipHuntingRangeView:Load()
			arg0.shipHuntingRangeView:ActionInvoke("DisplayHuntingRange")
		else
			arg0.shipHuntingRangeView:HideHuntingRange()
		end
	end)
	arg0:bind(ShipViewConst.PAINT_VIEW, function(arg0, arg1)
		if arg1 then
			arg0:paintView()
		else
			arg0:hidePaintView(true)
		end
	end)
	arg0:bind(ShipViewConst.SHOW_EXP_ITEM_USAGE, function(arg0, arg1)
		arg0.expItemUsagePage:ExecuteAction("Show", arg1)
	end)
end

function var0.didEnter(arg0)
	arg0:addRingDragListenter()
	onButton(arg0, arg0:findTF("top/back_btn", arg0.common), function()
		GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

		if not arg0.everTriggerBack then
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0:closeView()
			end))

			arg0.everTriggerBack = true
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.npcFlagTF, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_actnpc.tip
		})
	end, SFX_PANEL)

	arg0.helpBtn = arg0:findTF("help_btn", arg0.common)

	onButton(arg0, arg0.helpBtn, function()
		arg0:openHelpPage(ShipViewConst.currentPage)
	end, SFX_PANEL)

	for iter0, iter1 in pairs(arg0.togglesList) do
		if iter1 == arg0.upgradeToggle or iter1 == arg0.remouldToggle or iter1 == arg0.equipmentToggle then
			onToggle(arg0, iter1, function(arg0)
				if arg0 then
					if LeanTween.isTweening(go(arg0.chat)) then
						LeanTween.cancel(go(arg0.chat))
					end

					rtf(arg0.chat).localScale = Vector3.New(0, 0, 1)
					arg0.chatFlag = false

					arg0:switchToPage(iter0)
				end
			end, SFX_PANEL)
		else
			onToggle(arg0, iter1, function(arg0)
				if arg0 then
					arg0:switchToPage(iter0)
				end
			end, SFX_PANEL)
		end
	end

	onButton(arg0, arg0.technologyToggle, function()
		arg0:emit(ShipMainMediator.ON_TECHNOLOGY, arg0.shipVO)
	end, SFX_PANEL)
	onButton(arg0, arg0.metaToggle, function()
		arg0:emit(ShipMainMediator.ON_META, arg0.shipVO)
	end, SFX_PANEL)
	onButton(arg0, tf(arg0.character), function()
		if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
			arg0:displayShipWord("detail")
		end
	end)
	onButton(arg0, arg0.energyTF, function()
		arg0:showEnergyDesc()
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.blurPanel, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})

	local var0 = arg0:checkToggleActive(arg0.contextData.page) and arg0.contextData.page or ShipViewConst.PAGE.DETAIL

	arg0:gotoPage(var0)

	if ShipViewConst.currentPage == ShipViewConst.PAGE.DETAIL then
		arg0:displayShipWord(arg0:getInitmacyWords())
		arg0:checkMaxLevelHelp()
	end
end

function var0.openHelpPage(arg0, arg1)
	if arg1 == ShipViewConst.PAGE.EQUIPMENT then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_equip.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif arg1 == ShipViewConst.PAGE.DETAIL then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_detail.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif arg1 == ShipViewConst.PAGE.INTENSIFY then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_intensify.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif arg1 == ShipViewConst.PAGE.UPGRADE then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_upgrate.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif arg1 == ShipViewConst.PAGE.FASHION then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_fashion.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_maxlevel.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	end
end

function var0.showAwakenCompleteAni(arg0, arg1)
	local function var0()
		arg0.awakenAni:SetActive(true)

		arg0.awakenPlay = true

		onButton(arg0, arg0.awakenAni, function()
			arg0.awakenAni:GetComponent("Animator"):SetBool("endFlag", true)
		end)

		local var0 = tf(arg0.awakenAni)

		pg.UIMgr.GetInstance():BlurPanel(var0, false, {
			weight = LayerWeightConst.TOP_LAYER
		})
		setText(arg0:findTF("window/desc", arg0.awakenAni), arg1)
		var0:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			arg0.awakenAni:GetComponent("Animator"):SetBool("endFlag", false)
			pg.UIMgr.GetInstance():UnblurPanel(var0, arg0.common)
			arg0.awakenAni:SetActive(false)

			arg0.awakenPlay = false
		end)
	end

	local var1 = arg0:findTF("AwakenCompleteWindows(Clone)")

	if var1 then
		arg0.awakenAni = go(var1)
	end

	if not arg0.awakenAni then
		PoolMgr.GetInstance():GetUI("AwakenCompleteWindows", true, function(arg0)
			arg0:SetActive(true)

			arg0.awakenAni = arg0

			var0()
		end)
	else
		var0()
	end
end

function var0.updatePreference(arg0, arg1)
	local var0 = arg1:getConfigTable()
	local var1 = arg0.shipVO:getName()

	setScrollText(arg0.shipName:Find("nameRect/name_mask/Text"), var1)
	setText(arg0:findTF("english_name", arg0.shipName), var0.english_name)
	setActive(arg0.nameEditFlag, arg1.propose and not arg1:IsXIdol())

	local var2 = GetSpriteFromAtlas("energy", arg1:getEnergyPrint())

	if not var2 then
		warning("找不到疲劳")
	end

	setImageSprite(arg0.energyTF, var2, true)
	setActive(arg0.energyTF, true)

	local var3 = arg0:findTF("stars", arg0.shipName)

	removeAllChildren(var3)

	local var4 = arg1:getStar()
	local var5 = arg1:getMaxStar()

	for iter0 = 1, var5 do
		local var6 = cloneTplTo(arg0.shipInfoStarTpl, var3, "star_" .. iter0)

		setActive(var6:Find("star_tpl"), iter0 <= var4)
		setActive(var6:Find("empty_star_tpl"), true)
	end

	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
		arg0:loadPainting(arg0.shipVO:getPainting())
		arg0:loadSkinBg(arg0.shipVO:rarity2bgPrintForGet(), arg0.shipVO:isBluePrintShip(), arg0.shipVO:isMetaShip(), arg0.isSpBg)
	end

	local var7 = GetSpriteFromAtlas("shiptype", arg1:getShipType())

	if not var7 then
		warning("找不到船形, shipConfigId: " .. arg1.configId)
	end

	setImageSprite(arg0:findTF("type", arg0.shipName), var7, true)
end

function var0.doUpgradeMaxLeveAnim(arg0, arg1, arg2, arg3)
	arg0.inUpgradeAnim = true

	arg0.shipDetailView:DoLeveUpAnim(arg1, arg2, function()
		if arg3 then
			arg3()
		end

		arg0.inUpgradeAnim = nil
	end)
end

function var0.addRingDragListenter(arg0)
	local var0 = GetOrAddComponent(arg0._tf, "EventTriggerListener")
	local var1
	local var2 = 0
	local var3

	var0:AddBeginDragFunc(function()
		var2 = 0
		var1 = nil
	end)
	var0:AddDragFunc(function(arg0, arg1)
		if not arg0.inPaintingView then
			local var0 = arg1.position

			if not var1 then
				var1 = var0
			end

			var2 = var0.x - var1.x
		end
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		if not arg0.inPaintingView then
			if var2 < -50 then
				if not arg0.isLoading then
					arg0:emit(ShipMainMediator.NEXTSHIP, -1)
				end
			elseif var2 > 50 and not arg0.isLoading then
				arg0:emit(ShipMainMediator.NEXTSHIP)
			end
		end
	end)
end

function var0.showEnergyDesc(arg0)
	if arg0.energyTimer then
		return
	end

	setActive(arg0.energyDescTF, true)

	local var0, var1 = arg0.shipVO:getEnergyPrint()

	setText(arg0.energyText, i18n(var1))

	arg0.energyTimer = Timer.New(function()
		setActive(arg0.energyDescTF, false)
		arg0.energyTimer:Stop()

		arg0.energyTimer = nil
	end, 2, 1)

	arg0.energyTimer:Start()
end

function var0.displayShipWord(arg0, arg1, arg2)
	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT or ShipViewConst.currentPage == ShipViewConst.PAGE.UPGRADE then
		rtf(arg0.chat).localScale = Vector3.New(0, 0, 1)

		return
	end

	if arg2 or not arg0.chatFlag then
		arg0.chatFlag = true
		arg0.chat.localScale = Vector3.zero

		setActive(arg0.chat, true)

		arg0.chat.localPosition = Vector3(arg0.character.localPosition.x + 100, arg0.chat.localPosition.y, 0)

		local var0 = arg0.shipVO:getCVIntimacy()

		arg0.chat:SetAsLastSibling()

		local var1 = arg0.chatText:GetComponent(typeof(Text))

		if findTF(arg0.nowPainting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0.nowPainting, "fitter"):GetChild(0), arg0.paintingCode, arg1, var0)
		end

		local var2, var3, var4 = ShipWordHelper.GetWordAndCV(arg0.shipVO.skinId, arg1, nil, nil, var0)
		local var5 = arg0.chatText:GetComponent(typeof(Text))

		if PLATFORM_CODE ~= PLATFORM_US then
			setText(arg0.chatText, SwitchSpecialChar(var4))
		else
			var5.fontSize = arg0.initfontSize

			setTextEN(arg0.chatText, var4)

			while var5.preferredHeight > arg0.initChatTextH do
				var5.fontSize = var5.fontSize - 2

				setTextEN(arg0.chatText, var4)

				if var5.fontSize < 20 then
					break
				end
			end
		end

		if #var5.text > CHAT_POP_STR_LEN then
			var5.alignment = TextAnchor.MiddleLeft
		else
			var5.alignment = TextAnchor.MiddleCenter
		end

		local var6 = var5.preferredHeight + 120

		if var6 > arg0.initChatBgH then
			arg0.chatBg.sizeDelta = Vector2.New(arg0.chatBg.sizeDelta.x, var6)
		else
			arg0.chatBg.sizeDelta = Vector2.New(arg0.chatBg.sizeDelta.x, arg0.initChatBgH)
		end

		local var7 = var4

		local function var8()
			if arg0.chatFlag then
				if arg0.chatani1Id then
					LeanTween.cancel(arg0.chatani1Id)
				end

				if arg0.chatani2Id then
					LeanTween.cancel(arg0.chatani2Id)
				end
			end

			arg0.chatani1Id = LeanTween.scale(rtf(arg0.chat.gameObject), Vector3.New(1, 1, 1), var3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				arg0.chatani2Id = LeanTween.scale(rtf(arg0.chat.gameObject), Vector3.New(0, 0, 1), var3):setEase(LeanTweenType.easeInBack):setDelay(var3 + var7):setOnComplete(System.Action(function()
					arg0.chatFlag = nil
				end)).uniqueId
			end)).uniqueId
		end

		if var3 then
			arg0:StopPreVoice()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3, function(arg0)
				if arg0 then
					var7 = arg0:GetLength() * 0.001
				end

				var8()
			end)

			arg0.preVoiceContent = var3
		else
			var8()
		end
	end
end

function var0.StopPreVoice(arg0)
	if arg0.preVoiceContent ~= nil then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0.preVoiceContent)
	end
end

function var0.startChatTimer(arg0)
	if arg0.chatFlag then
		return
	end

	if arg0.chatTimer then
		arg0.chatTimer:Stop()

		arg0.chatTimer = nil
	end

	arg0.chatTimer = Timer.New(function()
		arg0:displayShipWord(arg0:getInitmacyWords())
	end, var6, 1)

	arg0.chatTimer:Start()
end

function var0.hideShipWord(arg0)
	if arg0.chatFlag then
		if arg0.chatani1Id then
			LeanTween.cancel(arg0.chatani1Id)
		end

		if arg0.chatani2Id then
			LeanTween.cancel(arg0.chatani2Id)
		end

		LeanTween.scale(rtf(arg0.chat.gameObject), Vector3.New(0, 0, 1), var3):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function()
			arg0.chatFlag = nil
		end))
	end

	arg0:StopPreVoice()
end

function var0.gotoPage(arg0, arg1)
	if arg1 == ShipViewConst.PAGE.FASHION then
		local function var0()
			arg0:switchToPage(arg1)
		end

		arg0:checkPaintingRes(var0)
	else
		triggerToggle(arg0.togglesList[arg1], true)
	end
end

function var0.switchToPage(arg0, arg1, arg2)
	local function var0(arg0, arg1)
		setActive(arg0.detailContainer, false)

		if arg0 == ShipViewConst.PAGE.DETAIL then
			setActive(arg0.detailContainer, arg1)

			local var0 = arg1 and {
				arg0.detailContainer.rect.width + 200,
				0
			} or {
				0,
				arg0.detailContainer.rect.width + 200
			}

			shiftPanel(arg0.detailContainer, var0[2], 0, var2, 0):setFrom(var0[1])
		elseif arg0 == ShipViewConst.PAGE.EQUIPMENT then
			local var1 = {
				-(arg0.equipLCon.rect.width + 190),
				190
			}
			local var2 = {
				arg0.equipRCon.rect.width,
				10
			}
			local var3 = {
				-arg0.equipBCon.rect.height,
				0
			}
			local var4 = arg1 and 1 or 2
			local var5 = arg1 and 2 or 1

			shiftPanel(arg0.equipLCon, var1[var5], 0, var2, 0):setFrom(var1[var4])
			shiftPanel(arg0.equipRCon, var2[var5], 0, var2, 0):setFrom(var2[var4])
			shiftPanel(arg0.equipBCon, 0, var3[var5], var2, 0):setFrom(var3[var4])
		elseif arg0 == ShipViewConst.PAGE.FASHION then
			local var6 = arg1 and {
				arg0.fashionContainer.rect.width + 150,
				0
			} or {
				0,
				arg0.fashionContainer.rect.width + 150
			}

			shiftPanel(arg0.fashionContainer, var6[2], 0, var2, 0):setFrom(var6[1])

			if arg1 then
				arg0.shipFashionView:ActionInvoke("UpdateFashion")
			end
		elseif arg0 == ShipViewConst.PAGE.INTENSIFY then
			if arg1 then
				arg0:emit(ShipMainMediator.OPEN_INTENSIFY)
			else
				arg0:emit(ShipMainMediator.CLOSE_INTENSIFY)
			end
		elseif arg0 == ShipViewConst.PAGE.UPGRADE then
			if arg1 then
				arg0:emit(ShipMainMediator.ON_UPGRADE)
			else
				arg0:emit(ShipMainMediator.CLOSE_UPGRADE)
			end
		elseif arg0 == ShipViewConst.PAGE.REMOULD then
			if arg1 then
				arg0:emit(ShipMainMediator.OPEN_REMOULD)
			else
				arg0:emit(ShipMainMediator.CLOSE_REMOULD)
			end
		end

		arg0:blurPage(arg0, arg1)

		if arg0 ~= ShipViewConst.PAGE.FASHION then
			arg0.fashionSkinId = arg0.shipVO.skinId

			arg0:loadPainting(arg0.shipVO:getPainting())
		end

		local var7 = not ShipViewConst.IsSubLayerPage(arg0)
		local var8 = arg0.bgEffect[arg0.shipVO:getRarity()]

		if var8 then
			setActive(var8, arg0 ~= ShipViewConst.PAGE.REMOULD and arg0.shipVO.bluePrintFlag and arg0.shipVO.bluePrintFlag == 0)
		end

		setActive(arg0.helpBtn, var7)
	end

	function switchHandler()
		if arg1 == ShipViewConst.currentPage and arg2 then
			var0(arg1, true)
		elseif arg1 ~= ShipViewConst.currentPage then
			if ShipViewConst.currentPage then
				var0(ShipViewConst.currentPage, false)
			end

			ShipViewConst.currentPage = arg1
			arg0.contextData.page = arg1

			var0(arg1, true)
			arg0:switchPainting()
		end
	end

	if arg0.viewList[arg1] ~= nil then
		local var1 = arg0.viewList[arg1]

		if not var1:GetLoaded() then
			var1:Load()
			var1:CallbackInvoke(switchHandler)
		else
			switchHandler()
		end
	else
		switchHandler()
	end
end

function var0.blurPage(arg0, arg1, arg2)
	local var0 = pg.UIMgr.GetInstance()

	if arg1 == ShipViewConst.PAGE.DETAIL then
		arg0.shipDetailView:ActionInvoke("OnSelected", arg2)
	elseif arg1 == ShipViewConst.PAGE.EQUIPMENT then
		arg0.shipEquipView:ActionInvoke("OnSelected", arg2)
	elseif arg1 == ShipViewConst.PAGE.FASHION then
		arg0.shipFashionView:ActionInvoke("OnSelected", arg2)
	elseif arg1 == ShipViewConst.PAGE.INTENSIFY then
		-- block empty
	elseif arg1 == ShipViewConst.PAGE.UPGRADE then
		-- block empty
	elseif arg1 == ShipViewConst.PAGE.REMOULD then
		-- block empty
	end
end

function var0.switchPainting(arg0)
	setActive(arg0.shipInfo, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
	setActive(arg0.shipName, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))

	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT then
		shiftPanel(arg0.shipInfo, -20, 0, var2, 0)

		arg0.paintingFrameName = "zhuangbei"
	else
		shiftPanel(arg0.shipInfo, -460, 0, var2, 0)

		arg0.paintingFrameName = "chuanwu"
	end

	local var0 = GetOrAddComponent(findTF(arg0.nowPainting, "fitter"), "PaintingScaler")

	var0:Snapshoot()

	var0.FrameName = arg0.paintingFrameName

	local var1 = LeanTween.value(go(arg0.nowPainting), 0, 1, var2):setOnUpdate(System.Action_float(function(arg0)
		var0.Tween = arg0
		arg0.chat.localPosition = Vector3(arg0.character.localPosition.x + 100, arg0.chat.localPosition.y, 0)
	end)):setEase(LeanTweenType.easeInOutSine)
end

function var0.setPreOrNext(arg0, arg1, arg2)
	if arg1 then
		arg0.isRight = true
	else
		arg0.isRight = false
	end

	if arg0.shipVO:getGroupId() ~= arg2:getGroupId() then
		arg0.switchCnt = (arg0.switchCnt or 0) + 1
	end

	if arg0.switchCnt and arg0.switchCnt >= 10 then
		gcAll()

		arg0.switchCnt = 0
	end
end

function var0.loadPainting(arg0, arg1, arg2)
	local var0 = arg1

	arg1 = MainMeshImagePainting.StaticGetPaintingName(var0)

	if arg0.isLoading == true then
		return
	end

	for iter0, iter1 in pairs(arg0.tablePainting) do
		iter1.localScale = Vector3(1, 1, 1)
	end

	if arg0.LoadShipVOId and not arg2 and arg0.LoadShipVOId == arg0.shipVO.id and arg0.LoadPaintingCode == arg1 then
		return
	end

	local var1 = 0
	local var2 = arg0.isRight and 1800 or -1800
	local var3 = arg0:getPaintingFromTable(false)

	arg0.isLoading = true

	local var4 = arg0.paintingCode
	local var5 = {}

	if var3 then
		table.insert(var5, function(arg0)
			local var0 = var3:GetComponent(typeof(RectTransform))
			local var1 = var3:GetComponent(typeof(CanvasGroup))

			LeanTween.cancel(go(var1))
			LeanTween.alphaCanvas(var1, 0, 0.3):setFrom(1):setUseEstimatedTime(true)
			LeanTween.moveX(var0, -var2, 0.3):setFrom(0):setOnComplete(System.Action(function()
				retPaintingPrefab(var3, var4)
				arg0()
			end))
		end)
	end

	local var6 = arg0:getPaintingFromTable(true)

	arg0.paintingCode = arg1

	if arg0.paintingCode and var6 then
		local var7 = var6:GetComponent(typeof(RectTransform))

		table.insert(var5, function(arg0)
			arg0.nowPainting = var6

			LoadPaintingPrefabAsync(var6, var0, arg0.paintingCode, arg0.paintingFrameName or "chuanwu", function()
				ShipExpressionHelper.SetExpression(findTF(var6, "fitter"):GetChild(0), arg0.paintingCode)
				arg0()
			end)
		end)
		table.insert(var5, function(arg0)
			LeanTween.cancel(go(var7))
			LeanTween.moveX(var7, 0, 0.3):setFrom(var2):setOnComplete(System.Action(arg0))

			local var0 = var6:GetComponent(typeof(CanvasGroup))

			LeanTween.alphaCanvas(var0, 1, 0.3):setFrom(0):setUseEstimatedTime(true)
		end)
	end

	parallelAsync(var5, function()
		arg0.LoadShipVOId = arg0.shipVO.id
		arg0.LoadPaintingCode = arg1
		arg0.isLoading = false
	end)
end

function var0.getPaintingFromTable(arg0, arg1)
	if arg0.tablePainting == nil then
		print("self.tablePainting为空")

		return
	end

	for iter0 = 1, #arg0.tablePainting do
		if findTF(arg0.tablePainting[iter0], "fitter").childCount == 0 then
			if arg1 == true and arg0.tablePainting[iter0] then
				return arg0.tablePainting[iter0]
			end
		elseif arg1 == false and arg0.tablePainting[iter0] then
			return arg0.tablePainting[iter0]
		end
	end
end

function var0.loadSkinBg(arg0, arg1, arg2, arg3, arg4)
	if not arg0.bgEffect then
		arg0.bgEffect = {}
	end

	if arg0.shipSkinBg ~= arg1 or arg0.isDesign ~= arg2 or arg0.isMeta ~= arg3 then
		arg0.shipSkinBg = arg1
		arg0.isDesign = arg2
		arg0.isMeta = arg3

		if arg0.isDesign then
			if arg0.bgEffect then
				for iter0, iter1 in pairs(arg0.bgEffect) do
					setActive(iter1, false)
				end
			end

			if arg0.bgEffect then
				for iter2, iter3 in pairs(arg0.bgEffect) do
					setActive(iter3, false)
				end
			end

			if arg0.designBg and arg0.designName ~= "raritydesign" .. arg0.shipVO:getRarity() then
				PoolMgr.GetInstance():ReturnUI(arg0.designName, arg0.designBg)

				arg0.designBg = nil
			end

			if not arg0.designBg then
				PoolMgr.GetInstance():GetUI("raritydesign" .. arg0.shipVO:getRarity(), true, function(arg0)
					arg0.designBg = arg0
					arg0.designName = "raritydesign" .. arg0.shipVO:getRarity()

					arg0.transform:SetParent(arg0._tf, false)

					arg0.transform.localPosition = Vector3(1, 1, 1)
					arg0.transform.localScale = Vector3(1, 1, 1)

					arg0.transform:SetSiblingIndex(1)
					setActive(arg0, true)
				end)
			else
				setActive(arg0.designBg, true)
			end
		elseif arg0.isMeta then
			if arg0.designBg then
				setActive(arg0.designBg, false)
			end

			if arg0.metaBg and arg0.metaName ~= "raritymeta" .. arg0.shipVO:getRarity() then
				PoolMgr.GetInstance():ReturnUI(arg0.metaName, arg0.metaBg)

				arg0.metaBg = nil
			end

			if not arg0.metaBg then
				PoolMgr.GetInstance():GetUI("raritymeta" .. arg0.shipVO:getRarity(), true, function(arg0)
					arg0.metaBg = arg0
					arg0.metaName = "raritymeta" .. arg0.shipVO:getRarity()

					arg0.transform:SetParent(arg0._tf, false)

					arg0.transform.localPosition = Vector3(1, 1, 1)
					arg0.transform.localScale = Vector3(1, 1, 1)

					arg0.transform:SetSiblingIndex(1)
					setActive(arg0, true)
				end)
			else
				setActive(arg0.metaBg, true)
			end
		else
			if arg0.designBg then
				setActive(arg0.designBg, false)
			end

			if arg0.metaBg then
				setActive(arg0.metaBg, false)
			end

			for iter4 = 1, 5 do
				local var0 = arg0.shipVO:getRarity()

				if arg0.bgEffect[iter4] then
					setActive(arg0.bgEffect[iter4], iter4 == var0 and ShipViewConst.currentPage ~= ShipViewConst.PAGE.REMOULD and not arg4)
				elseif var0 > 2 and var0 == iter4 and not arg4 then
					PoolMgr.GetInstance():GetUI("al_bg02_" .. var0 - 1, true, function(arg0)
						arg0.bgEffect[iter4] = arg0

						arg0.transform:SetParent(arg0._tf, false)

						arg0.transform.localPosition = Vector3(0, 0, 0)
						arg0.transform.localScale = Vector3(1, 1, 1)

						arg0.transform:SetSiblingIndex(1)
						setActive(arg0, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
					end)
				end
			end
		end

		GetSpriteFromAtlasAsync("bg/star_level_bg_" .. arg1, "", function(arg0)
			if not arg0.exited and arg0.shipSkinBg == arg1 then
				setImageSprite(arg0.background, arg0)
			end
		end)
	end
end

function var0.getInitmacyWords(arg0)
	local var0 = arg0.shipVO:getIntimacyLevel()
	local var1 = Mathf.Clamp(var0, 1, 5)

	return "feeling" .. var1
end

function var0.paintView(arg0)
	if LeanTween.isTweening(arg0.chat.gameObject) then
		LeanTween.cancel(arg0.chat.gameObject)

		arg0.chat.localScale = Vector3(0, 0, 0)
		arg0.chatFlag = nil
	end

	arg0.character:GetComponent("Image").enabled = false
	arg0.inPaintingView = true

	local var0 = {}
	local var1 = arg0._tf.childCount
	local var2 = 0

	while var2 < var1 do
		local var3 = arg0._tf:GetChild(var2)

		if var3.gameObject.activeSelf and var3 ~= arg0.main and var3 ~= arg0.background then
			var0[#var0 + 1] = var3

			setActive(var3, false)
		end

		var2 = var2 + 1
	end

	local var4 = arg0.main.childCount
	local var5 = 0

	while var5 < var4 do
		local var6 = arg0.main:GetChild(var5)

		if var6.gameObject.activeSelf and var6 ~= arg0.shipInfo then
			var0[#var0 + 1] = var6

			setActive(var6, false)
		end

		var5 = var5 + 1
	end

	arg0.shipDetailView:Hide()
	setActive(arg0.blurPanel, false)
	setActive(pg.playerResUI._go, false)

	var0[#var0 + 1] = arg0.chat

	openPortrait()
	setActive(arg0.common, false)

	arg0.mainMask.enabled = false

	arg0.mainMask:PerformClipping()

	local var7 = arg0.nowPainting
	local var8 = var7.anchoredPosition.x
	local var9 = var7.anchoredPosition.y
	local var10 = var7.rect.width
	local var11 = var7.rect.height
	local var12 = arg0._tf.rect.width / UnityEngine.Screen.width
	local var13 = arg0._tf.rect.height / UnityEngine.Screen.height
	local var14 = var10 / 2
	local var15 = var11 / 2
	local var16
	local var17
	local var18 = GetOrAddComponent(arg0.background, "PinchZoom")
	local var19 = GetOrAddComponent(arg0.background, "EventTriggerListener")
	local var20 = true
	local var21 = false

	var19:AddPointDownFunc(function(arg0)
		if Input.touchCount == 1 or IsUnityEditor then
			var21 = true
			var20 = true
		elseif Input.touchCount >= 2 then
			var20 = false
			var21 = false
		end
	end)
	var19:AddPointUpFunc(function(arg0)
		if Input.touchCount <= 2 then
			var20 = true
		end
	end)
	var19:AddBeginDragFunc(function(arg0, arg1)
		var21 = false
		var16 = arg1.position.x * var12 - var14 - tf(arg0.nowPainting).localPosition.x
		var17 = arg1.position.y * var13 - var15 - tf(arg0.nowPainting).localPosition.y
	end)
	var19:AddDragFunc(function(arg0, arg1)
		if var18.processing then
			return
		end

		if var20 then
			local var0 = tf(arg0.nowPainting).localPosition

			tf(arg0.nowPainting).localPosition = Vector3(arg1.position.x * var12 - var14 - var16, arg1.position.y * var13 - var15 - var17, -22)
		end
	end)
	onButton(arg0, arg0.background, function()
		arg0:hidePaintView()
	end, SFX_CANCEL)

	function var0.hidePaintView(arg0, arg1)
		if not arg1 and not var21 then
			return
		end

		arg0.character:GetComponent("Image").enabled = true
		Input.multiTouchEnabled = false

		setActive(arg0.common, true)
		SwitchPanel(arg0.shipInfo, -460, nil, var2 * 2)

		var19.enabled = false
		var18.enabled = false
		arg0.character.localScale = Vector3.one

		arg0.shipDetailView:Show()
		setActive(arg0.blurPanel, true)
		setActive(pg.playerResUI._go, true)

		for iter0, iter1 in ipairs(var0) do
			setActive(iter1, true)
		end

		closePortrait()

		arg0.nowPainting.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0.nowPainting, {
			x = var8,
			y = var9
		})

		arg0.background:GetComponent("Button").enabled = false
		arg0.nowPainting:GetComponent("CanvasGroup").blocksRaycasts = true
		arg0.mainMask.enabled = true

		arg0.mainMask:PerformClipping()

		arg0.inPaintingView = false
	end

	SwitchPanel(arg0.shipInfo, var1, nil, var2 * 2):setOnComplete(System.Action(function()
		var18.enabled = true
		var19.enabled = true
		arg0.background:GetComponent("Button").enabled = true
		arg0.nowPainting:GetComponent("CanvasGroup").blocksRaycasts = false
	end))
end

function var0.onBackPressed(arg0)
	if arg0.inUpgradeAnim then
		return
	end

	if arg0.awakenPlay then
		return
	end

	if arg0.shipChangeNameView.isOpenRenamePanel then
		arg0.shipChangeNameView:ActionInvoke("DisplayRenamePanel", false)

		return
	end

	if arg0.shipCustomMsgBox.isShowCustomMsgBox then
		arg0.shipCustomMsgBox:ActionInvoke("hideCustomMsgBox")

		return
	end

	if arg0.shipHuntingRangeView.onSelected then
		arg0.shipHuntingRangeView:ActionInvoke("HideHuntingRange")

		return
	end

	if arg0.inPaintingView then
		arg0:hidePaintView(true)

		return
	end

	if arg0.expItemUsagePage and arg0.expItemUsagePage:GetLoaded() and arg0.expItemUsagePage:isShowing() then
		arg0.expItemUsagePage:Hide()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0:findTF("top/back_btn", arg0.common))
end

function var0.willExit(arg0)
	Input.multiTouchEnabled = true

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.chat, arg0.character)
	arg0:blurPage(ShipViewConst.currentPage)
	setActive(arg0.background, false)

	if arg0.designBg then
		PoolMgr.GetInstance():ReturnUI(arg0.designName, arg0.designBg)
	end

	if arg0.metaBg then
		PoolMgr.GetInstance():ReturnUI(arg0.metaName, arg0.metaBg)
	end

	arg0.intensifyToggle:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
	arg0.upgradeToggle:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
	LeanTween.cancel(arg0.chat.gameObject)

	if arg0.paintingCode then
		for iter0 = 1, #arg0.tablePainting do
			local var0 = go(arg0.tablePainting[iter0])

			if LeanTween.isTweening(var0) then
				LeanTween.cancel(go(var0))
			end
		end

		retPaintingPrefab(arg0.nowPainting, arg0.paintingCode)
	end

	arg0.shipDetailView:Destroy()
	arg0.shipFashionView:Destroy()
	arg0.shipEquipView:Destroy()
	arg0.shipHuntingRangeView:Destroy()
	arg0.shipCustomMsgBox:Destroy()
	arg0.shipChangeNameView:Destroy()
	clearImageSprite(arg0.background)

	if arg0.energyTimer then
		arg0.energyTimer:Stop()

		arg0.energyTimer = nil
	end

	if arg0.chatTimer then
		arg0.chatTimer:Stop()

		arg0.chatTimer = nil
	end

	arg0:StopPreVoice()
	cameraPaintViewAdjust(false)

	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)

	arg0.shareData = nil
end

function var0.RefreshShipExpItemUsagePage(arg0)
	if arg0.expItemUsagePage and arg0.expItemUsagePage:GetLoaded() and arg0.expItemUsagePage:isShowing() then
		arg0.expItemUsagePage:Flush(arg0.shipVO)
	end
end

function var0.OnWillLogout(arg0)
	if arg0.inPaintingView then
		arg0:hidePaintView(true)
	end
end

function var0.checkPaintingRes(arg0, arg1)
	local var0 = PaintingGroupConst.GetPaintingNameListByShipVO(arg0.shipVO)
	local var1 = {
		isShowBox = true,
		paintingNameList = var0,
		finishFunc = arg1
	}

	PaintingGroupConst.PaintingDownload(var1)
end

return var0
