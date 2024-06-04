local var0 = class("PlayerVitaeShipsPage", import("...base.BaseSubView"))
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 1
local var5 = 2

var0.RANDOM_FLAG_SHIP_PAGE = var5
var0.EDUCATE_CHAR_SLOT_ID = 6
var0.ON_BEGIN_DRAG_CARD = "PlayerVitaeShipsPage:ON_BEGIN_DRAG_CARD"
var0.ON_DRAGING_CARD = "PlayerVitaeShipsPage:ON_DRAGING_CARD"
var0.ON_DRAG_END_CARD = "PlayerVitaeShipsPage:ON_DRAG_END_CARD"

function var0.GetSlotIndexList()
	local var0, var1 = var0.GetSlotMaxCnt()
	local var2 = {}

	for iter0 = 1, var1 do
		table.insert(var2, iter0)
	end

	if var0.GetEducateCharSlotMaxCnt() > 0 then
		table.insert(var2, var0.EDUCATE_CHAR_SLOT_ID)
	end

	return var2
end

function var0.GetAllUnlockSlotCnt()
	local var0, var1 = var0.GetSlotMaxCnt()

	return var1 + var0.GetEducateCharSlotMaxCnt()
end

function var0.GetEducateCharSlotMaxCnt()
	if LOCK_EDUCATE_SYSTEM then
		return 0
	end

	if getProxy(PlayerProxy):getRawData():ExistEducateChar() or getProxy(EducateProxy):IsUnlockSecretary() then
		return 1
	else
		return 0
	end
end

function var0.GetSlotMaxCnt()
	local var0 = pg.gameset.secretary_group_unlock.description
	local var1 = var0[#var0][2]
	local var2 = 1

	for iter0, iter1 in ipairs(var0) do
		if getProxy(ChapterProxy):isClear(iter1[1]) then
			var2 = iter1[2]
		end
	end

	return var1, var2
end

function var0.getUIName(arg0)
	return "PlayerVitaeShipsPage"
end

function var0.UpdateCard(arg0, arg1)
	local var0 = arg0.cards[var1]

	for iter0, iter1 in ipairs(var0) do
		if isActive(iter1._tf) and iter1.displayShip and iter1.displayShip.id == arg1 then
			iter1:Refresh()

			break
		end
	end
end

function var0.UpdateCardPaintingTag(arg0)
	local var0 = arg0.cards[var1]

	for iter0, iter1 in ipairs(var0) do
		iter1:updatePaintingTag()
	end
end

function var0.RefreshShips(arg0)
	arg0:Update()
end

function var0.OnLoaded(arg0)
	arg0.cardContainer = arg0:findTF("frame")
	arg0.shipTpl = arg0:findTF("frame/shipCard")
	arg0.emptyTpl = arg0:findTF("frame/addCard")
	arg0.lockTpl = arg0:findTF("frame/lockCard")
	arg0.helpBtn = arg0:findTF("help_btn")
	arg0.settingBtn = arg0:findTF("setting_btn")
	arg0.settingBtnSlider = arg0:findTF("toggle/on", arg0.settingBtn)
	arg0.randomBtn = arg0:findTF("ran_setting_btn")
	arg0.randomBtnSlider = arg0:findTF("toggle/on", arg0.randomBtn)
	arg0.settingSeceneBtn = arg0:findTF("setting_scene_btn")
	arg0.nativeBtn = arg0:findTF("native_setting_btn")
	arg0.nativeBtnOn = arg0.nativeBtn:Find("on")
	arg0.nativeBtnOff = arg0.nativeBtn:Find("off")
	arg0.educateCharTr = arg0:findTF("educate_char")
	arg0.educateCharSettingList = UIItemList.New(arg0:findTF("educate_char/shipCard/settings/panel"), arg0:findTF("educate_char/shipCard/settings/panel/tpl"))
	arg0.educateCharSettingBtn = arg0:findTF("educate_char/shipCard/settings/tpl")
	arg0.educateCharTrTip = arg0.educateCharTr:Find("tip")

	if LOCK_EDUCATE_SYSTEM then
		setActive(arg0.educateCharTr, false)
		setAnchoredPosition(arg0.cardContainer, {
			x = 0
		})
		setAnchoredPosition(arg0:findTF("flagship"), {
			x = -720
		})
		setAnchoredPosition(arg0:findTF("zs"), {
			x = 763
		})
		setAnchoredPosition(arg0:findTF("line"), {
			x = 740
		})
	end

	arg0.educateCharCards = {
		[var1] = PlayerVitaeEducateShipCard.New(arg0:findTF("educate_char/shipCard"), arg0.event),
		[var2] = PlayerVitaeEducateAddCard.New(arg0:findTF("educate_char/addCard"), arg0.event),
		[var3] = PlayerVitaeEducateLockCard.New(arg0:findTF("educate_char/lockCard"), arg0.event)
	}
	arg0.tip = arg0:findTF("tip"):GetComponent(typeof(Text))
	arg0.flagShipMark = arg0:findTF("flagship")

	arg0:bind(var0.ON_BEGIN_DRAG_CARD, function(arg0, arg1)
		arg0:OnBeginDragCard(arg1)
	end)
	arg0:bind(var0.ON_DRAGING_CARD, function(arg0, arg1)
		arg0:OnDragingCard(arg1)
	end)
	arg0:bind(var0.ON_DRAG_END_CARD, function(arg0)
		arg0:OnEndDragCard()
	end)
	setText(arg0.nativeBtnOn:Find("Text"), i18n("random_ship_before"))
	setText(arg0.nativeBtnOff:Find("Text"), i18n("random_ship_now"))
	setText(arg0.settingBtn:Find("Text"), i18n("player_vitae_skin_setting"))
	setText(arg0.randomBtn:Find("Text"), i18n("random_ship_label"))
	setText(arg0.settingSeceneBtn:Find("Text"), i18n("playervtae_setting_btn_label"))

	arg0.cardContainerCG = GetOrAddComponent(arg0.cardContainer, typeof(CanvasGroup))
end

function var0.OnBeginDragCard(arg0, arg1)
	arg0.dragIndex = arg1
	arg0.displayCards = {}
	arg0.displayPos = {}

	local var0 = arg0.cards[var1]

	for iter0, iter1 in ipairs(var0) do
		if isActive(iter1._tf) then
			arg0.displayCards[iter0] = iter1
			arg0.displayPos[iter0] = iter1._tf.localPosition
		end
	end

	for iter2, iter3 in pairs(arg0.displayCards) do
		if iter2 ~= arg1 then
			iter3:DisableDrag()
		end
	end
end

function var0.OnDragingCard(arg0, arg1)
	local var0 = arg0.displayCards[arg0.dragIndex - 1]
	local var1 = arg0.displayCards[arg0.dragIndex + 1]

	if var0 and arg0:ShouldSwap(arg1, arg0.dragIndex - 1) then
		arg0:Swap(arg0.dragIndex, arg0.dragIndex - 1)
	elseif var1 and arg0:ShouldSwap(arg1, arg0.dragIndex + 1) then
		arg0:Swap(arg0.dragIndex, arg0.dragIndex + 1)
	end
end

function var0.Swap(arg0, arg1, arg2)
	local var0 = arg0.displayCards[arg1]
	local var1 = arg0.displayPos[arg1]
	local var2 = arg0.displayCards[arg2]

	var2._tf.localPosition = var1
	arg0.displayCards[arg1], arg0.displayCards[arg2] = arg0.displayCards[arg2], arg0.displayCards[arg1]
	arg0.dragIndex = arg2
	var0.slotIndex = arg2
	var2.slotIndex = arg1
	var0.typeIndex, var2.typeIndex = var2.typeIndex, var0.typeIndex

	local var3 = arg0.cards[var1]

	var3[arg1], var3[arg2] = var3[arg2], var3[arg1]
end

function var0.ShouldSwap(arg0, arg1, arg2)
	local var0 = arg0.displayPos[arg2]

	return math.abs(var0.x - arg1.x) <= 130
end

function var0.OnEndDragCard(arg0)
	local var0 = arg0.displayPos[arg0.dragIndex]

	arg0.displayCards[arg0.dragIndex]._tf.localPosition = var0

	local var1 = {}
	local var2 = getProxy(PlayerProxy):getRawData()
	local var3 = false

	for iter0, iter1 in pairs(arg0.displayCards) do
		iter1:EnableDrag()
		table.insert(var1, iter1.displayShip.id)

		if not var3 and var2.characters[#var1] ~= iter1.displayShip.id then
			var3 = true
		end
	end

	arg0.dragIndex = nil
	arg0.displayCards = nil
	arg0.displayPos = nil
	arg0.cardContainerCG.blocksRaycasts = false

	if var3 then
		arg0:emit(PlayerVitaeMediator.CHANGE_PAINTS, var1, function()
			Timer.New(function()
				if arg0.cardContainerCG then
					arg0.cardContainerCG.blocksRaycasts = true
				end
			end, 0.3, 1):Start()
		end)
	else
		arg0.cardContainerCG.blocksRaycasts = true
	end
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("secretary_help")
		})
	end, SFX_PANEL)

	local var0 = false

	local function var1()
		local var0 = {
			68,
			-68
		}

		setAnchoredPosition(arg0.settingBtnSlider, {
			x = var0[var0 and 1 or 2]
		})
	end

	onButton(arg0, arg0.settingBtn, function()
		var0 = not var0

		arg0:EditCards(var0)
		var1()
	end, SFX_PANEL)
	var1()

	local var2 = getProxy(SettingsProxy)

	arg0.randomFlag = var2:IsOpenRandomFlagShip()
	arg0.nativeFlag = false

	local function var3()
		local var0 = {
			68,
			-68
		}

		setAnchoredPosition(arg0.randomBtnSlider, {
			x = var0[arg0.randomFlag and 1 or 2]
		})
		setActive(arg0.nativeBtn, arg0.randomFlag)
		setActive(arg0.flagShipMark, not arg0.randomFlag or arg0.nativeFlag)

		if arg0.randomFlag and var0 then
			triggerButton(arg0.settingBtn)
		end
	end

	local function var4()
		setActive(arg0.nativeBtnOn, arg0.nativeFlag)
		setActive(arg0.nativeBtnOff, not arg0.nativeFlag)
		setActive(arg0.flagShipMark, not arg0.randomFlag or arg0.nativeFlag)

		if var0 then
			triggerButton(arg0.settingBtn)
		end
	end

	onButton(arg0, arg0.randomBtn, function()
		arg0.randomFlag = not arg0.randomFlag

		if arg0.randomFlag then
			local var0 = MainRandomFlagShipSequence.New():Random()

			if not var0 or #var0 <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_off_0"))

				arg0.randomFlag = not arg0.randomFlag

				return
			end

			var2:UpdateRandomFlagShipList(var0)
		else
			var2:UpdateRandomFlagShipList({})

			arg0.nativeFlag = false

			var4()
		end

		arg0:SwitchToPage(arg0.randomFlag and var5 or var4)
		var3()

		local var1 = arg0.randomFlag and i18n("random_ship_on") or i18n("random_ship_off")

		pg.TipsMgr.GetInstance():ShowTips(var1)
		arg0:emit(PlayerVitaeMediator.ON_SWITCH_RANDOM_FLAG_SHIP_BTN, arg0.randomFlag)
	end, SFX_PANEL)
	var3()
	onButton(arg0, arg0.nativeBtn, function()
		arg0.nativeFlag = not arg0.nativeFlag

		var4()
		arg0:SwitchToPage(arg0.nativeFlag and var4 or var5)
	end, SFX_PANEL)
	var4()
	onButton(arg0, arg0.educateCharSettingBtn, function()
		local var0 = isActive(arg0.educateCharSettingList.container)

		setActive(arg0.educateCharSettingList.container, not var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.settingSeceneBtn, function()
		arg0.contextData.showSelectCharacters = true

		arg0:emit(PlayerVitaeMediator.GO_SCENE, SCENE.SETTINGS, {
			page = NewSettingsScene.PAGE_OPTION,
			scroll = SettingsRandomFlagShipAndSkinPanel
		})
	end, SFX_PANEL)

	arg0.cards = {
		{},
		{},
		{}
	}

	table.insert(arg0.cards[var1], PlayerVitaeShipCard.New(arg0.shipTpl, arg0.event))
	table.insert(arg0.cards[var2], PlayerVitaeAddCard.New(arg0.emptyTpl, arg0.event))
	table.insert(arg0.cards[var3], PlayerVitaeLockCard.New(arg0.lockTpl, arg0.event))
end

function var0.Update(arg0)
	local var0 = getProxy(SettingsProxy)
	local var1

	if arg0.randomFlag and arg0.nativeFlag then
		var1 = var4
	else
		var1 = var0:IsOpenRandomFlagShip() and var5 or var4
	end

	arg0:SwitchToPage(var1)
	arg0:UpdateEducateChar()
	arg0:Show()
end

function var0.UpdateEducateChar(arg0)
	arg0:UpdateEducateCharSettings()
	arg0:UpdateEducateSlot()
	arg0:UpdateEducateCharTrTip()
end

function var0.UpdateEducateCharTrTip(arg0)
	setActive(arg0.educateCharTrTip, getProxy(SettingsProxy):ShouldEducateCharTip())
end

local function var6()
	if var0.GetEducateCharSlotMaxCnt() <= 0 then
		return var3
	end

	if getProxy(PlayerProxy):getRawData():ExistEducateChar() then
		return var1
	end

	return var2
end

function var0.UpdateEducateSlot(arg0)
	local var0 = var6()
	local var1

	for iter0, iter1 in pairs(arg0.educateCharCards) do
		local var2 = iter0 == var0

		iter1:ShowOrHide(var2)

		if var2 then
			var1 = iter1
		end
	end

	var1:Flush()
end

function var0.UpdateEducateCharSettings(arg0)
	local var0 = getProxy(SettingsProxy)

	local function var1()
		local var0 = var0:GetFlagShipDisplayMode()

		setText(arg0.educateCharSettingBtn:Find("Text"), i18n("flagship_display_mode_" .. var0))
	end

	local var2 = {
		FlAG_SHIP_DISPLAY_ONLY_SHIP,
		FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR,
		FlAG_SHIP_DISPLAY_ALL
	}

	arg0.educateCharSettingList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1 + 1]

			setText(arg2:Find("Text"), i18n("flagship_display_mode_" .. var0))
			onButton(arg0, arg2, function()
				var0:SetFlagShipDisplayMode(var0)
				var1()
				setActive(arg0.educateCharSettingList.container, false)
			end, SFX_PANEL)
			setActive(arg2:Find("line"), arg1 + 1 ~= #var2)
		end
	end)
	arg0.educateCharSettingList:align(#var2)
	var1()
end

function var0.SwitchToPage(arg0, arg1)
	local var0

	if arg1 == var5 then
		var0 = _.select(getProxy(SettingsProxy):GetRandomFlagShipList(), function(arg0)
			return getProxy(BayProxy):RawGetShipById(arg0) ~= nil
		end)
		arg0.tip.text = i18n("random_ship_tips1")

		arg0:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_RANDOM_SHIPS)
	elseif arg1 == var4 then
		var0 = getProxy(PlayerProxy):getRawData().characters
		arg0.tip.text = i18n("random_ship_tips2")

		arg0:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_NATIVE_SHIPS)
	end

	arg0:Flush(var0, arg1)
	setActive(arg0.tip.gameObject, arg0.randomFlag)
end

function var0.Flush(arg0, arg1, arg2)
	local var0, var1 = var0.GetSlotMaxCnt()

	arg0.max = var0
	arg0.unlockCnt = var1

	local var2 = arg0:GetUnlockShipCnt(arg1)

	arg0:UpdateCards(arg2, arg1, var2)
end

function var0.UpdateCards(arg0, arg1, arg2, arg3)
	local var0 = {
		0
	}
	local var1 = {}

	for iter0, iter1 in ipairs(arg3) do
		table.insert(var1, function(arg0)
			arg0:UpdateTypeCards(arg1, arg2, iter0, iter1, var0, arg0)
		end)
	end

	seriesAsync(var1)
end

function var0.UpdateTypeCards(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = {}
	local var1 = arg0.cards[arg3]

	local function var2(arg0)
		local var0 = var1[arg0]

		if not var0 then
			var0 = var1[1]:Clone()
			var1[arg0] = var0
		end

		arg5[1] = arg5[1] + 1

		var0:Enable()
		var0:Update(arg5[1], arg0, arg2, arg1, arg0.nativeFlag)
	end

	for iter0 = 1, arg4 do
		table.insert(var0, function(arg0)
			if arg0.exited then
				return
			end

			var2(iter0)
			onNextTick(arg0)
		end)
	end

	for iter1 = #var1, arg4 + 1, -1 do
		var1[iter1]:Disable()
	end

	seriesAsync(var0, arg6)
end

function var0.GetUnlockShipCnt(arg0, arg1)
	local var0 = 0
	local var1 = 0
	local var2 = 0
	local var3 = #arg1
	local var4 = arg0.unlockCnt - var3
	local var5 = arg0.max - arg0.unlockCnt

	return {
		var3,
		var4,
		var5
	}
end

function var0.EditCards(arg0, arg1)
	local var0 = {
		var1,
		var2
	}

	for iter0, iter1 in ipairs(var0) do
		local var1 = arg0.cards[iter1]

		for iter2, iter3 in ipairs(var1) do
			if isActive(iter3._tf) then
				iter3:EditCard(arg1)
			end
		end
	end

	arg0.IsOpenEdit = arg1
end

function var0.EditCardsForRandom(arg0, arg1)
	local var0 = {}
	local var1 = arg0.cards[var1]

	for iter0, iter1 in ipairs(var1) do
		if isActive(iter1._tf) then
			if not arg1 then
				var0[iter1.slotIndex] = iter1:GetRandomFlagValue()
			end

			iter1:EditCardForRandom(arg1)
		end
	end

	arg0.IsOpenEditForRandom = arg1

	if #var0 > 0 then
		arg0:SaveRandomSettings(var0)
	end

	local var2 = arg0.cards[var2]

	for iter2, iter3 in ipairs(var2) do
		if isActive(iter3._tf) then
			iter3:EditCard(arg1)
		end
	end
end

function var0.SaveRandomSettings(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData()

	for iter0 = 1, arg0.max do
		if not arg1[iter0] then
			arg1[iter0] = var0:RawGetRandomShipAndSkinValueInpos(iter0)
		end
	end

	arg0:emit(PlayerVitaeMediator.CHANGE_RANDOM_SETTING, arg1)
end

function var0.Show(arg0)
	var0.super.Show(arg0)

	Input.multiTouchEnabled = false
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)

	if arg0.IsOpenEdit then
		triggerButton(arg0.settingBtn)
	end

	if arg0.IsOpenEditForRandom then
		triggerButton(arg0.randomBtn)
	end

	Input.multiTouchEnabled = true

	arg0:emit(PlayerVitaeScene.ON_PAGE_SWTICH, PlayerVitaeScene.PAGE_DEFAULT)
end

function var0.OnDestroy(arg0)
	arg0:Hide()

	for iter0, iter1 in pairs(arg0.cards) do
		for iter2, iter3 in pairs(iter1) do
			iter3:Dispose()
		end
	end

	arg0.exited = true
end

return var0
