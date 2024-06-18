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

	if var0_0.GetEducateCharSlotMaxCnt() > 0 then
		table.insert(var2_1, var0_0.EDUCATE_CHAR_SLOT_ID)
	end

	return var2_1
end

function var0_0.GetAllUnlockSlotCnt()
	local var0_2, var1_2 = var0_0.GetSlotMaxCnt()

	return var1_2 + var0_0.GetEducateCharSlotMaxCnt()
end

function var0_0.GetEducateCharSlotMaxCnt()
	if LOCK_EDUCATE_SYSTEM then
		return 0
	end

	if getProxy(PlayerProxy):getRawData():ExistEducateChar() or getProxy(EducateProxy):IsUnlockSecretary() then
		return 1
	else
		return 0
	end
end

function var0_0.GetSlotMaxCnt()
	local var0_4 = pg.gameset.secretary_group_unlock.description
	local var1_4 = var0_4[#var0_4][2]
	local var2_4 = 1

	for iter0_4, iter1_4 in ipairs(var0_4) do
		if getProxy(ChapterProxy):isClear(iter1_4[1]) then
			var2_4 = iter1_4[2]
		end
	end

	return var1_4, var2_4
end

function var0_0.getUIName(arg0_5)
	return "PlayerVitaeShipsPage"
end

function var0_0.UpdateCard(arg0_6, arg1_6)
	local var0_6 = arg0_6.cards[var1_0]

	for iter0_6, iter1_6 in ipairs(var0_6) do
		if isActive(iter1_6._tf) and iter1_6.displayShip and iter1_6.displayShip.id == arg1_6 then
			iter1_6:Refresh()

			break
		end
	end
end

function var0_0.UpdateCardPaintingTag(arg0_7)
	local var0_7 = arg0_7.cards[var1_0]

	for iter0_7, iter1_7 in ipairs(var0_7) do
		iter1_7:updatePaintingTag()
	end
end

function var0_0.RefreshShips(arg0_8)
	arg0_8:Update()
end

function var0_0.OnLoaded(arg0_9)
	arg0_9.cardContainer = arg0_9:findTF("frame")
	arg0_9.shipTpl = arg0_9:findTF("frame/shipCard")
	arg0_9.emptyTpl = arg0_9:findTF("frame/addCard")
	arg0_9.lockTpl = arg0_9:findTF("frame/lockCard")
	arg0_9.helpBtn = arg0_9:findTF("help_btn")
	arg0_9.settingBtn = arg0_9:findTF("setting_btn")
	arg0_9.settingBtnSlider = arg0_9:findTF("toggle/on", arg0_9.settingBtn)
	arg0_9.randomBtn = arg0_9:findTF("ran_setting_btn")
	arg0_9.randomBtnSlider = arg0_9:findTF("toggle/on", arg0_9.randomBtn)
	arg0_9.settingSeceneBtn = arg0_9:findTF("setting_scene_btn")
	arg0_9.nativeBtn = arg0_9:findTF("native_setting_btn")
	arg0_9.nativeBtnOn = arg0_9.nativeBtn:Find("on")
	arg0_9.nativeBtnOff = arg0_9.nativeBtn:Find("off")
	arg0_9.educateCharTr = arg0_9:findTF("educate_char")
	arg0_9.educateCharSettingList = UIItemList.New(arg0_9:findTF("educate_char/shipCard/settings/panel"), arg0_9:findTF("educate_char/shipCard/settings/panel/tpl"))
	arg0_9.educateCharSettingBtn = arg0_9:findTF("educate_char/shipCard/settings/tpl")
	arg0_9.educateCharTrTip = arg0_9.educateCharTr:Find("tip")

	if LOCK_EDUCATE_SYSTEM then
		setActive(arg0_9.educateCharTr, false)
		setAnchoredPosition(arg0_9.cardContainer, {
			x = 0
		})
		setAnchoredPosition(arg0_9:findTF("flagship"), {
			x = -720
		})
		setAnchoredPosition(arg0_9:findTF("zs"), {
			x = 763
		})
		setAnchoredPosition(arg0_9:findTF("line"), {
			x = 740
		})
	end

	arg0_9.educateCharCards = {
		[var1_0] = PlayerVitaeEducateShipCard.New(arg0_9:findTF("educate_char/shipCard"), arg0_9.event),
		[var2_0] = PlayerVitaeEducateAddCard.New(arg0_9:findTF("educate_char/addCard"), arg0_9.event),
		[var3_0] = PlayerVitaeEducateLockCard.New(arg0_9:findTF("educate_char/lockCard"), arg0_9.event)
	}
	arg0_9.tip = arg0_9:findTF("tip"):GetComponent(typeof(Text))
	arg0_9.flagShipMark = arg0_9:findTF("flagship")

	arg0_9:bind(var0_0.ON_BEGIN_DRAG_CARD, function(arg0_10, arg1_10)
		arg0_9:OnBeginDragCard(arg1_10)
	end)
	arg0_9:bind(var0_0.ON_DRAGING_CARD, function(arg0_11, arg1_11)
		arg0_9:OnDragingCard(arg1_11)
	end)
	arg0_9:bind(var0_0.ON_DRAG_END_CARD, function(arg0_12)
		arg0_9:OnEndDragCard()
	end)
	setText(arg0_9.nativeBtnOn:Find("Text"), i18n("random_ship_before"))
	setText(arg0_9.nativeBtnOff:Find("Text"), i18n("random_ship_now"))
	setText(arg0_9.settingBtn:Find("Text"), i18n("player_vitae_skin_setting"))
	setText(arg0_9.randomBtn:Find("Text"), i18n("random_ship_label"))
	setText(arg0_9.settingSeceneBtn:Find("Text"), i18n("playervtae_setting_btn_label"))

	arg0_9.cardContainerCG = GetOrAddComponent(arg0_9.cardContainer, typeof(CanvasGroup))
end

function var0_0.OnBeginDragCard(arg0_13, arg1_13)
	arg0_13.dragIndex = arg1_13
	arg0_13.displayCards = {}
	arg0_13.displayPos = {}

	local var0_13 = arg0_13.cards[var1_0]

	for iter0_13, iter1_13 in ipairs(var0_13) do
		if isActive(iter1_13._tf) then
			arg0_13.displayCards[iter0_13] = iter1_13
			arg0_13.displayPos[iter0_13] = iter1_13._tf.localPosition
		end
	end

	for iter2_13, iter3_13 in pairs(arg0_13.displayCards) do
		if iter2_13 ~= arg1_13 then
			iter3_13:DisableDrag()
		end
	end
end

function var0_0.OnDragingCard(arg0_14, arg1_14)
	local var0_14 = arg0_14.displayCards[arg0_14.dragIndex - 1]
	local var1_14 = arg0_14.displayCards[arg0_14.dragIndex + 1]

	if var0_14 and arg0_14:ShouldSwap(arg1_14, arg0_14.dragIndex - 1) then
		arg0_14:Swap(arg0_14.dragIndex, arg0_14.dragIndex - 1)
	elseif var1_14 and arg0_14:ShouldSwap(arg1_14, arg0_14.dragIndex + 1) then
		arg0_14:Swap(arg0_14.dragIndex, arg0_14.dragIndex + 1)
	end
end

function var0_0.Swap(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.displayCards[arg1_15]
	local var1_15 = arg0_15.displayPos[arg1_15]
	local var2_15 = arg0_15.displayCards[arg2_15]

	var2_15._tf.localPosition = var1_15
	arg0_15.displayCards[arg1_15], arg0_15.displayCards[arg2_15] = arg0_15.displayCards[arg2_15], arg0_15.displayCards[arg1_15]
	arg0_15.dragIndex = arg2_15
	var0_15.slotIndex = arg2_15
	var2_15.slotIndex = arg1_15
	var0_15.typeIndex, var2_15.typeIndex = var2_15.typeIndex, var0_15.typeIndex

	local var3_15 = arg0_15.cards[var1_0]

	var3_15[arg1_15], var3_15[arg2_15] = var3_15[arg2_15], var3_15[arg1_15]
end

function var0_0.ShouldSwap(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.displayPos[arg2_16]

	return math.abs(var0_16.x - arg1_16.x) <= 130
end

function var0_0.OnEndDragCard(arg0_17)
	local var0_17 = arg0_17.displayPos[arg0_17.dragIndex]

	arg0_17.displayCards[arg0_17.dragIndex]._tf.localPosition = var0_17

	local var1_17 = {}
	local var2_17 = getProxy(PlayerProxy):getRawData()
	local var3_17 = false

	for iter0_17, iter1_17 in pairs(arg0_17.displayCards) do
		iter1_17:EnableDrag()
		table.insert(var1_17, iter1_17.displayShip.id)

		if not var3_17 and var2_17.characters[#var1_17] ~= iter1_17.displayShip.id then
			var3_17 = true
		end
	end

	arg0_17.dragIndex = nil
	arg0_17.displayCards = nil
	arg0_17.displayPos = nil
	arg0_17.cardContainerCG.blocksRaycasts = false

	if var3_17 then
		arg0_17:emit(PlayerVitaeMediator.CHANGE_PAINTS, var1_17, function()
			Timer.New(function()
				if arg0_17.cardContainerCG then
					arg0_17.cardContainerCG.blocksRaycasts = true
				end
			end, 0.3, 1):Start()
		end)
	else
		arg0_17.cardContainerCG.blocksRaycasts = true
	end
end

function var0_0.OnInit(arg0_20)
	onButton(arg0_20, arg0_20.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("secretary_help")
		})
	end, SFX_PANEL)

	local var0_20 = false

	local function var1_20()
		local var0_22 = {
			68,
			-68
		}

		setAnchoredPosition(arg0_20.settingBtnSlider, {
			x = var0_22[var0_20 and 1 or 2]
		})
	end

	onButton(arg0_20, arg0_20.settingBtn, function()
		var0_20 = not var0_20

		arg0_20:EditCards(var0_20)
		var1_20()
	end, SFX_PANEL)
	var1_20()

	local var2_20 = getProxy(SettingsProxy)

	arg0_20.randomFlag = var2_20:IsOpenRandomFlagShip()
	arg0_20.nativeFlag = false

	local function var3_20()
		local var0_24 = {
			68,
			-68
		}

		setAnchoredPosition(arg0_20.randomBtnSlider, {
			x = var0_24[arg0_20.randomFlag and 1 or 2]
		})
		setActive(arg0_20.nativeBtn, arg0_20.randomFlag)
		setActive(arg0_20.flagShipMark, not arg0_20.randomFlag or arg0_20.nativeFlag)

		if arg0_20.randomFlag and var0_20 then
			triggerButton(arg0_20.settingBtn)
		end
	end

	local function var4_20()
		setActive(arg0_20.nativeBtnOn, arg0_20.nativeFlag)
		setActive(arg0_20.nativeBtnOff, not arg0_20.nativeFlag)
		setActive(arg0_20.flagShipMark, not arg0_20.randomFlag or arg0_20.nativeFlag)

		if var0_20 then
			triggerButton(arg0_20.settingBtn)
		end
	end

	onButton(arg0_20, arg0_20.randomBtn, function()
		arg0_20.randomFlag = not arg0_20.randomFlag

		if arg0_20.randomFlag then
			local var0_26 = MainRandomFlagShipSequence.New():Random()

			if not var0_26 or #var0_26 <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_off_0"))

				arg0_20.randomFlag = not arg0_20.randomFlag

				return
			end

			var2_20:UpdateRandomFlagShipList(var0_26)
		else
			var2_20:UpdateRandomFlagShipList({})

			arg0_20.nativeFlag = false

			var4_20()
		end

		arg0_20:SwitchToPage(arg0_20.randomFlag and var5_0 or var4_0)
		var3_20()

		local var1_26 = arg0_20.randomFlag and i18n("random_ship_on") or i18n("random_ship_off")

		pg.TipsMgr.GetInstance():ShowTips(var1_26)
		arg0_20:emit(PlayerVitaeMediator.ON_SWITCH_RANDOM_FLAG_SHIP_BTN, arg0_20.randomFlag)
	end, SFX_PANEL)
	var3_20()
	onButton(arg0_20, arg0_20.nativeBtn, function()
		arg0_20.nativeFlag = not arg0_20.nativeFlag

		var4_20()
		arg0_20:SwitchToPage(arg0_20.nativeFlag and var4_0 or var5_0)
	end, SFX_PANEL)
	var4_20()
	onButton(arg0_20, arg0_20.educateCharSettingBtn, function()
		local var0_28 = isActive(arg0_20.educateCharSettingList.container)

		setActive(arg0_20.educateCharSettingList.container, not var0_28)
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20.settingSeceneBtn, function()
		arg0_20.contextData.showSelectCharacters = true

		arg0_20:emit(PlayerVitaeMediator.GO_SCENE, SCENE.SETTINGS, {
			page = NewSettingsScene.PAGE_OPTION,
			scroll = SettingsRandomFlagShipAndSkinPanel
		})
	end, SFX_PANEL)

	arg0_20.cards = {
		{},
		{},
		{}
	}

	table.insert(arg0_20.cards[var1_0], PlayerVitaeShipCard.New(arg0_20.shipTpl, arg0_20.event))
	table.insert(arg0_20.cards[var2_0], PlayerVitaeAddCard.New(arg0_20.emptyTpl, arg0_20.event))
	table.insert(arg0_20.cards[var3_0], PlayerVitaeLockCard.New(arg0_20.lockTpl, arg0_20.event))
end

function var0_0.Update(arg0_30)
	local var0_30 = getProxy(SettingsProxy)
	local var1_30

	if arg0_30.randomFlag and arg0_30.nativeFlag then
		var1_30 = var4_0
	else
		var1_30 = var0_30:IsOpenRandomFlagShip() and var5_0 or var4_0
	end

	arg0_30:SwitchToPage(var1_30)
	arg0_30:UpdateEducateChar()
	arg0_30:Show()
end

function var0_0.UpdateEducateChar(arg0_31)
	arg0_31:UpdateEducateCharSettings()
	arg0_31:UpdateEducateSlot()
	arg0_31:UpdateEducateCharTrTip()
end

function var0_0.UpdateEducateCharTrTip(arg0_32)
	setActive(arg0_32.educateCharTrTip, getProxy(SettingsProxy):ShouldEducateCharTip())
end

local function var6_0()
	if var0_0.GetEducateCharSlotMaxCnt() <= 0 then
		return var3_0
	end

	if getProxy(PlayerProxy):getRawData():ExistEducateChar() then
		return var1_0
	end

	return var2_0
end

function var0_0.UpdateEducateSlot(arg0_34)
	local var0_34 = var6_0()
	local var1_34

	for iter0_34, iter1_34 in pairs(arg0_34.educateCharCards) do
		local var2_34 = iter0_34 == var0_34

		iter1_34:ShowOrHide(var2_34)

		if var2_34 then
			var1_34 = iter1_34
		end
	end

	var1_34:Flush()
end

function var0_0.UpdateEducateCharSettings(arg0_35)
	local var0_35 = getProxy(SettingsProxy)

	local function var1_35()
		local var0_36 = var0_35:GetFlagShipDisplayMode()

		setText(arg0_35.educateCharSettingBtn:Find("Text"), i18n("flagship_display_mode_" .. var0_36))
	end

	local var2_35 = {
		FlAG_SHIP_DISPLAY_ONLY_SHIP,
		FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR,
		FlAG_SHIP_DISPLAY_ALL
	}

	arg0_35.educateCharSettingList:make(function(arg0_37, arg1_37, arg2_37)
		if arg0_37 == UIItemList.EventUpdate then
			local var0_37 = var2_35[arg1_37 + 1]

			setText(arg2_37:Find("Text"), i18n("flagship_display_mode_" .. var0_37))
			onButton(arg0_35, arg2_37, function()
				var0_35:SetFlagShipDisplayMode(var0_37)
				var1_35()
				setActive(arg0_35.educateCharSettingList.container, false)
			end, SFX_PANEL)
			setActive(arg2_37:Find("line"), arg1_37 + 1 ~= #var2_35)
		end
	end)
	arg0_35.educateCharSettingList:align(#var2_35)
	var1_35()
end

function var0_0.SwitchToPage(arg0_39, arg1_39)
	local var0_39

	if arg1_39 == var5_0 then
		var0_39 = _.select(getProxy(SettingsProxy):GetRandomFlagShipList(), function(arg0_40)
			return getProxy(BayProxy):RawGetShipById(arg0_40) ~= nil
		end)
		arg0_39.tip.text = i18n("random_ship_tips1")

		arg0_39:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_RANDOM_SHIPS)
	elseif arg1_39 == var4_0 then
		var0_39 = getProxy(PlayerProxy):getRawData().characters
		arg0_39.tip.text = i18n("random_ship_tips2")

		arg0_39:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_NATIVE_SHIPS)
	end

	arg0_39:Flush(var0_39, arg1_39)
	setActive(arg0_39.tip.gameObject, arg0_39.randomFlag)
end

function var0_0.Flush(arg0_41, arg1_41, arg2_41)
	local var0_41, var1_41 = var0_0.GetSlotMaxCnt()

	arg0_41.max = var0_41
	arg0_41.unlockCnt = var1_41

	local var2_41 = arg0_41:GetUnlockShipCnt(arg1_41)

	arg0_41:UpdateCards(arg2_41, arg1_41, var2_41)
end

function var0_0.UpdateCards(arg0_42, arg1_42, arg2_42, arg3_42)
	local var0_42 = {
		0
	}
	local var1_42 = {}

	for iter0_42, iter1_42 in ipairs(arg3_42) do
		table.insert(var1_42, function(arg0_43)
			arg0_42:UpdateTypeCards(arg1_42, arg2_42, iter0_42, iter1_42, var0_42, arg0_43)
		end)
	end

	seriesAsync(var1_42)
end

function var0_0.UpdateTypeCards(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44, arg5_44, arg6_44)
	local var0_44 = {}
	local var1_44 = arg0_44.cards[arg3_44]

	local function var2_44(arg0_45)
		local var0_45 = var1_44[arg0_45]

		if not var0_45 then
			var0_45 = var1_44[1]:Clone()
			var1_44[arg0_45] = var0_45
		end

		arg5_44[1] = arg5_44[1] + 1

		var0_45:Enable()
		var0_45:Update(arg5_44[1], arg0_45, arg2_44, arg1_44, arg0_44.nativeFlag)
	end

	for iter0_44 = 1, arg4_44 do
		table.insert(var0_44, function(arg0_46)
			if arg0_44.exited then
				return
			end

			var2_44(iter0_44)
			onNextTick(arg0_46)
		end)
	end

	for iter1_44 = #var1_44, arg4_44 + 1, -1 do
		var1_44[iter1_44]:Disable()
	end

	seriesAsync(var0_44, arg6_44)
end

function var0_0.GetUnlockShipCnt(arg0_47, arg1_47)
	local var0_47 = 0
	local var1_47 = 0
	local var2_47 = 0
	local var3_47 = #arg1_47
	local var4_47 = arg0_47.unlockCnt - var3_47
	local var5_47 = arg0_47.max - arg0_47.unlockCnt

	return {
		var3_47,
		var4_47,
		var5_47
	}
end

function var0_0.EditCards(arg0_48, arg1_48)
	local var0_48 = {
		var1_0,
		var2_0
	}

	for iter0_48, iter1_48 in ipairs(var0_48) do
		local var1_48 = arg0_48.cards[iter1_48]

		for iter2_48, iter3_48 in ipairs(var1_48) do
			if isActive(iter3_48._tf) then
				iter3_48:EditCard(arg1_48)
			end
		end
	end

	arg0_48.IsOpenEdit = arg1_48
end

function var0_0.EditCardsForRandom(arg0_49, arg1_49)
	local var0_49 = {}
	local var1_49 = arg0_49.cards[var1_0]

	for iter0_49, iter1_49 in ipairs(var1_49) do
		if isActive(iter1_49._tf) then
			if not arg1_49 then
				var0_49[iter1_49.slotIndex] = iter1_49:GetRandomFlagValue()
			end

			iter1_49:EditCardForRandom(arg1_49)
		end
	end

	arg0_49.IsOpenEditForRandom = arg1_49

	if #var0_49 > 0 then
		arg0_49:SaveRandomSettings(var0_49)
	end

	local var2_49 = arg0_49.cards[var2_0]

	for iter2_49, iter3_49 in ipairs(var2_49) do
		if isActive(iter3_49._tf) then
			iter3_49:EditCard(arg1_49)
		end
	end
end

function var0_0.SaveRandomSettings(arg0_50, arg1_50)
	local var0_50 = getProxy(PlayerProxy):getRawData()

	for iter0_50 = 1, arg0_50.max do
		if not arg1_50[iter0_50] then
			arg1_50[iter0_50] = var0_50:RawGetRandomShipAndSkinValueInpos(iter0_50)
		end
	end

	arg0_50:emit(PlayerVitaeMediator.CHANGE_RANDOM_SETTING, arg1_50)
end

function var0_0.Show(arg0_51)
	var0_0.super.Show(arg0_51)

	Input.multiTouchEnabled = false
end

function var0_0.Hide(arg0_52)
	var0_0.super.Hide(arg0_52)

	if arg0_52.IsOpenEdit then
		triggerButton(arg0_52.settingBtn)
	end

	if arg0_52.IsOpenEditForRandom then
		triggerButton(arg0_52.randomBtn)
	end

	Input.multiTouchEnabled = true

	arg0_52:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_DEFAULT)
end

function var0_0.OnDestroy(arg0_53)
	arg0_53:Hide()

	for iter0_53, iter1_53 in pairs(arg0_53.cards) do
		for iter2_53, iter3_53 in pairs(iter1_53) do
			iter3_53:Dispose()
		end
	end

	arg0_53.exited = true
end

return var0_0
