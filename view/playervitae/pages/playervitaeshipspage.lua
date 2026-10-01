local var0_0 = class("PlayerVitaeShipsPage", import("...base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 1
local var5_0 = 2

var0_0.RANDOM_FLAG_SHIP_PAGE = var5_0
var0_0.EDUCATE_CHAR_SLOT_ID = 6
var0_0.ON_BEGIN_DRAG_CARD = "PlayerVitaeShipsPage:ON_BEGIN_DRAG_CARD"
var0_0.ON_DRAGING_CARD = "PlayerVitaeShipsPage:ON_DRAGING_CARD"
var0_0.ON_DRAG_END_CARD = "PlayerVitaeShipsPage:ON_DRAG_END_CARD"

function var0_0.GetSlotIndexList()
	local var0_1, var1_1 = var0_0.GetSlotMaxCnt()
	local var2_1 = {}

	for iter0_1 = 1, var1_1 do
		table.insert(var2_1, iter0_1)
	end

	if NewEducateHelper.GetEducateCharSlotMaxCnt() > 0 then
		table.insert(var2_1, var0_0.EDUCATE_CHAR_SLOT_ID)
	end

	return var2_1
end

function var0_0.GetAllUnlockSlotCnt()
	local var0_2, var1_2 = var0_0.GetSlotMaxCnt()

	return var1_2 + NewEducateHelper.GetEducateCharSlotMaxCnt()
end

function var0_0.GetSlotMaxCnt()
	local var0_3 = pg.gameset.secretary_group_unlock.description
	local var1_3 = var0_3[#var0_3][2]
	local var2_3 = 1

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if getProxy(ChapterProxy):isClear(iter1_3[1]) then
			var2_3 = iter1_3[2]
		end
	end

	return var1_3, var2_3
end

function var0_0.getUIName(arg0_4)
	return "PlayerVitaeShipsPage"
end

function var0_0.getResource(arg0_5, arg1_5)
	local var0_5 = {
		"ui/proposeShipCard"
	}
	local var1_5 = var0_0.super.getResource(arg0_5)
	local var2_5 = arg1_5 and arg1_5.showTrans

	local function var3_5(arg0_6)
		local var0_6 = getProxy(BayProxy):GetShipPhantom(arg0_6)
		local var1_6 = getProxy(ShipSkinProxy):GetAllSkinForShip(var0_6)
		local var2_6 = getProxy(ShipSkinProxy):GetShareSkinsForShip(var0_6)
		local var3_6 = _.map(var2_6, function(arg0_7)
			return pg.ship_skin_template[arg0_7.id]
		end)

		table.insertto(var1_6, var3_6)

		for iter0_6, iter1_6 in ipairs(var1_6) do
			local var4_6 = iter1_6 and iter1_6.painting or "unknown"

			if var4_6 ~= "unknown" then
				local var5_6 = ResPathSupport.GetPaintingListByPaintingName(var4_6)

				table.insertto(var1_5, var5_6)
			end
		end
	end

	local function var4_5(arg0_8)
		if not arg0_8 then
			return
		end

		local var0_8 = arg0_8:rarity2bgPrint(var2_5)

		table.insert(var1_5, string.format(ResPathSupport.ConstPath.BG.ShipCard, var0_8))

		local var1_8, var2_8 = arg0_8:GetFrameAndEffect(true)

		if noEmptyStr(var2_8) then
			table.insert(var1_5, ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, var2_8))
		end
	end

	local function var5_5(arg0_9)
		local var0_9 = getProxy(BayProxy):GetShipPhantom(arg0_9)

		var4_5(var0_9)
	end

	for iter0_5, iter1_5 in ipairs(getProxy(PlayerProxy):getRawData():GetShipPhantomMarks()) do
		var5_5(iter1_5)
		var3_5(iter1_5)
	end

	for iter2_5, iter3_5 in ipairs(getProxy(SettingsProxy):GetRandomFlagShipList()) do
		var5_5(iter3_5)
		var3_5(iter3_5)
	end

	local var6_5 = getProxy(PlayerProxy):getRawData()

	if var6_5:ExistEducateChar() then
		local var7_5 = VirtualEducateCharShip.New(var6_5:GetEducateCharacter())

		table.insert(var1_5, "painting/" .. var7_5:getPainting())
	end

	return ResPathSupport.UniqueLuaArr(ResPathSupport.MergeLuaArr(var1_5, var0_5))
end

function var0_0.UpdateCard(arg0_10, arg1_10)
	local var0_10 = arg0_10.cards[var1_0]

	for iter0_10, iter1_10 in ipairs(var0_10) do
		if isActive(iter1_10._tf) and iter1_10.displayShip and iter1_10.displayShip:GetShipPhantomMark() == arg1_10 then
			iter1_10:Refresh()

			break
		end
	end
end

function var0_0.UpdateCardPaintingTag(arg0_11)
	local var0_11 = arg0_11.cards[var1_0]

	for iter0_11, iter1_11 in ipairs(var0_11) do
		iter1_11:updatePaintingTag()
	end
end

function var0_0.RefreshShips(arg0_12)
	arg0_12:Update()
end

function var0_0.OnLoaded(arg0_13)
	arg0_13.cardContainer = arg0_13._tf:Find("frame")
	arg0_13.shipTpl = arg0_13._tf:Find("frame/shipCard")
	arg0_13.emptyTpl = arg0_13._tf:Find("frame/addCard")
	arg0_13.lockTpl = arg0_13._tf:Find("frame/lockCard")
	arg0_13.helpBtn = arg0_13._tf:Find("help_btn")
	arg0_13.settingBtn = arg0_13._tf:Find("setting_btn")
	arg0_13.settingBtnSlider = arg0_13.settingBtn:Find("toggle/on")
	arg0_13.randomBtn = arg0_13._tf:Find("ran_setting_btn")
	arg0_13.randomBtnSlider = arg0_13.randomBtn:Find("toggle/on")
	arg0_13.settingSeceneBtn = arg0_13._tf:Find("setting_scene_btn")
	arg0_13.nativeBtn = arg0_13._tf:Find("native_setting_btn")
	arg0_13.nativeBtnOn = arg0_13.nativeBtn:Find("on")
	arg0_13.nativeBtnOff = arg0_13.nativeBtn:Find("off")
	arg0_13.getMailBtn = arg0_13._tf:Find("get_mail")
	arg0_13.educateCharTr = arg0_13._tf:Find("educate_char")
	arg0_13.educateCharSettingList = UIItemList.New(arg0_13._tf:Find("educate_char/shipCard/settings/panel"), arg0_13._tf:Find("educate_char/shipCard/settings/panel/tpl"))
	arg0_13.educateCharSettingBtn = arg0_13._tf:Find("educate_char/shipCard/settings/tpl")
	arg0_13.educateCharTrTip = arg0_13.educateCharTr:Find("tip")

	if LOCK_EDUCATE_SYSTEM then
		setActive(arg0_13.educateCharTr, false)
		setAnchoredPosition(arg0_13.cardContainer, {
			x = 0
		})
		setAnchoredPosition(arg0_13._tf:Find("flagship"), {
			x = -720
		})
		setAnchoredPosition(arg0_13._tf:Find("zs"), {
			x = 763
		})
		setAnchoredPosition(arg0_13._tf:Find("line"), {
			x = 740
		})
	end

	arg0_13.educateCharCards = {
		[var1_0] = PlayerVitaeEducateShipCard.New(arg0_13._tf:Find("educate_char/shipCard"), arg0_13.event),
		[var2_0] = PlayerVitaeEducateAddCard.New(arg0_13._tf:Find("educate_char/addCard"), arg0_13.event),
		[var3_0] = PlayerVitaeEducateLockCard.New(arg0_13._tf:Find("educate_char/lockCard"), arg0_13.event)
	}
	arg0_13.tip = arg0_13._tf:Find("tip"):GetComponent(typeof(Text))
	arg0_13.flagShipMark = arg0_13._tf:Find("flagship")

	arg0_13:bind(var0_0.ON_BEGIN_DRAG_CARD, function(arg0_14, arg1_14)
		arg0_13:OnBeginDragCard(arg1_14)
	end)
	arg0_13:bind(var0_0.ON_DRAGING_CARD, function(arg0_15, arg1_15)
		arg0_13:OnDragingCard(arg1_15)
	end)
	arg0_13:bind(var0_0.ON_DRAG_END_CARD, function(arg0_16)
		arg0_13:OnEndDragCard()
	end)
	setText(arg0_13.nativeBtnOn:Find("Text"), i18n("random_ship_before"))
	setText(arg0_13.nativeBtnOff:Find("Text"), i18n("random_ship_now"))
	setText(arg0_13.settingBtn:Find("Text"), i18n("player_vitae_skin_setting"))
	setText(arg0_13.randomBtn:Find("Text"), i18n("random_ship_label"))
	setText(arg0_13.settingSeceneBtn:Find("Text"), i18n("playervtae_setting_btn_label"))
	setText(arg0_13.getMailBtn:Find("Text"), i18n("spring_present_tips_btn"))
	setText(arg0_13.getMailBtn:Find("time"), i18n("spring_present_tips_time"))

	arg0_13.cardContainerCG = GetOrAddComponent(arg0_13.cardContainer, typeof(CanvasGroup))
end

function var0_0.OnBeginDragCard(arg0_17, arg1_17)
	arg0_17.dragIndex = arg1_17
	arg0_17.displayCards = {}
	arg0_17.displayPos = {}

	local var0_17 = arg0_17.cards[var1_0]

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if isActive(iter1_17._tf) then
			arg0_17.displayCards[iter0_17] = iter1_17
			arg0_17.displayPos[iter0_17] = iter1_17._tf.localPosition
		end
	end

	for iter2_17, iter3_17 in pairs(arg0_17.displayCards) do
		if iter2_17 ~= arg1_17 then
			iter3_17:DisableDrag()
		end
	end
end

function var0_0.OnDragingCard(arg0_18, arg1_18)
	local var0_18 = arg0_18.displayCards[arg0_18.dragIndex - 1]
	local var1_18 = arg0_18.displayCards[arg0_18.dragIndex + 1]

	if var0_18 and arg0_18:ShouldSwap(arg1_18, arg0_18.dragIndex - 1) then
		arg0_18:Swap(arg0_18.dragIndex, arg0_18.dragIndex - 1)
	elseif var1_18 and arg0_18:ShouldSwap(arg1_18, arg0_18.dragIndex + 1) then
		arg0_18:Swap(arg0_18.dragIndex, arg0_18.dragIndex + 1)
	end
end

function var0_0.Swap(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.displayCards[arg1_19]
	local var1_19 = arg0_19.displayPos[arg1_19]
	local var2_19 = arg0_19.displayCards[arg2_19]

	var2_19._tf.localPosition = var1_19
	arg0_19.displayCards[arg1_19], arg0_19.displayCards[arg2_19] = arg0_19.displayCards[arg2_19], arg0_19.displayCards[arg1_19]
	arg0_19.dragIndex = arg2_19
	var0_19.slotIndex = arg2_19
	var2_19.slotIndex = arg1_19
	var0_19.typeIndex, var2_19.typeIndex = var2_19.typeIndex, var0_19.typeIndex

	local var3_19 = arg0_19.cards[var1_0]

	var3_19[arg1_19], var3_19[arg2_19] = var3_19[arg2_19], var3_19[arg1_19]
end

function var0_0.ShouldSwap(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.displayPos[arg2_20]

	return math.abs(var0_20.x - arg1_20.x) <= 130
end

function var0_0.OnEndDragCard(arg0_21)
	local var0_21 = arg0_21.displayPos[arg0_21.dragIndex]

	arg0_21.displayCards[arg0_21.dragIndex]._tf.localPosition = var0_21

	local var1_21 = {}
	local var2_21 = getProxy(PlayerProxy):getRawData():GetShipPhantomMarks()
	local var3_21 = false

	for iter0_21, iter1_21 in pairs(arg0_21.displayCards) do
		iter1_21:EnableDrag()
		table.insert(var1_21, iter1_21.displayShip:GetShipPhantomMark())

		if not var3_21 and var2_21[#var1_21] ~= var1_21[#var1_21] then
			var3_21 = true
		end
	end

	arg0_21.dragIndex = nil
	arg0_21.displayCards = nil
	arg0_21.displayPos = nil
	arg0_21.cardContainerCG.blocksRaycasts = false

	if var3_21 then
		arg0_21:emit(PlayerVitaeMediator.CHANGE_PAINTS, var1_21, function()
			Timer.New(function()
				if arg0_21.cardContainerCG then
					arg0_21.cardContainerCG.blocksRaycasts = true
				end
			end, 0.3, 1):Start()
		end)
	else
		arg0_21.cardContainerCG.blocksRaycasts = true
	end
end

function var0_0.OnInit(arg0_24)
	onButton(arg0_24, arg0_24.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("secretary_help")
		})
	end, SFX_PANEL)

	local var0_24 = false

	local function var1_24()
		local var0_26 = {
			68,
			-68
		}

		setAnchoredPosition(arg0_24.settingBtnSlider, {
			x = var0_26[var0_24 and 1 or 2]
		})
	end

	onButton(arg0_24, arg0_24.settingBtn, function()
		var0_24 = not var0_24

		arg0_24:EditCards(var0_24)
		var1_24()
	end, SFX_PANEL)
	var1_24()

	local var2_24 = getProxy(SettingsProxy)

	arg0_24.randomFlag = var2_24:IsOpenRandomFlagShip()
	arg0_24.nativeFlag = false

	local function var3_24()
		local var0_28 = {
			68,
			-68
		}

		setAnchoredPosition(arg0_24.randomBtnSlider, {
			x = var0_28[arg0_24.randomFlag and 1 or 2]
		})
		setActive(arg0_24.nativeBtn, arg0_24.randomFlag)
		setActive(arg0_24.flagShipMark, not arg0_24.randomFlag or arg0_24.nativeFlag)

		if arg0_24.randomFlag and var0_24 then
			triggerButton(arg0_24.settingBtn)
		end
	end

	local function var4_24()
		setActive(arg0_24.nativeBtnOn, arg0_24.nativeFlag)
		setActive(arg0_24.nativeBtnOff, not arg0_24.nativeFlag)
		setActive(arg0_24.flagShipMark, not arg0_24.randomFlag or arg0_24.nativeFlag)

		if var0_24 then
			triggerButton(arg0_24.settingBtn)
		end
	end

	onButton(arg0_24, arg0_24.randomBtn, function()
		arg0_24.randomFlag = not arg0_24.randomFlag

		if arg0_24.randomFlag then
			local var0_30 = MainRandomFlagShipSequence.New():Random()

			if not var0_30 or #var0_30 <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_off_0"))

				arg0_24.randomFlag = not arg0_24.randomFlag

				return
			end

			var2_24:UpdateRandomFlagShipList(var0_30)
		else
			var2_24:UpdateRandomFlagShipList({})

			arg0_24.nativeFlag = false

			var4_24()
		end

		arg0_24:SwitchToPage(arg0_24.randomFlag and var5_0 or var4_0)
		var3_24()

		local var1_30 = arg0_24.randomFlag and i18n("random_ship_on") or i18n("random_ship_off")

		pg.TipsMgr.GetInstance():ShowTips(var1_30)
		arg0_24:emit(PlayerVitaeMediator.ON_SWITCH_RANDOM_FLAG_SHIP_BTN, arg0_24.randomFlag)
	end, SFX_PANEL)
	var3_24()
	onButton(arg0_24, arg0_24.nativeBtn, function()
		arg0_24.nativeFlag = not arg0_24.nativeFlag

		var4_24()
		arg0_24:SwitchToPage(arg0_24.nativeFlag and var4_0 or var5_0)
	end, SFX_PANEL)
	var4_24()
	onButton(arg0_24, arg0_24.getMailBtn, function()
		if arg0_24.randomFlag then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spring_present_tips0"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("spring_present_tips1"),
			onYes = function()
				local var0_33 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_MAIL)

				if not var0_33 then
					setActive(arg0_24.getMailBtn, false)
					pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

					return
				end

				arg0_24:emit(PlayerVitaeMediator.ON_GET_LOVE_LETTER_MAIL, var0_33.id)
			end
		})
	end)
	arg0_24:UpdateGetMailBtn()
	onButton(arg0_24, arg0_24.educateCharSettingBtn, function()
		local var0_34 = isActive(arg0_24.educateCharSettingList.container)

		setActive(arg0_24.educateCharSettingList.container, not var0_34)
	end, SFX_PANEL)
	onButton(arg0_24, arg0_24.settingSeceneBtn, function()
		arg0_24.contextData.showSelectCharacters = true

		arg0_24:emit(PlayerVitaeMediator.GO_SCENE, SCENE.SETTINGS, {
			page = NewSettingsScene.PAGE_OPTION,
			scroll = SettingsRandomFlagShipAndSkinPanel
		})
	end, SFX_PANEL)

	arg0_24.cards = {
		{},
		{},
		{}
	}

	table.insert(arg0_24.cards[var1_0], PlayerVitaeShipCard.New(arg0_24.shipTpl, arg0_24.event))
	table.insert(arg0_24.cards[var2_0], PlayerVitaeAddCard.New(arg0_24.emptyTpl, arg0_24.event))
	table.insert(arg0_24.cards[var3_0], PlayerVitaeLockCard.New(arg0_24.lockTpl, arg0_24.event))
end

function var0_0.UpdateGetMailBtn(arg0_36)
	local var0_36 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_MAIL)

	setActive(arg0_36.getMailBtn, var0_36 and not var0_36:isEnd() and var0_36:readyToAchieve())
end

function var0_0.Update(arg0_37)
	local var0_37 = getProxy(SettingsProxy)
	local var1_37

	if arg0_37.randomFlag and arg0_37.nativeFlag then
		var1_37 = var4_0
	else
		var1_37 = var0_37:IsOpenRandomFlagShip() and var5_0 or var4_0
	end

	arg0_37:SwitchToPage(var1_37)
	arg0_37:UpdateEducateChar()
	arg0_37:UpdateGetMailBtn()
	arg0_37:Show()
end

function var0_0.UpdateEducateChar(arg0_38)
	arg0_38:UpdateEducateCharSettings()
	arg0_38:UpdateEducateSlot()
	arg0_38:UpdateEducateCharTrTip()
end

function var0_0.UpdateEducateCharTrTip(arg0_39)
	setActive(arg0_39.educateCharTrTip, getProxy(SettingsProxy):ShouldEducateCharTip())
end

local function var6_0()
	if NewEducateHelper.GetEducateCharSlotMaxCnt() <= 0 then
		return var3_0
	end

	if getProxy(PlayerProxy):getRawData():ExistEducateChar() then
		return var1_0
	end

	return var2_0
end

function var0_0.UpdateEducateSlot(arg0_41)
	local var0_41 = var6_0()
	local var1_41

	for iter0_41, iter1_41 in pairs(arg0_41.educateCharCards) do
		local var2_41 = iter0_41 == var0_41

		iter1_41:ShowOrHide(var2_41)

		if var2_41 then
			var1_41 = iter1_41
		end
	end

	var1_41:Flush()
end

function var0_0.UpdateEducateCharSettings(arg0_42)
	local var0_42 = getProxy(SettingsProxy)

	local function var1_42()
		local var0_43 = var0_42:GetFlagShipDisplayMode()

		setText(arg0_42.educateCharSettingBtn:Find("Text"), i18n("flagship_display_mode_" .. var0_43))
	end

	local var2_42 = {
		FlAG_SHIP_DISPLAY_ONLY_SHIP,
		FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR,
		FlAG_SHIP_DISPLAY_ALL
	}

	arg0_42.educateCharSettingList:make(function(arg0_44, arg1_44, arg2_44)
		if arg0_44 == UIItemList.EventUpdate then
			local var0_44 = var2_42[arg1_44 + 1]

			setText(arg2_44:Find("Text"), i18n("flagship_display_mode_" .. var0_44))
			onButton(arg0_42, arg2_44, function()
				var0_42:SetFlagShipDisplayMode(var0_44)
				var1_42()
				setActive(arg0_42.educateCharSettingList.container, false)
			end, SFX_PANEL)
			setActive(arg2_44:Find("line"), arg1_44 + 1 ~= #var2_42)
		end
	end)
	arg0_42.educateCharSettingList:align(#var2_42)
	var1_42()
end

function var0_0.SwitchToPage(arg0_46, arg1_46)
	local var0_46

	if arg1_46 == var5_0 then
		var0_46 = _.select(getProxy(SettingsProxy):GetRandomFlagShipList(), function(arg0_47)
			return getProxy(BayProxy):GetShipPhantom(arg0_47) ~= nil
		end)
		arg0_46.tip.text = i18n("random_ship_tips1")

		arg0_46:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_RANDOM_SHIPS)
	elseif arg1_46 == var4_0 then
		var0_46 = getProxy(PlayerProxy):getRawData():GetShipPhantomMarks()
		arg0_46.tip.text = i18n("random_ship_tips2")

		arg0_46:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_NATIVE_SHIPS)
	end

	arg0_46:Flush(var0_46, arg1_46)
	setActive(arg0_46.tip.gameObject, arg0_46.randomFlag)
end

function var0_0.Flush(arg0_48, arg1_48, arg2_48)
	local var0_48, var1_48 = var0_0.GetSlotMaxCnt()

	arg0_48.max = var0_48
	arg0_48.unlockCnt = var1_48

	local var2_48 = arg0_48:GetUnlockShipCnt(arg1_48)

	arg0_48:UpdateCards(arg2_48, arg1_48, var2_48)
end

function var0_0.UpdateCards(arg0_49, arg1_49, arg2_49, arg3_49)
	local var0_49 = {
		0
	}
	local var1_49 = {}

	for iter0_49, iter1_49 in ipairs(arg3_49) do
		table.insert(var1_49, function(arg0_50)
			arg0_49:UpdateTypeCards(arg1_49, arg2_49, iter0_49, iter1_49, var0_49, arg0_50)
		end)
	end

	seriesAsync(var1_49)
end

function var0_0.UpdateTypeCards(arg0_51, arg1_51, arg2_51, arg3_51, arg4_51, arg5_51, arg6_51)
	local var0_51 = {}
	local var1_51 = arg0_51.cards[arg3_51]

	local function var2_51(arg0_52)
		local var0_52 = var1_51[arg0_52]

		if not var0_52 then
			var0_52 = var1_51[1]:Clone()
			var1_51[arg0_52] = var0_52
		end

		arg5_51[1] = arg5_51[1] + 1

		var0_52:Enable()
		var0_52:Update(arg5_51[1], arg0_52, arg2_51, arg1_51, arg0_51.nativeFlag)
	end

	for iter0_51 = 1, arg4_51 do
		table.insert(var0_51, function(arg0_53)
			if arg0_51.exited then
				return
			end

			var2_51(iter0_51)
			onNextTick(arg0_53)
		end)
	end

	for iter1_51 = #var1_51, arg4_51 + 1, -1 do
		var1_51[iter1_51]:Disable()
	end

	seriesAsync(var0_51, arg6_51)
end

function var0_0.GetUnlockShipCnt(arg0_54, arg1_54)
	local var0_54 = 0
	local var1_54 = 0
	local var2_54 = 0
	local var3_54 = #arg1_54
	local var4_54 = arg0_54.unlockCnt - var3_54
	local var5_54 = arg0_54.max - arg0_54.unlockCnt

	return {
		var3_54,
		var4_54,
		var5_54
	}
end

function var0_0.EditCards(arg0_55, arg1_55)
	local var0_55 = {
		var1_0,
		var2_0
	}

	for iter0_55, iter1_55 in ipairs(var0_55) do
		local var1_55 = arg0_55.cards[iter1_55]

		for iter2_55, iter3_55 in ipairs(var1_55) do
			if isActive(iter3_55._tf) then
				iter3_55:EditCard(arg1_55)
			end
		end
	end

	arg0_55.IsOpenEdit = arg1_55
end

function var0_0.EditCardsForRandom(arg0_56, arg1_56)
	local var0_56 = {}
	local var1_56 = arg0_56.cards[var1_0]

	for iter0_56, iter1_56 in ipairs(var1_56) do
		if isActive(iter1_56._tf) then
			if not arg1_56 then
				var0_56[iter1_56.slotIndex] = iter1_56:GetRandomFlagValue()
			end

			iter1_56:EditCardForRandom(arg1_56)
		end
	end

	arg0_56.IsOpenEditForRandom = arg1_56

	if #var0_56 > 0 then
		arg0_56:SaveRandomSettings(var0_56)
	end

	local var2_56 = arg0_56.cards[var2_0]

	for iter2_56, iter3_56 in ipairs(var2_56) do
		if isActive(iter3_56._tf) then
			iter3_56:EditCard(arg1_56)
		end
	end
end

function var0_0.SaveRandomSettings(arg0_57, arg1_57)
	local var0_57 = getProxy(PlayerProxy):getRawData()

	for iter0_57 = 1, arg0_57.max do
		if not arg1_57[iter0_57] then
			arg1_57[iter0_57] = var0_57:RawGetRandomShipAndSkinValueInpos(iter0_57)
		end
	end

	arg0_57:emit(PlayerVitaeMediator.CHANGE_RANDOM_SETTING, arg1_57)
end

function var0_0.Show(arg0_58)
	var0_0.super.Show(arg0_58)

	Input.multiTouchEnabled = false
end

function var0_0.Hide(arg0_59)
	var0_0.super.Hide(arg0_59)

	if arg0_59.IsOpenEdit then
		triggerButton(arg0_59.settingBtn)
	end

	if arg0_59.IsOpenEditForRandom then
		triggerButton(arg0_59.randomBtn)
	end

	Input.multiTouchEnabled = true

	arg0_59:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_DEFAULT)
end

function var0_0.OnDestroy(arg0_60)
	arg0_60:Hide()

	for iter0_60, iter1_60 in pairs(arg0_60.cards) do
		for iter2_60, iter3_60 in pairs(iter1_60) do
			iter3_60:Dispose()
		end
	end

	arg0_60.exited = true
end

return var0_0
