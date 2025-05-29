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

	arg0_2:Switch(var0_0.MODE_VIEW)
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
	arg0_3.phantomToggle = arg0_3._tf:Find("toggle_phantom")
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

	function arg0_5.scrollrect.onReturnItem(arg0_8, arg1_8)
		arg0_5:onReturnItem(arg0_8, arg1_8)
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
	onToggle(arg0_5, arg0_5.frequentlyUseToggle, function(arg0_15)
		arg0_5.frequentlyUseFlags[arg0_5.mode] = arg0_15

		local var0_15 = arg0_5:GetShipList(arg0_5.mode)

		arg0_5:FlushShipList(var0_15)
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.lockToggle, function(arg0_16)
		arg0_5.lockFlags[arg0_5.mode] = arg0_16

		local var0_16 = arg0_5:GetShipList(arg0_5.mode)

		arg0_5:FlushShipList(var0_16)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.sortBtn, function()
		arg0_5.sortFlags[arg0_5.mode] = not arg0_5.sortFlags[arg0_5.mode]

		setActive(arg0_5.sortUp, arg0_5.sortFlags[arg0_5.mode])
		setActive(arg0_5.sortDown, not arg0_5.sortFlags[arg0_5.mode])

		local var0_17 = arg0_5:GetShipList(arg0_5.mode)

		arg0_5:FlushShipList(var0_17)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.indexBtn, function()
		arg0_5:emit(RandomDockYardMediator.OPEN_INDEX, {
			OnFilter = function(arg0_19)
				arg0_5:OnFilter(arg0_19)
			end,
			defaultIndex = arg0_5.indexDatas[arg0_5.mode]
		})
	end, SFX_PANEL)
	setToggleEnabled(arg0_5.phantomToggle, false)
	onButton(arg0_5, arg0_5.phantomToggle:Find("off"), function()
		arg0_5:emit(RandomDockYardMediator.OPEN_PHANTOM_LAYER)
	end, SFX_PANEL)
	arg0_5:Switch(var0_0.MODE_VIEW)
end

function var0_0.GetRandomFlagShips(arg0_21)
	if not arg0_21.randomFlagShips then
		local var0_21 = getProxy(PlayerProxy):getRawData()

		arg0_21.randomFlagShips = {}
		arg0_21.phantomCount = 0

		local var1_21 = getProxy(BayProxy)

		for iter0_21, iter1_21 in ipairs(var1_21:getRandomFlagShipPhantomMarks()) do
			local var2_21 = var1_21:GetShipPhantom(iter1_21)

			if var2_21 then
				if var2_21.phantomId == 0 then
					table.insert(arg0_21.randomFlagShips, var2_21)
				else
					arg0_21.phantomCount = arg0_21.phantomCount + 1
				end
			end
		end
	end

	return arg0_21.randomFlagShips
end

function var0_0.GetDockYardShipAndNotInRandom(arg0_22)
	if not arg0_22.dockyardShips then
		local var0_22 = arg0_22:GetRandomFlagShips()
		local var1_22 = {}

		for iter0_22, iter1_22 in ipairs(var0_22) do
			var1_22[iter1_22.id] = true
		end

		arg0_22.dockyardShips = {}

		local var2_22 = getProxy(BayProxy):getRawData()

		for iter2_22, iter3_22 in pairs(var2_22) do
			if not var1_22[iter3_22.id] and not iter3_22:isActivityNpc() then
				table.insert(arg0_22.dockyardShips, iter3_22)
			end
		end
	end

	return arg0_22.dockyardShips
end

function var0_0.GetShipList(arg0_23, arg1_23)
	local var0_23 = {}

	if arg1_23 == var0_0.MODE_VIEW then
		var0_23 = arg0_23:GetRandomFlagShips()
	elseif arg1_23 == var0_0.MODE_ADD then
		var0_23 = arg0_23:GetDockYardShipAndNotInRandom()
	elseif arg1_23 == var0_0.MODE_REMOVE then
		var0_23 = arg0_23:GetRandomFlagShips()
	end

	return var0_23
end

function var0_0.Switch(arg0_24, arg1_24)
	arg0_24:Clear()

	arg0_24.selected = {}

	local var0_24 = arg0_24:GetShipList(arg1_24)

	arg0_24:UpdateModeStyle(arg1_24, #var0_24)

	arg0_24.mode = arg1_24

	arg0_24:FlushShipList(var0_24)

	if arg0_24.mode == var0_0.MODE_VIEW then
		arg0_24:UpdateSelectedCnt(#var0_24 + arg0_24.phantomCount)
	else
		arg0_24:UpdateSelectedCnt(table.getCount(arg0_24.selected))
	end

	setActive(arg0_24.phantomToggle, arg0_24.mode == var0_0.MODE_VIEW)
end

function var0_0.UpdateModeStyle(arg0_25, arg1_25, arg2_25)
	arg0_25.titleImg.sprite = arg0_25.titles[arg1_25]

	arg0_25.titleImg:SetNativeSize()

	arg0_25.titleEnImg.sprite = arg0_25.titleEns[arg1_25]

	arg0_25.titleEnImg:SetNativeSize()
	setActive(arg0_25.addBtn, arg1_25 == var0_0.MODE_VIEW)
	setActive(arg0_25.removeBtn, arg1_25 == var0_0.MODE_VIEW)
	setActive(arg0_25.cancelBtn, arg1_25 == var0_0.MODE_ADD or arg1_25 == var0_0.MODE_REMOVE)
	setActive(arg0_25.confirmBtn, arg1_25 == var0_0.MODE_ADD or arg1_25 == var0_0.MODE_REMOVE)
	setActive(arg0_25.allBtn, arg1_25 == var0_0.MODE_ADD or arg1_25 == var0_0.MODE_REMOVE)

	arg0_25.tipTxt.text = arg0_25.tips[arg1_25]
	arg0_25.selectedTxt.text = arg0_25.selectedTxts[arg1_25]

	setButtonEnabled(arg0_25.removeBtn, arg1_25 == var0_0.MODE_VIEW and arg2_25 > 0)
	setAnchoredPosition(arg0_25.selectPanelFrame, {
		x = arg1_25 == var0_0.MODE_VIEW and 0 or 180
	})
end

function var0_0.OnConfirm(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.selected) do
		table.insert(var0_26, iter0_26)
	end

	local function var1_26()
		if arg0_26.mode == var0_0.MODE_ADD then
			arg0_26:emit(RandomDockYardMediator.ON_ADD_SHIPS, var0_26)
		elseif arg0_26.mode == var0_0.MODE_REMOVE then
			arg0_26:emit(RandomDockYardMediator.ON_REMOVE_SHIPS, var0_26)
		end
	end

	local var2_26 = arg0_26.msgBoxTitle[arg0_26.mode]
	local var3_26 = arg0_26.msgBoxSubTitle[arg0_26.mode]

	arg0_26.msgbox:ExecuteAction("Flush", var2_26, var3_26, var0_26, var1_26)
end

function var0_0.OnAll(arg0_28)
	for iter0_28, iter1_28 in ipairs(arg0_28.displays) do
		arg0_28.selected[iter1_28.id] = true
	end

	arg0_28.scrollrect:SetTotalCount(#arg0_28.displays)
	arg0_28:UpdateSelectedCnt(table.getCount(arg0_28.selected))
end

function var0_0.UpdateSelectedCnt(arg0_29, arg1_29)
	arg0_29.selectedCntTxt.text = arg1_29

	setButtonEnabled(arg0_29.confirmBtn, arg1_29 > 0)
	setActive(arg0_29.confirmBtnMask, arg1_29 <= 0)
end

local function var1_0(arg0_30)
	return arg0_30.sortIndex ~= ShipIndexConst.SortLevel or arg0_30.typeIndex ~= ShipIndexConst.TypeAll or arg0_30.campIndex ~= ShipIndexConst.CampAll or arg0_30.rarityIndex ~= ShipIndexConst.RarityAll or arg0_30.extraIndex ~= ShipIndexConst.ExtraALL
end

function var0_0.OnFilter(arg0_31, arg1_31)
	local var0_31 = arg0_31.indexDatas[arg0_31.mode]

	var0_31.sortIndex = arg1_31.sortIndex
	var0_31.typeIndex = arg1_31.typeIndex
	var0_31.campIndex = arg1_31.campIndex
	var0_31.rarityIndex = arg1_31.rarityIndex
	var0_31.extraIndex = arg1_31.extraIndex

	setActive(arg0_31.indexBtnSel, var1_0(var0_31))

	local var1_31 = arg0_31:GetShipList(arg0_31.mode)

	arg0_31:FlushShipList(var1_31)
end

function var0_0.OnItemUpdate(arg0_32, arg1_32)
	local var0_32 = RandomDockYardCard.New(arg1_32)

	onButton(arg0_32, var0_32._go, function()
		if arg0_32.mode == var0_0.MODE_VIEW then
			return
		end

		if arg0_32.selected[var0_32.ship.id] then
			arg0_32.selected[var0_32.ship.id] = nil
		else
			arg0_32.selected[var0_32.ship.id] = true
		end

		arg0_32:UpdateSelectedCnt(table.getCount(arg0_32.selected))
		var0_32:UpdateSelected(arg0_32.selected[var0_32.ship.id])
	end, SFX_PANEL)

	arg0_32.cards[arg1_32] = var0_32
end

function var0_0.OnUpdateItem(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.cards[arg2_34]

	if not var0_34 then
		arg0_34:OnItemUpdate(arg2_34)

		var0_34 = arg0_34.cards[arg2_34]
	end

	local var1_34 = arg0_34.displays[arg1_34 + 1]
	local var2_34 = arg0_34.selected[var1_34.id]

	var0_34:Update(var1_34, var2_34)
end

function var0_0.onReturnItem(arg0_35, arg1_35, arg2_35)
	if arg0_35.exited then
		return
	end

	local var0_35 = arg0_35.cards[arg2_35]

	if var0_35 then
		var0_35:Dispose()
	end
end

function var0_0.FlushShipList(arg0_36, arg1_36)
	arg0_36.displays = {}

	arg0_36:FilterShips(arg1_36, arg0_36.displays)
	arg0_36:SortShips(arg0_36.displays)

	local var0_36 = #arg0_36.displays

	arg0_36.scrollrect:SetTotalCount(var0_36)
	setActive(arg0_36.emptyTr, var0_36 <= 0)
end

function var0_0.FilterShips(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37.lockFlags[arg0_37.mode]
	local var1_37 = arg0_37.frequentlyUseFlags[arg0_37.mode]
	local var2_37 = arg0_37.indexDatas[arg0_37.mode]

	local function var3_37(arg0_38)
		local var0_38 = not var0_37 or not not arg0_38:IsLocked()
		local var1_38 = not var1_37 or not not arg0_38:IsPreferenceTag()
		local var2_38 = ShipIndexConst.filterByType(arg0_38, var2_37.typeIndex)
		local var3_38 = ShipIndexConst.filterByCamp(arg0_38, var2_37.campIndex)
		local var4_38 = ShipIndexConst.filterByRarity(arg0_38, var2_37.rarityIndex)
		local var5_38 = ShipIndexConst.filterByExtra(arg0_38, var2_37.extraIndex)

		return var0_38 and var1_38 and var2_38 and var3_38 and var4_38 and var5_38
	end

	for iter0_37, iter1_37 in ipairs(arg1_37) do
		if var3_37(iter1_37) then
			table.insert(arg2_37, iter1_37)
		end
	end
end

function var0_0.SortShips(arg0_39, arg1_39)
	local var0_39 = arg0_39.indexDatas[arg0_39.mode]
	local var1_39 = arg0_39.sortFlags[arg0_39.mode]
	local var2_39 = var0_39.sortIndex
	local var3_39, var4_39 = ShipIndexConst.getSortFuncAndName(var2_39, var1_39)

	table.insert(var3_39, 1, function(arg0_40)
		return -arg0_40.activityNpc
	end)
	table.sort(arg1_39, CompareFuncs(var3_39))

	arg0_39.sortTxt.text = i18n(var4_39)
end

function var0_0.onBackPressed(arg0_41)
	var0_0.super.onBackPressed(arg0_41)
end

function var0_0.Clear(arg0_42)
	for iter0_42, iter1_42 in pairs(arg0_42.cards) do
		iter1_42:Dispose()
	end

	arg0_42.cards = {}
end

function var0_0.willExit(arg0_43)
	arg0_43.titles = nil

	if arg0_43.msgbox then
		arg0_43.msgbox:Destroy()
	end

	arg0_43.msgbox = nil
end

return var0_0
