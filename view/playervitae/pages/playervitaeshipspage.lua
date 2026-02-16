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
		if isActive(iter1_5._tf) and iter1_5.displayShip and iter1_5.displayShip:GetShipPhantomMark() == arg1_5 then
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
	arg0_8.cardContainer = arg0_8._tf:Find("frame")
	arg0_8.shipTpl = arg0_8._tf:Find("frame/shipCard")
	arg0_8.emptyTpl = arg0_8._tf:Find("frame/addCard")
	arg0_8.lockTpl = arg0_8._tf:Find("frame/lockCard")
	arg0_8.helpBtn = arg0_8._tf:Find("help_btn")
	arg0_8.settingBtn = arg0_8._tf:Find("setting_btn")
	arg0_8.settingBtnSlider = arg0_8.settingBtn:Find("toggle/on")
	arg0_8.randomBtn = arg0_8._tf:Find("ran_setting_btn")
	arg0_8.randomBtnSlider = arg0_8.randomBtn:Find("toggle/on")
	arg0_8.settingSeceneBtn = arg0_8._tf:Find("setting_scene_btn")
	arg0_8.nativeBtn = arg0_8._tf:Find("native_setting_btn")
	arg0_8.nativeBtnOn = arg0_8.nativeBtn:Find("on")
	arg0_8.nativeBtnOff = arg0_8.nativeBtn:Find("off")
	arg0_8.getMailBtn = arg0_8._tf:Find("get_mail")
	arg0_8.educateCharTr = arg0_8._tf:Find("educate_char")
	arg0_8.educateCharSettingList = UIItemList.New(arg0_8._tf:Find("educate_char/shipCard/settings/panel"), arg0_8._tf:Find("educate_char/shipCard/settings/panel/tpl"))
	arg0_8.educateCharSettingBtn = arg0_8._tf:Find("educate_char/shipCard/settings/tpl")
	arg0_8.educateCharTrTip = arg0_8.educateCharTr:Find("tip")

	if LOCK_EDUCATE_SYSTEM then
		setActive(arg0_8.educateCharTr, false)
		setAnchoredPosition(arg0_8.cardContainer, {
			x = 0
		})
		setAnchoredPosition(arg0_8._tf:Find("flagship"), {
			x = -720
		})
		setAnchoredPosition(arg0_8._tf:Find("zs"), {
			x = 763
		})
		setAnchoredPosition(arg0_8._tf:Find("line"), {
			x = 740
		})
	end

	arg0_8.educateCharCards = {
		[var1_0] = PlayerVitaeEducateShipCard.New(arg0_8._tf:Find("educate_char/shipCard"), arg0_8.event),
		[var2_0] = PlayerVitaeEducateAddCard.New(arg0_8._tf:Find("educate_char/addCard"), arg0_8.event),
		[var3_0] = PlayerVitaeEducateLockCard.New(arg0_8._tf:Find("educate_char/lockCard"), arg0_8.event)
	}
	arg0_8.tip = arg0_8._tf:Find("tip"):GetComponent(typeof(Text))
	arg0_8.flagShipMark = arg0_8._tf:Find("flagship")

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
	setText(arg0_8.getMailBtn:Find("Text"), i18n("spring_present_tips_btn"))
	setText(arg0_8.getMailBtn:Find("time"), i18n("spring_present_tips_time"))

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
	local var2_16 = getProxy(PlayerProxy):getRawData():GetShipPhantomMarks()
	local var3_16 = false

	for iter0_16, iter1_16 in pairs(arg0_16.displayCards) do
		iter1_16:EnableDrag()
		table.insert(var1_16, iter1_16.displayShip:GetShipPhantomMark())

		if not var3_16 and var2_16[#var1_16] ~= var1_16[#var1_16] then
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
	onButton(arg0_19, arg0_19.getMailBtn, function()
		if arg0_19.randomFlag then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spring_present_tips0"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("spring_present_tips1"),
			onYes = function()
				local var0_28 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_MAIL)

				if not var0_28 then
					setActive(arg0_19.getMailBtn, false)
					pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

					return
				end

				arg0_19:emit(PlayerVitaeMediator.ON_GET_LOVE_LETTER_MAIL, var0_28.id)
			end
		})
	end)
	arg0_19:UpdateGetMailBtn()
	onButton(arg0_19, arg0_19.educateCharSettingBtn, function()
		local var0_29 = isActive(arg0_19.educateCharSettingList.container)

		setActive(arg0_19.educateCharSettingList.container, not var0_29)
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

function var0_0.UpdateGetMailBtn(arg0_31)
	local var0_31 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_MAIL)

	setActive(arg0_31.getMailBtn, var0_31 and not var0_31:isEnd() and var0_31:readyToAchieve())
end

function var0_0.Update(arg0_32)
	local var0_32 = getProxy(SettingsProxy)
	local var1_32

	if arg0_32.randomFlag and arg0_32.nativeFlag then
		var1_32 = var4_0
	else
		var1_32 = var0_32:IsOpenRandomFlagShip() and var5_0 or var4_0
	end

	arg0_32:SwitchToPage(var1_32)
	arg0_32:UpdateEducateChar()
	arg0_32:UpdateGetMailBtn()
	arg0_32:Show()
end

function var0_0.UpdateEducateChar(arg0_33)
	arg0_33:UpdateEducateCharSettings()
	arg0_33:UpdateEducateSlot()
	arg0_33:UpdateEducateCharTrTip()
end

function var0_0.UpdateEducateCharTrTip(arg0_34)
	setActive(arg0_34.educateCharTrTip, getProxy(SettingsProxy):ShouldEducateCharTip())
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

function var0_0.UpdateEducateSlot(arg0_36)
	local var0_36 = var6_0()
	local var1_36

	for iter0_36, iter1_36 in pairs(arg0_36.educateCharCards) do
		local var2_36 = iter0_36 == var0_36

		iter1_36:ShowOrHide(var2_36)

		if var2_36 then
			var1_36 = iter1_36
		end
	end

	var1_36:Flush()
end

function var0_0.UpdateEducateCharSettings(arg0_37)
	local var0_37 = getProxy(SettingsProxy)

	local function var1_37()
		local var0_38 = var0_37:GetFlagShipDisplayMode()

		setText(arg0_37.educateCharSettingBtn:Find("Text"), i18n("flagship_display_mode_" .. var0_38))
	end

	local var2_37 = {
		FlAG_SHIP_DISPLAY_ONLY_SHIP,
		FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR,
		FlAG_SHIP_DISPLAY_ALL
	}

	arg0_37.educateCharSettingList:make(function(arg0_39, arg1_39, arg2_39)
		if arg0_39 == UIItemList.EventUpdate then
			local var0_39 = var2_37[arg1_39 + 1]

			setText(arg2_39:Find("Text"), i18n("flagship_display_mode_" .. var0_39))
			onButton(arg0_37, arg2_39, function()
				var0_37:SetFlagShipDisplayMode(var0_39)
				var1_37()
				setActive(arg0_37.educateCharSettingList.container, false)
			end, SFX_PANEL)
			setActive(arg2_39:Find("line"), arg1_39 + 1 ~= #var2_37)
		end
	end)
	arg0_37.educateCharSettingList:align(#var2_37)
	var1_37()
end

function var0_0.SwitchToPage(arg0_41, arg1_41)
	local var0_41

	if arg1_41 == var5_0 then
		var0_41 = _.select(getProxy(SettingsProxy):GetRandomFlagShipList(), function(arg0_42)
			return getProxy(BayProxy):GetShipPhantom(arg0_42) ~= nil
		end)
		arg0_41.tip.text = i18n("random_ship_tips1")

		arg0_41:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_RANDOM_SHIPS)
	elseif arg1_41 == var4_0 then
		var0_41 = getProxy(PlayerProxy):getRawData():GetShipPhantomMarks()
		arg0_41.tip.text = i18n("random_ship_tips2")

		arg0_41:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_NATIVE_SHIPS)
	end

	arg0_41:Flush(var0_41, arg1_41)
	setActive(arg0_41.tip.gameObject, arg0_41.randomFlag)
end

function var0_0.Flush(arg0_43, arg1_43, arg2_43)
	local var0_43, var1_43 = var0_0.GetSlotMaxCnt()

	arg0_43.max = var0_43
	arg0_43.unlockCnt = var1_43

	local var2_43 = arg0_43:GetUnlockShipCnt(arg1_43)

	arg0_43:UpdateCards(arg2_43, arg1_43, var2_43)
end

function var0_0.UpdateCards(arg0_44, arg1_44, arg2_44, arg3_44)
	local var0_44 = {
		0
	}
	local var1_44 = {}

	for iter0_44, iter1_44 in ipairs(arg3_44) do
		table.insert(var1_44, function(arg0_45)
			arg0_44:UpdateTypeCards(arg1_44, arg2_44, iter0_44, iter1_44, var0_44, arg0_45)
		end)
	end

	seriesAsync(var1_44)
end

function var0_0.UpdateTypeCards(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46, arg5_46, arg6_46)
	local var0_46 = {}
	local var1_46 = arg0_46.cards[arg3_46]

	local function var2_46(arg0_47)
		local var0_47 = var1_46[arg0_47]

		if not var0_47 then
			var0_47 = var1_46[1]:Clone()
			var1_46[arg0_47] = var0_47
		end

		arg5_46[1] = arg5_46[1] + 1

		var0_47:Enable()
		var0_47:Update(arg5_46[1], arg0_47, arg2_46, arg1_46, arg0_46.nativeFlag)
	end

	for iter0_46 = 1, arg4_46 do
		table.insert(var0_46, function(arg0_48)
			if arg0_46.exited then
				return
			end

			var2_46(iter0_46)
			onNextTick(arg0_48)
		end)
	end

	for iter1_46 = #var1_46, arg4_46 + 1, -1 do
		var1_46[iter1_46]:Disable()
	end

	seriesAsync(var0_46, arg6_46)
end

function var0_0.GetUnlockShipCnt(arg0_49, arg1_49)
	local var0_49 = 0
	local var1_49 = 0
	local var2_49 = 0
	local var3_49 = #arg1_49
	local var4_49 = arg0_49.unlockCnt - var3_49
	local var5_49 = arg0_49.max - arg0_49.unlockCnt

	return {
		var3_49,
		var4_49,
		var5_49
	}
end

function var0_0.EditCards(arg0_50, arg1_50)
	local var0_50 = {
		var1_0,
		var2_0
	}

	for iter0_50, iter1_50 in ipairs(var0_50) do
		local var1_50 = arg0_50.cards[iter1_50]

		for iter2_50, iter3_50 in ipairs(var1_50) do
			if isActive(iter3_50._tf) then
				iter3_50:EditCard(arg1_50)
			end
		end
	end

	arg0_50.IsOpenEdit = arg1_50
end

function var0_0.EditCardsForRandom(arg0_51, arg1_51)
	local var0_51 = {}
	local var1_51 = arg0_51.cards[var1_0]

	for iter0_51, iter1_51 in ipairs(var1_51) do
		if isActive(iter1_51._tf) then
			if not arg1_51 then
				var0_51[iter1_51.slotIndex] = iter1_51:GetRandomFlagValue()
			end

			iter1_51:EditCardForRandom(arg1_51)
		end
	end

	arg0_51.IsOpenEditForRandom = arg1_51

	if #var0_51 > 0 then
		arg0_51:SaveRandomSettings(var0_51)
	end

	local var2_51 = arg0_51.cards[var2_0]

	for iter2_51, iter3_51 in ipairs(var2_51) do
		if isActive(iter3_51._tf) then
			iter3_51:EditCard(arg1_51)
		end
	end
end

function var0_0.SaveRandomSettings(arg0_52, arg1_52)
	local var0_52 = getProxy(PlayerProxy):getRawData()

	for iter0_52 = 1, arg0_52.max do
		if not arg1_52[iter0_52] then
			arg1_52[iter0_52] = var0_52:RawGetRandomShipAndSkinValueInpos(iter0_52)
		end
	end

	arg0_52:emit(PlayerVitaeMediator.CHANGE_RANDOM_SETTING, arg1_52)
end

function var0_0.Show(arg0_53)
	var0_0.super.Show(arg0_53)

	Input.multiTouchEnabled = false
end

function var0_0.Hide(arg0_54)
	var0_0.super.Hide(arg0_54)

	if arg0_54.IsOpenEdit then
		triggerButton(arg0_54.settingBtn)
	end

	if arg0_54.IsOpenEditForRandom then
		triggerButton(arg0_54.randomBtn)
	end

	Input.multiTouchEnabled = true

	arg0_54:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_DEFAULT)
end

function var0_0.OnDestroy(arg0_55)
	arg0_55:Hide()

	for iter0_55, iter1_55 in pairs(arg0_55.cards) do
		for iter2_55, iter3_55 in pairs(iter1_55) do
			iter3_55:Dispose()
		end
	end

	arg0_55.exited = true
end

return var0_0
