local var0_0 = class("StoreHouseScene", import("view.base.BaseUI"))
local var1_0 = 1
local var2_0 = 0
local var3_0 = 1
local var4_0 = 2
local var5_0 = 1
local var6_0 = 2

function var0_0.getUIName(arg0_1)
	return "StoreHouseUI"
end

function var0_0.setEquipments(arg0_2, arg1_2)
	arg0_2.equipmentVOs = arg1_2

	arg0_2:setEquipmentByIds(arg1_2)
end

function var0_0.setEquipmentByIds(arg0_3, arg1_3)
	arg0_3.equipmentVOByIds = {}

	for iter0_3, iter1_3 in pairs(arg1_3) do
		if not iter1_3.isSkin then
			arg0_3.equipmentVOByIds[iter1_3.id] = iter1_3
		end
	end
end

local var7_0 = require("view.equipment.EquipmentSortCfg")
local var8_0 = require("view.equipment.SpWeaponSortCfg")

function var0_0.init(arg0_4)
	arg0_4.filterEquipWaitting = 0

	local var0_4 = arg0_4.contextData

	arg0_4.topItems = arg0_4:findTF("topItems")
	arg0_4.equipmentView = arg0_4:findTF("equipment_scrollview")
	arg0_4.blurPanel = arg0_4:findTF("blur_panel")
	arg0_4.topPanel = arg0_4:findTF("adapt/top", arg0_4.blurPanel)
	arg0_4.indexBtn = arg0_4:findTF("buttons/index_button", arg0_4.topPanel)
	arg0_4.sortBtn = arg0_4:findTF("buttons/sort_button", arg0_4.topPanel)
	arg0_4.sortPanel = arg0_4:findTF("sort", arg0_4.topItems)
	arg0_4.sortContain = arg0_4:findTF("adapt/mask/panel", arg0_4.sortPanel)
	arg0_4.sortTpl = arg0_4:findTF("tpl", arg0_4.sortContain)

	setActive(arg0_4.sortTpl, false)

	arg0_4.equipSkinFilteBtn = arg0_4:findTF("buttons/EquipSkinFilteBtn", arg0_4.topPanel)
	arg0_4.itemView = arg0_4:findTF("item_scrollview")

	local var1_4
	local var2_4 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var2_4:CheckLargeScreen() then
		var1_4 = arg0_4.itemView.rect.width > 2000
	else
		var1_4 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0_4.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var1_4 and 8 or 7
	arg0_4.itemView:Find("item_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var1_4 and 8 or 7
	arg0_4.decBtn = findTF(arg0_4.topPanel, "buttons/dec_btn")
	arg0_4.sortImgAsc = findTF(arg0_4.decBtn, "asc")
	arg0_4.sortImgDec = findTF(arg0_4.decBtn, "desc")
	arg0_4.equipmentToggle = arg0_4._tf:Find("blur_panel/adapt/left_length/frame/toggle_root")

	setActive(arg0_4.equipmentToggle, false)

	arg0_4.filterBusyToggle = arg0_4._tf:Find("blur_panel/adapt/left_length/frame/toggle_equip")

	setActive(arg0_4.filterBusyToggle, false)

	arg0_4.designTabRoot = arg0_4._tf:Find("blur_panel/adapt/left_length/frame/toggle_design")

	setActive(arg0_4.designTabRoot, false)

	arg0_4.designTabs = CustomIndexLayer.Clone2Full(arg0_4.designTabRoot, 2)
	arg0_4.bottomBack = arg0_4:findTF("adapt/bottom_back", arg0_4.topItems)
	arg0_4.bottomPanel = arg0_4:findTF("types", arg0_4.bottomBack)
	arg0_4.materialToggle = arg0_4.bottomPanel:Find("material")
	arg0_4.weaponToggle = arg0_4.bottomPanel:Find("weapon")
	arg0_4.designToggle = arg0_4.bottomPanel:Find("design")
	arg0_4.capacityTF = arg0_4:findTF("bottom_left/tip/capcity/Text", arg0_4.bottomBack)
	arg0_4.tipTF = arg0_4:findTF("bottom_left/tip", arg0_4.bottomBack)
	arg0_4.tip = arg0_4.tipTF:Find("label")
	arg0_4.helpBtn = arg0_4:findTF("adapt/help_btn", arg0_4.topItems)

	setActive(arg0_4.helpBtn, true)

	arg0_4.backBtn = arg0_4:findTF("blur_panel/adapt/top/back_btn")
	arg0_4.selectedMin = defaultValue(var0_4.selectedMin, 1)
	arg0_4.selectedMax = defaultValue(var0_4.selectedMax, pg.gameset.equip_select_limit.key_value or 0)
	arg0_4.selectedIds = Clone(var0_4.selectedIds or {})
	arg0_4.checkEquipment = var0_4.onEquipment or function(arg0_5, arg1_5, arg2_5)
		return true
	end
	arg0_4.onSelected = var0_4.onSelected or function()
		warning("not implemented.")
	end
	arg0_4.BatchDisposeBtn = arg0_4:findTF("dispos", arg0_4.bottomPanel)

	if not arg0_4.BatchDisposeBtn then
		arg0_4.BatchDisposeBtn = arg0_4:findTF("dispos", arg0_4.bottomBack)
	end

	arg0_4.selectPanel = arg0_4:findTF("adapt/select_panel", arg0_4.topItems)

	setActive(arg0_4.selectPanel, true)
	setAnchoredPosition(arg0_4.selectPanel, {
		y = -124
	})

	arg0_4.selectTransformPanel = arg0_4:findTF("adapt/select_transform_panel", arg0_4.topItems)

	setActive(arg0_4.selectTransformPanel, false)

	arg0_4.listEmptyTF = arg0_4:findTF("empty")

	setActive(arg0_4.listEmptyTF, false)

	arg0_4.listEmptyTxt = arg0_4:findTF("Text", arg0_4.listEmptyTF)
	arg0_4.destroyConfirmView = DestroyConfirmView.New(arg0_4.topItems, arg0_4.event)
	arg0_4.assignedItemView = AssignedItemView.New(arg0_4.topItems, arg0_4.event)
	arg0_4.blueprintAssignedItemView = BlueprintAssignedItemView.New(arg0_4.topItems, arg0_4.event)
	arg0_4.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0_4.topItems, arg0_4.event)
	arg0_4.isEquipingOn = false
	arg0_4.msgBox = SelectSkinMsgbox.New(arg0_4._tf, arg0_4.event)
end

function var0_0.setEquipment(arg0_7, arg1_7)
	local var0_7 = #arg0_7.equipmentVOs + 1

	for iter0_7, iter1_7 in ipairs(arg0_7.equipmentVOs) do
		if not iter1_7.shipId and iter1_7.id == arg1_7.id then
			var0_7 = iter0_7

			break
		end
	end

	if arg1_7.count > 0 then
		arg0_7.equipmentVOs[var0_7] = arg1_7
		arg0_7.equipmentVOByIds[arg1_7.id] = arg1_7
	else
		table.remove(arg0_7.equipmentVOs, var0_7)

		arg0_7.equipmentVOByIds[arg1_7.id] = nil
	end
end

function var0_0.setEquipmentUpdate(arg0_8)
	if arg0_8.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
		arg0_8:filterEquipment()
		arg0_8:updateCapacity()
	end
end

function var0_0.addShipEquipment(arg0_9, arg1_9)
	for iter0_9, iter1_9 in pairs(arg0_9.equipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_9, arg1_9) then
			arg0_9.equipmentVOs[iter0_9] = arg1_9

			return
		end
	end

	table.insert(arg0_9.equipmentVOs, arg1_9)
end

function var0_0.removeShipEquipment(arg0_10, arg1_10)
	for iter0_10 = #arg0_10.equipmentVOs, 1, -1 do
		local var0_10 = arg0_10.equipmentVOs[iter0_10]

		if EquipmentProxy.SameEquip(var0_10, arg1_10) then
			table.remove(arg0_10.equipmentVOs, iter0_10)
		end
	end
end

function var0_0.setEquipmentSkin(arg0_11, arg1_11)
	local var0_11 = true

	for iter0_11, iter1_11 in pairs(arg0_11.equipmentVOs) do
		if iter1_11.id == arg1_11.id and iter1_11.isSkin then
			arg0_11.equipmentVOs[iter0_11] = {
				isSkin = true,
				id = arg1_11.id,
				count = arg1_11.count
			}
			var0_11 = false
		end
	end

	if var0_11 then
		table.insert(arg0_11.equipmentVOs, {
			isSkin = true,
			id = arg1_11.id,
			count = arg1_11.count
		})
	end
end

function var0_0.setEquipmentSkinUpdate(arg0_12)
	if arg0_12.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
		arg0_12:filterEquipment()
		arg0_12:updateCapacity()
	end
end

function var0_0.SetSpWeapons(arg0_13, arg1_13)
	arg0_13.spweaponVOs = arg1_13
end

function var0_0.SetSpWeaponUpdate(arg0_14)
	if arg0_14.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0_14.page == var4_0 then
		arg0_14:filterEquipment()
		arg0_14:UpdateSpweaponCapacity()
	elseif arg0_14.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0_14.contextData.designPage == var6_0 then
		arg0_14:UpdateSpweaponCapacity()
	end
end

function var0_0.didEnter(arg0_15)
	setText(arg0_15:findTF("tip", arg0_15.selectPanel), i18n("equipment_select_device_destroy_tip"))
	setActive(arg0_15:findTF("adapt/stamp", arg0_15.topItems), getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0_15, arg0_15:findTF("adapt/stamp", arg0_15.topItems), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(2)
	end, SFX_CONFIRM)
	onButton(arg0_15, arg0_15.helpBtn, function()
		local var0_17

		if arg0_15.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
			if arg0_15.page == var2_0 then
				var0_17 = pg.gametip.help_equipment.tip
			elseif arg0_15.page == var3_0 then
				var0_17 = pg.gametip.help_equipment_skin.tip
			elseif arg0_15.page == var4_0 then
				var0_17 = pg.gametip.spweapon_help_storage.tip
			end
		elseif arg0_15.contextData.warp == StoreHouseConst.WARP_TO_DESIGN then
			if arg0_15.contextData.designPage == var5_0 then
				var0_17 = pg.gametip.help_equipment.tip
			elseif arg0_15.contextData.designPage == var6_0 then
				var0_17 = pg.gametip.spweapon_help_storage.tip
			end
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_17
		})
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.equipmentToggle:Find("equipment"), function(arg0_18)
		if arg0_18 then
			arg0_15.page = var2_0

			arg0_15:UpdateWeaponWrapButtons()
			arg0_15:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.equipmentToggle:Find("skin"), function(arg0_19)
		if arg0_19 then
			arg0_15.page = var3_0

			arg0_15:UpdateWeaponWrapButtons()
			arg0_15:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.equipmentToggle:Find("spweapon"), function(arg0_20)
		if arg0_20 then
			arg0_15.page = var4_0

			arg0_15:UpdateWeaponWrapButtons()
			arg0_15:filterEquipment()
		end
	end, SFX_PANEL)
	setActive(arg0_15.equipmentToggle:Find("spweapon"), not LOCK_SP_WEAPON)
	onToggle(arg0_15, arg0_15.designTabs[var5_0], function(arg0_21)
		if arg0_21 then
			arg0_15.contextData.designPage = var5_0

			arg0_15:emit(EquipmentMediator.OPEN_DESIGN)
			arg0_15:updateCapacity()
			setActive(arg0_15.tip, false)
			setActive(arg0_15.listEmptyTF, false)
		else
			arg0_15:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
		end
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.designTabs[var6_0], function(arg0_22)
		if arg0_22 then
			arg0_15.contextData.designPage = var6_0

			arg0_15:emit(EquipmentMediator.OPEN_SPWEAPON_DESIGN)
			arg0_15:UpdateSpweaponCapacity()
			setActive(arg0_15.tip, false)
			setActive(arg0_15.listEmptyTF, false)
		else
			arg0_15:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.backBtn, function()
		if arg0_15.mode == StoreHouseConst.DESTROY then
			triggerButton(arg0_15.BatchDisposeBtn)

			return
		end

		GetOrAddComponent(arg0_15._tf, typeof(CanvasGroup)).interactable = false

		arg0_15:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onToggle(arg0_15, arg0_15.sortBtn, function(arg0_24)
		if arg0_24 then
			pg.UIMgr.GetInstance():OverlayPanel(arg0_15.sortPanel, {
				groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
			})
			setActive(arg0_15.sortPanel, true)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15.sortPanel, arg0_15.topItems)
			setActive(arg0_15.sortPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.sortPanel, function()
		triggerToggle(arg0_15.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.indexBtn, function()
		local var0_26 = switch(arg0_15.page, {
			[var2_0] = function()
				return setmetatable({
					indexDatas = Clone(arg0_15.contextData.indexDatas),
					callback = function(arg0_28)
						arg0_15.contextData.indexDatas.typeIndex = arg0_28.typeIndex
						arg0_15.contextData.indexDatas.equipPropertyIndex = arg0_28.equipPropertyIndex
						arg0_15.contextData.indexDatas.equipPropertyIndex2 = arg0_28.equipPropertyIndex2
						arg0_15.contextData.indexDatas.equipAmmoIndex1 = arg0_28.equipAmmoIndex1
						arg0_15.contextData.indexDatas.equipAmmoIndex2 = arg0_28.equipAmmoIndex2
						arg0_15.contextData.indexDatas.equipCampIndex = arg0_28.equipCampIndex
						arg0_15.contextData.indexDatas.rarityIndex = arg0_28.rarityIndex
						arg0_15.contextData.indexDatas.extraIndex = arg0_28.extraIndex

						if arg0_15.filterBusyToggle:GetComponent(typeof(Toggle)) then
							if bit.band(arg0_28.extraIndex, IndexConst.EquipmentExtraEquiping) > 0 then
								arg0_15:SetShowBusyFlag(true)
							end

							triggerToggle(arg0_15.filterBusyToggle, arg0_15:GetShowBusyFlag())
						else
							arg0_15:filterEquipment()
						end
					end
				}, {
					__index = StoreHouseConst.EQUIPMENT_INDEX_COMMON
				})
			end,
			[var4_0] = function()
				return setmetatable({
					indexDatas = Clone(arg0_15.contextData.spweaponIndexDatas),
					callback = function(arg0_30)
						arg0_15.contextData.spweaponIndexDatas.typeIndex = arg0_30.typeIndex
						arg0_15.contextData.spweaponIndexDatas.rarityIndex = arg0_30.rarityIndex

						arg0_15:filterEquipment()
					end
				}, {
					__index = StoreHouseConst.SPWEAPON_INDEX_COMMON
				})
			end
		})

		arg0_15:emit(EquipmentMediator.OPEN_EQUIPMENT_INDEX, var0_26)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.equipSkinFilteBtn, function()
		local var0_31 = {
			display = {
				equipSkinIndex = IndexConst.FlagRange2Bits(IndexConst.EquipSkinIndexAll, IndexConst.EquipSkinIndexAux),
				equipSkinTheme = IndexConst.FlagRange2Str(IndexConst.EquipSkinThemeAll, IndexConst.EquipSkinThemeEnd)
			},
			equipSkinSort = arg0_15.equipSkinSort or IndexConst.EquipSkinSortType,
			equipSkinIndex = arg0_15.equipSkinIndex or IndexConst.Flags2Bits({
				IndexConst.EquipSkinIndexAll
			}),
			equipSkinTheme = arg0_15.equipSkinTheme or IndexConst.Flags2Str({
				IndexConst.EquipSkinThemeAll
			}),
			callback = function(arg0_32)
				arg0_15.equipSkinSort = arg0_32.equipSkinSort
				arg0_15.equipSkinIndex = arg0_32.equipSkinIndex
				arg0_15.equipSkinTheme = arg0_32.equipSkinTheme

				arg0_15:filterEquipment()
			end
		}

		arg0_15:emit(EquipmentMediator.OPEN_EQUIPSKIN_INDEX_LAYER, var0_31)
	end, SFX_PANEL)

	arg0_15.equipmetItems = {}
	arg0_15.itemCards = {}

	arg0_15:initItems()
	arg0_15:initEquipments()

	arg0_15.asc = arg0_15.contextData.asc or false
	arg0_15.contextData.sortData = arg0_15.contextData.sortData or var7_0.sort[1]
	arg0_15.contextData.indexDatas = arg0_15.contextData.indexDatas or {}
	arg0_15.contextData.spweaponIndexDatas = arg0_15.contextData.spweaponIndexDatas or {}
	arg0_15.contextData.spweaponSortData = arg0_15.contextData.spweaponSortData or var8_0.sort[1]

	arg0_15:initSort()
	setActive(arg0_15.itemView, false)
	setActive(arg0_15.equipmentView, false)
	onToggle(arg0_15, arg0_15.materialToggle, function(arg0_33)
		arg0_15.inMaterial = arg0_33

		if arg0_33 and arg0_15.contextData.warp ~= StoreHouseConst.WARP_TO_MATERIAL then
			arg0_15.contextData.warp = StoreHouseConst.WARP_TO_MATERIAL

			setText(arg0_15.tip, i18n("equipment_select_materials_tip"))
			setActive(arg0_15.capacityTF.parent, false)
			setActive(arg0_15.tip, true)
			arg0_15:sortItems()
		end

		setActive(arg0_15.helpBtn, not arg0_33)
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.weaponToggle, function(arg0_34)
		if arg0_34 then
			if arg0_15.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON then
				arg0_15.contextData.warp = StoreHouseConst.WARP_TO_WEAPON

				setActive(arg0_15.tip, false)
				setActive(arg0_15.capacityTF.parent, true)

				if arg0_15.page == var3_0 then
					triggerToggle(arg0_15.equipmentToggle:Find("skin"), true)
				elseif arg0_15.page == var4_0 then
					triggerToggle(arg0_15.equipmentToggle:Find("spweapon"), true)
				else
					triggerToggle(arg0_15.equipmentToggle:Find("equipment"), true)
				end
			end
		else
			setActive(arg0_15.BatchDisposeBtn, false)
			setActive(arg0_15.filterBusyToggle, false)
			setActive(arg0_15.equipmentToggle, false)
		end
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.designToggle, function(arg0_35)
		if arg0_35 then
			arg0_15.contextData.warp = StoreHouseConst.WARP_TO_DESIGN

			local var0_35 = arg0_15.contextData.designPage or var5_0

			triggerToggle(arg0_15.designTabs[var0_35], true)
			setActive(arg0_15.capacityTF.parent, true)
		else
			arg0_15:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
			arg0_15:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end

		setActive(arg0_15.designTabRoot, arg0_35 and not LOCK_SP_WEAPON)
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.filterBusyToggle, function(arg0_36)
		arg0_15:SetShowBusyFlag(arg0_36)
		arg0_15:filterEquipment()
	end, SFX_PANEL)

	arg0_15.filterEquipWaitting = arg0_15.filterEquipWaitting + 1

	triggerToggle(arg0_15.filterBusyToggle, arg0_15.shipVO)
	onButton(arg0_15, arg0_15.BatchDisposeBtn, function()
		if arg0_15.mode == StoreHouseConst.DESTROY then
			arg0_15.mode = StoreHouseConst.OVERVIEW
			arg0_15.asc = arg0_15.lastasc
			arg0_15.lastasc = nil
			arg0_15.filterImportance = nil

			shiftPanel(arg0_15.bottomBack, nil, 0, nil, 0, true, true)
			shiftPanel(arg0_15.selectPanel, nil, -124, nil, 0, true, true)
			arg0_15:filterEquipment()
		else
			arg0_15.mode = StoreHouseConst.DESTROY
			arg0_15.lastasc = arg0_15.asc
			arg0_15.filterImportance = true
			arg0_15.asc = true

			shiftPanel(arg0_15.bottomBack, nil, -124, nil, 0, true, true)
			shiftPanel(arg0_15.selectPanel, nil, 0, nil, 0, true, true)

			arg0_15.contextData.asc = arg0_15.asc
			arg0_15.contextData.sortData = var7_0.sort[1]

			arg0_15:filterEquipment()
		end

		arg0_15:UpdateWeaponWrapButtons()
	end, SFX_PANEL)
	onButton(arg0_15, findTF(arg0_15.selectPanel, "cancel_button"), function()
		arg0_15:unselecteAllEquips()
		triggerButton(arg0_15.BatchDisposeBtn)
	end, SFX_CANCEL)
	onButton(arg0_15, findTF(arg0_15.selectPanel, "confirm_button"), function()
		local var0_39 = {}

		if underscore.any(arg0_15.selectedIds, function(arg0_40)
			local var0_40 = arg0_15.equipmentVOByIds[arg0_40[1]]

			return var0_40:getConfig("rarity") >= 4 or var0_40:getConfig("level") > 1
		end) then
			table.insert(var0_39, function(arg0_41)
				arg0_15.equipDestroyConfirmWindow:Load()
				arg0_15.equipDestroyConfirmWindow:ActionInvoke("Show", underscore.map(arg0_15.selectedIds, function(arg0_42)
					return setmetatable({
						count = arg0_42[2]
					}, {
						__index = arg0_15.equipmentVOByIds[arg0_42[1]]
					})
				end), arg0_41)
			end)
		end

		seriesAsync(var0_39, function()
			arg0_15.destroyConfirmView:Load()
			arg0_15.destroyConfirmView:ActionInvoke("Show")
			arg0_15.destroyConfirmView:ActionInvoke("DisplayDestroyBonus", arg0_15.selectedIds)
			arg0_15.destroyConfirmView:ActionInvoke("SetConfirmBtnCB", function()
				arg0_15:unselecteAllEquips()
			end)
		end)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_15.blurPanel, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0_15.topItems, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})

	local var0_15 = arg0_15.contextData.warp or StoreHouseConst.WARP_TO_MATERIAL
	local var1_15 = arg0_15.contextData.mode or StoreHouseConst.OVERVIEW

	arg0_15.contextData.warp = nil
	arg0_15.contextData.mode = nil
	arg0_15.mode = arg0_15.mode or StoreHouseConst.OVERVIEW

	if var0_15 == StoreHouseConst.WARP_TO_DESIGN then
		triggerToggle(arg0_15.designToggle, true)
	elseif var0_15 == StoreHouseConst.WARP_TO_MATERIAL then
		triggerToggle(arg0_15.materialToggle, true)
	elseif var0_15 == StoreHouseConst.WARP_TO_WEAPON then
		if var1_15 == StoreHouseConst.DESTROY then
			arg0_15.filterEquipWaitting = arg0_15.filterEquipWaitting + 1

			triggerToggle(arg0_15.weaponToggle, true)
			triggerButton(arg0_15.BatchDisposeBtn)
		else
			if var1_15 == StoreHouseConst.SKIN then
				arg0_15.page = var3_0
			elseif var1_15 == StoreHouseConst.SPWEAPON then
				arg0_15.page = var4_0
			else
				arg0_15.page = var2_0
			end

			triggerToggle(arg0_15.weaponToggle, true)
		end
	end

	arg0_15.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_15, arg0_15.topItems)
end

function var0_0.isDefaultStatus(arg0_45)
	return underscore(arg0_45.contextData.indexDatas):chain():keys():all(function(arg0_46)
		return arg0_45.contextData.indexDatas[arg0_46] == StoreHouseConst.EQUIPMENT_INDEX_COMMON.customPanels[arg0_46].options[1]
	end):value()
end

function var0_0.isDefaultSpWeaponIndexData(arg0_47)
	return underscore(arg0_47.contextData.spweaponIndexDatas):chain():keys():all(function(arg0_48)
		return arg0_47.contextData.spweaponIndexDatas[arg0_48] == StoreHouseConst.SPWEAPON_INDEX_COMMON.customPanels[arg0_48].options[1]
	end):value()
end

function var0_0.onBackPressed(arg0_49)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_49.sortPanel) then
		triggerButton(arg0_49.sortPanel)
	elseif arg0_49.destroyConfirmView:isShowing() then
		arg0_49.destroyConfirmView:Hide()
	elseif arg0_49.assignedItemView:isShowing() then
		arg0_49.assignedItemView:Hide()
	elseif arg0_49.blueprintAssignedItemView:isShowing() then
		arg0_49.blueprintAssignedItemView:Hide()
	elseif arg0_49.equipDestroyConfirmWindow:isShowing() then
		arg0_49.equipDestroyConfirmWindow:Hide()
	else
		triggerButton(arg0_49.backBtn)
	end
end

function var0_0.updateCapacity(arg0_50)
	if arg0_50.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		return
	end

	setText(arg0_50.tip, "")
	setText(arg0_50.capacityTF, arg0_50.capacity .. "/" .. arg0_50.player:getMaxEquipmentBag())
end

function var0_0.setCapacity(arg0_51, arg1_51)
	arg0_51.capacity = arg1_51
end

function var0_0.UpdateSpweaponCapacity(arg0_52)
	local var0_52 = getProxy(EquipmentProxy)

	setText(arg0_52.capacityTF, var0_52:GetSpWeaponCount() .. "/" .. var0_52:GetSpWeaponCapacity())
end

function var0_0.setShip(arg0_53, arg1_53)
	arg0_53.shipVO = arg1_53

	setActive(arg0_53.bottomPanel, not tobool(arg1_53))
end

function var0_0.setPlayer(arg0_54, arg1_54)
	arg0_54.player = arg1_54

	if arg0_54.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0_54.page == var2_0 then
		arg0_54:updateCapacity()
	elseif arg0_54.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0_54.contextData.designPage == var5_0 then
		arg0_54:updateCapacity()
	end
end

function var0_0.initSort(arg0_55)
	onButton(arg0_55, arg0_55.decBtn, function()
		arg0_55.asc = not arg0_55.asc
		arg0_55.contextData.asc = arg0_55.asc

		arg0_55:filterEquipment()
	end)

	arg0_55.sortButtons = {}

	eachChild(arg0_55.sortContain, function(arg0_57)
		setActive(arg0_57, false)
	end)

	for iter0_55, iter1_55 in ipairs(var7_0.sort) do
		local var0_55 = iter0_55 <= arg0_55.sortContain.childCount and arg0_55.sortContain:GetChild(iter0_55 - 1) or cloneTplTo(arg0_55.sortTpl, arg0_55.sortContain)

		setActive(var0_55, true)
		setImageSprite(findTF(var0_55, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1_55.spr), true)
		onToggle(arg0_55, var0_55, function(arg0_58)
			if arg0_58 then
				if arg0_55.page == var2_0 then
					arg0_55.contextData.sortData = iter1_55
				elseif arg0_55.page == var4_0 then
					arg0_55.contextData.spweaponSortData = var8_0.sort[iter0_55]
				end

				arg0_55:filterEquipment()
				triggerToggle(arg0_55.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0_55.sortButtons[iter0_55] = var0_55
	end
end

function var0_0.UpdateWeaponWrapButtons(arg0_59)
	local var0_59 = arg0_59.page

	setActive(arg0_59.indexBtn, var0_59 == var2_0 or var0_59 == var4_0)
	setActive(arg0_59.sortBtn, var0_59 == var2_0 or var0_59 == var4_0)
	setActive(arg0_59.BatchDisposeBtn, var0_59 == var2_0)
	setActive(arg0_59.capacityTF.parent, var0_59 == var2_0 or var0_59 == var4_0)
	setActive(arg0_59.equipSkinFilteBtn, var0_59 == var3_0)
	setActive(arg0_59.filterBusyToggle, arg0_59.mode == StoreHouseConst.OVERVIEW)
	setActive(arg0_59.equipmentToggle, arg0_59.mode == StoreHouseConst.OVERVIEW and not arg0_59.contextData.shipId)
	arg0_59:updatePageFilterButtons(var0_59)
end

function var0_0.updatePageFilterButtons(arg0_60, arg1_60)
	for iter0_60, iter1_60 in ipairs(var7_0.sort) do
		triggerToggle(arg0_60.sortButtons[iter0_60], false)
		setActive(arg0_60.sortButtons[iter0_60], table.contains(iter1_60.pages, arg1_60))
	end
end

function var0_0.initEquipments(arg0_61)
	arg0_61.isInitWeapons = true
	arg0_61.equipmentRect = arg0_61.equipmentView:GetComponent("LScrollRect")

	function arg0_61.equipmentRect.onInitItem(arg0_62)
		arg0_61:initEquipment(arg0_62)
	end

	function arg0_61.equipmentRect.onUpdateItem(arg0_63, arg1_63)
		arg0_61:updateEquipment(arg0_63, arg1_63)
	end

	function arg0_61.equipmentRect.onReturnItem(arg0_64, arg1_64)
		arg0_61:returnEquipment(arg0_64, arg1_64)
	end

	function arg0_61.equipmentRect.onStart()
		arg0_61:updateSelected()
	end

	arg0_61.equipmentRect.decelerationRate = 0.07
end

function var0_0.initEquipment(arg0_66, arg1_66)
	local var0_66 = EquipmentItem.New(arg1_66)

	onButton(arg0_66, var0_66.unloadBtn, function()
		if arg0_66.page == var3_0 then
			arg0_66:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT_SKIN)
		elseif arg0_66.page == var2_0 then
			arg0_66:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT)
		end
	end, SFX_PANEL)
	onButton(arg0_66, var0_66.reduceBtn, function()
		arg0_66:selectEquip(var0_66.equipmentVO, 1)
	end, SFX_PANEL)

	arg0_66.equipmetItems[arg1_66] = var0_66
end

function var0_0.updateEquipment(arg0_69, arg1_69, arg2_69)
	local var0_69 = arg0_69.equipmetItems[arg2_69]

	assert(var0_69, "without init item")

	local var1_69 = arg0_69.loadEquipmentVOs[arg1_69 + 1]

	var0_69:update(var1_69)

	local var2_69 = false
	local var3_69 = 0

	if var1_69 then
		for iter0_69, iter1_69 in ipairs(arg0_69.selectedIds) do
			if var1_69.id == iter1_69[1] then
				var2_69 = true
				var3_69 = iter1_69[2]

				break
			end
		end
	end

	var0_69:updateSelected(var2_69, var3_69)

	if not var1_69 then
		removeOnButton(var0_69.go)
	elseif isa(var1_69, SpWeapon) then
		onButton(arg0_69, var0_69.go, function()
			local var0_70 = arg0_69.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				shipId = arg0_69.contextData.shipId,
				oldSpWeaponUid = var1_69:GetUID(),
				oldShipId = var1_69:GetShipId()
			} or var1_69:GetShipId() and {
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				spWeaponUid = var1_69:GetUID(),
				shipId = var1_69:GetShipId()
			} or {
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				spWeaponUid = var1_69:GetUID()
			}

			arg0_69:emit(var0_0.ON_SPWEAPON, var0_70)
		end, SFX_PANEL)
	elseif var0_69.equipmentVO.isSkin then
		if var1_69.shipId then
			onButton(arg0_69, var0_69.go, function()
				local var0_71 = var1_69.shipId
				local var1_71 = var1_69.shipPos

				assert(var1_71, "equipment skin pos is nil")
				arg0_69:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_69.id, arg0_69.contextData.pos, {
					id = var0_71,
					pos = var1_71
				})
			end, SFX_PANEL)
		else
			onButton(arg0_69, var0_69.go, function()
				arg0_69:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_69.id, arg0_69.contextData.pos)
			end, SFX_PANEL)
		end
	elseif var1_69.mask then
		removeOnButton(var0_69.go)
	elseif arg0_69.mode == StoreHouseConst.DESTROY then
		onButton(arg0_69, var0_69.go, function()
			arg0_69:selectEquip(var1_69, var1_69.count)
		end, SFX_PANEL)
	else
		onButton(arg0_69, var0_69.go, function()
			local var0_74 = arg0_69.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				equipmentId = var1_69.id,
				shipId = arg0_69.contextData.shipId,
				pos = arg0_69.contextData.pos,
				oldShipId = var1_69.shipId,
				oldPos = var1_69.shipPos
			} or var1_69.shipId and {
				showTransformTip = true,
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				equipmentId = var1_69.id,
				shipId = var1_69.shipId,
				pos = var1_69.shipPos
			} or {
				destroy = true,
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				equipmentId = var1_69.id
			}

			arg0_69:emit(var0_0.ON_EQUIPMENT, var0_74)
		end, SFX_PANEL)
	end
end

function var0_0.returnEquipment(arg0_75, arg1_75, arg2_75)
	if arg0_75.exited then
		return
	end

	local var0_75 = arg0_75.equipmetItems[arg2_75]

	if var0_75 then
		removeOnButton(var0_75.go)
		var0_75:clear()
	end
end

function var0_0.updateEquipmentCount(arg0_76, arg1_76)
	arg0_76.equipmentRect:SetTotalCount(arg1_76 or #arg0_76.loadEquipmentVOs, -1)
	setActive(arg0_76.listEmptyTF, (arg1_76 or #arg0_76.loadEquipmentVOs) <= 0)
	setText(arg0_76.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.filterEquipment(arg0_77)
	if arg0_77.filterEquipWaitting > 0 then
		arg0_77.filterEquipWaitting = arg0_77.filterEquipWaitting - 1

		return
	end

	if arg0_77.page == var3_0 then
		arg0_77:filterEquipSkin()

		return
	elseif arg0_77.page == var4_0 then
		arg0_77:filterSpWeapon()

		return
	end

	local var0_77 = arg0_77:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_77, function(arg0_78)
		setImageSprite(arg0_77.indexBtn, arg0_78, true)
	end)

	local var1_77 = {}

	arg0_77.loadEquipmentVOs = {}

	for iter0_77, iter1_77 in pairs(arg0_77.equipmentVOs) do
		if not iter1_77.isSkin then
			table.insert(var1_77, iter1_77)
		end
	end

	local var2_77 = {
		arg0_77.contextData.indexDatas.equipPropertyIndex,
		arg0_77.contextData.indexDatas.equipPropertyIndex2
	}

	for iter2_77, iter3_77 in pairs(var1_77) do
		if (iter3_77.count > 0 or iter3_77.shipId) and arg0_77:checkFitBusyCondition(iter3_77) and IndexConst.filterEquipByType(iter3_77, arg0_77.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(iter3_77, var2_77) and IndexConst.filterEquipAmmo1(iter3_77, arg0_77.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(iter3_77, arg0_77.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(iter3_77, arg0_77.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(iter3_77, arg0_77.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(iter3_77, arg0_77.contextData.indexDatas.extraIndex) then
			table.insert(arg0_77.loadEquipmentVOs, iter3_77)
		end
	end

	if arg0_77.filterImportance ~= nil then
		for iter4_77 = #arg0_77.loadEquipmentVOs, 1, -1 do
			local var3_77 = arg0_77.loadEquipmentVOs[iter4_77]

			if var3_77.isSkin or not var3_77.isSkin and var3_77:isImportance() then
				table.remove(arg0_77.loadEquipmentVOs, iter4_77)
			end
		end
	end

	local var4_77 = arg0_77.contextData.sortData

	if var4_77 then
		local var5_77 = arg0_77.asc

		table.sort(arg0_77.loadEquipmentVOs, CompareFuncs(var7_0.sortFunc(var4_77, var5_77)))
	end

	if arg0_77.contextData.qiutBtn then
		table.insert(arg0_77.loadEquipmentVOs, 1, false)
	end

	arg0_77:updateSelected()
	arg0_77:updateEquipmentCount()
	setImageSprite(arg0_77:findTF("Image", arg0_77.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var4_77.spr), true)
	setActive(arg0_77.sortImgAsc, arg0_77.asc)
	setActive(arg0_77.sortImgDec, not arg0_77.asc)
	arg0_77:updateCapacity()
end

function var0_0.filterEquipSkin(arg0_79)
	local var0_79 = arg0_79.equipSkinIndex
	local var1_79 = arg0_79.equipSkinTheme
	local var2_79 = arg0_79.page
	local var3_79 = {}

	arg0_79.loadEquipmentVOs = {}

	if var2_79 ~= var3_0 then
		assert(false, "不是外观分页")
	end

	for iter0_79, iter1_79 in pairs(arg0_79.equipmentVOs) do
		if iter1_79.isSkin and iter1_79.count > 0 then
			table.insert(var3_79, iter1_79)
		end
	end

	for iter2_79, iter3_79 in pairs(var3_79) do
		if IndexConst.filterEquipSkinByIndex(iter3_79, var0_79) and IndexConst.filterEquipSkinByTheme(iter3_79, var1_79) and arg0_79:checkFitBusyCondition(iter3_79) then
			table.insert(arg0_79.loadEquipmentVOs, iter3_79)
		end
	end

	if arg0_79.filterImportance ~= nil then
		for iter4_79 = #arg0_79.loadEquipmentVOs, 1, -1 do
			local var4_79 = arg0_79.loadEquipmentVOs[iter4_79]

			if var4_79.isSkin or not var4_79.isSkin and var4_79:isImportance() then
				table.remove(arg0_79.loadEquipmentVOs, iter4_79)
			end
		end
	end

	local var5_79 = arg0_79.contextData.sortData

	if var5_79 then
		local var6_79 = arg0_79.asc

		table.sort(arg0_79.loadEquipmentVOs, CompareFuncs(var7_0.sortFunc(var5_79, var6_79)))
	end

	if arg0_79.contextData.qiutBtn then
		table.insert(arg0_79.loadEquipmentVOs, 1, false)
	end

	arg0_79:updateSelected()
	arg0_79:updateEquipmentCount()
	setActive(arg0_79.sortImgAsc, arg0_79.asc)
	setActive(arg0_79.sortImgDec, not arg0_79.asc)
end

function var0_0.filterSpWeapon(arg0_80)
	if arg0_80.page ~= var4_0 then
		assert(false, "不是特殊兵装分页")
	end

	local var0_80 = arg0_80:isDefaultSpWeaponIndexData() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_80, function(arg0_81)
		setImageSprite(arg0_80.indexBtn, arg0_81, true)
	end)

	arg0_80.loadEquipmentVOs = {}

	local var1_80 = arg0_80.contextData.spweaponIndexDatas.typeIndex
	local var2_80 = arg0_80.contextData.spweaponIndexDatas.rarityIndex

	for iter0_80, iter1_80 in pairs(arg0_80.spweaponVOs) do
		if IndexConst.filterSpWeaponByType(iter1_80, var1_80) and IndexConst.filterSpWeaponByRarity(iter1_80, var2_80) and arg0_80:checkFitBusyCondition(iter1_80) and (arg0_80.filterImportance == nil or iter1_80:IsImportant()) then
			table.insert(arg0_80.loadEquipmentVOs, iter1_80)
		end
	end

	local var3_80 = arg0_80.contextData.spweaponSortData

	if var3_80 then
		local var4_80 = arg0_80.asc

		table.sort(arg0_80.loadEquipmentVOs, CompareFuncs(var8_0.sortFunc(var3_80, var4_80)))
	end

	if arg0_80.contextData.qiutBtn then
		table.insert(arg0_80.loadEquipmentVOs, 1, false)
	end

	arg0_80:updateSelected()
	arg0_80:updateEquipmentCount()
	setImageSprite(arg0_80:findTF("Image", arg0_80.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var3_80.spr), true)
	setActive(arg0_80.sortImgAsc, arg0_80.asc)
	setActive(arg0_80.sortImgDec, not arg0_80.asc)
	arg0_80:UpdateSpweaponCapacity()
end

function var0_0.GetShowBusyFlag(arg0_82)
	return arg0_82.isEquipingOn
end

function var0_0.SetShowBusyFlag(arg0_83, arg1_83)
	arg0_83.isEquipingOn = arg1_83
end

function var0_0.Scroll2Equip(arg0_84, arg1_84)
	if arg0_84.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON or arg0_84.page ~= var2_0 then
		return
	end

	for iter0_84, iter1_84 in ipairs(arg0_84.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_84, arg1_84) then
			local var0_84 = arg0_84.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
			local var1_84 = (var0_84.cellSize.y + var0_84.spacing.y) * math.floor((iter0_84 - 1) / var0_84.constraintCount) + arg0_84.equipmentRect.paddingFront + arg0_84.equipmentView.rect.height * 0.5

			arg0_84:ScrollEquipPos(var1_84 - arg0_84.equipmentRect.paddingFront)

			break
		end
	end
end

function var0_0.ScrollEquipPos(arg0_85, arg1_85)
	local var0_85 = arg0_85.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1_85 = (var0_85.cellSize.y + var0_85.spacing.y) * math.ceil(#arg0_85.loadEquipmentVOs / var0_85.constraintCount) - var0_85.spacing.y + arg0_85.equipmentRect.paddingFront + arg0_85.equipmentRect.paddingEnd
	local var2_85 = var1_85 - arg0_85.equipmentView.rect.height

	var2_85 = var2_85 > 0 and var2_85 or var1_85

	local var3_85 = (arg1_85 - arg0_85.equipmentView.rect.height * 0.5) / var2_85

	arg0_85.equipmentRect:ScrollTo(var3_85)
end

function var0_0.checkFitBusyCondition(arg0_86, arg1_86)
	return not arg1_86.shipId or arg0_86:GetShowBusyFlag() and arg0_86.mode ~= StoreHouseConst.DESTROY
end

function var0_0.setItems(arg0_87, arg1_87)
	arg0_87.itemVOs = arg1_87

	if arg0_87.isInitItems and arg0_87.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		arg0_87:sortItems()
	end
end

function var0_0.initItems(arg0_88)
	arg0_88.isInitItems = true
	arg0_88.itemRect = arg0_88.itemView:GetComponent("LScrollRect")

	function arg0_88.itemRect.onInitItem(arg0_89)
		arg0_88:initItem(arg0_89)
	end

	function arg0_88.itemRect.onUpdateItem(arg0_90, arg1_90)
		arg0_88:updateItem(arg0_90, arg1_90)
	end

	function arg0_88.itemRect.onReturnItem(arg0_91, arg1_91)
		arg0_88:returnItem(arg0_91, arg1_91)
	end

	arg0_88.itemRect.decelerationRate = 0.07
end

function var0_0.sortItems(arg0_92)
	table.sort(arg0_92.itemVOs, CompareFuncs({
		function(arg0_93)
			return -arg0_93:getConfig("order")
		end,
		function(arg0_94)
			return -arg0_94:getConfig("rarity")
		end,
		function(arg0_95)
			return arg0_95.id
		end
	}))
	arg0_92.itemRect:SetTotalCount(#arg0_92.itemVOs, -1)
	setActive(arg0_92.listEmptyTF, #arg0_92.itemVOs <= 0)
	setText(arg0_92.listEmptyTxt, i18n("list_empty_tip_storehouseui_item"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.initItem(arg0_96, arg1_96)
	arg0_96.itemCards[arg1_96] = ItemCard.New(arg1_96)
end

function var0_0.updateItem(arg0_97, arg1_97, arg2_97)
	local var0_97 = arg0_97.itemCards[arg2_97]

	assert(var0_97, "without init item")

	local var1_97 = arg0_97.itemVOs[arg1_97 + 1]

	var0_97:update(var1_97)

	if not var1_97 then
		removeOnButton(var0_97.go)
	elseif tobool(getProxy(TechnologyProxy):getItemCanUnlockBluePrint(var1_97.id)) then
		local var2_97 = getProxy(TechnologyProxy)
		local var3_97 = underscore.map(var2_97:getItemCanUnlockBluePrint(var1_97.id), function(arg0_98)
			return var2_97:getBluePrintById(arg0_98)
		end)
		local var4_97 = underscore.detect(var3_97, function(arg0_99)
			return not arg0_99:isUnlock()
		end)

		if var4_97 then
			onButton(arg0_97, var0_97.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					item = var1_97,
					blueprints = var3_97,
					onYes = function()
						arg0_97:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.SHIPBLUEPRINT, {
							shipBluePrintVO = var4_97
						})
					end,
					yesText = i18n("text_forward")
				})
			end, SFX_PANEL)
		else
			onButton(arg0_97, var0_97.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					windowSize = Vector2(1010, 685),
					item = var1_97,
					blueprints = var3_97,
					onYes = function()
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							type = MSGBOX_TYPE_ITEM_BOX,
							content = i18n("techpackage_item_use_confirm"),
							items = underscore.map(var1_97:getConfig("display_icon"), function(arg0_104)
								return {
									type = arg0_104[1],
									id = arg0_104[2],
									count = arg0_104[3]
								}
							end),
							onYes = function()
								arg0_97:emit(EquipmentMediator.ON_USE_ITEM, var1_97.id, 1)
							end
						})
					end
				})
			end, SFX_PANEL)
		end
	elseif var1_97:getConfig("type") == Item.INVITATION_TYPE then
		onButton(arg0_97, var0_97.go, function()
			arg0_97:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = var1_97
			})
		end, SFX_PANEL)
	elseif var1_97:getConfig("type") == Item.ASSIGNED_TYPE or var1_97:getConfig("type") == Item.EQUIPMENT_ASSIGNED_TYPE then
		if underscore.any(pg.gameset.general_blueprint_list.description, function(arg0_107)
			return var1_97.id == arg0_107
		end) then
			onButton(arg0_97, var0_97.go, function()
				arg0_97.blueprintAssignedItemView:Load()
				arg0_97.blueprintAssignedItemView:ActionInvoke("Show")
				arg0_97.blueprintAssignedItemView:ActionInvoke("update", var1_97)
			end, SFX_PANEL)
		else
			onButton(arg0_97, var0_97.go, function()
				arg0_97.assignedItemView:Load()
				arg0_97.assignedItemView:ActionInvoke("Show")
				arg0_97.assignedItemView:ActionInvoke("update", var1_97)
			end, SFX_PANEL)
		end
	elseif var1_97:getConfig("type") == Item.LOVE_LETTER_TYPE then
		onButton(arg0_97, var0_97.go, function()
			arg0_97:emit(var0_0.ON_ITEM_EXTRA, var1_97.id, var1_97.extra)
		end, SFX_PANEL)
	elseif var1_97:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
		onButton(arg0_97, var0_97.go, function()
			arg0_97:emit(var0_0.ON_ITEM, var1_97.id, function()
				local var0_112 = var1_97:getConfig("usage_arg")

				if var1_97:IsAllSkinOwner() then
					local var1_112 = Drop.New({
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var0_112[5]
					})

					arg0_97.msgBox:ExecuteAction("Show", {
						content = i18n("blackfriday_pack_select_skinall_dialog", var1_97:getConfig("name"), var1_112:getName()),
						leftDrop = {
							count = 1,
							type = DROP_TYPE_ITEM,
							id = var1_97.id
						},
						rightDrop = var1_112,
						onYes = function()
							arg0_97:emit(EquipmentMediator.ON_USE_ITEM, var1_97.id, 1, {
								0
							})
						end
					})
				else
					local var2_112 = {}

					for iter0_112, iter1_112 in ipairs(var0_112[2]) do
						var2_112[iter1_112] = true
					end

					arg0_97:emit(EquipmentMediator.ITEM_ADD_LAYER, Context.New({
						viewComponent = SelectSkinLayer,
						mediator = SkinAtlasMediator,
						data = {
							mode = SelectSkinLayer.MODE_SELECT,
							itemId = var1_97.id,
							selectableSkinList = underscore.map(var1_97:GetValidSkinList(), function(arg0_114)
								return SelectableSkin.New({
									id = arg0_114,
									isTimeLimit = var2_112[arg0_114] or false
								})
							end),
							OnConfirm = function(arg0_115)
								arg0_97:emit(EquipmentMediator.ON_USE_ITEM, var1_97.id, 1, {
									arg0_115
								})
							end
						}
					}))
				end
			end)
		end, SFX_PANEL)
	else
		onButton(arg0_97, var0_97.go, function()
			arg0_97:emit(var0_0.ON_ITEM, var1_97.id)
		end, SFX_PANEL)
	end
end

function var0_0.returnItem(arg0_117, arg1_117, arg2_117)
	if arg0_117.exited then
		return
	end

	local var0_117 = arg0_117.itemCards[arg2_117]

	if var0_117 then
		removeOnButton(var0_117.go)
		var0_117:clear()
	end
end

function var0_0.selectCount(arg0_118)
	local var0_118 = 0

	for iter0_118, iter1_118 in ipairs(arg0_118.selectedIds) do
		var0_118 = var0_118 + iter1_118[2]
	end

	return var0_118
end

function var0_0.selectEquip(arg0_119, arg1_119, arg2_119)
	if not arg0_119:checkDestroyGold(arg1_119, arg2_119) then
		return
	end

	if arg0_119.mode == StoreHouseConst.DESTROY then
		local var0_119 = false
		local var1_119
		local var2_119 = 0

		for iter0_119, iter1_119 in pairs(arg0_119.selectedIds) do
			if iter1_119[1] == arg1_119.id then
				var0_119 = true
				var1_119 = iter0_119
				var2_119 = iter1_119[2]

				break
			end
		end

		if not var0_119 then
			local var3_119, var4_119 = arg0_119.checkEquipment(arg1_119, function()
				arg0_119:selectEquip(arg1_119, arg2_119)
			end, arg0_119.selectedIds)

			if not var3_119 then
				if var4_119 then
					pg.TipsMgr.GetInstance():ShowTips(var4_119)
				end

				return
			end

			local var5_119 = arg0_119:selectCount()

			if arg0_119.selectedMax > 0 and var5_119 + arg2_119 > arg0_119.selectedMax then
				arg2_119 = arg0_119.selectedMax - var5_119
			end

			if arg0_119.selectedMax == 0 or var5_119 < arg0_119.selectedMax then
				table.insert(arg0_119.selectedIds, {
					arg1_119.id,
					arg2_119
				})
			elseif arg0_119.selectedMax == 1 then
				arg0_119.selectedIds[1] = {
					arg1_119.id,
					arg2_119
				}
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentScene_selectError_more", arg0_119.selectedMax))

				return
			end
		elseif var2_119 - arg2_119 > 0 then
			arg0_119.selectedIds[var1_119][2] = var2_119 - arg2_119
		else
			table.remove(arg0_119.selectedIds, var1_119)
		end
	end

	arg0_119:updateSelected()
end

function var0_0.unselecteAllEquips(arg0_121)
	arg0_121.selectedIds = {}

	arg0_121:updateSelected()
end

function var0_0.checkDestroyGold(arg0_122, arg1_122, arg2_122)
	local var0_122 = 0
	local var1_122 = false

	for iter0_122, iter1_122 in pairs(arg0_122.selectedIds) do
		local var2_122 = iter1_122[2]

		if Equipment.CanInBag(iter1_122[1]) then
			var0_122 = var0_122 + (Equipment.getConfigData(iter1_122[1]).destory_gold or 0) * var2_122
		end

		if arg1_122 and iter1_122[1] == arg1_122.configId then
			var1_122 = true
		end
	end

	if not var1_122 and arg1_122 and arg2_122 > 0 then
		var0_122 = var0_122 + (arg1_122:getConfig("destory_gold") or 0) * arg2_122
	end

	if arg0_122.player:GoldMax(var0_122) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.updateSelected(arg0_123)
	for iter0_123, iter1_123 in pairs(arg0_123.equipmetItems) do
		if iter1_123.equipmentVO then
			local var0_123 = false
			local var1_123 = 0

			for iter2_123, iter3_123 in pairs(arg0_123.selectedIds) do
				if iter1_123.equipmentVO.id == iter3_123[1] then
					var0_123 = true
					var1_123 = iter3_123[2]

					break
				end
			end

			iter1_123:updateSelected(var0_123, var1_123)
		end
	end

	if arg0_123.mode == StoreHouseConst.DESTROY then
		local var2_123 = arg0_123:selectCount()

		if arg0_123.selectedMax == 0 then
			setText(findTF(arg0_123.selectPanel, "bottom_info/bg_input/count"), var2_123)
		else
			setText(findTF(arg0_123.selectPanel, "bottom_info/bg_input/count"), var2_123 .. "/" .. arg0_123.selectedMax)
		end

		if #arg0_123.selectedIds < arg0_123.selectedMin then
			setActive(findTF(arg0_123.selectPanel, "confirm_button/mask"), true)
		else
			setActive(findTF(arg0_123.selectPanel, "confirm_button/mask"), false)
		end
	end
end

function var0_0.SwitchToDestroy(arg0_124)
	arg0_124.page = var2_0
	arg0_124.filterEquipWaitting = arg0_124.filterEquipWaitting + 1

	triggerToggle(arg0_124.weaponToggle, true)
	triggerButton(arg0_124.BatchDisposeBtn)
end

function var0_0.SwitchToSpWeaponStoreHouse(arg0_125)
	arg0_125.page = var4_0

	triggerToggle(arg0_125.weaponToggle, true)
end

function var0_0.willExit(arg0_126)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_126.blurPanel, arg0_126._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_126.topItems, arg0_126._tf)

	if arg0_126.bulinTip then
		arg0_126.bulinTip:Destroy()

		arg0_126.bulinTip = nil
	end

	arg0_126.destroyConfirmView:Destroy()
	arg0_126.assignedItemView:Destroy()
	arg0_126.blueprintAssignedItemView:Destroy()
	arg0_126.equipDestroyConfirmWindow:Destroy()
	arg0_126.msgBox:Destroy()
end

return var0_0
