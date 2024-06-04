local var0 = class("RandomDockYardScene", import("view.base.BaseUI"))

var0.MODE_VIEW = 1
var0.MODE_ADD = 2
var0.MODE_REMOVE = 3

function var0.getUIName(arg0)
	return "RandomDockYardUI"
end

function var0.OnChangeRandomShips(arg0)
	arg0.randomFlagShips = nil
	arg0.dockyardShips = nil

	if arg0.mode ~= var0.MODE_VIEW then
		arg0:Switch(var0.MODE_VIEW)
	end
end

function var0.init(arg0)
	arg0.titleImg = arg0:findTF("blur_panel/adapt/top/title"):GetComponent(typeof(Image))
	arg0.titleEnImg = arg0:findTF("blur_panel/adapt/top/title/title_en"):GetComponent(typeof(Image))
	arg0.scrollrect = arg0:findTF("main/ship_container/ships"):GetComponent("LScrollRect")
	arg0.emptyTr = arg0:findTF("empty")
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back")
	arg0.addBtn = arg0:findTF("blur_panel/select_panel/add_button")
	arg0.removeBtn = arg0:findTF("blur_panel/select_panel/remove_button")
	arg0.cancelBtn = arg0:findTF("blur_panel/select_panel/cancel_button")
	arg0.confirmBtn = arg0:findTF("blur_panel/select_panel/confirm_button")
	arg0.confirmBtnMask = arg0.confirmBtn:Find("mask")
	arg0.allBtn = arg0:findTF("blur_panel/select_panel/all_button")
	arg0.tipTxt = arg0:findTF("blur_panel/select_panel/tip"):GetComponent(typeof(Text))
	arg0.selectedTxt = arg0:findTF("blur_panel/select_panel/bottom_info/bg_input/selected"):GetComponent(typeof(Text))
	arg0.frequentlyUseToggle = arg0:findTF("blur_panel/adapt/top/preference_toggle")
	arg0.lockToggle = arg0:findTF("blur_panel/adapt/top/lock_toggle")
	arg0.sortBtn = arg0:findTF("blur_panel/adapt/top/sort_button")
	arg0.sortTxt = arg0.sortBtn:Find("Image"):GetComponent(typeof(Text))
	arg0.sortUp = arg0.sortBtn:Find("asc")
	arg0.sortDown = arg0.sortBtn:Find("desc")
	arg0.indexBtn = arg0:findTF("blur_panel/adapt/top/index_button")
	arg0.indexBtnSel = arg0.indexBtn:Find("Image")
	arg0.selectedCntTxt = arg0:findTF("blur_panel/select_panel/bottom_info/bg_input/count"):GetComponent(typeof(Text))
	arg0.selectPanelFrame = arg0:findTF("blur_panel/select_panel/bottom_info/bg_input")

	setActive(arg0.sortUp, false)
	setActive(arg0.sortDown, true)
	setText(arg0.emptyTr:Find("Text"), i18n("random_ship_custom_mode_main_empty"))
	setText(arg0.addBtn:Find("Text"), i18n("random_ship_custom_mode_main_button_add"))
	setText(arg0.removeBtn:Find("Text"), i18n("random_ship_custom_mode_main_button_remove"))
	setText(arg0.cancelBtn:Find("Text"), i18n("text_cancel"))
	setText(arg0.confirmBtn:Find("Text"), i18n("text_confirm"))
	setText(arg0.allBtn:Find("Text"), i18n("random_ship_custom_mode_select_all"))

	arg0.msgbox = RandomDockYardMsgBoxPgae.New(arg0._tf, arg0.event)

	arg0:InitDefault()
end

function var0.InitDefault(arg0)
	arg0.selected = {}
	arg0.titles = {
		[var0.MODE_VIEW] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_random_ship"),
		[var0.MODE_ADD] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_add_random_ship"),
		[var0.MODE_REMOVE] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_remove_random_ship")
	}
	arg0.titleEns = {
		[var0.MODE_VIEW] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_rd_en"),
		[var0.MODE_ADD] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_add_en"),
		[var0.MODE_REMOVE] = GetSpriteFromAtlas("ui/dockyardui_atlas", "title_remove_en")
	}
	arg0.msgBoxTitle = {
		[var0.MODE_VIEW] = {
			cn = "",
			en = ""
		},
		[var0.MODE_ADD] = {
			en = "ADD",
			cn = i18n("random_ship_custom_mode_add_title")
		},
		[var0.MODE_REMOVE] = {
			en = "REMOVE",
			cn = i18n("random_ship_custom_mode_remove_title")
		}
	}
	arg0.msgBoxSubTitle = {
		[var0.MODE_VIEW] = "",
		[var0.MODE_ADD] = i18n("random_ship_custom_mode_add_tip2"),
		[var0.MODE_REMOVE] = i18n("random_ship_custom_mode_remove_tip2")
	}
	arg0.tips = {
		[var0.MODE_VIEW] = i18n("random_ship_custom_mode_main_tip1"),
		[var0.MODE_ADD] = i18n("random_ship_custom_mode_add_tip1"),
		[var0.MODE_REMOVE] = i18n("random_ship_custom_mode_remove_tip1")
	}
	arg0.selectedTxts = {
		[var0.MODE_VIEW] = i18n("random_ship_custom_mode_main_tip2"),
		[var0.MODE_ADD] = i18n("random_ship_custom_mode_select_number"),
		[var0.MODE_REMOVE] = i18n("random_ship_custom_mode_select_number")
	}
	arg0.frequentlyUseFlags = {
		[var0.MODE_VIEW] = false,
		[var0.MODE_ADD] = false,
		[var0.MODE_REMOVE] = false
	}
	arg0.lockFlags = {
		[var0.MODE_VIEW] = false,
		[var0.MODE_ADD] = false,
		[var0.MODE_REMOVE] = false
	}
	arg0.sortFlags = {
		[var0.MODE_VIEW] = false,
		[var0.MODE_ADD] = false,
		[var0.MODE_REMOVE] = false
	}
	arg0.indexDatas = {
		[var0.MODE_VIEW] = {
			sortIndex = ShipIndexConst.SortLevel,
			typeIndex = ShipIndexConst.TypeAll,
			campIndex = ShipIndexConst.CampAll,
			rarityIndex = ShipIndexConst.RarityAll,
			extraIndex = ShipIndexConst.ExtraALL
		},
		[var0.MODE_ADD] = {
			sortIndex = ShipIndexConst.SortLevel,
			typeIndex = ShipIndexConst.TypeAll,
			campIndex = ShipIndexConst.CampAll,
			rarityIndex = ShipIndexConst.RarityAll,
			extraIndex = ShipIndexConst.ExtraALL
		},
		[var0.MODE_REMOVE] = {
			sortIndex = ShipIndexConst.SortLevel,
			typeIndex = ShipIndexConst.TypeAll,
			campIndex = ShipIndexConst.CampAll,
			rarityIndex = ShipIndexConst.RarityAll,
			extraIndex = ShipIndexConst.ExtraALL
		}
	}
end

function var0.didEnter(arg0)
	arg0.cards = {}

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnItemUpdate(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	onButton(arg0, arg0.backBtn, function()
		if arg0.mode ~= var0.MODE_VIEW then
			arg0:Switch(var0.MODE_VIEW)

			return
		end

		arg0:emit(var0.ON_RETURN, {
			page = NewSettingsScene.PAGE_OPTION,
			scroll = SettingsRandomFlagShipAndSkinPanel
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.addBtn, function()
		arg0:Switch(var0.MODE_ADD)
	end, SFX_PANEL)
	onButton(arg0, arg0.removeBtn, function()
		arg0:Switch(var0.MODE_REMOVE)
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		if arg0.mode == var0.MODE_VIEW then
			return
		end

		arg0:Switch(var0.MODE_VIEW)
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.mode == var0.MODE_VIEW then
			return
		end

		arg0:OnConfirm()
	end, SFX_PANEL)
	onButton(arg0, arg0.allBtn, function()
		if arg0.mode == var0.MODE_VIEW then
			return
		end

		arg0:OnAll()
	end, SFX_PANEL)
	onToggle(arg0, arg0.frequentlyUseToggle, function(arg0)
		arg0.frequentlyUseFlags[arg0.mode] = arg0

		local var0 = arg0:GetShipList(arg0.mode)

		arg0:FlushShipList(var0)
	end, SFX_PANEL)
	onToggle(arg0, arg0.lockToggle, function(arg0)
		arg0.lockFlags[arg0.mode] = arg0

		local var0 = arg0:GetShipList(arg0.mode)

		arg0:FlushShipList(var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.sortBtn, function()
		arg0.sortFlags[arg0.mode] = not arg0.sortFlags[arg0.mode]

		setActive(arg0.sortUp, arg0.sortFlags[arg0.mode])
		setActive(arg0.sortDown, not arg0.sortFlags[arg0.mode])

		local var0 = arg0:GetShipList(arg0.mode)

		arg0:FlushShipList(var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.indexBtn, function()
		arg0:emit(RandomDockYardMediator.OPEN_INDEX, {
			OnFilter = function(arg0)
				arg0:OnFilter(arg0)
			end,
			defaultIndex = arg0.indexDatas[arg0.mode]
		})
	end, SFX_PANEL)
	arg0:Switch(var0.MODE_VIEW)
end

function var0.GetRandomFlagShips(arg0)
	if not arg0.randomFlagShips then
		local var0 = getProxy(PlayerProxy):getRawData()

		arg0.randomFlagShips = {}

		local var1 = getProxy(BayProxy)

		for iter0, iter1 in ipairs(var0:GetCustomRandomShipList()) do
			local var2 = var1:RawGetShipById(iter1)

			if var2 then
				table.insert(arg0.randomFlagShips, var2)
			end
		end
	end

	return arg0.randomFlagShips
end

function var0.GetDockYardShipAndNotInRandom(arg0)
	if not arg0.dockyardShips then
		local var0 = arg0:GetRandomFlagShips()
		local var1 = {}

		for iter0, iter1 in ipairs(var0) do
			var1[iter1.id] = true
		end

		arg0.dockyardShips = {}

		local var2 = getProxy(BayProxy):getRawData()

		for iter2, iter3 in pairs(var2) do
			if not var1[iter3.id] and not iter3:isActivityNpc() then
				table.insert(arg0.dockyardShips, iter3)
			end
		end
	end

	return arg0.dockyardShips
end

function var0.GetShipList(arg0, arg1)
	local var0 = {}

	if arg1 == var0.MODE_VIEW then
		var0 = arg0:GetRandomFlagShips()
	elseif arg1 == var0.MODE_ADD then
		var0 = arg0:GetDockYardShipAndNotInRandom()
	elseif arg1 == var0.MODE_REMOVE then
		var0 = arg0:GetRandomFlagShips()
	end

	return var0
end

function var0.Switch(arg0, arg1)
	arg0:Clear()

	arg0.selected = {}

	local var0 = arg0:GetShipList(arg1)

	arg0:UpdateModeStyle(arg1, #var0)

	arg0.mode = arg1

	arg0:FlushShipList(var0)

	if arg0.mode == var0.MODE_VIEW then
		arg0:UpdateSelectedCnt(var0)
	else
		arg0:UpdateSelectedCnt(arg0.selected)
	end
end

function var0.UpdateModeStyle(arg0, arg1, arg2)
	arg0.titleImg.sprite = arg0.titles[arg1]

	arg0.titleImg:SetNativeSize()

	arg0.titleEnImg.sprite = arg0.titleEns[arg1]

	arg0.titleEnImg:SetNativeSize()
	setActive(arg0.addBtn, arg1 == var0.MODE_VIEW)
	setActive(arg0.removeBtn, arg1 == var0.MODE_VIEW)
	setActive(arg0.cancelBtn, arg1 == var0.MODE_ADD or arg1 == var0.MODE_REMOVE)
	setActive(arg0.confirmBtn, arg1 == var0.MODE_ADD or arg1 == var0.MODE_REMOVE)
	setActive(arg0.allBtn, arg1 == var0.MODE_ADD or arg1 == var0.MODE_REMOVE)

	arg0.tipTxt.text = arg0.tips[arg1]
	arg0.selectedTxt.text = arg0.selectedTxts[arg1]

	setButtonEnabled(arg0.removeBtn, arg1 == var0.MODE_VIEW and arg2 > 0)
	setAnchoredPosition(arg0.selectPanelFrame, {
		x = arg1 == var0.MODE_VIEW and 0 or 180
	})
end

function var0.OnConfirm(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.selected) do
		table.insert(var0, iter0)
	end

	local function var1()
		if arg0.mode == var0.MODE_ADD then
			arg0:emit(RandomDockYardMediator.ON_ADD_SHIPS, var0)
		elseif arg0.mode == var0.MODE_REMOVE then
			arg0:emit(RandomDockYardMediator.ON_REMOVE_SHIPS, var0)
		end
	end

	local var2 = arg0.msgBoxTitle[arg0.mode]
	local var3 = arg0.msgBoxSubTitle[arg0.mode]

	arg0.msgbox:ExecuteAction("Flush", var2, var3, var0, var1)
end

function var0.OnAll(arg0)
	for iter0, iter1 in ipairs(arg0.displays) do
		arg0.selected[iter1.id] = true
	end

	arg0.scrollrect:SetTotalCount(#arg0.displays)
	arg0:UpdateSelectedCnt(arg0.selected)
end

function var0.UpdateSelectedCnt(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in pairs(arg1) do
		var0 = var0 + 1
	end

	arg0.selectedCntTxt.text = var0

	setButtonEnabled(arg0.confirmBtn, var0 > 0)
	setActive(arg0.confirmBtnMask, var0 <= 0)
end

local function var1(arg0)
	return arg0.sortIndex ~= ShipIndexConst.SortLevel or arg0.typeIndex ~= ShipIndexConst.TypeAll or arg0.campIndex ~= ShipIndexConst.CampAll or arg0.rarityIndex ~= ShipIndexConst.RarityAll or arg0.extraIndex ~= ShipIndexConst.ExtraALL
end

function var0.OnFilter(arg0, arg1)
	local var0 = arg0.indexDatas[arg0.mode]

	var0.sortIndex = arg1.sortIndex
	var0.typeIndex = arg1.typeIndex
	var0.campIndex = arg1.campIndex
	var0.rarityIndex = arg1.rarityIndex
	var0.extraIndex = arg1.extraIndex

	setActive(arg0.indexBtnSel, var1(var0))

	local var1 = arg0:GetShipList(arg0.mode)

	arg0:FlushShipList(var1)
end

function var0.OnItemUpdate(arg0, arg1)
	local var0 = RandomDockYardCard.New(arg1)

	onButton(arg0, var0._go, function()
		if arg0.mode == var0.MODE_VIEW then
			return
		end

		if arg0.selected[var0.ship.id] then
			arg0.selected[var0.ship.id] = nil
		else
			arg0.selected[var0.ship.id] = true
		end

		arg0:UpdateSelectedCnt(arg0.selected)
		var0:UpdateSelected(arg0.selected[var0.ship.id])
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnItemUpdate(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]
	local var2 = arg0.selected[var1.id]

	var0:Update(var1, var2)
end

function var0.FlushShipList(arg0, arg1)
	arg0.displays = {}

	arg0:FilterShips(arg1, arg0.displays)
	arg0:SortShips(arg0.displays)

	local var0 = #arg0.displays

	arg0.scrollrect:SetTotalCount(var0)
	setActive(arg0.emptyTr, var0 <= 0)
end

function var0.FilterShips(arg0, arg1, arg2)
	local var0 = arg0.lockFlags[arg0.mode]
	local var1 = arg0.frequentlyUseFlags[arg0.mode]
	local var2 = arg0.indexDatas[arg0.mode]

	local function var3(arg0)
		local var0 = not var0 or not not arg0:IsLocked()
		local var1 = not var1 or not not arg0:IsPreferenceTag()
		local var2 = ShipIndexConst.filterByType(arg0, var2.typeIndex)
		local var3 = ShipIndexConst.filterByCamp(arg0, var2.campIndex)
		local var4 = ShipIndexConst.filterByRarity(arg0, var2.rarityIndex)
		local var5 = ShipIndexConst.filterByExtra(arg0, var2.extraIndex)

		return var0 and var1 and var2 and var3 and var4 and var5
	end

	for iter0, iter1 in ipairs(arg1) do
		if var3(iter1) then
			table.insert(arg2, iter1)
		end
	end
end

function var0.SortShips(arg0, arg1)
	local var0 = arg0.indexDatas[arg0.mode]
	local var1 = arg0.sortFlags[arg0.mode]
	local var2 = var0.sortIndex
	local var3, var4 = ShipIndexConst.getSortFuncAndName(var2, var1)

	table.insert(var3, 1, function(arg0)
		return -arg0.activityNpc
	end)
	table.sort(arg1, CompareFuncs(var3))

	arg0.sortTxt.text = i18n(var4)
end

function var0.onBackPressed(arg0)
	var0.super.onBackPressed(arg0)
end

function var0.Clear(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = {}
end

function var0.willExit(arg0)
	arg0.titles = nil

	if arg0.msgbox then
		arg0.msgbox:Destroy()
	end

	arg0.msgbox = nil
end

return var0
