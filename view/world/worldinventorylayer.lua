local var0 = class("WorldInventoryLayer", import("..base.BaseUI"))
local var1 = require("view.equipment.EquipmentSortCfg")

var0.PAGE = {
	Equipment = 2,
	Property = 1,
	Material = 3
}

function var0.getUIName(arg0)
	return "WorldInventoryUI"
end

function var0.init(arg0)
	function arg0.itemUpdateListenerFunc(...)
		arg0:setItemList(arg0.inventoryProxy:GetItemList())
	end

	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.backBtn = arg0:findTF("adapt/top/back_btn", arg0.blurPanel)
	arg0.topItems = arg0:findTF("topItems")
	arg0.itemView = arg0:findTF("item_scrollview")
	arg0.equipmentView = arg0:findTF("equipment_scrollview")
	arg0.materialtView = arg0:findTF("material_scrollview")

	local var0
	local var1 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var1:CheckLargeScreen() then
		var0 = arg0.itemView.rect.width > 2000
	else
		var0 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0.itemView:Find("Viewport/item_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var0 and 8 or 7
	arg0.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var0 and 8 or 7
	arg0.materialtView:Find("Viewport/item_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var0 and 8 or 7
	arg0.itemUsagePanel = ItemUsagePanel.New(arg0:findTF("item_usage_panel"), arg0._tf)
	arg0.itemResetPanel = ItemResetPanel.New(arg0:findTF("reset_info_panel"), arg0._tf)
	arg0.assignedItemView = WorldAssignedItemView.New(arg0._tf, arg0.event)
	arg0.itemCards = {}
	arg0.equipmetItems = {}
	arg0.materialCards = {}
	arg0._itemToggle = arg0:findTF("topItems/bottom_back/types/properties")
	arg0._weaponToggle = arg0:findTF("topItems/bottom_back/types/siren_weapon")
	arg0._materialToggle = arg0:findTF("topItems/bottom_back/types/material")
	arg0.exchangeTips = arg0:findTF("topItems/bottom_back/reset_exchange")
	arg0.filterBusyToggle = arg0:findTF("adapt/left_length/frame/toggle_equip", arg0.blurPanel)
	arg0.sortBtn = arg0:findTF("adapt/top/buttons/sort_button", arg0.blurPanel)
	arg0.indexBtn = arg0:findTF("adapt/top/buttons/index_button", arg0.blurPanel)
	arg0.decBtn = arg0:findTF("adapt/top/buttons/dec_btn", arg0.blurPanel)
	arg0.upOrderTF = arg0:findTF("asc", arg0.decBtn)
	arg0.downOrderTF = arg0:findTF("desc", arg0.decBtn)
	arg0.sortPanel = arg0:findTF("sort", arg0.topItems)
	arg0.sortContain = arg0:findTF("adapt/mask/panel", arg0.sortPanel)
	arg0.sortTpl = arg0:findTF("tpl", arg0.sortContain)

	setActive(arg0.sortTpl, false)
	arg0:initData()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:initItems()
	arg0:initEquipments()
	arg0:InitMaterials()
	setActive(arg0._weaponToggle, true)
	setActive(arg0._itemToggle, true)

	local var0 = arg0.contextData.pageNum

	arg0.contextData.pageNum = nil

	if var0 == var0.PAGE.Property then
		triggerToggle(arg0._itemToggle, true)
	elseif var0 == var0.PAGE.Equipment then
		triggerToggle(arg0._weaponToggle, true)
	elseif var0 == var0.PAGE.Material then
		triggerToggle(arg0._materialToggle, true)
	end

	if arg0.contextData.equipScrollPos then
		arg0:ScrollEquipPos(arg0.contextData.equipScrollPos.y)
	end

	onButton(arg0, arg0.exchangeTips:Find("capcity"), function()
		arg0:emit(var0.ON_DROP, {
			type = DROP_TYPE_RESOURCE,
			id = WorldConst.ResourceID
		})
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData()
	})
end

function var0.OverlayPanel(arg0, arg1)
	arg0.overlayIndex = arg0.overlayIndex or 0
	arg0.overlayIndex = arg0.overlayIndex + 1

	setParent(tf(arg1), arg0._tf.parent, false)
	tf(arg1):SetSiblingIndex(arg0._tf:GetSiblingIndex() + arg0.overlayIndex)
end

function var0.UnOverlayPanel(arg0, arg1, arg2)
	setParent(tf(arg1), arg2, false)

	arg0.overlayIndex = arg0.overlayIndex or 0
	arg0.overlayIndex = arg0.overlayIndex - 1
	arg0.overlayIndex = math.max(arg0.overlayIndex, 0)
end

function var0.onBackPressed(arg0)
	if isActive(arg0.itemResetPanel._go) then
		arg0.itemResetPanel:Close()
	elseif isActive(arg0.itemUsagePanel._go) then
		arg0.itemUsagePanel:Close()
	elseif arg0.assignedItemView:isShowing() then
		arg0.assignedItemView:Hide()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0.backBtn)
	end
end

function var0.willExit(arg0)
	arg0.assignedItemView:Destroy()
	arg0.inventoryProxy:RemoveListener(WorldInventoryProxy.EventUpdateItem, arg0.itemUpdateListenerFunc)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

function var0.initData(arg0)
	arg0.contextData.pageNum = arg0.contextData.pageNum or var0.PAGE.Property
	arg0.contextData.asc = arg0.contextData.asc or false

	if not arg0.contextData.sortData then
		arg0.contextData.sortData = var1.sort[1]
	end

	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}
	arg0.isEquipingOn = false
end

function var0.GetShowBusyFlag(arg0)
	return arg0.isEquipingOn
end

function var0.SetShowBusyFlag(arg0, arg1)
	arg0.isEquipingOn = arg1
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.decBtn, function()
		arg0.contextData.asc = not arg0.contextData.asc

		if arg0.contextData.pageNum == var0.PAGE.Equipment then
			arg0:filterEquipment()
		end
	end, SFX_PANEL)

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

	onToggle(arg0, arg0.sortBtn, function(arg0)
		if arg0 then
			arg0:OverlayPanel(arg0.sortPanel)
			setActive(arg0.sortPanel, true)
		else
			arg0:UnOverlayPanel(arg0.sortPanel, arg0.topItems)
			setActive(arg0.sortPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.sortPanel, function()
		triggerToggle(arg0.sortBtn, false)
	end, SFX_PANEL)
	onToggle(arg0, arg0.filterBusyToggle, function(arg0)
		arg0:SetShowBusyFlag(arg0)

		if arg0.contextData.pageNum == var0.PAGE.Equipment then
			arg0:filterEquipment()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.indexBtn, function()
		local var0 = {
			indexDatas = Clone(arg0.contextData.indexDatas),
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
			callback = function(arg0)
				arg0.contextData.indexDatas.typeIndex = arg0.typeIndex
				arg0.contextData.indexDatas.equipPropertyIndex = arg0.equipPropertyIndex
				arg0.contextData.indexDatas.equipPropertyIndex2 = arg0.equipPropertyIndex2
				arg0.contextData.indexDatas.equipAmmoIndex1 = arg0.equipAmmoIndex1
				arg0.contextData.indexDatas.equipAmmoIndex2 = arg0.equipAmmoIndex2
				arg0.contextData.indexDatas.equipCampIndex = arg0.equipCampIndex
				arg0.contextData.indexDatas.rarityIndex = arg0.rarityIndex
				arg0.contextData.indexDatas.extraIndex = arg0.extraIndex

				if arg0.filterBusyToggle:GetComponent(typeof(Toggle)) then
					if bit.band(arg0.extraIndex, IndexConst.EquipmentExtraEquiping) > 0 then
						arg0:SetShowBusyFlag(true)
					end

					triggerToggle(arg0.filterBusyToggle, arg0:GetShowBusyFlag())
				else
					arg0:filterEquipment()
				end
			end
		}

		arg0:emit(WorldInventoryMediator.OPEN_EQUIPMENT_INDEX, var0)
	end, SFX_PANEL)
	onToggle(arg0, arg0._itemToggle, function(arg0)
		if arg0 and arg0.contextData.pageNum ~= var0.PAGE.Property then
			arg0.contextData.pageNum = var0.PAGE.Property

			arg0:activeResetExchange(arg0.contextData.pageNum == var0.PAGE.Property)
			arg0:sortItems()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0._weaponToggle, function(arg0)
		if arg0 and arg0.contextData.pageNum ~= var0.PAGE.Equipment then
			arg0.contextData.pageNum = var0.PAGE.Equipment

			arg0:activeResetExchange(arg0.contextData.pageNum == var0.PAGE.Property)
			arg0:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0._materialToggle, function(arg0)
		if arg0 and arg0.contextData.pageNum ~= var0.PAGE.Material then
			arg0.contextData.pageNum = var0.PAGE.Material

			arg0:activeResetExchange(arg0.contextData.pageNum == var0.PAGE.Property)
			arg0:SortMaterials()
		end
	end, SFX_PANEL)
end

function var0.setWorldFleet(arg0, arg1)
	arg0.worldFleetList = arg1
end

function var0.setInventoryProxy(arg0, arg1)
	arg0.inventoryProxy = arg1

	arg0.inventoryProxy:AddListener(WorldInventoryProxy.EventUpdateItem, arg0.itemUpdateListenerFunc)
	arg0:setItemList(arg0.inventoryProxy:GetItemList())
end

function var0.setItemList(arg0, arg1)
	arg0.itemList = arg1

	if arg0.isInitItems then
		arg0:sortItems()
	end
end

function var0.initItems(arg0)
	arg0.isInitItems = true
	arg0.itemRect = arg0.itemView:GetComponent("LScrollRect")

	function arg0.itemRect.onInitItem(arg0)
		arg0:initItem(arg0)
	end

	function arg0.itemRect.onUpdateItem(arg0, arg1)
		arg0:updateItem(arg0, arg1)
	end

	function arg0.itemRect.onReturnItem(arg0, arg1)
		arg0:returnItem(arg0, arg1)
	end
end

function var0.initItem(arg0, arg1)
	local var0 = WSInventoryItem.New(arg1)

	onButton(arg0, var0.go, function()
		local var0 = var0.itemVO:getWorldItemType()

		if var0 == WorldItem.UsageBuff or var0 == WorldItem.UsageHPRegenerate or var0 == WorldItem.UsageHPRegenerateValue then
			arg0:emit(WorldInventoryMediator.OnOpenAllocateLayer, {
				itemVO = var0.itemVO,
				fleetList = arg0.worldFleetList,
				fleetIndex = arg0.contextData.currentFleetIndex,
				confirmCallback = function(arg0, arg1)
					arg0:emit(WorldInventoryMediator.OnUseItem, arg0, 1, arg1)
				end,
				onResetInfo = function(arg0)
					arg0.itemResetPanel:Open(arg0)
				end
			})
		elseif var0 == WorldItem.UsageWorldMap then
			arg0.itemUsagePanel:Open({
				item = var0.itemVO,
				mode = ItemUsagePanel.SEE,
				onUse = function()
					arg0:PlayOpenBox(var0.itemVO:getWorldItemOpenDisplay(), function()
						arg0:emit(WorldInventoryMediator.OnMap, var0.itemVO.id)
						arg0:closeView()
					end)
				end,
				onResetInfo = function(arg0)
					arg0.itemResetPanel:Open(arg0)
				end
			})
		elseif var0 == WorldItem.UsageDrop or var0 == WorldItem.UsageRecoverAp or var0 == WorldItem.UsageWorldItem or var0 == WorldItem.UsageWorldBuff then
			arg0.itemUsagePanel:Open({
				item = var0.itemVO,
				mode = ItemUsagePanel.BATCH,
				onUseBatch = function(arg0)
					arg0:emit(WorldInventoryMediator.OnUseItem, var0.itemVO.id, arg0, {})
				end,
				onUseOne = function()
					arg0:emit(WorldInventoryMediator.OnUseItem, var0.itemVO.id, 1, {})
				end,
				onResetInfo = function(arg0)
					arg0.itemResetPanel:Open(arg0)
				end
			})
		elseif var0 == WorldItem.UsageLoot then
			arg0.itemUsagePanel:Open({
				item = var0.itemVO,
				mode = ItemUsagePanel.INFO,
				onResetInfo = function(arg0)
					arg0.itemResetPanel:Open(arg0)
				end
			})
		elseif var0 == WorldItem.UsageWorldClean or var0 == WorldItem.UsageWorldFlag then
			arg0.itemUsagePanel:Open({
				item = var0.itemVO,
				onUse = function()
					arg0:emit(WorldInventoryMediator.OnUseItem, var0.itemVO.id, 1, {})
				end,
				onResetInfo = function(arg0)
					arg0.itemResetPanel:Open(arg0)
				end
			})
		elseif var0 == WorldItem.UsageDropAppointed then
			arg0.assignedItemView:Load()
			arg0.assignedItemView:ActionInvoke("update", var0.itemVO)
			arg0.assignedItemView:ActionInvoke("Show")
		end
	end, SFX_PANEL)

	arg0.itemCards[arg1] = var0
end

function var0.updateItem(arg0, arg1, arg2)
	local var0 = arg0.itemCards[arg2]

	if not var0 then
		arg0:initItem(arg2)

		var0 = arg0.itemCards[arg2]
	end

	local var1 = arg0.itemList[arg1 + 1]

	var0:update(var1)
end

function var0.returnItem(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.itemCards[arg2]

	if var0 then
		var0:clear()
	end
end

function var0.sortItems(arg0)
	table.sort(arg0.itemList, CompareFuncs({
		function(arg0)
			return -arg0:getConfig("sort_priority")
		end,
		function(arg0)
			return arg0:getConfig("id")
		end
	}))
	arg0.itemRect:SetTotalCount(#arg0.itemList, -1)
	arg0:updateResetExchange()
end

function var0.updateResetExchange(arg0)
	local var0 = arg0.inventoryProxy:CalcResetExchangeResource()

	setText(arg0.exchangeTips:Find("capcity/Text"), defaultValue(checkExist(var0, {
		DROP_TYPE_RESOURCE
	}, {
		WorldConst.ResourceID
	}), 0))
end

function var0.activeResetExchange(arg0, arg1)
	local var0 = nowWorld():IsSystemOpen(WorldConst.SystemResetExchange)

	setActive(arg0.exchangeTips, var0 and arg1)
end

function var0.PlayOpenBox(arg0, arg1, arg2)
	if not arg1 or arg1 == "" then
		arg2()

		return
	end

	local function var0()
		if arg0.playing or not arg0[arg1] then
			return
		end

		arg0.playing = true

		arg0[arg1]:SetActive(true)

		local var0 = tf(arg0[arg1])

		var0:SetParent(arg0._tf, false)
		var0:SetAsLastSibling()

		local var1 = var0:GetComponent("DftAniEvent")

		var1:SetTriggerEvent(function(arg0)
			arg2()
		end)
		var1:SetEndEvent(function(arg0)
			if arg0[arg1] then
				SetActive(arg0[arg1], false)

				arg0.playing = false
			end
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_EQUIPMENT_OPEN)
	end

	local var1 = arg0:findTF(arg1 .. "(Clone)")

	if var1 then
		arg0[arg1] = go(var1)
	end

	if not arg0[arg1] then
		PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(arg1), "", true, function(arg0)
			arg0:SetActive(true)

			arg0[arg1] = arg0

			var0()
		end)
	else
		var0()
	end
end

function var0.setEquipments(arg0, arg1)
	arg0.equipmentVOs = arg1
end

function var0.setEquipment(arg0, arg1)
	local var0 = #arg0.equipmentVOs + 1

	for iter0, iter1 in ipairs(arg0.equipmentVOs) do
		if not iter1.shipId and iter1.id == arg1.id then
			var0 = iter0

			break
		end
	end

	if arg1.count > 0 then
		arg0.equipmentVOs[var0] = arg1
	else
		table.remove(arg0.equipmentVOs, var0)
	end

	if arg0.contextData.pageNum == var0.PAGE.Equipment then
		arg0:filterEquipment()
	end
end

function var0.initEquipments(arg0)
	arg0.isInitWeapons = true
	arg0.equipmentRect = arg0.equipmentView:GetComponent("LScrollRect")

	function arg0.equipmentRect.onInitItem(arg0)
		arg0:initEquipment(arg0)
	end

	function arg0.equipmentRect.onUpdateItem(arg0, arg1)
		arg0:updateEquipment(arg0, arg1)
	end

	function arg0.equipmentRect.onReturnItem(arg0, arg1)
		arg0:returnEquipment(arg0, arg1)
	end

	arg0.equipmentRect.decelerationRate = 0.07
end

function var0.initEquipment(arg0, arg1)
	local var0 = EquipmentItem.New(arg1)

	onButton(arg0, var0.go, function()
		if arg0.equipmentRect.GetContentAnchoredPositionOriginal then
			arg0.contextData.equipScrollPos = arg0.equipmentRect:GetContentAnchoredPositionOriginal()
		end

		if var0.equipmentVO == nil or var0.equipmentVO.mask then
			return
		end

		local var0 = arg0.shipVO and {
			type = EquipmentInfoMediator.TYPE_REPLACE,
			equipmentId = var0.equipmentVO.id,
			shipId = arg0.contextData.shipId,
			pos = arg0.contextData.pos,
			oldShipId = var0.equipmentVO.shipId,
			oldPos = var0.equipmentVO.shipPos
		} or var0.equipmentVO.shipId and {
			type = EquipmentInfoMediator.TYPE_DISPLAY,
			equipmentId = var0.equipmentVO.id,
			shipId = var0.equipmentVO.shipId,
			pos = var0.equipmentVO.shipPos
		} or {
			destroy = true,
			type = EquipmentInfoMediator.TYPE_DEFAULT,
			equipmentId = var0.equipmentVO.id
		}

		arg0:emit(var0.ON_EQUIPMENT, var0)
	end, SFX_PANEL)

	arg0.equipmetItems[arg1] = var0
end

function var0.updateEquipment(arg0, arg1, arg2)
	local var0 = arg0.equipmetItems[arg2]

	if not var0 then
		arg0:initEquipment(arg2)

		var0 = arg0.equipmetItems[arg2]
	end

	local var1 = arg0.loadEquipmentVOs[arg1 + 1]

	var0:update(var1)
end

function var0.returnEquipment(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.equipmetItems[arg2]

	if var0 then
		var0:clear()
	end
end

function var0.filterEquipment(arg0)
	local var0 = arg0.contextData.sortData

	arg0.loadEquipmentVOs = arg0.loadEquipmentVOs or {}

	table.clean(arg0.loadEquipmentVOs)

	local var1 = arg0.loadEquipmentVOs
	local var2 = {
		arg0.contextData.indexDatas.equipPropertyIndex,
		arg0.contextData.indexDatas.equipPropertyIndex2
	}

	for iter0, iter1 in pairs(arg0.equipmentVOs) do
		if (not iter1.shipId or arg0:GetShowBusyFlag()) and not iter1.isSkin and IndexConst.filterEquipByType(iter1, arg0.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(iter1, var2) and IndexConst.filterEquipAmmo1(iter1, arg0.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(iter1, arg0.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(iter1, arg0.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(iter1, arg0.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(iter1, arg0.contextData.indexDatas.extraIndex) then
			table.insert(arg0.loadEquipmentVOs, iter1)
		end
	end

	if var0 then
		local var3 = arg0.contextData.asc

		table.sort(var1, CompareFuncs(var1.sortFunc(var0, var3)))
	end

	arg0:updateEquipmentCount()
	setImageSprite(arg0:findTF("Image", arg0.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var0.spr), true)
	setActive(arg0.downOrderTF, not arg0.contextData.asc)
	setActive(arg0.upOrderTF, arg0.contextData.asc)
end

function var0.updateEquipmentCount(arg0, arg1)
	arg0.equipmentRect:SetTotalCount(arg1 or #arg0.loadEquipmentVOs, -1)
	Canvas.ForceUpdateCanvases()
end

function var0.Scroll2Equip(arg0, arg1)
	if arg0.contextData.pageNum ~= var0.PAGE.Equipment then
		return
	end

	for iter0, iter1 in ipairs(arg0.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(iter1, arg1) then
			local var0 = arg0.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup))
			local var1 = (var0.cellSize.y + var0.spacing.y) * math.floor((iter0 - 1) / var0.constraintCount) + arg0.equipmentRect.paddingFront + arg0.equipmentView.rect.height * 0.5

			arg0:ScrollEquipPos(var1 - arg0.equipmentRect.paddingFront)

			break
		end
	end
end

function var0.ScrollEquipPos(arg0, arg1)
	local var0 = arg0.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1 = (var0.cellSize.y + var0.spacing.y) * math.ceil(#arg0.loadEquipmentVOs / var0.constraintCount) - var0.spacing.y + arg0.equipmentRect.paddingFront + arg0.equipmentRect.paddingEnd
	local var2 = var1 - arg0.equipmentView.rect.height

	var2 = var2 > 0 and var2 or var1

	local var3 = (arg1 - arg0.equipmentView.rect.height * 0.5) / var2

	arg0.equipmentRect:ScrollTo(var3)
end

function var0.SetMaterials(arg0, arg1)
	arg0.materials = arg1

	if arg0.isInitMaterials and arg0.contextData.pageNum == var0.PAGE.Material then
		arg0:SortMaterials()
	end
end

function var0.InitMaterials(arg0)
	arg0.isInitMaterials = true
	arg0.materialRect = arg0.materialtView:GetComponent("LScrollRect")

	function arg0.materialRect.onInitItem(arg0)
		arg0:InitMaterial(arg0)
	end

	function arg0.materialRect.onUpdateItem(arg0, arg1)
		arg0:UpdateMaterial(arg0, arg1)
	end

	function arg0.materialRect.onReturnItem(arg0, arg1)
		arg0:ReturnMaterial(arg0, arg1)
	end

	arg0.materialRect.decelerationRate = 0.07
end

function var0.SortMaterials(arg0)
	table.sort(arg0.materials, CompareFuncs({
		function(arg0)
			return -arg0:getConfig("rarity")
		end,
		function(arg0)
			return arg0.id
		end
	}))
	arg0.materialRect:SetTotalCount(#arg0.materials, -1)
	Canvas.ForceUpdateCanvases()
end

function var0.InitMaterial(arg0, arg1)
	local var0 = ItemCard.New(arg1)

	onButton(arg0, var0.go, function()
		if var0.itemVO == nil then
			return
		end

		if var0.itemVO:getConfig("type") == Item.INVITATION_TYPE then
			arg0:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = var0.itemVO
			})
		else
			arg0:emit(var0.ON_ITEM, var0.itemVO.id)
		end
	end, SFX_PANEL)

	arg0.materialCards[arg1] = var0
end

function var0.UpdateMaterial(arg0, arg1, arg2)
	local var0 = arg0.materialCards[arg2]

	if not var0 then
		arg0:initItem(arg2)

		var0 = arg0.materialCards[arg2]
	end

	local var1 = arg0.materials[arg1 + 1]

	var0:update(var1)
end

function var0.ReturnMaterial(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.materialCards[arg2]

	if var0 then
		var0:clear()
	end
end

return var0
