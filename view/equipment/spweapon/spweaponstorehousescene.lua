local var0 = class("SpWeaponStoreHouseScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "SpWeaponStoreHouseUI"
end

function var0.setEquipments(arg0, arg1)
	arg0.equipmentVOs = arg1
end

function var0.SetCraftList(arg0, arg1)
	arg0.craftList = arg1
end

local var1 = require("view.equipment.SpWeaponSortCfg")

function var0.init(arg0)
	arg0.topItems = arg0:findTF("topItems")
	arg0.equipmentView = arg0:findTF("ScrollView")
	arg0.equipmentsGrid = arg0.equipmentView:Find("Viewport/Content/StoreHouse/Grid")
	arg0.craftsGrid = arg0.equipmentView:Find("Viewport/Content/Craft/Grid")

	setActive(arg0.equipmentView:Find("Template"), false)

	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.topPanel = arg0:findTF("adapt/top", arg0.blurPanel)
	arg0.indexBtn = arg0:findTF("buttons/index_button", arg0.topPanel)
	arg0.sortBtn = arg0:findTF("buttons/sort_button", arg0.topPanel)
	arg0.sortPanel = arg0:findTF("sort", arg0.topItems)
	arg0.sortContain = arg0:findTF("adapt/mask/panel", arg0.sortPanel)
	arg0.sortTpl = arg0:findTF("tpl", arg0.sortContain)

	setActive(arg0.sortTpl, false)

	local var0
	local var1 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var1:CheckLargeScreen() then
		var0 = arg0.equipmentView.rect.width > 2000
	else
		var0 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0.equipmentsGrid:GetComponent(typeof(GridLayoutGroup)).constraintCount = var0 and 8 or 7
	arg0.craftsGrid:GetComponent(typeof(GridLayoutGroup)).constraintCount = var0 and 8 or 7
	arg0.decBtn = findTF(arg0.topPanel, "buttons/dec_btn")
	arg0.sortImgAsc = findTF(arg0.decBtn, "asc")
	arg0.sortImgDec = findTF(arg0.decBtn, "desc")
	arg0.filterBusyToggle = arg0._tf:Find("blur_panel/adapt/left_length/frame/toggle_equip")

	setActive(arg0.filterBusyToggle, false)

	arg0.bottomBack = arg0:findTF("adapt/bottom_back", arg0.topItems)
	arg0.capacityTF = arg0:findTF("bottom_left/tip/capcity/Text", arg0.bottomBack)
	arg0.tipTF = arg0:findTF("bottom_left/tip", arg0.bottomBack)
	arg0.tip = arg0.tipTF:Find("label")
	arg0.helpBtn = arg0:findTF("adapt/help_btn", arg0.topItems)

	setActive(arg0.helpBtn, true)

	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back_btn")
	arg0.listEmptyTF = arg0:findTF("empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)

	setText(arg0.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	setText(arg0.equipmentView:Find("Viewport/Content/Craft/Banner/Text"), i18n("spweapon_ui_create"))
	setText(arg0.equipmentView:Find("Viewport/Content/StoreHouse/Banner/Text"), i18n("spweapon_ui_storage"))

	arg0.isEquipingOn = false
	arg0.filterImportance = nil
end

function var0.setEquipmentUpdate(arg0)
	arg0:filterEquipment()
	arg0:updateCapacity()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.helpBtn, function()
		local var0 = pg.gametip.spweapon_help_storage.tip

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onToggle(arg0, arg0.sortBtn, function(arg0)
		if arg0 then
			pg.UIMgr.GetInstance():OverlayPanel(arg0.sortPanel, {
				groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
			})
			setActive(arg0.sortPanel, true)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0.sortPanel, arg0.topItems)
			setActive(arg0.sortPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.sortPanel, function()
		triggerToggle(arg0.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0, arg0.indexBtn, function()
		local var0 = {
			indexDatas = Clone(arg0.contextData.indexDatas),
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
			callback = function(arg0)
				arg0.contextData.indexDatas.typeIndex = arg0.typeIndex
				arg0.contextData.indexDatas.rarityIndex = arg0.rarityIndex

				arg0:filterEquipment()
			end
		}

		arg0:emit(SpWeaponStoreHouseMediator.OPEN_EQUIPMENT_INDEX, var0)
	end, SFX_PANEL)

	local var0 = arg0.equipmentView:Find("Viewport/Content/Craft/Banner/Arrow")

	onToggle(arg0, var0, function(arg0)
		arg0.hideCraft = not arg0

		arg0:UpdateCraftCount()
	end, SFX_PANEL, SFX_PANEL)

	local var1 = arg0.equipmentView:Find("Viewport/Content/StoreHouse/Banner/Arrow")

	onToggle(arg0, var1, function(arg0)
		arg0.hideSpweapon = not arg0

		arg0:updateEquipmentCount()
	end, SFX_PANEL, SFX_PANEL)

	arg0.equipmetItems = {}
	arg0.craftItems = {}

	arg0:initEquipments()

	arg0.asc = arg0.contextData.asc or false
	arg0.contextData.sortData = arg0.contextData.sortData or var1.sort[1]
	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}

	arg0:initSort()
	onToggle(arg0, arg0.filterBusyToggle, function(arg0)
		arg0:SetShowBusyFlag(arg0)
		arg0:filterEquipment()
	end, SFX_PANEL)
	triggerToggle(arg0.filterBusyToggle, arg0.shipVO)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.blurPanel, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0.topItems, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})

	local var2 = arg0.contextData.mode or StoreHouseConst.OVERVIEW

	arg0.contextData.mode = var2

	arg0:updateCapacity()
	setActive(arg0.tip, false)
	setActive(arg0.capacityTF.parent, true)
	setActive(arg0.filterBusyToggle, true)
	setActive(arg0.indexBtn, true)
	setActive(arg0.sortBtn, false)
	triggerToggle(var0, true)
	triggerToggle(var1, true)
end

function var0.isDefaultStatus(arg0)
	return (not arg0.contextData.indexDatas.typeIndex or arg0.contextData.indexDatas.typeIndex == IndexConst.SpWeaponTypeAll) and (not arg0.contextData.indexDatas.rarityIndex or arg0.contextData.indexDatas.rarityIndex == IndexConst.SpWeaponRarityAll)
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0.sortPanel) then
		triggerButton(arg0.sortPanel)
	else
		triggerButton(arg0.backBtn)
	end
end

function var0.updateCapacity(arg0)
	setText(arg0.tip, "")

	local var0 = getProxy(EquipmentProxy):GetSpWeaponCount()
	local var1 = getProxy(EquipmentProxy):GetSpWeaponCapacity()

	setText(arg0.capacityTF, var0 .. "/" .. var1)
end

function var0.setShip(arg0, arg1)
	arg0.shipVO = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.initSort(arg0)
	onButton(arg0, arg0.decBtn, function()
		arg0.asc = not arg0.asc
		arg0.contextData.asc = arg0.asc

		arg0:filterEquipment()
	end)

	arg0.sortButtons = {}

	eachChild(arg0.sortContain, function(arg0)
		setActive(arg0, false)
	end)

	for iter0, iter1 in ipairs(var1.sort) do
		local var0 = iter0 <= arg0.sortContain.childCount and arg0.sortContain:GetChild(iter0 - 1) or cloneTplTo(arg0.sortTpl, arg0.sortContain)

		setActive(var0, true)
		setImageSprite(findTF(var0, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1.spr), true)
		onToggle(arg0, var0, function(arg0)
			if arg0 then
				arg0.contextData.sortData = iter1

				arg0:filterEquipment()
				triggerToggle(arg0.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0.sortButtons[iter0] = var0
	end
end

function var0.initEquipments(arg0)
	arg0.equipmentRect = UIItemList.New(arg0.equipmentsGrid, arg0.equipmentView:Find("Template"))

	arg0.equipmentRect:make(function(arg0, arg1, arg2)
		local var0 = go(arg2)

		if arg0 == UIItemList.EventInit then
			arg0:InitSpWeapon(var0)
		elseif arg0 == UIItemList.EventUpdate then
			arg0:UpdateSpWeapon(arg1, var0)
		elseif arg0 == UIItemList.EventExcess then
			arg0:ReturnSpWeapon(arg1, var0)
		end
	end)

	arg0.craftRect = UIItemList.New(arg0.craftsGrid, arg0.equipmentView:Find("Template"))

	arg0.craftRect:make(function(arg0, arg1, arg2)
		local var0 = go(arg2)

		if arg0 == UIItemList.EventInit then
			arg0:InitCraftItem(var0)
		elseif arg0 == UIItemList.EventUpdate then
			arg0:UpdateCraftItem(arg1, var0)
		elseif arg0 == UIItemList.EventExcess then
			arg0:ReturnCraftItem(arg1, var0)
		end
	end)
end

function var0.InitSpWeapon(arg0, arg1)
	local var0 = SpWeaponItemView.New(arg1)

	onButton(arg0, var0.unloadBtn, function()
		arg0:emit(SpWeaponStoreHouseMediator.ON_UNEQUIP)
	end, SFX_PANEL)

	arg0.equipmetItems[arg1] = var0
end

function var0.UpdateSpWeapon(arg0, arg1, arg2)
	local var0 = arg0.equipmetItems[arg2]

	assert(var0, "without init item")

	local var1 = arg0.loadEquipmentVOs[arg1 + 1]

	var0:update(var1)

	if not var1 or var1.mask then
		removeOnButton(var0.go)
	else
		onButton(arg0, var0.go, function()
			local var0 = arg0.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				shipId = arg0.contextData.shipId,
				oldSpWeaponUid = var1:GetUID(),
				oldShipId = var1:GetShipId()
			} or var1:GetShipId() and {
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				spWeaponUid = var1:GetUID(),
				shipId = var1:GetShipId()
			} or {
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				spWeaponUid = var1:GetUID()
			}

			arg0:emit(var0.ON_SPWEAPON, var0)
		end, SFX_PANEL)
	end
end

function var0.ReturnSpWeapon(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.equipmetItems[arg2]

	if var0 then
		removeOnButton(var0.go)
		var0:clear()
	end
end

function var0.updateEquipmentCount(arg0)
	local var0 = arg0.hideSpweapon and 0 or #arg0.loadEquipmentVOs

	arg0.equipmentRect:align(var0)

	local var1 = arg0.equipmentsGrid:GetComponent(typeof(GridLayoutGroup))
	local var2 = var1.padding

	if var0 then
		var2.top = 31
		var2.bottom = 25
	else
		var2.top = 0
		var2.bottom = 0
	end

	var1.padding = var2
end

function var0.filterEquipment(arg0)
	local var0 = arg0:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0, function(arg0)
		setImageSprite(arg0.indexBtn, arg0, true)
	end)

	local var1 = arg0.contextData.sortData

	;(function()
		arg0.loadEquipmentVOs = {}

		local var0 = {}

		for iter0, iter1 in pairs(arg0.equipmentVOs) do
			table.insert(var0, iter1)
		end

		for iter2, iter3 in pairs(var0) do
			if arg0:checkFitBusyCondition(iter3) and IndexConst.filterSpWeaponByType(iter3, arg0.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter3, arg0.contextData.indexDatas.rarityIndex) and (arg0.filterImportance == nil or iter3:IsImportant()) then
				table.insert(arg0.loadEquipmentVOs, iter3)
			end
		end

		if var1 then
			local var1 = arg0.asc

			table.sort(arg0.loadEquipmentVOs, CompareFuncs(var1.sortFunc(var1, var1)))
		end

		if arg0.contextData.qiutBtn then
			table.insert(arg0.loadEquipmentVOs, 1, false)
		end
	end)()
	arg0:updateEquipmentCount()
	;(function()
		arg0.showCraftList = {}

		local var0 = {}

		for iter0, iter1 in pairs(arg0.craftList) do
			table.insert(var0, iter1)
		end

		for iter2, iter3 in pairs(var0) do
			if arg0:checkFitBusyCondition(iter3) and IndexConst.filterSpWeaponByType(iter3, arg0.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter3, arg0.contextData.indexDatas.rarityIndex) and (arg0.filterImportance == nil or iter3:IsImportant()) then
				table.insert(arg0.showCraftList, iter3)
			end
		end

		if var1 then
			local var1 = arg0.asc

			table.sort(arg0.showCraftList, CompareFuncs(var1.sortFunc(var1, var1)))
		end
	end)()
	arg0:UpdateCraftCount()
	setImageSprite(arg0:findTF("Image", arg0.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var1.spr), true)
	setActive(arg0.sortImgAsc, arg0.asc)
	setActive(arg0.sortImgDec, not arg0.asc)
end

function var0.InitCraftItem(arg0, arg1)
	local var0 = SpWeaponItemView.New(arg1)

	arg0.craftItems[arg1] = var0
end

function var0.UpdateCraftItem(arg0, arg1, arg2)
	local var0 = arg0.craftItems[arg2]

	assert(var0, "without init item")

	local var1 = arg0.showCraftList[arg1 + 1]

	var0:update(var1)
	onButton(arg0, var0.go, function()
		arg0:emit(SpWeaponStoreHouseMediator.ON_COMPOSITE, var1:GetConfigID())
	end, SFX_PANEL)
end

function var0.ReturnCraftItem(arg0, arg1, arg2)
	local var0 = arg0.craftItems[arg2]

	if var0 then
		removeOnButton(var0.go)
		var0:clear()
	end
end

function var0.UpdateCraftCount(arg0)
	local var0 = arg0.hideCraft and 0 or #arg0.showCraftList

	arg0.craftRect:align(var0)

	local var1 = arg0.craftsGrid:GetComponent(typeof(GridLayoutGroup))
	local var2 = var1.padding

	if var0 > 0 then
		var2.top = 31
		var2.bottom = 25
	else
		var2.top = 0
		var2.bottom = 0
	end

	var1.padding = var2
end

function var0.GetShowBusyFlag(arg0)
	return arg0.isEquipingOn
end

function var0.SetShowBusyFlag(arg0, arg1)
	arg0.isEquipingOn = arg1
end

function var0.checkFitBusyCondition(arg0, arg1)
	return arg0:GetShowBusyFlag() or not arg1:GetShipId()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.topItems, arg0._tf)
end

return var0
