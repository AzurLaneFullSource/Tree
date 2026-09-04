local var0_0 = class("StoreHouseScene", import("view.base.BaseUI"))
local var1_0 = 1
local var2_0 = 0
local var3_0 = 1
local var4_0 = 2
local var5_0 = 1
local var6_0 = 2
local var7_0 = 3

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

local var8_0 = require("view.equipment.EquipmentSortCfg")
local var9_0 = require("view.equipment.SpWeaponSortCfg")

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
		parent = arg0_4.topPanel:Find("buttons"),
		expand_parent = arg0_4.blurPanel:Find("adapt"),
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

	arg0_4.designTabs = CustomIndexLayer.Clone2Full(arg0_4.designTabRoot, 3)
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

		setActive(arg0_16.designTabs[var7_0], arg0_22)
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
	setActive(arg0_16.designTabs[var7_0], arg0_16.contextData.designPage == var5_0)

	arg0_16.isShowAllDesign = false

	onToggle(arg0_16, arg0_16.designTabs[var7_0], function(arg0_24)
		arg0_16.isShowAllDesign = arg0_24

		arg0_16:emit(EquipmentMediator.DESIGN_FILTER_CHANGED, arg0_16.isShowAllDesign)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.backBtn, function()
		if arg0_16.mode == StoreHouseConst.DESTROY then
			triggerButton(arg0_16.BatchDisposeBtn)

			return
		end

		GetOrAddComponent(arg0_16._tf, typeof(CanvasGroup)).interactable = false

		arg0_16:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onToggle(arg0_16, arg0_16.sortBtn, function(arg0_26)
		if arg0_26 then
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
		local var0_29 = switch(arg0_16.page, {
			[var2_0] = function()
				return setmetatable({
					indexDatas = Clone(arg0_16.contextData.indexDatas),
					callback = function(arg0_31)
						arg0_16.contextData.indexDatas.typeIndex = arg0_31.typeIndex
						arg0_16.contextData.indexDatas.equipPropertyIndex = arg0_31.equipPropertyIndex
						arg0_16.contextData.indexDatas.equipPropertyIndex2 = arg0_31.equipPropertyIndex2
						arg0_16.contextData.indexDatas.equipAmmoIndex1 = arg0_31.equipAmmoIndex1
						arg0_16.contextData.indexDatas.equipAmmoIndex2 = arg0_31.equipAmmoIndex2
						arg0_16.contextData.indexDatas.equipCampIndex = arg0_31.equipCampIndex
						arg0_16.contextData.indexDatas.rarityIndex = arg0_31.rarityIndex
						arg0_16.contextData.indexDatas.extraIndex = arg0_31.extraIndex

						if arg0_16.filterBusyToggle:GetComponent(typeof(Toggle)) then
							if bit.band(arg0_31.extraIndex, IndexConst.EquipmentExtraEquiping) > 0 then
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
					callback = function(arg0_33)
						arg0_16.contextData.spweaponIndexDatas.typeIndex = arg0_33.typeIndex
						arg0_16.contextData.spweaponIndexDatas.rarityIndex = arg0_33.rarityIndex

						arg0_16:filterEquipment()
					end
				}, {
					__index = StoreHouseConst.SPWEAPON_INDEX_COMMON
				})
			end
		})

		arg0_16:emit(EquipmentMediator.OPEN_EQUIPMENT_INDEX, var0_29)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.equipSkinFilteBtn, function()
		local var0_34 = {
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
			callback = function(arg0_35)
				arg0_16.equipSkinSort = arg0_35.equipSkinSort
				arg0_16.equipSkinIndex = arg0_35.equipSkinIndex
				arg0_16.equipSkinTheme = arg0_35.equipSkinTheme

				arg0_16:filterEquipment()
			end
		}

		arg0_16:emit(EquipmentMediator.OPEN_EQUIPSKIN_INDEX_LAYER, var0_34)
	end, SFX_PANEL)

	arg0_16.equipmetItems = {}
	arg0_16.itemCards = {}

	arg0_16:initItems()
	arg0_16:initEquipments()

	arg0_16.asc = arg0_16.contextData.asc or false
	arg0_16.contextData.sortData = arg0_16.contextData.sortData or var8_0.sort[1]
	arg0_16.contextData.indexDatas = arg0_16.contextData.indexDatas or {}
	arg0_16.contextData.spweaponIndexDatas = arg0_16.contextData.spweaponIndexDatas or {}
	arg0_16.contextData.spweaponSortData = arg0_16.contextData.spweaponSortData or var9_0.sort[1]

	arg0_16:initSort()
	setActive(arg0_16.itemView, false)
	setActive(arg0_16.equipmentView, false)
	onToggle(arg0_16, arg0_16.materialToggle, function(arg0_36)
		arg0_16.inMaterial = arg0_36

		if arg0_36 and arg0_16.contextData.warp ~= StoreHouseConst.WARP_TO_MATERIAL then
			arg0_16.contextData.warp = StoreHouseConst.WARP_TO_MATERIAL

			setText(arg0_16.tip, i18n("equipment_select_materials_tip"))
			setActive(arg0_16.capacityTF.parent, false)
			setActive(arg0_16.tip, true)
			arg0_16:sortItems()
		end

		setActive(arg0_16.helpBtn, not arg0_36)
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.weaponToggle, function(arg0_37)
		if arg0_37 then
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

		arg0_16.searchBar:EnableOrDisable(arg0_37)
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.designToggle, function(arg0_38)
		if arg0_38 then
			arg0_16.contextData.warp = StoreHouseConst.WARP_TO_DESIGN

			local var0_38 = arg0_16.contextData.designPage or var5_0

			triggerToggle(arg0_16.designTabs[var0_38], true)
			setActive(arg0_16.capacityTF.parent, true)
		else
			arg0_16:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
			arg0_16:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end

		setActive(arg0_16.designTabRoot, arg0_38 and not LOCK_SP_WEAPON)
	end, SFX_PANEL)
	onToggle(arg0_16, arg0_16.filterBusyToggle, function(arg0_39)
		arg0_16:SetShowBusyFlag(arg0_39)
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
			arg0_16.contextData.sortData = var8_0.sort[1]

			arg0_16:filterEquipment()
		end

		arg0_16:UpdateWeaponWrapButtons()
	end, SFX_PANEL)
	onButton(arg0_16, findTF(arg0_16.selectPanel, "cancel_button"), function()
		arg0_16:unselecteAllEquips()
		triggerButton(arg0_16.BatchDisposeBtn)
	end, SFX_CANCEL)
	onButton(arg0_16, findTF(arg0_16.selectPanel, "confirm_button"), function()
		local var0_42 = {}

		if underscore.any(arg0_16.selectedIds, function(arg0_43)
			local var0_43 = arg0_16.equipmentVOByIds[arg0_43[1]]

			return var0_43:getConfig("rarity") >= 4 or var0_43:getConfig("level") > 1
		end) then
			table.insert(var0_42, function(arg0_44)
				arg0_16.equipDestroyConfirmWindow:Load()
				arg0_16.equipDestroyConfirmWindow:ActionInvoke("Show", underscore.map(arg0_16.selectedIds, function(arg0_45)
					return setmetatable({
						count = arg0_45[2]
					}, {
						__index = arg0_16.equipmentVOByIds[arg0_45[1]]
					})
				end), arg0_44)
			end)
		end

		seriesAsync(var0_42, function()
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

function var0_0.isDefaultStatus(arg0_48)
	return underscore(arg0_48.contextData.indexDatas):chain():keys():all(function(arg0_49)
		return arg0_48.contextData.indexDatas[arg0_49] == StoreHouseConst.EQUIPMENT_INDEX_COMMON.customPanels[arg0_49].options[1]
	end):value()
end

function var0_0.isDefaultSpWeaponIndexData(arg0_50)
	return underscore(arg0_50.contextData.spweaponIndexDatas):chain():keys():all(function(arg0_51)
		return arg0_50.contextData.spweaponIndexDatas[arg0_51] == StoreHouseConst.SPWEAPON_INDEX_COMMON.customPanels[arg0_51].options[1]
	end):value()
end

function var0_0.onBackPressed(arg0_52)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_52.sortPanel) then
		triggerButton(arg0_52.sortPanel)
	elseif arg0_52.destroyConfirmView:isShowing() then
		arg0_52.destroyConfirmView:Hide()
	elseif arg0_52.assignedItemView:isShowing() then
		arg0_52.assignedItemView:Hide()
	elseif arg0_52.blueprintAssignedItemView:isShowing() then
		arg0_52.blueprintAssignedItemView:Hide()
	elseif arg0_52.equipDestroyConfirmWindow:isShowing() then
		arg0_52.equipDestroyConfirmWindow:Hide()
	else
		triggerButton(arg0_52.backBtn)
	end
end

function var0_0.updateCapacity(arg0_53)
	if arg0_53.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		return
	end

	setText(arg0_53.tip, "")
	setText(arg0_53.capacityTF, arg0_53.capacity .. "/" .. arg0_53.player:getMaxEquipmentBag())
end

function var0_0.setCapacity(arg0_54, arg1_54)
	arg0_54.capacity = arg1_54
end

function var0_0.UpdateSpweaponCapacity(arg0_55)
	local var0_55 = getProxy(EquipmentProxy)

	setText(arg0_55.capacityTF, var0_55:GetSpWeaponCount() .. "/" .. var0_55:GetSpWeaponCapacity())
end

function var0_0.setShip(arg0_56, arg1_56)
	arg0_56.shipVO = arg1_56

	setActive(arg0_56.bottomPanel, not tobool(arg1_56))
end

function var0_0.setPlayer(arg0_57, arg1_57)
	arg0_57.player = arg1_57

	if arg0_57.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0_57.page == var2_0 then
		arg0_57:updateCapacity()
	elseif arg0_57.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0_57.contextData.designPage == var5_0 then
		arg0_57:updateCapacity()
	end
end

function var0_0.initSort(arg0_58)
	onButton(arg0_58, arg0_58.decBtn, function()
		arg0_58.asc = not arg0_58.asc
		arg0_58.contextData.asc = arg0_58.asc

		arg0_58:filterEquipment()
	end)

	arg0_58.sortButtons = {}

	eachChild(arg0_58.sortContain, function(arg0_60)
		setActive(arg0_60, false)
	end)

	for iter0_58, iter1_58 in ipairs(var8_0.sort) do
		local var0_58 = iter0_58 <= arg0_58.sortContain.childCount and arg0_58.sortContain:GetChild(iter0_58 - 1) or cloneTplTo(arg0_58.sortTpl, arg0_58.sortContain)

		setActive(var0_58, true)
		setImageSprite(findTF(var0_58, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1_58.spr), true)
		onToggle(arg0_58, var0_58, function(arg0_61)
			if arg0_61 then
				if arg0_58.page == var2_0 then
					arg0_58.contextData.sortData = iter1_58
				elseif arg0_58.page == var4_0 then
					arg0_58.contextData.spweaponSortData = var9_0.sort[iter0_58]
				end

				arg0_58:filterEquipment()
				triggerToggle(arg0_58.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0_58.sortButtons[iter0_58] = var0_58
	end
end

function var0_0.UpdateWeaponWrapButtons(arg0_62)
	local var0_62 = arg0_62.page

	setActive(arg0_62.indexBtn, var0_62 == var2_0 or var0_62 == var4_0)
	setActive(arg0_62.sortBtn, var0_62 == var2_0 or var0_62 == var4_0)
	setActive(arg0_62.BatchDisposeBtn, var0_62 == var2_0)
	setActive(arg0_62.capacityTF.parent, var0_62 == var2_0 or var0_62 == var4_0)
	setActive(arg0_62.equipSkinFilteBtn, var0_62 == var3_0)
	setActive(arg0_62.filterBusyToggle, arg0_62.mode == StoreHouseConst.OVERVIEW)
	setActive(arg0_62.equipmentToggle, arg0_62.mode == StoreHouseConst.OVERVIEW and not arg0_62.contextData.shipId)
	arg0_62:updatePageFilterButtons(var0_62)
end

function var0_0.updatePageFilterButtons(arg0_63, arg1_63)
	for iter0_63, iter1_63 in ipairs(var8_0.sort) do
		triggerToggle(arg0_63.sortButtons[iter0_63], false)
		setActive(arg0_63.sortButtons[iter0_63], table.contains(iter1_63.pages, arg1_63))
	end
end

function var0_0.initEquipments(arg0_64)
	arg0_64.isInitWeapons = true
	arg0_64.equipmentRect = arg0_64.equipmentView:GetComponent("LScrollRect")

	function arg0_64.equipmentRect.onInitItem(arg0_65)
		arg0_64:initEquipment(arg0_65)
	end

	function arg0_64.equipmentRect.onUpdateItem(arg0_66, arg1_66)
		arg0_64:updateEquipment(arg0_66, arg1_66)
	end

	function arg0_64.equipmentRect.onReturnItem(arg0_67, arg1_67)
		arg0_64:returnEquipment(arg0_67, arg1_67)
	end

	function arg0_64.equipmentRect.onStart()
		arg0_64:updateSelected()
	end

	arg0_64.equipmentRect.decelerationRate = 0.07
end

function var0_0.initEquipment(arg0_69, arg1_69)
	local var0_69 = EquipmentItem.New(arg1_69)

	onButton(arg0_69, var0_69.unloadBtn, function()
		if arg0_69.page == var3_0 then
			arg0_69:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT_SKIN)
		elseif arg0_69.page == var2_0 then
			arg0_69:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT)
		end
	end, SFX_PANEL)
	onButton(arg0_69, var0_69.reduceBtn, function()
		arg0_69:selectEquip(var0_69.equipmentVO, 1)
	end, SFX_PANEL)

	arg0_69.equipmetItems[arg1_69] = var0_69
end

function var0_0.updateEquipment(arg0_72, arg1_72, arg2_72)
	local var0_72 = arg0_72.equipmetItems[arg2_72]

	assert(var0_72, "without init item")

	local var1_72 = arg0_72.loadEquipmentVOs[arg1_72 + 1]

	var0_72:update(var1_72)

	local var2_72 = false
	local var3_72 = 0

	if var1_72 then
		for iter0_72, iter1_72 in ipairs(arg0_72.selectedIds) do
			if var1_72.id == iter1_72[1] then
				var2_72 = true
				var3_72 = iter1_72[2]

				break
			end
		end
	end

	var0_72:updateSelected(var2_72, var3_72)

	if not var1_72 then
		removeOnButton(var0_72.go)
	elseif isa(var1_72, SpWeapon) then
		onButton(arg0_72, var0_72.go, function()
			local var0_73 = arg0_72.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				shipId = arg0_72.contextData.shipId,
				oldSpWeaponUid = var1_72:GetUID(),
				oldShipId = var1_72:GetShipId()
			} or var1_72:GetShipId() and {
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				spWeaponUid = var1_72:GetUID(),
				shipId = var1_72:GetShipId()
			} or {
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				spWeaponUid = var1_72:GetUID()
			}

			arg0_72:emit(var0_0.ON_SPWEAPON, var0_73)
		end, SFX_PANEL)
	elseif var0_72.equipmentVO.isSkin then
		if var1_72.shipId then
			onButton(arg0_72, var0_72.go, function()
				local var0_74 = var1_72.shipId
				local var1_74 = var1_72.shipPos

				assert(var1_74, "equipment skin pos is nil")
				arg0_72:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_72.id, arg0_72.contextData.pos, {
					id = var0_74,
					pos = var1_74
				})
			end, SFX_PANEL)
		else
			onButton(arg0_72, var0_72.go, function()
				arg0_72:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_72.id, arg0_72.contextData.pos)
			end, SFX_PANEL)
		end
	elseif var1_72.mask then
		removeOnButton(var0_72.go)
	elseif arg0_72.mode == StoreHouseConst.DESTROY then
		onButton(arg0_72, var0_72.go, function()
			arg0_72:selectEquip(var1_72, var1_72.count)
		end, SFX_PANEL)
	else
		onButton(arg0_72, var0_72.go, function()
			local var0_77 = arg0_72.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				equipmentId = var1_72.id,
				shipId = arg0_72.contextData.shipId,
				pos = arg0_72.contextData.pos,
				oldShipId = var1_72.shipId,
				oldPos = var1_72.shipPos
			} or var1_72.shipId and {
				showTransformTip = true,
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				equipmentId = var1_72.id,
				shipId = var1_72.shipId,
				pos = var1_72.shipPos
			} or {
				destroy = true,
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				equipmentId = var1_72.id
			}

			arg0_72:emit(var0_0.ON_EQUIPMENT, var0_77)
		end, SFX_PANEL)
	end
end

function var0_0.returnEquipment(arg0_78, arg1_78, arg2_78)
	if arg0_78.exited then
		return
	end

	local var0_78 = arg0_78.equipmetItems[arg2_78]

	if var0_78 then
		removeOnButton(var0_78.go)
		var0_78:clear()
	end
end

function var0_0.updateEquipmentCount(arg0_79, arg1_79)
	arg0_79.equipmentRect:SetTotalCount(arg1_79 or #arg0_79.loadEquipmentVOs, -1)
	setActive(arg0_79.listEmptyTF, (arg1_79 or #arg0_79.loadEquipmentVOs) <= 0)
	setText(arg0_79.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.filterEquipment(arg0_80)
	if arg0_80.filterEquipWaitting > 0 then
		arg0_80.filterEquipWaitting = arg0_80.filterEquipWaitting - 1

		return
	end

	if arg0_80.page == var3_0 then
		arg0_80:filterEquipSkin()

		return
	elseif arg0_80.page == var4_0 then
		arg0_80:filterSpWeapon()

		return
	end

	local var0_80 = arg0_80:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_80, function(arg0_81)
		setImageSprite(arg0_80.indexBtn, arg0_81, true)
	end)

	local var1_80 = {}

	arg0_80.loadEquipmentVOs = {}

	for iter0_80, iter1_80 in pairs(arg0_80.equipmentVOs) do
		if not iter1_80.isSkin then
			table.insert(var1_80, iter1_80)
		end
	end

	local var2_80 = {
		arg0_80.contextData.indexDatas.equipPropertyIndex,
		arg0_80.contextData.indexDatas.equipPropertyIndex2
	}

	for iter2_80, iter3_80 in pairs(var1_80) do
		if (iter3_80.count > 0 or iter3_80.shipId) and arg0_80:checkFitBusyCondition(iter3_80) and IndexConst.filterEquipByType(iter3_80, arg0_80.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(iter3_80, var2_80) and IndexConst.filterEquipAmmo1(iter3_80, arg0_80.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(iter3_80, arg0_80.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(iter3_80, arg0_80.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(iter3_80, arg0_80.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(iter3_80, arg0_80.contextData.indexDatas.extraIndex) then
			table.insert(arg0_80.loadEquipmentVOs, iter3_80)
		end
	end

	if arg0_80.filterImportance ~= nil then
		for iter4_80 = #arg0_80.loadEquipmentVOs, 1, -1 do
			local var3_80 = arg0_80.loadEquipmentVOs[iter4_80]

			if var3_80.isSkin or not var3_80.isSkin and var3_80:isImportance() then
				table.remove(arg0_80.loadEquipmentVOs, iter4_80)
			end
		end
	end

	local var4_80 = arg0_80.searchBar:GetInputText()

	if var4_80 and var4_80 ~= "" then
		arg0_80.loadEquipmentVOs = underscore.filter(arg0_80.loadEquipmentVOs, function(arg0_82)
			return arg0_82:IsMatchKey(var4_80)
		end)
	end

	local var5_80 = arg0_80.contextData.sortData

	if var5_80 then
		local var6_80 = arg0_80.asc

		table.sort(arg0_80.loadEquipmentVOs, CompareFuncs(var8_0.sortFunc(var5_80, var6_80)))
	end

	if arg0_80.contextData.qiutBtn then
		table.insert(arg0_80.loadEquipmentVOs, 1, false)
	end

	arg0_80:updateSelected()
	arg0_80:updateEquipmentCount()
	setImageSprite(arg0_80.sortBtn:Find("Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", var5_80.spr), true)
	setActive(arg0_80.sortImgAsc, arg0_80.asc)
	setActive(arg0_80.sortImgDec, not arg0_80.asc)
	arg0_80:updateCapacity()
end

function var0_0.filterEquipSkin(arg0_83)
	local var0_83 = arg0_83.equipSkinIndex
	local var1_83 = arg0_83.equipSkinTheme
	local var2_83 = arg0_83.page
	local var3_83 = {}

	arg0_83.loadEquipmentVOs = {}

	if var2_83 ~= var3_0 then
		assert(false, "不是外观分页")
	end

	local var4_83 = arg0_83.searchBar:GetInputText()

	for iter0_83, iter1_83 in pairs(arg0_83.equipmentVOs) do
		if iter1_83.isSkin and iter1_83.count > 0 and (var4_83 == "" or EquipmentTools.IsMatchEquipmentSkinKey(iter1_83.id, var4_83)) then
			table.insert(var3_83, iter1_83)
		end
	end

	for iter2_83, iter3_83 in pairs(var3_83) do
		if IndexConst.filterEquipSkinByIndex(iter3_83, var0_83) and IndexConst.filterEquipSkinByTheme(iter3_83, var1_83) and arg0_83:checkFitBusyCondition(iter3_83) then
			table.insert(arg0_83.loadEquipmentVOs, iter3_83)
		end
	end

	if arg0_83.filterImportance ~= nil then
		for iter4_83 = #arg0_83.loadEquipmentVOs, 1, -1 do
			local var5_83 = arg0_83.loadEquipmentVOs[iter4_83]

			if var5_83.isSkin or not var5_83.isSkin and var5_83:isImportance() then
				table.remove(arg0_83.loadEquipmentVOs, iter4_83)
			end
		end
	end

	local var6_83 = arg0_83.contextData.sortData

	if var6_83 then
		local var7_83 = arg0_83.asc

		table.sort(arg0_83.loadEquipmentVOs, CompareFuncs(var8_0.sortFunc(var6_83, var7_83)))
	end

	if arg0_83.contextData.qiutBtn then
		table.insert(arg0_83.loadEquipmentVOs, 1, false)
	end

	arg0_83:updateSelected()
	arg0_83:updateEquipmentCount()
	setActive(arg0_83.sortImgAsc, arg0_83.asc)
	setActive(arg0_83.sortImgDec, not arg0_83.asc)
end

function var0_0.filterSpWeapon(arg0_84)
	if arg0_84.page ~= var4_0 then
		assert(false, "不是特殊兵装分页")
	end

	local var0_84 = arg0_84:isDefaultSpWeaponIndexData() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_84, function(arg0_85)
		setImageSprite(arg0_84.indexBtn, arg0_85, true)
	end)

	arg0_84.loadEquipmentVOs = {}

	local var1_84 = arg0_84.contextData.spweaponIndexDatas.typeIndex
	local var2_84 = arg0_84.contextData.spweaponIndexDatas.rarityIndex

	for iter0_84, iter1_84 in pairs(arg0_84.spweaponVOs) do
		if IndexConst.filterSpWeaponByType(iter1_84, var1_84) and IndexConst.filterSpWeaponByRarity(iter1_84, var2_84) and arg0_84:checkFitBusyCondition(iter1_84) and (arg0_84.filterImportance == nil or iter1_84:IsImportant()) then
			table.insert(arg0_84.loadEquipmentVOs, iter1_84)
		end
	end

	local var3_84 = arg0_84.searchBar:GetInputText()

	if var3_84 and var3_84 ~= "" then
		local var4_84 = EquipmentTools.GetMatchSpEquipmentListKeyByShip(var3_84)

		arg0_84.loadEquipmentVOs = underscore.filter(arg0_84.loadEquipmentVOs, function(arg0_86)
			return arg0_86:IsMatchKey(var3_84) or table.contains(var4_84, arg0_86.id)
		end)
	end

	local var5_84 = arg0_84.contextData.spweaponSortData

	if var5_84 then
		local var6_84 = arg0_84.asc

		table.sort(arg0_84.loadEquipmentVOs, CompareFuncs(var9_0.sortFunc(var5_84, var6_84)))
	end

	if arg0_84.contextData.qiutBtn then
		table.insert(arg0_84.loadEquipmentVOs, 1, false)
	end

	arg0_84:updateSelected()
	arg0_84:updateEquipmentCount()
	setImageSprite(arg0_84.sortBtn:Find("Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", var5_84.spr), true)
	setActive(arg0_84.sortImgAsc, arg0_84.asc)
	setActive(arg0_84.sortImgDec, not arg0_84.asc)
	arg0_84:UpdateSpweaponCapacity()
end

function var0_0.GetShowBusyFlag(arg0_87)
	return arg0_87.isEquipingOn
end

function var0_0.SetShowBusyFlag(arg0_88, arg1_88)
	arg0_88.isEquipingOn = arg1_88
end

function var0_0.Scroll2Equip(arg0_89, arg1_89)
	if arg0_89.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON or arg0_89.page ~= var2_0 then
		return
	end

	for iter0_89, iter1_89 in ipairs(arg0_89.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_89, arg1_89) then
			local var0_89 = arg0_89.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
			local var1_89 = (var0_89.cellSize.y + var0_89.spacing.y) * math.floor((iter0_89 - 1) / var0_89.constraintCount) + arg0_89.equipmentRect.paddingFront + arg0_89.equipmentView.rect.height * 0.5

			arg0_89:ScrollEquipPos(var1_89 - arg0_89.equipmentRect.paddingFront)

			break
		end
	end
end

function var0_0.ScrollEquipPos(arg0_90, arg1_90)
	local var0_90 = arg0_90.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1_90 = (var0_90.cellSize.y + var0_90.spacing.y) * math.ceil(#arg0_90.loadEquipmentVOs / var0_90.constraintCount) - var0_90.spacing.y + arg0_90.equipmentRect.paddingFront + arg0_90.equipmentRect.paddingEnd
	local var2_90 = var1_90 - arg0_90.equipmentView.rect.height

	var2_90 = var2_90 > 0 and var2_90 or var1_90

	local var3_90 = (arg1_90 - arg0_90.equipmentView.rect.height * 0.5) / var2_90

	arg0_90.equipmentRect:ScrollTo(var3_90)
end

function var0_0.checkFitBusyCondition(arg0_91, arg1_91)
	return not arg1_91.shipId or arg0_91:GetShowBusyFlag() and arg0_91.mode ~= StoreHouseConst.DESTROY
end

function var0_0.setItems(arg0_92, arg1_92)
	arg0_92.itemVOs = arg1_92

	if arg0_92.isInitItems and arg0_92.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		arg0_92:sortItems()
	end
end

function var0_0.initItems(arg0_93)
	arg0_93.isInitItems = true
	arg0_93.itemRect = arg0_93.itemView:GetComponent("LScrollRect")

	function arg0_93.itemRect.onInitItem(arg0_94)
		arg0_93:initItem(arg0_94)
	end

	function arg0_93.itemRect.onUpdateItem(arg0_95, arg1_95)
		arg0_93:updateItem(arg0_95, arg1_95)
	end

	function arg0_93.itemRect.onReturnItem(arg0_96, arg1_96)
		arg0_93:returnItem(arg0_96, arg1_96)
	end

	arg0_93.itemRect.decelerationRate = 0.07
end

function var0_0.sortItems(arg0_97)
	table.sort(arg0_97.itemVOs, CompareFuncs({
		function(arg0_98)
			return -arg0_98:getConfig("order")
		end,
		function(arg0_99)
			return -arg0_99:getConfig("rarity")
		end,
		function(arg0_100)
			return arg0_100.id
		end
	}))
	arg0_97.itemRect:SetTotalCount(#arg0_97.itemVOs, -1)
	setActive(arg0_97.listEmptyTF, #arg0_97.itemVOs <= 0)
	setText(arg0_97.listEmptyTxt, i18n("list_empty_tip_storehouseui_item"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.initItem(arg0_101, arg1_101)
	arg0_101.itemCards[arg1_101] = ItemCard.New(arg1_101)
end

function var0_0.updateItem(arg0_102, arg1_102, arg2_102)
	local var0_102 = arg0_102.itemCards[arg2_102]

	assert(var0_102, "without init item")

	local var1_102 = arg0_102.itemVOs[arg1_102 + 1]

	var0_102:update(var1_102)

	if not var1_102 then
		removeOnButton(var0_102.go)
	elseif tobool(getProxy(TechnologyProxy):getItemCanUnlockBluePrint(var1_102.id)) then
		local var2_102 = getProxy(TechnologyProxy)
		local var3_102 = underscore.map(var2_102:getItemCanUnlockBluePrint(var1_102.id), function(arg0_103)
			return var2_102:getBluePrintById(arg0_103)
		end)
		local var4_102 = underscore.detect(var3_102, function(arg0_104)
			return not arg0_104:isUnlock()
		end)

		if var4_102 then
			onButton(arg0_102, var0_102.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					item = var1_102,
					blueprints = var3_102,
					onYes = function()
						arg0_102:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.SHIPBLUEPRINT, {
							shipBluePrintVO = var4_102
						})
					end,
					yesText = i18n("text_forward")
				})
			end, SFX_PANEL)
		else
			onButton(arg0_102, var0_102.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					windowSize = Vector2(1010, 685),
					item = var1_102,
					blueprints = var3_102,
					onYes = function()
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							type = MSGBOX_TYPE_ITEM_BOX,
							content = i18n("techpackage_item_use_confirm"),
							items = underscore.map(var1_102:getConfig("display_icon"), function(arg0_109)
								return {
									type = arg0_109[1],
									id = arg0_109[2],
									count = arg0_109[3]
								}
							end),
							onYes = function()
								arg0_102:emit(EquipmentMediator.ON_USE_ITEM, var1_102.id, 1)
							end
						})
					end
				})
			end, SFX_PANEL)
		end
	elseif var1_102:getConfig("type") == Item.INVITATION_TYPE then
		onButton(arg0_102, var0_102.go, function()
			arg0_102:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = var1_102
			})
		end, SFX_PANEL)
	elseif var1_102:getConfig("type") == Item.ASSIGNED_TYPE or var1_102:getConfig("type") == Item.EQUIPMENT_ASSIGNED_TYPE then
		if var1_102:getConfig("usage") == ItemUsage.EX_RE_MAP then
			onButton(arg0_102, var0_102.go, function()
				arg0_102:emit(var0_0.ON_ITEM, var1_102.id)
			end, SFX_PANEL)
		elseif underscore.any(pg.gameset.general_blueprint_list.description, function(arg0_113)
			return var1_102.id == arg0_113
		end) then
			onButton(arg0_102, var0_102.go, function()
				arg0_102.blueprintAssignedItemView:Load()
				arg0_102.blueprintAssignedItemView:ActionInvoke("Show")
				arg0_102.blueprintAssignedItemView:ActionInvoke("update", var1_102)
			end, SFX_PANEL)
		else
			onButton(arg0_102, var0_102.go, function()
				arg0_102.assignedItemView:Load()
				arg0_102.assignedItemView:ActionInvoke("Show")
				arg0_102.assignedItemView:ActionInvoke("update", var1_102)
			end, SFX_PANEL)
		end
	elseif Item.IsLoveLetterCheckItem(var1_102.id) then
		onButton(arg0_102, var0_102.go, function()
			arg0_102:emit(var0_0.ON_ITEM_EXTRA, var1_102.id, var1_102.extra)
		end, SFX_PANEL)
	elseif var1_102:getConfig("type") == Item.LOVE_LETTER_TYPE then
		onButton(arg0_102, var0_102.go, function()
			arg0_102:emit(var0_0.ON_ITEM_EXTRA, var1_102.id, var1_102.extra)
		end, SFX_PANEL)
	elseif var1_102:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
		onButton(arg0_102, var0_102.go, function()
			arg0_102:emit(var0_0.ON_ITEM, var1_102.id, function()
				local var0_119 = var1_102:getConfig("usage_arg")

				if var1_102:IsAllSkinOwner() then
					local var1_119 = Drop.New({
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var0_119[5]
					})

					arg0_102.msgBox:ExecuteAction("Show", {
						content = i18n("blackfriday_pack_select_skinall_dialog", var1_102:getConfig("name"), var1_119:getName()),
						leftDrop = {
							count = 1,
							type = DROP_TYPE_ITEM,
							id = var1_102.id
						},
						rightDrop = var1_119,
						onYes = function()
							arg0_102:emit(EquipmentMediator.ON_USE_ITEM, var1_102.id, 1, {
								0
							})
						end
					})
				else
					local var2_119 = {}

					for iter0_119, iter1_119 in ipairs(var0_119[2]) do
						var2_119[iter1_119] = true
					end

					arg0_102:emit(EquipmentMediator.ITEM_ADD_LAYER, Context.New({
						viewComponent = NewSelectSkinLayer,
						mediator = NewSkinAtlasMediator,
						data = {
							mode = SelectSkinLayer.MODE_SELECT,
							itemId = var1_102.id,
							selectableSkinList = underscore.map(var1_102:GetValidSkinList(), function(arg0_121)
								return SelectableSkin.New({
									id = arg0_121,
									isTimeLimit = var2_119[arg0_121] or false
								})
							end),
							OnConfirm = function(arg0_122)
								arg0_102:emit(EquipmentMediator.ON_USE_ITEM, var1_102.id, 1, {
									arg0_122
								})
							end
						}
					}))
				end
			end)
		end, SFX_PANEL)
	else
		onButton(arg0_102, var0_102.go, function()
			arg0_102:emit(var0_0.ON_ITEM, var1_102.id)
		end, SFX_PANEL)
	end
end

function var0_0.returnItem(arg0_124, arg1_124, arg2_124)
	if arg0_124.exited then
		return
	end

	local var0_124 = arg0_124.itemCards[arg2_124]

	if var0_124 then
		removeOnButton(var0_124.go)
		var0_124:clear()
	end
end

function var0_0.selectCount(arg0_125)
	local var0_125 = 0

	for iter0_125, iter1_125 in ipairs(arg0_125.selectedIds) do
		var0_125 = var0_125 + iter1_125[2]
	end

	return var0_125
end

function var0_0.selectEquip(arg0_126, arg1_126, arg2_126)
	if not arg0_126:checkDestroyGold(arg1_126, arg2_126) then
		return
	end

	if arg0_126.mode == StoreHouseConst.DESTROY then
		local var0_126 = false
		local var1_126
		local var2_126 = 0

		for iter0_126, iter1_126 in pairs(arg0_126.selectedIds) do
			if iter1_126[1] == arg1_126.id then
				var0_126 = true
				var1_126 = iter0_126
				var2_126 = iter1_126[2]

				break
			end
		end

		if not var0_126 then
			local var3_126, var4_126 = arg0_126.checkEquipment(arg1_126, function()
				arg0_126:selectEquip(arg1_126, arg2_126)
			end, arg0_126.selectedIds)

			if not var3_126 then
				if var4_126 then
					pg.TipsMgr.GetInstance():ShowTips(var4_126)
				end

				return
			end

			local var5_126 = arg0_126:selectCount()

			if arg0_126.selectedMax > 0 and var5_126 + arg2_126 > arg0_126.selectedMax then
				arg2_126 = arg0_126.selectedMax - var5_126
			end

			if arg0_126.selectedMax == 0 or var5_126 < arg0_126.selectedMax then
				table.insert(arg0_126.selectedIds, {
					arg1_126.id,
					arg2_126
				})
			elseif arg0_126.selectedMax == 1 then
				arg0_126.selectedIds[1] = {
					arg1_126.id,
					arg2_126
				}
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentScene_selectError_more", arg0_126.selectedMax))

				return
			end
		elseif var2_126 - arg2_126 > 0 then
			arg0_126.selectedIds[var1_126][2] = var2_126 - arg2_126
		else
			table.remove(arg0_126.selectedIds, var1_126)
		end
	end

	arg0_126:updateSelected()
end

function var0_0.unselecteAllEquips(arg0_128)
	arg0_128.selectedIds = {}

	arg0_128:updateSelected()
end

function var0_0.checkDestroyGold(arg0_129, arg1_129, arg2_129)
	local var0_129 = 0
	local var1_129 = false

	for iter0_129, iter1_129 in pairs(arg0_129.selectedIds) do
		local var2_129 = iter1_129[2]

		if Equipment.CanInBag(iter1_129[1]) then
			var0_129 = var0_129 + (Equipment.getConfigData(iter1_129[1]).destory_gold or 0) * var2_129
		end

		if arg1_129 and iter1_129[1] == arg1_129.configId then
			var1_129 = true
		end
	end

	if not var1_129 and arg1_129 and arg2_129 > 0 then
		var0_129 = var0_129 + (arg1_129:getConfig("destory_gold") or 0) * arg2_129
	end

	if arg0_129.player:GoldMax(var0_129) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.updateSelected(arg0_130)
	for iter0_130, iter1_130 in pairs(arg0_130.equipmetItems) do
		if iter1_130.equipmentVO then
			local var0_130 = false
			local var1_130 = 0

			for iter2_130, iter3_130 in pairs(arg0_130.selectedIds) do
				if iter1_130.equipmentVO.id == iter3_130[1] then
					var0_130 = true
					var1_130 = iter3_130[2]

					break
				end
			end

			iter1_130:updateSelected(var0_130, var1_130)
		end
	end

	if arg0_130.mode == StoreHouseConst.DESTROY then
		local var2_130 = arg0_130:selectCount()

		if arg0_130.selectedMax == 0 then
			setText(findTF(arg0_130.selectPanel, "bottom_info/bg_input/count"), var2_130)
		else
			setText(findTF(arg0_130.selectPanel, "bottom_info/bg_input/count"), var2_130 .. "/" .. arg0_130.selectedMax)
		end

		if #arg0_130.selectedIds < arg0_130.selectedMin then
			setActive(findTF(arg0_130.selectPanel, "confirm_button/mask"), true)
		else
			setActive(findTF(arg0_130.selectPanel, "confirm_button/mask"), false)
		end
	end
end

function var0_0.SwitchToDestroy(arg0_131)
	arg0_131.page = var2_0
	arg0_131.filterEquipWaitting = arg0_131.filterEquipWaitting + 1

	triggerToggle(arg0_131.weaponToggle, true)
	triggerButton(arg0_131.BatchDisposeBtn)
end

function var0_0.SwitchToSpWeaponStoreHouse(arg0_132)
	arg0_132.page = var4_0

	triggerToggle(arg0_132.weaponToggle, true)
end

function var0_0.SwitchEquipmentType(arg0_133, arg1_133)
	local var0_133

	if arg1_133 == var4_0 then
		var0_133 = i18n("search_sp_equipment")
	elseif arg1_133 == var3_0 then
		var0_133 = i18n("search_equipment_appearance")
	else
		var0_133 = i18n("search_equipment")
	end

	arg0_133.searchBar:UpdateHolder(var0_133)
	arg0_133.searchBar:ClearInputText()
end

function var0_0.willExit(arg0_134)
	arg0_134:UnOverlayPanel(arg0_134.blurPanel, arg0_134._tf)
	arg0_134:UnOverlayPanel(arg0_134.topItems, arg0_134._tf)

	if arg0_134.bulinTip then
		arg0_134.bulinTip:Destroy()

		arg0_134.bulinTip = nil
	end

	if arg0_134.searchBar then
		arg0_134.searchBar:Dispose()

		arg0_134.searchBar = nil
	end

	arg0_134.destroyConfirmView:Destroy()
	arg0_134.assignedItemView:Destroy()
	arg0_134.blueprintAssignedItemView:Destroy()
	arg0_134.equipDestroyConfirmWindow:Destroy()
	arg0_134.msgBox:Destroy()
end

return var0_0
