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

	arg0_4.topItems = arg0_4._tf:Find("topItems")
	arg0_4.equipmentView = arg0_4._tf:Find("adapt/equipment_scrollview")
	arg0_4.blurPanel = arg0_4._tf:Find("blur_panel")
	arg0_4.topPanel = arg0_4.blurPanel:Find("adapt/top")
	arg0_4.indexBtn = arg0_4.topPanel:Find("buttons/index_button")
	arg0_4.sortBtn = arg0_4.topPanel:Find("buttons/sort_button")
	arg0_4.sortPanel = arg0_4.topItems:Find("sort")
	arg0_4.sortPanelTG = arg0_4.sortPanel:GetComponent("ToggleGroup")
	arg0_4.sortPanelTG.allowSwitchOff = true
	arg0_4.sortContain = arg0_4.sortPanel:Find("adapt/mask/panel")
	arg0_4.sortTpl = arg0_4.sortContain:Find("tpl")

	setActive(arg0_4.sortTpl, false)

	arg0_4.equipSkinFilteBtn = arg0_4.topPanel:Find("buttons/EquipSkinFilteBtn")
	arg0_4.searchBar = RecordableSearchBar.New(RecordableSearchBar.CreateData({
		enabledFlag = false,
		holder = i18n("search_equipment"),
		onInputChanged = function()
			arg0_4:filterEquipment()
		end,
		key = arg0_4.__cname,
		parent = arg0_4.blurPanel:Find("adapt"),
		anchoredPosition = Vector3(-1305, arg0_4.topPanel.sizeDelta.y * -0.5, 0)
	}))
	arg0_4.itemView = arg0_4._tf:Find("adapt/item_scrollview")

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
	arg0_4.bottomBack = arg0_4.topItems:Find("adapt/bottom_back")
	arg0_4.bottomPanel = arg0_4.bottomBack:Find("types")
	arg0_4.materialToggle = arg0_4.bottomPanel:Find("material")
	arg0_4.weaponToggle = arg0_4.bottomPanel:Find("weapon")
	arg0_4.designToggle = arg0_4.bottomPanel:Find("design")
	arg0_4.capacityTF = arg0_4.bottomBack:Find("bottom_left/tip/capcity/Text")
	arg0_4.tipTF = arg0_4.bottomBack:Find("bottom_left/tip")
	arg0_4.tip = arg0_4.tipTF:Find("label")
	arg0_4.helpBtn = arg0_4.topItems:Find("adapt/help_btn")

	setActive(arg0_4.helpBtn, true)

	arg0_4.backBtn = arg0_4._tf:Find("blur_panel/adapt/top/back_btn")
	arg0_4.selectedMin = defaultValue(var0_4.selectedMin, 1)
	arg0_4.selectedMax = defaultValue(var0_4.selectedMax, pg.gameset.equip_select_limit.key_value or 0)
	arg0_4.selectedIds = Clone(var0_4.selectedIds or {})
	arg0_4.checkEquipment = var0_4.onEquipment or function(arg0_6, arg1_6, arg2_6)
		return true
	end
	arg0_4.onSelected = var0_4.onSelected or function()
		warning("not implemented.")
	end
	arg0_4.BatchDisposeBtn = arg0_4.bottomPanel:Find("dispos")

	if not arg0_4.BatchDisposeBtn then
		arg0_4.BatchDisposeBtn = arg0_4.bottomBack:Find("dispos")
	end

	arg0_4.selectPanel = arg0_4.topItems:Find("adapt/select_panel")

	setActive(arg0_4.selectPanel, true)
	setAnchoredPosition(arg0_4.selectPanel, {
		y = -124
	})

	arg0_4.selectTransformPanel = arg0_4.topItems:Find("adapt/select_transform_panel")

	setActive(arg0_4.selectTransformPanel, false)

	arg0_4.listEmptyTF = arg0_4._tf:Find("adapt/empty")

	setActive(arg0_4.listEmptyTF, false)

	arg0_4.listEmptyTxt = arg0_4.listEmptyTF:Find("Text")
	arg0_4.destroyConfirmView = DestroyConfirmView.New(arg0_4.topItems, arg0_4.event)
	arg0_4.assignedItemView = AssignedItemView.New(arg0_4.topItems, arg0_4.event)
	arg0_4.blueprintAssignedItemView = BlueprintAssignedItemView.New(arg0_4.topItems, arg0_4.event)
	arg0_4.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0_4.topItems, arg0_4.event)
	arg0_4.isEquipingOn = false
	arg0_4.msgBox = SelectSkinMsgbox.New(arg0_4._tf, arg0_4.event)
end

function var0_0.setEquipment(arg0_8, arg1_8)
	local var0_8 = #arg0_8.equipmentVOs + 1

	for iter0_8, iter1_8 in ipairs(arg0_8.equipmentVOs) do
		if not iter1_8.shipId and iter1_8.id == arg1_8.id then
			var0_8 = iter0_8

			break
		end
	end

	if arg1_8.count > 0 then
		arg0_8.equipmentVOs[var0_8] = arg1_8
		arg0_8.equipmentVOByIds[arg1_8.id] = arg1_8
	else
		table.remove(arg0_8.equipmentVOs, var0_8)

		arg0_8.equipmentVOByIds[arg1_8.id] = nil
	end
end

function var0_0.setEquipmentUpdate(arg0_9)
	if arg0_9.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
		arg0_9:filterEquipment()
		arg0_9:updateCapacity()
	end
end

function var0_0.addShipEquipment(arg0_10, arg1_10)
	for iter0_10, iter1_10 in pairs(arg0_10.equipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_10, arg1_10) then
			arg0_10.equipmentVOs[iter0_10] = arg1_10

			return
		end
	end

	table.insert(arg0_10.equipmentVOs, arg1_10)
end

function var0_0.removeShipEquipment(arg0_11, arg1_11)
	for iter0_11 = #arg0_11.equipmentVOs, 1, -1 do
		local var0_11 = arg0_11.equipmentVOs[iter0_11]

		if EquipmentProxy.SameEquip(var0_11, arg1_11) then
			table.remove(arg0_11.equipmentVOs, iter0_11)
		end
	end
end

function var0_0.setEquipmentSkin(arg0_12, arg1_12)
	local var0_12 = true

	for iter0_12, iter1_12 in pairs(arg0_12.equipmentVOs) do
		if iter1_12.id == arg1_12.id and iter1_12.isSkin then
			arg0_12.equipmentVOs[iter0_12] = {
				isSkin = true,
				id = arg1_12.id,
				count = arg1_12.count
			}
			var0_12 = false
		end
	end

	if var0_12 then
		table.insert(arg0_12.equipmentVOs, {
			isSkin = true,
			id = arg1_12.id,
			count = arg1_12.count
		})
	end
end

function var0_0.setEquipmentSkinUpdate(arg0_13)
	if arg0_13.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
		arg0_13:filterEquipment()
		arg0_13:updateCapacity()
	end
end

function var0_0.SetSpWeapons(arg0_14, arg1_14)
	arg0_14.spweaponVOs = arg1_14
end

function var0_0.SetSpWeaponUpdate(arg0_15)
	if arg0_15.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0_15.page == var4_0 then
		arg0_15:filterEquipment()
		arg0_15:UpdateSpweaponCapacity()
	elseif arg0_15.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0_15.contextData.designPage == var6_0 then
		arg0_15:UpdateSpweaponCapacity()
	end
end

function var0_0.didEnter(arg0_16)
	setText(arg0_16.selectPanel:Find("tip"), i18n("equipment_select_device_destroy_tip"))
	setActive(arg0_16.topItems:Find("adapt/stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0_16, arg0_16.topItems:Find("adapt/stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(2)
	end, SFX_CONFIRM)
	onButton(arg0_16, arg0_16.helpBtn, function()
		local var0_18

		if arg0_16.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
			if arg0_16.page == var2_0 then
				var0_18 = pg.gametip.help_equipment.tip
			elseif arg0_16.page == var3_0 then
				var0_18 = pg.gametip.help_equipment_skin.tip
			elseif arg0_16.page == var4_0 then
				var0_18 = pg.gametip.spweapon_help_storage.tip
			end
		elseif arg0_16.contextData.warp == StoreHouseConst.WARP_TO_DESIGN then
			if arg0_16.contextData.designPage == var5_0 then
				var0_18 = pg.gametip.help_equipment.tip
			elseif arg0_16.contextData.designPage == var6_0 then
				var0_18 = pg.gametip.spweapon_help_storage.tip
			end
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_18
		})
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.equipmentToggle:Find("equipment"), function(arg0_19)
		if arg0_19 then
			arg0_16.page = var2_0

			arg0_16:SwitchEquipmentType(var2_0)
			arg0_16:UpdateWeaponWrapButtons()
			arg0_16:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.equipmentToggle:Find("skin"), function(arg0_20)
		if arg0_20 then
			arg0_16.page = var3_0

			arg0_16:SwitchEquipmentType(var3_0)
			arg0_16:UpdateWeaponWrapButtons()
			arg0_16:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.equipmentToggle:Find("spweapon"), function(arg0_21)
		if arg0_21 then
			arg0_16.page = var4_0

			arg0_16:SwitchEquipmentType(var4_0)
			arg0_16:UpdateWeaponWrapButtons()
			arg0_16:filterEquipment()
		end
	end, SFX_PANEL)
	setActive(arg0_16.equipmentToggle:Find("spweapon"), not LOCK_SP_WEAPON)
	onToggle(arg0_16, arg0_16.designTabs[var5_0], function(arg0_22)
		if arg0_22 then
			arg0_16.contextData.designPage = var5_0

			arg0_16:emit(EquipmentMediator.OPEN_DESIGN)
			arg0_16:updateCapacity()
			setActive(arg0_16.tip, false)
			setActive(arg0_16.listEmptyTF, false)
		else
			arg0_16:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
		end
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.designTabs[var6_0], function(arg0_23)
		if arg0_23 then
			arg0_16.contextData.designPage = var6_0

			arg0_16:emit(EquipmentMediator.OPEN_SPWEAPON_DESIGN)
			arg0_16:UpdateSpweaponCapacity()
			setActive(arg0_16.tip, false)
			setActive(arg0_16.listEmptyTF, false)
		else
			arg0_16:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.backBtn, function()
		if arg0_16.mode == StoreHouseConst.DESTROY then
			triggerButton(arg0_16.BatchDisposeBtn)

			return
		end

		GetOrAddComponent(arg0_16._tf, typeof(CanvasGroup)).interactable = false

		arg0_16:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onToggle(arg0_16, arg0_16.sortBtn, function(arg0_25)
		if arg0_25 then
			arg0_16:OverlayPanel(arg0_16.sortPanel)
			setActive(arg0_16.sortPanel, true)
			onNextTick(function()
				arg0_16.sortPanelTG.allowSwitchOff = false
			end)
		else
			arg0_16:UnOverlayPanel(arg0_16.sortPanel, arg0_16.topItems)
			setActive(arg0_16.sortPanel, false)

			arg0_16.sortPanelTG.allowSwitchOff = true
		end
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.sortPanel, function()
		triggerToggle(arg0_16.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.indexBtn, function()
		local var0_28 = switch(arg0_16.page, {
			[var2_0] = function()
				return setmetatable({
					indexDatas = Clone(arg0_16.contextData.indexDatas),
					callback = function(arg0_30)
						arg0_16.contextData.indexDatas.typeIndex = arg0_30.typeIndex
						arg0_16.contextData.indexDatas.equipPropertyIndex = arg0_30.equipPropertyIndex
						arg0_16.contextData.indexDatas.equipPropertyIndex2 = arg0_30.equipPropertyIndex2
						arg0_16.contextData.indexDatas.equipAmmoIndex1 = arg0_30.equipAmmoIndex1
						arg0_16.contextData.indexDatas.equipAmmoIndex2 = arg0_30.equipAmmoIndex2
						arg0_16.contextData.indexDatas.equipCampIndex = arg0_30.equipCampIndex
						arg0_16.contextData.indexDatas.rarityIndex = arg0_30.rarityIndex
						arg0_16.contextData.indexDatas.extraIndex = arg0_30.extraIndex

						if arg0_16.filterBusyToggle:GetComponent(typeof(Toggle)) then
							if bit.band(arg0_30.extraIndex, IndexConst.EquipmentExtraEquiping) > 0 then
								arg0_16:SetShowBusyFlag(true)
							end

							triggerToggle(arg0_16.filterBusyToggle, arg0_16:GetShowBusyFlag())
						else
							arg0_16:filterEquipment()
						end
					end
				}, {
					__index = StoreHouseConst.EQUIPMENT_INDEX_COMMON
				})
			end,
			[var4_0] = function()
				return setmetatable({
					indexDatas = Clone(arg0_16.contextData.spweaponIndexDatas),
					callback = function(arg0_32)
						arg0_16.contextData.spweaponIndexDatas.typeIndex = arg0_32.typeIndex
						arg0_16.contextData.spweaponIndexDatas.rarityIndex = arg0_32.rarityIndex

						arg0_16:filterEquipment()
					end
				}, {
					__index = StoreHouseConst.SPWEAPON_INDEX_COMMON
				})
			end
		})

		arg0_16:emit(EquipmentMediator.OPEN_EQUIPMENT_INDEX, var0_28)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.equipSkinFilteBtn, function()
		local var0_33 = {
			display = {
				equipSkinIndex = IndexConst.FlagRange2Bits(IndexConst.EquipSkinIndexAll, IndexConst.EquipSkinIndexAux),
				equipSkinTheme = IndexConst.FlagRange2Str(IndexConst.EquipSkinThemeAll, IndexConst.EquipSkinThemeEnd)
			},
			equipSkinSort = arg0_16.equipSkinSort or IndexConst.EquipSkinSortType,
			equipSkinIndex = arg0_16.equipSkinIndex or IndexConst.Flags2Bits({
				IndexConst.EquipSkinIndexAll
			}),
			equipSkinTheme = arg0_16.equipSkinTheme or IndexConst.Flags2Str({
				IndexConst.EquipSkinThemeAll
			}),
			callback = function(arg0_34)
				arg0_16.equipSkinSort = arg0_34.equipSkinSort
				arg0_16.equipSkinIndex = arg0_34.equipSkinIndex
				arg0_16.equipSkinTheme = arg0_34.equipSkinTheme

				arg0_16:filterEquipment()
			end
		}

		arg0_16:emit(EquipmentMediator.OPEN_EQUIPSKIN_INDEX_LAYER, var0_33)
	end, SFX_PANEL)

	arg0_16.equipmetItems = {}
	arg0_16.itemCards = {}

	arg0_16:initItems()
	arg0_16:initEquipments()

	arg0_16.asc = arg0_16.contextData.asc or false
	arg0_16.contextData.sortData = arg0_16.contextData.sortData or var7_0.sort[1]
	arg0_16.contextData.indexDatas = arg0_16.contextData.indexDatas or {}
	arg0_16.contextData.spweaponIndexDatas = arg0_16.contextData.spweaponIndexDatas or {}
	arg0_16.contextData.spweaponSortData = arg0_16.contextData.spweaponSortData or var8_0.sort[1]

	arg0_16:initSort()
	setActive(arg0_16.itemView, false)
	setActive(arg0_16.equipmentView, false)
	onToggle(arg0_16, arg0_16.materialToggle, function(arg0_35)
		arg0_16.inMaterial = arg0_35

		if arg0_35 and arg0_16.contextData.warp ~= StoreHouseConst.WARP_TO_MATERIAL then
			arg0_16.contextData.warp = StoreHouseConst.WARP_TO_MATERIAL

			setText(arg0_16.tip, i18n("equipment_select_materials_tip"))
			setActive(arg0_16.capacityTF.parent, false)
			setActive(arg0_16.tip, true)
			arg0_16:sortItems()
		end

		setActive(arg0_16.helpBtn, not arg0_35)
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.weaponToggle, function(arg0_36)
		if arg0_36 then
			if arg0_16.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON then
				arg0_16.contextData.warp = StoreHouseConst.WARP_TO_WEAPON

				setActive(arg0_16.tip, false)
				setActive(arg0_16.capacityTF.parent, true)

				if arg0_16.page == var3_0 then
					triggerToggle(arg0_16.equipmentToggle:Find("skin"), true)
				elseif arg0_16.page == var4_0 then
					triggerToggle(arg0_16.equipmentToggle:Find("spweapon"), true)
				else
					triggerToggle(arg0_16.equipmentToggle:Find("equipment"), true)
				end
			end
		else
			setActive(arg0_16.BatchDisposeBtn, false)
			setActive(arg0_16.filterBusyToggle, false)
			setActive(arg0_16.equipmentToggle, false)
		end

		arg0_16.searchBar:EnableOrDisable(arg0_36)
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.designToggle, function(arg0_37)
		if arg0_37 then
			arg0_16.contextData.warp = StoreHouseConst.WARP_TO_DESIGN

			local var0_37 = arg0_16.contextData.designPage or var5_0

			triggerToggle(arg0_16.designTabs[var0_37], true)
			setActive(arg0_16.capacityTF.parent, true)
		else
			arg0_16:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
			arg0_16:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end

		setActive(arg0_16.designTabRoot, arg0_37 and not LOCK_SP_WEAPON)
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.filterBusyToggle, function(arg0_38)
		arg0_16:SetShowBusyFlag(arg0_38)
		arg0_16:filterEquipment()
	end, SFX_PANEL)

	arg0_16.filterEquipWaitting = arg0_16.filterEquipWaitting + 1

	triggerToggle(arg0_16.filterBusyToggle, arg0_16.shipVO)
	onButton(arg0_16, arg0_16.BatchDisposeBtn, function()
		if arg0_16.mode == StoreHouseConst.DESTROY then
			arg0_16.mode = StoreHouseConst.OVERVIEW
			arg0_16.asc = arg0_16.lastasc
			arg0_16.lastasc = nil
			arg0_16.filterImportance = nil

			shiftPanel(arg0_16.bottomBack, nil, 0, nil, 0, true, true)
			shiftPanel(arg0_16.selectPanel, nil, -124, nil, 0, true, true)
			arg0_16:filterEquipment()
		else
			arg0_16.mode = StoreHouseConst.DESTROY
			arg0_16.lastasc = arg0_16.asc
			arg0_16.filterImportance = true
			arg0_16.asc = true

			shiftPanel(arg0_16.bottomBack, nil, -124, nil, 0, true, true)
			shiftPanel(arg0_16.selectPanel, nil, 0, nil, 0, true, true)

			arg0_16.contextData.asc = arg0_16.asc
			arg0_16.contextData.sortData = var7_0.sort[1]

			arg0_16:filterEquipment()
		end

		arg0_16:UpdateWeaponWrapButtons()
	end, SFX_PANEL)
	onButton(arg0_16, findTF(arg0_16.selectPanel, "cancel_button"), function()
		arg0_16:unselecteAllEquips()
		triggerButton(arg0_16.BatchDisposeBtn)
	end, SFX_CANCEL)
	onButton(arg0_16, findTF(arg0_16.selectPanel, "confirm_button"), function()
		local var0_41 = {}

		if underscore.any(arg0_16.selectedIds, function(arg0_42)
			local var0_42 = arg0_16.equipmentVOByIds[arg0_42[1]]

			return var0_42:getConfig("rarity") >= 4 or var0_42:getConfig("level") > 1
		end) then
			table.insert(var0_41, function(arg0_43)
				arg0_16.equipDestroyConfirmWindow:Load()
				arg0_16.equipDestroyConfirmWindow:ActionInvoke("Show", underscore.map(arg0_16.selectedIds, function(arg0_44)
					return setmetatable({
						count = arg0_44[2]
					}, {
						__index = arg0_16.equipmentVOByIds[arg0_44[1]]
					})
				end), arg0_43)
			end)
		end

		seriesAsync(var0_41, function()
			arg0_16.destroyConfirmView:Load()
			arg0_16.destroyConfirmView:ActionInvoke("Show")
			arg0_16.destroyConfirmView:ActionInvoke("DisplayDestroyBonus", arg0_16.selectedIds)
			arg0_16.destroyConfirmView:ActionInvoke("SetConfirmBtnCB", function()
				arg0_16:unselecteAllEquips()
			end)
		end)
	end, SFX_CONFIRM)
	arg0_16:OverlayPanel(arg0_16.blurPanel)
	arg0_16:PlayUIAnimation(arg0_16.blurPanel, "enter")
	arg0_16:OverlayPanel(arg0_16.topItems)

	local var0_16 = arg0_16.contextData.warp or StoreHouseConst.WARP_TO_MATERIAL
	local var1_16 = arg0_16.contextData.mode or StoreHouseConst.OVERVIEW

	arg0_16.contextData.warp = nil
	arg0_16.contextData.mode = nil
	arg0_16.mode = arg0_16.mode or StoreHouseConst.OVERVIEW

	if var0_16 == StoreHouseConst.WARP_TO_DESIGN then
		triggerToggle(arg0_16.designToggle, true)
	elseif var0_16 == StoreHouseConst.WARP_TO_MATERIAL then
		triggerToggle(arg0_16.materialToggle, true)
	elseif var0_16 == StoreHouseConst.WARP_TO_WEAPON then
		if var1_16 == StoreHouseConst.DESTROY then
			arg0_16.filterEquipWaitting = arg0_16.filterEquipWaitting + 1

			triggerToggle(arg0_16.weaponToggle, true)
			triggerButton(arg0_16.BatchDisposeBtn)
		else
			if var1_16 == StoreHouseConst.SKIN then
				arg0_16.page = var3_0
			elseif var1_16 == StoreHouseConst.SPWEAPON then
				arg0_16.page = var4_0
			else
				arg0_16.page = var2_0
			end

			triggerToggle(arg0_16.weaponToggle, true)
		end
	end

	arg0_16.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_16, arg0_16.topItems)
end

function var0_0.isDefaultStatus(arg0_47)
	return underscore(arg0_47.contextData.indexDatas):chain():keys():all(function(arg0_48)
		return arg0_47.contextData.indexDatas[arg0_48] == StoreHouseConst.EQUIPMENT_INDEX_COMMON.customPanels[arg0_48].options[1]
	end):value()
end

function var0_0.isDefaultSpWeaponIndexData(arg0_49)
	return underscore(arg0_49.contextData.spweaponIndexDatas):chain():keys():all(function(arg0_50)
		return arg0_49.contextData.spweaponIndexDatas[arg0_50] == StoreHouseConst.SPWEAPON_INDEX_COMMON.customPanels[arg0_50].options[1]
	end):value()
end

function var0_0.onBackPressed(arg0_51)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_51.sortPanel) then
		triggerButton(arg0_51.sortPanel)
	elseif arg0_51.destroyConfirmView:isShowing() then
		arg0_51.destroyConfirmView:Hide()
	elseif arg0_51.assignedItemView:isShowing() then
		arg0_51.assignedItemView:Hide()
	elseif arg0_51.blueprintAssignedItemView:isShowing() then
		arg0_51.blueprintAssignedItemView:Hide()
	elseif arg0_51.equipDestroyConfirmWindow:isShowing() then
		arg0_51.equipDestroyConfirmWindow:Hide()
	else
		triggerButton(arg0_51.backBtn)
	end
end

function var0_0.updateCapacity(arg0_52)
	if arg0_52.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		return
	end

	setText(arg0_52.tip, "")
	setText(arg0_52.capacityTF, arg0_52.capacity .. "/" .. arg0_52.player:getMaxEquipmentBag())
end

function var0_0.setCapacity(arg0_53, arg1_53)
	arg0_53.capacity = arg1_53
end

function var0_0.UpdateSpweaponCapacity(arg0_54)
	local var0_54 = getProxy(EquipmentProxy)

	setText(arg0_54.capacityTF, var0_54:GetSpWeaponCount() .. "/" .. var0_54:GetSpWeaponCapacity())
end

function var0_0.setShip(arg0_55, arg1_55)
	arg0_55.shipVO = arg1_55

	setActive(arg0_55.bottomPanel, not tobool(arg1_55))
end

function var0_0.setPlayer(arg0_56, arg1_56)
	arg0_56.player = arg1_56

	if arg0_56.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0_56.page == var2_0 then
		arg0_56:updateCapacity()
	elseif arg0_56.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0_56.contextData.designPage == var5_0 then
		arg0_56:updateCapacity()
	end
end

function var0_0.initSort(arg0_57)
	onButton(arg0_57, arg0_57.decBtn, function()
		arg0_57.asc = not arg0_57.asc
		arg0_57.contextData.asc = arg0_57.asc

		arg0_57:filterEquipment()
	end)

	arg0_57.sortButtons = {}

	eachChild(arg0_57.sortContain, function(arg0_59)
		setActive(arg0_59, false)
	end)

	for iter0_57, iter1_57 in ipairs(var7_0.sort) do
		local var0_57 = iter0_57 <= arg0_57.sortContain.childCount and arg0_57.sortContain:GetChild(iter0_57 - 1) or cloneTplTo(arg0_57.sortTpl, arg0_57.sortContain)

		setActive(var0_57, true)
		setImageSprite(findTF(var0_57, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1_57.spr), true)
		onToggle(arg0_57, var0_57, function(arg0_60)
			if arg0_60 then
				if arg0_57.page == var2_0 then
					arg0_57.contextData.sortData = iter1_57
				elseif arg0_57.page == var4_0 then
					arg0_57.contextData.spweaponSortData = var8_0.sort[iter0_57]
				end

				arg0_57:filterEquipment()
				triggerToggle(arg0_57.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0_57.sortButtons[iter0_57] = var0_57
	end
end

function var0_0.UpdateWeaponWrapButtons(arg0_61)
	local var0_61 = arg0_61.page

	setActive(arg0_61.indexBtn, var0_61 == var2_0 or var0_61 == var4_0)
	setActive(arg0_61.sortBtn, var0_61 == var2_0 or var0_61 == var4_0)
	setActive(arg0_61.BatchDisposeBtn, var0_61 == var2_0)
	setActive(arg0_61.capacityTF.parent, var0_61 == var2_0 or var0_61 == var4_0)
	setActive(arg0_61.equipSkinFilteBtn, var0_61 == var3_0)
	setActive(arg0_61.filterBusyToggle, arg0_61.mode == StoreHouseConst.OVERVIEW)
	setActive(arg0_61.equipmentToggle, arg0_61.mode == StoreHouseConst.OVERVIEW and not arg0_61.contextData.shipId)
	arg0_61:updatePageFilterButtons(var0_61)
end

function var0_0.updatePageFilterButtons(arg0_62, arg1_62)
	for iter0_62, iter1_62 in ipairs(var7_0.sort) do
		triggerToggle(arg0_62.sortButtons[iter0_62], false)
		setActive(arg0_62.sortButtons[iter0_62], table.contains(iter1_62.pages, arg1_62))
	end
end

function var0_0.initEquipments(arg0_63)
	arg0_63.isInitWeapons = true
	arg0_63.equipmentRect = arg0_63.equipmentView:GetComponent("LScrollRect")

	function arg0_63.equipmentRect.onInitItem(arg0_64)
		arg0_63:initEquipment(arg0_64)
	end

	function arg0_63.equipmentRect.onUpdateItem(arg0_65, arg1_65)
		arg0_63:updateEquipment(arg0_65, arg1_65)
	end

	function arg0_63.equipmentRect.onReturnItem(arg0_66, arg1_66)
		arg0_63:returnEquipment(arg0_66, arg1_66)
	end

	function arg0_63.equipmentRect.onStart()
		arg0_63:updateSelected()
	end

	arg0_63.equipmentRect.decelerationRate = 0.07
end

function var0_0.initEquipment(arg0_68, arg1_68)
	local var0_68 = EquipmentItem.New(arg1_68)

	onButton(arg0_68, var0_68.unloadBtn, function()
		if arg0_68.page == var3_0 then
			arg0_68:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT_SKIN)
		elseif arg0_68.page == var2_0 then
			arg0_68:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT)
		end
	end, SFX_PANEL)
	onButton(arg0_68, var0_68.reduceBtn, function()
		arg0_68:selectEquip(var0_68.equipmentVO, 1)
	end, SFX_PANEL)

	arg0_68.equipmetItems[arg1_68] = var0_68
end

function var0_0.updateEquipment(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71.equipmetItems[arg2_71]

	assert(var0_71, "without init item")

	local var1_71 = arg0_71.loadEquipmentVOs[arg1_71 + 1]

	var0_71:update(var1_71)

	local var2_71 = false
	local var3_71 = 0

	if var1_71 then
		for iter0_71, iter1_71 in ipairs(arg0_71.selectedIds) do
			if var1_71.id == iter1_71[1] then
				var2_71 = true
				var3_71 = iter1_71[2]

				break
			end
		end
	end

	var0_71:updateSelected(var2_71, var3_71)

	if not var1_71 then
		removeOnButton(var0_71.go)
	elseif isa(var1_71, SpWeapon) then
		onButton(arg0_71, var0_71.go, function()
			local var0_72 = arg0_71.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				shipId = arg0_71.contextData.shipId,
				oldSpWeaponUid = var1_71:GetUID(),
				oldShipId = var1_71:GetShipId()
			} or var1_71:GetShipId() and {
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				spWeaponUid = var1_71:GetUID(),
				shipId = var1_71:GetShipId()
			} or {
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				spWeaponUid = var1_71:GetUID()
			}

			arg0_71:emit(var0_0.ON_SPWEAPON, var0_72)
		end, SFX_PANEL)
	elseif var0_71.equipmentVO.isSkin then
		if var1_71.shipId then
			onButton(arg0_71, var0_71.go, function()
				local var0_73 = var1_71.shipId
				local var1_73 = var1_71.shipPos

				assert(var1_73, "equipment skin pos is nil")
				arg0_71:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_71.id, arg0_71.contextData.pos, {
					id = var0_73,
					pos = var1_73
				})
			end, SFX_PANEL)
		else
			onButton(arg0_71, var0_71.go, function()
				arg0_71:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_71.id, arg0_71.contextData.pos)
			end, SFX_PANEL)
		end
	elseif var1_71.mask then
		removeOnButton(var0_71.go)
	elseif arg0_71.mode == StoreHouseConst.DESTROY then
		onButton(arg0_71, var0_71.go, function()
			arg0_71:selectEquip(var1_71, var1_71.count)
		end, SFX_PANEL)
	else
		onButton(arg0_71, var0_71.go, function()
			local var0_76 = arg0_71.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				equipmentId = var1_71.id,
				shipId = arg0_71.contextData.shipId,
				pos = arg0_71.contextData.pos,
				oldShipId = var1_71.shipId,
				oldPos = var1_71.shipPos
			} or var1_71.shipId and {
				showTransformTip = true,
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				equipmentId = var1_71.id,
				shipId = var1_71.shipId,
				pos = var1_71.shipPos
			} or {
				destroy = true,
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				equipmentId = var1_71.id
			}

			arg0_71:emit(var0_0.ON_EQUIPMENT, var0_76)
		end, SFX_PANEL)
	end
end

function var0_0.returnEquipment(arg0_77, arg1_77, arg2_77)
	if arg0_77.exited then
		return
	end

	local var0_77 = arg0_77.equipmetItems[arg2_77]

	if var0_77 then
		removeOnButton(var0_77.go)
		var0_77:clear()
	end
end

function var0_0.updateEquipmentCount(arg0_78, arg1_78)
	arg0_78.equipmentRect:SetTotalCount(arg1_78 or #arg0_78.loadEquipmentVOs, -1)
	setActive(arg0_78.listEmptyTF, (arg1_78 or #arg0_78.loadEquipmentVOs) <= 0)
	setText(arg0_78.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.filterEquipment(arg0_79)
	if arg0_79.filterEquipWaitting > 0 then
		arg0_79.filterEquipWaitting = arg0_79.filterEquipWaitting - 1

		return
	end

	if arg0_79.page == var3_0 then
		arg0_79:filterEquipSkin()

		return
	elseif arg0_79.page == var4_0 then
		arg0_79:filterSpWeapon()

		return
	end

	local var0_79 = arg0_79:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_79, function(arg0_80)
		setImageSprite(arg0_79.indexBtn, arg0_80, true)
	end)

	local var1_79 = {}

	arg0_79.loadEquipmentVOs = {}

	for iter0_79, iter1_79 in pairs(arg0_79.equipmentVOs) do
		if not iter1_79.isSkin then
			table.insert(var1_79, iter1_79)
		end
	end

	local var2_79 = {
		arg0_79.contextData.indexDatas.equipPropertyIndex,
		arg0_79.contextData.indexDatas.equipPropertyIndex2
	}

	for iter2_79, iter3_79 in pairs(var1_79) do
		if (iter3_79.count > 0 or iter3_79.shipId) and arg0_79:checkFitBusyCondition(iter3_79) and IndexConst.filterEquipByType(iter3_79, arg0_79.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(iter3_79, var2_79) and IndexConst.filterEquipAmmo1(iter3_79, arg0_79.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(iter3_79, arg0_79.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(iter3_79, arg0_79.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(iter3_79, arg0_79.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(iter3_79, arg0_79.contextData.indexDatas.extraIndex) then
			table.insert(arg0_79.loadEquipmentVOs, iter3_79)
		end
	end

	if arg0_79.filterImportance ~= nil then
		for iter4_79 = #arg0_79.loadEquipmentVOs, 1, -1 do
			local var3_79 = arg0_79.loadEquipmentVOs[iter4_79]

			if var3_79.isSkin or not var3_79.isSkin and var3_79:isImportance() then
				table.remove(arg0_79.loadEquipmentVOs, iter4_79)
			end
		end
	end

	local var4_79 = arg0_79.searchBar:GetInputText()

	if var4_79 and var4_79 ~= "" then
		arg0_79.loadEquipmentVOs = underscore.filter(arg0_79.loadEquipmentVOs, function(arg0_81)
			return arg0_81:IsMatchKey(var4_79)
		end)
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
	setImageSprite(arg0_79.sortBtn:Find("Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", var5_79.spr), true)
	setActive(arg0_79.sortImgAsc, arg0_79.asc)
	setActive(arg0_79.sortImgDec, not arg0_79.asc)
	arg0_79:updateCapacity()
end

function var0_0.filterEquipSkin(arg0_82)
	local var0_82 = arg0_82.equipSkinIndex
	local var1_82 = arg0_82.equipSkinTheme
	local var2_82 = arg0_82.page
	local var3_82 = {}

	arg0_82.loadEquipmentVOs = {}

	if var2_82 ~= var3_0 then
		assert(false, "不是外观分页")
	end

	local var4_82 = arg0_82.searchBar:GetInputText()

	for iter0_82, iter1_82 in pairs(arg0_82.equipmentVOs) do
		if iter1_82.isSkin and iter1_82.count > 0 and (var4_82 == "" or EquipmentTools.IsMatchEquipmentSkinKey(iter1_82.id, var4_82)) then
			table.insert(var3_82, iter1_82)
		end
	end

	for iter2_82, iter3_82 in pairs(var3_82) do
		if IndexConst.filterEquipSkinByIndex(iter3_82, var0_82) and IndexConst.filterEquipSkinByTheme(iter3_82, var1_82) and arg0_82:checkFitBusyCondition(iter3_82) then
			table.insert(arg0_82.loadEquipmentVOs, iter3_82)
		end
	end

	if arg0_82.filterImportance ~= nil then
		for iter4_82 = #arg0_82.loadEquipmentVOs, 1, -1 do
			local var5_82 = arg0_82.loadEquipmentVOs[iter4_82]

			if var5_82.isSkin or not var5_82.isSkin and var5_82:isImportance() then
				table.remove(arg0_82.loadEquipmentVOs, iter4_82)
			end
		end
	end

	local var6_82 = arg0_82.contextData.sortData

	if var6_82 then
		local var7_82 = arg0_82.asc

		table.sort(arg0_82.loadEquipmentVOs, CompareFuncs(var7_0.sortFunc(var6_82, var7_82)))
	end

	if arg0_82.contextData.qiutBtn then
		table.insert(arg0_82.loadEquipmentVOs, 1, false)
	end

	arg0_82:updateSelected()
	arg0_82:updateEquipmentCount()
	setActive(arg0_82.sortImgAsc, arg0_82.asc)
	setActive(arg0_82.sortImgDec, not arg0_82.asc)
end

function var0_0.filterSpWeapon(arg0_83)
	if arg0_83.page ~= var4_0 then
		assert(false, "不是特殊兵装分页")
	end

	local var0_83 = arg0_83:isDefaultSpWeaponIndexData() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_83, function(arg0_84)
		setImageSprite(arg0_83.indexBtn, arg0_84, true)
	end)

	arg0_83.loadEquipmentVOs = {}

	local var1_83 = arg0_83.contextData.spweaponIndexDatas.typeIndex
	local var2_83 = arg0_83.contextData.spweaponIndexDatas.rarityIndex

	for iter0_83, iter1_83 in pairs(arg0_83.spweaponVOs) do
		if IndexConst.filterSpWeaponByType(iter1_83, var1_83) and IndexConst.filterSpWeaponByRarity(iter1_83, var2_83) and arg0_83:checkFitBusyCondition(iter1_83) and (arg0_83.filterImportance == nil or iter1_83:IsImportant()) then
			table.insert(arg0_83.loadEquipmentVOs, iter1_83)
		end
	end

	local var3_83 = arg0_83.searchBar:GetInputText()

	if var3_83 and var3_83 ~= "" then
		local var4_83 = EquipmentTools.GetMatchSpEquipmentListKeyByShip(var3_83)

		arg0_83.loadEquipmentVOs = underscore.filter(arg0_83.loadEquipmentVOs, function(arg0_85)
			return arg0_85:IsMatchKey(var3_83) or table.contains(var4_83, arg0_85.id)
		end)
	end

	local var5_83 = arg0_83.contextData.spweaponSortData

	if var5_83 then
		local var6_83 = arg0_83.asc

		table.sort(arg0_83.loadEquipmentVOs, CompareFuncs(var8_0.sortFunc(var5_83, var6_83)))
	end

	if arg0_83.contextData.qiutBtn then
		table.insert(arg0_83.loadEquipmentVOs, 1, false)
	end

	arg0_83:updateSelected()
	arg0_83:updateEquipmentCount()
	setImageSprite(arg0_83.sortBtn:Find("Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", var5_83.spr), true)
	setActive(arg0_83.sortImgAsc, arg0_83.asc)
	setActive(arg0_83.sortImgDec, not arg0_83.asc)
	arg0_83:UpdateSpweaponCapacity()
end

function var0_0.GetShowBusyFlag(arg0_86)
	return arg0_86.isEquipingOn
end

function var0_0.SetShowBusyFlag(arg0_87, arg1_87)
	arg0_87.isEquipingOn = arg1_87
end

function var0_0.Scroll2Equip(arg0_88, arg1_88)
	if arg0_88.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON or arg0_88.page ~= var2_0 then
		return
	end

	for iter0_88, iter1_88 in ipairs(arg0_88.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_88, arg1_88) then
			local var0_88 = arg0_88.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
			local var1_88 = (var0_88.cellSize.y + var0_88.spacing.y) * math.floor((iter0_88 - 1) / var0_88.constraintCount) + arg0_88.equipmentRect.paddingFront + arg0_88.equipmentView.rect.height * 0.5

			arg0_88:ScrollEquipPos(var1_88 - arg0_88.equipmentRect.paddingFront)

			break
		end
	end
end

function var0_0.ScrollEquipPos(arg0_89, arg1_89)
	local var0_89 = arg0_89.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1_89 = (var0_89.cellSize.y + var0_89.spacing.y) * math.ceil(#arg0_89.loadEquipmentVOs / var0_89.constraintCount) - var0_89.spacing.y + arg0_89.equipmentRect.paddingFront + arg0_89.equipmentRect.paddingEnd
	local var2_89 = var1_89 - arg0_89.equipmentView.rect.height

	var2_89 = var2_89 > 0 and var2_89 or var1_89

	local var3_89 = (arg1_89 - arg0_89.equipmentView.rect.height * 0.5) / var2_89

	arg0_89.equipmentRect:ScrollTo(var3_89)
end

function var0_0.checkFitBusyCondition(arg0_90, arg1_90)
	return not arg1_90.shipId or arg0_90:GetShowBusyFlag() and arg0_90.mode ~= StoreHouseConst.DESTROY
end

function var0_0.setItems(arg0_91, arg1_91)
	arg0_91.itemVOs = arg1_91

	if arg0_91.isInitItems and arg0_91.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		arg0_91:sortItems()
	end
end

function var0_0.initItems(arg0_92)
	arg0_92.isInitItems = true
	arg0_92.itemRect = arg0_92.itemView:GetComponent("LScrollRect")

	function arg0_92.itemRect.onInitItem(arg0_93)
		arg0_92:initItem(arg0_93)
	end

	function arg0_92.itemRect.onUpdateItem(arg0_94, arg1_94)
		arg0_92:updateItem(arg0_94, arg1_94)
	end

	function arg0_92.itemRect.onReturnItem(arg0_95, arg1_95)
		arg0_92:returnItem(arg0_95, arg1_95)
	end

	arg0_92.itemRect.decelerationRate = 0.07
end

function var0_0.sortItems(arg0_96)
	table.sort(arg0_96.itemVOs, CompareFuncs({
		function(arg0_97)
			return -arg0_97:getConfig("order")
		end,
		function(arg0_98)
			return -arg0_98:getConfig("rarity")
		end,
		function(arg0_99)
			return arg0_99.id
		end
	}))
	arg0_96.itemRect:SetTotalCount(#arg0_96.itemVOs, -1)
	setActive(arg0_96.listEmptyTF, #arg0_96.itemVOs <= 0)
	setText(arg0_96.listEmptyTxt, i18n("list_empty_tip_storehouseui_item"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.initItem(arg0_100, arg1_100)
	arg0_100.itemCards[arg1_100] = ItemCard.New(arg1_100)
end

function var0_0.updateItem(arg0_101, arg1_101, arg2_101)
	local var0_101 = arg0_101.itemCards[arg2_101]

	assert(var0_101, "without init item")

	local var1_101 = arg0_101.itemVOs[arg1_101 + 1]

	var0_101:update(var1_101)

	if not var1_101 then
		removeOnButton(var0_101.go)
	elseif tobool(getProxy(TechnologyProxy):getItemCanUnlockBluePrint(var1_101.id)) then
		local var2_101 = getProxy(TechnologyProxy)
		local var3_101 = underscore.map(var2_101:getItemCanUnlockBluePrint(var1_101.id), function(arg0_102)
			return var2_101:getBluePrintById(arg0_102)
		end)
		local var4_101 = underscore.detect(var3_101, function(arg0_103)
			return not arg0_103:isUnlock()
		end)

		if var4_101 then
			onButton(arg0_101, var0_101.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					item = var1_101,
					blueprints = var3_101,
					onYes = function()
						arg0_101:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.SHIPBLUEPRINT, {
							shipBluePrintVO = var4_101
						})
					end,
					yesText = i18n("text_forward")
				})
			end, SFX_PANEL)
		else
			onButton(arg0_101, var0_101.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					windowSize = Vector2(1010, 685),
					item = var1_101,
					blueprints = var3_101,
					onYes = function()
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							type = MSGBOX_TYPE_ITEM_BOX,
							content = i18n("techpackage_item_use_confirm"),
							items = underscore.map(var1_101:getConfig("display_icon"), function(arg0_108)
								return {
									type = arg0_108[1],
									id = arg0_108[2],
									count = arg0_108[3]
								}
							end),
							onYes = function()
								arg0_101:emit(EquipmentMediator.ON_USE_ITEM, var1_101.id, 1)
							end
						})
					end
				})
			end, SFX_PANEL)
		end
	elseif var1_101:getConfig("type") == Item.INVITATION_TYPE then
		onButton(arg0_101, var0_101.go, function()
			arg0_101:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = var1_101
			})
		end, SFX_PANEL)
	elseif var1_101:getConfig("type") == Item.ASSIGNED_TYPE or var1_101:getConfig("type") == Item.EQUIPMENT_ASSIGNED_TYPE then
		if underscore.any(pg.gameset.general_blueprint_list.description, function(arg0_111)
			return var1_101.id == arg0_111
		end) then
			onButton(arg0_101, var0_101.go, function()
				arg0_101.blueprintAssignedItemView:Load()
				arg0_101.blueprintAssignedItemView:ActionInvoke("Show")
				arg0_101.blueprintAssignedItemView:ActionInvoke("update", var1_101)
			end, SFX_PANEL)
		else
			onButton(arg0_101, var0_101.go, function()
				arg0_101.assignedItemView:Load()
				arg0_101.assignedItemView:ActionInvoke("Show")
				arg0_101.assignedItemView:ActionInvoke("update", var1_101)
			end, SFX_PANEL)
		end
	elseif Item.IsLoveLetterCheckItem(var1_101.id) then
		onButton(arg0_101, var0_101.go, function()
			arg0_101:emit(var0_0.ON_ITEM_EXTRA, var1_101.id, var1_101.extra)
		end, SFX_PANEL)
	elseif var1_101:getConfig("type") == Item.LOVE_LETTER_TYPE then
		onButton(arg0_101, var0_101.go, function()
			arg0_101:emit(var0_0.ON_ITEM_EXTRA, var1_101.id, var1_101.extra)
		end, SFX_PANEL)
	elseif var1_101:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
		onButton(arg0_101, var0_101.go, function()
			arg0_101:emit(var0_0.ON_ITEM, var1_101.id, function()
				local var0_117 = var1_101:getConfig("usage_arg")

				if var1_101:IsAllSkinOwner() then
					local var1_117 = Drop.New({
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var0_117[5]
					})

					arg0_101.msgBox:ExecuteAction("Show", {
						content = i18n("blackfriday_pack_select_skinall_dialog", var1_101:getConfig("name"), var1_117:getName()),
						leftDrop = {
							count = 1,
							type = DROP_TYPE_ITEM,
							id = var1_101.id
						},
						rightDrop = var1_117,
						onYes = function()
							arg0_101:emit(EquipmentMediator.ON_USE_ITEM, var1_101.id, 1, {
								0
							})
						end
					})
				else
					local var2_117 = {}

					for iter0_117, iter1_117 in ipairs(var0_117[2]) do
						var2_117[iter1_117] = true
					end

					arg0_101:emit(EquipmentMediator.ITEM_ADD_LAYER, Context.New({
						viewComponent = NewSelectSkinLayer,
						mediator = NewSkinAtlasMediator,
						data = {
							mode = SelectSkinLayer.MODE_SELECT,
							itemId = var1_101.id,
							selectableSkinList = underscore.map(var1_101:GetValidSkinList(), function(arg0_119)
								return SelectableSkin.New({
									id = arg0_119,
									isTimeLimit = var2_117[arg0_119] or false
								})
							end),
							OnConfirm = function(arg0_120)
								arg0_101:emit(EquipmentMediator.ON_USE_ITEM, var1_101.id, 1, {
									arg0_120
								})
							end
						}
					}))
				end
			end)
		end, SFX_PANEL)
	else
		onButton(arg0_101, var0_101.go, function()
			arg0_101:emit(var0_0.ON_ITEM, var1_101.id)
		end, SFX_PANEL)
	end
end

function var0_0.returnItem(arg0_122, arg1_122, arg2_122)
	if arg0_122.exited then
		return
	end

	local var0_122 = arg0_122.itemCards[arg2_122]

	if var0_122 then
		removeOnButton(var0_122.go)
		var0_122:clear()
	end
end

function var0_0.selectCount(arg0_123)
	local var0_123 = 0

	for iter0_123, iter1_123 in ipairs(arg0_123.selectedIds) do
		var0_123 = var0_123 + iter1_123[2]
	end

	return var0_123
end

function var0_0.selectEquip(arg0_124, arg1_124, arg2_124)
	if not arg0_124:checkDestroyGold(arg1_124, arg2_124) then
		return
	end

	if arg0_124.mode == StoreHouseConst.DESTROY then
		local var0_124 = false
		local var1_124
		local var2_124 = 0

		for iter0_124, iter1_124 in pairs(arg0_124.selectedIds) do
			if iter1_124[1] == arg1_124.id then
				var0_124 = true
				var1_124 = iter0_124
				var2_124 = iter1_124[2]

				break
			end
		end

		if not var0_124 then
			local var3_124, var4_124 = arg0_124.checkEquipment(arg1_124, function()
				arg0_124:selectEquip(arg1_124, arg2_124)
			end, arg0_124.selectedIds)

			if not var3_124 then
				if var4_124 then
					pg.TipsMgr.GetInstance():ShowTips(var4_124)
				end

				return
			end

			local var5_124 = arg0_124:selectCount()

			if arg0_124.selectedMax > 0 and var5_124 + arg2_124 > arg0_124.selectedMax then
				arg2_124 = arg0_124.selectedMax - var5_124
			end

			if arg0_124.selectedMax == 0 or var5_124 < arg0_124.selectedMax then
				table.insert(arg0_124.selectedIds, {
					arg1_124.id,
					arg2_124
				})
			elseif arg0_124.selectedMax == 1 then
				arg0_124.selectedIds[1] = {
					arg1_124.id,
					arg2_124
				}
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentScene_selectError_more", arg0_124.selectedMax))

				return
			end
		elseif var2_124 - arg2_124 > 0 then
			arg0_124.selectedIds[var1_124][2] = var2_124 - arg2_124
		else
			table.remove(arg0_124.selectedIds, var1_124)
		end
	end

	arg0_124:updateSelected()
end

function var0_0.unselecteAllEquips(arg0_126)
	arg0_126.selectedIds = {}

	arg0_126:updateSelected()
end

function var0_0.checkDestroyGold(arg0_127, arg1_127, arg2_127)
	local var0_127 = 0
	local var1_127 = false

	for iter0_127, iter1_127 in pairs(arg0_127.selectedIds) do
		local var2_127 = iter1_127[2]

		if Equipment.CanInBag(iter1_127[1]) then
			var0_127 = var0_127 + (Equipment.getConfigData(iter1_127[1]).destory_gold or 0) * var2_127
		end

		if arg1_127 and iter1_127[1] == arg1_127.configId then
			var1_127 = true
		end
	end

	if not var1_127 and arg1_127 and arg2_127 > 0 then
		var0_127 = var0_127 + (arg1_127:getConfig("destory_gold") or 0) * arg2_127
	end

	if arg0_127.player:GoldMax(var0_127) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.updateSelected(arg0_128)
	for iter0_128, iter1_128 in pairs(arg0_128.equipmetItems) do
		if iter1_128.equipmentVO then
			local var0_128 = false
			local var1_128 = 0

			for iter2_128, iter3_128 in pairs(arg0_128.selectedIds) do
				if iter1_128.equipmentVO.id == iter3_128[1] then
					var0_128 = true
					var1_128 = iter3_128[2]

					break
				end
			end

			iter1_128:updateSelected(var0_128, var1_128)
		end
	end

	if arg0_128.mode == StoreHouseConst.DESTROY then
		local var2_128 = arg0_128:selectCount()

		if arg0_128.selectedMax == 0 then
			setText(findTF(arg0_128.selectPanel, "bottom_info/bg_input/count"), var2_128)
		else
			setText(findTF(arg0_128.selectPanel, "bottom_info/bg_input/count"), var2_128 .. "/" .. arg0_128.selectedMax)
		end

		if #arg0_128.selectedIds < arg0_128.selectedMin then
			setActive(findTF(arg0_128.selectPanel, "confirm_button/mask"), true)
		else
			setActive(findTF(arg0_128.selectPanel, "confirm_button/mask"), false)
		end
	end
end

function var0_0.SwitchToDestroy(arg0_129)
	arg0_129.page = var2_0
	arg0_129.filterEquipWaitting = arg0_129.filterEquipWaitting + 1

	triggerToggle(arg0_129.weaponToggle, true)
	triggerButton(arg0_129.BatchDisposeBtn)
end

function var0_0.SwitchToSpWeaponStoreHouse(arg0_130)
	arg0_130.page = var4_0

	triggerToggle(arg0_130.weaponToggle, true)
end

function var0_0.SwitchEquipmentType(arg0_131, arg1_131)
	local var0_131

	if arg1_131 == var4_0 then
		var0_131 = i18n("search_sp_equipment")
	elseif arg1_131 == var3_0 then
		var0_131 = i18n("search_equipment_appearance")
	else
		var0_131 = i18n("search_equipment")
	end

	arg0_131.searchBar:UpdateHolder(var0_131)
	arg0_131.searchBar:ClearInputText()
end

function var0_0.willExit(arg0_132)
	arg0_132:UnOverlayPanel(arg0_132.blurPanel, arg0_132._tf)
	arg0_132:UnOverlayPanel(arg0_132.topItems, arg0_132._tf)

	if arg0_132.bulinTip then
		arg0_132.bulinTip:Destroy()

		arg0_132.bulinTip = nil
	end

	if arg0_132.searchBar then
		arg0_132.searchBar:Dispose()

		arg0_132.searchBar = nil
	end

	arg0_132.destroyConfirmView:Destroy()
	arg0_132.assignedItemView:Destroy()
	arg0_132.blueprintAssignedItemView:Destroy()
	arg0_132.equipDestroyConfirmWindow:Destroy()
	arg0_132.msgBox:Destroy()
end

return var0_0
