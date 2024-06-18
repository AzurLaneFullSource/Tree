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
	return {
		anim = true,
		showType = PlayerResUI.TYPE_ALL,
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	}
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

			local var0_5 = PoolMgr.GetInstance()
			local var1_5 = "ShipDetailView"

			if not var0_5:HasCacheUI(var1_5) then
				var0_5:GetUI(var1_5, true, function(arg0_6)
					var0_5:ReturnUI(var1_5, arg0_6)
					arg0_5()
				end)
			else
				arg0_5()
			end
		end
	}, arg1_3)
end

function var0_0.setPlayer(arg0_7, arg1_7)
	arg0_7.player = arg1_7

	arg0_7:GetShareData():SetPlayer(arg1_7)
end

function var0_0.setShipList(arg0_8, arg1_8)
	arg0_8.shipList = arg1_8
end

function var0_0.setShip(arg0_9, arg1_9)
	arg0_9:GetShareData():SetShipVO(arg1_9)

	local var0_9 = false

	if arg0_9.shipVO and arg0_9.shipVO.id ~= arg1_9.id then
		arg0_9:StopPreVoice()

		var0_9 = true
	end

	arg0_9.shipVO = arg1_9

	setActive(arg0_9.npcFlagTF, arg1_9:isActivityNpc())

	if var0_9 and not arg0_9:checkToggleActive(ShipViewConst.currentPage) then
		triggerToggle(arg0_9.detailToggle, true)
	end

	arg0_9:setToggleEnable()

	local var1_9 = pg.ship_skin_template[arg0_9.shipVO.skinId]

	arg0_9.isSpBg = var1_9.rarity_bg and var1_9.rarity_bg ~= ""

	arg0_9:updatePreference(arg1_9)
	arg0_9.shipDetailView:ActionInvoke("UpdateUI")
	arg0_9.shipFashionView:ActionInvoke("UpdateUI")
	arg0_9.shipEquipView:ActionInvoke("UpdateUI")
end

function var0_0.equipmentChange(arg0_10)
	if arg0_10.shipDetailView then
		arg0_10.shipDetailView:ActionInvoke("UpdateUI")
	end
end

function var0_0.setToggleEnable(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.togglesList) do
		setActive(iter1_11, arg0_11:checkToggleActive(iter0_11))
	end

	setActive(arg0_11.technologyToggle, arg0_11.shipVO:isBluePrintShip())
	SetActive(arg0_11.metaToggle, arg0_11.shipVO:isMetaShip())
end

function var0_0.checkToggleActive(arg0_12, arg1_12)
	if arg1_12 == ShipViewConst.PAGE.DETAIL then
		return true
	elseif arg1_12 == ShipViewConst.PAGE.EQUIPMENT then
		return true
	elseif arg1_12 == ShipViewConst.PAGE.INTENSIFY then
		return not arg0_12.shipVO:isTestShip() and not arg0_12.shipVO:isBluePrintShip() and not arg0_12.shipVO:isMetaShip()
	elseif arg1_12 == ShipViewConst.PAGE.UPGRADE then
		return not arg0_12.shipVO:isTestShip() and not arg0_12.shipVO:isBluePrintShip() and not arg0_12.shipVO:isMetaShip()
	elseif arg1_12 == ShipViewConst.PAGE.REMOULD then
		return not arg0_12.shipVO:isTestShip() and not arg0_12.shipVO:isBluePrintShip() and pg.ship_data_trans[arg0_12.shipVO.groupId] and not arg0_12.shipVO:isMetaShip()
	elseif arg1_12 == ShipViewConst.PAGE.FASHION then
		if not arg0_12:hasFashion() then
			return false
		else
			local var0_12
			local var1_12

			if not PaintingGroupConst.IsPaintingNeedCheck() then
				var1_12 = false
			else
				local var2_12 = PaintingGroupConst.GetPaintingNameListByShipVO(arg0_12.shipVO)

				var1_12 = PaintingGroupConst.CalcPaintingListSize(var2_12) > 0
			end

			return not var1_12
		end
	else
		return false
	end
end

function var0_0.setSkinList(arg0_13, arg1_13)
	arg0_13.shipFashionView:ActionInvoke("SetSkinList", arg1_13)
end

function var0_0.updateLock(arg0_14)
	arg0_14.shipDetailView:ActionInvoke("UpdateLock")
end

function var0_0.updatePreferenceTag(arg0_15)
	arg0_15.shipDetailView:ActionInvoke("UpdatePreferenceTag")
end

function var0_0.updateFashionTag(arg0_16)
	arg0_16.shipDetailView:ActionInvoke("UpdateFashionTag")
end

function var0_0.closeRecordPanel(arg0_17)
	arg0_17.shipDetailView:ActionInvoke("CloseRecordPanel")
end

function var0_0.updateRecordEquipments(arg0_18, arg1_18)
	arg0_18.shipDetailView:UpdateRecordEquipments(arg1_18)
	arg0_18.shipDetailView:UpdateRecordSpWeapons(arg1_18)
end

function var0_0.setModPanel(arg0_19, arg1_19)
	arg0_19.modPanel = arg1_19
end

function var0_0.setMaxLevelHelpFlag(arg0_20, arg1_20)
	arg0_20.maxLevelHelpFlag = arg1_20
end

function var0_0.checkMaxLevelHelp(arg0_21)
	if not arg0_21.maxLevelHelpFlag and arg0_21.shipVO and arg0_21.shipVO:isReachNextMaxLevel() then
		arg0_21:openHelpPage()

		arg0_21.maxLevelHelpFlag = true

		getProxy(SettingsProxy):setMaxLevelHelp(true)
	end
end

function var0_0.GetShareData(arg0_22)
	if not arg0_22.shareData then
		arg0_22.shareData = ShipViewShareData.New(arg0_22.contextData)

		arg0_22.shipDetailView:SetShareData(arg0_22.shareData)
		arg0_22.shipFashionView:SetShareData(arg0_22.shareData)
		arg0_22.shipEquipView:SetShareData(arg0_22.shareData)
		arg0_22.shipEquipView:ActionInvoke("InitEvent")
		arg0_22.shipHuntingRangeView:SetShareData(arg0_22.shareData)
		arg0_22.shipCustomMsgBox:SetShareData(arg0_22.shareData)
		arg0_22.shipChangeNameView:SetShareData(arg0_22.shareData)
	end

	return arg0_22.shareData
end

function var0_0.hasFashion(arg0_23)
	return arg0_23.shareData:HasFashion()
end

function var0_0.DisplayRenamePanel(arg0_24, arg1_24)
	arg0_24.shipChangeNameView:Load()
	arg0_24.shipChangeNameView:ActionInvoke("DisplayRenamePanel", arg1_24)
end

function var0_0.init(arg0_25)
	arg0_25:initShip()
	arg0_25:initPages()
	arg0_25:initEvents()

	arg0_25.mainCanvasGroup = arg0_25._tf:GetComponent(typeof(CanvasGroup))
	arg0_25.commonCanvasGroup = arg0_25:findTF("blur_panel/adapt"):GetComponent(typeof(CanvasGroup))
	Input.multiTouchEnabled = false
end

function var0_0.initShip(arg0_26)
	arg0_26.shipInfo = arg0_26:findTF("main/character")

	setActive(arg0_26.shipInfo, true)

	arg0_26.tablePainting = {
		arg0_26:findTF("painting", arg0_26.shipInfo),
		arg0_26:findTF("painting2", arg0_26.shipInfo)
	}
	arg0_26.nowPainting = nil
	arg0_26.isRight = true
	arg0_26.blurPanel = arg0_26:findTF("blur_panel")
	arg0_26.common = arg0_26.blurPanel:Find("adapt")
	arg0_26.npcFlagTF = arg0_26.common:Find("name/npc")
	arg0_26.shipName = arg0_26.common:Find("name")
	arg0_26.shipInfoStarTpl = arg0_26.shipName:Find("star_tpl")
	arg0_26.nameEditFlag = arg0_26.shipName:Find("nameRect/editFlag")

	setActive(arg0_26.shipName, true)
	setActive(arg0_26.shipInfoStarTpl, false)
	setActive(arg0_26.nameEditFlag, false)

	arg0_26.energyTF = arg0_26.shipName:Find("energy")
	arg0_26.energyDescTF = arg0_26.energyTF:Find("desc")
	arg0_26.energyText = arg0_26.energyTF:Find("desc/desc")

	setActive(arg0_26.energyDescTF, false)

	arg0_26.character = arg0_26:findTF("main/character")
	arg0_26.chat = arg0_26:findTF("main/character/chat")
	arg0_26.chatBg = arg0_26:findTF("main/character/chat/chatbgtop")
	arg0_26.chatText = arg0_26:findTF("Text", arg0_26.chat)
	rtf(arg0_26.chat).localScale = Vector3.New(0, 0, 1)
	arg0_26.initChatBgH = arg0_26.chatText.sizeDelta.y
	arg0_26.initfontSize = arg0_26.chatText:GetComponent(typeof(Text)).fontSize
	arg0_26.initChatTextH = arg0_26.chatText.sizeDelta.y
	arg0_26.initfontSize = arg0_26.chatText:GetComponent(typeof(Text)).fontSize

	if PLATFORM_CODE == PLATFORM_US then
		local var0_26 = GetComponent(arg0_26.chatText, typeof(Text))

		var0_26.lineSpacing = 1.1
		var0_26.fontSize = 25
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0_26.chat, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})
end

function var0_0.initPages(arg0_27)
	ShipViewConst.currentPage = nil
	arg0_27.background = arg0_27:findTF("background")

	setActive(arg0_27.background, true)

	arg0_27.main = arg0_27:findTF("main")
	arg0_27.mainMask = arg0_27.main:GetComponent(typeof(RectMask2D))
	arg0_27.toggles = arg0_27:findTF("left_length/frame/root", arg0_27.common)
	arg0_27.detailToggle = arg0_27.toggles:Find("detail_toggle")
	arg0_27.equipmentToggle = arg0_27.toggles:Find("equpiment_toggle")
	arg0_27.intensifyToggle = arg0_27.toggles:Find("intensify_toggle")
	arg0_27.upgradeToggle = arg0_27.toggles:Find("upgrade_toggle")
	arg0_27.remouldToggle = arg0_27.toggles:Find("remould_toggle")
	arg0_27.technologyToggle = arg0_27.toggles:Find("technology_toggle")
	arg0_27.metaToggle = arg0_27.toggles:Find("meta_toggle")
	arg0_27.togglesList = {}
	arg0_27.togglesList[ShipViewConst.PAGE.DETAIL] = arg0_27.detailToggle
	arg0_27.togglesList[ShipViewConst.PAGE.EQUIPMENT] = arg0_27.equipmentToggle
	arg0_27.togglesList[ShipViewConst.PAGE.INTENSIFY] = arg0_27.intensifyToggle
	arg0_27.togglesList[ShipViewConst.PAGE.UPGRADE] = arg0_27.upgradeToggle
	arg0_27.togglesList[ShipViewConst.PAGE.REMOULD] = arg0_27.remouldToggle
	arg0_27.detailContainer = arg0_27.main:Find("detail_container")

	setAnchoredPosition(arg0_27.detailContainer, {
		x = 1300
	})

	arg0_27.fashionContainer = arg0_27.main:Find("fashion_container")

	setAnchoredPosition(arg0_27.fashionContainer, {
		x = 900
	})

	arg0_27.equipContainer = arg0_27.main:Find("equip_container")
	arg0_27.equipLCon = arg0_27.equipContainer:Find("equipment_l_container")
	arg0_27.equipRCon = arg0_27.equipContainer:Find("equipment_r_container")
	arg0_27.equipBCon = arg0_27.equipContainer:Find("equipment_b_container")

	setAnchoredPosition(arg0_27.equipRCon, {
		x = 750
	})
	setAnchoredPosition(arg0_27.equipLCon, {
		x = -700
	})
	setAnchoredPosition(arg0_27.equipBCon, {
		y = -540
	})

	arg0_27.shipDetailView = ShipDetailView.New(arg0_27.detailContainer, arg0_27.event, arg0_27.contextData)
	arg0_27.shipFashionView = ShipFashionView.New(arg0_27.fashionContainer, arg0_27.event, arg0_27.contextData)
	arg0_27.shipEquipView = ShipEquipView.New(arg0_27.equipContainer, arg0_27.event, arg0_27.contextData)
	arg0_27.shipHuntingRangeView = ShipHuntingRangeView.New(arg0_27._tf, arg0_27.event, arg0_27.contextData)
	arg0_27.shipCustomMsgBox = ShipCustomMsgBox.New(arg0_27._tf, arg0_27.event, arg0_27.contextData)
	arg0_27.shipChangeNameView = ShipChangeNameView.New(arg0_27._tf, arg0_27.event, arg0_27.contextData)
	arg0_27.expItemUsagePage = ShipExpItemUsagePage.New(arg0_27._tf, arg0_27.event, arg0_27.contextData)
	arg0_27.viewList = {}
	arg0_27.viewList[ShipViewConst.PAGE.DETAIL] = arg0_27.shipDetailView
	arg0_27.viewList[ShipViewConst.PAGE.FASHION] = arg0_27.shipFashionView
	arg0_27.viewList[ShipViewConst.PAGE.EQUIPMENT] = arg0_27.shipEquipView

	onButton(arg0_27, arg0_27.shipName, function()
		if arg0_27.shipVO.propose and not arg0_27.shipVO:IsXIdol() then
			if not pg.PushNotificationMgr.GetInstance():isEnableShipName() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_switch_tip"))

				return
			end

			local var0_28 = arg0_27.shipVO.renameTime + 2592000 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0_28 > 0 then
				local var1_28 = math.floor(var0_28 / 60 / 60 / 24)

				if var1_28 < 1 then
					var1_28 = 1
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_time_tip", var1_28))
			else
				arg0_27:DisplayRenamePanel(true)
			end
		end
	end, SFX_PANEL)
end

function var0_0.initEvents(arg0_29)
	arg0_29:bind(ShipViewConst.SWITCH_TO_PAGE, function(arg0_30, arg1_30)
		arg0_29:gotoPage(arg1_30)
	end)
	arg0_29:bind(ShipViewConst.LOAD_PAINTING, function(arg0_31, arg1_31, arg2_31)
		arg0_29:loadPainting(arg1_31, arg2_31)
	end)
	arg0_29:bind(ShipViewConst.LOAD_PAINTING_BG, function(arg0_32, arg1_32, arg2_32, arg3_32)
		arg0_29:loadSkinBg(arg1_32, arg2_32, arg3_32, arg0_29.isSpBg)
	end)
	arg0_29:bind(ShipViewConst.HIDE_SHIP_WORD, function(arg0_33)
		arg0_29:hideShipWord()
	end)
	arg0_29:bind(ShipViewConst.SET_CLICK_ENABLE, function(arg0_34, arg1_34)
		arg0_29.mainCanvasGroup.blocksRaycasts = arg1_34
		arg0_29.commonCanvasGroup.blocksRaycasts = arg1_34
		GetComponent(arg0_29.detailContainer, "CanvasGroup").blocksRaycasts = arg1_34
	end)
	arg0_29:bind(ShipViewConst.SHOW_CUSTOM_MSG, function(arg0_35, arg1_35)
		arg0_29.shipCustomMsgBox:Load()
		arg0_29.shipCustomMsgBox:ActionInvoke("showCustomMsgBox", arg1_35)
	end)
	arg0_29:bind(ShipViewConst.HIDE_CUSTOM_MSG, function(arg0_36)
		arg0_29.shipCustomMsgBox:ActionInvoke("hideCustomMsgBox")
	end)
	arg0_29:bind(ShipViewConst.DISPLAY_HUNTING_RANGE, function(arg0_37, arg1_37)
		if arg1_37 then
			arg0_29.shipHuntingRangeView:Load()
			arg0_29.shipHuntingRangeView:ActionInvoke("DisplayHuntingRange")
		else
			arg0_29.shipHuntingRangeView:HideHuntingRange()
		end
	end)
	arg0_29:bind(ShipViewConst.PAINT_VIEW, function(arg0_38, arg1_38)
		if arg1_38 then
			arg0_29:paintView()
		else
			arg0_29:hidePaintView(true)
		end
	end)
	arg0_29:bind(ShipViewConst.SHOW_EXP_ITEM_USAGE, function(arg0_39, arg1_39)
		arg0_29.expItemUsagePage:ExecuteAction("Show", arg1_39)
	end)
end

function var0_0.didEnter(arg0_40)
	arg0_40:addRingDragListenter()
	onButton(arg0_40, arg0_40:findTF("top/back_btn", arg0_40.common), function()
		GetOrAddComponent(arg0_40._tf, typeof(CanvasGroup)).interactable = false

		if not arg0_40.everTriggerBack then
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0_40:closeView()
			end))

			arg0_40.everTriggerBack = true
		end
	end, SFX_CANCEL)
	onButton(arg0_40, arg0_40.npcFlagTF, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_actnpc.tip
		})
	end, SFX_PANEL)

	arg0_40.helpBtn = arg0_40:findTF("help_btn", arg0_40.common)

	onButton(arg0_40, arg0_40.helpBtn, function()
		arg0_40:openHelpPage(ShipViewConst.currentPage)
	end, SFX_PANEL)

	for iter0_40, iter1_40 in pairs(arg0_40.togglesList) do
		if iter1_40 == arg0_40.upgradeToggle or iter1_40 == arg0_40.remouldToggle or iter1_40 == arg0_40.equipmentToggle then
			onToggle(arg0_40, iter1_40, function(arg0_45)
				if arg0_45 then
					if LeanTween.isTweening(go(arg0_40.chat)) then
						LeanTween.cancel(go(arg0_40.chat))
					end

					rtf(arg0_40.chat).localScale = Vector3.New(0, 0, 1)
					arg0_40.chatFlag = false

					arg0_40:switchToPage(iter0_40)
				end
			end, SFX_PANEL)
		else
			onToggle(arg0_40, iter1_40, function(arg0_46)
				if arg0_46 then
					arg0_40:switchToPage(iter0_40)
				end
			end, SFX_PANEL)
		end
	end

	onButton(arg0_40, arg0_40.technologyToggle, function()
		arg0_40:emit(ShipMainMediator.ON_TECHNOLOGY, arg0_40.shipVO)
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.metaToggle, function()
		arg0_40:emit(ShipMainMediator.ON_META, arg0_40.shipVO)
	end, SFX_PANEL)
	onButton(arg0_40, tf(arg0_40.character), function()
		if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
			arg0_40:displayShipWord("detail")
		end
	end)
	onButton(arg0_40, arg0_40.energyTF, function()
		arg0_40:showEnergyDesc()
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_40.blurPanel, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})

	local var0_40 = arg0_40:checkToggleActive(arg0_40.contextData.page) and arg0_40.contextData.page or ShipViewConst.PAGE.DETAIL

	arg0_40:gotoPage(var0_40)

	if ShipViewConst.currentPage == ShipViewConst.PAGE.DETAIL then
		arg0_40:displayShipWord(arg0_40:getInitmacyWords())
		arg0_40:checkMaxLevelHelp()
	end
end

function var0_0.openHelpPage(arg0_51, arg1_51)
	if arg1_51 == ShipViewConst.PAGE.EQUIPMENT then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_equip.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif arg1_51 == ShipViewConst.PAGE.DETAIL then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_detail.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif arg1_51 == ShipViewConst.PAGE.INTENSIFY then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_intensify.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif arg1_51 == ShipViewConst.PAGE.UPGRADE then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_upgrate.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif arg1_51 == ShipViewConst.PAGE.FASHION then
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

function var0_0.showAwakenCompleteAni(arg0_52, arg1_52)
	local function var0_52()
		arg0_52.awakenAni:SetActive(true)

		arg0_52.awakenPlay = true

		onButton(arg0_52, arg0_52.awakenAni, function()
			arg0_52.awakenAni:GetComponent("Animator"):SetBool("endFlag", true)
		end)

		local var0_53 = tf(arg0_52.awakenAni)

		pg.UIMgr.GetInstance():BlurPanel(var0_53, false, {
			weight = LayerWeightConst.TOP_LAYER
		})
		setText(arg0_52:findTF("window/desc", arg0_52.awakenAni), arg1_52)
		var0_53:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_55)
			arg0_52.awakenAni:GetComponent("Animator"):SetBool("endFlag", false)
			pg.UIMgr.GetInstance():UnblurPanel(var0_53, arg0_52.common)
			arg0_52.awakenAni:SetActive(false)

			arg0_52.awakenPlay = false
		end)
	end

	local var1_52 = arg0_52:findTF("AwakenCompleteWindows(Clone)")

	if var1_52 then
		arg0_52.awakenAni = go(var1_52)
	end

	if not arg0_52.awakenAni then
		PoolMgr.GetInstance():GetUI("AwakenCompleteWindows", true, function(arg0_56)
			arg0_56:SetActive(true)

			arg0_52.awakenAni = arg0_56

			var0_52()
		end)
	else
		var0_52()
	end
end

function var0_0.updatePreference(arg0_57, arg1_57)
	local var0_57 = arg1_57:getConfigTable()
	local var1_57 = arg0_57.shipVO:getName()

	setScrollText(arg0_57.shipName:Find("nameRect/name_mask/Text"), var1_57)
	setText(arg0_57:findTF("english_name", arg0_57.shipName), var0_57.english_name)
	setActive(arg0_57.nameEditFlag, arg1_57.propose and not arg1_57:IsXIdol())

	local var2_57 = GetSpriteFromAtlas("energy", arg1_57:getEnergyPrint())

	if not var2_57 then
		warning("找不到疲劳")
	end

	setImageSprite(arg0_57.energyTF, var2_57, true)
	setActive(arg0_57.energyTF, true)

	local var3_57 = arg0_57:findTF("stars", arg0_57.shipName)

	removeAllChildren(var3_57)

	local var4_57 = arg1_57:getStar()
	local var5_57 = arg1_57:getMaxStar()

	for iter0_57 = 1, var5_57 do
		local var6_57 = cloneTplTo(arg0_57.shipInfoStarTpl, var3_57, "star_" .. iter0_57)

		setActive(var6_57:Find("star_tpl"), iter0_57 <= var4_57)
		setActive(var6_57:Find("empty_star_tpl"), true)
	end

	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
		arg0_57:loadPainting(arg0_57.shipVO:getPainting())
		arg0_57:loadSkinBg(arg0_57.shipVO:rarity2bgPrintForGet(), arg0_57.shipVO:isBluePrintShip(), arg0_57.shipVO:isMetaShip(), arg0_57.isSpBg)
	end

	local var7_57 = GetSpriteFromAtlas("shiptype", arg1_57:getShipType())

	if not var7_57 then
		warning("找不到船形, shipConfigId: " .. arg1_57.configId)
	end

	setImageSprite(arg0_57:findTF("type", arg0_57.shipName), var7_57, true)
end

function var0_0.doUpgradeMaxLeveAnim(arg0_58, arg1_58, arg2_58, arg3_58)
	arg0_58.inUpgradeAnim = true

	arg0_58.shipDetailView:DoLeveUpAnim(arg1_58, arg2_58, function()
		if arg3_58 then
			arg3_58()
		end

		arg0_58.inUpgradeAnim = nil
	end)
end

function var0_0.addRingDragListenter(arg0_60)
	local var0_60 = GetOrAddComponent(arg0_60._tf, "EventTriggerListener")
	local var1_60
	local var2_60 = 0
	local var3_60

	var0_60:AddBeginDragFunc(function()
		var2_60 = 0
		var1_60 = nil
	end)
	var0_60:AddDragFunc(function(arg0_62, arg1_62)
		if not arg0_60.inPaintingView then
			local var0_62 = arg1_62.position

			if not var1_60 then
				var1_60 = var0_62
			end

			var2_60 = var0_62.x - var1_60.x
		end
	end)
	var0_60:AddDragEndFunc(function(arg0_63, arg1_63)
		if not arg0_60.inPaintingView then
			if var2_60 < -50 then
				if not arg0_60.isLoading then
					arg0_60:emit(ShipMainMediator.NEXTSHIP, -1)
				end
			elseif var2_60 > 50 and not arg0_60.isLoading then
				arg0_60:emit(ShipMainMediator.NEXTSHIP)
			end
		end
	end)
end

function var0_0.showEnergyDesc(arg0_64)
	if arg0_64.energyTimer then
		return
	end

	setActive(arg0_64.energyDescTF, true)

	local var0_64, var1_64 = arg0_64.shipVO:getEnergyPrint()

	setText(arg0_64.energyText, i18n(var1_64))

	arg0_64.energyTimer = Timer.New(function()
		setActive(arg0_64.energyDescTF, false)
		arg0_64.energyTimer:Stop()

		arg0_64.energyTimer = nil
	end, 2, 1)

	arg0_64.energyTimer:Start()
end

function var0_0.displayShipWord(arg0_66, arg1_66, arg2_66)
	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT or ShipViewConst.currentPage == ShipViewConst.PAGE.UPGRADE then
		rtf(arg0_66.chat).localScale = Vector3.New(0, 0, 1)

		return
	end

	if arg2_66 or not arg0_66.chatFlag then
		arg0_66.chatFlag = true
		arg0_66.chat.localScale = Vector3.zero

		setActive(arg0_66.chat, true)

		arg0_66.chat.localPosition = Vector3(arg0_66.character.localPosition.x + 100, arg0_66.chat.localPosition.y, 0)

		local var0_66 = arg0_66.shipVO:getCVIntimacy()

		arg0_66.chat:SetAsLastSibling()

		local var1_66 = arg0_66.chatText:GetComponent(typeof(Text))

		if findTF(arg0_66.nowPainting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0_66.nowPainting, "fitter"):GetChild(0), arg0_66.paintingCode, arg1_66, var0_66)
		end

		local var2_66, var3_66, var4_66 = ShipWordHelper.GetWordAndCV(arg0_66.shipVO.skinId, arg1_66, nil, nil, var0_66)
		local var5_66 = arg0_66.chatText:GetComponent(typeof(Text))

		if PLATFORM_CODE ~= PLATFORM_US then
			setText(arg0_66.chatText, SwitchSpecialChar(var4_66))
		else
			var5_66.fontSize = arg0_66.initfontSize

			setTextEN(arg0_66.chatText, var4_66)

			while var5_66.preferredHeight > arg0_66.initChatTextH do
				var5_66.fontSize = var5_66.fontSize - 2

				setTextEN(arg0_66.chatText, var4_66)

				if var5_66.fontSize < 20 then
					break
				end
			end
		end

		if #var5_66.text > CHAT_POP_STR_LEN then
			var5_66.alignment = TextAnchor.MiddleLeft
		else
			var5_66.alignment = TextAnchor.MiddleCenter
		end

		local var6_66 = var5_66.preferredHeight + 120

		if var6_66 > arg0_66.initChatBgH then
			arg0_66.chatBg.sizeDelta = Vector2.New(arg0_66.chatBg.sizeDelta.x, var6_66)
		else
			arg0_66.chatBg.sizeDelta = Vector2.New(arg0_66.chatBg.sizeDelta.x, arg0_66.initChatBgH)
		end

		local var7_66 = var4_0

		local function var8_66()
			if arg0_66.chatFlag then
				if arg0_66.chatani1Id then
					LeanTween.cancel(arg0_66.chatani1Id)
				end

				if arg0_66.chatani2Id then
					LeanTween.cancel(arg0_66.chatani2Id)
				end
			end

			arg0_66.chatani1Id = LeanTween.scale(rtf(arg0_66.chat.gameObject), Vector3.New(1, 1, 1), var3_0):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				arg0_66.chatani2Id = LeanTween.scale(rtf(arg0_66.chat.gameObject), Vector3.New(0, 0, 1), var3_0):setEase(LeanTweenType.easeInBack):setDelay(var3_0 + var7_66):setOnComplete(System.Action(function()
					arg0_66.chatFlag = nil
				end)).uniqueId
			end)).uniqueId
		end

		if var3_66 then
			arg0_66:StopPreVoice()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_66, function(arg0_70)
				if arg0_70 then
					var7_66 = arg0_70:GetLength() * 0.001
				end

				var8_66()
			end)

			arg0_66.preVoiceContent = var3_66
		else
			var8_66()
		end
	end
end

function var0_0.StopPreVoice(arg0_71)
	if arg0_71.preVoiceContent ~= nil then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_71.preVoiceContent)
	end
end

function var0_0.startChatTimer(arg0_72)
	if arg0_72.chatFlag then
		return
	end

	if arg0_72.chatTimer then
		arg0_72.chatTimer:Stop()

		arg0_72.chatTimer = nil
	end

	arg0_72.chatTimer = Timer.New(function()
		arg0_72:displayShipWord(arg0_72:getInitmacyWords())
	end, var6_0, 1)

	arg0_72.chatTimer:Start()
end

function var0_0.hideShipWord(arg0_74)
	if arg0_74.chatFlag then
		if arg0_74.chatani1Id then
			LeanTween.cancel(arg0_74.chatani1Id)
		end

		if arg0_74.chatani2Id then
			LeanTween.cancel(arg0_74.chatani2Id)
		end

		LeanTween.scale(rtf(arg0_74.chat.gameObject), Vector3.New(0, 0, 1), var3_0):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function()
			arg0_74.chatFlag = nil
		end))
	end

	arg0_74:StopPreVoice()
end

function var0_0.gotoPage(arg0_76, arg1_76)
	if arg1_76 == ShipViewConst.PAGE.FASHION then
		local function var0_76()
			arg0_76:switchToPage(arg1_76)
		end

		arg0_76:checkPaintingRes(var0_76)
	else
		triggerToggle(arg0_76.togglesList[arg1_76], true)
	end
end

function var0_0.switchToPage(arg0_78, arg1_78, arg2_78)
	local function var0_78(arg0_79, arg1_79)
		setActive(arg0_78.detailContainer, false)

		if arg0_79 == ShipViewConst.PAGE.DETAIL then
			setActive(arg0_78.detailContainer, arg1_79)

			local var0_79 = arg1_79 and {
				arg0_78.detailContainer.rect.width + 200,
				0
			} or {
				0,
				arg0_78.detailContainer.rect.width + 200
			}

			shiftPanel(arg0_78.detailContainer, var0_79[2], 0, var2_0, 0):setFrom(var0_79[1])
		elseif arg0_79 == ShipViewConst.PAGE.EQUIPMENT then
			local var1_79 = {
				-(arg0_78.equipLCon.rect.width + 190),
				190
			}
			local var2_79 = {
				arg0_78.equipRCon.rect.width,
				10
			}
			local var3_79 = {
				-arg0_78.equipBCon.rect.height,
				0
			}
			local var4_79 = arg1_79 and 1 or 2
			local var5_79 = arg1_79 and 2 or 1

			shiftPanel(arg0_78.equipLCon, var1_79[var5_79], 0, var2_0, 0):setFrom(var1_79[var4_79])
			shiftPanel(arg0_78.equipRCon, var2_79[var5_79], 0, var2_0, 0):setFrom(var2_79[var4_79])
			shiftPanel(arg0_78.equipBCon, 0, var3_79[var5_79], var2_0, 0):setFrom(var3_79[var4_79])
		elseif arg0_79 == ShipViewConst.PAGE.FASHION then
			local var6_79 = arg1_79 and {
				arg0_78.fashionContainer.rect.width + 150,
				0
			} or {
				0,
				arg0_78.fashionContainer.rect.width + 150
			}

			shiftPanel(arg0_78.fashionContainer, var6_79[2], 0, var2_0, 0):setFrom(var6_79[1])

			if arg1_79 then
				arg0_78.shipFashionView:ActionInvoke("UpdateFashion")
			end
		elseif arg0_79 == ShipViewConst.PAGE.INTENSIFY then
			if arg1_79 then
				arg0_78:emit(ShipMainMediator.OPEN_INTENSIFY)
			else
				arg0_78:emit(ShipMainMediator.CLOSE_INTENSIFY)
			end
		elseif arg0_79 == ShipViewConst.PAGE.UPGRADE then
			if arg1_79 then
				arg0_78:emit(ShipMainMediator.ON_UPGRADE)
			else
				arg0_78:emit(ShipMainMediator.CLOSE_UPGRADE)
			end
		elseif arg0_79 == ShipViewConst.PAGE.REMOULD then
			if arg1_79 then
				arg0_78:emit(ShipMainMediator.OPEN_REMOULD)
			else
				arg0_78:emit(ShipMainMediator.CLOSE_REMOULD)
			end
		end

		arg0_78:blurPage(arg0_79, arg1_79)

		if arg0_79 ~= ShipViewConst.PAGE.FASHION then
			arg0_78.fashionSkinId = arg0_78.shipVO.skinId

			arg0_78:loadPainting(arg0_78.shipVO:getPainting())
		end

		local var7_79 = not ShipViewConst.IsSubLayerPage(arg0_79)
		local var8_79 = arg0_78.bgEffect[arg0_78.shipVO:getRarity()]

		if var8_79 then
			setActive(var8_79, arg0_79 ~= ShipViewConst.PAGE.REMOULD and arg0_78.shipVO.bluePrintFlag and arg0_78.shipVO.bluePrintFlag == 0)
		end

		setActive(arg0_78.helpBtn, var7_79)
	end

	function switchHandler()
		if arg1_78 == ShipViewConst.currentPage and arg2_78 then
			var0_78(arg1_78, true)
		elseif arg1_78 ~= ShipViewConst.currentPage then
			if ShipViewConst.currentPage then
				var0_78(ShipViewConst.currentPage, false)
			end

			ShipViewConst.currentPage = arg1_78
			arg0_78.contextData.page = arg1_78

			var0_78(arg1_78, true)
			arg0_78:switchPainting()
		end
	end

	if arg0_78.viewList[arg1_78] ~= nil then
		local var1_78 = arg0_78.viewList[arg1_78]

		if not var1_78:GetLoaded() then
			var1_78:Load()
			var1_78:CallbackInvoke(switchHandler)
		else
			switchHandler()
		end
	else
		switchHandler()
	end
end

function var0_0.blurPage(arg0_81, arg1_81, arg2_81)
	local var0_81 = pg.UIMgr.GetInstance()

	if arg1_81 == ShipViewConst.PAGE.DETAIL then
		arg0_81.shipDetailView:ActionInvoke("OnSelected", arg2_81)
	elseif arg1_81 == ShipViewConst.PAGE.EQUIPMENT then
		arg0_81.shipEquipView:ActionInvoke("OnSelected", arg2_81)
	elseif arg1_81 == ShipViewConst.PAGE.FASHION then
		arg0_81.shipFashionView:ActionInvoke("OnSelected", arg2_81)
	elseif arg1_81 == ShipViewConst.PAGE.INTENSIFY then
		-- block empty
	elseif arg1_81 == ShipViewConst.PAGE.UPGRADE then
		-- block empty
	elseif arg1_81 == ShipViewConst.PAGE.REMOULD then
		-- block empty
	end
end

function var0_0.switchPainting(arg0_82)
	setActive(arg0_82.shipInfo, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
	setActive(arg0_82.shipName, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))

	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT then
		shiftPanel(arg0_82.shipInfo, -20, 0, var2_0, 0)

		arg0_82.paintingFrameName = "zhuangbei"
	else
		shiftPanel(arg0_82.shipInfo, -460, 0, var2_0, 0)

		arg0_82.paintingFrameName = "chuanwu"
	end

	local var0_82 = GetOrAddComponent(findTF(arg0_82.nowPainting, "fitter"), "PaintingScaler")

	var0_82:Snapshoot()

	var0_82.FrameName = arg0_82.paintingFrameName

	local var1_82 = LeanTween.value(go(arg0_82.nowPainting), 0, 1, var2_0):setOnUpdate(System.Action_float(function(arg0_83)
		var0_82.Tween = arg0_83
		arg0_82.chat.localPosition = Vector3(arg0_82.character.localPosition.x + 100, arg0_82.chat.localPosition.y, 0)
	end)):setEase(LeanTweenType.easeInOutSine)
end

function var0_0.setPreOrNext(arg0_84, arg1_84, arg2_84)
	if arg1_84 then
		arg0_84.isRight = true
	else
		arg0_84.isRight = false
	end

	if arg0_84.shipVO:getGroupId() ~= arg2_84:getGroupId() then
		arg0_84.switchCnt = (arg0_84.switchCnt or 0) + 1
	end

	if arg0_84.switchCnt and arg0_84.switchCnt >= 10 then
		gcAll()

		arg0_84.switchCnt = 0
	end
end

function var0_0.loadPainting(arg0_85, arg1_85, arg2_85)
	local var0_85 = arg1_85

	arg1_85 = MainMeshImagePainting.StaticGetPaintingName(var0_85)

	if arg0_85.isLoading == true then
		return
	end

	for iter0_85, iter1_85 in pairs(arg0_85.tablePainting) do
		iter1_85.localScale = Vector3(1, 1, 1)
	end

	if arg0_85.LoadShipVOId and not arg2_85 and arg0_85.LoadShipVOId == arg0_85.shipVO.id and arg0_85.LoadPaintingCode == arg1_85 then
		return
	end

	local var1_85 = 0
	local var2_85 = arg0_85.isRight and 1800 or -1800
	local var3_85 = arg0_85:getPaintingFromTable(false)

	arg0_85.isLoading = true

	local var4_85 = arg0_85.paintingCode
	local var5_85 = {}

	if var3_85 then
		table.insert(var5_85, function(arg0_86)
			local var0_86 = var3_85:GetComponent(typeof(RectTransform))
			local var1_86 = var3_85:GetComponent(typeof(CanvasGroup))

			LeanTween.cancel(go(var1_86))
			LeanTween.alphaCanvas(var1_86, 0, 0.3):setFrom(1):setUseEstimatedTime(true)
			LeanTween.moveX(var0_86, -var2_85, 0.3):setFrom(0):setOnComplete(System.Action(function()
				retPaintingPrefab(var3_85, var4_85)
				arg0_86()
			end))
		end)
	end

	local var6_85 = arg0_85:getPaintingFromTable(true)

	arg0_85.paintingCode = arg1_85

	if arg0_85.paintingCode and var6_85 then
		local var7_85 = var6_85:GetComponent(typeof(RectTransform))

		table.insert(var5_85, function(arg0_88)
			arg0_85.nowPainting = var6_85

			LoadPaintingPrefabAsync(var6_85, var0_85, arg0_85.paintingCode, arg0_85.paintingFrameName or "chuanwu", function()
				ShipExpressionHelper.SetExpression(findTF(var6_85, "fitter"):GetChild(0), arg0_85.paintingCode)
				arg0_88()
			end)
		end)
		table.insert(var5_85, function(arg0_90)
			LeanTween.cancel(go(var7_85))
			LeanTween.moveX(var7_85, 0, 0.3):setFrom(var2_85):setOnComplete(System.Action(arg0_90))

			local var0_90 = var6_85:GetComponent(typeof(CanvasGroup))

			LeanTween.alphaCanvas(var0_90, 1, 0.3):setFrom(0):setUseEstimatedTime(true)
		end)
	end

	parallelAsync(var5_85, function()
		arg0_85.LoadShipVOId = arg0_85.shipVO.id
		arg0_85.LoadPaintingCode = arg1_85
		arg0_85.isLoading = false
	end)
end

function var0_0.getPaintingFromTable(arg0_92, arg1_92)
	if arg0_92.tablePainting == nil then
		print("self.tablePainting为空")

		return
	end

	for iter0_92 = 1, #arg0_92.tablePainting do
		if findTF(arg0_92.tablePainting[iter0_92], "fitter").childCount == 0 then
			if arg1_92 == true and arg0_92.tablePainting[iter0_92] then
				return arg0_92.tablePainting[iter0_92]
			end
		elseif arg1_92 == false and arg0_92.tablePainting[iter0_92] then
			return arg0_92.tablePainting[iter0_92]
		end
	end
end

function var0_0.loadSkinBg(arg0_93, arg1_93, arg2_93, arg3_93, arg4_93)
	if not arg0_93.bgEffect then
		arg0_93.bgEffect = {}
	end

	if arg0_93.shipSkinBg ~= arg1_93 or arg0_93.isDesign ~= arg2_93 or arg0_93.isMeta ~= arg3_93 then
		arg0_93.shipSkinBg = arg1_93
		arg0_93.isDesign = arg2_93
		arg0_93.isMeta = arg3_93

		if arg0_93.isDesign then
			if arg0_93.bgEffect then
				for iter0_93, iter1_93 in pairs(arg0_93.bgEffect) do
					setActive(iter1_93, false)
				end
			end

			if arg0_93.bgEffect then
				for iter2_93, iter3_93 in pairs(arg0_93.bgEffect) do
					setActive(iter3_93, false)
				end
			end

			if arg0_93.designBg and arg0_93.designName ~= "raritydesign" .. arg0_93.shipVO:getRarity() then
				PoolMgr.GetInstance():ReturnUI(arg0_93.designName, arg0_93.designBg)

				arg0_93.designBg = nil
			end

			if not arg0_93.designBg then
				PoolMgr.GetInstance():GetUI("raritydesign" .. arg0_93.shipVO:getRarity(), true, function(arg0_94)
					arg0_93.designBg = arg0_94
					arg0_93.designName = "raritydesign" .. arg0_93.shipVO:getRarity()

					arg0_94.transform:SetParent(arg0_93._tf, false)

					arg0_94.transform.localPosition = Vector3(1, 1, 1)
					arg0_94.transform.localScale = Vector3(1, 1, 1)

					arg0_94.transform:SetSiblingIndex(1)
					setActive(arg0_94, true)
				end)
			else
				setActive(arg0_93.designBg, true)
			end
		elseif arg0_93.isMeta then
			if arg0_93.designBg then
				setActive(arg0_93.designBg, false)
			end

			if arg0_93.metaBg and arg0_93.metaName ~= "raritymeta" .. arg0_93.shipVO:getRarity() then
				PoolMgr.GetInstance():ReturnUI(arg0_93.metaName, arg0_93.metaBg)

				arg0_93.metaBg = nil
			end

			if not arg0_93.metaBg then
				PoolMgr.GetInstance():GetUI("raritymeta" .. arg0_93.shipVO:getRarity(), true, function(arg0_95)
					arg0_93.metaBg = arg0_95
					arg0_93.metaName = "raritymeta" .. arg0_93.shipVO:getRarity()

					arg0_95.transform:SetParent(arg0_93._tf, false)

					arg0_95.transform.localPosition = Vector3(1, 1, 1)
					arg0_95.transform.localScale = Vector3(1, 1, 1)

					arg0_95.transform:SetSiblingIndex(1)
					setActive(arg0_95, true)
				end)
			else
				setActive(arg0_93.metaBg, true)
			end
		else
			if arg0_93.designBg then
				setActive(arg0_93.designBg, false)
			end

			if arg0_93.metaBg then
				setActive(arg0_93.metaBg, false)
			end

			for iter4_93 = 1, 5 do
				local var0_93 = arg0_93.shipVO:getRarity()

				if arg0_93.bgEffect[iter4_93] then
					setActive(arg0_93.bgEffect[iter4_93], iter4_93 == var0_93 and ShipViewConst.currentPage ~= ShipViewConst.PAGE.REMOULD and not arg4_93)
				elseif var0_93 > 2 and var0_93 == iter4_93 and not arg4_93 then
					PoolMgr.GetInstance():GetUI("al_bg02_" .. var0_93 - 1, true, function(arg0_96)
						arg0_93.bgEffect[iter4_93] = arg0_96

						arg0_96.transform:SetParent(arg0_93._tf, false)

						arg0_96.transform.localPosition = Vector3(0, 0, 0)
						arg0_96.transform.localScale = Vector3(1, 1, 1)

						arg0_96.transform:SetSiblingIndex(1)
						setActive(arg0_96, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
					end)
				end
			end
		end

		GetSpriteFromAtlasAsync("bg/star_level_bg_" .. arg1_93, "", function(arg0_97)
			if not arg0_93.exited and arg0_93.shipSkinBg == arg1_93 then
				setImageSprite(arg0_93.background, arg0_97)
			end
		end)
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

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_108.chat, arg0_108.character)
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

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_108.blurPanel, arg0_108._tf)

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
