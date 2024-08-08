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
	arg0_4.sortPanelTG = arg0_4.sortPanel:GetComponent("ToggleGroup")
	arg0_4.sortPanelTG.allowSwitchOff = true
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
			onNextTick(function()
				arg0_15.sortPanelTG.allowSwitchOff = false
			end)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15.sortPanel, arg0_15.topItems)
			setActive(arg0_15.sortPanel, false)

			arg0_15.sortPanelTG.allowSwitchOff = true
		end
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.sortPanel, function()
		triggerToggle(arg0_15.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.indexBtn, function()
		local var0_27 = switch(arg0_15.page, {
			[var2_0] = function()
				return setmetatable({
					indexDatas = Clone(arg0_15.contextData.indexDatas),
					callback = function(arg0_29)
						arg0_15.contextData.indexDatas.typeIndex = arg0_29.typeIndex
						arg0_15.contextData.indexDatas.equipPropertyIndex = arg0_29.equipPropertyIndex
						arg0_15.contextData.indexDatas.equipPropertyIndex2 = arg0_29.equipPropertyIndex2
						arg0_15.contextData.indexDatas.equipAmmoIndex1 = arg0_29.equipAmmoIndex1
						arg0_15.contextData.indexDatas.equipAmmoIndex2 = arg0_29.equipAmmoIndex2
						arg0_15.contextData.indexDatas.equipCampIndex = arg0_29.equipCampIndex
						arg0_15.contextData.indexDatas.rarityIndex = arg0_29.rarityIndex
						arg0_15.contextData.indexDatas.extraIndex = arg0_29.extraIndex

						if arg0_15.filterBusyToggle:GetComponent(typeof(Toggle)) then
							if bit.band(arg0_29.extraIndex, IndexConst.EquipmentExtraEquiping) > 0 then
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
					callback = function(arg0_31)
						arg0_15.contextData.spweaponIndexDatas.typeIndex = arg0_31.typeIndex
						arg0_15.contextData.spweaponIndexDatas.rarityIndex = arg0_31.rarityIndex

						arg0_15:filterEquipment()
					end
				}, {
					__index = StoreHouseConst.SPWEAPON_INDEX_COMMON
				})
			end
		})

		arg0_15:emit(EquipmentMediator.OPEN_EQUIPMENT_INDEX, var0_27)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.equipSkinFilteBtn, function()
		local var0_32 = {
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
			callback = function(arg0_33)
				arg0_15.equipSkinSort = arg0_33.equipSkinSort
				arg0_15.equipSkinIndex = arg0_33.equipSkinIndex
				arg0_15.equipSkinTheme = arg0_33.equipSkinTheme

				arg0_15:filterEquipment()
			end
		}

		arg0_15:emit(EquipmentMediator.OPEN_EQUIPSKIN_INDEX_LAYER, var0_32)
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
	onToggle(arg0_15, arg0_15.materialToggle, function(arg0_34)
		arg0_15.inMaterial = arg0_34

		if arg0_34 and arg0_15.contextData.warp ~= StoreHouseConst.WARP_TO_MATERIAL then
			arg0_15.contextData.warp = StoreHouseConst.WARP_TO_MATERIAL

			setText(arg0_15.tip, i18n("equipment_select_materials_tip"))
			setActive(arg0_15.capacityTF.parent, false)
			setActive(arg0_15.tip, true)
			arg0_15:sortItems()
		end

		setActive(arg0_15.helpBtn, not arg0_34)
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.weaponToggle, function(arg0_35)
		if arg0_35 then
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
	onToggle(arg0_15, arg0_15.designToggle, function(arg0_36)
		if arg0_36 then
			arg0_15.contextData.warp = StoreHouseConst.WARP_TO_DESIGN

			local var0_36 = arg0_15.contextData.designPage or var5_0

			triggerToggle(arg0_15.designTabs[var0_36], true)
			setActive(arg0_15.capacityTF.parent, true)
		else
			arg0_15:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
			arg0_15:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end

		setActive(arg0_15.designTabRoot, arg0_36 and not LOCK_SP_WEAPON)
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.filterBusyToggle, function(arg0_37)
		arg0_15:SetShowBusyFlag(arg0_37)
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
		local var0_40 = {}

		if underscore.any(arg0_15.selectedIds, function(arg0_41)
			local var0_41 = arg0_15.equipmentVOByIds[arg0_41[1]]

			return var0_41:getConfig("rarity") >= 4 or var0_41:getConfig("level") > 1
		end) then
			table.insert(var0_40, function(arg0_42)
				arg0_15.equipDestroyConfirmWindow:Load()
				arg0_15.equipDestroyConfirmWindow:ActionInvoke("Show", underscore.map(arg0_15.selectedIds, function(arg0_43)
					return setmetatable({
						count = arg0_43[2]
					}, {
						__index = arg0_15.equipmentVOByIds[arg0_43[1]]
					})
				end), arg0_42)
			end)
		end

		seriesAsync(var0_40, function()
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

function var0_0.isDefaultStatus(arg0_46)
	return underscore(arg0_46.contextData.indexDatas):chain():keys():all(function(arg0_47)
		return arg0_46.contextData.indexDatas[arg0_47] == StoreHouseConst.EQUIPMENT_INDEX_COMMON.customPanels[arg0_47].options[1]
	end):value()
end

function var0_0.isDefaultSpWeaponIndexData(arg0_48)
	return underscore(arg0_48.contextData.spweaponIndexDatas):chain():keys():all(function(arg0_49)
		return arg0_48.contextData.spweaponIndexDatas[arg0_49] == StoreHouseConst.SPWEAPON_INDEX_COMMON.customPanels[arg0_49].options[1]
	end):value()
end

function var0_0.onBackPressed(arg0_50)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_50.sortPanel) then
		triggerButton(arg0_50.sortPanel)
	elseif arg0_50.destroyConfirmView:isShowing() then
		arg0_50.destroyConfirmView:Hide()
	elseif arg0_50.assignedItemView:isShowing() then
		arg0_50.assignedItemView:Hide()
	elseif arg0_50.blueprintAssignedItemView:isShowing() then
		arg0_50.blueprintAssignedItemView:Hide()
	elseif arg0_50.equipDestroyConfirmWindow:isShowing() then
		arg0_50.equipDestroyConfirmWindow:Hide()
	else
		triggerButton(arg0_50.backBtn)
	end
end

function var0_0.updateCapacity(arg0_51)
	if arg0_51.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		return
	end

	setText(arg0_51.tip, "")
	setText(arg0_51.capacityTF, arg0_51.capacity .. "/" .. arg0_51.player:getMaxEquipmentBag())
end

function var0_0.setCapacity(arg0_52, arg1_52)
	arg0_52.capacity = arg1_52
end

function var0_0.UpdateSpweaponCapacity(arg0_53)
	local var0_53 = getProxy(EquipmentProxy)

	setText(arg0_53.capacityTF, var0_53:GetSpWeaponCount() .. "/" .. var0_53:GetSpWeaponCapacity())
end

function var0_0.setShip(arg0_54, arg1_54)
	arg0_54.shipVO = arg1_54

	setActive(arg0_54.bottomPanel, not tobool(arg1_54))
end

function var0_0.setPlayer(arg0_55, arg1_55)
	arg0_55.player = arg1_55

	if arg0_55.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0_55.page == var2_0 then
		arg0_55:updateCapacity()
	elseif arg0_55.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0_55.contextData.designPage == var5_0 then
		arg0_55:updateCapacity()
	end
end

function var0_0.initSort(arg0_56)
	onButton(arg0_56, arg0_56.decBtn, function()
		arg0_56.asc = not arg0_56.asc
		arg0_56.contextData.asc = arg0_56.asc

		arg0_56:filterEquipment()
	end)

	arg0_56.sortButtons = {}

	eachChild(arg0_56.sortContain, function(arg0_58)
		setActive(arg0_58, false)
	end)

	for iter0_56, iter1_56 in ipairs(var7_0.sort) do
		local var0_56 = iter0_56 <= arg0_56.sortContain.childCount and arg0_56.sortContain:GetChild(iter0_56 - 1) or cloneTplTo(arg0_56.sortTpl, arg0_56.sortContain)

		setActive(var0_56, true)
		setImageSprite(findTF(var0_56, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1_56.spr), true)
		onToggle(arg0_56, var0_56, function(arg0_59)
			if arg0_59 then
				if arg0_56.page == var2_0 then
					arg0_56.contextData.sortData = iter1_56
				elseif arg0_56.page == var4_0 then
					arg0_56.contextData.spweaponSortData = var8_0.sort[iter0_56]
				end

				arg0_56:filterEquipment()
				triggerToggle(arg0_56.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0_56.sortButtons[iter0_56] = var0_56
	end
end

function var0_0.UpdateWeaponWrapButtons(arg0_60)
	local var0_60 = arg0_60.page

	setActive(arg0_60.indexBtn, var0_60 == var2_0 or var0_60 == var4_0)
	setActive(arg0_60.sortBtn, var0_60 == var2_0 or var0_60 == var4_0)
	setActive(arg0_60.BatchDisposeBtn, var0_60 == var2_0)
	setActive(arg0_60.capacityTF.parent, var0_60 == var2_0 or var0_60 == var4_0)
	setActive(arg0_60.equipSkinFilteBtn, var0_60 == var3_0)
	setActive(arg0_60.filterBusyToggle, arg0_60.mode == StoreHouseConst.OVERVIEW)
	setActive(arg0_60.equipmentToggle, arg0_60.mode == StoreHouseConst.OVERVIEW and not arg0_60.contextData.shipId)
	arg0_60:updatePageFilterButtons(var0_60)
end

function var0_0.updatePageFilterButtons(arg0_61, arg1_61)
	for iter0_61, iter1_61 in ipairs(var7_0.sort) do
		triggerToggle(arg0_61.sortButtons[iter0_61], false)
		setActive(arg0_61.sortButtons[iter0_61], table.contains(iter1_61.pages, arg1_61))
	end
end

function var0_0.initEquipments(arg0_62)
	arg0_62.isInitWeapons = true
	arg0_62.equipmentRect = arg0_62.equipmentView:GetComponent("LScrollRect")

	function arg0_62.equipmentRect.onInitItem(arg0_63)
		arg0_62:initEquipment(arg0_63)
	end

	function arg0_62.equipmentRect.onUpdateItem(arg0_64, arg1_64)
		arg0_62:updateEquipment(arg0_64, arg1_64)
	end

	function arg0_62.equipmentRect.onReturnItem(arg0_65, arg1_65)
		arg0_62:returnEquipment(arg0_65, arg1_65)
	end

	function arg0_62.equipmentRect.onStart()
		arg0_62:updateSelected()
	end

	arg0_62.equipmentRect.decelerationRate = 0.07
end

function var0_0.initEquipment(arg0_67, arg1_67)
	local var0_67 = EquipmentItem.New(arg1_67)

	onButton(arg0_67, var0_67.unloadBtn, function()
		if arg0_67.page == var3_0 then
			arg0_67:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT_SKIN)
		elseif arg0_67.page == var2_0 then
			arg0_67:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT)
		end
	end, SFX_PANEL)
	onButton(arg0_67, var0_67.reduceBtn, function()
		arg0_67:selectEquip(var0_67.equipmentVO, 1)
	end, SFX_PANEL)

	arg0_67.equipmetItems[arg1_67] = var0_67
end

function var0_0.updateEquipment(arg0_70, arg1_70, arg2_70)
	local var0_70 = arg0_70.equipmetItems[arg2_70]

	assert(var0_70, "without init item")

	local var1_70 = arg0_70.loadEquipmentVOs[arg1_70 + 1]

	var0_70:update(var1_70)

	local var2_70 = false
	local var3_70 = 0

	if var1_70 then
		for iter0_70, iter1_70 in ipairs(arg0_70.selectedIds) do
			if var1_70.id == iter1_70[1] then
				var2_70 = true
				var3_70 = iter1_70[2]

				break
			end
		end
	end

	var0_70:updateSelected(var2_70, var3_70)

	if not var1_70 then
		removeOnButton(var0_70.go)
	elseif isa(var1_70, SpWeapon) then
		onButton(arg0_70, var0_70.go, function()
			local var0_71 = arg0_70.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				shipId = arg0_70.contextData.shipId,
				oldSpWeaponUid = var1_70:GetUID(),
				oldShipId = var1_70:GetShipId()
			} or var1_70:GetShipId() and {
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				spWeaponUid = var1_70:GetUID(),
				shipId = var1_70:GetShipId()
			} or {
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				spWeaponUid = var1_70:GetUID()
			}

			arg0_70:emit(var0_0.ON_SPWEAPON, var0_71)
		end, SFX_PANEL)
	elseif var0_70.equipmentVO.isSkin then
		if var1_70.shipId then
			onButton(arg0_70, var0_70.go, function()
				local var0_72 = var1_70.shipId
				local var1_72 = var1_70.shipPos

				assert(var1_72, "equipment skin pos is nil")
				arg0_70:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_70.id, arg0_70.contextData.pos, {
					id = var0_72,
					pos = var1_72
				})
			end, SFX_PANEL)
		else
			onButton(arg0_70, var0_70.go, function()
				arg0_70:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_70.id, arg0_70.contextData.pos)
			end, SFX_PANEL)
		end
	elseif var1_70.mask then
		removeOnButton(var0_70.go)
	elseif arg0_70.mode == StoreHouseConst.DESTROY then
		onButton(arg0_70, var0_70.go, function()
			arg0_70:selectEquip(var1_70, var1_70.count)
		end, SFX_PANEL)
	else
		onButton(arg0_70, var0_70.go, function()
			local var0_75 = arg0_70.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				equipmentId = var1_70.id,
				shipId = arg0_70.contextData.shipId,
				pos = arg0_70.contextData.pos,
				oldShipId = var1_70.shipId,
				oldPos = var1_70.shipPos
			} or var1_70.shipId and {
				showTransformTip = true,
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				equipmentId = var1_70.id,
				shipId = var1_70.shipId,
				pos = var1_70.shipPos
			} or {
				destroy = true,
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				equipmentId = var1_70.id
			}

			arg0_70:emit(var0_0.ON_EQUIPMENT, var0_75)
		end, SFX_PANEL)
	end
end

function var0_0.returnEquipment(arg0_76, arg1_76, arg2_76)
	if arg0_76.exited then
		return
	end

	local var0_76 = arg0_76.equipmetItems[arg2_76]

	if var0_76 then
		removeOnButton(var0_76.go)
		var0_76:clear()
	end
end

function var0_0.updateEquipmentCount(arg0_77, arg1_77)
	arg0_77.equipmentRect:SetTotalCount(arg1_77 or #arg0_77.loadEquipmentVOs, -1)
	setActive(arg0_77.listEmptyTF, (arg1_77 or #arg0_77.loadEquipmentVOs) <= 0)
	setText(arg0_77.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.filterEquipment(arg0_78)
	if arg0_78.filterEquipWaitting > 0 then
		arg0_78.filterEquipWaitting = arg0_78.filterEquipWaitting - 1

		return
	end

	if arg0_78.page == var3_0 then
		arg0_78:filterEquipSkin()

		return
	elseif arg0_78.page == var4_0 then
		arg0_78:filterSpWeapon()

		return
	end

	local var0_78 = arg0_78:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_78, function(arg0_79)
		setImageSprite(arg0_78.indexBtn, arg0_79, true)
	end)

	local var1_78 = {}

	arg0_78.loadEquipmentVOs = {}

	for iter0_78, iter1_78 in pairs(arg0_78.equipmentVOs) do
		if not iter1_78.isSkin then
			table.insert(var1_78, iter1_78)
		end
	end

	local var2_78 = {
		arg0_78.contextData.indexDatas.equipPropertyIndex,
		arg0_78.contextData.indexDatas.equipPropertyIndex2
	}

	for iter2_78, iter3_78 in pairs(var1_78) do
		if (iter3_78.count > 0 or iter3_78.shipId) and arg0_78:checkFitBusyCondition(iter3_78) and IndexConst.filterEquipByType(iter3_78, arg0_78.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(iter3_78, var2_78) and IndexConst.filterEquipAmmo1(iter3_78, arg0_78.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(iter3_78, arg0_78.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(iter3_78, arg0_78.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(iter3_78, arg0_78.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(iter3_78, arg0_78.contextData.indexDatas.extraIndex) then
			table.insert(arg0_78.loadEquipmentVOs, iter3_78)
		end
	end

	if arg0_78.filterImportance ~= nil then
		for iter4_78 = #arg0_78.loadEquipmentVOs, 1, -1 do
			local var3_78 = arg0_78.loadEquipmentVOs[iter4_78]

			if var3_78.isSkin or not var3_78.isSkin and var3_78:isImportance() then
				table.remove(arg0_78.loadEquipmentVOs, iter4_78)
			end
		end
	end

	local var4_78 = arg0_78.contextData.sortData

	if var4_78 then
		local var5_78 = arg0_78.asc

		table.sort(arg0_78.loadEquipmentVOs, CompareFuncs(var7_0.sortFunc(var4_78, var5_78)))
	end

	if arg0_78.contextData.qiutBtn then
		table.insert(arg0_78.loadEquipmentVOs, 1, false)
	end

	arg0_78:updateSelected()
	arg0_78:updateEquipmentCount()
	setImageSprite(arg0_78:findTF("Image", arg0_78.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var4_78.spr), true)
	setActive(arg0_78.sortImgAsc, arg0_78.asc)
	setActive(arg0_78.sortImgDec, not arg0_78.asc)
	arg0_78:updateCapacity()
end

function var0_0.filterEquipSkin(arg0_80)
	local var0_80 = arg0_80.equipSkinIndex
	local var1_80 = arg0_80.equipSkinTheme
	local var2_80 = arg0_80.page
	local var3_80 = {}

	arg0_80.loadEquipmentVOs = {}

	if var2_80 ~= var3_0 then
		assert(false, "不是外观分页")
	end

	for iter0_80, iter1_80 in pairs(arg0_80.equipmentVOs) do
		if iter1_80.isSkin and iter1_80.count > 0 then
			table.insert(var3_80, iter1_80)
		end
	end

	for iter2_80, iter3_80 in pairs(var3_80) do
		if IndexConst.filterEquipSkinByIndex(iter3_80, var0_80) and IndexConst.filterEquipSkinByTheme(iter3_80, var1_80) and arg0_80:checkFitBusyCondition(iter3_80) then
			table.insert(arg0_80.loadEquipmentVOs, iter3_80)
		end
	end

	if arg0_80.filterImportance ~= nil then
		for iter4_80 = #arg0_80.loadEquipmentVOs, 1, -1 do
			local var4_80 = arg0_80.loadEquipmentVOs[iter4_80]

			if var4_80.isSkin or not var4_80.isSkin and var4_80:isImportance() then
				table.remove(arg0_80.loadEquipmentVOs, iter4_80)
			end
		end
	end

	local var5_80 = arg0_80.contextData.sortData

	if var5_80 then
		local var6_80 = arg0_80.asc

		table.sort(arg0_80.loadEquipmentVOs, CompareFuncs(var7_0.sortFunc(var5_80, var6_80)))
	end

	if arg0_80.contextData.qiutBtn then
		table.insert(arg0_80.loadEquipmentVOs, 1, false)
	end

	arg0_80:updateSelected()
	arg0_80:updateEquipmentCount()
	setActive(arg0_80.sortImgAsc, arg0_80.asc)
	setActive(arg0_80.sortImgDec, not arg0_80.asc)
end

function var0_0.filterSpWeapon(arg0_81)
	if arg0_81.page ~= var4_0 then
		assert(false, "不是特殊兵装分页")
	end

	local var0_81 = arg0_81:isDefaultSpWeaponIndexData() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_81, function(arg0_82)
		setImageSprite(arg0_81.indexBtn, arg0_82, true)
	end)

	arg0_81.loadEquipmentVOs = {}

	local var1_81 = arg0_81.contextData.spweaponIndexDatas.typeIndex
	local var2_81 = arg0_81.contextData.spweaponIndexDatas.rarityIndex

	for iter0_81, iter1_81 in pairs(arg0_81.spweaponVOs) do
		if IndexConst.filterSpWeaponByType(iter1_81, var1_81) and IndexConst.filterSpWeaponByRarity(iter1_81, var2_81) and arg0_81:checkFitBusyCondition(iter1_81) and (arg0_81.filterImportance == nil or iter1_81:IsImportant()) then
			table.insert(arg0_81.loadEquipmentVOs, iter1_81)
		end
	end

	local var3_81 = arg0_81.contextData.spweaponSortData

	if var3_81 then
		local var4_81 = arg0_81.asc

		table.sort(arg0_81.loadEquipmentVOs, CompareFuncs(var8_0.sortFunc(var3_81, var4_81)))
	end

	if arg0_81.contextData.qiutBtn then
		table.insert(arg0_81.loadEquipmentVOs, 1, false)
	end

	arg0_81:updateSelected()
	arg0_81:updateEquipmentCount()
	setImageSprite(arg0_81:findTF("Image", arg0_81.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var3_81.spr), true)
	setActive(arg0_81.sortImgAsc, arg0_81.asc)
	setActive(arg0_81.sortImgDec, not arg0_81.asc)
	arg0_81:UpdateSpweaponCapacity()
end

function var0_0.GetShowBusyFlag(arg0_83)
	return arg0_83.isEquipingOn
end

function var0_0.SetShowBusyFlag(arg0_84, arg1_84)
	arg0_84.isEquipingOn = arg1_84
end

function var0_0.Scroll2Equip(arg0_85, arg1_85)
	if arg0_85.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON or arg0_85.page ~= var2_0 then
		return
	end

	for iter0_85, iter1_85 in ipairs(arg0_85.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_85, arg1_85) then
			local var0_85 = arg0_85.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
			local var1_85 = (var0_85.cellSize.y + var0_85.spacing.y) * math.floor((iter0_85 - 1) / var0_85.constraintCount) + arg0_85.equipmentRect.paddingFront + arg0_85.equipmentView.rect.height * 0.5

			arg0_85:ScrollEquipPos(var1_85 - arg0_85.equipmentRect.paddingFront)

			break
		end
	end
end

function var0_0.ScrollEquipPos(arg0_86, arg1_86)
	local var0_86 = arg0_86.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1_86 = (var0_86.cellSize.y + var0_86.spacing.y) * math.ceil(#arg0_86.loadEquipmentVOs / var0_86.constraintCount) - var0_86.spacing.y + arg0_86.equipmentRect.paddingFront + arg0_86.equipmentRect.paddingEnd
	local var2_86 = var1_86 - arg0_86.equipmentView.rect.height

	var2_86 = var2_86 > 0 and var2_86 or var1_86

	local var3_86 = (arg1_86 - arg0_86.equipmentView.rect.height * 0.5) / var2_86

	arg0_86.equipmentRect:ScrollTo(var3_86)
end

function var0_0.checkFitBusyCondition(arg0_87, arg1_87)
	return not arg1_87.shipId or arg0_87:GetShowBusyFlag() and arg0_87.mode ~= StoreHouseConst.DESTROY
end

function var0_0.setItems(arg0_88, arg1_88)
	arg0_88.itemVOs = arg1_88

	if arg0_88.isInitItems and arg0_88.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		arg0_88:sortItems()
	end
end

function var0_0.initItems(arg0_89)
	arg0_89.isInitItems = true
	arg0_89.itemRect = arg0_89.itemView:GetComponent("LScrollRect")

	function arg0_89.itemRect.onInitItem(arg0_90)
		arg0_89:initItem(arg0_90)
	end

	function arg0_89.itemRect.onUpdateItem(arg0_91, arg1_91)
		arg0_89:updateItem(arg0_91, arg1_91)
	end

	function arg0_89.itemRect.onReturnItem(arg0_92, arg1_92)
		arg0_89:returnItem(arg0_92, arg1_92)
	end

	arg0_89.itemRect.decelerationRate = 0.07
end

function var0_0.sortItems(arg0_93)
	table.sort(arg0_93.itemVOs, CompareFuncs({
		function(arg0_94)
			return -arg0_94:getConfig("order")
		end,
		function(arg0_95)
			return -arg0_95:getConfig("rarity")
		end,
		function(arg0_96)
			return arg0_96.id
		end
	}))
	arg0_93.itemRect:SetTotalCount(#arg0_93.itemVOs, -1)
	setActive(arg0_93.listEmptyTF, #arg0_93.itemVOs <= 0)
	setText(arg0_93.listEmptyTxt, i18n("list_empty_tip_storehouseui_item"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.initItem(arg0_97, arg1_97)
	arg0_97.itemCards[arg1_97] = ItemCard.New(arg1_97)
end

function var0_0.updateItem(arg0_98, arg1_98, arg2_98)
	local var0_98 = arg0_98.itemCards[arg2_98]

	assert(var0_98, "without init item")

	local var1_98 = arg0_98.itemVOs[arg1_98 + 1]

	var0_98:update(var1_98)

	if not var1_98 then
		removeOnButton(var0_98.go)
	elseif tobool(getProxy(TechnologyProxy):getItemCanUnlockBluePrint(var1_98.id)) then
		local var2_98 = getProxy(TechnologyProxy)
		local var3_98 = underscore.map(var2_98:getItemCanUnlockBluePrint(var1_98.id), function(arg0_99)
			return var2_98:getBluePrintById(arg0_99)
		end)
		local var4_98 = underscore.detect(var3_98, function(arg0_100)
			return not arg0_100:isUnlock()
		end)

		if var4_98 then
			onButton(arg0_98, var0_98.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					item = var1_98,
					blueprints = var3_98,
					onYes = function()
						arg0_98:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.SHIPBLUEPRINT, {
							shipBluePrintVO = var4_98
						})
					end,
					yesText = i18n("text_forward")
				})
			end, SFX_PANEL)
		else
			onButton(arg0_98, var0_98.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					windowSize = Vector2(1010, 685),
					item = var1_98,
					blueprints = var3_98,
					onYes = function()
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							type = MSGBOX_TYPE_ITEM_BOX,
							content = i18n("techpackage_item_use_confirm"),
							items = underscore.map(var1_98:getConfig("display_icon"), function(arg0_105)
								return {
									type = arg0_105[1],
									id = arg0_105[2],
									count = arg0_105[3]
								}
							end),
							onYes = function()
								arg0_98:emit(EquipmentMediator.ON_USE_ITEM, var1_98.id, 1)
							end
						})
					end
				})
			end, SFX_PANEL)
		end
	elseif var1_98:getConfig("type") == Item.INVITATION_TYPE then
		onButton(arg0_98, var0_98.go, function()
			arg0_98:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = var1_98
			})
		end, SFX_PANEL)
	elseif var1_98:getConfig("type") == Item.ASSIGNED_TYPE or var1_98:getConfig("type") == Item.EQUIPMENT_ASSIGNED_TYPE then
		if underscore.any(pg.gameset.general_blueprint_list.description, function(arg0_108)
			return var1_98.id == arg0_108
		end) then
			onButton(arg0_98, var0_98.go, function()
				arg0_98.blueprintAssignedItemView:Load()
				arg0_98.blueprintAssignedItemView:ActionInvoke("Show")
				arg0_98.blueprintAssignedItemView:ActionInvoke("update", var1_98)
			end, SFX_PANEL)
		else
			onButton(arg0_98, var0_98.go, function()
				arg0_98.assignedItemView:Load()
				arg0_98.assignedItemView:ActionInvoke("Show")
				arg0_98.assignedItemView:ActionInvoke("update", var1_98)
			end, SFX_PANEL)
		end
	elseif Item.IsLoveLetterCheckItem(var1_98.id) then
		onButton(arg0_98, var0_98.go, function()
			arg0_98:emit(var0_0.ON_ITEM_EXTRA, var1_98.id, var1_98.extra)
		end, SFX_PANEL)
	elseif var1_98:getConfig("type") == Item.LOVE_LETTER_TYPE then
		onButton(arg0_98, var0_98.go, function()
			arg0_98:emit(var0_0.ON_ITEM_EXTRA, var1_98.id, var1_98.extra)
		end, SFX_PANEL)
	elseif var1_98:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
		onButton(arg0_98, var0_98.go, function()
			arg0_98:emit(var0_0.ON_ITEM, var1_98.id, function()
				local var0_114 = var1_98:getConfig("usage_arg")

				if var1_98:IsAllSkinOwner() then
					local var1_114 = Drop.New({
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var0_114[5]
					})

					arg0_98.msgBox:ExecuteAction("Show", {
						content = i18n("blackfriday_pack_select_skinall_dialog", var1_98:getConfig("name"), var1_114:getName()),
						leftDrop = {
							count = 1,
							type = DROP_TYPE_ITEM,
							id = var1_98.id
						},
						rightDrop = var1_114,
						onYes = function()
							arg0_98:emit(EquipmentMediator.ON_USE_ITEM, var1_98.id, 1, {
								0
							})
						end
					})
				else
					local var2_114 = {}

					for iter0_114, iter1_114 in ipairs(var0_114[2]) do
						var2_114[iter1_114] = true
					end

					arg0_98:emit(EquipmentMediator.ITEM_ADD_LAYER, Context.New({
						viewComponent = SelectSkinLayer,
						mediator = SkinAtlasMediator,
						data = {
							mode = SelectSkinLayer.MODE_SELECT,
							itemId = var1_98.id,
							selectableSkinList = underscore.map(var1_98:GetValidSkinList(), function(arg0_116)
								return SelectableSkin.New({
									id = arg0_116,
									isTimeLimit = var2_114[arg0_116] or false
								})
							end),
							OnConfirm = function(arg0_117)
								arg0_98:emit(EquipmentMediator.ON_USE_ITEM, var1_98.id, 1, {
									arg0_117
								})
							end
						}
					}))
				end
			end)
		end, SFX_PANEL)
	else
		onButton(arg0_98, var0_98.go, function()
			arg0_98:emit(var0_0.ON_ITEM, var1_98.id)
		end, SFX_PANEL)
	end
end

function var0_0.returnItem(arg0_119, arg1_119, arg2_119)
	if arg0_119.exited then
		return
	end

	local var0_119 = arg0_119.itemCards[arg2_119]

	if var0_119 then
		removeOnButton(var0_119.go)
		var0_119:clear()
	end
end

function var0_0.selectCount(arg0_120)
	local var0_120 = 0

	for iter0_120, iter1_120 in ipairs(arg0_120.selectedIds) do
		var0_120 = var0_120 + iter1_120[2]
	end

	return var0_120
end

function var0_0.selectEquip(arg0_121, arg1_121, arg2_121)
	if not arg0_121:checkDestroyGold(arg1_121, arg2_121) then
		return
	end

	if arg0_121.mode == StoreHouseConst.DESTROY then
		local var0_121 = false
		local var1_121
		local var2_121 = 0

		for iter0_121, iter1_121 in pairs(arg0_121.selectedIds) do
			if iter1_121[1] == arg1_121.id then
				var0_121 = true
				var1_121 = iter0_121
				var2_121 = iter1_121[2]

				break
			end
		end

		if not var0_121 then
			local var3_121, var4_121 = arg0_121.checkEquipment(arg1_121, function()
				arg0_121:selectEquip(arg1_121, arg2_121)
			end, arg0_121.selectedIds)

			if not var3_121 then
				if var4_121 then
					pg.TipsMgr.GetInstance():ShowTips(var4_121)
				end

				return
			end

			local var5_121 = arg0_121:selectCount()

			if arg0_121.selectedMax > 0 and var5_121 + arg2_121 > arg0_121.selectedMax then
				arg2_121 = arg0_121.selectedMax - var5_121
			end

			if arg0_121.selectedMax == 0 or var5_121 < arg0_121.selectedMax then
				table.insert(arg0_121.selectedIds, {
					arg1_121.id,
					arg2_121
				})
			elseif arg0_121.selectedMax == 1 then
				arg0_121.selectedIds[1] = {
					arg1_121.id,
					arg2_121
				}
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentScene_selectError_more", arg0_121.selectedMax))

				return
			end
		elseif var2_121 - arg2_121 > 0 then
			arg0_121.selectedIds[var1_121][2] = var2_121 - arg2_121
		else
			table.remove(arg0_121.selectedIds, var1_121)
		end
	end

	arg0_121:updateSelected()
end

function var0_0.unselecteAllEquips(arg0_123)
	arg0_123.selectedIds = {}

	arg0_123:updateSelected()
end

function var0_0.checkDestroyGold(arg0_124, arg1_124, arg2_124)
	local var0_124 = 0
	local var1_124 = false

	for iter0_124, iter1_124 in pairs(arg0_124.selectedIds) do
		local var2_124 = iter1_124[2]

		if Equipment.CanInBag(iter1_124[1]) then
			var0_124 = var0_124 + (Equipment.getConfigData(iter1_124[1]).destory_gold or 0) * var2_124
		end

		if arg1_124 and iter1_124[1] == arg1_124.configId then
			var1_124 = true
		end
	end

	if not var1_124 and arg1_124 and arg2_124 > 0 then
		var0_124 = var0_124 + (arg1_124:getConfig("destory_gold") or 0) * arg2_124
	end

	if arg0_124.player:GoldMax(var0_124) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.updateSelected(arg0_125)
	for iter0_125, iter1_125 in pairs(arg0_125.equipmetItems) do
		if iter1_125.equipmentVO then
			local var0_125 = false
			local var1_125 = 0

			for iter2_125, iter3_125 in pairs(arg0_125.selectedIds) do
				if iter1_125.equipmentVO.id == iter3_125[1] then
					var0_125 = true
					var1_125 = iter3_125[2]

					break
				end
			end

			iter1_125:updateSelected(var0_125, var1_125)
		end
	end

	if arg0_125.mode == StoreHouseConst.DESTROY then
		local var2_125 = arg0_125:selectCount()

		if arg0_125.selectedMax == 0 then
			setText(findTF(arg0_125.selectPanel, "bottom_info/bg_input/count"), var2_125)
		else
			setText(findTF(arg0_125.selectPanel, "bottom_info/bg_input/count"), var2_125 .. "/" .. arg0_125.selectedMax)
		end

		if #arg0_125.selectedIds < arg0_125.selectedMin then
			setActive(findTF(arg0_125.selectPanel, "confirm_button/mask"), true)
		else
			setActive(findTF(arg0_125.selectPanel, "confirm_button/mask"), false)
		end
	end
end

function var0_0.SwitchToDestroy(arg0_126)
	arg0_126.page = var2_0
	arg0_126.filterEquipWaitting = arg0_126.filterEquipWaitting + 1

	triggerToggle(arg0_126.weaponToggle, true)
	triggerButton(arg0_126.BatchDisposeBtn)
end

function var0_0.SwitchToSpWeaponStoreHouse(arg0_127)
	arg0_127.page = var4_0

	triggerToggle(arg0_127.weaponToggle, true)
end

function var0_0.willExit(arg0_128)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_128.blurPanel, arg0_128._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_128.topItems, arg0_128._tf)

	if arg0_128.bulinTip then
		arg0_128.bulinTip:Destroy()

		arg0_128.bulinTip = nil
	end

	arg0_128.destroyConfirmView:Destroy()
	arg0_128.assignedItemView:Destroy()
	arg0_128.blueprintAssignedItemView:Destroy()
	arg0_128.equipDestroyConfirmWindow:Destroy()
	arg0_128.msgBox:Destroy()
end

return var0_0
