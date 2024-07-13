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

	arg0_2.blurPanel = arg0_2:findTF("blur_panel")
	arg0_2.backBtn = arg0_2:findTF("adapt/top/back_btn", arg0_2.blurPanel)
	arg0_2.topItems = arg0_2:findTF("topItems")
	arg0_2.itemView = arg0_2:findTF("item_scrollview")
	arg0_2.equipmentView = arg0_2:findTF("equipment_scrollview")
	arg0_2.materialtView = arg0_2:findTF("material_scrollview")

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
	arg0_2.itemUsagePanel = ItemUsagePanel.New(arg0_2:findTF("item_usage_panel"), arg0_2._tf)
	arg0_2.itemResetPanel = ItemResetPanel.New(arg0_2:findTF("reset_info_panel"), arg0_2._tf)
	arg0_2.assignedItemView = WorldAssignedItemView.New(arg0_2._tf, arg0_2.event)
	arg0_2.itemCards = {}
	arg0_2.equipmetItems = {}
	arg0_2.materialCards = {}
	arg0_2._itemToggle = arg0_2:findTF("topItems/bottom_back/types/properties")
	arg0_2._weaponToggle = arg0_2:findTF("topItems/bottom_back/types/siren_weapon")
	arg0_2._materialToggle = arg0_2:findTF("topItems/bottom_back/types/material")
	arg0_2.exchangeTips = arg0_2:findTF("topItems/bottom_back/reset_exchange")
	arg0_2.filterBusyToggle = arg0_2:findTF("adapt/left_length/frame/toggle_equip", arg0_2.blurPanel)
	arg0_2.sortBtn = arg0_2:findTF("adapt/top/buttons/sort_button", arg0_2.blurPanel)
	arg0_2.indexBtn = arg0_2:findTF("adapt/top/buttons/index_button", arg0_2.blurPanel)
	arg0_2.decBtn = arg0_2:findTF("adapt/top/buttons/dec_btn", arg0_2.blurPanel)
	arg0_2.upOrderTF = arg0_2:findTF("asc", arg0_2.decBtn)
	arg0_2.downOrderTF = arg0_2:findTF("desc", arg0_2.decBtn)
	arg0_2.sortPanel = arg0_2:findTF("sort", arg0_2.topItems)
	arg0_2.sortContain = arg0_2:findTF("adapt/mask/panel", arg0_2.sortPanel)
	arg0_2.sortTpl = arg0_2:findTF("tpl", arg0_2.sortContain)

	setActive(arg0_2.sortTpl, false)
	arg0_2:initData()
	arg0_2:addListener()
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
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf, {
		groupName = arg0_4:getGroupNameFromData()
	})
end

function var0_0.OverlayPanel(arg0_6, arg1_6)
	arg0_6.overlayIndex = arg0_6.overlayIndex or 0
	arg0_6.overlayIndex = arg0_6.overlayIndex + 1

	setParent(tf(arg1_6), arg0_6._tf.parent, false)
	tf(arg1_6):SetSiblingIndex(arg0_6._tf:GetSiblingIndex() + arg0_6.overlayIndex)
end

function var0_0.UnOverlayPanel(arg0_7, arg1_7, arg2_7)
	setParent(tf(arg1_7), arg2_7, false)

	arg0_7.overlayIndex = arg0_7.overlayIndex or 0
	arg0_7.overlayIndex = arg0_7.overlayIndex - 1
	arg0_7.overlayIndex = math.max(arg0_7.overlayIndex, 0)
end

function var0_0.onBackPressed(arg0_8)
	if isActive(arg0_8.itemResetPanel._go) then
		arg0_8.itemResetPanel:Close()
	elseif isActive(arg0_8.itemUsagePanel._go) then
		arg0_8.itemUsagePanel:Close()
	elseif arg0_8.assignedItemView:isShowing() then
		arg0_8.assignedItemView:Hide()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_8.backBtn)
	end
end

function var0_0.willExit(arg0_9)
	arg0_9.assignedItemView:Destroy()
	arg0_9.inventoryProxy:RemoveListener(WorldInventoryProxy.EventUpdateItem, arg0_9.itemUpdateListenerFunc)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9._tf)
end

function var0_0.initData(arg0_10)
	arg0_10.contextData.pageNum = arg0_10.contextData.pageNum or var0_0.PAGE.Property
	arg0_10.contextData.asc = arg0_10.contextData.asc or false

	if not arg0_10.contextData.sortData then
		arg0_10.contextData.sortData = var1_0.sort[1]
	end

	arg0_10.contextData.indexDatas = arg0_10.contextData.indexDatas or {}
	arg0_10.isEquipingOn = false
end

function var0_0.GetShowBusyFlag(arg0_11)
	return arg0_11.isEquipingOn
end

function var0_0.SetShowBusyFlag(arg0_12, arg1_12)
	arg0_12.isEquipingOn = arg1_12
end

function var0_0.addListener(arg0_13)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:closeView()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.decBtn, function()
		arg0_13.contextData.asc = not arg0_13.contextData.asc

		if arg0_13.contextData.pageNum == var0_0.PAGE.Equipment then
			arg0_13:filterEquipment()
		end
	end, SFX_PANEL)

	arg0_13.sortButtons = {}

	eachChild(arg0_13.sortContain, function(arg0_16)
		setActive(arg0_16, false)
	end)

	for iter0_13, iter1_13 in ipairs(var1_0.sort) do
		local var0_13 = iter0_13 <= arg0_13.sortContain.childCount and arg0_13.sortContain:GetChild(iter0_13 - 1) or cloneTplTo(arg0_13.sortTpl, arg0_13.sortContain)

		setActive(var0_13, true)
		setImageSprite(findTF(var0_13, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1_13.spr), true)
		onToggle(arg0_13, var0_13, function(arg0_17)
			if arg0_17 then
				arg0_13.contextData.sortData = iter1_13

				arg0_13:filterEquipment()
				triggerToggle(arg0_13.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0_13.sortButtons[iter0_13] = var0_13
	end

	onToggle(arg0_13, arg0_13.sortBtn, function(arg0_18)
		if arg0_18 then
			arg0_13:OverlayPanel(arg0_13.sortPanel)
			setActive(arg0_13.sortPanel, true)
		else
			arg0_13:UnOverlayPanel(arg0_13.sortPanel, arg0_13.topItems)
			setActive(arg0_13.sortPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.sortPanel, function()
		triggerToggle(arg0_13.sortBtn, false)
	end, SFX_PANEL)
	onToggle(arg0_13, arg0_13.filterBusyToggle, function(arg0_20)
		arg0_13:SetShowBusyFlag(arg0_20)

		if arg0_13.contextData.pageNum == var0_0.PAGE.Equipment then
			arg0_13:filterEquipment()
		end
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.indexBtn, function()
		local var0_21 = {
			indexDatas = Clone(arg0_13.contextData.indexDatas),
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
			callback = function(arg0_22)
				arg0_13.contextData.indexDatas.typeIndex = arg0_22.typeIndex
				arg0_13.contextData.indexDatas.equipPropertyIndex = arg0_22.equipPropertyIndex
				arg0_13.contextData.indexDatas.equipPropertyIndex2 = arg0_22.equipPropertyIndex2
				arg0_13.contextData.indexDatas.equipAmmoIndex1 = arg0_22.equipAmmoIndex1
				arg0_13.contextData.indexDatas.equipAmmoIndex2 = arg0_22.equipAmmoIndex2
				arg0_13.contextData.indexDatas.equipCampIndex = arg0_22.equipCampIndex
				arg0_13.contextData.indexDatas.rarityIndex = arg0_22.rarityIndex
				arg0_13.contextData.indexDatas.extraIndex = arg0_22.extraIndex

				if arg0_13.filterBusyToggle:GetComponent(typeof(Toggle)) then
					if bit.band(arg0_22.extraIndex, IndexConst.EquipmentExtraEquiping) > 0 then
						arg0_13:SetShowBusyFlag(true)
					end

					triggerToggle(arg0_13.filterBusyToggle, arg0_13:GetShowBusyFlag())
				else
					arg0_13:filterEquipment()
				end
			end
		}

		arg0_13:emit(WorldInventoryMediator.OPEN_EQUIPMENT_INDEX, var0_21)
	end, SFX_PANEL)
	onToggle(arg0_13, arg0_13._itemToggle, function(arg0_23)
		if arg0_23 and arg0_13.contextData.pageNum ~= var0_0.PAGE.Property then
			arg0_13.contextData.pageNum = var0_0.PAGE.Property

			arg0_13:activeResetExchange(arg0_13.contextData.pageNum == var0_0.PAGE.Property)
			arg0_13:sortItems()
		end
	end, SFX_PANEL)
	onToggle(arg0_13, arg0_13._weaponToggle, function(arg0_24)
		if arg0_24 and arg0_13.contextData.pageNum ~= var0_0.PAGE.Equipment then
			arg0_13.contextData.pageNum = var0_0.PAGE.Equipment

			arg0_13:activeResetExchange(arg0_13.contextData.pageNum == var0_0.PAGE.Property)
			arg0_13:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0_13, arg0_13._materialToggle, function(arg0_25)
		if arg0_25 and arg0_13.contextData.pageNum ~= var0_0.PAGE.Material then
			arg0_13.contextData.pageNum = var0_0.PAGE.Material

			arg0_13:activeResetExchange(arg0_13.contextData.pageNum == var0_0.PAGE.Property)
			arg0_13:SortMaterials()
		end
	end, SFX_PANEL)
end

function var0_0.setWorldFleet(arg0_26, arg1_26)
	arg0_26.worldFleetList = arg1_26
end

function var0_0.setInventoryProxy(arg0_27, arg1_27)
	arg0_27.inventoryProxy = arg1_27

	arg0_27.inventoryProxy:AddListener(WorldInventoryProxy.EventUpdateItem, arg0_27.itemUpdateListenerFunc)
	arg0_27:setItemList(arg0_27.inventoryProxy:GetItemList())
end

function var0_0.setItemList(arg0_28, arg1_28)
	arg0_28.itemList = arg1_28

	if arg0_28.isInitItems then
		arg0_28:sortItems()
	end
end

function var0_0.initItems(arg0_29)
	arg0_29.isInitItems = true
	arg0_29.itemRect = arg0_29.itemView:GetComponent("LScrollRect")

	function arg0_29.itemRect.onInitItem(arg0_30)
		arg0_29:initItem(arg0_30)
	end

	function arg0_29.itemRect.onUpdateItem(arg0_31, arg1_31)
		arg0_29:updateItem(arg0_31, arg1_31)
	end

	function arg0_29.itemRect.onReturnItem(arg0_32, arg1_32)
		arg0_29:returnItem(arg0_32, arg1_32)
	end
end

function var0_0.initItem(arg0_33, arg1_33)
	local var0_33 = WSInventoryItem.New(arg1_33)

	onButton(arg0_33, var0_33.go, function()
		local var0_34 = var0_33.itemVO:getWorldItemType()

		if var0_34 == WorldItem.UsageBuff or var0_34 == WorldItem.UsageHPRegenerate or var0_34 == WorldItem.UsageHPRegenerateValue then
			arg0_33:emit(WorldInventoryMediator.OnOpenAllocateLayer, {
				itemVO = var0_33.itemVO,
				fleetList = arg0_33.worldFleetList,
				fleetIndex = arg0_33.contextData.currentFleetIndex,
				confirmCallback = function(arg0_35, arg1_35)
					arg0_33:emit(WorldInventoryMediator.OnUseItem, arg0_35, 1, arg1_35)
				end,
				onResetInfo = function(arg0_36)
					arg0_33.itemResetPanel:Open(arg0_36)
				end
			})
		elseif var0_34 == WorldItem.UsageWorldMap then
			arg0_33.itemUsagePanel:Open({
				item = var0_33.itemVO,
				mode = ItemUsagePanel.SEE,
				onUse = function()
					arg0_33:PlayOpenBox(var0_33.itemVO:getWorldItemOpenDisplay(), function()
						arg0_33:emit(WorldInventoryMediator.OnMap, var0_33.itemVO.id)
						arg0_33:closeView()
					end)
				end,
				onResetInfo = function(arg0_39)
					arg0_33.itemResetPanel:Open(arg0_39)
				end
			})
		elseif var0_34 == WorldItem.UsageDrop or var0_34 == WorldItem.UsageRecoverAp or var0_34 == WorldItem.UsageWorldItem or var0_34 == WorldItem.UsageWorldBuff then
			arg0_33.itemUsagePanel:Open({
				item = var0_33.itemVO,
				mode = ItemUsagePanel.BATCH,
				onUseBatch = function(arg0_40)
					arg0_33:emit(WorldInventoryMediator.OnUseItem, var0_33.itemVO.id, arg0_40, {})
				end,
				onUseOne = function()
					arg0_33:emit(WorldInventoryMediator.OnUseItem, var0_33.itemVO.id, 1, {})
				end,
				onResetInfo = function(arg0_42)
					arg0_33.itemResetPanel:Open(arg0_42)
				end
			})
		elseif var0_34 == WorldItem.UsageLoot then
			arg0_33.itemUsagePanel:Open({
				item = var0_33.itemVO,
				mode = ItemUsagePanel.INFO,
				onResetInfo = function(arg0_43)
					arg0_33.itemResetPanel:Open(arg0_43)
				end
			})
		elseif var0_34 == WorldItem.UsageWorldClean or var0_34 == WorldItem.UsageWorldFlag then
			arg0_33.itemUsagePanel:Open({
				item = var0_33.itemVO,
				onUse = function()
					arg0_33:emit(WorldInventoryMediator.OnUseItem, var0_33.itemVO.id, 1, {})
				end,
				onResetInfo = function(arg0_45)
					arg0_33.itemResetPanel:Open(arg0_45)
				end
			})
		elseif var0_34 == WorldItem.UsageDropAppointed then
			arg0_33.assignedItemView:Load()
			arg0_33.assignedItemView:ActionInvoke("update", var0_33.itemVO)
			arg0_33.assignedItemView:ActionInvoke("Show")
		end
	end, SFX_PANEL)

	arg0_33.itemCards[arg1_33] = var0_33
end

function var0_0.updateItem(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg0_46.itemCards[arg2_46]

	if not var0_46 then
		arg0_46:initItem(arg2_46)

		var0_46 = arg0_46.itemCards[arg2_46]
	end

	local var1_46 = arg0_46.itemList[arg1_46 + 1]

	var0_46:update(var1_46)
end

function var0_0.returnItem(arg0_47, arg1_47, arg2_47)
	if arg0_47.exited then
		return
	end

	local var0_47 = arg0_47.itemCards[arg2_47]

	if var0_47 then
		var0_47:clear()
	end
end

function var0_0.sortItems(arg0_48)
	table.sort(arg0_48.itemList, CompareFuncs({
		function(arg0_49)
			return -arg0_49:getConfig("sort_priority")
		end,
		function(arg0_50)
			return arg0_50:getConfig("id")
		end
	}))
	arg0_48.itemRect:SetTotalCount(#arg0_48.itemList, -1)
	arg0_48:updateResetExchange()
end

function var0_0.updateResetExchange(arg0_51)
	local var0_51 = arg0_51.inventoryProxy:CalcResetExchangeResource()

	setText(arg0_51.exchangeTips:Find("capcity/Text"), defaultValue(checkExist(var0_51, {
		DROP_TYPE_RESOURCE
	}, {
		WorldConst.ResourceID
	}), 0))
end

function var0_0.activeResetExchange(arg0_52, arg1_52)
	local var0_52 = nowWorld():IsSystemOpen(WorldConst.SystemResetExchange)

	setActive(arg0_52.exchangeTips, var0_52 and arg1_52)
end

function var0_0.PlayOpenBox(arg0_53, arg1_53, arg2_53)
	if not arg1_53 or arg1_53 == "" then
		arg2_53()

		return
	end

	local function var0_53()
		if arg0_53.playing or not arg0_53[arg1_53] then
			return
		end

		arg0_53.playing = true

		arg0_53[arg1_53]:SetActive(true)

		local var0_54 = tf(arg0_53[arg1_53])

		var0_54:SetParent(arg0_53._tf, false)
		var0_54:SetAsLastSibling()

		local var1_54 = var0_54:GetComponent("DftAniEvent")

		var1_54:SetTriggerEvent(function(arg0_55)
			arg2_53()
		end)
		var1_54:SetEndEvent(function(arg0_56)
			if arg0_53[arg1_53] then
				SetActive(arg0_53[arg1_53], false)

				arg0_53.playing = false
			end
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_EQUIPMENT_OPEN)
	end

	local var1_53 = arg0_53:findTF(arg1_53 .. "(Clone)")

	if var1_53 then
		arg0_53[arg1_53] = go(var1_53)
	end

	if not arg0_53[arg1_53] then
		PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(arg1_53), "", true, function(arg0_57)
			arg0_57:SetActive(true)

			arg0_53[arg1_53] = arg0_57

			var0_53()
		end)
	else
		var0_53()
	end
end

function var0_0.setEquipments(arg0_58, arg1_58)
	arg0_58.equipmentVOs = arg1_58
end

function var0_0.setEquipment(arg0_59, arg1_59)
	local var0_59 = #arg0_59.equipmentVOs + 1

	for iter0_59, iter1_59 in ipairs(arg0_59.equipmentVOs) do
		if not iter1_59.shipId and iter1_59.id == arg1_59.id then
			var0_59 = iter0_59

			break
		end
	end

	if arg1_59.count > 0 then
		arg0_59.equipmentVOs[var0_59] = arg1_59
	else
		table.remove(arg0_59.equipmentVOs, var0_59)
	end

	if arg0_59.contextData.pageNum == var0_0.PAGE.Equipment then
		arg0_59:filterEquipment()
	end
end

function var0_0.initEquipments(arg0_60)
	arg0_60.isInitWeapons = true
	arg0_60.equipmentRect = arg0_60.equipmentView:GetComponent("LScrollRect")

	function arg0_60.equipmentRect.onInitItem(arg0_61)
		arg0_60:initEquipment(arg0_61)
	end

	function arg0_60.equipmentRect.onUpdateItem(arg0_62, arg1_62)
		arg0_60:updateEquipment(arg0_62, arg1_62)
	end

	function arg0_60.equipmentRect.onReturnItem(arg0_63, arg1_63)
		arg0_60:returnEquipment(arg0_63, arg1_63)
	end

	arg0_60.equipmentRect.decelerationRate = 0.07
end

function var0_0.initEquipment(arg0_64, arg1_64)
	local var0_64 = EquipmentItem.New(arg1_64)

	onButton(arg0_64, var0_64.go, function()
		if arg0_64.equipmentRect.GetContentAnchoredPositionOriginal then
			arg0_64.contextData.equipScrollPos = arg0_64.equipmentRect:GetContentAnchoredPositionOriginal()
		end

		if var0_64.equipmentVO == nil or var0_64.equipmentVO.mask then
			return
		end

		local var0_65 = arg0_64.shipVO and {
			type = EquipmentInfoMediator.TYPE_REPLACE,
			equipmentId = var0_64.equipmentVO.id,
			shipId = arg0_64.contextData.shipId,
			pos = arg0_64.contextData.pos,
			oldShipId = var0_64.equipmentVO.shipId,
			oldPos = var0_64.equipmentVO.shipPos
		} or var0_64.equipmentVO.shipId and {
			type = EquipmentInfoMediator.TYPE_DISPLAY,
			equipmentId = var0_64.equipmentVO.id,
			shipId = var0_64.equipmentVO.shipId,
			pos = var0_64.equipmentVO.shipPos
		} or {
			destroy = true,
			type = EquipmentInfoMediator.TYPE_DEFAULT,
			equipmentId = var0_64.equipmentVO.id
		}

		arg0_64:emit(var0_0.ON_EQUIPMENT, var0_65)
	end, SFX_PANEL)

	arg0_64.equipmetItems[arg1_64] = var0_64
end

function var0_0.updateEquipment(arg0_66, arg1_66, arg2_66)
	local var0_66 = arg0_66.equipmetItems[arg2_66]

	if not var0_66 then
		arg0_66:initEquipment(arg2_66)

		var0_66 = arg0_66.equipmetItems[arg2_66]
	end

	local var1_66 = arg0_66.loadEquipmentVOs[arg1_66 + 1]

	var0_66:update(var1_66)
end

function var0_0.returnEquipment(arg0_67, arg1_67, arg2_67)
	if arg0_67.exited then
		return
	end

	local var0_67 = arg0_67.equipmetItems[arg2_67]

	if var0_67 then
		var0_67:clear()
	end
end

function var0_0.filterEquipment(arg0_68)
	local var0_68 = arg0_68.contextData.sortData

	arg0_68.loadEquipmentVOs = arg0_68.loadEquipmentVOs or {}

	table.clean(arg0_68.loadEquipmentVOs)

	local var1_68 = arg0_68.loadEquipmentVOs
	local var2_68 = {
		arg0_68.contextData.indexDatas.equipPropertyIndex,
		arg0_68.contextData.indexDatas.equipPropertyIndex2
	}

	for iter0_68, iter1_68 in pairs(arg0_68.equipmentVOs) do
		if (not iter1_68.shipId or arg0_68:GetShowBusyFlag()) and not iter1_68.isSkin and IndexConst.filterEquipByType(iter1_68, arg0_68.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(iter1_68, var2_68) and IndexConst.filterEquipAmmo1(iter1_68, arg0_68.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(iter1_68, arg0_68.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(iter1_68, arg0_68.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(iter1_68, arg0_68.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(iter1_68, arg0_68.contextData.indexDatas.extraIndex) then
			table.insert(arg0_68.loadEquipmentVOs, iter1_68)
		end
	end

	if var0_68 then
		local var3_68 = arg0_68.contextData.asc

		table.sort(var1_68, CompareFuncs(var1_0.sortFunc(var0_68, var3_68)))
	end

	arg0_68:updateEquipmentCount()
	setImageSprite(arg0_68:findTF("Image", arg0_68.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var0_68.spr), true)
	setActive(arg0_68.downOrderTF, not arg0_68.contextData.asc)
	setActive(arg0_68.upOrderTF, arg0_68.contextData.asc)
end

function var0_0.updateEquipmentCount(arg0_69, arg1_69)
	arg0_69.equipmentRect:SetTotalCount(arg1_69 or #arg0_69.loadEquipmentVOs, -1)
	Canvas.ForceUpdateCanvases()
end

function var0_0.Scroll2Equip(arg0_70, arg1_70)
	if arg0_70.contextData.pageNum ~= var0_0.PAGE.Equipment then
		return
	end

	for iter0_70, iter1_70 in ipairs(arg0_70.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_70, arg1_70) then
			local var0_70 = arg0_70.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup))
			local var1_70 = (var0_70.cellSize.y + var0_70.spacing.y) * math.floor((iter0_70 - 1) / var0_70.constraintCount) + arg0_70.equipmentRect.paddingFront + arg0_70.equipmentView.rect.height * 0.5

			arg0_70:ScrollEquipPos(var1_70 - arg0_70.equipmentRect.paddingFront)

			break
		end
	end
end

function var0_0.ScrollEquipPos(arg0_71, arg1_71)
	local var0_71 = arg0_71.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1_71 = (var0_71.cellSize.y + var0_71.spacing.y) * math.ceil(#arg0_71.loadEquipmentVOs / var0_71.constraintCount) - var0_71.spacing.y + arg0_71.equipmentRect.paddingFront + arg0_71.equipmentRect.paddingEnd
	local var2_71 = var1_71 - arg0_71.equipmentView.rect.height

	var2_71 = var2_71 > 0 and var2_71 or var1_71

	local var3_71 = (arg1_71 - arg0_71.equipmentView.rect.height * 0.5) / var2_71

	arg0_71.equipmentRect:ScrollTo(var3_71)
end

function var0_0.SetMaterials(arg0_72, arg1_72)
	arg0_72.materials = arg1_72

	if arg0_72.isInitMaterials and arg0_72.contextData.pageNum == var0_0.PAGE.Material then
		arg0_72:SortMaterials()
	end
end

function var0_0.InitMaterials(arg0_73)
	arg0_73.isInitMaterials = true
	arg0_73.materialRect = arg0_73.materialtView:GetComponent("LScrollRect")

	function arg0_73.materialRect.onInitItem(arg0_74)
		arg0_73:InitMaterial(arg0_74)
	end

	function arg0_73.materialRect.onUpdateItem(arg0_75, arg1_75)
		arg0_73:UpdateMaterial(arg0_75, arg1_75)
	end

	function arg0_73.materialRect.onReturnItem(arg0_76, arg1_76)
		arg0_73:ReturnMaterial(arg0_76, arg1_76)
	end

	arg0_73.materialRect.decelerationRate = 0.07
end

function var0_0.SortMaterials(arg0_77)
	table.sort(arg0_77.materials, CompareFuncs({
		function(arg0_78)
			return -arg0_78:getConfig("rarity")
		end,
		function(arg0_79)
			return arg0_79.id
		end
	}))
	arg0_77.materialRect:SetTotalCount(#arg0_77.materials, -1)
	Canvas.ForceUpdateCanvases()
end

function var0_0.InitMaterial(arg0_80, arg1_80)
	local var0_80 = ItemCard.New(arg1_80)

	onButton(arg0_80, var0_80.go, function()
		if var0_80.itemVO == nil then
			return
		end

		if var0_80.itemVO:getConfig("type") == Item.INVITATION_TYPE then
			arg0_80:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = var0_80.itemVO
			})
		else
			arg0_80:emit(var0_0.ON_ITEM, var0_80.itemVO.id)
		end
	end, SFX_PANEL)

	arg0_80.materialCards[arg1_80] = var0_80
end

function var0_0.UpdateMaterial(arg0_82, arg1_82, arg2_82)
	local var0_82 = arg0_82.materialCards[arg2_82]

	if not var0_82 then
		arg0_82:initItem(arg2_82)

		var0_82 = arg0_82.materialCards[arg2_82]
	end

	local var1_82 = arg0_82.materials[arg1_82 + 1]

	var0_82:update(var1_82)
end

function var0_0.ReturnMaterial(arg0_83, arg1_83, arg2_83)
	if arg0_83.exited then
		return
	end

	local var0_83 = arg0_83.materialCards[arg2_83]

	if var0_83 then
		var0_83:clear()
	end
end

return var0_0
