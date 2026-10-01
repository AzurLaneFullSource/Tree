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

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = getProxy(BayProxy):getShipById(arg1_3.shipId)
	local var1_3 = {
		"ui/ShipDetailView",
		"bg/star_level_bg_" .. var0_3:rarity2bgPrintForGet(),
		"ui/star_level_bg_" .. var0_3:rarity2bgPrintForGet()
	}
	local var2_3 = var0_3:getRarity()
	local var3_3 = pg.ship_skin_template[var0_3:getSkinId()]
	local var4_3 = var3_3.rarity_bg and var3_3.rarity_bg ~= ""

	if var2_3 > 2 and not var4_3 then
		table.insert(var1_3, "ui/al_bg02_" .. var2_3 - 1)
	end

	return table.insertto(var1_3, var0_0.super.getResource(arg0_3, arg1_3))
end

function var0_0.preload(arg0_4, arg1_4)
	local var0_4 = getProxy(BayProxy):getShipById(arg0_4.contextData.shipId)

	parallelAsync({
		function(arg0_5)
			GetSpriteFromAtlasAsync("bg/star_level_bg_" .. var0_4:rarity2bgPrintForGet(), "", arg0_5)
		end,
		function(arg0_6)
			if arg0_4.exited then
				return
			end

			PoolMgr.GetInstance():PreloadUI("ShipDetailView", arg0_6)
		end
	}, arg1_4)
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

	SplitPackConst.DownloadByLuaArr(ResPathSupport.GetShipAllRes(arg1_9), function()
		if arg0_9.exited or arg0_9.shipVO ~= arg1_9 then
			return
		end

		setActive(arg0_9.npcFlagTF, arg1_9:isActivityNpc())
		arg0_9:setToggleEnable()

		local var0_10 = pg.ship_skin_template[arg0_9.shipVO:getSkinId()]

		arg0_9.isSpBg = var0_10.rarity_bg and var0_10.rarity_bg ~= ""

		arg0_9:updatePreference(arg1_9)
		arg0_9.shipDetailView:ActionInvokeExclusive("UpdateUI")
		arg0_9.shipFashionView:ActionInvokeExclusive("UpdateUI")
		arg0_9.shipEquipView:ActionInvokeExclusive("UpdateUI")

		if var0_9 and not arg0_9:checkToggleActive(ShipViewConst.currentPage) then
			triggerToggle(arg0_9.detailToggle, true)
		end
	end)
end

function var0_0.equipmentChange(arg0_11)
	if arg0_11.shipDetailView then
		arg0_11.shipDetailView:ActionInvoke("UpdateUI")
	end
end

function var0_0.setToggleEnable(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.togglesList) do
		setActive(iter1_12, arg0_12:checkToggleActive(iter0_12))
	end

	setActive(arg0_12.technologyToggle, arg0_12.shipVO:isBluePrintShip())
	SetActive(arg0_12.metaToggle, arg0_12.shipVO:isMetaShip())
end

function var0_0.checkToggleActive(arg0_13, arg1_13)
	if arg1_13 == ShipViewConst.PAGE.DETAIL then
		return true
	elseif arg1_13 == ShipViewConst.PAGE.EQUIPMENT then
		return true
	elseif arg1_13 == ShipViewConst.PAGE.INTENSIFY then
		return not arg0_13.shipVO:isTestShip() and not arg0_13.shipVO:isBluePrintShip() and not arg0_13.shipVO:isMetaShip()
	elseif arg1_13 == ShipViewConst.PAGE.UPGRADE then
		return not arg0_13.shipVO:isTestShip() and not arg0_13.shipVO:isBluePrintShip() and not arg0_13.shipVO:isMetaShip()
	elseif arg1_13 == ShipViewConst.PAGE.REMOULD then
		return not arg0_13.shipVO:isTestShip() and not arg0_13.shipVO:isBluePrintShip() and pg.ship_data_trans[arg0_13.shipVO.groupId] and not arg0_13.shipVO:isMetaShip()
	elseif arg1_13 == ShipViewConst.PAGE.FASHION then
		if not arg0_13:hasFashion() then
			return false
		else
			local var0_13
			local var1_13

			if not PaintingGroupConst.IsPaintingNeedCheck() then
				var1_13 = false
			else
				local var2_13 = PaintingGroupConst.GetPaintingNameListByShipVO(arg0_13.shipVO)

				var1_13 = PaintingGroupConst.CalcPaintingListSize(var2_13) > 0
			end

			return not var1_13
		end
	else
		return false
	end
end

function var0_0.setSkinList(arg0_14, arg1_14)
	arg0_14.shipFashionView:ActionInvoke("SetSkinList", arg1_14)
end

function var0_0.updateLock(arg0_15)
	arg0_15.shipDetailView:ActionInvoke("UpdateLock")
end

function var0_0.updatePreferenceTag(arg0_16)
	arg0_16.shipDetailView:ActionInvoke("UpdatePreferenceTag")
end

function var0_0.updateFashionTag(arg0_17)
	arg0_17.shipDetailView:ActionInvoke("UpdateFashionTag")
end

function var0_0.closeRecordPanel(arg0_18)
	arg0_18.shipDetailView:ActionInvoke("CloseRecordPanel")
end

function var0_0.updateRecordEquipments(arg0_19, arg1_19)
	arg0_19.shipDetailView:UpdateRecordEquipments(arg1_19)
	arg0_19.shipDetailView:UpdateRecordSpWeapons(arg1_19)
end

function var0_0.setModPanel(arg0_20, arg1_20)
	arg0_20.modPanel = arg1_20
end

function var0_0.setMaxLevelHelpFlag(arg0_21, arg1_21)
	arg0_21.maxLevelHelpFlag = arg1_21
end

function var0_0.checkMaxLevelHelp(arg0_22)
	if not arg0_22.maxLevelHelpFlag and arg0_22.shipVO and arg0_22.shipVO:isReachNextMaxLevel() then
		arg0_22:openHelpPage()

		arg0_22.maxLevelHelpFlag = true

		getProxy(SettingsProxy):setMaxLevelHelp(true)
	end
end

function var0_0.GetShareData(arg0_23)
	if not arg0_23.shareData then
		arg0_23.shareData = ShipViewShareData.New(arg0_23.contextData)

		arg0_23.shipDetailView:SetShareData(arg0_23.shareData)
		arg0_23.shipFashionView:SetShareData(arg0_23.shareData)
		arg0_23.shipEquipView:SetShareData(arg0_23.shareData)
		arg0_23.shipEquipView:ActionInvoke("InitEvent")
		arg0_23.shipHuntingRangeView:SetShareData(arg0_23.shareData)
		arg0_23.shipCustomMsgBox:SetShareData(arg0_23.shareData)
		arg0_23.shipChangeNameView:SetShareData(arg0_23.shareData)
	end

	return arg0_23.shareData
end

function var0_0.hasFashion(arg0_24)
	return arg0_24.shareData:HasFashion()
end

function var0_0.DisplayRenamePanel(arg0_25, arg1_25)
	arg0_25.shipChangeNameView:Load()
	arg0_25.shipChangeNameView:ActionInvoke("DisplayRenamePanel", arg1_25)
end

function var0_0.init(arg0_26)
	arg0_26:initShip()
	arg0_26:initPages()
	arg0_26:initEvents()

	arg0_26.bgEffect = arg0_26.bgEffect or {}
	arg0_26.mainCanvasGroup = arg0_26._tf:GetComponent(typeof(CanvasGroup))
	arg0_26.commonCanvasGroup = arg0_26._tf:Find("blur_panel/adapt"):GetComponent(typeof(CanvasGroup))
	Input.multiTouchEnabled = false
end

function var0_0.initShip(arg0_27)
	arg0_27.shipInfo = arg0_27._tf:Find("main/character")

	setActive(arg0_27.shipInfo, true)

	arg0_27.tablePainting = {
		arg0_27.shipInfo:Find("painting"),
		arg0_27.shipInfo:Find("painting2")
	}
	arg0_27.nowPainting = nil
	arg0_27.isRight = true
	arg0_27.blurPanel = arg0_27._tf:Find("blur_panel")
	arg0_27.common = arg0_27.blurPanel:Find("adapt")
	arg0_27.npcFlagTF = arg0_27.common:Find("name/npc")
	arg0_27.shipName = arg0_27.common:Find("name")
	arg0_27.shipInfoStarTpl = arg0_27.shipName:Find("star_tpl")
	arg0_27.nameEditFlag = arg0_27.shipName:Find("nameRect/editFlag")

	setActive(arg0_27.shipName, true)
	setActive(arg0_27.shipInfoStarTpl, false)
	setActive(arg0_27.nameEditFlag, false)

	arg0_27.energyTF = arg0_27.shipName:Find("energy")
	arg0_27.energyDescTF = arg0_27.energyTF:Find("desc")
	arg0_27.energyText = arg0_27.energyTF:Find("desc/desc")

	setActive(arg0_27.energyDescTF, false)

	arg0_27.character = arg0_27._tf:Find("main/character")
	arg0_27.chat = arg0_27._tf:Find("main/character/chat")
	arg0_27.chatBg = arg0_27._tf:Find("main/character/chat/chatbgtop")
	arg0_27.chatText = arg0_27.chat:Find("Text")
	rtf(arg0_27.chat).localScale = Vector3.New(0, 0, 1)
	arg0_27.initChatBgH = arg0_27.chatBg.sizeDelta.y
	arg0_27.initChatTextH = arg0_27.chatText.sizeDelta.y
	arg0_27.initfontSize = arg0_27.chatText:GetComponent(typeof(Text)).fontSize
end

function var0_0.initPages(arg0_28)
	ShipViewConst.currentPage = nil
	arg0_28.background = arg0_28._tf:Find("background")

	setActive(arg0_28.background, true)

	arg0_28.main = arg0_28._tf:Find("main")
	arg0_28.mainMask = arg0_28.main:GetComponent(typeof(RectMask2D))
	arg0_28.toggles = arg0_28.common:Find("left_length/frame/root")
	arg0_28.detailToggle = arg0_28.toggles:Find("detail_toggle")
	arg0_28.equipmentToggle = arg0_28.toggles:Find("equpiment_toggle")
	arg0_28.intensifyToggle = arg0_28.toggles:Find("intensify_toggle")
	arg0_28.upgradeToggle = arg0_28.toggles:Find("upgrade_toggle")
	arg0_28.remouldToggle = arg0_28.toggles:Find("remould_toggle")
	arg0_28.technologyToggle = arg0_28.toggles:Find("technology_toggle")
	arg0_28.metaToggle = arg0_28.toggles:Find("meta_toggle")
	arg0_28.togglesList = {}
	arg0_28.togglesList[ShipViewConst.PAGE.DETAIL] = arg0_28.detailToggle
	arg0_28.togglesList[ShipViewConst.PAGE.EQUIPMENT] = arg0_28.equipmentToggle
	arg0_28.togglesList[ShipViewConst.PAGE.INTENSIFY] = arg0_28.intensifyToggle
	arg0_28.togglesList[ShipViewConst.PAGE.UPGRADE] = arg0_28.upgradeToggle
	arg0_28.togglesList[ShipViewConst.PAGE.REMOULD] = arg0_28.remouldToggle
	arg0_28.detailContainer = arg0_28.main:Find("detail_container")

	setAnchoredPosition(arg0_28.detailContainer, {
		x = 1300
	})

	arg0_28.fashionContainer = arg0_28.main:Find("fashion_container")

	setAnchoredPosition(arg0_28.fashionContainer, {
		x = 900
	})

	arg0_28.equipContainer = arg0_28.main:Find("equip_container")
	arg0_28.equipLCon = arg0_28.equipContainer:Find("equipment_l_container")
	arg0_28.equipRCon = arg0_28.equipContainer:Find("equipment_r_container")
	arg0_28.equipBCon = arg0_28.equipContainer:Find("equipment_b_container")

	setAnchoredPosition(arg0_28.equipRCon, {
		x = 750
	})
	setAnchoredPosition(arg0_28.equipLCon, {
		x = -700
	})
	setAnchoredPosition(arg0_28.equipBCon, {
		y = -540
	})

	arg0_28.shipDetailView = ShipDetailView.New(arg0_28.detailContainer, arg0_28.event, arg0_28.contextData)
	arg0_28.shipFashionView = ShipFashionView.New(arg0_28.fashionContainer, arg0_28.event, arg0_28.contextData)
	arg0_28.shipEquipView = ShipEquipView.New(arg0_28.equipContainer, arg0_28.event, arg0_28.contextData)
	arg0_28.shipHuntingRangeView = ShipHuntingRangeView.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.shipCustomMsgBox = ShipCustomMsgBox.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.shipChangeNameView = ShipChangeNameView.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.expItemUsagePage = ShipExpItemUsagePage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)

	for iter0_28, iter1_28 in ipairs({
		arg0_28.shipDetailView,
		arg0_28.shipFashionView,
		arg0_28.shipEquipView,
		arg0_28.shipHuntingRangeView,
		arg0_28.shipCustomMsgBox,
		arg0_28.shipChangeNameView,
		arg0_28.expItemUsagePage
	}) do
		iter1_28:RegisterView(arg0_28)
	end

	arg0_28.viewList = {}
	arg0_28.viewList[ShipViewConst.PAGE.DETAIL] = arg0_28.shipDetailView
	arg0_28.viewList[ShipViewConst.PAGE.FASHION] = arg0_28.shipFashionView
	arg0_28.viewList[ShipViewConst.PAGE.EQUIPMENT] = arg0_28.shipEquipView

	onButton(arg0_28, arg0_28.shipName, function()
		if arg0_28.shipVO.propose and not arg0_28.shipVO:IsXIdol() then
			if not pg.PushNotificationMgr.GetInstance():isEnableShipName() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_switch_tip"))

				return
			end

			local var0_29 = arg0_28.shipVO.renameTime + 2592000 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0_29 > 0 then
				local var1_29 = math.floor(var0_29 / 60 / 60 / 24)

				if var1_29 < 1 then
					var1_29 = 1
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_time_tip", var1_29))
			else
				arg0_28:DisplayRenamePanel(true)
			end
		end
	end, SFX_PANEL)
end

function var0_0.initEvents(arg0_30)
	arg0_30:bind(ShipViewConst.SWITCH_TO_PAGE, function(arg0_31, arg1_31)
		arg0_30:gotoPage(arg1_31)
	end)
	arg0_30:bind(ShipViewConst.LOAD_PAINTING, function(arg0_32, arg1_32, arg2_32)
		arg0_30:loadPainting(arg1_32, arg2_32)
	end)
	arg0_30:bind(ShipViewConst.LOAD_PAINTING_BG, function(arg0_33, arg1_33, arg2_33, arg3_33)
		arg0_30:loadSkinBg(arg1_33, arg2_33, arg3_33, arg0_30.isSpBg)
	end)
	arg0_30:bind(ShipViewConst.HIDE_SHIP_WORD, function(arg0_34)
		arg0_30:hideShipWord()
	end)
	arg0_30:bind(ShipViewConst.SET_CLICK_ENABLE, function(arg0_35, arg1_35)
		arg0_30.mainCanvasGroup.blocksRaycasts = arg1_35
		arg0_30.commonCanvasGroup.blocksRaycasts = arg1_35
		GetOrAddComponent(arg0_30.detailContainer, "CanvasGroup").blocksRaycasts = arg1_35
	end)
	arg0_30:bind(ShipViewConst.SHOW_CUSTOM_MSG, function(arg0_36, arg1_36)
		arg0_30.shipCustomMsgBox:Load()
		arg0_30.shipCustomMsgBox:ActionInvoke("showCustomMsgBox", arg1_36)
	end)
	arg0_30:bind(ShipViewConst.HIDE_CUSTOM_MSG, function(arg0_37)
		arg0_30.shipCustomMsgBox:ActionInvoke("hideCustomMsgBox")
	end)
	arg0_30:bind(ShipViewConst.DISPLAY_HUNTING_RANGE, function(arg0_38, arg1_38)
		if arg1_38 then
			arg0_30.shipHuntingRangeView:Load()
			arg0_30.shipHuntingRangeView:ActionInvoke("DisplayHuntingRange")
		else
			arg0_30.shipHuntingRangeView:HideHuntingRange()
		end
	end)
	arg0_30:bind(ShipViewConst.PAINT_VIEW, function(arg0_39, arg1_39)
		if arg1_39 then
			arg0_30:paintView()
		else
			arg0_30:hidePaintView(true)
		end
	end)
	arg0_30:bind(ShipViewConst.SHOW_EXP_ITEM_USAGE, function(arg0_40, arg1_40)
		arg0_30.expItemUsagePage:ExecuteAction("Show", arg1_40)
	end)
end

function var0_0.didEnter(arg0_41)
	arg0_41:addRingDragListenter()
	onButton(arg0_41, arg0_41.common:Find("top/back_btn"), function()
		GetOrAddComponent(arg0_41._tf, typeof(CanvasGroup)).interactable = false

		if not arg0_41.everTriggerBack then
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0_41:closeView()
			end))

			arg0_41.everTriggerBack = true
		end
	end, SFX_CANCEL)
	onButton(arg0_41, arg0_41.npcFlagTF, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_actnpc.tip
		})
	end, SFX_PANEL)

	arg0_41.helpBtn = arg0_41.common:Find("help_btn")

	onButton(arg0_41, arg0_41.helpBtn, function()
		arg0_41:openHelpPage(ShipViewConst.currentPage)
	end, SFX_PANEL)

	for iter0_41, iter1_41 in pairs(arg0_41.togglesList) do
		if iter1_41 == arg0_41.upgradeToggle or iter1_41 == arg0_41.remouldToggle or iter1_41 == arg0_41.equipmentToggle then
			onToggle(arg0_41, iter1_41, function(arg0_46)
				if arg0_46 then
					if LeanTween.isTweening(go(arg0_41.chat)) then
						LeanTween.cancel(go(arg0_41.chat))
					end

					rtf(arg0_41.chat).localScale = Vector3.New(0, 0, 1)
					arg0_41.chatFlag = false

					arg0_41:switchToPage(iter0_41)
				end
			end, SFX_PANEL)
		else
			onToggle(arg0_41, iter1_41, function(arg0_47)
				if arg0_47 then
					arg0_41:switchToPage(iter0_41)
				end
			end, SFX_PANEL)
		end
	end

	onButton(arg0_41, arg0_41.technologyToggle, function()
		arg0_41:emit(ShipMainMediator.ON_TECHNOLOGY, arg0_41.shipVO)
	end, SFX_PANEL)
	onButton(arg0_41, arg0_41.metaToggle, function()
		arg0_41:emit(ShipMainMediator.ON_META, arg0_41.shipVO)
	end, SFX_PANEL)
	onButton(arg0_41, tf(arg0_41.character), function()
		if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
			arg0_41:displayShipWord("detail")
		end
	end)
	onButton(arg0_41, arg0_41.energyTF, function()
		arg0_41:showEnergyDesc()
		getProxy(CommanderManualProxy):TaskProgressAdd(2022, 1)
	end)
	arg0_41:OverlayPanel(arg0_41.chat, {
		groupDelta = 1
	})
	arg0_41:OverlayPanel(arg0_41.blurPanel)

	local var0_41 = arg0_41:checkToggleActive(arg0_41.contextData.page) and arg0_41.contextData.page or ShipViewConst.PAGE.DETAIL

	arg0_41:gotoPage(var0_41)

	if ShipViewConst.currentPage == ShipViewConst.PAGE.DETAIL or var0_41 == ShipViewConst.PAGE.DETAIL then
		arg0_41:displayShipWord(arg0_41:getInitmacyWords())
		arg0_41:checkMaxLevelHelp()
	end

	arg0_41:changePaintingSortLayer(true)
end

function var0_0.openHelpPage(arg0_52, arg1_52)
	if arg1_52 == ShipViewConst.PAGE.EQUIPMENT then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_equip.tip
		})
	elseif arg1_52 == ShipViewConst.PAGE.DETAIL then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_detail.tip
		})
	elseif arg1_52 == ShipViewConst.PAGE.INTENSIFY then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_intensify.tip
		})
	elseif arg1_52 == ShipViewConst.PAGE.UPGRADE then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_upgrate.tip
		})
	elseif arg1_52 == ShipViewConst.PAGE.FASHION then
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

function var0_0.showAwakenCompleteAni(arg0_53, arg1_53)
	local function var0_53()
		arg0_53.awakenAni:SetActive(true)

		arg0_53.awakenPlay = true

		onButton(arg0_53, arg0_53.awakenAni, function()
			arg0_53.awakenAni:GetComponent("Animator"):SetBool("endFlag", true)
		end)

		local var0_54 = tf(arg0_53.awakenAni)

		pg.UIMgr.GetInstance():BlurPanel(var0_54)
		setText(var0_54:Find("window/desc"), arg1_53)
		var0_54:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_56)
			arg0_53.awakenAni:GetComponent("Animator"):SetBool("endFlag", false)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_54, arg0_53.common)
			arg0_53.awakenAni:SetActive(false)

			arg0_53.awakenPlay = false
		end)
	end

	local var1_53 = arg0_53._tf:Find("AwakenCompleteWindows(Clone)")

	if var1_53 then
		arg0_53.awakenAni = go(var1_53)
	end

	if not arg0_53.awakenAni then
		PoolMgr.GetInstance():GetUI("AwakenCompleteWindows", true, function(arg0_57)
			arg0_57:SetActive(true)

			arg0_53.awakenAni = arg0_57

			var0_53()
		end)
	else
		var0_53()
	end
end

function var0_0.updatePreference(arg0_58, arg1_58)
	local var0_58 = arg1_58:getConfigTable()
	local var1_58 = arg0_58.shipVO:getName()

	setScrollText(arg0_58.shipName:Find("nameRect/name_mask/Text"), var1_58)
	setText(arg0_58.shipName:Find("english_name"), var0_58.english_name)
	setActive(arg0_58.nameEditFlag, arg1_58.propose and not arg1_58:IsXIdol())

	local var2_58 = GetSpriteFromAtlas("energy", arg1_58:getEnergyPrint())

	if not var2_58 then
		warning("找不到疲劳")
	end

	setImageSprite(arg0_58.energyTF, var2_58, true)
	setActive(arg0_58.energyTF, true)

	local var3_58 = arg0_58.shipName:Find("stars")

	removeAllChildren(var3_58)

	local var4_58 = arg1_58:getStar()
	local var5_58 = arg1_58:getMaxStar()

	for iter0_58 = 1, var5_58 do
		local var6_58 = cloneTplTo(arg0_58.shipInfoStarTpl, var3_58, "star_" .. iter0_58)

		setActive(var6_58:Find("star_tpl"), iter0_58 <= var4_58)
		setActive(var6_58:Find("empty_star_tpl"), true)
	end

	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
		arg0_58:loadPainting(arg0_58.shipVO:getPainting())
		arg0_58:loadSkinBg(arg0_58.shipVO:rarity2bgPrintForGet(), arg0_58.shipVO:isBluePrintShip(), arg0_58.shipVO:isMetaShip(), arg0_58.isSpBg)
	end

	local var7_58 = GetSpriteFromAtlas("shiptype", arg1_58:getShipType())

	if not var7_58 then
		warning("找不到船形, shipConfigId: " .. arg1_58.configId)
	end

	setImageSprite(arg0_58.shipName:Find("type"), var7_58, true)
end

function var0_0.doUpgradeMaxLeveAnim(arg0_59, arg1_59, arg2_59, arg3_59)
	arg0_59.inUpgradeAnim = true

	arg0_59.shipDetailView:DoLeveUpAnim(arg1_59, arg2_59, function()
		if arg3_59 then
			arg3_59()
		end

		arg0_59.inUpgradeAnim = nil
	end)
end

function var0_0.addRingDragListenter(arg0_61)
	local var0_61 = GetOrAddComponent(arg0_61._tf, "EventTriggerListener")
	local var1_61
	local var2_61 = 0
	local var3_61

	var0_61:AddBeginDragFunc(function()
		var2_61 = 0
		var1_61 = nil
	end)
	var0_61:AddDragFunc(function(arg0_63, arg1_63)
		if not arg0_61.inPaintingView then
			local var0_63 = arg1_63.position

			if not var1_61 then
				var1_61 = var0_63
			end

			var2_61 = var0_63.x - var1_61.x
		end
	end)
	var0_61:AddDragEndFunc(function(arg0_64, arg1_64)
		if not arg0_61.inPaintingView then
			if var2_61 < -50 then
				if not arg0_61.isLoading then
					arg0_61:emit(ShipMainMediator.NEXTSHIP, -1)
				end
			elseif var2_61 > 50 and not arg0_61.isLoading then
				arg0_61:emit(ShipMainMediator.NEXTSHIP)
			end
		end
	end)
end

function var0_0.showEnergyDesc(arg0_65)
	if arg0_65.energyTimer then
		return
	end

	setActive(arg0_65.energyDescTF, true)

	local var0_65, var1_65 = arg0_65.shipVO:getEnergyPrint()

	setText(arg0_65.energyText, i18n(var1_65))

	arg0_65.energyTimer = Timer.New(function()
		setActive(arg0_65.energyDescTF, false)
		arg0_65.energyTimer:Stop()

		arg0_65.energyTimer = nil
	end, 2, 1)

	arg0_65.energyTimer:Start()
end

function var0_0.displayShipWord(arg0_67, arg1_67, arg2_67)
	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT or ShipViewConst.currentPage == ShipViewConst.PAGE.UPGRADE then
		rtf(arg0_67.chat).localScale = Vector3.New(0, 0, 1)

		return
	end

	if arg2_67 or not arg0_67.chatFlag then
		arg0_67.chatFlag = true
		arg0_67.chat.localScale = Vector3.zero

		setActive(arg0_67.chat, true)

		arg0_67.chat.localPosition = Vector3(arg0_67.character.localPosition.x + 100, arg0_67.chat.localPosition.y, 0)

		local var0_67 = arg0_67.shipVO:getCVIntimacy()

		if findTF(arg0_67.nowPainting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0_67.nowPainting, "fitter"):GetChild(0), arg0_67.paintingCode, arg1_67, var0_67)
		end

		local var1_67, var2_67, var3_67 = ShipWordHelper.GetWordAndCV(arg0_67.shipVO:getSkinId(), arg1_67, nil, nil, var0_67)
		local var4_67 = arg0_67.chatText:GetComponent(typeof(Text))

		if PLATFORM_CODE ~= PLATFORM_US then
			setText(arg0_67.chatText, SwitchSpecialChar(var3_67))
		else
			var4_67.fontSize = arg0_67.initfontSize

			setTextEN(arg0_67.chatText, var3_67)

			while var4_67.preferredHeight > arg0_67.initChatTextH do
				var4_67.fontSize = var4_67.fontSize - 2

				setTextEN(arg0_67.chatText, var3_67)

				if var4_67.fontSize < 20 then
					break
				end
			end
		end

		if #var4_67.text > CHAT_POP_STR_LEN then
			var4_67.alignment = TextAnchor.MiddleLeft
		else
			var4_67.alignment = TextAnchor.MiddleCenter
		end

		local var5_67 = var4_67.preferredHeight + 120

		if var5_67 > arg0_67.initChatBgH then
			arg0_67.chatBg.sizeDelta = Vector2.New(arg0_67.chatBg.sizeDelta.x, var5_67)
		else
			arg0_67.chatBg.sizeDelta = Vector2.New(arg0_67.chatBg.sizeDelta.x, arg0_67.initChatBgH)
		end

		local var6_67 = var4_0

		local function var7_67()
			if arg0_67.chatFlag then
				if arg0_67.chatani1Id then
					LeanTween.cancel(arg0_67.chatani1Id)
				end

				if arg0_67.chatani2Id then
					LeanTween.cancel(arg0_67.chatani2Id)
				end
			end

			arg0_67.chatani1Id = LeanTween.scale(rtf(arg0_67.chat.gameObject), Vector3.New(1, 1, 1), var3_0):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				arg0_67.chatani2Id = LeanTween.scale(rtf(arg0_67.chat.gameObject), Vector3.New(0, 0, 1), var3_0):setEase(LeanTweenType.easeInBack):setDelay(var3_0 + var6_67):setOnComplete(System.Action(function()
					arg0_67.chatFlag = nil
				end)).uniqueId
			end)).uniqueId
		end

		if var2_67 then
			arg0_67:StopPreVoice()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_67, function(arg0_71)
				if arg0_71 then
					var6_67 = arg0_71:GetLength() * 0.001
				end

				var7_67()
			end)

			arg0_67.preVoiceContent = var2_67
		else
			var7_67()
		end
	end
end

function var0_0.StopPreVoice(arg0_72)
	if arg0_72.preVoiceContent ~= nil then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_72.preVoiceContent)
	end
end

function var0_0.startChatTimer(arg0_73)
	if arg0_73.chatFlag then
		return
	end

	if arg0_73.chatTimer then
		arg0_73.chatTimer:Stop()

		arg0_73.chatTimer = nil
	end

	arg0_73.chatTimer = Timer.New(function()
		arg0_73:displayShipWord(arg0_73:getInitmacyWords())
	end, var6_0, 1)

	arg0_73.chatTimer:Start()
end

function var0_0.hideShipWord(arg0_75)
	if arg0_75.chatFlag then
		if arg0_75.chatani1Id then
			LeanTween.cancel(arg0_75.chatani1Id)
		end

		if arg0_75.chatani2Id then
			LeanTween.cancel(arg0_75.chatani2Id)
		end

		LeanTween.scale(rtf(arg0_75.chat.gameObject), Vector3.New(0, 0, 1), var3_0):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function()
			arg0_75.chatFlag = nil
		end))
	end

	arg0_75:StopPreVoice()
end

function var0_0.gotoPage(arg0_77, arg1_77)
	if arg1_77 == ShipViewConst.PAGE.FASHION then
		local function var0_77()
			arg0_77:switchToPage(arg1_77)
		end

		arg0_77:checkPaintingRes(var0_77)
	else
		triggerToggle(arg0_77.togglesList[arg1_77], true)
	end
end

function var0_0.switchToPage(arg0_79, arg1_79, arg2_79)
	local function var0_79(arg0_80, arg1_80)
		setActive(arg0_79.detailContainer, false)

		if arg0_80 == ShipViewConst.PAGE.DETAIL then
			setActive(arg0_79.detailContainer, arg1_80)

			local var0_80 = arg1_80 and {
				arg0_79.detailContainer.rect.width + 200,
				0
			} or {
				0,
				arg0_79.detailContainer.rect.width + 200
			}

			shiftPanel(arg0_79.detailContainer, var0_80[2], 0, var2_0, 0):setFrom(var0_80[1])
		elseif arg0_80 == ShipViewConst.PAGE.EQUIPMENT then
			local var1_80 = {
				-(arg0_79.equipLCon.rect.width + 190),
				190
			}
			local var2_80 = {
				arg0_79.equipRCon.rect.width,
				10
			}
			local var3_80 = {
				-arg0_79.equipBCon.rect.height,
				0
			}
			local var4_80 = arg1_80 and 1 or 2
			local var5_80 = arg1_80 and 2 or 1

			shiftPanel(arg0_79.equipLCon, var1_80[var5_80], 0, var2_0, 0):setFrom(var1_80[var4_80])
			shiftPanel(arg0_79.equipRCon, var2_80[var5_80], 0, var2_0, 0):setFrom(var2_80[var4_80])
			shiftPanel(arg0_79.equipBCon, 0, var3_80[var5_80], var2_0, 0):setFrom(var3_80[var4_80])
		elseif arg0_80 == ShipViewConst.PAGE.FASHION then
			local var6_80 = arg1_80 and {
				arg0_79.fashionContainer.rect.width + 150,
				0
			} or {
				0,
				arg0_79.fashionContainer.rect.width + 150
			}

			shiftPanel(arg0_79.fashionContainer, var6_80[2], 0, var2_0, 0):setFrom(var6_80[1])

			if arg1_80 then
				arg0_79.shipFashionView:ActionInvoke("UpdateFashion")
			end
		elseif arg0_80 == ShipViewConst.PAGE.INTENSIFY then
			if arg1_80 then
				arg0_79:emit(ShipMainMediator.OPEN_INTENSIFY)
			else
				arg0_79:emit(ShipMainMediator.CLOSE_INTENSIFY)
			end
		elseif arg0_80 == ShipViewConst.PAGE.UPGRADE then
			if arg1_80 then
				arg0_79:emit(ShipMainMediator.ON_UPGRADE)
			else
				arg0_79:emit(ShipMainMediator.CLOSE_UPGRADE)
			end
		elseif arg0_80 == ShipViewConst.PAGE.REMOULD then
			if arg1_80 then
				arg0_79:emit(ShipMainMediator.OPEN_REMOULD)
			else
				arg0_79:emit(ShipMainMediator.CLOSE_REMOULD)
			end
		end

		arg0_79:blurPage(arg0_80, arg1_80)

		if arg0_80 ~= ShipViewConst.PAGE.FASHION then
			arg0_79.fashionSkinId = arg0_79.shipVO:getSkinId()

			arg0_79:loadPainting(arg0_79.shipVO:getPainting())
		end

		local var7_80 = not ShipViewConst.IsSubLayerPage(arg0_80)
		local var8_80 = arg0_79.bgEffect and arg0_79.bgEffect[arg0_79.shipVO:getRarity()]

		if var8_80 then
			setActive(var8_80, arg0_80 ~= ShipViewConst.PAGE.REMOULD and arg0_79.shipVO.bluePrintFlag and arg0_79.shipVO.bluePrintFlag == 0)
			arg0_79:changePaintingSortLayer(true)
		end

		setActive(arg0_79.helpBtn, var7_80)
	end

	function switchHandler()
		if arg1_79 == ShipViewConst.currentPage and arg2_79 then
			var0_79(arg1_79, true)
		elseif arg1_79 ~= ShipViewConst.currentPage then
			if ShipViewConst.currentPage then
				var0_79(ShipViewConst.currentPage, false)
			end

			ShipViewConst.currentPage = arg1_79
			arg0_79.contextData.page = arg1_79

			var0_79(arg1_79, true)
			arg0_79:switchPainting()
		end
	end

	if arg0_79.viewList[arg1_79] ~= nil then
		local var1_79 = arg0_79.viewList[arg1_79]

		if not var1_79:GetLoaded() then
			var1_79:Load()
			var1_79:CallbackInvoke(switchHandler)
		else
			switchHandler()
		end
	else
		switchHandler()
	end
end

function var0_0.blurPage(arg0_82, arg1_82, arg2_82)
	if arg1_82 == ShipViewConst.PAGE.DETAIL then
		arg0_82.shipDetailView:ActionInvoke("OnSelected", arg2_82)
	elseif arg1_82 == ShipViewConst.PAGE.EQUIPMENT then
		arg0_82.shipEquipView:ActionInvoke("OnSelected", arg2_82)
	elseif arg1_82 == ShipViewConst.PAGE.FASHION then
		arg0_82.shipFashionView:ActionInvoke("OnSelected", arg2_82)
	elseif arg1_82 == ShipViewConst.PAGE.INTENSIFY then
		-- block empty
	elseif arg1_82 == ShipViewConst.PAGE.UPGRADE then
		-- block empty
	elseif arg1_82 == ShipViewConst.PAGE.REMOULD then
		-- block empty
	end
end

function var0_0.switchPainting(arg0_83)
	setActive(arg0_83.shipInfo, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
	setActive(arg0_83.shipName, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))

	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT then
		shiftPanel(arg0_83.shipInfo, -20, 0, var2_0, 0)

		arg0_83.paintingFrameName = "zhuangbei"
	else
		shiftPanel(arg0_83.shipInfo, -460, 0, var2_0, 0)

		arg0_83.paintingFrameName = "chuanwu"
	end

	local var0_83 = GetOrAddComponent(findTF(arg0_83.nowPainting, "fitter"), "PaintingScaler")

	var0_83:Snapshoot()

	var0_83.FrameName = arg0_83.paintingFrameName

	local var1_83 = LeanTween.value(go(arg0_83.nowPainting), 0, 1, var2_0):setOnUpdate(System.Action_float(function(arg0_84)
		var0_83.Tween = arg0_84
		arg0_83.chat.localPosition = Vector3(arg0_83.character.localPosition.x + 100, arg0_83.chat.localPosition.y, 0)
	end)):setEase(LeanTweenType.easeInOutSine)
end

function var0_0.setPreOrNext(arg0_85, arg1_85, arg2_85)
	if arg1_85 then
		arg0_85.isRight = true
	else
		arg0_85.isRight = false
	end

	if arg0_85.shipVO:getGroupId() ~= arg2_85:getGroupId() then
		arg0_85.switchCnt = (arg0_85.switchCnt or 0) + 1
	end

	if arg0_85.switchCnt and arg0_85.switchCnt >= 10 then
		gcAll()

		arg0_85.switchCnt = 0
	end
end

function var0_0.loadPainting(arg0_86, arg1_86, arg2_86)
	local var0_86 = arg1_86

	arg1_86 = MainMeshImagePainting.StaticGetPaintingName(var0_86)

	if arg0_86.isLoading == true then
		return
	end

	for iter0_86, iter1_86 in pairs(arg0_86.tablePainting) do
		iter1_86.localScale = Vector3(1, 1, 1)
	end

	if arg0_86.LoadShipVOId and not arg2_86 and arg0_86.LoadShipVOId == arg0_86.shipVO.id and arg0_86.LoadPaintingCode == arg1_86 and not arg2_86 then
		return
	end

	local var1_86 = 0
	local var2_86 = arg0_86.isRight and 1800 or -1800
	local var3_86 = arg0_86:getPaintingFromTable(false)

	arg0_86.isLoading = true

	local var4_86 = arg0_86.paintingCode
	local var5_86 = {}

	if var3_86 then
		table.insert(var5_86, function(arg0_87)
			local var0_87 = var3_86:GetComponent(typeof(RectTransform))
			local var1_87 = var3_86:GetComponent(typeof(CanvasGroup))

			LeanTween.cancel(go(var1_87))
			LeanTween.alphaCanvas(var1_87, 0, 0.3):setFrom(1):setUseEstimatedTime(true)
			LeanTween.moveX(var0_87, -var2_86, 0.3):setFrom(0):setOnComplete(System.Action(function()
				retPaintingPrefab(var3_86, var4_86)
				arg0_87()
			end))
		end)
	end

	local var6_86 = arg0_86:getPaintingFromTable(true)

	arg0_86.paintingCode = arg1_86

	if arg0_86.paintingCode and var6_86 then
		local var7_86 = var6_86:GetComponent(typeof(RectTransform))

		table.insert(var5_86, function(arg0_89)
			arg0_86.nowPainting = var6_86

			LoadPaintingPrefabAsync(var6_86, var0_86, arg0_86.paintingCode, arg0_86.paintingFrameName or "chuanwu", function()
				local var0_90 = arg0_86.shipVO:getCVIntimacy()
				local var1_90 = arg0_86:getInitmacyWords()

				ShipExpressionHelper.SetExpression(findTF(var6_86, "fitter"):GetChild(0), arg0_86.paintingCode, var1_90, var0_90)
				arg0_89()
			end)
		end)
		table.insert(var5_86, function(arg0_91)
			LeanTween.cancel(go(var7_86))
			LeanTween.moveX(var7_86, 0, 0.3):setFrom(var2_86):setOnComplete(System.Action(arg0_91))

			local var0_91 = var6_86:GetComponent(typeof(CanvasGroup))

			LeanTween.alphaCanvas(var0_91, 1, 0.3):setFrom(0):setUseEstimatedTime(true)
		end)
	end

	parallelAsync(var5_86, function()
		arg0_86.LoadShipVOId = arg0_86.shipVO.id
		arg0_86.LoadPaintingCode = arg1_86
		arg0_86.isLoading = false
	end)
end

function var0_0.getPaintingFromTable(arg0_93, arg1_93)
	if arg0_93.tablePainting == nil then
		print("self.tablePainting为空")

		return
	end

	for iter0_93 = 1, #arg0_93.tablePainting do
		if findTF(arg0_93.tablePainting[iter0_93], "fitter").childCount == 0 then
			if arg1_93 == true and arg0_93.tablePainting[iter0_93] then
				return arg0_93.tablePainting[iter0_93]
			end
		elseif arg1_93 == false and arg0_93.tablePainting[iter0_93] then
			return arg0_93.tablePainting[iter0_93]
		end
	end
end

function var0_0.loadSkinBg(arg0_94, arg1_94, arg2_94, arg3_94, arg4_94)
	if not arg0_94.bgEffect then
		arg0_94.bgEffect = {}
	end

	if arg0_94.shipSkinBg ~= arg1_94 or arg0_94.isDesign ~= arg2_94 or arg0_94.isMeta ~= arg3_94 then
		arg0_94.shipSkinBg = arg1_94
		arg0_94.isDesign = arg2_94
		arg0_94.isMeta = arg3_94

		if arg0_94.isDesign then
			if arg0_94.metaBg then
				setActive(arg0_94.metaBg, false)
			end

			if arg0_94.bgEffect then
				for iter0_94, iter1_94 in pairs(arg0_94.bgEffect) do
					setActive(iter1_94, false)
				end
			end

			if arg0_94.designBg and arg0_94.designName ~= "raritydesign" .. arg0_94.shipVO:getRarity() then
				PoolMgr.GetInstance():ReturnUI(arg0_94.designName, arg0_94.designBg)

				arg0_94.designBg = nil
			end

			if not arg0_94.designBg then
				PoolMgr.GetInstance():GetUI("raritydesign" .. arg0_94.shipVO:getRarity(), true, function(arg0_95)
					arg0_94.designBg = arg0_95
					arg0_94.designName = "raritydesign" .. arg0_94.shipVO:getRarity()

					arg0_95.transform:SetParent(arg0_94._tf, false)

					arg0_95.transform.localPosition = Vector3(1, 1, 1)
					arg0_95.transform.localScale = Vector3(1, 1, 1)

					arg0_95.transform:SetSiblingIndex(1)
					setActive(arg0_95, true)
				end)
			else
				setActive(arg0_94.designBg, true)
			end
		elseif arg0_94.isMeta then
			if arg0_94.designBg then
				setActive(arg0_94.designBg, false)
			end

			if arg0_94.metaBg and arg0_94.metaName ~= "raritymeta" .. arg0_94.shipVO:getRarity() then
				PoolMgr.GetInstance():ReturnUI(arg0_94.metaName, arg0_94.metaBg)

				arg0_94.metaBg = nil
			end

			if not arg0_94.metaBg then
				PoolMgr.GetInstance():GetUI("raritymeta" .. arg0_94.shipVO:getRarity(), true, function(arg0_96)
					arg0_94.metaBg = arg0_96
					arg0_94.metaName = "raritymeta" .. arg0_94.shipVO:getRarity()

					arg0_96.transform:SetParent(arg0_94._tf, false)

					arg0_96.transform.localPosition = Vector3(1, 1, 1)
					arg0_96.transform.localScale = Vector3(1, 1, 1)

					arg0_96.transform:SetSiblingIndex(1)
					setActive(arg0_96, true)
				end)
			else
				setActive(arg0_94.metaBg, true)
			end
		else
			if arg0_94.designBg then
				setActive(arg0_94.designBg, false)
			end

			if arg0_94.metaBg then
				setActive(arg0_94.metaBg, false)
			end

			for iter2_94 = 1, 5 do
				local var0_94 = arg0_94.shipVO:getRarity()

				if arg0_94.bgEffect[iter2_94] then
					setActive(arg0_94.bgEffect[iter2_94], iter2_94 == var0_94 and ShipViewConst.currentPage ~= ShipViewConst.PAGE.REMOULD and not arg4_94)
				elseif var0_94 > 2 and var0_94 == iter2_94 and not arg4_94 then
					PoolMgr.GetInstance():GetUI("al_bg02_" .. var0_94 - 1, true, function(arg0_97)
						arg0_94.bgEffect[iter2_94] = arg0_97

						arg0_97.transform:SetParent(arg0_94._tf, false)

						arg0_97.transform.localPosition = Vector3(0, 0, 0)
						arg0_97.transform.localScale = Vector3(1, 1, 1)

						arg0_97.transform:SetSiblingIndex(1)
						setActive(arg0_97, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
					end)
				end

				arg0_94:changePaintingSortLayer(true)
			end
		end

		GetSpriteFromAtlasAsync("bg/star_level_bg_" .. arg1_94, "", function(arg0_98)
			if not arg0_94.exited and arg0_94.shipSkinBg == arg1_94 then
				setImageSprite(arg0_94.background, arg0_98)
			end
		end)
	end
end

function var0_0.changePaintingSortLayer(arg0_99, arg1_99)
	local var0_99
	local var1_99 = arg1_99 and 12 or -1

	for iter0_99, iter1_99 in ipairs(arg0_99.tablePainting) do
		GetComponent(iter1_99, typeof(Canvas)).sortingOrder = var1_99
	end

	if arg1_99 then
		local var2_99 = arg0_99.shipVO:getRarity()

		if arg0_99.isDesign and arg0_99.designBg then
			setActive(arg0_99.designBg, true)
		elseif arg0_99.bgEffect and var2_99 and arg0_99.bgEffect[var2_99] then
			setActive(arg0_99.bgEffect[var2_99], true)
		end
	else
		if arg0_99.designBg then
			setActive(arg0_99.designBg, false)
		end

		if arg0_99.bgEffect then
			for iter2_99, iter3_99 in pairs(arg0_99.bgEffect) do
				setActive(iter3_99, false)
			end
		end
	end
end

function var0_0.getInitmacyWords(arg0_100)
	local var0_100 = arg0_100.shipVO:getIntimacyLevel()
	local var1_100 = Mathf.Clamp(var0_100, 1, 5)

	return "feeling" .. var1_100
end

function var0_0.paintView(arg0_101)
	if LeanTween.isTweening(arg0_101.chat.gameObject) then
		LeanTween.cancel(arg0_101.chat.gameObject)

		arg0_101.chat.localScale = Vector3(0, 0, 0)
		arg0_101.chatFlag = nil
	end

	arg0_101.character:GetComponent("Image").enabled = false
	arg0_101.inPaintingView = true

	local var0_101 = {}
	local var1_101 = arg0_101._tf.childCount
	local var2_101 = 0

	while var2_101 < var1_101 do
		local var3_101 = arg0_101._tf:GetChild(var2_101)

		if var3_101.gameObject.activeSelf and var3_101 ~= arg0_101.main and var3_101 ~= arg0_101.background then
			var0_101[#var0_101 + 1] = var3_101

			setActive(var3_101, false)
		end

		var2_101 = var2_101 + 1
	end

	local var4_101 = arg0_101.main.childCount
	local var5_101 = 0

	while var5_101 < var4_101 do
		local var6_101 = arg0_101.main:GetChild(var5_101)

		if var6_101.gameObject.activeSelf and var6_101 ~= arg0_101.shipInfo then
			var0_101[#var0_101 + 1] = var6_101

			setActive(var6_101, false)
		end

		var5_101 = var5_101 + 1
	end

	arg0_101.shipDetailView:Hide()
	setActive(arg0_101.blurPanel, false)
	setActive(pg.playerResUI._go, false)

	var0_101[#var0_101 + 1] = arg0_101.chat

	openPortrait()
	setActive(arg0_101.common, false)

	arg0_101.mainMask.enabled = false

	arg0_101.mainMask:PerformClipping()

	local var7_101 = arg0_101.nowPainting
	local var8_101 = var7_101.anchoredPosition.x
	local var9_101 = var7_101.anchoredPosition.y
	local var10_101 = var7_101.rect.width
	local var11_101 = var7_101.rect.height
	local var12_101 = arg0_101._tf.rect.width / UnityEngine.Screen.width
	local var13_101 = arg0_101._tf.rect.height / UnityEngine.Screen.height
	local var14_101 = var10_101 / 2
	local var15_101 = var11_101 / 2
	local var16_101
	local var17_101
	local var18_101 = GetOrAddComponent(arg0_101.background, "PinchZoom")
	local var19_101 = GetOrAddComponent(arg0_101.background, "EventTriggerListener")
	local var20_101 = true
	local var21_101 = false

	var19_101:AddPointDownFunc(function(arg0_102)
		if Input.touchCount == 1 or IsUnityEditor then
			var21_101 = true
			var20_101 = true
		elseif Input.touchCount >= 2 then
			var20_101 = false
			var21_101 = false
		end
	end)
	var19_101:AddPointUpFunc(function(arg0_103)
		if Input.touchCount <= 2 then
			var20_101 = true
		end
	end)
	var19_101:AddBeginDragFunc(function(arg0_104, arg1_104)
		var21_101 = false
		var16_101 = arg1_104.position.x * var12_101 - var14_101 - tf(arg0_101.nowPainting).localPosition.x
		var17_101 = arg1_104.position.y * var13_101 - var15_101 - tf(arg0_101.nowPainting).localPosition.y
	end)
	var19_101:AddDragFunc(function(arg0_105, arg1_105)
		if var18_101.processing then
			return
		end

		if var20_101 then
			local var0_105 = tf(arg0_101.nowPainting).localPosition

			tf(arg0_101.nowPainting).localPosition = Vector3(arg1_105.position.x * var12_101 - var14_101 - var16_101, arg1_105.position.y * var13_101 - var15_101 - var17_101, -22)
		end
	end)
	onButton(arg0_101, arg0_101.background, function()
		arg0_101:hidePaintView()
	end, SFX_CANCEL)

	function var0_0.hidePaintView(arg0_107, arg1_107)
		if not arg1_107 and not var21_101 then
			return
		end

		arg0_107.character:GetComponent("Image").enabled = true
		Input.multiTouchEnabled = false

		setActive(arg0_107.common, true)
		SwitchPanel(arg0_107.shipInfo, -460, nil, var2_0 * 2)

		var19_101.enabled = false
		var18_101.enabled = false
		arg0_107.character.localScale = Vector3.one

		arg0_107.shipDetailView:Show()
		setActive(arg0_107.blurPanel, true)
		setActive(pg.playerResUI._go, true)

		for iter0_107, iter1_107 in ipairs(var0_101) do
			setActive(iter1_107, true)
		end

		closePortrait()

		arg0_107.nowPainting.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0_107.nowPainting, {
			x = var8_101,
			y = var9_101
		})

		arg0_107.background:GetComponent("Button").enabled = false
		arg0_107.nowPainting:GetComponent("CanvasGroup").blocksRaycasts = true
		arg0_107.mainMask.enabled = true

		arg0_107.mainMask:PerformClipping()

		arg0_107.inPaintingView = false
	end

	SwitchPanel(arg0_101.shipInfo, var1_0, nil, var2_0 * 2):setOnComplete(System.Action(function()
		var18_101.enabled = true
		var19_101.enabled = true
		arg0_101.background:GetComponent("Button").enabled = true
		arg0_101.nowPainting:GetComponent("CanvasGroup").blocksRaycasts = false
	end))
end

function var0_0.onBackPressed(arg0_109)
	if arg0_109.inUpgradeAnim then
		return
	end

	if arg0_109.awakenPlay then
		return
	end

	if arg0_109.shipChangeNameView.isOpenRenamePanel then
		arg0_109.shipChangeNameView:ActionInvoke("DisplayRenamePanel", false)

		return
	end

	if arg0_109.shipCustomMsgBox.isShowCustomMsgBox then
		arg0_109.shipCustomMsgBox:ActionInvoke("hideCustomMsgBox")

		return
	end

	if arg0_109.shipHuntingRangeView.onSelected then
		arg0_109.shipHuntingRangeView:ActionInvoke("HideHuntingRange")

		return
	end

	if arg0_109.inPaintingView then
		arg0_109:hidePaintView(true)

		return
	end

	if arg0_109.expItemUsagePage and arg0_109.expItemUsagePage:GetLoaded() and arg0_109.expItemUsagePage:isShowing() then
		arg0_109.expItemUsagePage:Hide()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_109.common:Find("top/back_btn"))
end

function var0_0.willExit(arg0_110)
	Input.multiTouchEnabled = true

	arg0_110:UnOverlayPanel(arg0_110.chat, arg0_110.character)
	arg0_110:blurPage(ShipViewConst.currentPage)
	setActive(arg0_110.background, false)

	if arg0_110.designBg then
		PoolMgr.GetInstance():ReturnUI(arg0_110.designName, arg0_110.designBg)
	end

	if arg0_110.metaBg then
		PoolMgr.GetInstance():ReturnUI(arg0_110.metaName, arg0_110.metaBg)
	end

	arg0_110.intensifyToggle:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
	arg0_110.upgradeToggle:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
	LeanTween.cancel(arg0_110.chat.gameObject)

	if arg0_110.paintingCode then
		for iter0_110 = 1, #arg0_110.tablePainting do
			local var0_110 = go(arg0_110.tablePainting[iter0_110])

			if LeanTween.isTweening(var0_110) then
				LeanTween.cancel(go(var0_110))
			end
		end

		retPaintingPrefab(arg0_110.nowPainting, arg0_110.paintingCode)
	end

	arg0_110.shipDetailView:Destroy()
	arg0_110.shipFashionView:Destroy()
	arg0_110.shipEquipView:Destroy()
	arg0_110.shipHuntingRangeView:Destroy()
	arg0_110.shipCustomMsgBox:Destroy()
	arg0_110.shipChangeNameView:Destroy()
	clearImageSprite(arg0_110.background)

	if arg0_110.energyTimer then
		arg0_110.energyTimer:Stop()

		arg0_110.energyTimer = nil
	end

	if arg0_110.chatTimer then
		arg0_110.chatTimer:Stop()

		arg0_110.chatTimer = nil
	end

	arg0_110:StopPreVoice()
	cameraPaintViewAdjust(false)

	if arg0_110.tweens then
		cancelTweens(arg0_110.tweens)
	end

	arg0_110:UnOverlayPanel(arg0_110.blurPanel, arg0_110._tf)

	arg0_110.shareData = nil
end

function var0_0.RefreshShipExpItemUsagePage(arg0_111)
	if arg0_111.expItemUsagePage and arg0_111.expItemUsagePage:GetLoaded() and arg0_111.expItemUsagePage:isShowing() then
		arg0_111.expItemUsagePage:Flush(arg0_111.shipVO)
	end
end

function var0_0.OnWillLogout(arg0_112)
	if arg0_112.inPaintingView then
		arg0_112:hidePaintView(true)
	end
end

function var0_0.checkPaintingRes(arg0_113, arg1_113)
	local var0_113 = PaintingGroupConst.GetPaintingNameListByShipVO(arg0_113.shipVO)
	local var1_113 = {
		isShowBox = true,
		paintingNameList = var0_113,
		finishFunc = arg1_113
	}

	PaintingGroupConst.PaintingDownload(var1_113)
end

return var0_0
