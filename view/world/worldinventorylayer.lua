local var0_0 = class("WorldInventoryLayer", import("..base.BaseUI"))
local var1_0 = require("view.equipment.EquipmentSortCfg")

var0_0.PAGE = {
	Equipment = 2,
	Property = 1,
	Material = 3
}

function var0_0.getUIName(arg0_1)
	return "WorldInventoryUI"
end

function var0_0.init(arg0_2)
	function arg0_2.itemUpdateListenerFunc(...)
		arg0_2:setItemList(arg0_2.inventoryProxy:GetItemList())
	end

	arg0_2.blurPanel = arg0_2._tf:Find("adapt/blur_panel")
	arg0_2.backBtn = arg0_2.blurPanel:Find("adapt/top/back_btn")
	arg0_2.topItems = arg0_2._tf:Find("adapt/topItems")
	arg0_2.itemView = arg0_2._tf:Find("adapt/item_scrollview")
	arg0_2.equipmentView = arg0_2._tf:Find("adapt/equipment_scrollview")
	arg0_2.materialtView = arg0_2._tf:Find("adapt/material_scrollview")

	local var0_2
	local var1_2 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var1_2:CheckLargeScreen() then
		var0_2 = arg0_2.itemView.rect.width > 2000
	else
		var0_2 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0_2.itemView:Find("Viewport/item_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var0_2 and 8 or 7
	arg0_2.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var0_2 and 8 or 7
	arg0_2.materialtView:Find("Viewport/item_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var0_2 and 8 or 7
	arg0_2.itemUsagePanel = ItemUsagePanel.New(arg0_2._tf:Find("adapt/item_usage_panel"), arg0_2._tf:Find("adapt"))
	arg0_2.itemResetPanel = ItemResetPanel.New(arg0_2._tf:Find("adapt/reset_info_panel"), arg0_2._tf:Find("adapt"))
	arg0_2.assignedItemView = WorldAssignedItemView.New(arg0_2._tf:Find("adapt"), arg0_2.event)
	arg0_2.itemCards = {}
	arg0_2.equipmetItems = {}
	arg0_2.materialCards = {}
	arg0_2._itemToggle = arg0_2.topItems:Find("bottom_back/types/properties")
	arg0_2._weaponToggle = arg0_2.topItems:Find("bottom_back/types/siren_weapon")
	arg0_2._materialToggle = arg0_2.topItems:Find("bottom_back/types/material")
	arg0_2.exchangeTips = arg0_2.topItems:Find("bottom_back/reset_exchange")

	setText(arg0_2.topItems:Find("bottom_back/reset_exchange/Text"), i18n("world_inventory_tip"))

	arg0_2.filterBusyToggle = arg0_2.blurPanel:Find("adapt/left_length/frame/toggle_equip")
	arg0_2.sortBtn = arg0_2.blurPanel:Find("adapt/top/buttons/sort_button")
	arg0_2.indexBtn = arg0_2.blurPanel:Find("adapt/top/buttons/index_button")
	arg0_2.decBtn = arg0_2.blurPanel:Find("adapt/top/buttons/dec_btn")
	arg0_2.upOrderTF = arg0_2.decBtn:Find("asc")
	arg0_2.downOrderTF = arg0_2.decBtn:Find("desc")
	arg0_2.sortPanel = arg0_2.topItems:Find("sort")
	arg0_2.sortContain = arg0_2.sortPanel:Find("adapt/mask/panel")
	arg0_2.sortTpl = arg0_2.sortContain:Find("tpl")

	setActive(arg0_2.sortTpl, false)
	arg0_2:initData()
	arg0_2:addListener()
	print(arg0_2._tf:Find("bg").rect.width)
end

function var0_0.didEnter(arg0_4)
	arg0_4:initItems()
	arg0_4:initEquipments()
	arg0_4:InitMaterials()
	setActive(arg0_4._weaponToggle, true)
	setActive(arg0_4._itemToggle, true)

	local var0_4 = arg0_4.contextData.pageNum

	arg0_4.contextData.pageNum = nil

	if var0_4 == var0_0.PAGE.Property then
		triggerToggle(arg0_4._itemToggle, true)
	elseif var0_4 == var0_0.PAGE.Equipment then
		triggerToggle(arg0_4._weaponToggle, true)
	elseif var0_4 == var0_0.PAGE.Material then
		triggerToggle(arg0_4._materialToggle, true)
	end

	if arg0_4.contextData.equipScrollPos then
		arg0_4:ScrollEquipPos(arg0_4.contextData.equipScrollPos.y)
	end

	onButton(arg0_4, arg0_4.exchangeTips:Find("capcity"), function()
		arg0_4:emit(var0_0.ON_DROP, {
			type = DROP_TYPE_RESOURCE,
			id = WorldConst.ResourceID
		})
	end, SFX_PANEL)
	arg0_4:OverlayPanel(arg0_4._tf)
end

function var0_0.onBackPressed(arg0_6)
	print(arg0_6._tf:Find("bg").rect.width)

	if isActive(arg0_6.itemResetPanel._go) then
		arg0_6.itemResetPanel:Close()
	elseif isActive(arg0_6.itemUsagePanel._go) then
		arg0_6.itemUsagePanel:Close()
	elseif arg0_6.assignedItemView:isShowing() then
		arg0_6.assignedItemView:Hide()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_6.backBtn)
	end
end

function var0_0.willExit(arg0_7)
	arg0_7.assignedItemView:Destroy()
	arg0_7.inventoryProxy:RemoveListener(WorldInventoryProxy.EventUpdateItem, arg0_7.itemUpdateListenerFunc)
	arg0_7:UnOverlayPanel(arg0_7._tf)
end

function var0_0.initData(arg0_8)
	arg0_8.contextData.pageNum = arg0_8.contextData.pageNum or var0_0.PAGE.Property
	arg0_8.contextData.asc = arg0_8.contextData.asc or false

	if not arg0_8.contextData.sortData then
		arg0_8.contextData.sortData = var1_0.sort[1]
	end

	arg0_8.contextData.indexDatas = arg0_8.contextData.indexDatas or {}
	arg0_8.isEquipingOn = false
end

function var0_0.GetShowBusyFlag(arg0_9)
	return arg0_9.isEquipingOn
end

function var0_0.SetShowBusyFlag(arg0_10, arg1_10)
	arg0_10.isEquipingOn = arg1_10
end

function var0_0.addListener(arg0_11)
	onButton(arg0_11, arg0_11.backBtn, function()
		print(arg0_11._tf:Find("bg").rect.width)
		arg0_11:closeView()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.decBtn, function()
		arg0_11.contextData.asc = not arg0_11.contextData.asc

		if arg0_11.contextData.pageNum == var0_0.PAGE.Equipment then
			arg0_11:filterEquipment()
		end
	end, SFX_PANEL)

	arg0_11.sortButtons = {}

	eachChild(arg0_11.sortContain, function(arg0_14)
		setActive(arg0_14, false)
	end)

	for iter0_11, iter1_11 in ipairs(var1_0.sort) do
		local var0_11 = iter0_11 <= arg0_11.sortContain.childCount and arg0_11.sortContain:GetChild(iter0_11 - 1) or cloneTplTo(arg0_11.sortTpl, arg0_11.sortContain)

		setActive(var0_11, true)
		setImageSprite(findTF(var0_11, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1_11.spr), true)
		onToggle(arg0_11, var0_11, function(arg0_15)
			if arg0_15 then
				arg0_11.contextData.sortData = iter1_11

				arg0_11:filterEquipment()
				triggerToggle(arg0_11.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0_11.sortButtons[iter0_11] = var0_11
	end

	onToggle(arg0_11, arg0_11.sortBtn, function(arg0_16)
		if arg0_16 then
			arg0_11:OverlayPanel(arg0_11.sortPanel)
			setActive(arg0_11.sortPanel, true)
		else
			arg0_11:UnOverlayPanel(arg0_11.sortPanel, arg0_11.topItems)
			setActive(arg0_11.sortPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.sortPanel, function()
		triggerToggle(arg0_11.sortBtn, false)
	end, SFX_PANEL)
	onToggle(arg0_11, arg0_11.filterBusyToggle, function(arg0_18)
		arg0_11:SetShowBusyFlag(arg0_18)

		if arg0_11.contextData.pageNum == var0_0.PAGE.Equipment then
			arg0_11:filterEquipment()
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.indexBtn, function()
		local var0_19 = {
			indexDatas = Clone(arg0_11.contextData.indexDatas),
			customPanels = {
				minHeight = 650,
				typeIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipmentTypeIndexs,
					names = IndexConst.EquipmentTypeNames
				},
				equipPropertyIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipPropertyIndexs,
					names = IndexConst.EquipPropertyNames
				},
				equipPropertyIndex2 = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipPropertyIndexs,
					names = IndexConst.EquipPropertyNames
				},
				equipAmmoIndex1 = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipAmmoIndexs_1,
					names = IndexConst.EquipAmmoIndexs_1_Names
				},
				equipAmmoIndex2 = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipAmmoIndexs_2,
					names = IndexConst.EquipAmmoIndexs_2_Names
				},
				equipCampIndex = {
					mode = CustomIndexLayer.Mode.AND,
					options = IndexConst.EquipCampIndexs,
					names = IndexConst.EquipCampNames
				},
				rarityIndex = {
					mode = CustomIndexLayer.Mode.AND,
					options = IndexConst.EquipmentRarityIndexs,
					names = IndexConst.RarityNames
				},
				extraIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipmentExtraIndexs,
					names = IndexConst.EquipmentExtraNames
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
					dropdown = true,
					titleTxt = "indexsort_index",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"equipPropertyIndex",
						"equipPropertyIndex2",
						"equipAmmoIndex1",
						"equipAmmoIndex2"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_camp",
					titleENTxt = "indexsort_campeng",
					tags = {
						"equipCampIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_rarity",
					titleENTxt = "indexsort_rarityeng",
					tags = {
						"rarityIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_extraindex",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"extraIndex"
					}
				}
			},
			dropdownLimit = {
				equipPropertyIndex = {
					include = {
						typeIndex = IndexConst.EquipmentTypeAll
					},
					exclude = {}
				},
				equipPropertyIndex2 = {
					include = {
						typeIndex = IndexConst.EquipmentTypeEquip
					},
					exclude = {
						typeIndex = IndexConst.EquipmentTypeAll
					}
				},
				equipAmmoIndex1 = {
					include = {
						typeIndex = IndexConst.BitAll({
							IndexConst.EquipmentTypeSmallCannon,
							IndexConst.EquipmentTypeMediumCannon,
							IndexConst.EquipmentTypeBigCannon
						})
					},
					exclude = {
						typeIndex = IndexConst.EquipmentTypeAll
					}
				},
				equipAmmoIndex2 = {
					include = {
						typeIndex = IndexConst.BitAll({
							IndexConst.EquipmentTypeWarshipTorpedo,
							IndexConst.EquipmentTypeSubmaraineTorpedo
						})
					},
					exclude = {
						typeIndex = IndexConst.EquipmentTypeAll
					}
				}
			},
			callback = function(arg0_20)
				arg0_11.contextData.indexDatas.typeIndex = arg0_20.typeIndex
				arg0_11.contextData.indexDatas.equipPropertyIndex = arg0_20.equipPropertyIndex
				arg0_11.contextData.indexDatas.equipPropertyIndex2 = arg0_20.equipPropertyIndex2
				arg0_11.contextData.indexDatas.equipAmmoIndex1 = arg0_20.equipAmmoIndex1
				arg0_11.contextData.indexDatas.equipAmmoIndex2 = arg0_20.equipAmmoIndex2
				arg0_11.contextData.indexDatas.equipCampIndex = arg0_20.equipCampIndex
				arg0_11.contextData.indexDatas.rarityIndex = arg0_20.rarityIndex
				arg0_11.contextData.indexDatas.extraIndex = arg0_20.extraIndex

				if arg0_11.filterBusyToggle:GetComponent(typeof(Toggle)) then
					if bit.band(arg0_20.extraIndex, IndexConst.EquipmentExtraEquiping) > 0 then
						arg0_11:SetShowBusyFlag(true)
					end

					triggerToggle(arg0_11.filterBusyToggle, arg0_11:GetShowBusyFlag())
				else
					arg0_11:filterEquipment()
				end
			end
		}

		arg0_11:emit(WorldInventoryMediator.OPEN_EQUIPMENT_INDEX, var0_19)
	end, SFX_PANEL)
	onToggle(arg0_11, arg0_11._itemToggle, function(arg0_21)
		if arg0_21 and arg0_11.contextData.pageNum ~= var0_0.PAGE.Property then
			arg0_11.contextData.pageNum = var0_0.PAGE.Property

			arg0_11:activeResetExchange(arg0_11.contextData.pageNum == var0_0.PAGE.Property)
			arg0_11:sortItems()
		end
	end, SFX_PANEL)
	onToggle(arg0_11, arg0_11._weaponToggle, function(arg0_22)
		if arg0_22 and arg0_11.contextData.pageNum ~= var0_0.PAGE.Equipment then
			arg0_11.contextData.pageNum = var0_0.PAGE.Equipment

			arg0_11:activeResetExchange(arg0_11.contextData.pageNum == var0_0.PAGE.Property)
			arg0_11:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0_11, arg0_11._materialToggle, function(arg0_23)
		if arg0_23 and arg0_11.contextData.pageNum ~= var0_0.PAGE.Material then
			arg0_11.contextData.pageNum = var0_0.PAGE.Material

			arg0_11:activeResetExchange(arg0_11.contextData.pageNum == var0_0.PAGE.Property)
			arg0_11:SortMaterials()
		end
	end, SFX_PANEL)
end

function var0_0.setWorldFleet(arg0_24, arg1_24)
	arg0_24.worldFleetList = arg1_24
end

function var0_0.setInventoryProxy(arg0_25, arg1_25)
	arg0_25.inventoryProxy = arg1_25

	arg0_25.inventoryProxy:AddListener(WorldInventoryProxy.EventUpdateItem, arg0_25.itemUpdateListenerFunc)
	arg0_25:setItemList(arg0_25.inventoryProxy:GetItemList())
end

function var0_0.setItemList(arg0_26, arg1_26)
	arg0_26.itemList = arg1_26

	if arg0_26.isInitItems then
		arg0_26:sortItems()
	end
end

function var0_0.initItems(arg0_27)
	arg0_27.isInitItems = true
	arg0_27.itemRect = arg0_27.itemView:GetComponent("LScrollRect")

	function arg0_27.itemRect.onInitItem(arg0_28)
		arg0_27:initItem(arg0_28)
	end

	function arg0_27.itemRect.onUpdateItem(arg0_29, arg1_29)
		arg0_27:updateItem(arg0_29, arg1_29)
	end

	function arg0_27.itemRect.onReturnItem(arg0_30, arg1_30)
		arg0_27:returnItem(arg0_30, arg1_30)
	end
end

function var0_0.initItem(arg0_31, arg1_31)
	local var0_31 = WSInventoryItem.New(arg1_31)

	onButton(arg0_31, var0_31.go, function()
		local var0_32 = var0_31.itemVO:getWorldItemType()

		if var0_32 == WorldItem.UsageBuff or var0_32 == WorldItem.UsageHPRegenerate or var0_32 == WorldItem.UsageHPRegenerateValue then
			arg0_31:emit(WorldInventoryMediator.OnOpenAllocateLayer, {
				itemVO = var0_31.itemVO,
				fleetList = arg0_31.worldFleetList,
				fleetIndex = arg0_31.contextData.currentFleetIndex,
				confirmCallback = function(arg0_33, arg1_33)
					arg0_31:emit(WorldInventoryMediator.OnUseItem, arg0_33, 1, arg1_33)
				end,
				onResetInfo = function(arg0_34)
					arg0_31.itemResetPanel:Open(arg0_34)
				end
			})
		elseif var0_32 == WorldItem.UsageWorldMap then
			arg0_31.itemUsagePanel:Open({
				item = var0_31.itemVO,
				mode = ItemUsagePanel.SEE,
				onUse = function()
					arg0_31:PlayOpenBox(var0_31.itemVO:getWorldItemOpenDisplay(), function()
						arg0_31:emit(WorldInventoryMediator.OnMap, var0_31.itemVO.id)
						arg0_31:closeView()
					end)
				end,
				onResetInfo = function(arg0_37)
					arg0_31.itemResetPanel:Open(arg0_37)
				end
			})
		elseif var0_32 == WorldItem.UsageDrop or var0_32 == WorldItem.UsageRecoverAp or var0_32 == WorldItem.UsageWorldItem or var0_32 == WorldItem.UsageWorldBuff then
			arg0_31.itemUsagePanel:Open({
				item = var0_31.itemVO,
				mode = ItemUsagePanel.BATCH,
				onUseBatch = function(arg0_38)
					arg0_31:emit(WorldInventoryMediator.OnUseItem, var0_31.itemVO.id, arg0_38, {})
				end,
				onUseOne = function()
					arg0_31:emit(WorldInventoryMediator.OnUseItem, var0_31.itemVO.id, 1, {})
				end,
				onResetInfo = function(arg0_40)
					arg0_31.itemResetPanel:Open(arg0_40)
				end
			})
		elseif var0_32 == WorldItem.UsageLoot then
			arg0_31.itemUsagePanel:Open({
				item = var0_31.itemVO,
				mode = ItemUsagePanel.INFO,
				onResetInfo = function(arg0_41)
					arg0_31.itemResetPanel:Open(arg0_41)
				end
			})
		elseif var0_32 == WorldItem.UsageWorldClean or var0_32 == WorldItem.UsageWorldFlag then
			arg0_31.itemUsagePanel:Open({
				item = var0_31.itemVO,
				onUse = function()
					arg0_31:emit(WorldInventoryMediator.OnUseItem, var0_31.itemVO.id, 1, {})
				end,
				onResetInfo = function(arg0_43)
					arg0_31.itemResetPanel:Open(arg0_43)
				end
			})
		elseif var0_32 == WorldItem.UsageDropAppointed then
			arg0_31.assignedItemView:Load()
			arg0_31.assignedItemView:ActionInvoke("update", var0_31.itemVO)
			arg0_31.assignedItemView:ActionInvoke("Show")
		end
	end, SFX_PANEL)

	arg0_31.itemCards[arg1_31] = var0_31
end

function var0_0.updateItem(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44.itemCards[arg2_44]

	if not var0_44 then
		arg0_44:initItem(arg2_44)

		var0_44 = arg0_44.itemCards[arg2_44]
	end

	local var1_44 = arg0_44.itemList[arg1_44 + 1]

	var0_44:update(var1_44)
end

function var0_0.returnItem(arg0_45, arg1_45, arg2_45)
	if arg0_45.exited then
		return
	end

	local var0_45 = arg0_45.itemCards[arg2_45]

	if var0_45 then
		var0_45:clear()
	end
end

function var0_0.sortItems(arg0_46)
	table.sort(arg0_46.itemList, CompareFuncs({
		function(arg0_47)
			return -arg0_47:getConfig("sort_priority")
		end,
		function(arg0_48)
			return arg0_48:getConfig("id")
		end
	}))
	arg0_46.itemRect:SetTotalCount(#arg0_46.itemList, -1)
	arg0_46:updateResetExchange()
end

function var0_0.updateResetExchange(arg0_49)
	local var0_49 = arg0_49.inventoryProxy:CalcResetExchangeResource()

	setText(arg0_49.exchangeTips:Find("capcity/Text"), defaultValue(checkExist(var0_49, {
		DROP_TYPE_RESOURCE
	}, {
		WorldConst.ResourceID
	}), 0))
end

function var0_0.activeResetExchange(arg0_50, arg1_50)
	local var0_50 = nowWorld():IsSystemOpen(WorldConst.SystemResetExchange)

	setActive(arg0_50.exchangeTips, var0_50 and arg1_50)
end

function var0_0.PlayOpenBox(arg0_51, arg1_51, arg2_51)
	if not arg1_51 or arg1_51 == "" then
		arg2_51()

		return
	end

	local function var0_51()
		if arg0_51.playing or not arg0_51[arg1_51] then
			return
		end

		arg0_51.playing = true

		arg0_51[arg1_51]:SetActive(true)

		local var0_52 = tf(arg0_51[arg1_51])

		var0_52:SetParent(arg0_51._tf:Find("adapt"), false)
		var0_52:SetAsLastSibling()

		local var1_52 = var0_52:GetComponent("DftAniEvent")

		var1_52:SetTriggerEvent(function(arg0_53)
			arg2_51()
		end)
		var1_52:SetEndEvent(function(arg0_54)
			if arg0_51[arg1_51] then
				SetActive(arg0_51[arg1_51], false)

				arg0_51.playing = false
			end
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_EQUIPMENT_OPEN)
	end

	local var1_51 = arg0_51._tf:Find(arg1_51 .. "(Clone)")

	if var1_51 then
		arg0_51[arg1_51] = go(var1_51)
	end

	if not arg0_51[arg1_51] then
		PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(arg1_51), "", true, function(arg0_55)
			arg0_55:SetActive(true)

			arg0_51[arg1_51] = arg0_55

			var0_51()
		end)
	else
		var0_51()
	end
end

function var0_0.setEquipments(arg0_56, arg1_56)
	arg0_56.equipmentVOs = arg1_56
end

function var0_0.setEquipment(arg0_57, arg1_57)
	local var0_57 = #arg0_57.equipmentVOs + 1

	for iter0_57, iter1_57 in ipairs(arg0_57.equipmentVOs) do
		if not iter1_57.shipId and iter1_57.id == arg1_57.id then
			var0_57 = iter0_57

			break
		end
	end

	if arg1_57.count > 0 then
		arg0_57.equipmentVOs[var0_57] = arg1_57
	else
		table.remove(arg0_57.equipmentVOs, var0_57)
	end

	if arg0_57.contextData.pageNum == var0_0.PAGE.Equipment then
		arg0_57:filterEquipment()
	end
end

function var0_0.initEquipments(arg0_58)
	arg0_58.isInitWeapons = true
	arg0_58.equipmentRect = arg0_58.equipmentView:GetComponent("LScrollRect")

	function arg0_58.equipmentRect.onInitItem(arg0_59)
		arg0_58:initEquipment(arg0_59)
	end

	function arg0_58.equipmentRect.onUpdateItem(arg0_60, arg1_60)
		arg0_58:updateEquipment(arg0_60, arg1_60)
	end

	function arg0_58.equipmentRect.onReturnItem(arg0_61, arg1_61)
		arg0_58:returnEquipment(arg0_61, arg1_61)
	end

	arg0_58.equipmentRect.decelerationRate = 0.07
end

function var0_0.initEquipment(arg0_62, arg1_62)
	local var0_62 = EquipmentItem.New(arg1_62)

	onButton(arg0_62, var0_62.go, function()
		if arg0_62.equipmentRect.GetContentAnchoredPositionOriginal then
			arg0_62.contextData.equipScrollPos = arg0_62.equipmentRect:GetContentAnchoredPositionOriginal()
		end

		if var0_62.equipmentVO == nil or var0_62.equipmentVO.mask then
			return
		end

		local var0_63 = arg0_62.shipVO and {
			type = EquipmentInfoMediator.TYPE_REPLACE,
			equipmentId = var0_62.equipmentVO.id,
			shipId = arg0_62.contextData.shipId,
			pos = arg0_62.contextData.pos,
			oldShipId = var0_62.equipmentVO.shipId,
			oldPos = var0_62.equipmentVO.shipPos
		} or var0_62.equipmentVO.shipId and {
			type = EquipmentInfoMediator.TYPE_DISPLAY,
			equipmentId = var0_62.equipmentVO.id,
			shipId = var0_62.equipmentVO.shipId,
			pos = var0_62.equipmentVO.shipPos
		} or {
			destroy = true,
			type = EquipmentInfoMediator.TYPE_DEFAULT,
			equipmentId = var0_62.equipmentVO.id
		}

		arg0_62:emit(var0_0.ON_EQUIPMENT, var0_63)
	end, SFX_PANEL)

	arg0_62.equipmetItems[arg1_62] = var0_62
end

function var0_0.updateEquipment(arg0_64, arg1_64, arg2_64)
	local var0_64 = arg0_64.equipmetItems[arg2_64]

	if not var0_64 then
		arg0_64:initEquipment(arg2_64)

		var0_64 = arg0_64.equipmetItems[arg2_64]
	end

	local var1_64 = arg0_64.loadEquipmentVOs[arg1_64 + 1]

	var0_64:update(var1_64)
end

function var0_0.returnEquipment(arg0_65, arg1_65, arg2_65)
	if arg0_65.exited then
		return
	end

	local var0_65 = arg0_65.equipmetItems[arg2_65]

	if var0_65 then
		var0_65:clear()
	end
end

function var0_0.filterEquipment(arg0_66)
	local var0_66 = arg0_66.contextData.sortData

	arg0_66.loadEquipmentVOs = arg0_66.loadEquipmentVOs or {}

	table.clean(arg0_66.loadEquipmentVOs)

	local var1_66 = arg0_66.loadEquipmentVOs
	local var2_66 = {
		arg0_66.contextData.indexDatas.equipPropertyIndex,
		arg0_66.contextData.indexDatas.equipPropertyIndex2
	}

	for iter0_66, iter1_66 in pairs(arg0_66.equipmentVOs) do
		if (not iter1_66.shipId or arg0_66:GetShowBusyFlag()) and not iter1_66.isSkin and IndexConst.filterEquipByType(iter1_66, arg0_66.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(iter1_66, var2_66) and IndexConst.filterEquipAmmo1(iter1_66, arg0_66.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(iter1_66, arg0_66.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(iter1_66, arg0_66.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(iter1_66, arg0_66.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(iter1_66, arg0_66.contextData.indexDatas.extraIndex) then
			table.insert(arg0_66.loadEquipmentVOs, iter1_66)
		end
	end

	if var0_66 then
		local var3_66 = arg0_66.contextData.asc

		table.sort(var1_66, CompareFuncs(var1_0.sortFunc(var0_66, var3_66)))
	end

	arg0_66:updateEquipmentCount()
	setImageSprite(arg0_66.sortBtn:Find("Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", var0_66.spr), true)
	setActive(arg0_66.downOrderTF, not arg0_66.contextData.asc)
	setActive(arg0_66.upOrderTF, arg0_66.contextData.asc)
end

function var0_0.updateEquipmentCount(arg0_67, arg1_67)
	arg0_67.equipmentRect:SetTotalCount(arg1_67 or #arg0_67.loadEquipmentVOs, -1)
	Canvas.ForceUpdateCanvases()
end

function var0_0.Scroll2Equip(arg0_68, arg1_68)
	if arg0_68.contextData.pageNum ~= var0_0.PAGE.Equipment then
		return
	end

	for iter0_68, iter1_68 in ipairs(arg0_68.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_68, arg1_68) then
			local var0_68 = arg0_68.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup))
			local var1_68 = (var0_68.cellSize.y + var0_68.spacing.y) * math.floor((iter0_68 - 1) / var0_68.constraintCount) + arg0_68.equipmentRect.paddingFront + arg0_68.equipmentView.rect.height * 0.5

			arg0_68:ScrollEquipPos(var1_68 - arg0_68.equipmentRect.paddingFront)

			break
		end
	end
end

function var0_0.ScrollEquipPos(arg0_69, arg1_69)
	local var0_69 = arg0_69.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1_69 = (var0_69.cellSize.y + var0_69.spacing.y) * math.ceil(#arg0_69.loadEquipmentVOs / var0_69.constraintCount) - var0_69.spacing.y + arg0_69.equipmentRect.paddingFront + arg0_69.equipmentRect.paddingEnd
	local var2_69 = var1_69 - arg0_69.equipmentView.rect.height

	var2_69 = var2_69 > 0 and var2_69 or var1_69

	local var3_69 = (arg1_69 - arg0_69.equipmentView.rect.height * 0.5) / var2_69

	arg0_69.equipmentRect:ScrollTo(var3_69)
end

function var0_0.SetMaterials(arg0_70, arg1_70)
	arg0_70.materials = arg1_70

	if arg0_70.isInitMaterials and arg0_70.contextData.pageNum == var0_0.PAGE.Material then
		arg0_70:SortMaterials()
	end
end

function var0_0.InitMaterials(arg0_71)
	arg0_71.isInitMaterials = true
	arg0_71.materialRect = arg0_71.materialtView:GetComponent("LScrollRect")

	function arg0_71.materialRect.onInitItem(arg0_72)
		arg0_71:InitMaterial(arg0_72)
	end

	function arg0_71.materialRect.onUpdateItem(arg0_73, arg1_73)
		arg0_71:UpdateMaterial(arg0_73, arg1_73)
	end

	function arg0_71.materialRect.onReturnItem(arg0_74, arg1_74)
		arg0_71:ReturnMaterial(arg0_74, arg1_74)
	end

	arg0_71.materialRect.decelerationRate = 0.07
end

function var0_0.SortMaterials(arg0_75)
	table.sort(arg0_75.materials, CompareFuncs({
		function(arg0_76)
			return -arg0_76:getConfig("rarity")
		end,
		function(arg0_77)
			return arg0_77.id
		end
	}))
	arg0_75.materialRect:SetTotalCount(#arg0_75.materials, -1)
	Canvas.ForceUpdateCanvases()
end

function var0_0.InitMaterial(arg0_78, arg1_78)
	local var0_78 = ItemCard.New(arg1_78)

	onButton(arg0_78, var0_78.go, function()
		if var0_78.itemVO == nil then
			return
		end

		if var0_78.itemVO:getConfig("type") == Item.INVITATION_TYPE then
			arg0_78:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = var0_78.itemVO
			})
		else
			arg0_78:emit(var0_0.ON_ITEM, var0_78.itemVO.id)
		end
	end, SFX_PANEL)

	arg0_78.materialCards[arg1_78] = var0_78
end

function var0_0.UpdateMaterial(arg0_80, arg1_80, arg2_80)
	local var0_80 = arg0_80.materialCards[arg2_80]

	if not var0_80 then
		arg0_80:initItem(arg2_80)

		var0_80 = arg0_80.materialCards[arg2_80]
	end

	local var1_80 = arg0_80.materials[arg1_80 + 1]

	var0_80:update(var1_80)
end

function var0_0.ReturnMaterial(arg0_81, arg1_81, arg2_81)
	if arg0_81.exited then
		return
	end

	local var0_81 = arg0_81.materialCards[arg2_81]

	if var0_81 then
		var0_81:clear()
	end
end

return var0_0
