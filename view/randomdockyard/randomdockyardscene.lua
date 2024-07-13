local var0_0 = class("RandomDockYardScene", import("view.base.BaseUI"))

var0_0.MODE_VIEW = 1
var0_0.MODE_ADD = 2
var0_0.MODE_REMOVE = 3

function var0_0.getUIName(arg0_1)
	return "RandomDockYardUI"
end

function var0_0.OnChangeRandomShips(arg0_2)
	arg0_2.randomFlagShips = nil
	arg0_2.dockyardShips = nil

	if arg0_2.mode ~= var0_0.MODE_VIEW then
		arg0_2:Switch(var0_0.MODE_VIEW)
	end
end

function var0_0.init(arg0_3)
	arg0_3.titleImg = arg0_3:findTF("blur_panel/adapt/top/title"):GetComponent(typeof(Image))
	arg0_3.titleEnImg = arg0_3:findTF("blur_panel/adapt/top/title/title_en"):GetComponent(typeof(Image))
	arg0_3.scrollrect = arg0_3:findTF("main/ship_container/ships"):GetComponent("LScrollRect")
	arg0_3.emptyTr = arg0_3:findTF("empty")
	arg0_3.backBtn = arg0_3:findTF("blur_panel/adapt/top/back")
	arg0_3.addBtn = arg0_3:findTF("blur_panel/select_panel/add_button")
	arg0_3.removeBtn = arg0_3:findTF("blur_panel/select_panel/remove_button")
	arg0_3.cancelBtn = arg0_3:findTF("blur_panel/select_panel/cancel_button")
	arg0_3.confirmBtn = arg0_3:findTF("blur_panel/select_panel/confirm_button")
	arg0_3.confirmBtnMask = arg0_3.confirmBtn:Find("mask")
	arg0_3.allBtn = arg0_3:findTF("blur_panel/select_panel/all_button")
	arg0_3.tipTxt = arg0_3:findTF("blur_panel/select_panel/tip"):GetComponent(typeof(Text))
	arg0_3.selectedTxt = arg0_3:findTF("blur_panel/select_panel/bottom_info/bg_input/selected"):GetComponent(typeof(Text))
	arg0_3.frequentlyUseToggle = arg0_3:findTF("blur_panel/adapt/top/preference_toggle")
	arg0_3.lockToggle = arg0_3:findTF("blur_panel/adapt/top/lock_toggle")
	arg0_3.sortBtn = arg0_3:findTF("blur_panel/adapt/top/sort_button")
	arg0_3.sortTxt = arg0_3.sortBtn:Find("Image"):GetComponent(typeof(Text))
	arg0_3.sortUp = arg0_3.sortBtn:Find("asc")
	arg0_3.sortDown = arg0_3.sortBtn:Find("desc")
	arg0_3.indexBtn = arg0_3:findTF("blur_panel/adapt/top/index_button")
	arg0_3.indexBtnSel = arg0_3.indexBtn:Find("Image")
	arg0_3.selectedCntTxt = arg0_3:findTF("blur_panel/select_panel/bottom_info/bg_input/count"):GetComponent(typeof(Text))
	arg0_3.selectPanelFrame = arg0_3:findTF("blur_panel/select_panel/bottom_info/bg_input")

	setActive(arg0_3.sortUp, false)
	setActive(arg0_3.sortDown, true)
	setText(arg0_3.emptyTr:Find("Text"), i18n("random_ship_custom_mode_main_empty"))
	setText(arg0_3.addBtn:Find("Text"), i18n("random_ship_custom_mode_main_button_add"))
	setText(arg0_3.removeBtn:Find("Text"), i18n("random_ship_custom_mode_main_button_remove"))
	setText(arg0_3.cancelBtn:Find("Text"), i18n("text_cancel"))
	setText(arg0_3.confirmBtn:Find("Text"), i18n("text_confirm"))
	setText(arg0_3.allBtn:Find("Text"), i18n("random_ship_custom_mode_select_all"))

	arg0_3.msgbox = RandomDockYardMsgBoxPgae.New(arg0_3._tf, arg0_3.event)

	arg0_3:InitDefault()
end

function var0_0.InitDefault(arg0_4)
	arg0_4.selected = {}
	arg0_4.titles = {
		[var0_0.MODE_VIEW] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_random_ship"),
		[var0_0.MODE_ADD] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_add_random_ship"),
		[var0_0.MODE_REMOVE] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_remove_random_ship")
	}
	arg0_4.titleEns = {
		[var0_0.MODE_VIEW] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_rd_en"),
		[var0_0.MODE_ADD] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_add_en"),
		[var0_0.MODE_REMOVE] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_remove_en")
	}
	arg0_4.msgBoxTitle = {
		[var0_0.MODE_VIEW] = {
			cn = "",
			en = ""
		},
		[var0_0.MODE_ADD] = {
			en = "ADD",
			cn = i18n("random_ship_custom_mode_add_title")
		},
		[var0_0.MODE_REMOVE] = {
			en = "REMOVE",
			cn = i18n("random_ship_custom_mode_remove_title")
		}
	}
	arg0_4.msgBoxSubTitle = {
		[var0_0.MODE_VIEW] = "",
		[var0_0.MODE_ADD] = i18n("random_ship_custom_mode_add_tip2"),
		[var0_0.MODE_REMOVE] = i18n("random_ship_custom_mode_remove_tip2")
	}
	arg0_4.tips = {
		[var0_0.MODE_VIEW] = i18n("random_ship_custom_mode_main_tip1"),
		[var0_0.MODE_ADD] = i18n("random_ship_custom_mode_add_tip1"),
		[var0_0.MODE_REMOVE] = i18n("random_ship_custom_mode_remove_tip1")
	}
	arg0_4.selectedTxts = {
		[var0_0.MODE_VIEW] = i18n("random_ship_custom_mode_main_tip2"),
		[var0_0.MODE_ADD] = i18n("random_ship_custom_mode_select_number"),
		[var0_0.MODE_REMOVE] = i18n("random_ship_custom_mode_select_number")
	}
	arg0_4.frequentlyUseFlags = {
		[var0_0.MODE_VIEW] = false,
		[var0_0.MODE_ADD] = false,
		[var0_0.MODE_REMOVE] = false
	}
	arg0_4.lockFlags = {
		[var0_0.MODE_VIEW] = false,
		[var0_0.MODE_ADD] = false,
		[var0_0.MODE_REMOVE] = false
	}
	arg0_4.sortFlags = {
		[var0_0.MODE_VIEW] = false,
		[var0_0.MODE_ADD] = false,
		[var0_0.MODE_REMOVE] = false
	}
	arg0_4.indexDatas = {
		[var0_0.MODE_VIEW] = {
			sortIndex = ShipIndexConst.SortLevel,
			typeIndex = ShipIndexConst.TypeAll,
			campIndex = ShipIndexConst.CampAll,
			rarityIndex = ShipIndexConst.RarityAll,
			extraIndex = ShipIndexConst.ExtraALL
		},
		[var0_0.MODE_ADD] = {
			sortIndex = ShipIndexConst.SortLevel,
			typeIndex = ShipIndexConst.TypeAll,
			campIndex = ShipIndexConst.CampAll,
			rarityIndex = ShipIndexConst.RarityAll,
			extraIndex = ShipIndexConst.ExtraALL
		},
		[var0_0.MODE_REMOVE] = {
			sortIndex = ShipIndexConst.SortLevel,
			typeIndex = ShipIndexConst.TypeAll,
			campIndex = ShipIndexConst.CampAll,
			rarityIndex = ShipIndexConst.RarityAll,
			extraIndex = ShipIndexConst.ExtraALL
		}
	}
end

function var0_0.didEnter(arg0_5)
	arg0_5.cards = {}

	function arg0_5.scrollrect.onInitItem(arg0_6)
		arg0_5:OnItemUpdate(arg0_6)
	end

	function arg0_5.scrollrect.onUpdateItem(arg0_7, arg1_7)
		arg0_5:OnUpdateItem(arg0_7, arg1_7)
	end

	onButton(arg0_5, arg0_5.backBtn, function()
		if arg0_5.mode ~= var0_0.MODE_VIEW then
			arg0_5:Switch(var0_0.MODE_VIEW)

			return
		end

		arg0_5:emit(var0_0.ON_RETURN, {
			page = NewSettingsScene.PAGE_OPTION,
			scroll = SettingsRandomFlagShipAndSkinPanel
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.addBtn, function()
		arg0_5:Switch(var0_0.MODE_ADD)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.removeBtn, function()
		arg0_5:Switch(var0_0.MODE_REMOVE)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.cancelBtn, function()
		if arg0_5.mode == var0_0.MODE_VIEW then
			return
		end

		arg0_5:Switch(var0_0.MODE_VIEW)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.confirmBtn, function()
		if arg0_5.mode == var0_0.MODE_VIEW then
			return
		end

		arg0_5:OnConfirm()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.allBtn, function()
		if arg0_5.mode == var0_0.MODE_VIEW then
			return
		end

		arg0_5:OnAll()
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.frequentlyUseToggle, function(arg0_14)
		arg0_5.frequentlyUseFlags[arg0_5.mode] = arg0_14

		local var0_14 = arg0_5:GetShipList(arg0_5.mode)

		arg0_5:FlushShipList(var0_14)
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.lockToggle, function(arg0_15)
		arg0_5.lockFlags[arg0_5.mode] = arg0_15

		local var0_15 = arg0_5:GetShipList(arg0_5.mode)

		arg0_5:FlushShipList(var0_15)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.sortBtn, function()
		arg0_5.sortFlags[arg0_5.mode] = not arg0_5.sortFlags[arg0_5.mode]

		setActive(arg0_5.sortUp, arg0_5.sortFlags[arg0_5.mode])
		setActive(arg0_5.sortDown, not arg0_5.sortFlags[arg0_5.mode])

		local var0_16 = arg0_5:GetShipList(arg0_5.mode)

		arg0_5:FlushShipList(var0_16)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.indexBtn, function()
		arg0_5:emit(RandomDockYardMediator.OPEN_INDEX, {
			OnFilter = function(arg0_18)
				arg0_5:OnFilter(arg0_18)
			end,
			defaultIndex = arg0_5.indexDatas[arg0_5.mode]
		})
	end, SFX_PANEL)
	arg0_5:Switch(var0_0.MODE_VIEW)
end

function var0_0.GetRandomFlagShips(arg0_19)
	if not arg0_19.randomFlagShips then
		local var0_19 = getProxy(PlayerProxy):getRawData()

		arg0_19.randomFlagShips = {}

		local var1_19 = getProxy(BayProxy)

		for iter0_19, iter1_19 in ipairs(var0_19:GetCustomRandomShipList()) do
			local var2_19 = var1_19:RawGetShipById(iter1_19)

			if var2_19 then
				table.insert(arg0_19.randomFlagShips, var2_19)
			end
		end
	end

	return arg0_19.randomFlagShips
end

function var0_0.GetDockYardShipAndNotInRandom(arg0_20)
	if not arg0_20.dockyardShips then
		local var0_20 = arg0_20:GetRandomFlagShips()
		local var1_20 = {}

		for iter0_20, iter1_20 in ipairs(var0_20) do
			var1_20[iter1_20.id] = true
		end

		arg0_20.dockyardShips = {}

		local var2_20 = getProxy(BayProxy):getRawData()

		for iter2_20, iter3_20 in pairs(var2_20) do
			if not var1_20[iter3_20.id] and not iter3_20:isActivityNpc() then
				table.insert(arg0_20.dockyardShips, iter3_20)
			end
		end
	end

	return arg0_20.dockyardShips
end

function var0_0.GetShipList(arg0_21, arg1_21)
	local var0_21 = {}

	if arg1_21 == var0_0.MODE_VIEW then
		var0_21 = arg0_21:GetRandomFlagShips()
	elseif arg1_21 == var0_0.MODE_ADD then
		var0_21 = arg0_21:GetDockYardShipAndNotInRandom()
	elseif arg1_21 == var0_0.MODE_REMOVE then
		var0_21 = arg0_21:GetRandomFlagShips()
	end

	return var0_21
end

function var0_0.Switch(arg0_22, arg1_22)
	arg0_22:Clear()

	arg0_22.selected = {}

	local var0_22 = arg0_22:GetShipList(arg1_22)

	arg0_22:UpdateModeStyle(arg1_22, #var0_22)

	arg0_22.mode = arg1_22

	arg0_22:FlushShipList(var0_22)

	if arg0_22.mode == var0_0.MODE_VIEW then
		arg0_22:UpdateSelectedCnt(var0_22)
	else
		arg0_22:UpdateSelectedCnt(arg0_22.selected)
	end
end

function var0_0.UpdateModeStyle(arg0_23, arg1_23, arg2_23)
	arg0_23.titleImg.sprite = arg0_23.titles[arg1_23]

	arg0_23.titleImg:SetNativeSize()

	arg0_23.titleEnImg.sprite = arg0_23.titleEns[arg1_23]

	arg0_23.titleEnImg:SetNativeSize()
	setActive(arg0_23.addBtn, arg1_23 == var0_0.MODE_VIEW)
	setActive(arg0_23.removeBtn, arg1_23 == var0_0.MODE_VIEW)
	setActive(arg0_23.cancelBtn, arg1_23 == var0_0.MODE_ADD or arg1_23 == var0_0.MODE_REMOVE)
	setActive(arg0_23.confirmBtn, arg1_23 == var0_0.MODE_ADD or arg1_23 == var0_0.MODE_REMOVE)
	setActive(arg0_23.allBtn, arg1_23 == var0_0.MODE_ADD or arg1_23 == var0_0.MODE_REMOVE)

	arg0_23.tipTxt.text = arg0_23.tips[arg1_23]
	arg0_23.selectedTxt.text = arg0_23.selectedTxts[arg1_23]

	setButtonEnabled(arg0_23.removeBtn, arg1_23 == var0_0.MODE_VIEW and arg2_23 > 0)
	setAnchoredPosition(arg0_23.selectPanelFrame, {
		x = arg1_23 == var0_0.MODE_VIEW and 0 or 180
	})
end

function var0_0.OnConfirm(arg0_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.selected) do
		table.insert(var0_24, iter0_24)
	end

	local function var1_24()
		if arg0_24.mode == var0_0.MODE_ADD then
			arg0_24:emit(RandomDockYardMediator.ON_ADD_SHIPS, var0_24)
		elseif arg0_24.mode == var0_0.MODE_REMOVE then
			arg0_24:emit(RandomDockYardMediator.ON_REMOVE_SHIPS, var0_24)
		end
	end

	local var2_24 = arg0_24.msgBoxTitle[arg0_24.mode]
	local var3_24 = arg0_24.msgBoxSubTitle[arg0_24.mode]

	arg0_24.msgbox:ExecuteAction("Flush", var2_24, var3_24, var0_24, var1_24)
end

function var0_0.OnAll(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.displays) do
		arg0_26.selected[iter1_26.id] = true
	end

	arg0_26.scrollrect:SetTotalCount(#arg0_26.displays)
	arg0_26:UpdateSelectedCnt(arg0_26.selected)
end

function var0_0.UpdateSelectedCnt(arg0_27, arg1_27)
	local var0_27 = 0

	for iter0_27, iter1_27 in pairs(arg1_27) do
		var0_27 = var0_27 + 1
	end

	arg0_27.selectedCntTxt.text = var0_27

	setButtonEnabled(arg0_27.confirmBtn, var0_27 > 0)
	setActive(arg0_27.confirmBtnMask, var0_27 <= 0)
end

local function var1_0(arg0_28)
	return arg0_28.sortIndex ~= ShipIndexConst.SortLevel or arg0_28.typeIndex ~= ShipIndexConst.TypeAll or arg0_28.campIndex ~= ShipIndexConst.CampAll or arg0_28.rarityIndex ~= ShipIndexConst.RarityAll or arg0_28.extraIndex ~= ShipIndexConst.ExtraALL
end

function var0_0.OnFilter(arg0_29, arg1_29)
	local var0_29 = arg0_29.indexDatas[arg0_29.mode]

	var0_29.sortIndex = arg1_29.sortIndex
	var0_29.typeIndex = arg1_29.typeIndex
	var0_29.campIndex = arg1_29.campIndex
	var0_29.rarityIndex = arg1_29.rarityIndex
	var0_29.extraIndex = arg1_29.extraIndex

	setActive(arg0_29.indexBtnSel, var1_0(var0_29))

	local var1_29 = arg0_29:GetShipList(arg0_29.mode)

	arg0_29:FlushShipList(var1_29)
end

function var0_0.OnItemUpdate(arg0_30, arg1_30)
	local var0_30 = RandomDockYardCard.New(arg1_30)

	onButton(arg0_30, var0_30._go, function()
		if arg0_30.mode == var0_0.MODE_VIEW then
			return
		end

		if arg0_30.selected[var0_30.ship.id] then
			arg0_30.selected[var0_30.ship.id] = nil
		else
			arg0_30.selected[var0_30.ship.id] = true
		end

		arg0_30:UpdateSelectedCnt(arg0_30.selected)
		var0_30:UpdateSelected(arg0_30.selected[var0_30.ship.id])
	end, SFX_PANEL)

	arg0_30.cards[arg1_30] = var0_30
end

function var0_0.OnUpdateItem(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32.cards[arg2_32]

	if not var0_32 then
		arg0_32:OnItemUpdate(arg2_32)

		var0_32 = arg0_32.cards[arg2_32]
	end

	local var1_32 = arg0_32.displays[arg1_32 + 1]
	local var2_32 = arg0_32.selected[var1_32.id]

	var0_32:Update(var1_32, var2_32)
end

function var0_0.FlushShipList(arg0_33, arg1_33)
	arg0_33.displays = {}

	arg0_33:FilterShips(arg1_33, arg0_33.displays)
	arg0_33:SortShips(arg0_33.displays)

	local var0_33 = #arg0_33.displays

	arg0_33.scrollrect:SetTotalCount(var0_33)
	setActive(arg0_33.emptyTr, var0_33 <= 0)
end

function var0_0.FilterShips(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.lockFlags[arg0_34.mode]
	local var1_34 = arg0_34.frequentlyUseFlags[arg0_34.mode]
	local var2_34 = arg0_34.indexDatas[arg0_34.mode]

	local function var3_34(arg0_35)
		local var0_35 = not var0_34 or not not arg0_35:IsLocked()
		local var1_35 = not var1_34 or not not arg0_35:IsPreferenceTag()
		local var2_35 = ShipIndexConst.filterByType(arg0_35, var2_34.typeIndex)
		local var3_35 = ShipIndexConst.filterByCamp(arg0_35, var2_34.campIndex)
		local var4_35 = ShipIndexConst.filterByRarity(arg0_35, var2_34.rarityIndex)
		local var5_35 = ShipIndexConst.filterByExtra(arg0_35, var2_34.extraIndex)

		return var0_35 and var1_35 and var2_35 and var3_35 and var4_35 and var5_35
	end

	for iter0_34, iter1_34 in ipairs(arg1_34) do
		if var3_34(iter1_34) then
			table.insert(arg2_34, iter1_34)
		end
	end
end

function var0_0.SortShips(arg0_36, arg1_36)
	local var0_36 = arg0_36.indexDatas[arg0_36.mode]
	local var1_36 = arg0_36.sortFlags[arg0_36.mode]
	local var2_36 = var0_36.sortIndex
	local var3_36, var4_36 = ShipIndexConst.getSortFuncAndName(var2_36, var1_36)

	table.insert(var3_36, 1, function(arg0_37)
		return -arg0_37.activityNpc
	end)
	table.sort(arg1_36, CompareFuncs(var3_36))

	arg0_36.sortTxt.text = i18n(var4_36)
end

function var0_0.onBackPressed(arg0_38)
	var0_0.super.onBackPressed(arg0_38)
end

function var0_0.Clear(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.cards) do
		iter1_39:Dispose()
	end

	arg0_39.cards = {}
end

function var0_0.willExit(arg0_40)
	arg0_40.titles = nil

	if arg0_40.msgbox then
		arg0_40.msgbox:Destroy()
	end

	arg0_40.msgbox = nil
end

return var0_0
