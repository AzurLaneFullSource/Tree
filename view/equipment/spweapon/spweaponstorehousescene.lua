local var0_0 = class("SpWeaponStoreHouseScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SpWeaponStoreHouseUI"
end

function var0_0.setEquipments(arg0_2, arg1_2)
	arg0_2.equipmentVOs = arg1_2
end

function var0_0.SetCraftList(arg0_3, arg1_3)
	arg0_3.craftList = arg1_3
end

local var1_0 = require("view.equipment.SpWeaponSortCfg")

function var0_0.init(arg0_4)
	arg0_4.topItems = arg0_4:findTF("topItems")
	arg0_4.equipmentView = arg0_4:findTF("ScrollView")
	arg0_4.equipmentsGrid = arg0_4.equipmentView:Find("Viewport/Content/StoreHouse/Grid")
	arg0_4.craftsGrid = arg0_4.equipmentView:Find("Viewport/Content/Craft/Grid")

	setActive(arg0_4.equipmentView:Find("Template"), false)

	arg0_4.blurPanel = arg0_4:findTF("blur_panel")
	arg0_4.topPanel = arg0_4:findTF("adapt/top", arg0_4.blurPanel)
	arg0_4.indexBtn = arg0_4:findTF("buttons/index_button", arg0_4.topPanel)
	arg0_4.sortBtn = arg0_4:findTF("buttons/sort_button", arg0_4.topPanel)
	arg0_4.sortPanel = arg0_4:findTF("sort", arg0_4.topItems)
	arg0_4.sortContain = arg0_4:findTF("adapt/mask/panel", arg0_4.sortPanel)
	arg0_4.sortTpl = arg0_4:findTF("tpl", arg0_4.sortContain)

	setActive(arg0_4.sortTpl, false)

	local var0_4
	local var1_4 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var1_4:CheckLargeScreen() then
		var0_4 = arg0_4.equipmentView.rect.width > 2000
	else
		var0_4 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0_4.equipmentsGrid:GetComponent(typeof(GridLayoutGroup)).constraintCount = var0_4 and 8 or 7
	arg0_4.craftsGrid:GetComponent(typeof(GridLayoutGroup)).constraintCount = var0_4 and 8 or 7
	arg0_4.decBtn = findTF(arg0_4.topPanel, "buttons/dec_btn")
	arg0_4.sortImgAsc = findTF(arg0_4.decBtn, "asc")
	arg0_4.sortImgDec = findTF(arg0_4.decBtn, "desc")
	arg0_4.filterBusyToggle = arg0_4._tf:Find("blur_panel/adapt/left_length/frame/toggle_equip")

	setActive(arg0_4.filterBusyToggle, false)

	arg0_4.bottomBack = arg0_4:findTF("adapt/bottom_back", arg0_4.topItems)
	arg0_4.capacityTF = arg0_4:findTF("bottom_left/tip/capcity/Text", arg0_4.bottomBack)
	arg0_4.tipTF = arg0_4:findTF("bottom_left/tip", arg0_4.bottomBack)
	arg0_4.tip = arg0_4.tipTF:Find("label")
	arg0_4.helpBtn = arg0_4:findTF("adapt/help_btn", arg0_4.topItems)

	setActive(arg0_4.helpBtn, true)

	arg0_4.backBtn = arg0_4:findTF("blur_panel/adapt/top/back_btn")
	arg0_4.listEmptyTF = arg0_4:findTF("empty")

	setActive(arg0_4.listEmptyTF, false)

	arg0_4.listEmptyTxt = arg0_4:findTF("Text", arg0_4.listEmptyTF)

	setText(arg0_4.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	setText(arg0_4.equipmentView:Find("Viewport/Content/Craft/Banner/Text"), i18n("spweapon_ui_create"))
	setText(arg0_4.equipmentView:Find("Viewport/Content/StoreHouse/Banner/Text"), i18n("spweapon_ui_storage"))

	arg0_4.isEquipingOn = false
	arg0_4.filterImportance = nil
end

function var0_0.setEquipmentUpdate(arg0_5)
	arg0_5:filterEquipment()
	arg0_5:updateCapacity()
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6.helpBtn, function()
		local var0_7 = pg.gametip.spweapon_help_storage.tip

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_7
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.backBtn, function()
		GetOrAddComponent(arg0_6._tf, typeof(CanvasGroup)).interactable = false

		arg0_6:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onToggle(arg0_6, arg0_6.sortBtn, function(arg0_9)
		if arg0_9 then
			pg.UIMgr.GetInstance():OverlayPanel(arg0_6.sortPanel, {
				groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
			})
			setActive(arg0_6.sortPanel, true)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_6.sortPanel, arg0_6.topItems)
			setActive(arg0_6.sortPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.sortPanel, function()
		triggerToggle(arg0_6.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.indexBtn, function()
		local var0_11 = {
			indexDatas = Clone(arg0_6.contextData.indexDatas),
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
			callback = function(arg0_12)
				arg0_6.contextData.indexDatas.typeIndex = arg0_12.typeIndex
				arg0_6.contextData.indexDatas.rarityIndex = arg0_12.rarityIndex

				arg0_6:filterEquipment()
			end
		}

		arg0_6:emit(SpWeaponStoreHouseMediator.OPEN_EQUIPMENT_INDEX, var0_11)
	end, SFX_PANEL)

	local var0_6 = arg0_6.equipmentView:Find("Viewport/Content/Craft/Banner/Arrow")

	onToggle(arg0_6, var0_6, function(arg0_13)
		arg0_6.hideCraft = not arg0_13

		arg0_6:UpdateCraftCount()
	end, SFX_PANEL, SFX_PANEL)

	local var1_6 = arg0_6.equipmentView:Find("Viewport/Content/StoreHouse/Banner/Arrow")

	onToggle(arg0_6, var1_6, function(arg0_14)
		arg0_6.hideSpweapon = not arg0_14

		arg0_6:updateEquipmentCount()
	end, SFX_PANEL, SFX_PANEL)

	arg0_6.equipmetItems = {}
	arg0_6.craftItems = {}

	arg0_6:initEquipments()

	arg0_6.asc = arg0_6.contextData.asc or false
	arg0_6.contextData.sortData = arg0_6.contextData.sortData or var1_0.sort[1]
	arg0_6.contextData.indexDatas = arg0_6.contextData.indexDatas or {}

	arg0_6:initSort()
	onToggle(arg0_6, arg0_6.filterBusyToggle, function(arg0_15)
		arg0_6:SetShowBusyFlag(arg0_15)
		arg0_6:filterEquipment()
	end, SFX_PANEL)
	triggerToggle(arg0_6.filterBusyToggle, arg0_6.shipVO)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_6.blurPanel, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0_6.topItems, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})

	local var2_6 = arg0_6.contextData.mode or StoreHouseConst.OVERVIEW

	arg0_6.contextData.mode = var2_6

	arg0_6:updateCapacity()
	setActive(arg0_6.tip, false)
	setActive(arg0_6.capacityTF.parent, true)
	setActive(arg0_6.filterBusyToggle, true)
	setActive(arg0_6.indexBtn, true)
	setActive(arg0_6.sortBtn, false)
	triggerToggle(var0_6, true)
	triggerToggle(var1_6, true)
end

function var0_0.isDefaultStatus(arg0_16)
	return (not arg0_16.contextData.indexDatas.typeIndex or arg0_16.contextData.indexDatas.typeIndex == IndexConst.SpWeaponTypeAll) and (not arg0_16.contextData.indexDatas.rarityIndex or arg0_16.contextData.indexDatas.rarityIndex == IndexConst.SpWeaponRarityAll)
end

function var0_0.onBackPressed(arg0_17)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_17.sortPanel) then
		triggerButton(arg0_17.sortPanel)
	else
		triggerButton(arg0_17.backBtn)
	end
end

function var0_0.updateCapacity(arg0_18)
	setText(arg0_18.tip, "")

	local var0_18 = getProxy(EquipmentProxy):GetSpWeaponCount()
	local var1_18 = getProxy(EquipmentProxy):GetSpWeaponCapacity()

	setText(arg0_18.capacityTF, var0_18 .. "/" .. var1_18)
end

function var0_0.setShip(arg0_19, arg1_19)
	arg0_19.shipVO = arg1_19
end

function var0_0.setPlayer(arg0_20, arg1_20)
	arg0_20.player = arg1_20
end

function var0_0.initSort(arg0_21)
	onButton(arg0_21, arg0_21.decBtn, function()
		arg0_21.asc = not arg0_21.asc
		arg0_21.contextData.asc = arg0_21.asc

		arg0_21:filterEquipment()
	end)

	arg0_21.sortButtons = {}

	eachChild(arg0_21.sortContain, function(arg0_23)
		setActive(arg0_23, false)
	end)

	for iter0_21, iter1_21 in ipairs(var1_0.sort) do
		local var0_21 = iter0_21 <= arg0_21.sortContain.childCount and arg0_21.sortContain:GetChild(iter0_21 - 1) or cloneTplTo(arg0_21.sortTpl, arg0_21.sortContain)

		setActive(var0_21, true)
		setImageSprite(findTF(var0_21, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1_21.spr), true)
		onToggle(arg0_21, var0_21, function(arg0_24)
			if arg0_24 then
				arg0_21.contextData.sortData = iter1_21

				arg0_21:filterEquipment()
				triggerToggle(arg0_21.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0_21.sortButtons[iter0_21] = var0_21
	end
end

function var0_0.initEquipments(arg0_25)
	arg0_25.equipmentRect = UIItemList.New(arg0_25.equipmentsGrid, arg0_25.equipmentView:Find("Template"))

	arg0_25.equipmentRect:make(function(arg0_26, arg1_26, arg2_26)
		local var0_26 = go(arg2_26)

		if arg0_26 == UIItemList.EventInit then
			arg0_25:InitSpWeapon(var0_26)
		elseif arg0_26 == UIItemList.EventUpdate then
			arg0_25:UpdateSpWeapon(arg1_26, var0_26)
		elseif arg0_26 == UIItemList.EventExcess then
			arg0_25:ReturnSpWeapon(arg1_26, var0_26)
		end
	end)

	arg0_25.craftRect = UIItemList.New(arg0_25.craftsGrid, arg0_25.equipmentView:Find("Template"))

	arg0_25.craftRect:make(function(arg0_27, arg1_27, arg2_27)
		local var0_27 = go(arg2_27)

		if arg0_27 == UIItemList.EventInit then
			arg0_25:InitCraftItem(var0_27)
		elseif arg0_27 == UIItemList.EventUpdate then
			arg0_25:UpdateCraftItem(arg1_27, var0_27)
		elseif arg0_27 == UIItemList.EventExcess then
			arg0_25:ReturnCraftItem(arg1_27, var0_27)
		end
	end)
end

function var0_0.InitSpWeapon(arg0_28, arg1_28)
	local var0_28 = SpWeaponItemView.New(arg1_28)

	onButton(arg0_28, var0_28.unloadBtn, function()
		arg0_28:emit(SpWeaponStoreHouseMediator.ON_UNEQUIP)
	end, SFX_PANEL)

	arg0_28.equipmetItems[arg1_28] = var0_28
end

function var0_0.UpdateSpWeapon(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.equipmetItems[arg2_30]

	assert(var0_30, "without init item")

	local var1_30 = arg0_30.loadEquipmentVOs[arg1_30 + 1]

	var0_30:update(var1_30)

	if not var1_30 or var1_30.mask then
		removeOnButton(var0_30.go)
	else
		onButton(arg0_30, var0_30.go, function()
			local var0_31 = arg0_30.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				shipId = arg0_30.contextData.shipId,
				oldSpWeaponUid = var1_30:GetUID(),
				oldShipId = var1_30:GetShipId()
			} or var1_30:GetShipId() and {
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				spWeaponUid = var1_30:GetUID(),
				shipId = var1_30:GetShipId()
			} or {
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				spWeaponUid = var1_30:GetUID()
			}

			arg0_30:emit(var0_0.ON_SPWEAPON, var0_31)
		end, SFX_PANEL)
	end
end

function var0_0.ReturnSpWeapon(arg0_32, arg1_32, arg2_32)
	if arg0_32.exited then
		return
	end

	local var0_32 = arg0_32.equipmetItems[arg2_32]

	if var0_32 then
		removeOnButton(var0_32.go)
		var0_32:clear()
	end
end

function var0_0.updateEquipmentCount(arg0_33)
	local var0_33 = arg0_33.hideSpweapon and 0 or #arg0_33.loadEquipmentVOs

	arg0_33.equipmentRect:align(var0_33)

	local var1_33 = arg0_33.equipmentsGrid:GetComponent(typeof(GridLayoutGroup))
	local var2_33 = var1_33.padding

	if var0_33 then
		var2_33.top = 31
		var2_33.bottom = 25
	else
		var2_33.top = 0
		var2_33.bottom = 0
	end

	var1_33.padding = var2_33
end

function var0_0.filterEquipment(arg0_34)
	local var0_34 = arg0_34:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_34, function(arg0_35)
		setImageSprite(arg0_34.indexBtn, arg0_35, true)
	end)

	local var1_34 = arg0_34.contextData.sortData

	;(function()
		arg0_34.loadEquipmentVOs = {}

		local var0_36 = {}

		for iter0_36, iter1_36 in pairs(arg0_34.equipmentVOs) do
			table.insert(var0_36, iter1_36)
		end

		for iter2_36, iter3_36 in pairs(var0_36) do
			if arg0_34:checkFitBusyCondition(iter3_36) and IndexConst.filterSpWeaponByType(iter3_36, arg0_34.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter3_36, arg0_34.contextData.indexDatas.rarityIndex) and (arg0_34.filterImportance == nil or iter3_36:IsImportant()) then
				table.insert(arg0_34.loadEquipmentVOs, iter3_36)
			end
		end

		if var1_34 then
			local var1_36 = arg0_34.asc

			table.sort(arg0_34.loadEquipmentVOs, CompareFuncs(var1_0.sortFunc(var1_34, var1_36)))
		end

		if arg0_34.contextData.qiutBtn then
			table.insert(arg0_34.loadEquipmentVOs, 1, false)
		end
	end)()
	arg0_34:updateEquipmentCount()
	;(function()
		arg0_34.showCraftList = {}

		local var0_37 = {}

		for iter0_37, iter1_37 in pairs(arg0_34.craftList) do
			table.insert(var0_37, iter1_37)
		end

		for iter2_37, iter3_37 in pairs(var0_37) do
			if arg0_34:checkFitBusyCondition(iter3_37) and IndexConst.filterSpWeaponByType(iter3_37, arg0_34.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter3_37, arg0_34.contextData.indexDatas.rarityIndex) and (arg0_34.filterImportance == nil or iter3_37:IsImportant()) then
				table.insert(arg0_34.showCraftList, iter3_37)
			end
		end

		if var1_34 then
			local var1_37 = arg0_34.asc

			table.sort(arg0_34.showCraftList, CompareFuncs(var1_0.sortFunc(var1_34, var1_37)))
		end
	end)()
	arg0_34:UpdateCraftCount()
	setImageSprite(arg0_34:findTF("Image", arg0_34.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var1_34.spr), true)
	setActive(arg0_34.sortImgAsc, arg0_34.asc)
	setActive(arg0_34.sortImgDec, not arg0_34.asc)
end

function var0_0.InitCraftItem(arg0_38, arg1_38)
	local var0_38 = SpWeaponItemView.New(arg1_38)

	arg0_38.craftItems[arg1_38] = var0_38
end

function var0_0.UpdateCraftItem(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39.craftItems[arg2_39]

	assert(var0_39, "without init item")

	local var1_39 = arg0_39.showCraftList[arg1_39 + 1]

	var0_39:update(var1_39)
	onButton(arg0_39, var0_39.go, function()
		arg0_39:emit(SpWeaponStoreHouseMediator.ON_COMPOSITE, var1_39:GetConfigID())
	end, SFX_PANEL)
end

function var0_0.ReturnCraftItem(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41.craftItems[arg2_41]

	if var0_41 then
		removeOnButton(var0_41.go)
		var0_41:clear()
	end
end

function var0_0.UpdateCraftCount(arg0_42)
	local var0_42 = arg0_42.hideCraft and 0 or #arg0_42.showCraftList

	arg0_42.craftRect:align(var0_42)

	local var1_42 = arg0_42.craftsGrid:GetComponent(typeof(GridLayoutGroup))
	local var2_42 = var1_42.padding

	if var0_42 > 0 then
		var2_42.top = 31
		var2_42.bottom = 25
	else
		var2_42.top = 0
		var2_42.bottom = 0
	end

	var1_42.padding = var2_42
end

function var0_0.GetShowBusyFlag(arg0_43)
	return arg0_43.isEquipingOn
end

function var0_0.SetShowBusyFlag(arg0_44, arg1_44)
	arg0_44.isEquipingOn = arg1_44
end

function var0_0.checkFitBusyCondition(arg0_45, arg1_45)
	return arg0_45:GetShowBusyFlag() or not arg1_45:GetShipId()
end

function var0_0.willExit(arg0_46)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_46.blurPanel, arg0_46._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_46.topItems, arg0_46._tf)
end

return var0_0
