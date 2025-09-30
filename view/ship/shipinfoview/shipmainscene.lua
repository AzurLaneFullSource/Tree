local var0_0 = class("ShipMainScene", import("...base.BaseUI"))
local var1_0 = 0
local var2_0 = 0.2
local var3_0 = 0.3
local var4_0 = 3
local var5_0 = 0.5
local var6_0 = 11

function var0_0.getUIName(arg0_1)
	return "ShipMainScene"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = getProxy(BayProxy):getShipById(arg0_3.contextData.shipId)

	parallelAsync({
		function(arg0_4)
			GetSpriteFromAtlasAsync("bg/star_level_bg_" .. var0_3:rarity2bgPrintForGet(), "", arg0_4)
		end,
		function(arg0_5)
			if arg0_3.exited then
				return
			end

			PoolMgr.GetInstance():PreloadUI("ShipDetailView", arg0_5)
		end
	}, arg1_3)
end

function var0_0.setPlayer(arg0_6, arg1_6)
	arg0_6.player = arg1_6

	arg0_6:GetShareData():SetPlayer(arg1_6)
end

function var0_0.setShipList(arg0_7, arg1_7)
	arg0_7.shipList = arg1_7
end

function var0_0.setShip(arg0_8, arg1_8)
	arg0_8:GetShareData():SetShipVO(arg1_8)

	local var0_8 = false

	if arg0_8.shipVO and arg0_8.shipVO.id ~= arg1_8.id then
		arg0_8:StopPreVoice()

		var0_8 = true
	end

	arg0_8.shipVO = arg1_8

	setActive(arg0_8.npcFlagTF, arg1_8:isActivityNpc())
	arg0_8:setToggleEnable()

	local var1_8 = pg.ship_skin_template[arg0_8.shipVO:getSkinId()]

	arg0_8.isSpBg = var1_8.rarity_bg and var1_8.rarity_bg ~= ""

	arg0_8:updatePreference(arg1_8)
	arg0_8.shipDetailView:ActionInvokeExclusive("UpdateUI")
	arg0_8.shipFashionView:ActionInvokeExclusive("UpdateUI")
	arg0_8.shipEquipView:ActionInvokeExclusive("UpdateUI")

	if var0_8 and not arg0_8:checkToggleActive(ShipViewConst.currentPage) then
		triggerToggle(arg0_8.detailToggle, true)
	end
end

function var0_0.equipmentChange(arg0_9)
	if arg0_9.shipDetailView then
		arg0_9.shipDetailView:ActionInvoke("UpdateUI")
	end
end

function var0_0.setToggleEnable(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.togglesList) do
		setActive(iter1_10, arg0_10:checkToggleActive(iter0_10))
	end

	setActive(arg0_10.technologyToggle, arg0_10.shipVO:isBluePrintShip())
	SetActive(arg0_10.metaToggle, arg0_10.shipVO:isMetaShip())
end

function var0_0.checkToggleActive(arg0_11, arg1_11)
	if arg1_11 == ShipViewConst.PAGE.DETAIL then
		return true
	elseif arg1_11 == ShipViewConst.PAGE.EQUIPMENT then
		return true
	elseif arg1_11 == ShipViewConst.PAGE.INTENSIFY then
		return not arg0_11.shipVO:isTestShip() and not arg0_11.shipVO:isBluePrintShip() and not arg0_11.shipVO:isMetaShip()
	elseif arg1_11 == ShipViewConst.PAGE.UPGRADE then
		return not arg0_11.shipVO:isTestShip() and not arg0_11.shipVO:isBluePrintShip() and not arg0_11.shipVO:isMetaShip()
	elseif arg1_11 == ShipViewConst.PAGE.REMOULD then
		return not arg0_11.shipVO:isTestShip() and not arg0_11.shipVO:isBluePrintShip() and pg.ship_data_trans[arg0_11.shipVO.groupId] and not arg0_11.shipVO:isMetaShip()
	elseif arg1_11 == ShipViewConst.PAGE.FASHION then
		if not arg0_11:hasFashion() then
			return false
		else
			local var0_11
			local var1_11

			if not PaintingGroupConst.IsPaintingNeedCheck() then
				var1_11 = false
			else
				local var2_11 = PaintingGroupConst.GetPaintingNameListByShipVO(arg0_11.shipVO)

				var1_11 = PaintingGroupConst.CalcPaintingListSize(var2_11) > 0
			end

			return not var1_11
		end
	else
		return false
	end
end

function var0_0.setSkinList(arg0_12, arg1_12)
	arg0_12.shipFashionView:ActionInvoke("SetSkinList", arg1_12)
end

function var0_0.updateLock(arg0_13)
	arg0_13.shipDetailView:ActionInvoke("UpdateLock")
end

function var0_0.updatePreferenceTag(arg0_14)
	arg0_14.shipDetailView:ActionInvoke("UpdatePreferenceTag")
end

function var0_0.updateFashionTag(arg0_15)
	arg0_15.shipDetailView:ActionInvoke("UpdateFashionTag")
end

function var0_0.closeRecordPanel(arg0_16)
	arg0_16.shipDetailView:ActionInvoke("CloseRecordPanel")
end

function var0_0.updateRecordEquipments(arg0_17, arg1_17)
	arg0_17.shipDetailView:UpdateRecordEquipments(arg1_17)
	arg0_17.shipDetailView:UpdateRecordSpWeapons(arg1_17)
end

function var0_0.setModPanel(arg0_18, arg1_18)
	arg0_18.modPanel = arg1_18
end

function var0_0.setMaxLevelHelpFlag(arg0_19, arg1_19)
	arg0_19.maxLevelHelpFlag = arg1_19
end

function var0_0.checkMaxLevelHelp(arg0_20)
	if not arg0_20.maxLevelHelpFlag and arg0_20.shipVO and arg0_20.shipVO:isReachNextMaxLevel() then
		arg0_20:openHelpPage()

		arg0_20.maxLevelHelpFlag = true

		getProxy(SettingsProxy):setMaxLevelHelp(true)
	end
end

function var0_0.GetShareData(arg0_21)
	if not arg0_21.shareData then
		arg0_21.shareData = ShipViewShareData.New(arg0_21.contextData)

		arg0_21.shipDetailView:SetShareData(arg0_21.shareData)
		arg0_21.shipFashionView:SetShareData(arg0_21.shareData)
		arg0_21.shipEquipView:SetShareData(arg0_21.shareData)
		arg0_21.shipEquipView:ActionInvoke("InitEvent")
		arg0_21.shipHuntingRangeView:SetShareData(arg0_21.shareData)
		arg0_21.shipCustomMsgBox:SetShareData(arg0_21.shareData)
		arg0_21.shipChangeNameView:SetShareData(arg0_21.shareData)
	end

	return arg0_21.shareData
end

function var0_0.hasFashion(arg0_22)
	return arg0_22.shareData:HasFashion()
end

function var0_0.DisplayRenamePanel(arg0_23, arg1_23)
	arg0_23.shipChangeNameView:Load()
	arg0_23.shipChangeNameView:ActionInvoke("DisplayRenamePanel", arg1_23)
end

function var0_0.init(arg0_24)
	arg0_24:initShip()
	arg0_24:initPages()
	arg0_24:initEvents()

	arg0_24.mainCanvasGroup = arg0_24._tf:GetComponent(typeof(CanvasGroup))
	arg0_24.commonCanvasGroup = arg0_24:findTF("blur_panel/adapt"):GetComponent(typeof(CanvasGroup))
	Input.multiTouchEnabled = false
end

function var0_0.initShip(arg0_25)
	arg0_25.shipInfo = arg0_25:findTF("main/character")

	setActive(arg0_25.shipInfo, true)

	arg0_25.tablePainting = {
		arg0_25:findTF("painting", arg0_25.shipInfo),
		arg0_25:findTF("painting2", arg0_25.shipInfo)
	}
	arg0_25.nowPainting = nil
	arg0_25.isRight = true
	arg0_25.blurPanel = arg0_25:findTF("blur_panel")
	arg0_25.common = arg0_25.blurPanel:Find("adapt")
	arg0_25.npcFlagTF = arg0_25.common:Find("name/npc")
	arg0_25.shipName = arg0_25.common:Find("name")
	arg0_25.shipInfoStarTpl = arg0_25.shipName:Find("star_tpl")
	arg0_25.nameEditFlag = arg0_25.shipName:Find("nameRect/editFlag")

	setActive(arg0_25.shipName, true)
	setActive(arg0_25.shipInfoStarTpl, false)
	setActive(arg0_25.nameEditFlag, false)

	arg0_25.energyTF = arg0_25.shipName:Find("energy")
	arg0_25.energyDescTF = arg0_25.energyTF:Find("desc")
	arg0_25.energyText = arg0_25.energyTF:Find("desc/desc")

	setActive(arg0_25.energyDescTF, false)

	arg0_25.character = arg0_25:findTF("main/character")
	arg0_25.chat = arg0_25:findTF("main/character/chat")
	arg0_25.chatBg = arg0_25:findTF("main/character/chat/chatbgtop")
	arg0_25.chatText = arg0_25:findTF("Text", arg0_25.chat)
	rtf(arg0_25.chat).localScale = Vector3.New(0, 0, 1)
	arg0_25.initChatBgH = arg0_25.chatBg.sizeDelta.y
	arg0_25.initChatTextH = arg0_25.chatText.sizeDelta.y
	arg0_25.initfontSize = arg0_25.chatText:GetComponent(typeof(Text)).fontSize
end

function var0_0.initPages(arg0_26)
	ShipViewConst.currentPage = nil
	arg0_26.background = arg0_26:findTF("background")

	setActive(arg0_26.background, true)

	arg0_26.main = arg0_26:findTF("main")
	arg0_26.mainMask = arg0_26.main:GetComponent(typeof(RectMask2D))
	arg0_26.toggles = arg0_26:findTF("left_length/frame/root", arg0_26.common)
	arg0_26.detailToggle = arg0_26.toggles:Find("detail_toggle")
	arg0_26.equipmentToggle = arg0_26.toggles:Find("equpiment_toggle")
	arg0_26.intensifyToggle = arg0_26.toggles:Find("intensify_toggle")
	arg0_26.upgradeToggle = arg0_26.toggles:Find("upgrade_toggle")
	arg0_26.remouldToggle = arg0_26.toggles:Find("remould_toggle")
	arg0_26.technologyToggle = arg0_26.toggles:Find("technology_toggle")
	arg0_26.metaToggle = arg0_26.toggles:Find("meta_toggle")
	arg0_26.togglesList = {}
	arg0_26.togglesList[ShipViewConst.PAGE.DETAIL] = arg0_26.detailToggle
	arg0_26.togglesList[ShipViewConst.PAGE.EQUIPMENT] = arg0_26.equipmentToggle
	arg0_26.togglesList[ShipViewConst.PAGE.INTENSIFY] = arg0_26.intensifyToggle
	arg0_26.togglesList[ShipViewConst.PAGE.UPGRADE] = arg0_26.upgradeToggle
	arg0_26.togglesList[ShipViewConst.PAGE.REMOULD] = arg0_26.remouldToggle
	arg0_26.detailContainer = arg0_26.main:Find("detail_container")

	setAnchoredPosition(arg0_26.detailContainer, {
		x = 1300
	})

	arg0_26.fashionContainer = arg0_26.main:Find("fashion_container")

	setAnchoredPosition(arg0_26.fashionContainer, {
		x = 900
	})

	arg0_26.equipContainer = arg0_26.main:Find("equip_container")
	arg0_26.equipLCon = arg0_26.equipContainer:Find("equipment_l_container")
	arg0_26.equipRCon = arg0_26.equipContainer:Find("equipment_r_container")
	arg0_26.equipBCon = arg0_26.equipContainer:Find("equipment_b_container")

	setAnchoredPosition(arg0_26.equipRCon, {
		x = 750
	})
	setAnchoredPosition(arg0_26.equipLCon, {
		x = -700
	})
	setAnchoredPosition(arg0_26.equipBCon, {
		y = -540
	})

	arg0_26.shipDetailView = ShipDetailView.New(arg0_26.detailContainer, arg0_26.event, arg0_26.contextData)
	arg0_26.shipFashionView = ShipFashionView.New(arg0_26.fashionContainer, arg0_26.event, arg0_26.contextData)
	arg0_26.shipEquipView = ShipEquipView.New(arg0_26.equipContainer, arg0_26.event, arg0_26.contextData)
	arg0_26.shipHuntingRangeView = ShipHuntingRangeView.New(arg0_26._tf, arg0_26.event, arg0_26.contextData)
	arg0_26.shipCustomMsgBox = ShipCustomMsgBox.New(arg0_26._tf, arg0_26.event, arg0_26.contextData)
	arg0_26.shipChangeNameView = ShipChangeNameView.New(arg0_26._tf, arg0_26.event, arg0_26.contextData)
	arg0_26.expItemUsagePage = ShipExpItemUsagePage.New(arg0_26._tf, arg0_26.event, arg0_26.contextData)

	for iter0_26, iter1_26 in ipairs({
		arg0_26.shipDetailView,
		arg0_26.shipFashionView,
		arg0_26.shipEquipView,
		arg0_26.shipHuntingRangeView,
		arg0_26.shipCustomMsgBox,
		arg0_26.shipChangeNameView,
		arg0_26.expItemUsagePage
	}) do
		iter1_26:RegisterView(arg0_26)
	end

	arg0_26.viewList = {}
	arg0_26.viewList[ShipViewConst.PAGE.DETAIL] = arg0_26.shipDetailView
	arg0_26.viewList[ShipViewConst.PAGE.FASHION] = arg0_26.shipFashionView
	arg0_26.viewList[ShipViewConst.PAGE.EQUIPMENT] = arg0_26.shipEquipView

	onButton(arg0_26, arg0_26.shipName, function()
		if arg0_26.shipVO.propose and not arg0_26.shipVO:IsXIdol() then
			if not pg.PushNotificationMgr.GetInstance():isEnableShipName() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_switch_tip"))

				return
			end

			local var0_27 = arg0_26.shipVO.renameTime + 2592000 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0_27 > 0 then
				local var1_27 = math.floor(var0_27 / 60 / 60 / 24)

				if var1_27 < 1 then
					var1_27 = 1
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_time_tip", var1_27))
			else
				arg0_26:DisplayRenamePanel(true)
			end
		end
	end, SFX_PANEL)
end

function var0_0.initEvents(arg0_28)
	arg0_28:bind(ShipViewConst.SWITCH_TO_PAGE, function(arg0_29, arg1_29)
		arg0_28:gotoPage(arg1_29)
	end)
	arg0_28:bind(ShipViewConst.LOAD_PAINTING, function(arg0_30, arg1_30, arg2_30)
		arg0_28:loadPainting(arg1_30, arg2_30)
	end)
	arg0_28:bind(ShipViewConst.LOAD_PAINTING_BG, function(arg0_31, arg1_31, arg2_31, arg3_31)
		arg0_28:loadSkinBg(arg1_31, arg2_31, arg3_31, arg0_28.isSpBg)
	end)
	arg0_28:bind(ShipViewConst.HIDE_SHIP_WORD, function(arg0_32)
		arg0_28:hideShipWord()
	end)
	arg0_28:bind(ShipViewConst.SET_CLICK_ENABLE, function(arg0_33, arg1_33)
		arg0_28.mainCanvasGroup.blocksRaycasts = arg1_33
		arg0_28.commonCanvasGroup.blocksRaycasts = arg1_33
		GetOrAddComponent(arg0_28.detailContainer, "CanvasGroup").blocksRaycasts = arg1_33
	end)
	arg0_28:bind(ShipViewConst.SHOW_CUSTOM_MSG, function(arg0_34, arg1_34)
		arg0_28.shipCustomMsgBox:Load()
		arg0_28.shipCustomMsgBox:ActionInvoke("showCustomMsgBox", arg1_34)
	end)
	arg0_28:bind(ShipViewConst.HIDE_CUSTOM_MSG, function(arg0_35)
		arg0_28.shipCustomMsgBox:ActionInvoke("hideCustomMsgBox")
	end)
	arg0_28:bind(ShipViewConst.DISPLAY_HUNTING_RANGE, function(arg0_36, arg1_36)
		if arg1_36 then
			arg0_28.shipHuntingRangeView:Load()
			arg0_28.shipHuntingRangeView:ActionInvoke("DisplayHuntingRange")
		else
			arg0_28.shipHuntingRangeView:HideHuntingRange()
		end
	end)
	arg0_28:bind(ShipViewConst.PAINT_VIEW, function(arg0_37, arg1_37)
		if arg1_37 then
			arg0_28:paintView()
		else
			arg0_28:hidePaintView(true)
		end
	end)
	arg0_28:bind(ShipViewConst.SHOW_EXP_ITEM_USAGE, function(arg0_38, arg1_38)
		arg0_28.expItemUsagePage:ExecuteAction("Show", arg1_38)
	end)
end

function var0_0.didEnter(arg0_39)
	arg0_39:addRingDragListenter()
	onButton(arg0_39, arg0_39:findTF("top/back_btn", arg0_39.common), function()
		GetOrAddComponent(arg0_39._tf, typeof(CanvasGroup)).interactable = false

		if not arg0_39.everTriggerBack then
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0_39:closeView()
			end))

			arg0_39.everTriggerBack = true
		end
	end, SFX_CANCEL)
	onButton(arg0_39, arg0_39.npcFlagTF, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_actnpc.tip
		})
	end, SFX_PANEL)

	arg0_39.helpBtn = arg0_39:findTF("help_btn", arg0_39.common)

	onButton(arg0_39, arg0_39.helpBtn, function()
		arg0_39:openHelpPage(ShipViewConst.currentPage)
	end, SFX_PANEL)

	for iter0_39, iter1_39 in pairs(arg0_39.togglesList) do
		if iter1_39 == arg0_39.upgradeToggle or iter1_39 == arg0_39.remouldToggle or iter1_39 == arg0_39.equipmentToggle then
			onToggle(arg0_39, iter1_39, function(arg0_44)
				if arg0_44 then
					if LeanTween.isTweening(go(arg0_39.chat)) then
						LeanTween.cancel(go(arg0_39.chat))
					end

					rtf(arg0_39.chat).localScale = Vector3.New(0, 0, 1)
					arg0_39.chatFlag = false

					arg0_39:switchToPage(iter0_39)
				end
			end, SFX_PANEL)
		else
			onToggle(arg0_39, iter1_39, function(arg0_45)
				if arg0_45 then
					arg0_39:switchToPage(iter0_39)
				end
			end, SFX_PANEL)
		end
	end

	onButton(arg0_39, arg0_39.technologyToggle, function()
		arg0_39:emit(ShipMainMediator.ON_TECHNOLOGY, arg0_39.shipVO)
	end, SFX_PANEL)
	onButton(arg0_39, arg0_39.metaToggle, function()
		arg0_39:emit(ShipMainMediator.ON_META, arg0_39.shipVO)
	end, SFX_PANEL)
	onButton(arg0_39, tf(arg0_39.character), function()
		if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
			arg0_39:displayShipWord("detail")
		end
	end)
	onButton(arg0_39, arg0_39.energyTF, function()
		arg0_39:showEnergyDesc()
		getProxy(CommanderManualProxy):TaskProgressAdd(2022, 1)
	end)
	arg0_39:OverlayPanel(arg0_39.chat, {
		groupDelta = 1
	})
	arg0_39:OverlayPanel(arg0_39.blurPanel)

	local var0_39 = arg0_39:checkToggleActive(arg0_39.contextData.page) and arg0_39.contextData.page or ShipViewConst.PAGE.DETAIL

	arg0_39:gotoPage(var0_39)

	if ShipViewConst.currentPage == ShipViewConst.PAGE.DETAIL or var0_39 == ShipViewConst.PAGE.DETAIL then
		arg0_39:displayShipWord(arg0_39:getInitmacyWords())
		arg0_39:checkMaxLevelHelp()
	end

	arg0_39:changePaintingSortLayer(true)
end

function var0_0.openHelpPage(arg0_50, arg1_50)
	if arg1_50 == ShipViewConst.PAGE.EQUIPMENT then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_equip.tip
		})
	elseif arg1_50 == ShipViewConst.PAGE.DETAIL then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_detail.tip
		})
	elseif arg1_50 == ShipViewConst.PAGE.INTENSIFY then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_intensify.tip
		})
	elseif arg1_50 == ShipViewConst.PAGE.UPGRADE then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_upgrate.tip
		})
	elseif arg1_50 == ShipViewConst.PAGE.FASHION then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_fashion.tip
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_maxlevel.tip
		})
	end
end

function var0_0.showAwakenCompleteAni(arg0_51, arg1_51)
	local function var0_51()
		arg0_51.awakenAni:SetActive(true)

		arg0_51.awakenPlay = true

		onButton(arg0_51, arg0_51.awakenAni, function()
			arg0_51.awakenAni:GetComponent("Animator"):SetBool("endFlag", true)
		end)

		local var0_52 = tf(arg0_51.awakenAni)

		pg.UIMgr.GetInstance():BlurPanel(var0_52)
		setText(arg0_51:findTF("window/desc", arg0_51.awakenAni), arg1_51)
		var0_52:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_54)
			arg0_51.awakenAni:GetComponent("Animator"):SetBool("endFlag", false)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_52, arg0_51.common)
			arg0_51.awakenAni:SetActive(false)

			arg0_51.awakenPlay = false
		end)
	end

	local var1_51 = arg0_51:findTF("AwakenCompleteWindows(Clone)")

	if var1_51 then
		arg0_51.awakenAni = go(var1_51)
	end

	if not arg0_51.awakenAni then
		PoolMgr.GetInstance():GetUI("AwakenCompleteWindows", true, function(arg0_55)
			arg0_55:SetActive(true)

			arg0_51.awakenAni = arg0_55

			var0_51()
		end)
	else
		var0_51()
	end
end

function var0_0.updatePreference(arg0_56, arg1_56)
	local var0_56 = arg1_56:getConfigTable()
	local var1_56 = arg0_56.shipVO:getName()

	setScrollText(arg0_56.shipName:Find("nameRect/name_mask/Text"), var1_56)
	setText(arg0_56:findTF("english_name", arg0_56.shipName), var0_56.english_name)
	setActive(arg0_56.nameEditFlag, arg1_56.propose and not arg1_56:IsXIdol())

	local var2_56 = GetSpriteFromAtlas("energy", arg1_56:getEnergyPrint())

	if not var2_56 then
		warning("找不到疲劳")
	end

	setImageSprite(arg0_56.energyTF, var2_56, true)
	setActive(arg0_56.energyTF, true)

	local var3_56 = arg0_56:findTF("stars", arg0_56.shipName)

	removeAllChildren(var3_56)

	local var4_56 = arg1_56:getStar()
	local var5_56 = arg1_56:getMaxStar()

	for iter0_56 = 1, var5_56 do
		local var6_56 = cloneTplTo(arg0_56.shipInfoStarTpl, var3_56, "star_" .. iter0_56)

		setActive(var6_56:Find("star_tpl"), iter0_56 <= var4_56)
		setActive(var6_56:Find("empty_star_tpl"), true)
	end

	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
		arg0_56:loadPainting(arg0_56.shipVO:getPainting())
		arg0_56:loadSkinBg(arg0_56.shipVO:rarity2bgPrintForGet(), arg0_56.shipVO:isBluePrintShip(), arg0_56.shipVO:isMetaShip(), arg0_56.isSpBg)
	end

	local var7_56 = GetSpriteFromAtlas("shiptype", arg1_56:getShipType())

	if not var7_56 then
		warning("找不到船形, shipConfigId: " .. arg1_56.configId)
	end

	setImageSprite(arg0_56:findTF("type", arg0_56.shipName), var7_56, true)
end

function var0_0.doUpgradeMaxLeveAnim(arg0_57, arg1_57, arg2_57, arg3_57)
	arg0_57.inUpgradeAnim = true

	arg0_57.shipDetailView:DoLeveUpAnim(arg1_57, arg2_57, function()
		if arg3_57 then
			arg3_57()
		end

		arg0_57.inUpgradeAnim = nil
	end)
end

function var0_0.addRingDragListenter(arg0_59)
	local var0_59 = GetOrAddComponent(arg0_59._tf, "EventTriggerListener")
	local var1_59
	local var2_59 = 0
	local var3_59

	var0_59:AddBeginDragFunc(function()
		var2_59 = 0
		var1_59 = nil
	end)
	var0_59:AddDragFunc(function(arg0_61, arg1_61)
		if not arg0_59.inPaintingView then
			local var0_61 = arg1_61.position

			if not var1_59 then
				var1_59 = var0_61
			end

			var2_59 = var0_61.x - var1_59.x
		end
	end)
	var0_59:AddDragEndFunc(function(arg0_62, arg1_62)
		if not arg0_59.inPaintingView then
			if var2_59 < -50 then
				if not arg0_59.isLoading then
					arg0_59:emit(ShipMainMediator.NEXTSHIP, -1)
				end
			elseif var2_59 > 50 and not arg0_59.isLoading then
				arg0_59:emit(ShipMainMediator.NEXTSHIP)
			end
		end
	end)
end

function var0_0.showEnergyDesc(arg0_63)
	if arg0_63.energyTimer then
		return
	end

	setActive(arg0_63.energyDescTF, true)

	local var0_63, var1_63 = arg0_63.shipVO:getEnergyPrint()

	setText(arg0_63.energyText, i18n(var1_63))

	arg0_63.energyTimer = Timer.New(function()
		setActive(arg0_63.energyDescTF, false)
		arg0_63.energyTimer:Stop()

		arg0_63.energyTimer = nil
	end, 2, 1)

	arg0_63.energyTimer:Start()
end

function var0_0.displayShipWord(arg0_65, arg1_65, arg2_65)
	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT or ShipViewConst.currentPage == ShipViewConst.PAGE.UPGRADE then
		rtf(arg0_65.chat).localScale = Vector3.New(0, 0, 1)

		return
	end

	if arg2_65 or not arg0_65.chatFlag then
		arg0_65.chatFlag = true
		arg0_65.chat.localScale = Vector3.zero

		setActive(arg0_65.chat, true)

		arg0_65.chat.localPosition = Vector3(arg0_65.character.localPosition.x + 100, arg0_65.chat.localPosition.y, 0)

		local var0_65 = arg0_65.shipVO:getCVIntimacy()

		if findTF(arg0_65.nowPainting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0_65.nowPainting, "fitter"):GetChild(0), arg0_65.paintingCode, arg1_65, var0_65)
		end

		local var1_65, var2_65, var3_65 = ShipWordHelper.GetWordAndCV(arg0_65.shipVO:getSkinId(), arg1_65, nil, nil, var0_65)
		local var4_65 = arg0_65.chatText:GetComponent(typeof(Text))

		if PLATFORM_CODE ~= PLATFORM_US then
			setText(arg0_65.chatText, SwitchSpecialChar(var3_65))
		else
			var4_65.fontSize = arg0_65.initfontSize

			setTextEN(arg0_65.chatText, var3_65)

			while var4_65.preferredHeight > arg0_65.initChatTextH do
				var4_65.fontSize = var4_65.fontSize - 2

				setTextEN(arg0_65.chatText, var3_65)

				if var4_65.fontSize < 20 then
					break
				end
			end
		end

		if #var4_65.text > CHAT_POP_STR_LEN then
			var4_65.alignment = TextAnchor.MiddleLeft
		else
			var4_65.alignment = TextAnchor.MiddleCenter
		end

		local var5_65 = var4_65.preferredHeight + 120

		if var5_65 > arg0_65.initChatBgH then
			arg0_65.chatBg.sizeDelta = Vector2.New(arg0_65.chatBg.sizeDelta.x, var5_65)
		else
			arg0_65.chatBg.sizeDelta = Vector2.New(arg0_65.chatBg.sizeDelta.x, arg0_65.initChatBgH)
		end

		local var6_65 = var4_0

		local function var7_65()
			if arg0_65.chatFlag then
				if arg0_65.chatani1Id then
					LeanTween.cancel(arg0_65.chatani1Id)
				end

				if arg0_65.chatani2Id then
					LeanTween.cancel(arg0_65.chatani2Id)
				end
			end

			arg0_65.chatani1Id = LeanTween.scale(rtf(arg0_65.chat.gameObject), Vector3.New(1, 1, 1), var3_0):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				arg0_65.chatani2Id = LeanTween.scale(rtf(arg0_65.chat.gameObject), Vector3.New(0, 0, 1), var3_0):setEase(LeanTweenType.easeInBack):setDelay(var3_0 + var6_65):setOnComplete(System.Action(function()
					arg0_65.chatFlag = nil
				end)).uniqueId
			end)).uniqueId
		end

		if var2_65 then
			arg0_65:StopPreVoice()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_65, function(arg0_69)
				if arg0_69 then
					var6_65 = arg0_69:GetLength() * 0.001
				end

				var7_65()
			end)

			arg0_65.preVoiceContent = var2_65
		else
			var7_65()
		end
	end
end

function var0_0.StopPreVoice(arg0_70)
	if arg0_70.preVoiceContent ~= nil then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_70.preVoiceContent)
	end
end

function var0_0.startChatTimer(arg0_71)
	if arg0_71.chatFlag then
		return
	end

	if arg0_71.chatTimer then
		arg0_71.chatTimer:Stop()

		arg0_71.chatTimer = nil
	end

	arg0_71.chatTimer = Timer.New(function()
		arg0_71:displayShipWord(arg0_71:getInitmacyWords())
	end, var6_0, 1)

	arg0_71.chatTimer:Start()
end

function var0_0.hideShipWord(arg0_73)
	if arg0_73.chatFlag then
		if arg0_73.chatani1Id then
			LeanTween.cancel(arg0_73.chatani1Id)
		end

		if arg0_73.chatani2Id then
			LeanTween.cancel(arg0_73.chatani2Id)
		end

		LeanTween.scale(rtf(arg0_73.chat.gameObject), Vector3.New(0, 0, 1), var3_0):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function()
			arg0_73.chatFlag = nil
		end))
	end

	arg0_73:StopPreVoice()
end

function var0_0.gotoPage(arg0_75, arg1_75)
	if arg1_75 == ShipViewConst.PAGE.FASHION then
		local function var0_75()
			arg0_75:switchToPage(arg1_75)
		end

		arg0_75:checkPaintingRes(var0_75)
	else
		triggerToggle(arg0_75.togglesList[arg1_75], true)
	end
end

function var0_0.switchToPage(arg0_77, arg1_77, arg2_77)
	local function var0_77(arg0_78, arg1_78)
		setActive(arg0_77.detailContainer, false)

		if arg0_78 == ShipViewConst.PAGE.DETAIL then
			setActive(arg0_77.detailContainer, arg1_78)

			local var0_78 = arg1_78 and {
				arg0_77.detailContainer.rect.width + 200,
				0
			} or {
				0,
				arg0_77.detailContainer.rect.width + 200
			}

			shiftPanel(arg0_77.detailContainer, var0_78[2], 0, var2_0, 0):setFrom(var0_78[1])
		elseif arg0_78 == ShipViewConst.PAGE.EQUIPMENT then
			local var1_78 = {
				-(arg0_77.equipLCon.rect.width + 190),
				190
			}
			local var2_78 = {
				arg0_77.equipRCon.rect.width,
				10
			}
			local var3_78 = {
				-arg0_77.equipBCon.rect.height,
				0
			}
			local var4_78 = arg1_78 and 1 or 2
			local var5_78 = arg1_78 and 2 or 1

			shiftPanel(arg0_77.equipLCon, var1_78[var5_78], 0, var2_0, 0):setFrom(var1_78[var4_78])
			shiftPanel(arg0_77.equipRCon, var2_78[var5_78], 0, var2_0, 0):setFrom(var2_78[var4_78])
			shiftPanel(arg0_77.equipBCon, 0, var3_78[var5_78], var2_0, 0):setFrom(var3_78[var4_78])
		elseif arg0_78 == ShipViewConst.PAGE.FASHION then
			local var6_78 = arg1_78 and {
				arg0_77.fashionContainer.rect.width + 150,
				0
			} or {
				0,
				arg0_77.fashionContainer.rect.width + 150
			}

			shiftPanel(arg0_77.fashionContainer, var6_78[2], 0, var2_0, 0):setFrom(var6_78[1])

			if arg1_78 then
				arg0_77.shipFashionView:ActionInvoke("UpdateFashion")
			end
		elseif arg0_78 == ShipViewConst.PAGE.INTENSIFY then
			if arg1_78 then
				arg0_77:emit(ShipMainMediator.OPEN_INTENSIFY)
			else
				arg0_77:emit(ShipMainMediator.CLOSE_INTENSIFY)
			end
		elseif arg0_78 == ShipViewConst.PAGE.UPGRADE then
			if arg1_78 then
				arg0_77:emit(ShipMainMediator.ON_UPGRADE)
			else
				arg0_77:emit(ShipMainMediator.CLOSE_UPGRADE)
			end
		elseif arg0_78 == ShipViewConst.PAGE.REMOULD then
			if arg1_78 then
				arg0_77:emit(ShipMainMediator.OPEN_REMOULD)
			else
				arg0_77:emit(ShipMainMediator.CLOSE_REMOULD)
			end
		end

		arg0_77:blurPage(arg0_78, arg1_78)

		if arg0_78 ~= ShipViewConst.PAGE.FASHION then
			arg0_77.fashionSkinId = arg0_77.shipVO:getSkinId()

			arg0_77:loadPainting(arg0_77.shipVO:getPainting())
		end

		local var7_78 = not ShipViewConst.IsSubLayerPage(arg0_78)
		local var8_78 = arg0_77.bgEffect[arg0_77.shipVO:getRarity()]

		if var8_78 then
			setActive(var8_78, arg0_78 ~= ShipViewConst.PAGE.REMOULD and arg0_77.shipVO.bluePrintFlag and arg0_77.shipVO.bluePrintFlag == 0)
			arg0_77:changePaintingSortLayer(true)
		end

		setActive(arg0_77.helpBtn, var7_78)
	end

	function switchHandler()
		if arg1_77 == ShipViewConst.currentPage and arg2_77 then
			var0_77(arg1_77, true)
		elseif arg1_77 ~= ShipViewConst.currentPage then
			if ShipViewConst.currentPage then
				var0_77(ShipViewConst.currentPage, false)
			end

			ShipViewConst.currentPage = arg1_77
			arg0_77.contextData.page = arg1_77

			var0_77(arg1_77, true)
			arg0_77:switchPainting()
		end
	end

	if arg0_77.viewList[arg1_77] ~= nil then
		local var1_77 = arg0_77.viewList[arg1_77]

		if not var1_77:GetLoaded() then
			var1_77:Load()
			var1_77:CallbackInvoke(switchHandler)
		else
			switchHandler()
		end
	else
		switchHandler()
	end
end

function var0_0.blurPage(arg0_80, arg1_80, arg2_80)
	if arg1_80 == ShipViewConst.PAGE.DETAIL then
		arg0_80.shipDetailView:ActionInvoke("OnSelected", arg2_80)
	elseif arg1_80 == ShipViewConst.PAGE.EQUIPMENT then
		arg0_80.shipEquipView:ActionInvoke("OnSelected", arg2_80)
	elseif arg1_80 == ShipViewConst.PAGE.FASHION then
		arg0_80.shipFashionView:ActionInvoke("OnSelected", arg2_80)
	elseif arg1_80 == ShipViewConst.PAGE.INTENSIFY then
		-- block empty
	elseif arg1_80 == ShipViewConst.PAGE.UPGRADE then
		-- block empty
	elseif arg1_80 == ShipViewConst.PAGE.REMOULD then
		-- block empty
	end
end

function var0_0.switchPainting(arg0_81)
	setActive(arg0_81.shipInfo, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
	setActive(arg0_81.shipName, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))

	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT then
		shiftPanel(arg0_81.shipInfo, -20, 0, var2_0, 0)

		arg0_81.paintingFrameName = "zhuangbei"
	else
		shiftPanel(arg0_81.shipInfo, -460, 0, var2_0, 0)

		arg0_81.paintingFrameName = "chuanwu"
	end

	local var0_81 = GetOrAddComponent(findTF(arg0_81.nowPainting, "fitter"), "PaintingScaler")

	var0_81:Snapshoot()

	var0_81.FrameName = arg0_81.paintingFrameName

	local var1_81 = LeanTween.value(go(arg0_81.nowPainting), 0, 1, var2_0):setOnUpdate(System.Action_float(function(arg0_82)
		var0_81.Tween = arg0_82
		arg0_81.chat.localPosition = Vector3(arg0_81.character.localPosition.x + 100, arg0_81.chat.localPosition.y, 0)
	end)):setEase(LeanTweenType.easeInOutSine)
end

function var0_0.setPreOrNext(arg0_83, arg1_83, arg2_83)
	if arg1_83 then
		arg0_83.isRight = true
	else
		arg0_83.isRight = false
	end

	if arg0_83.shipVO:getGroupId() ~= arg2_83:getGroupId() then
		arg0_83.switchCnt = (arg0_83.switchCnt or 0) + 1
	end

	if arg0_83.switchCnt and arg0_83.switchCnt >= 10 then
		gcAll()

		arg0_83.switchCnt = 0
	end
end

function var0_0.loadPainting(arg0_84, arg1_84, arg2_84)
	local var0_84 = arg1_84

	arg1_84 = MainMeshImagePainting.StaticGetPaintingName(var0_84)

	if arg0_84.isLoading == true then
		return
	end

	for iter0_84, iter1_84 in pairs(arg0_84.tablePainting) do
		iter1_84.localScale = Vector3(1, 1, 1)
	end

	if arg0_84.LoadShipVOId and not arg2_84 and arg0_84.LoadShipVOId == arg0_84.shipVO.id and arg0_84.LoadPaintingCode == arg1_84 and not arg2_84 then
		return
	end

	local var1_84 = 0
	local var2_84 = arg0_84.isRight and 1800 or -1800
	local var3_84 = arg0_84:getPaintingFromTable(false)

	arg0_84.isLoading = true

	local var4_84 = arg0_84.paintingCode
	local var5_84 = {}

	if var3_84 then
		table.insert(var5_84, function(arg0_85)
			local var0_85 = var3_84:GetComponent(typeof(RectTransform))
			local var1_85 = var3_84:GetComponent(typeof(CanvasGroup))

			LeanTween.cancel(go(var1_85))
			LeanTween.alphaCanvas(var1_85, 0, 0.3):setFrom(1):setUseEstimatedTime(true)
			LeanTween.moveX(var0_85, -var2_84, 0.3):setFrom(0):setOnComplete(System.Action(function()
				retPaintingPrefab(var3_84, var4_84)
				arg0_85()
			end))
		end)
	end

	local var6_84 = arg0_84:getPaintingFromTable(true)

	arg0_84.paintingCode = arg1_84

	if arg0_84.paintingCode and var6_84 then
		local var7_84 = var6_84:GetComponent(typeof(RectTransform))

		table.insert(var5_84, function(arg0_87)
			arg0_84.nowPainting = var6_84

			LoadPaintingPrefabAsync(var6_84, var0_84, arg0_84.paintingCode, arg0_84.paintingFrameName or "chuanwu", function()
				local var0_88 = arg0_84.shipVO:getCVIntimacy()
				local var1_88 = arg0_84:getInitmacyWords()

				ShipExpressionHelper.SetExpression(findTF(var6_84, "fitter"):GetChild(0), arg0_84.paintingCode, var1_88, var0_88)
				arg0_87()
			end)
		end)
		table.insert(var5_84, function(arg0_89)
			LeanTween.cancel(go(var7_84))
			LeanTween.moveX(var7_84, 0, 0.3):setFrom(var2_84):setOnComplete(System.Action(arg0_89))

			local var0_89 = var6_84:GetComponent(typeof(CanvasGroup))

			LeanTween.alphaCanvas(var0_89, 1, 0.3):setFrom(0):setUseEstimatedTime(true)
		end)
	end

	parallelAsync(var5_84, function()
		arg0_84.LoadShipVOId = arg0_84.shipVO.id
		arg0_84.LoadPaintingCode = arg1_84
		arg0_84.isLoading = false
	end)
end

function var0_0.getPaintingFromTable(arg0_91, arg1_91)
	if arg0_91.tablePainting == nil then
		print("self.tablePainting为空")

		return
	end

	for iter0_91 = 1, #arg0_91.tablePainting do
		if findTF(arg0_91.tablePainting[iter0_91], "fitter").childCount == 0 then
			if arg1_91 == true and arg0_91.tablePainting[iter0_91] then
				return arg0_91.tablePainting[iter0_91]
			end
		elseif arg1_91 == false and arg0_91.tablePainting[iter0_91] then
			return arg0_91.tablePainting[iter0_91]
		end
	end
end

function var0_0.loadSkinBg(arg0_92, arg1_92, arg2_92, arg3_92, arg4_92)
	if not arg0_92.bgEffect then
		arg0_92.bgEffect = {}
	end

	if arg0_92.shipSkinBg ~= arg1_92 or arg0_92.isDesign ~= arg2_92 or arg0_92.isMeta ~= arg3_92 then
		arg0_92.shipSkinBg = arg1_92
		arg0_92.isDesign = arg2_92
		arg0_92.isMeta = arg3_92

		if arg0_92.isDesign then
			if arg0_92.metaBg then
				setActive(arg0_92.metaBg, false)
			end

			if arg0_92.bgEffect then
				for iter0_92, iter1_92 in pairs(arg0_92.bgEffect) do
					setActive(iter1_92, false)
				end
			end

			if arg0_92.designBg and arg0_92.designName ~= "raritydesign" .. arg0_92.shipVO:getRarity() then
				PoolMgr.GetInstance():ReturnUI(arg0_92.designName, arg0_92.designBg)

				arg0_92.designBg = nil
			end

			if not arg0_92.designBg then
				PoolMgr.GetInstance():GetUI("raritydesign" .. arg0_92.shipVO:getRarity(), true, function(arg0_93)
					arg0_92.designBg = arg0_93
					arg0_92.designName = "raritydesign" .. arg0_92.shipVO:getRarity()

					arg0_93.transform:SetParent(arg0_92._tf, false)

					arg0_93.transform.localPosition = Vector3(1, 1, 1)
					arg0_93.transform.localScale = Vector3(1, 1, 1)

					arg0_93.transform:SetSiblingIndex(1)
					setActive(arg0_93, true)
				end)
			else
				setActive(arg0_92.designBg, true)
			end
		elseif arg0_92.isMeta then
			if arg0_92.designBg then
				setActive(arg0_92.designBg, false)
			end

			if arg0_92.metaBg and arg0_92.metaName ~= "raritymeta" .. arg0_92.shipVO:getRarity() then
				PoolMgr.GetInstance():ReturnUI(arg0_92.metaName, arg0_92.metaBg)

				arg0_92.metaBg = nil
			end

			if not arg0_92.metaBg then
				PoolMgr.GetInstance():GetUI("raritymeta" .. arg0_92.shipVO:getRarity(), true, function(arg0_94)
					arg0_92.metaBg = arg0_94
					arg0_92.metaName = "raritymeta" .. arg0_92.shipVO:getRarity()

					arg0_94.transform:SetParent(arg0_92._tf, false)

					arg0_94.transform.localPosition = Vector3(1, 1, 1)
					arg0_94.transform.localScale = Vector3(1, 1, 1)

					arg0_94.transform:SetSiblingIndex(1)
					setActive(arg0_94, true)
				end)
			else
				setActive(arg0_92.metaBg, true)
			end
		else
			if arg0_92.designBg then
				setActive(arg0_92.designBg, false)
			end

			if arg0_92.metaBg then
				setActive(arg0_92.metaBg, false)
			end

			for iter2_92 = 1, 5 do
				local var0_92 = arg0_92.shipVO:getRarity()

				if arg0_92.bgEffect[iter2_92] then
					setActive(arg0_92.bgEffect[iter2_92], iter2_92 == var0_92 and ShipViewConst.currentPage ~= ShipViewConst.PAGE.REMOULD and not arg4_92)
				elseif var0_92 > 2 and var0_92 == iter2_92 and not arg4_92 then
					PoolMgr.GetInstance():GetUI("al_bg02_" .. var0_92 - 1, true, function(arg0_95)
						arg0_92.bgEffect[iter2_92] = arg0_95

						arg0_95.transform:SetParent(arg0_92._tf, false)

						arg0_95.transform.localPosition = Vector3(0, 0, 0)
						arg0_95.transform.localScale = Vector3(1, 1, 1)

						arg0_95.transform:SetSiblingIndex(1)
						setActive(arg0_95, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
					end)
				end

				arg0_92:changePaintingSortLayer(true)
			end
		end

		GetSpriteFromAtlasAsync("bg/star_level_bg_" .. arg1_92, "", function(arg0_96)
			if not arg0_92.exited and arg0_92.shipSkinBg == arg1_92 then
				setImageSprite(arg0_92.background, arg0_96)
			end
		end)
	end
end

function var0_0.changePaintingSortLayer(arg0_97, arg1_97)
	local var0_97
	local var1_97 = arg1_97 and 12 or -1

	for iter0_97, iter1_97 in ipairs(arg0_97.tablePainting) do
		GetComponent(iter1_97, typeof(Canvas)).sortingOrder = var1_97
	end

	if arg1_97 then
		local var2_97 = arg0_97.shipVO:getRarity()

		if arg0_97.isDesign and arg0_97.designBg then
			setActive(arg0_97.designBg, true)
		elseif arg0_97.bgEffect and var2_97 and arg0_97.bgEffect[var2_97] then
			setActive(arg0_97.bgEffect[var2_97], true)
		end
	else
		if arg0_97.designBg then
			setActive(arg0_97.designBg, false)
		end

		if arg0_97.bgEffect then
			for iter2_97, iter3_97 in pairs(arg0_97.bgEffect) do
				setActive(iter3_97, false)
			end
		end
	end
end

function var0_0.getInitmacyWords(arg0_98)
	local var0_98 = arg0_98.shipVO:getIntimacyLevel()
	local var1_98 = Mathf.Clamp(var0_98, 1, 5)

	return "feeling" .. var1_98
end

function var0_0.paintView(arg0_99)
	if LeanTween.isTweening(arg0_99.chat.gameObject) then
		LeanTween.cancel(arg0_99.chat.gameObject)

		arg0_99.chat.localScale = Vector3(0, 0, 0)
		arg0_99.chatFlag = nil
	end

	arg0_99.character:GetComponent("Image").enabled = false
	arg0_99.inPaintingView = true

	local var0_99 = {}
	local var1_99 = arg0_99._tf.childCount
	local var2_99 = 0

	while var2_99 < var1_99 do
		local var3_99 = arg0_99._tf:GetChild(var2_99)

		if var3_99.gameObject.activeSelf and var3_99 ~= arg0_99.main and var3_99 ~= arg0_99.background then
			var0_99[#var0_99 + 1] = var3_99

			setActive(var3_99, false)
		end

		var2_99 = var2_99 + 1
	end

	local var4_99 = arg0_99.main.childCount
	local var5_99 = 0

	while var5_99 < var4_99 do
		local var6_99 = arg0_99.main:GetChild(var5_99)

		if var6_99.gameObject.activeSelf and var6_99 ~= arg0_99.shipInfo then
			var0_99[#var0_99 + 1] = var6_99

			setActive(var6_99, false)
		end

		var5_99 = var5_99 + 1
	end

	arg0_99.shipDetailView:Hide()
	setActive(arg0_99.blurPanel, false)
	setActive(pg.playerResUI._go, false)

	var0_99[#var0_99 + 1] = arg0_99.chat

	openPortrait()
	setActive(arg0_99.common, false)

	arg0_99.mainMask.enabled = false

	arg0_99.mainMask:PerformClipping()

	local var7_99 = arg0_99.nowPainting
	local var8_99 = var7_99.anchoredPosition.x
	local var9_99 = var7_99.anchoredPosition.y
	local var10_99 = var7_99.rect.width
	local var11_99 = var7_99.rect.height
	local var12_99 = arg0_99._tf.rect.width / UnityEngine.Screen.width
	local var13_99 = arg0_99._tf.rect.height / UnityEngine.Screen.height
	local var14_99 = var10_99 / 2
	local var15_99 = var11_99 / 2
	local var16_99
	local var17_99
	local var18_99 = GetOrAddComponent(arg0_99.background, "PinchZoom")
	local var19_99 = GetOrAddComponent(arg0_99.background, "EventTriggerListener")
	local var20_99 = true
	local var21_99 = false

	var19_99:AddPointDownFunc(function(arg0_100)
		if Input.touchCount == 1 or IsUnityEditor then
			var21_99 = true
			var20_99 = true
		elseif Input.touchCount >= 2 then
			var20_99 = false
			var21_99 = false
		end
	end)
	var19_99:AddPointUpFunc(function(arg0_101)
		if Input.touchCount <= 2 then
			var20_99 = true
		end
	end)
	var19_99:AddBeginDragFunc(function(arg0_102, arg1_102)
		var21_99 = false
		var16_99 = arg1_102.position.x * var12_99 - var14_99 - tf(arg0_99.nowPainting).localPosition.x
		var17_99 = arg1_102.position.y * var13_99 - var15_99 - tf(arg0_99.nowPainting).localPosition.y
	end)
	var19_99:AddDragFunc(function(arg0_103, arg1_103)
		if var18_99.processing then
			return
		end

		if var20_99 then
			local var0_103 = tf(arg0_99.nowPainting).localPosition

			tf(arg0_99.nowPainting).localPosition = Vector3(arg1_103.position.x * var12_99 - var14_99 - var16_99, arg1_103.position.y * var13_99 - var15_99 - var17_99, -22)
		end
	end)
	onButton(arg0_99, arg0_99.background, function()
		arg0_99:hidePaintView()
	end, SFX_CANCEL)

	function var0_0.hidePaintView(arg0_105, arg1_105)
		if not arg1_105 and not var21_99 then
			return
		end

		arg0_105.character:GetComponent("Image").enabled = true
		Input.multiTouchEnabled = false

		setActive(arg0_105.common, true)
		SwitchPanel(arg0_105.shipInfo, -460, nil, var2_0 * 2)

		var19_99.enabled = false
		var18_99.enabled = false
		arg0_105.character.localScale = Vector3.one

		arg0_105.shipDetailView:Show()
		setActive(arg0_105.blurPanel, true)
		setActive(pg.playerResUI._go, true)

		for iter0_105, iter1_105 in ipairs(var0_99) do
			setActive(iter1_105, true)
		end

		closePortrait()

		arg0_105.nowPainting.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0_105.nowPainting, {
			x = var8_99,
			y = var9_99
		})

		arg0_105.background:GetComponent("Button").enabled = false
		arg0_105.nowPainting:GetComponent("CanvasGroup").blocksRaycasts = true
		arg0_105.mainMask.enabled = true

		arg0_105.mainMask:PerformClipping()

		arg0_105.inPaintingView = false
	end

	SwitchPanel(arg0_99.shipInfo, var1_0, nil, var2_0 * 2):setOnComplete(System.Action(function()
		var18_99.enabled = true
		var19_99.enabled = true
		arg0_99.background:GetComponent("Button").enabled = true
		arg0_99.nowPainting:GetComponent("CanvasGroup").blocksRaycasts = false
	end))
end

function var0_0.onBackPressed(arg0_107)
	if arg0_107.inUpgradeAnim then
		return
	end

	if arg0_107.awakenPlay then
		return
	end

	if arg0_107.shipChangeNameView.isOpenRenamePanel then
		arg0_107.shipChangeNameView:ActionInvoke("DisplayRenamePanel", false)

		return
	end

	if arg0_107.shipCustomMsgBox.isShowCustomMsgBox then
		arg0_107.shipCustomMsgBox:ActionInvoke("hideCustomMsgBox")

		return
	end

	if arg0_107.shipHuntingRangeView.onSelected then
		arg0_107.shipHuntingRangeView:ActionInvoke("HideHuntingRange")

		return
	end

	if arg0_107.inPaintingView then
		arg0_107:hidePaintView(true)

		return
	end

	if arg0_107.expItemUsagePage and arg0_107.expItemUsagePage:GetLoaded() and arg0_107.expItemUsagePage:isShowing() then
		arg0_107.expItemUsagePage:Hide()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_107:findTF("top/back_btn", arg0_107.common))
end

function var0_0.willExit(arg0_108)
	Input.multiTouchEnabled = true

	arg0_108:UnOverlayPanel(arg0_108.chat, arg0_108.character)
	arg0_108:blurPage(ShipViewConst.currentPage)
	setActive(arg0_108.background, false)

	if arg0_108.designBg then
		PoolMgr.GetInstance():ReturnUI(arg0_108.designName, arg0_108.designBg)
	end

	if arg0_108.metaBg then
		PoolMgr.GetInstance():ReturnUI(arg0_108.metaName, arg0_108.metaBg)
	end

	arg0_108.intensifyToggle:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
	arg0_108.upgradeToggle:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
	LeanTween.cancel(arg0_108.chat.gameObject)

	if arg0_108.paintingCode then
		for iter0_108 = 1, #arg0_108.tablePainting do
			local var0_108 = go(arg0_108.tablePainting[iter0_108])

			if LeanTween.isTweening(var0_108) then
				LeanTween.cancel(go(var0_108))
			end
		end

		retPaintingPrefab(arg0_108.nowPainting, arg0_108.paintingCode)
	end

	arg0_108.shipDetailView:Destroy()
	arg0_108.shipFashionView:Destroy()
	arg0_108.shipEquipView:Destroy()
	arg0_108.shipHuntingRangeView:Destroy()
	arg0_108.shipCustomMsgBox:Destroy()
	arg0_108.shipChangeNameView:Destroy()
	clearImageSprite(arg0_108.background)

	if arg0_108.energyTimer then
		arg0_108.energyTimer:Stop()

		arg0_108.energyTimer = nil
	end

	if arg0_108.chatTimer then
		arg0_108.chatTimer:Stop()

		arg0_108.chatTimer = nil
	end

	arg0_108:StopPreVoice()
	cameraPaintViewAdjust(false)

	if arg0_108.tweens then
		cancelTweens(arg0_108.tweens)
	end

	arg0_108:UnOverlayPanel(arg0_108.blurPanel, arg0_108._tf)

	arg0_108.shareData = nil
end

function var0_0.RefreshShipExpItemUsagePage(arg0_109)
	if arg0_109.expItemUsagePage and arg0_109.expItemUsagePage:GetLoaded() and arg0_109.expItemUsagePage:isShowing() then
		arg0_109.expItemUsagePage:Flush(arg0_109.shipVO)
	end
end

function var0_0.OnWillLogout(arg0_110)
	if arg0_110.inPaintingView then
		arg0_110:hidePaintView(true)
	end
end

function var0_0.checkPaintingRes(arg0_111, arg1_111)
	local var0_111 = PaintingGroupConst.GetPaintingNameListByShipVO(arg0_111.shipVO)
	local var1_111 = {
		isShowBox = true,
		paintingNameList = var0_111,
		finishFunc = arg1_111
	}

	PaintingGroupConst.PaintingDownload(var1_111)
end

return var0_0
