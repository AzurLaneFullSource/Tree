local var0_0 = class("SpWeaponStoreHouseScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SpWeaponStoreHouseUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/equipmentui_atlas",
		"ui/share/index_atlas",
		"weaponframes",
		"ui/iconcolorful",
		"ui/CustomIndexUI",
		"ui/MsgBox",
		"ui/SpWeaponUpgradeUI"
	}

	local function var1_2(arg0_3)
		if not arg0_3 then
			return
		end

		table.insert(var0_2, arg0_3:GetIconPath())

		local var0_3 = arg0_3:GetShipId()

		if var0_3 and var0_3 > 0 then
			local var1_3 = getProxy(BayProxy):RawGetShipById(var0_3)

			if var1_3 then
				table.insert(var0_2, "qicon/" .. var1_3:getPainting())
			end
		end
	end

	local var2_2 = getProxy(BayProxy)
	local var3_2 = arg1_2 and arg1_2.shipId
	local var4_2 = var3_2 and var2_2:RawGetShipById(var3_2)

	for iter0_2, iter1_2 in ipairs(var2_2:GetSpWeaponsInShips(var4_2)) do
		var1_2(iter1_2)
	end

	for iter2_2, iter3_2 in pairs(getProxy(EquipmentProxy):GetSpWeapons()) do
		if not var4_2 or not var4_2:IsSpWeaponForbidden(iter3_2) then
			var1_2(iter3_2)
		end
	end

	for iter4_2, iter5_2 in ipairs(SpWeapon.bindConfigTable().all) do
		local var5_2 = SpWeapon.New({
			id = iter5_2
		})

		if var5_2:IsCraftable() and (not var4_2 or not var4_2:IsSpWeaponForbidden(var5_2)) then
			var1_2(var5_2)
		end
	end

	table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))

	return var0_2
end

function var0_0.setEquipments(arg0_4, arg1_4)
	arg0_4.equipmentVOs = arg1_4
end

function var0_0.SetCraftList(arg0_5, arg1_5)
	arg0_5.craftList = arg1_5
end

local var1_0 = require("view.equipment.SpWeaponSortCfg")

function var0_0.init(arg0_6)
	arg0_6.topItems = arg0_6._tf:Find("topItems")
	arg0_6.equipmentView = arg0_6.rtAdapt:Find("ScrollView")
	arg0_6.equipmentsGrid = arg0_6.equipmentView:Find("Viewport/Content/StoreHouse/Grid")
	arg0_6.craftsGrid = arg0_6.equipmentView:Find("Viewport/Content/Craft/Grid")

	setActive(arg0_6.equipmentView:Find("Template"), false)

	arg0_6.blurPanel = arg0_6._tf:Find("blur_panel")
	arg0_6.topPanel = arg0_6.blurPanel:Find("adapt/top")
	arg0_6.indexBtn = arg0_6.topPanel:Find("buttons/index_button")
	arg0_6.sortBtn = arg0_6.topPanel:Find("buttons/sort_button")
	arg0_6.sortPanel = arg0_6.topItems:Find("sort")
	arg0_6.sortContain = arg0_6.sortPanel:Find("adapt/mask/panel")
	arg0_6.sortTpl = arg0_6.sortContain:Find("tpl")

	setActive(arg0_6.sortTpl, false)

	local var0_6
	local var1_6 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var1_6:CheckLargeScreen() then
		var0_6 = arg0_6.equipmentView.rect.width > 2000
	else
		var0_6 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0_6.equipmentsGrid:GetComponent(typeof(GridLayoutGroup)).constraintCount = var0_6 and 8 or 7
	arg0_6.craftsGrid:GetComponent(typeof(GridLayoutGroup)).constraintCount = var0_6 and 8 or 7
	arg0_6.decBtn = findTF(arg0_6.topPanel, "buttons/dec_btn")
	arg0_6.sortImgAsc = findTF(arg0_6.decBtn, "asc")
	arg0_6.sortImgDec = findTF(arg0_6.decBtn, "desc")
	arg0_6.filterBusyToggle = arg0_6._tf:Find("blur_panel/adapt/left_length/frame/toggle_equip")

	setActive(arg0_6.filterBusyToggle, false)

	arg0_6.bottomBack = arg0_6.topItems:Find("adapt/bottom_back")
	arg0_6.capacityTF = arg0_6.bottomBack:Find("bottom_left/tip/capcity/Text")
	arg0_6.tipTF = arg0_6.bottomBack:Find("bottom_left/tip")
	arg0_6.tip = arg0_6.tipTF:Find("label")
	arg0_6.helpBtn = arg0_6.topItems:Find("adapt/help_btn")

	setActive(arg0_6.helpBtn, true)

	arg0_6.backBtn = arg0_6._tf:Find("blur_panel/adapt/top/back_btn")
	arg0_6.listEmptyTF = arg0_6._tf:Find("empty")

	setActive(arg0_6.listEmptyTF, false)

	arg0_6.listEmptyTxt = arg0_6.listEmptyTF:Find("Text")

	setText(arg0_6.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	setText(arg0_6.equipmentView:Find("Viewport/Content/Craft/Banner/Text"), i18n("spweapon_ui_create"))
	setText(arg0_6.equipmentView:Find("Viewport/Content/StoreHouse/Banner/Text"), i18n("spweapon_ui_storage"))

	arg0_6.isEquipingOn = false
	arg0_6.filterImportance = nil
end

function var0_0.setEquipmentUpdate(arg0_7)
	arg0_7:filterEquipment()
	arg0_7:updateCapacity()
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8.helpBtn, function()
		local var0_9 = pg.gametip.spweapon_help_storage.tip

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_9
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.backBtn, function()
		GetOrAddComponent(arg0_8._tf, typeof(CanvasGroup)).interactable = false

		arg0_8:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onToggle(arg0_8, arg0_8.sortBtn, function(arg0_11)
		if arg0_11 then
			arg0_8:OverlayPanel(arg0_8.sortPanel)
			setActive(arg0_8.sortPanel, true)
		else
			arg0_8:UnOverlayPanel(arg0_8.sortPanel, arg0_8.topItems)
			setActive(arg0_8.sortPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.sortPanel, function()
		triggerToggle(arg0_8.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.indexBtn, function()
		local var0_13 = {
			indexDatas = Clone(arg0_8.contextData.indexDatas),
			customPanels = {
				typeIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.SpWeaponTypeIndexs,
					names = IndexConst.SpWeaponTypeNames
				},
				rarityIndex = {
					mode = CustomIndexLayer.Mode.AND,
					options = IndexConst.SpWeaponRarityIndexs,
					names = IndexConst.SpWeaponRarityNames
				}
			},
			groupList = {
				{
					dropdown = false,
					titleTxt = "indexsort_type",
					titleENTxt = "indexsort_typeeng",
					tags = {
						"typeIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_rarity",
					titleENTxt = "indexsort_rarityeng",
					tags = {
						"rarityIndex"
					}
				}
			},
			callback = function(arg0_14)
				arg0_8.contextData.indexDatas.typeIndex = arg0_14.typeIndex
				arg0_8.contextData.indexDatas.rarityIndex = arg0_14.rarityIndex

				arg0_8:filterEquipment()
			end
		}

		arg0_8:emit(SpWeaponStoreHouseMediator.OPEN_EQUIPMENT_INDEX, var0_13)
	end, SFX_PANEL)

	local var0_8 = arg0_8.equipmentView:Find("Viewport/Content/Craft/Banner/Arrow")

	onToggle(arg0_8, var0_8, function(arg0_15)
		arg0_8.hideCraft = not arg0_15

		arg0_8:UpdateCraftCount()
	end, SFX_PANEL, SFX_PANEL)

	local var1_8 = arg0_8.equipmentView:Find("Viewport/Content/StoreHouse/Banner/Arrow")

	onToggle(arg0_8, var1_8, function(arg0_16)
		arg0_8.hideSpweapon = not arg0_16

		arg0_8:updateEquipmentCount()
	end, SFX_PANEL, SFX_PANEL)

	arg0_8.equipmetItems = {}
	arg0_8.craftItems = {}

	arg0_8:initEquipments()

	arg0_8.asc = arg0_8.contextData.asc or false
	arg0_8.contextData.sortData = arg0_8.contextData.sortData or var1_0.sort[1]
	arg0_8.contextData.indexDatas = arg0_8.contextData.indexDatas or {}

	arg0_8:initSort()
	onToggle(arg0_8, arg0_8.filterBusyToggle, function(arg0_17)
		arg0_8:SetShowBusyFlag(arg0_17)
		arg0_8:filterEquipment()
	end, SFX_PANEL)
	triggerToggle(arg0_8.filterBusyToggle, arg0_8.shipVO)
	arg0_8:OverlayPanel(arg0_8.blurPanel)
	arg0_8:OverlayPanel(arg0_8.topItems)

	local var2_8 = arg0_8.contextData.mode or StoreHouseConst.OVERVIEW

	arg0_8.contextData.mode = var2_8

	arg0_8:updateCapacity()
	setActive(arg0_8.tip, false)
	setActive(arg0_8.capacityTF.parent, true)
	setActive(arg0_8.filterBusyToggle, true)
	setActive(arg0_8.indexBtn, true)
	setActive(arg0_8.sortBtn, false)
	triggerToggle(var0_8, true)
	triggerToggle(var1_8, true)
end

function var0_0.isDefaultStatus(arg0_18)
	return (not arg0_18.contextData.indexDatas.typeIndex or arg0_18.contextData.indexDatas.typeIndex == IndexConst.SpWeaponTypeAll) and (not arg0_18.contextData.indexDatas.rarityIndex or arg0_18.contextData.indexDatas.rarityIndex == IndexConst.SpWeaponRarityAll)
end

function var0_0.onBackPressed(arg0_19)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_19.sortPanel) then
		triggerButton(arg0_19.sortPanel)
	else
		triggerButton(arg0_19.backBtn)
	end
end

function var0_0.updateCapacity(arg0_20)
	setText(arg0_20.tip, "")

	local var0_20 = getProxy(EquipmentProxy):GetSpWeaponCount()
	local var1_20 = getProxy(EquipmentProxy):GetSpWeaponCapacity()

	setText(arg0_20.capacityTF, var0_20 .. "/" .. var1_20)
end

function var0_0.setShip(arg0_21, arg1_21)
	arg0_21.shipVO = arg1_21
end

function var0_0.setPlayer(arg0_22, arg1_22)
	arg0_22.player = arg1_22
end

function var0_0.initSort(arg0_23)
	onButton(arg0_23, arg0_23.decBtn, function()
		arg0_23.asc = not arg0_23.asc
		arg0_23.contextData.asc = arg0_23.asc

		arg0_23:filterEquipment()
	end)

	arg0_23.sortButtons = {}

	eachChild(arg0_23.sortContain, function(arg0_25)
		setActive(arg0_25, false)
	end)

	for iter0_23, iter1_23 in ipairs(var1_0.sort) do
		local var0_23 = iter0_23 <= arg0_23.sortContain.childCount and arg0_23.sortContain:GetChild(iter0_23 - 1) or cloneTplTo(arg0_23.sortTpl, arg0_23.sortContain)

		setActive(var0_23, true)
		setImageSprite(findTF(var0_23, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1_23.spr), true)
		onToggle(arg0_23, var0_23, function(arg0_26)
			if arg0_26 then
				arg0_23.contextData.sortData = iter1_23

				arg0_23:filterEquipment()
				triggerToggle(arg0_23.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0_23.sortButtons[iter0_23] = var0_23
	end
end

function var0_0.initEquipments(arg0_27)
	arg0_27.equipmentRect = UIItemList.New(arg0_27.equipmentsGrid, arg0_27.equipmentView:Find("Template"))

	arg0_27.equipmentRect:make(function(arg0_28, arg1_28, arg2_28)
		local var0_28 = go(arg2_28)

		if arg0_28 == UIItemList.EventInit then
			arg0_27:InitSpWeapon(var0_28)
		elseif arg0_28 == UIItemList.EventUpdate then
			arg0_27:UpdateSpWeapon(arg1_28, var0_28)
		elseif arg0_28 == UIItemList.EventExcess then
			arg0_27:ReturnSpWeapon(arg1_28, var0_28)
		end
	end)

	arg0_27.craftRect = UIItemList.New(arg0_27.craftsGrid, arg0_27.equipmentView:Find("Template"))

	arg0_27.craftRect:make(function(arg0_29, arg1_29, arg2_29)
		local var0_29 = go(arg2_29)

		if arg0_29 == UIItemList.EventInit then
			arg0_27:InitCraftItem(var0_29)
		elseif arg0_29 == UIItemList.EventUpdate then
			arg0_27:UpdateCraftItem(arg1_29, var0_29)
		elseif arg0_29 == UIItemList.EventExcess then
			arg0_27:ReturnCraftItem(arg1_29, var0_29)
		end
	end)
end

function var0_0.InitSpWeapon(arg0_30, arg1_30)
	local var0_30 = SpWeaponItemView.New(arg1_30)

	onButton(arg0_30, var0_30.unloadBtn, function()
		arg0_30:emit(SpWeaponStoreHouseMediator.ON_UNEQUIP)
	end, SFX_PANEL)

	arg0_30.equipmetItems[arg1_30] = var0_30
end

function var0_0.UpdateSpWeapon(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32.equipmetItems[arg2_32]

	assert(var0_32, "without init item")

	local var1_32 = arg0_32.loadEquipmentVOs[arg1_32 + 1]

	var0_32:update(var1_32)

	if not var1_32 or var1_32.mask then
		removeOnButton(var0_32.go)
	else
		onButton(arg0_32, var0_32.go, function()
			local var0_33 = arg0_32.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				shipId = arg0_32.contextData.shipId,
				oldSpWeaponUid = var1_32:GetUID(),
				oldShipId = var1_32:GetShipId()
			} or var1_32:GetShipId() and {
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				spWeaponUid = var1_32:GetUID(),
				shipId = var1_32:GetShipId()
			} or {
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				spWeaponUid = var1_32:GetUID()
			}

			arg0_32:emit(var0_0.ON_SPWEAPON, var0_33)
		end, SFX_PANEL)
	end
end

function var0_0.ReturnSpWeapon(arg0_34, arg1_34, arg2_34)
	if arg0_34.exited then
		return
	end

	local var0_34 = arg0_34.equipmetItems[arg2_34]

	if var0_34 then
		removeOnButton(var0_34.go)
		var0_34:clear()
	end
end

function var0_0.updateEquipmentCount(arg0_35)
	local var0_35 = arg0_35.hideSpweapon and 0 or #arg0_35.loadEquipmentVOs

	arg0_35.equipmentRect:align(var0_35)

	local var1_35 = arg0_35.equipmentsGrid:GetComponent(typeof(GridLayoutGroup))
	local var2_35 = var1_35.padding

	if var0_35 then
		var2_35.top = 31
		var2_35.bottom = 25
	else
		var2_35.top = 0
		var2_35.bottom = 0
	end

	var1_35.padding = var2_35
end

function var0_0.filterEquipment(arg0_36)
	local var0_36 = arg0_36:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_36, function(arg0_37)
		setImageSprite(arg0_36.indexBtn, arg0_37, true)
	end)

	local var1_36 = arg0_36.contextData.sortData

	;(function()
		arg0_36.loadEquipmentVOs = {}

		local var0_38 = {}

		for iter0_38, iter1_38 in pairs(arg0_36.equipmentVOs) do
			table.insert(var0_38, iter1_38)
		end

		for iter2_38, iter3_38 in pairs(var0_38) do
			if arg0_36:checkFitBusyCondition(iter3_38) and IndexConst.filterSpWeaponByType(iter3_38, arg0_36.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter3_38, arg0_36.contextData.indexDatas.rarityIndex) and (arg0_36.filterImportance == nil or iter3_38:IsImportant()) then
				table.insert(arg0_36.loadEquipmentVOs, iter3_38)
			end
		end

		if var1_36 then
			local var1_38 = arg0_36.asc

			table.sort(arg0_36.loadEquipmentVOs, CompareFuncs(var1_0.sortFunc(var1_36, var1_38)))
		end

		if arg0_36.contextData.qiutBtn then
			table.insert(arg0_36.loadEquipmentVOs, 1, false)
		end
	end)()
	arg0_36:updateEquipmentCount()
	;(function()
		arg0_36.showCraftList = {}

		local var0_39 = {}

		for iter0_39, iter1_39 in pairs(arg0_36.craftList) do
			table.insert(var0_39, iter1_39)
		end

		for iter2_39, iter3_39 in pairs(var0_39) do
			if arg0_36:checkFitBusyCondition(iter3_39) and IndexConst.filterSpWeaponByType(iter3_39, arg0_36.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter3_39, arg0_36.contextData.indexDatas.rarityIndex) and (arg0_36.filterImportance == nil or iter3_39:IsImportant()) then
				table.insert(arg0_36.showCraftList, iter3_39)
			end
		end

		if var1_36 then
			local var1_39 = arg0_36.asc

			table.sort(arg0_36.showCraftList, CompareFuncs(var1_0.sortFunc(var1_36, var1_39)))
		end
	end)()
	arg0_36:UpdateCraftCount()
	setImageSprite(arg0_36.sortBtn:Find("Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", var1_36.spr), true)
	setActive(arg0_36.sortImgAsc, arg0_36.asc)
	setActive(arg0_36.sortImgDec, not arg0_36.asc)
end

function var0_0.InitCraftItem(arg0_40, arg1_40)
	local var0_40 = SpWeaponItemView.New(arg1_40)

	arg0_40.craftItems[arg1_40] = var0_40
end

function var0_0.UpdateCraftItem(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41.craftItems[arg2_41]

	assert(var0_41, "without init item")

	local var1_41 = arg0_41.showCraftList[arg1_41 + 1]

	var0_41:update(var1_41)
	onButton(arg0_41, var0_41.go, function()
		arg0_41:emit(SpWeaponStoreHouseMediator.ON_COMPOSITE, var1_41:GetConfigID())
	end, SFX_PANEL)
end

function var0_0.ReturnCraftItem(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.craftItems[arg2_43]

	if var0_43 then
		removeOnButton(var0_43.go)
		var0_43:clear()
	end
end

function var0_0.UpdateCraftCount(arg0_44)
	local var0_44 = arg0_44.hideCraft and 0 or #arg0_44.showCraftList

	arg0_44.craftRect:align(var0_44)

	local var1_44 = arg0_44.craftsGrid:GetComponent(typeof(GridLayoutGroup))
	local var2_44 = var1_44.padding

	if var0_44 > 0 then
		var2_44.top = 31
		var2_44.bottom = 25
	else
		var2_44.top = 0
		var2_44.bottom = 0
	end

	var1_44.padding = var2_44
end

function var0_0.GetShowBusyFlag(arg0_45)
	return arg0_45.isEquipingOn
end

function var0_0.SetShowBusyFlag(arg0_46, arg1_46)
	arg0_46.isEquipingOn = arg1_46
end

function var0_0.checkFitBusyCondition(arg0_47, arg1_47)
	return arg0_47:GetShowBusyFlag() or not arg1_47:GetShipId()
end

function var0_0.willExit(arg0_48)
	arg0_48:UnOverlayPanel(arg0_48.blurPanel, arg0_48._tf)
	arg0_48:UnOverlayPanel(arg0_48.topItems, arg0_48._tf)
end

return var0_0
