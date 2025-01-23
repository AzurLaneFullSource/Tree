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

function var0_0.UpdateCard(arg0_5, arg1_5)
	local var0_5 = arg0_5.cards[var1_0]

	for iter0_5, iter1_5 in ipairs(var0_5) do
		if isActive(iter1_5._tf) and iter1_5.displayShip and iter1_5.displayShip.id == arg1_5 then
			iter1_5:Refresh()

			break
		end
	end
end

function var0_0.UpdateCardPaintingTag(arg0_6)
	local var0_6 = arg0_6.cards[var1_0]

	for iter0_6, iter1_6 in ipairs(var0_6) do
		iter1_6:updatePaintingTag()
	end
end

function var0_0.RefreshShips(arg0_7)
	arg0_7:Update()
end

function var0_0.OnLoaded(arg0_8)
	arg0_8.cardContainer = arg0_8:findTF("frame")
	arg0_8.shipTpl = arg0_8:findTF("frame/shipCard")
	arg0_8.emptyTpl = arg0_8:findTF("frame/addCard")
	arg0_8.lockTpl = arg0_8:findTF("frame/lockCard")
	arg0_8.helpBtn = arg0_8:findTF("help_btn")
	arg0_8.settingBtn = arg0_8:findTF("setting_btn")
	arg0_8.settingBtnSlider = arg0_8:findTF("toggle/on", arg0_8.settingBtn)
	arg0_8.randomBtn = arg0_8:findTF("ran_setting_btn")
	arg0_8.randomBtnSlider = arg0_8:findTF("toggle/on", arg0_8.randomBtn)
	arg0_8.settingSeceneBtn = arg0_8:findTF("setting_scene_btn")
	arg0_8.nativeBtn = arg0_8:findTF("native_setting_btn")
	arg0_8.nativeBtnOn = arg0_8.nativeBtn:Find("on")
	arg0_8.nativeBtnOff = arg0_8.nativeBtn:Find("off")
	arg0_8.educateCharTr = arg0_8:findTF("educate_char")
	arg0_8.educateCharSettingList = UIItemList.New(arg0_8:findTF("educate_char/shipCard/settings/panel"), arg0_8:findTF("educate_char/shipCard/settings/panel/tpl"))
	arg0_8.educateCharSettingBtn = arg0_8:findTF("educate_char/shipCard/settings/tpl")
	arg0_8.educateCharTrTip = arg0_8.educateCharTr:Find("tip")

	if LOCK_EDUCATE_SYSTEM then
		setActive(arg0_8.educateCharTr, false)
		setAnchoredPosition(arg0_8.cardContainer, {
			x = 0
		})
		setAnchoredPosition(arg0_8:findTF("flagship"), {
			x = -720
		})
		setAnchoredPosition(arg0_8:findTF("zs"), {
			x = 763
		})
		setAnchoredPosition(arg0_8:findTF("line"), {
			x = 740
		})
	end

	arg0_8.educateCharCards = {
		[var1_0] = PlayerVitaeEducateShipCard.New(arg0_8:findTF("educate_char/shipCard"), arg0_8.event),
		[var2_0] = PlayerVitaeEducateAddCard.New(arg0_8:findTF("educate_char/addCard"), arg0_8.event),
		[var3_0] = PlayerVitaeEducateLockCard.New(arg0_8:findTF("educate_char/lockCard"), arg0_8.event)
	}
	arg0_8.tip = arg0_8:findTF("tip"):GetComponent(typeof(Text))
	arg0_8.flagShipMark = arg0_8:findTF("flagship")

	arg0_8:bind(var0_0.ON_BEGIN_DRAG_CARD, function(arg0_9, arg1_9)
		arg0_8:OnBeginDragCard(arg1_9)
	end)
	arg0_8:bind(var0_0.ON_DRAGING_CARD, function(arg0_10, arg1_10)
		arg0_8:OnDragingCard(arg1_10)
	end)
	arg0_8:bind(var0_0.ON_DRAG_END_CARD, function(arg0_11)
		arg0_8:OnEndDragCard()
	end)
	setText(arg0_8.nativeBtnOn:Find("Text"), i18n("random_ship_before"))
	setText(arg0_8.nativeBtnOff:Find("Text"), i18n("random_ship_now"))
	setText(arg0_8.settingBtn:Find("Text"), i18n("player_vitae_skin_setting"))
	setText(arg0_8.randomBtn:Find("Text"), i18n("random_ship_label"))
	setText(arg0_8.settingSeceneBtn:Find("Text"), i18n("playervtae_setting_btn_label"))

	arg0_8.cardContainerCG = GetOrAddComponent(arg0_8.cardContainer, typeof(CanvasGroup))
end

function var0_0.OnBeginDragCard(arg0_12, arg1_12)
	arg0_12.dragIndex = arg1_12
	arg0_12.displayCards = {}
	arg0_12.displayPos = {}

	local var0_12 = arg0_12.cards[var1_0]

	for iter0_12, iter1_12 in ipairs(var0_12) do
		if isActive(iter1_12._tf) then
			arg0_12.displayCards[iter0_12] = iter1_12
			arg0_12.displayPos[iter0_12] = iter1_12._tf.localPosition
		end
	end

	for iter2_12, iter3_12 in pairs(arg0_12.displayCards) do
		if iter2_12 ~= arg1_12 then
			iter3_12:DisableDrag()
		end
	end
end

function var0_0.OnDragingCard(arg0_13, arg1_13)
	local var0_13 = arg0_13.displayCards[arg0_13.dragIndex - 1]
	local var1_13 = arg0_13.displayCards[arg0_13.dragIndex + 1]

	if var0_13 and arg0_13:ShouldSwap(arg1_13, arg0_13.dragIndex - 1) then
		arg0_13:Swap(arg0_13.dragIndex, arg0_13.dragIndex - 1)
	elseif var1_13 and arg0_13:ShouldSwap(arg1_13, arg0_13.dragIndex + 1) then
		arg0_13:Swap(arg0_13.dragIndex, arg0_13.dragIndex + 1)
	end
end

function var0_0.Swap(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.displayCards[arg1_14]
	local var1_14 = arg0_14.displayPos[arg1_14]
	local var2_14 = arg0_14.displayCards[arg2_14]

	var2_14._tf.localPosition = var1_14
	arg0_14.displayCards[arg1_14], arg0_14.displayCards[arg2_14] = arg0_14.displayCards[arg2_14], arg0_14.displayCards[arg1_14]
	arg0_14.dragIndex = arg2_14
	var0_14.slotIndex = arg2_14
	var2_14.slotIndex = arg1_14
	var0_14.typeIndex, var2_14.typeIndex = var2_14.typeIndex, var0_14.typeIndex

	local var3_14 = arg0_14.cards[var1_0]

	var3_14[arg1_14], var3_14[arg2_14] = var3_14[arg2_14], var3_14[arg1_14]
end

function var0_0.ShouldSwap(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.displayPos[arg2_15]

	return math.abs(var0_15.x - arg1_15.x) <= 130
end

function var0_0.OnEndDragCard(arg0_16)
	local var0_16 = arg0_16.displayPos[arg0_16.dragIndex]

	arg0_16.displayCards[arg0_16.dragIndex]._tf.localPosition = var0_16

	local var1_16 = {}
	local var2_16 = getProxy(PlayerProxy):getRawData()
	local var3_16 = false

	for iter0_16, iter1_16 in pairs(arg0_16.displayCards) do
		iter1_16:EnableDrag()
		table.insert(var1_16, iter1_16.displayShip.id)

		if not var3_16 and var2_16.characters[#var1_16] ~= iter1_16.displayShip.id then
			var3_16 = true
		end
	end

	arg0_16.dragIndex = nil
	arg0_16.displayCards = nil
	arg0_16.displayPos = nil
	arg0_16.cardContainerCG.blocksRaycasts = false

	if var3_16 then
		arg0_16:emit(PlayerVitaeMediator.CHANGE_PAINTS, var1_16, function()
			Timer.New(function()
				if arg0_16.cardContainerCG then
					arg0_16.cardContainerCG.blocksRaycasts = true
				end
			end, 0.3, 1):Start()
		end)
	else
		arg0_16.cardContainerCG.blocksRaycasts = true
	end
end

function var0_0.OnInit(arg0_19)
	onButton(arg0_19, arg0_19.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("secretary_help")
		})
	end, SFX_PANEL)

	local var0_19 = false

	local function var1_19()
		local var0_21 = {
			68,
			-68
		}

		setAnchoredPosition(arg0_19.settingBtnSlider, {
			x = var0_21[var0_19 and 1 or 2]
		})
	end

	onButton(arg0_19, arg0_19.settingBtn, function()
		var0_19 = not var0_19

		arg0_19:EditCards(var0_19)
		var1_19()
	end, SFX_PANEL)
	var1_19()

	local var2_19 = getProxy(SettingsProxy)

	arg0_19.randomFlag = var2_19:IsOpenRandomFlagShip()
	arg0_19.nativeFlag = false

	local function var3_19()
		local var0_23 = {
			68,
			-68
		}

		setAnchoredPosition(arg0_19.randomBtnSlider, {
			x = var0_23[arg0_19.randomFlag and 1 or 2]
		})
		setActive(arg0_19.nativeBtn, arg0_19.randomFlag)
		setActive(arg0_19.flagShipMark, not arg0_19.randomFlag or arg0_19.nativeFlag)

		if arg0_19.randomFlag and var0_19 then
			triggerButton(arg0_19.settingBtn)
		end
	end

	local function var4_19()
		setActive(arg0_19.nativeBtnOn, arg0_19.nativeFlag)
		setActive(arg0_19.nativeBtnOff, not arg0_19.nativeFlag)
		setActive(arg0_19.flagShipMark, not arg0_19.randomFlag or arg0_19.nativeFlag)

		if var0_19 then
			triggerButton(arg0_19.settingBtn)
		end
	end

	onButton(arg0_19, arg0_19.randomBtn, function()
		arg0_19.randomFlag = not arg0_19.randomFlag

		if arg0_19.randomFlag then
			local var0_25 = MainRandomFlagShipSequence.New():Random()

			if not var0_25 or #var0_25 <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_off_0"))

				arg0_19.randomFlag = not arg0_19.randomFlag

				return
			end

			var2_19:UpdateRandomFlagShipList(var0_25)
		else
			var2_19:UpdateRandomFlagShipList({})

			arg0_19.nativeFlag = false

			var4_19()
		end

		arg0_19:SwitchToPage(arg0_19.randomFlag and var5_0 or var4_0)
		var3_19()

		local var1_25 = arg0_19.randomFlag and i18n("random_ship_on") or i18n("random_ship_off")

		pg.TipsMgr.GetInstance():ShowTips(var1_25)
		arg0_19:emit(PlayerVitaeMediator.ON_SWITCH_RANDOM_FLAG_SHIP_BTN, arg0_19.randomFlag)
	end, SFX_PANEL)
	var3_19()
	onButton(arg0_19, arg0_19.nativeBtn, function()
		arg0_19.nativeFlag = not arg0_19.nativeFlag

		var4_19()
		arg0_19:SwitchToPage(arg0_19.nativeFlag and var4_0 or var5_0)
	end, SFX_PANEL)
	var4_19()
	onButton(arg0_19, arg0_19.educateCharSettingBtn, function()
		local var0_27 = isActive(arg0_19.educateCharSettingList.container)

		setActive(arg0_19.educateCharSettingList.container, not var0_27)
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.settingSeceneBtn, function()
		arg0_19.contextData.showSelectCharacters = true

		arg0_19:emit(PlayerVitaeMediator.GO_SCENE, SCENE.SETTINGS, {
			page = NewSettingsScene.PAGE_OPTION,
			scroll = SettingsRandomFlagShipAndSkinPanel
		})
	end, SFX_PANEL)

	arg0_19.cards = {
		{},
		{},
		{}
	}

	table.insert(arg0_19.cards[var1_0], PlayerVitaeShipCard.New(arg0_19.shipTpl, arg0_19.event))
	table.insert(arg0_19.cards[var2_0], PlayerVitaeAddCard.New(arg0_19.emptyTpl, arg0_19.event))
	table.insert(arg0_19.cards[var3_0], PlayerVitaeLockCard.New(arg0_19.lockTpl, arg0_19.event))
end

function var0_0.Update(arg0_29)
	local var0_29 = getProxy(SettingsProxy)
	local var1_29

	if arg0_29.randomFlag and arg0_29.nativeFlag then
		var1_29 = var4_0
	else
		var1_29 = var0_29:IsOpenRandomFlagShip() and var5_0 or var4_0
	end

	arg0_29:SwitchToPage(var1_29)
	arg0_29:UpdateEducateChar()
	arg0_29:Show()
end

function var0_0.UpdateEducateChar(arg0_30)
	arg0_30:UpdateEducateCharSettings()
	arg0_30:UpdateEducateSlot()
	arg0_30:UpdateEducateCharTrTip()
end

function var0_0.UpdateEducateCharTrTip(arg0_31)
	setActive(arg0_31.educateCharTrTip, getProxy(SettingsProxy):ShouldEducateCharTip())
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

function var0_0.UpdateEducateSlot(arg0_33)
	local var0_33 = var6_0()
	local var1_33

	for iter0_33, iter1_33 in pairs(arg0_33.educateCharCards) do
		local var2_33 = iter0_33 == var0_33

		iter1_33:ShowOrHide(var2_33)

		if var2_33 then
			var1_33 = iter1_33
		end
	end

	var1_33:Flush()
end

function var0_0.UpdateEducateCharSettings(arg0_34)
	local var0_34 = getProxy(SettingsProxy)

	local function var1_34()
		local var0_35 = var0_34:GetFlagShipDisplayMode()

		setText(arg0_34.educateCharSettingBtn:Find("Text"), i18n("flagship_display_mode_" .. var0_35))
	end

	local var2_34 = {
		FlAG_SHIP_DISPLAY_ONLY_SHIP,
		FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR,
		FlAG_SHIP_DISPLAY_ALL
	}

	arg0_34.educateCharSettingList:make(function(arg0_36, arg1_36, arg2_36)
		if arg0_36 == UIItemList.EventUpdate then
			local var0_36 = var2_34[arg1_36 + 1]

			setText(arg2_36:Find("Text"), i18n("flagship_display_mode_" .. var0_36))
			onButton(arg0_34, arg2_36, function()
				var0_34:SetFlagShipDisplayMode(var0_36)
				var1_34()
				setActive(arg0_34.educateCharSettingList.container, false)
			end, SFX_PANEL)
			setActive(arg2_36:Find("line"), arg1_36 + 1 ~= #var2_34)
		end
	end)
	arg0_34.educateCharSettingList:align(#var2_34)
	var1_34()
end

function var0_0.SwitchToPage(arg0_38, arg1_38)
	local var0_38

	if arg1_38 == var5_0 then
		var0_38 = _.select(getProxy(SettingsProxy):GetRandomFlagShipList(), function(arg0_39)
			return getProxy(BayProxy):RawGetShipById(arg0_39) ~= nil
		end)
		arg0_38.tip.text = i18n("random_ship_tips1")

		arg0_38:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_RANDOM_SHIPS)
	elseif arg1_38 == var4_0 then
		var0_38 = getProxy(PlayerProxy):getRawData().characters
		arg0_38.tip.text = i18n("random_ship_tips2")

		arg0_38:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_NATIVE_SHIPS)
	end

	arg0_38:Flush(var0_38, arg1_38)
	setActive(arg0_38.tip.gameObject, arg0_38.randomFlag)
end

function var0_0.Flush(arg0_40, arg1_40, arg2_40)
	local var0_40, var1_40 = var0_0.GetSlotMaxCnt()

	arg0_40.max = var0_40
	arg0_40.unlockCnt = var1_40

	local var2_40 = arg0_40:GetUnlockShipCnt(arg1_40)

	arg0_40:UpdateCards(arg2_40, arg1_40, var2_40)
end

function var0_0.UpdateCards(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41 = {
		0
	}
	local var1_41 = {}

	for iter0_41, iter1_41 in ipairs(arg3_41) do
		table.insert(var1_41, function(arg0_42)
			arg0_41:UpdateTypeCards(arg1_41, arg2_41, iter0_41, iter1_41, var0_41, arg0_42)
		end)
	end

	seriesAsync(var1_41)
end

function var0_0.UpdateTypeCards(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43, arg5_43, arg6_43)
	local var0_43 = {}
	local var1_43 = arg0_43.cards[arg3_43]

	local function var2_43(arg0_44)
		local var0_44 = var1_43[arg0_44]

		if not var0_44 then
			var0_44 = var1_43[1]:Clone()
			var1_43[arg0_44] = var0_44
		end

		arg5_43[1] = arg5_43[1] + 1

		var0_44:Enable()
		var0_44:Update(arg5_43[1], arg0_44, arg2_43, arg1_43, arg0_43.nativeFlag)
	end

	for iter0_43 = 1, arg4_43 do
		table.insert(var0_43, function(arg0_45)
			if arg0_43.exited then
				return
			end

			var2_43(iter0_43)
			onNextTick(arg0_45)
		end)
	end

	for iter1_43 = #var1_43, arg4_43 + 1, -1 do
		var1_43[iter1_43]:Disable()
	end

	seriesAsync(var0_43, arg6_43)
end

function var0_0.GetUnlockShipCnt(arg0_46, arg1_46)
	local var0_46 = 0
	local var1_46 = 0
	local var2_46 = 0
	local var3_46 = #arg1_46
	local var4_46 = arg0_46.unlockCnt - var3_46
	local var5_46 = arg0_46.max - arg0_46.unlockCnt

	return {
		var3_46,
		var4_46,
		var5_46
	}
end

function var0_0.EditCards(arg0_47, arg1_47)
	local var0_47 = {
		var1_0,
		var2_0
	}

	for iter0_47, iter1_47 in ipairs(var0_47) do
		local var1_47 = arg0_47.cards[iter1_47]

		for iter2_47, iter3_47 in ipairs(var1_47) do
			if isActive(iter3_47._tf) then
				iter3_47:EditCard(arg1_47)
			end
		end
	end

	arg0_47.IsOpenEdit = arg1_47
end

function var0_0.EditCardsForRandom(arg0_48, arg1_48)
	local var0_48 = {}
	local var1_48 = arg0_48.cards[var1_0]

	for iter0_48, iter1_48 in ipairs(var1_48) do
		if isActive(iter1_48._tf) then
			if not arg1_48 then
				var0_48[iter1_48.slotIndex] = iter1_48:GetRandomFlagValue()
			end

			iter1_48:EditCardForRandom(arg1_48)
		end
	end

	arg0_48.IsOpenEditForRandom = arg1_48

	if #var0_48 > 0 then
		arg0_48:SaveRandomSettings(var0_48)
	end

	local var2_48 = arg0_48.cards[var2_0]

	for iter2_48, iter3_48 in ipairs(var2_48) do
		if isActive(iter3_48._tf) then
			iter3_48:EditCard(arg1_48)
		end
	end
end

function var0_0.SaveRandomSettings(arg0_49, arg1_49)
	local var0_49 = getProxy(PlayerProxy):getRawData()

	for iter0_49 = 1, arg0_49.max do
		if not arg1_49[iter0_49] then
			arg1_49[iter0_49] = var0_49:RawGetRandomShipAndSkinValueInpos(iter0_49)
		end
	end

	arg0_49:emit(PlayerVitaeMediator.CHANGE_RANDOM_SETTING, arg1_49)
end

function var0_0.Show(arg0_50)
	var0_0.super.Show(arg0_50)

	Input.multiTouchEnabled = false
end

function var0_0.Hide(arg0_51)
	var0_0.super.Hide(arg0_51)

	if arg0_51.IsOpenEdit then
		triggerButton(arg0_51.settingBtn)
	end

	if arg0_51.IsOpenEditForRandom then
		triggerButton(arg0_51.randomBtn)
	end

	Input.multiTouchEnabled = true

	arg0_51:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_DEFAULT)
end

function var0_0.OnDestroy(arg0_52)
	arg0_52:Hide()

	for iter0_52, iter1_52 in pairs(arg0_52.cards) do
		for iter2_52, iter3_52 in pairs(iter1_52) do
			iter3_52:Dispose()
		end
	end

	arg0_52.exited = true
end

return var0_0
