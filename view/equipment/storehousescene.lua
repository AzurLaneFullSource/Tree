local var0_0 = class("StoreHouseScene", import("view.base.BaseUI"))
local var1_0 = 1
local var2_0 = 0
local var3_0 = 1
local var4_0 = 2
local var5_0 = 1
local var6_0 = 2
local var7_0 = 3

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {
		"ui/share/index_atlas",
		"ui/storehouseui",
		"ui/equipmentui_atlas",
		"ui/recordablesearchbarui",
		"ui/iconcolorful"
	}

	return table.insertto(var0_1, var0_0.super.getResource(arg0_1))
end

function var0_0.getUIName(arg0_2)
	return "StoreHouseUI"
end

function var0_0.setEquipments(arg0_3, arg1_3)
	arg0_3.equipmentVOs = arg1_3

	arg0_3:setEquipmentByIds(arg1_3)
end

function var0_0.setEquipmentByIds(arg0_4, arg1_4)
	arg0_4.equipmentVOByIds = {}

	for iter0_4, iter1_4 in pairs(arg1_4) do
		if not iter1_4.isSkin then
			arg0_4.equipmentVOByIds[iter1_4.id] = iter1_4
		end
	end
end

local var8_0 = require("view.equipment.EquipmentSortCfg")
local var9_0 = require("view.equipment.SpWeaponSortCfg")

function var0_0.init(arg0_5)
	arg0_5.filterEquipWaitting = 0

	local var0_5 = arg0_5.contextData

	arg0_5.topItems = arg0_5._tf:Find("topItems")
	arg0_5.equipmentView = arg0_5._tf:Find("adapt/equipment_scrollview")
	arg0_5.blurPanel = arg0_5._tf:Find("blur_panel")
	arg0_5.topPanel = arg0_5.blurPanel:Find("adapt/top")
	arg0_5.indexBtn = arg0_5.topPanel:Find("buttons/index_button")
	arg0_5.sortBtn = arg0_5.topPanel:Find("buttons/sort_button")
	arg0_5.sortPanel = arg0_5.topItems:Find("sort")
	arg0_5.sortPanelTG = arg0_5.sortPanel:GetComponent("ToggleGroup")
	arg0_5.sortPanelTG.allowSwitchOff = true
	arg0_5.sortContain = arg0_5.sortPanel:Find("adapt/mask/panel")
	arg0_5.sortTpl = arg0_5.sortContain:Find("tpl")

	setActive(arg0_5.sortTpl, false)

	arg0_5.equipSkinFilteBtn = arg0_5.topPanel:Find("buttons/EquipSkinFilteBtn")
	arg0_5.searchBar = RecordableSearchBar.New(RecordableSearchBar.CreateData({
		enabledFlag = false,
		holder = i18n("search_equipment"),
		onInputChanged = function()
			arg0_5:filterEquipment()
		end,
		key = arg0_5.__cname,
		parent = arg0_5.topPanel:Find("buttons"),
		expand_parent = arg0_5.blurPanel:Find("adapt"),
		anchoredPosition = Vector3(-1305, arg0_5.topPanel.sizeDelta.y * -0.5, 0)
	}))
	arg0_5.itemView = arg0_5._tf:Find("adapt/item_scrollview")

	local var1_5
	local var2_5 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var2_5:CheckLargeScreen() then
		var1_5 = arg0_5.itemView.rect.width > 2000
	else
		var1_5 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0_5.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var1_5 and 8 or 7
	arg0_5.itemView:Find("item_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var1_5 and 8 or 7
	arg0_5.decBtn = findTF(arg0_5.topPanel, "buttons/dec_btn")
	arg0_5.sortImgAsc = findTF(arg0_5.decBtn, "asc")
	arg0_5.sortImgDec = findTF(arg0_5.decBtn, "desc")
	arg0_5.equipmentToggle = arg0_5._tf:Find("blur_panel/adapt/left_length/frame/toggle_root")

	setActive(arg0_5.equipmentToggle, false)

	arg0_5.filterBusyToggle = arg0_5._tf:Find("blur_panel/adapt/left_length/frame/toggle_equip")

	setActive(arg0_5.filterBusyToggle, false)

	arg0_5.designTabRoot = arg0_5._tf:Find("blur_panel/adapt/left_length/frame/toggle_design")

	setActive(arg0_5.designTabRoot, false)

	arg0_5.designTabs = CustomIndexLayer.Clone2Full(arg0_5.designTabRoot, 3)
	arg0_5.bottomBack = arg0_5.topItems:Find("adapt/bottom_back")
	arg0_5.bottomPanel = arg0_5.bottomBack:Find("types")
	arg0_5.materialToggle = arg0_5.bottomPanel:Find("material")
	arg0_5.weaponToggle = arg0_5.bottomPanel:Find("weapon")
	arg0_5.designToggle = arg0_5.bottomPanel:Find("design")
	arg0_5.capacityTF = arg0_5.bottomBack:Find("bottom_left/tip/capcity/Text")
	arg0_5.tipTF = arg0_5.bottomBack:Find("bottom_left/tip")
	arg0_5.tip = arg0_5.tipTF:Find("label")
	arg0_5.helpBtn = arg0_5.topItems:Find("adapt/help_btn")

	setActive(arg0_5.helpBtn, true)

	arg0_5.backBtn = arg0_5._tf:Find("blur_panel/adapt/top/back_btn")
	arg0_5.selectedMin = defaultValue(var0_5.selectedMin, 1)
	arg0_5.selectedMax = defaultValue(var0_5.selectedMax, pg.gameset.equip_select_limit.key_value or 0)
	arg0_5.selectedIds = Clone(var0_5.selectedIds or {})
	arg0_5.checkEquipment = var0_5.onEquipment or function(arg0_7, arg1_7, arg2_7)
		return true
	end
	arg0_5.onSelected = var0_5.onSelected or function()
		warning("not implemented.")
	end
	arg0_5.BatchDisposeBtn = arg0_5.bottomPanel:Find("dispos")

	if not arg0_5.BatchDisposeBtn then
		arg0_5.BatchDisposeBtn = arg0_5.bottomBack:Find("dispos")
	end

	arg0_5.selectPanel = arg0_5.topItems:Find("adapt/select_panel")

	setActive(arg0_5.selectPanel, true)
	setAnchoredPosition(arg0_5.selectPanel, {
		y = -124
	})

	arg0_5.selectTransformPanel = arg0_5.topItems:Find("adapt/select_transform_panel")

	setActive(arg0_5.selectTransformPanel, false)

	arg0_5.listEmptyTF = arg0_5._tf:Find("adapt/empty")

	setActive(arg0_5.listEmptyTF, false)

	arg0_5.listEmptyTxt = arg0_5.listEmptyTF:Find("Text")
	arg0_5.destroyConfirmView = DestroyConfirmView.New(arg0_5.topItems, arg0_5.event)
	arg0_5.assignedItemView = AssignedItemView.New(arg0_5.topItems, arg0_5.event)
	arg0_5.blueprintAssignedItemView = BlueprintAssignedItemView.New(arg0_5.topItems, arg0_5.event)
	arg0_5.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0_5.topItems, arg0_5.event)
	arg0_5.isEquipingOn = false
	arg0_5.msgBox = SelectSkinMsgbox.New(arg0_5._tf, arg0_5.event)
end

function var0_0.setEquipment(arg0_9, arg1_9)
	local var0_9 = #arg0_9.equipmentVOs + 1

	for iter0_9, iter1_9 in ipairs(arg0_9.equipmentVOs) do
		if not iter1_9.shipId and iter1_9.id == arg1_9.id then
			var0_9 = iter0_9

			break
		end
	end

	if arg1_9.count > 0 then
		arg0_9.equipmentVOs[var0_9] = arg1_9
		arg0_9.equipmentVOByIds[arg1_9.id] = arg1_9
	else
		table.remove(arg0_9.equipmentVOs, var0_9)

		arg0_9.equipmentVOByIds[arg1_9.id] = nil
	end
end

function var0_0.setEquipmentUpdate(arg0_10)
	if arg0_10.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
		arg0_10:filterEquipment()
		arg0_10:updateCapacity()
	end
end

function var0_0.addShipEquipment(arg0_11, arg1_11)
	for iter0_11, iter1_11 in pairs(arg0_11.equipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_11, arg1_11) then
			arg0_11.equipmentVOs[iter0_11] = arg1_11

			return
		end
	end

	table.insert(arg0_11.equipmentVOs, arg1_11)
end

function var0_0.removeShipEquipment(arg0_12, arg1_12)
	for iter0_12 = #arg0_12.equipmentVOs, 1, -1 do
		local var0_12 = arg0_12.equipmentVOs[iter0_12]

		if EquipmentProxy.SameEquip(var0_12, arg1_12) then
			table.remove(arg0_12.equipmentVOs, iter0_12)
		end
	end
end

function var0_0.setEquipmentSkin(arg0_13, arg1_13)
	local var0_13 = true

	for iter0_13, iter1_13 in pairs(arg0_13.equipmentVOs) do
		if iter1_13.id == arg1_13.id and iter1_13.isSkin then
			arg0_13.equipmentVOs[iter0_13] = {
				isSkin = true,
				id = arg1_13.id,
				count = arg1_13.count
			}
			var0_13 = false
		end
	end

	if var0_13 then
		table.insert(arg0_13.equipmentVOs, {
			isSkin = true,
			id = arg1_13.id,
			count = arg1_13.count
		})
	end
end

function var0_0.setEquipmentSkinUpdate(arg0_14)
	if arg0_14.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
		arg0_14:filterEquipment()
		arg0_14:updateCapacity()
	end
end

function var0_0.SetSpWeapons(arg0_15, arg1_15)
	arg0_15.spweaponVOs = arg1_15
end

function var0_0.SetSpWeaponUpdate(arg0_16)
	if arg0_16.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0_16.page == var4_0 then
		arg0_16:filterEquipment()
		arg0_16:UpdateSpweaponCapacity()
	elseif arg0_16.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0_16.contextData.designPage == var6_0 then
		arg0_16:UpdateSpweaponCapacity()
	end
end

function var0_0.didEnter(arg0_17)
	setText(arg0_17.selectPanel:Find("tip"), i18n("equipment_select_device_destroy_tip"))
	setActive(arg0_17.topItems:Find("adapt/stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0_17, arg0_17.topItems:Find("adapt/stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(2)
	end, SFX_CONFIRM)
	onButton(arg0_17, arg0_17.helpBtn, function()
		local var0_19

		if arg0_17.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
			if arg0_17.page == var2_0 then
				var0_19 = pg.gametip.help_equipment.tip
			elseif arg0_17.page == var3_0 then
				var0_19 = pg.gametip.help_equipment_skin.tip
			elseif arg0_17.page == var4_0 then
				var0_19 = pg.gametip.spweapon_help_storage.tip
			end
		elseif arg0_17.contextData.warp == StoreHouseConst.WARP_TO_DESIGN then
			if arg0_17.contextData.designPage == var5_0 then
				var0_19 = pg.gametip.help_equipment.tip
			elseif arg0_17.contextData.designPage == var6_0 then
				var0_19 = pg.gametip.spweapon_help_storage.tip
			end
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_19
		})
	end, SFX_PANEL)
	onToggle(arg0_17, arg0_17.equipmentToggle:Find("equipment"), function(arg0_20)
		if arg0_20 then
			arg0_17.page = var2_0

			arg0_17:SwitchEquipmentType(var2_0)
			arg0_17:UpdateWeaponWrapButtons()
			arg0_17:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0_17, arg0_17.equipmentToggle:Find("skin"), function(arg0_21)
		if arg0_21 then
			arg0_17.page = var3_0

			arg0_17:SwitchEquipmentType(var3_0)
			arg0_17:UpdateWeaponWrapButtons()
			arg0_17:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0_17, arg0_17.equipmentToggle:Find("spweapon"), function(arg0_22)
		if arg0_22 then
			arg0_17.page = var4_0

			arg0_17:SwitchEquipmentType(var4_0)
			arg0_17:UpdateWeaponWrapButtons()
			arg0_17:filterEquipment()
		end
	end, SFX_PANEL)
	setActive(arg0_17.equipmentToggle:Find("spweapon"), not LOCK_SP_WEAPON)
	onToggle(arg0_17, arg0_17.designTabs[var5_0], function(arg0_23)
		if arg0_23 then
			arg0_17.contextData.designPage = var5_0

			arg0_17:emit(EquipmentMediator.OPEN_DESIGN)
			arg0_17:updateCapacity()
			setActive(arg0_17.tip, false)
			setActive(arg0_17.listEmptyTF, false)
		else
			arg0_17:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
		end

		setActive(arg0_17.designTabs[var7_0], arg0_23)
	end, SFX_PANEL)
	onToggle(arg0_17, arg0_17.designTabs[var6_0], function(arg0_24)
		if arg0_24 then
			arg0_17.contextData.designPage = var6_0

			arg0_17:emit(EquipmentMediator.OPEN_SPWEAPON_DESIGN)
			arg0_17:UpdateSpweaponCapacity()
			setActive(arg0_17.tip, false)
			setActive(arg0_17.listEmptyTF, false)
		else
			arg0_17:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end
	end, SFX_PANEL)
	setActive(arg0_17.designTabs[var7_0], arg0_17.contextData.designPage == var5_0)

	arg0_17.isShowAllDesign = false

	onToggle(arg0_17, arg0_17.designTabs[var7_0], function(arg0_25)
		arg0_17.isShowAllDesign = arg0_25

		arg0_17:emit(EquipmentMediator.DESIGN_FILTER_CHANGED, arg0_17.isShowAllDesign)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.backBtn, function()
		if arg0_17.mode == StoreHouseConst.DESTROY then
			triggerButton(arg0_17.BatchDisposeBtn)

			return
		end

		GetOrAddComponent(arg0_17._tf, typeof(CanvasGroup)).interactable = false

		arg0_17:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onToggle(arg0_17, arg0_17.sortBtn, function(arg0_27)
		if arg0_27 then
			arg0_17:OverlayPanel(arg0_17.sortPanel)
			setActive(arg0_17.sortPanel, true)
			onNextTick(function()
				arg0_17.sortPanelTG.allowSwitchOff = false
			end)
		else
			arg0_17:UnOverlayPanel(arg0_17.sortPanel, arg0_17.topItems)
			setActive(arg0_17.sortPanel, false)

			arg0_17.sortPanelTG.allowSwitchOff = true
		end
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.sortPanel, function()
		triggerToggle(arg0_17.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.indexBtn, function()
		local var0_30 = switch(arg0_17.page, {
			[var2_0] = function()
				return setmetatable({
					indexDatas = Clone(arg0_17.contextData.indexDatas),
					callback = function(arg0_32)
						arg0_17.contextData.indexDatas.typeIndex = arg0_32.typeIndex
						arg0_17.contextData.indexDatas.equipPropertyIndex = arg0_32.equipPropertyIndex
						arg0_17.contextData.indexDatas.equipPropertyIndex2 = arg0_32.equipPropertyIndex2
						arg0_17.contextData.indexDatas.equipAmmoIndex1 = arg0_32.equipAmmoIndex1
						arg0_17.contextData.indexDatas.equipAmmoIndex2 = arg0_32.equipAmmoIndex2
						arg0_17.contextData.indexDatas.equipCampIndex = arg0_32.equipCampIndex
						arg0_17.contextData.indexDatas.rarityIndex = arg0_32.rarityIndex
						arg0_17.contextData.indexDatas.extraIndex = arg0_32.extraIndex

						if arg0_17.filterBusyToggle:GetComponent(typeof(Toggle)) then
							if bit.band(arg0_32.extraIndex, IndexConst.EquipmentExtraEquiping) > 0 then
								arg0_17:SetShowBusyFlag(true)
							end

							triggerToggle(arg0_17.filterBusyToggle, arg0_17:GetShowBusyFlag())
						else
							arg0_17:filterEquipment()
						end
					end
				}, {
					__index = StoreHouseConst.EQUIPMENT_INDEX_COMMON
				})
			end,
			[var4_0] = function()
				return setmetatable({
					indexDatas = Clone(arg0_17.contextData.spweaponIndexDatas),
					callback = function(arg0_34)
						arg0_17.contextData.spweaponIndexDatas.typeIndex = arg0_34.typeIndex
						arg0_17.contextData.spweaponIndexDatas.rarityIndex = arg0_34.rarityIndex

						arg0_17:filterEquipment()
					end
				}, {
					__index = StoreHouseConst.SPWEAPON_INDEX_COMMON
				})
			end
		})

		arg0_17:emit(EquipmentMediator.OPEN_EQUIPMENT_INDEX, var0_30)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.equipSkinFilteBtn, function()
		local var0_35 = {
			display = {
				equipSkinIndex = IndexConst.FlagRange2Bits(IndexConst.EquipSkinIndexAll, IndexConst.EquipSkinIndexAux),
				equipSkinTheme = IndexConst.FlagRange2Str(IndexConst.EquipSkinThemeAll, IndexConst.EquipSkinThemeEnd)
			},
			equipSkinSort = arg0_17.equipSkinSort or IndexConst.EquipSkinSortType,
			equipSkinIndex = arg0_17.equipSkinIndex or IndexConst.Flags2Bits({
				IndexConst.EquipSkinIndexAll
			}),
			equipSkinTheme = arg0_17.equipSkinTheme or IndexConst.Flags2Str({
				IndexConst.EquipSkinThemeAll
			}),
			callback = function(arg0_36)
				arg0_17.equipSkinSort = arg0_36.equipSkinSort
				arg0_17.equipSkinIndex = arg0_36.equipSkinIndex
				arg0_17.equipSkinTheme = arg0_36.equipSkinTheme

				arg0_17:filterEquipment()
			end
		}

		arg0_17:emit(EquipmentMediator.OPEN_EQUIPSKIN_INDEX_LAYER, var0_35)
	end, SFX_PANEL)

	arg0_17.equipmetItems = {}
	arg0_17.itemCards = {}

	arg0_17:initItems()
	arg0_17:initEquipments()

	arg0_17.asc = arg0_17.contextData.asc or false
	arg0_17.contextData.sortData = arg0_17.contextData.sortData or var8_0.sort[1]
	arg0_17.contextData.indexDatas = arg0_17.contextData.indexDatas or {}
	arg0_17.contextData.spweaponIndexDatas = arg0_17.contextData.spweaponIndexDatas or {}
	arg0_17.contextData.spweaponSortData = arg0_17.contextData.spweaponSortData or var9_0.sort[1]

	arg0_17:initSort()
	setActive(arg0_17.itemView, false)
	setActive(arg0_17.equipmentView, false)
	onToggle(arg0_17, arg0_17.materialToggle, function(arg0_37)
		arg0_17.inMaterial = arg0_37

		if arg0_37 and arg0_17.contextData.warp ~= StoreHouseConst.WARP_TO_MATERIAL then
			arg0_17.contextData.warp = StoreHouseConst.WARP_TO_MATERIAL

			setText(arg0_17.tip, i18n("equipment_select_materials_tip"))
			setActive(arg0_17.capacityTF.parent, false)
			setActive(arg0_17.tip, true)
			arg0_17:sortItems()
		end

		setActive(arg0_17.helpBtn, not arg0_37)
	end, SFX_PANEL)
	onToggle(arg0_17, arg0_17.weaponToggle, function(arg0_38)
		if arg0_38 then
			if arg0_17.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON then
				arg0_17.contextData.warp = StoreHouseConst.WARP_TO_WEAPON

				setActive(arg0_17.tip, false)
				setActive(arg0_17.capacityTF.parent, true)

				if arg0_17.page == var3_0 then
					triggerToggle(arg0_17.equipmentToggle:Find("skin"), true)
				elseif arg0_17.page == var4_0 then
					triggerToggle(arg0_17.equipmentToggle:Find("spweapon"), true)
				else
					triggerToggle(arg0_17.equipmentToggle:Find("equipment"), true)
				end
			end
		else
			setActive(arg0_17.BatchDisposeBtn, false)
			setActive(arg0_17.filterBusyToggle, false)
			setActive(arg0_17.equipmentToggle, false)
		end

		arg0_17.searchBar:EnableOrDisable(arg0_38)
	end, SFX_PANEL)
	onToggle(arg0_17, arg0_17.designToggle, function(arg0_39)
		if arg0_39 then
			arg0_17.contextData.warp = StoreHouseConst.WARP_TO_DESIGN

			local var0_39 = arg0_17.contextData.designPage or var5_0

			triggerToggle(arg0_17.designTabs[var0_39], true)
			setActive(arg0_17.capacityTF.parent, true)
		else
			arg0_17:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
			arg0_17:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end

		setActive(arg0_17.designTabRoot, arg0_39 and not LOCK_SP_WEAPON)
	end, SFX_PANEL)
	onToggle(arg0_17, arg0_17.filterBusyToggle, function(arg0_40)
		arg0_17:SetShowBusyFlag(arg0_40)
		arg0_17:filterEquipment()
	end, SFX_PANEL)

	arg0_17.filterEquipWaitting = arg0_17.filterEquipWaitting + 1

	triggerToggle(arg0_17.filterBusyToggle, arg0_17.shipVO)
	onButton(arg0_17, arg0_17.BatchDisposeBtn, function()
		if arg0_17.mode == StoreHouseConst.DESTROY then
			arg0_17.mode = StoreHouseConst.OVERVIEW
			arg0_17.asc = arg0_17.lastasc
			arg0_17.lastasc = nil
			arg0_17.filterImportance = nil

			shiftPanel(arg0_17.bottomBack, nil, 0, nil, 0, true, true)
			shiftPanel(arg0_17.selectPanel, nil, -124, nil, 0, true, true)
			arg0_17:filterEquipment()
		else
			arg0_17.mode = StoreHouseConst.DESTROY
			arg0_17.lastasc = arg0_17.asc
			arg0_17.filterImportance = true
			arg0_17.asc = true

			shiftPanel(arg0_17.bottomBack, nil, -124, nil, 0, true, true)
			shiftPanel(arg0_17.selectPanel, nil, 0, nil, 0, true, true)

			arg0_17.contextData.asc = arg0_17.asc
			arg0_17.contextData.sortData = var8_0.sort[1]

			arg0_17:filterEquipment()
		end

		arg0_17:UpdateWeaponWrapButtons()
	end, SFX_PANEL)
	onButton(arg0_17, findTF(arg0_17.selectPanel, "cancel_button"), function()
		arg0_17:unselecteAllEquips()
		triggerButton(arg0_17.BatchDisposeBtn)
	end, SFX_CANCEL)
	onButton(arg0_17, findTF(arg0_17.selectPanel, "confirm_button"), function()
		local var0_43 = {}

		if underscore.any(arg0_17.selectedIds, function(arg0_44)
			local var0_44 = arg0_17.equipmentVOByIds[arg0_44[1]]

			return var0_44:getConfig("rarity") >= 4 or var0_44:getConfig("level") > 1
		end) then
			table.insert(var0_43, function(arg0_45)
				arg0_17.equipDestroyConfirmWindow:Load()
				arg0_17.equipDestroyConfirmWindow:ActionInvoke("Show", underscore.map(arg0_17.selectedIds, function(arg0_46)
					return setmetatable({
						count = arg0_46[2]
					}, {
						__index = arg0_17.equipmentVOByIds[arg0_46[1]]
					})
				end), arg0_45)
			end)
		end

		seriesAsync(var0_43, function()
			arg0_17.destroyConfirmView:Load()
			arg0_17.destroyConfirmView:ActionInvoke("Show")
			arg0_17.destroyConfirmView:ActionInvoke("DisplayDestroyBonus", arg0_17.selectedIds)
			arg0_17.destroyConfirmView:ActionInvoke("SetConfirmBtnCB", function()
				arg0_17:unselecteAllEquips()
			end)
		end)
	end, SFX_CONFIRM)
	arg0_17:OverlayPanel(arg0_17.blurPanel)
	arg0_17:PlayUIAnimation(arg0_17.blurPanel, "enter")
	arg0_17:OverlayPanel(arg0_17.topItems)

	local var0_17 = arg0_17.contextData.warp or StoreHouseConst.WARP_TO_MATERIAL
	local var1_17 = arg0_17.contextData.mode or StoreHouseConst.OVERVIEW

	arg0_17.contextData.warp = nil
	arg0_17.contextData.mode = nil
	arg0_17.mode = arg0_17.mode or StoreHouseConst.OVERVIEW

	if var0_17 == StoreHouseConst.WARP_TO_DESIGN then
		triggerToggle(arg0_17.designToggle, true)
	elseif var0_17 == StoreHouseConst.WARP_TO_MATERIAL then
		triggerToggle(arg0_17.materialToggle, true)
	elseif var0_17 == StoreHouseConst.WARP_TO_WEAPON then
		if var1_17 == StoreHouseConst.DESTROY then
			arg0_17.filterEquipWaitting = arg0_17.filterEquipWaitting + 1

			triggerToggle(arg0_17.weaponToggle, true)
			triggerButton(arg0_17.BatchDisposeBtn)
		else
			if var1_17 == StoreHouseConst.SKIN then
				arg0_17.page = var3_0
			elseif var1_17 == StoreHouseConst.SPWEAPON then
				arg0_17.page = var4_0
			else
				arg0_17.page = var2_0
			end

			triggerToggle(arg0_17.weaponToggle, true)
		end
	end

	arg0_17.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_17, arg0_17.topItems)
end

function var0_0.isDefaultStatus(arg0_49)
	return underscore(arg0_49.contextData.indexDatas):chain():keys():all(function(arg0_50)
		return arg0_49.contextData.indexDatas[arg0_50] == StoreHouseConst.EQUIPMENT_INDEX_COMMON.customPanels[arg0_50].options[1]
	end):value()
end

function var0_0.isDefaultSpWeaponIndexData(arg0_51)
	return underscore(arg0_51.contextData.spweaponIndexDatas):chain():keys():all(function(arg0_52)
		return arg0_51.contextData.spweaponIndexDatas[arg0_52] == StoreHouseConst.SPWEAPON_INDEX_COMMON.customPanels[arg0_52].options[1]
	end):value()
end

function var0_0.onBackPressed(arg0_53)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_53.sortPanel) then
		triggerButton(arg0_53.sortPanel)
	elseif arg0_53.destroyConfirmView:isShowing() then
		arg0_53.destroyConfirmView:Hide()
	elseif arg0_53.assignedItemView:isShowing() then
		arg0_53.assignedItemView:Hide()
	elseif arg0_53.blueprintAssignedItemView:isShowing() then
		arg0_53.blueprintAssignedItemView:Hide()
	elseif arg0_53.equipDestroyConfirmWindow:isShowing() then
		arg0_53.equipDestroyConfirmWindow:Hide()
	else
		triggerButton(arg0_53.backBtn)
	end
end

function var0_0.updateCapacity(arg0_54)
	if arg0_54.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		return
	end

	setText(arg0_54.tip, "")
	setText(arg0_54.capacityTF, arg0_54.capacity .. "/" .. arg0_54.player:getMaxEquipmentBag())
end

function var0_0.setCapacity(arg0_55, arg1_55)
	arg0_55.capacity = arg1_55
end

function var0_0.UpdateSpweaponCapacity(arg0_56)
	local var0_56 = getProxy(EquipmentProxy)

	setText(arg0_56.capacityTF, var0_56:GetSpWeaponCount() .. "/" .. var0_56:GetSpWeaponCapacity())
end

function var0_0.setShip(arg0_57, arg1_57)
	arg0_57.shipVO = arg1_57

	setActive(arg0_57.bottomPanel, not tobool(arg1_57))
end

function var0_0.setPlayer(arg0_58, arg1_58)
	arg0_58.player = arg1_58

	if arg0_58.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0_58.page == var2_0 then
		arg0_58:updateCapacity()
	elseif arg0_58.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0_58.contextData.designPage == var5_0 then
		arg0_58:updateCapacity()
	end
end

function var0_0.initSort(arg0_59)
	onButton(arg0_59, arg0_59.decBtn, function()
		arg0_59.asc = not arg0_59.asc
		arg0_59.contextData.asc = arg0_59.asc

		arg0_59:filterEquipment()
	end)

	arg0_59.sortButtons = {}

	eachChild(arg0_59.sortContain, function(arg0_61)
		setActive(arg0_61, false)
	end)

	for iter0_59, iter1_59 in ipairs(var8_0.sort) do
		local var0_59 = iter0_59 <= arg0_59.sortContain.childCount and arg0_59.sortContain:GetChild(iter0_59 - 1) or cloneTplTo(arg0_59.sortTpl, arg0_59.sortContain)

		setActive(var0_59, true)
		setImageSprite(findTF(var0_59, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1_59.spr), true)
		onToggle(arg0_59, var0_59, function(arg0_62)
			if arg0_62 then
				if arg0_59.page == var2_0 then
					arg0_59.contextData.sortData = iter1_59
				elseif arg0_59.page == var4_0 then
					arg0_59.contextData.spweaponSortData = var9_0.sort[iter0_59]
				end

				arg0_59:filterEquipment()
				triggerToggle(arg0_59.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0_59.sortButtons[iter0_59] = var0_59
	end
end

function var0_0.UpdateWeaponWrapButtons(arg0_63)
	local var0_63 = arg0_63.page

	setActive(arg0_63.indexBtn, var0_63 == var2_0 or var0_63 == var4_0)
	setActive(arg0_63.sortBtn, var0_63 == var2_0 or var0_63 == var4_0)
	setActive(arg0_63.BatchDisposeBtn, var0_63 == var2_0)
	setActive(arg0_63.capacityTF.parent, var0_63 == var2_0 or var0_63 == var4_0)
	setActive(arg0_63.equipSkinFilteBtn, var0_63 == var3_0)
	setActive(arg0_63.filterBusyToggle, arg0_63.mode == StoreHouseConst.OVERVIEW)
	setActive(arg0_63.equipmentToggle, arg0_63.mode == StoreHouseConst.OVERVIEW and not arg0_63.contextData.shipId)
	arg0_63:updatePageFilterButtons(var0_63)
end

function var0_0.updatePageFilterButtons(arg0_64, arg1_64)
	for iter0_64, iter1_64 in ipairs(var8_0.sort) do
		triggerToggle(arg0_64.sortButtons[iter0_64], false)
		setActive(arg0_64.sortButtons[iter0_64], table.contains(iter1_64.pages, arg1_64))
	end
end

function var0_0.initEquipments(arg0_65)
	arg0_65.isInitWeapons = true
	arg0_65.equipmentRect = arg0_65.equipmentView:GetComponent("LScrollRect")

	function arg0_65.equipmentRect.onInitItem(arg0_66)
		arg0_65:initEquipment(arg0_66)
	end

	function arg0_65.equipmentRect.onUpdateItem(arg0_67, arg1_67)
		arg0_65:updateEquipment(arg0_67, arg1_67)
	end

	function arg0_65.equipmentRect.onReturnItem(arg0_68, arg1_68)
		arg0_65:returnEquipment(arg0_68, arg1_68)
	end

	function arg0_65.equipmentRect.onStart()
		arg0_65:updateSelected()
	end

	arg0_65.equipmentRect.decelerationRate = 0.07
end

function var0_0.initEquipment(arg0_70, arg1_70)
	local var0_70 = EquipmentItem.New(arg1_70)

	onButton(arg0_70, var0_70.unloadBtn, function()
		if arg0_70.page == var3_0 then
			arg0_70:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT_SKIN)
		elseif arg0_70.page == var2_0 then
			arg0_70:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT)
		end
	end, SFX_PANEL)
	onButton(arg0_70, var0_70.reduceBtn, function()
		arg0_70:selectEquip(var0_70.equipmentVO, 1)
	end, SFX_PANEL)

	arg0_70.equipmetItems[arg1_70] = var0_70
end

function var0_0.updateEquipment(arg0_73, arg1_73, arg2_73)
	local var0_73 = arg0_73.equipmetItems[arg2_73]

	assert(var0_73, "without init item")

	local var1_73 = arg0_73.loadEquipmentVOs[arg1_73 + 1]

	var0_73:update(var1_73)

	local var2_73 = false
	local var3_73 = 0

	if var1_73 then
		for iter0_73, iter1_73 in ipairs(arg0_73.selectedIds) do
			if var1_73.id == iter1_73[1] then
				var2_73 = true
				var3_73 = iter1_73[2]

				break
			end
		end
	end

	var0_73:updateSelected(var2_73, var3_73)

	if not var1_73 then
		removeOnButton(var0_73.go)
	elseif isa(var1_73, SpWeapon) then
		onButton(arg0_73, var0_73.go, function()
			local var0_74 = arg0_73.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				shipId = arg0_73.contextData.shipId,
				oldSpWeaponUid = var1_73:GetUID(),
				oldShipId = var1_73:GetShipId()
			} or var1_73:GetShipId() and {
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				spWeaponUid = var1_73:GetUID(),
				shipId = var1_73:GetShipId()
			} or {
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				spWeaponUid = var1_73:GetUID()
			}

			arg0_73:emit(var0_0.ON_SPWEAPON, var0_74)
		end, SFX_PANEL)
	elseif var0_73.equipmentVO.isSkin then
		if var1_73.shipId then
			onButton(arg0_73, var0_73.go, function()
				local var0_75 = var1_73.shipId
				local var1_75 = var1_73.shipPos

				assert(var1_75, "equipment skin pos is nil")
				arg0_73:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_73.id, arg0_73.contextData.pos, {
					id = var0_75,
					pos = var1_75
				})
			end, SFX_PANEL)
		else
			onButton(arg0_73, var0_73.go, function()
				arg0_73:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1_73.id, arg0_73.contextData.pos)
			end, SFX_PANEL)
		end
	elseif var1_73.mask then
		removeOnButton(var0_73.go)
	elseif arg0_73.mode == StoreHouseConst.DESTROY then
		onButton(arg0_73, var0_73.go, function()
			arg0_73:selectEquip(var1_73, var1_73.count)
		end, SFX_PANEL)
	else
		onButton(arg0_73, var0_73.go, function()
			local var0_78 = arg0_73.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				equipmentId = var1_73.id,
				shipId = arg0_73.contextData.shipId,
				pos = arg0_73.contextData.pos,
				oldShipId = var1_73.shipId,
				oldPos = var1_73.shipPos
			} or var1_73.shipId and {
				showTransformTip = true,
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				equipmentId = var1_73.id,
				shipId = var1_73.shipId,
				pos = var1_73.shipPos
			} or {
				destroy = true,
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				equipmentId = var1_73.id
			}

			arg0_73:emit(var0_0.ON_EQUIPMENT, var0_78)
		end, SFX_PANEL)
	end
end

function var0_0.returnEquipment(arg0_79, arg1_79, arg2_79)
	if arg0_79.exited then
		return
	end

	local var0_79 = arg0_79.equipmetItems[arg2_79]

	if var0_79 then
		removeOnButton(var0_79.go)
		var0_79:clear()
	end
end

function var0_0.updateEquipmentCount(arg0_80, arg1_80)
	arg0_80.equipmentRect:SetTotalCount(arg1_80 or #arg0_80.loadEquipmentVOs, -1)
	setActive(arg0_80.listEmptyTF, (arg1_80 or #arg0_80.loadEquipmentVOs) <= 0)
	setText(arg0_80.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.filterEquipment(arg0_81)
	if arg0_81.filterEquipWaitting > 0 then
		arg0_81.filterEquipWaitting = arg0_81.filterEquipWaitting - 1

		return
	end

	if arg0_81.page == var3_0 then
		arg0_81:filterEquipSkin()

		return
	elseif arg0_81.page == var4_0 then
		arg0_81:filterSpWeapon()

		return
	end

	local var0_81 = arg0_81:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_81, function(arg0_82)
		setImageSprite(arg0_81.indexBtn, arg0_82, true)
	end)

	local var1_81 = {}

	arg0_81.loadEquipmentVOs = {}

	for iter0_81, iter1_81 in pairs(arg0_81.equipmentVOs) do
		if not iter1_81.isSkin then
			table.insert(var1_81, iter1_81)
		end
	end

	local var2_81 = {
		arg0_81.contextData.indexDatas.equipPropertyIndex,
		arg0_81.contextData.indexDatas.equipPropertyIndex2
	}

	for iter2_81, iter3_81 in pairs(var1_81) do
		if (iter3_81.count > 0 or iter3_81.shipId) and arg0_81:checkFitBusyCondition(iter3_81) and IndexConst.filterEquipByType(iter3_81, arg0_81.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(iter3_81, var2_81) and IndexConst.filterEquipAmmo1(iter3_81, arg0_81.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(iter3_81, arg0_81.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(iter3_81, arg0_81.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(iter3_81, arg0_81.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(iter3_81, arg0_81.contextData.indexDatas.extraIndex) then
			table.insert(arg0_81.loadEquipmentVOs, iter3_81)
		end
	end

	if arg0_81.filterImportance ~= nil then
		for iter4_81 = #arg0_81.loadEquipmentVOs, 1, -1 do
			local var3_81 = arg0_81.loadEquipmentVOs[iter4_81]

			if var3_81.isSkin or not var3_81.isSkin and var3_81:isImportance() then
				table.remove(arg0_81.loadEquipmentVOs, iter4_81)
			end
		end
	end

	local var4_81 = arg0_81.searchBar:GetInputText()

	if var4_81 and var4_81 ~= "" then
		arg0_81.loadEquipmentVOs = underscore.filter(arg0_81.loadEquipmentVOs, function(arg0_83)
			return arg0_83:IsMatchKey(var4_81)
		end)
	end

	local var5_81 = arg0_81.contextData.sortData

	if var5_81 then
		local var6_81 = arg0_81.asc

		table.sort(arg0_81.loadEquipmentVOs, CompareFuncs(var8_0.sortFunc(var5_81, var6_81)))
	end

	if arg0_81.contextData.qiutBtn then
		table.insert(arg0_81.loadEquipmentVOs, 1, false)
	end

	arg0_81:updateSelected()
	arg0_81:updateEquipmentCount()
	setImageSprite(arg0_81.sortBtn:Find("Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", var5_81.spr), true)
	setActive(arg0_81.sortImgAsc, arg0_81.asc)
	setActive(arg0_81.sortImgDec, not arg0_81.asc)
	arg0_81:updateCapacity()
end

function var0_0.filterEquipSkin(arg0_84)
	local var0_84 = arg0_84.equipSkinIndex
	local var1_84 = arg0_84.equipSkinTheme
	local var2_84 = arg0_84.page
	local var3_84 = {}

	arg0_84.loadEquipmentVOs = {}

	if var2_84 ~= var3_0 then
		assert(false, "不是外观分页")
	end

	local var4_84 = arg0_84.searchBar:GetInputText()

	for iter0_84, iter1_84 in pairs(arg0_84.equipmentVOs) do
		if iter1_84.isSkin and iter1_84.count > 0 and (var4_84 == "" or EquipmentTools.IsMatchEquipmentSkinKey(iter1_84.id, var4_84)) then
			table.insert(var3_84, iter1_84)
		end
	end

	for iter2_84, iter3_84 in pairs(var3_84) do
		if IndexConst.filterEquipSkinByIndex(iter3_84, var0_84) and IndexConst.filterEquipSkinByTheme(iter3_84, var1_84) and arg0_84:checkFitBusyCondition(iter3_84) then
			table.insert(arg0_84.loadEquipmentVOs, iter3_84)
		end
	end

	if arg0_84.filterImportance ~= nil then
		for iter4_84 = #arg0_84.loadEquipmentVOs, 1, -1 do
			local var5_84 = arg0_84.loadEquipmentVOs[iter4_84]

			if var5_84.isSkin or not var5_84.isSkin and var5_84:isImportance() then
				table.remove(arg0_84.loadEquipmentVOs, iter4_84)
			end
		end
	end

	local var6_84 = arg0_84.contextData.sortData

	if var6_84 then
		local var7_84 = arg0_84.asc

		table.sort(arg0_84.loadEquipmentVOs, CompareFuncs(var8_0.sortFunc(var6_84, var7_84)))
	end

	if arg0_84.contextData.qiutBtn then
		table.insert(arg0_84.loadEquipmentVOs, 1, false)
	end

	arg0_84:updateSelected()
	arg0_84:updateEquipmentCount()
	setActive(arg0_84.sortImgAsc, arg0_84.asc)
	setActive(arg0_84.sortImgDec, not arg0_84.asc)
end

function var0_0.filterSpWeapon(arg0_85)
	if arg0_85.page ~= var4_0 then
		assert(false, "不是特殊兵装分页")
	end

	local var0_85 = arg0_85:isDefaultSpWeaponIndexData() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_85, function(arg0_86)
		setImageSprite(arg0_85.indexBtn, arg0_86, true)
	end)

	arg0_85.loadEquipmentVOs = {}

	local var1_85 = arg0_85.contextData.spweaponIndexDatas.typeIndex
	local var2_85 = arg0_85.contextData.spweaponIndexDatas.rarityIndex

	for iter0_85, iter1_85 in pairs(arg0_85.spweaponVOs) do
		if IndexConst.filterSpWeaponByType(iter1_85, var1_85) and IndexConst.filterSpWeaponByRarity(iter1_85, var2_85) and arg0_85:checkFitBusyCondition(iter1_85) and (arg0_85.filterImportance == nil or iter1_85:IsImportant()) then
			table.insert(arg0_85.loadEquipmentVOs, iter1_85)
		end
	end

	local var3_85 = arg0_85.searchBar:GetInputText()

	if var3_85 and var3_85 ~= "" then
		local var4_85 = EquipmentTools.GetMatchSpEquipmentListKeyByShip(var3_85)

		arg0_85.loadEquipmentVOs = underscore.filter(arg0_85.loadEquipmentVOs, function(arg0_87)
			return arg0_87:IsMatchKey(var3_85) or table.contains(var4_85, arg0_87.id)
		end)
	end

	local var5_85 = arg0_85.contextData.spweaponSortData

	if var5_85 then
		local var6_85 = arg0_85.asc

		table.sort(arg0_85.loadEquipmentVOs, CompareFuncs(var9_0.sortFunc(var5_85, var6_85)))
	end

	if arg0_85.contextData.qiutBtn then
		table.insert(arg0_85.loadEquipmentVOs, 1, false)
	end

	arg0_85:updateSelected()
	arg0_85:updateEquipmentCount()
	setImageSprite(arg0_85.sortBtn:Find("Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", var5_85.spr), true)
	setActive(arg0_85.sortImgAsc, arg0_85.asc)
	setActive(arg0_85.sortImgDec, not arg0_85.asc)
	arg0_85:UpdateSpweaponCapacity()
end

function var0_0.GetShowBusyFlag(arg0_88)
	return arg0_88.isEquipingOn
end

function var0_0.SetShowBusyFlag(arg0_89, arg1_89)
	arg0_89.isEquipingOn = arg1_89
end

function var0_0.Scroll2Equip(arg0_90, arg1_90)
	if arg0_90.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON or arg0_90.page ~= var2_0 then
		return
	end

	for iter0_90, iter1_90 in ipairs(arg0_90.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(iter1_90, arg1_90) then
			local var0_90 = arg0_90.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
			local var1_90 = (var0_90.cellSize.y + var0_90.spacing.y) * math.floor((iter0_90 - 1) / var0_90.constraintCount) + arg0_90.equipmentRect.paddingFront + arg0_90.equipmentView.rect.height * 0.5

			arg0_90:ScrollEquipPos(var1_90 - arg0_90.equipmentRect.paddingFront)

			break
		end
	end
end

function var0_0.ScrollEquipPos(arg0_91, arg1_91)
	local var0_91 = arg0_91.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1_91 = (var0_91.cellSize.y + var0_91.spacing.y) * math.ceil(#arg0_91.loadEquipmentVOs / var0_91.constraintCount) - var0_91.spacing.y + arg0_91.equipmentRect.paddingFront + arg0_91.equipmentRect.paddingEnd
	local var2_91 = var1_91 - arg0_91.equipmentView.rect.height

	var2_91 = var2_91 > 0 and var2_91 or var1_91

	local var3_91 = (arg1_91 - arg0_91.equipmentView.rect.height * 0.5) / var2_91

	arg0_91.equipmentRect:ScrollTo(var3_91)
end

function var0_0.checkFitBusyCondition(arg0_92, arg1_92)
	return not arg1_92.shipId or arg0_92:GetShowBusyFlag() and arg0_92.mode ~= StoreHouseConst.DESTROY
end

function var0_0.setItems(arg0_93, arg1_93)
	arg0_93.itemVOs = arg1_93

	if arg0_93.isInitItems and arg0_93.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		arg0_93:sortItems()
	end
end

function var0_0.initItems(arg0_94)
	arg0_94.isInitItems = true
	arg0_94.itemRect = arg0_94.itemView:GetComponent("LScrollRect")

	function arg0_94.itemRect.onInitItem(arg0_95)
		arg0_94:initItem(arg0_95)
	end

	function arg0_94.itemRect.onUpdateItem(arg0_96, arg1_96)
		arg0_94:updateItem(arg0_96, arg1_96)
	end

	function arg0_94.itemRect.onReturnItem(arg0_97, arg1_97)
		arg0_94:returnItem(arg0_97, arg1_97)
	end

	arg0_94.itemRect.decelerationRate = 0.07
end

function var0_0.sortItems(arg0_98)
	table.sort(arg0_98.itemVOs, CompareFuncs({
		function(arg0_99)
			return -arg0_99:getConfig("order")
		end,
		function(arg0_100)
			return -arg0_100:getConfig("rarity")
		end,
		function(arg0_101)
			return arg0_101.id
		end
	}))
	arg0_98.itemRect:SetTotalCount(#arg0_98.itemVOs, -1)
	setActive(arg0_98.listEmptyTF, #arg0_98.itemVOs <= 0)
	setText(arg0_98.listEmptyTxt, i18n("list_empty_tip_storehouseui_item"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.initItem(arg0_102, arg1_102)
	arg0_102.itemCards[arg1_102] = ItemCard.New(arg1_102)
end

function var0_0.updateItem(arg0_103, arg1_103, arg2_103)
	local var0_103 = arg0_103.itemCards[arg2_103]

	assert(var0_103, "without init item")

	local var1_103 = arg0_103.itemVOs[arg1_103 + 1]

	var0_103:update(var1_103)

	if not var1_103 then
		removeOnButton(var0_103.go)
	elseif tobool(getProxy(TechnologyProxy):getItemCanUnlockBluePrint(var1_103.id)) then
		local var2_103 = getProxy(TechnologyProxy)
		local var3_103 = underscore.map(var2_103:getItemCanUnlockBluePrint(var1_103.id), function(arg0_104)
			return var2_103:getBluePrintById(arg0_104)
		end)
		local var4_103 = underscore.detect(var3_103, function(arg0_105)
			return not arg0_105:isUnlock()
		end)

		if var4_103 then
			onButton(arg0_103, var0_103.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					item = var1_103,
					blueprints = var3_103,
					onYes = function()
						arg0_103:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.SHIPBLUEPRINT, {
							shipBluePrintVO = var4_103
						})
					end,
					yesText = i18n("text_forward")
				})
			end, SFX_PANEL)
		else
			onButton(arg0_103, var0_103.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					windowSize = Vector2(1010, 685),
					item = var1_103,
					blueprints = var3_103,
					onYes = function()
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							type = MSGBOX_TYPE_ITEM_BOX,
							content = i18n("techpackage_item_use_confirm"),
							items = underscore.map(var1_103:getConfig("display_icon"), function(arg0_110)
								return {
									type = arg0_110[1],
									id = arg0_110[2],
									count = arg0_110[3]
								}
							end),
							onYes = function()
								arg0_103:emit(EquipmentMediator.ON_USE_ITEM, var1_103.id, 1)
							end
						})
					end
				})
			end, SFX_PANEL)
		end
	elseif var1_103:getConfig("type") == Item.INVITATION_TYPE then
		onButton(arg0_103, var0_103.go, function()
			arg0_103:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = var1_103
			})
		end, SFX_PANEL)
	elseif var1_103:getConfig("type") == Item.ASSIGNED_TYPE or var1_103:getConfig("type") == Item.EQUIPMENT_ASSIGNED_TYPE then
		if var1_103:getConfig("usage") == ItemUsage.EX_RE_MAP then
			onButton(arg0_103, var0_103.go, function()
				arg0_103:emit(var0_0.ON_ITEM, var1_103.id)
			end, SFX_PANEL)
		elseif underscore.any(pg.gameset.general_blueprint_list.description, function(arg0_114)
			return var1_103.id == arg0_114
		end) then
			onButton(arg0_103, var0_103.go, function()
				arg0_103.blueprintAssignedItemView:Load()
				arg0_103.blueprintAssignedItemView:ActionInvoke("Show")
				arg0_103.blueprintAssignedItemView:ActionInvoke("update", var1_103)
			end, SFX_PANEL)
		else
			onButton(arg0_103, var0_103.go, function()
				arg0_103.assignedItemView:Load()
				arg0_103.assignedItemView:ActionInvoke("Show")
				arg0_103.assignedItemView:ActionInvoke("update", var1_103)
			end, SFX_PANEL)
		end
	elseif Item.IsLoveLetterCheckItem(var1_103.id) then
		onButton(arg0_103, var0_103.go, function()
			arg0_103:emit(var0_0.ON_ITEM_EXTRA, var1_103.id, var1_103.extra)
		end, SFX_PANEL)
	elseif var1_103:getConfig("type") == Item.LOVE_LETTER_TYPE then
		onButton(arg0_103, var0_103.go, function()
			arg0_103:emit(var0_0.ON_ITEM_EXTRA, var1_103.id, var1_103.extra)
		end, SFX_PANEL)
	elseif var1_103:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
		onButton(arg0_103, var0_103.go, function()
			arg0_103:emit(var0_0.ON_ITEM, var1_103.id, function()
				local var0_120 = var1_103:getConfig("usage_arg")

				if var1_103:IsAllSkinOwner() then
					local var1_120 = Drop.New({
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var0_120[5]
					})

					arg0_103.msgBox:ExecuteAction("Show", {
						content = i18n("blackfriday_pack_select_skinall_dialog", var1_103:getConfig("name"), var1_120:getName()),
						leftDrop = {
							count = 1,
							type = DROP_TYPE_ITEM,
							id = var1_103.id
						},
						rightDrop = var1_120,
						onYes = function()
							arg0_103:emit(EquipmentMediator.ON_USE_ITEM, var1_103.id, 1, {
								0
							})
						end
					})
				else
					local var2_120 = {}

					for iter0_120, iter1_120 in ipairs(var0_120[2]) do
						var2_120[iter1_120] = true
					end

					arg0_103:emit(EquipmentMediator.ITEM_ADD_LAYER, Context.New({
						viewComponent = NewSelectSkinLayer,
						mediator = NewSkinAtlasMediator,
						data = {
							mode = SelectSkinLayer.MODE_SELECT,
							itemId = var1_103.id,
							selectableSkinList = underscore.map(var1_103:GetValidSkinList(), function(arg0_122)
								return SelectableSkin.New({
									id = arg0_122,
									isTimeLimit = var2_120[arg0_122] or false
								})
							end),
							OnConfirm = function(arg0_123)
								arg0_103:emit(EquipmentMediator.ON_USE_ITEM, var1_103.id, 1, {
									arg0_123
								})
							end
						}
					}))
				end
			end)
		end, SFX_PANEL)
	else
		onButton(arg0_103, var0_103.go, function()
			arg0_103:emit(var0_0.ON_ITEM, var1_103.id)
		end, SFX_PANEL)
	end
end

function var0_0.returnItem(arg0_125, arg1_125, arg2_125)
	if arg0_125.exited then
		return
	end

	local var0_125 = arg0_125.itemCards[arg2_125]

	if var0_125 then
		removeOnButton(var0_125.go)
		var0_125:clear()
	end
end

function var0_0.selectCount(arg0_126)
	local var0_126 = 0

	for iter0_126, iter1_126 in ipairs(arg0_126.selectedIds) do
		var0_126 = var0_126 + iter1_126[2]
	end

	return var0_126
end

function var0_0.selectEquip(arg0_127, arg1_127, arg2_127)
	if not arg0_127:checkDestroyGold(arg1_127, arg2_127) then
		return
	end

	if arg0_127.mode == StoreHouseConst.DESTROY then
		local var0_127 = false
		local var1_127
		local var2_127 = 0

		for iter0_127, iter1_127 in pairs(arg0_127.selectedIds) do
			if iter1_127[1] == arg1_127.id then
				var0_127 = true
				var1_127 = iter0_127
				var2_127 = iter1_127[2]

				break
			end
		end

		if not var0_127 then
			local var3_127, var4_127 = arg0_127.checkEquipment(arg1_127, function()
				arg0_127:selectEquip(arg1_127, arg2_127)
			end, arg0_127.selectedIds)

			if not var3_127 then
				if var4_127 then
					pg.TipsMgr.GetInstance():ShowTips(var4_127)
				end

				return
			end

			local var5_127 = arg0_127:selectCount()

			if arg0_127.selectedMax > 0 and var5_127 + arg2_127 > arg0_127.selectedMax then
				arg2_127 = arg0_127.selectedMax - var5_127
			end

			if arg0_127.selectedMax == 0 or var5_127 < arg0_127.selectedMax then
				table.insert(arg0_127.selectedIds, {
					arg1_127.id,
					arg2_127
				})
			elseif arg0_127.selectedMax == 1 then
				arg0_127.selectedIds[1] = {
					arg1_127.id,
					arg2_127
				}
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentScene_selectError_more", arg0_127.selectedMax))

				return
			end
		elseif var2_127 - arg2_127 > 0 then
			arg0_127.selectedIds[var1_127][2] = var2_127 - arg2_127
		else
			table.remove(arg0_127.selectedIds, var1_127)
		end
	end

	arg0_127:updateSelected()
end

function var0_0.unselecteAllEquips(arg0_129)
	arg0_129.selectedIds = {}

	arg0_129:updateSelected()
end

function var0_0.checkDestroyGold(arg0_130, arg1_130, arg2_130)
	local var0_130 = 0
	local var1_130 = false

	for iter0_130, iter1_130 in pairs(arg0_130.selectedIds) do
		local var2_130 = iter1_130[2]

		if Equipment.CanInBag(iter1_130[1]) then
			var0_130 = var0_130 + (Equipment.getConfigData(iter1_130[1]).destory_gold or 0) * var2_130
		end

		if arg1_130 and iter1_130[1] == arg1_130.configId then
			var1_130 = true
		end
	end

	if not var1_130 and arg1_130 and arg2_130 > 0 then
		var0_130 = var0_130 + (arg1_130:getConfig("destory_gold") or 0) * arg2_130
	end

	if arg0_130.player:GoldMax(var0_130) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.updateSelected(arg0_131)
	for iter0_131, iter1_131 in pairs(arg0_131.equipmetItems) do
		if iter1_131.equipmentVO then
			local var0_131 = false
			local var1_131 = 0

			for iter2_131, iter3_131 in pairs(arg0_131.selectedIds) do
				if iter1_131.equipmentVO.id == iter3_131[1] then
					var0_131 = true
					var1_131 = iter3_131[2]

					break
				end
			end

			iter1_131:updateSelected(var0_131, var1_131)
		end
	end

	if arg0_131.mode == StoreHouseConst.DESTROY then
		local var2_131 = arg0_131:selectCount()

		if arg0_131.selectedMax == 0 then
			setText(findTF(arg0_131.selectPanel, "bottom_info/bg_input/count"), var2_131)
		else
			setText(findTF(arg0_131.selectPanel, "bottom_info/bg_input/count"), var2_131 .. "/" .. arg0_131.selectedMax)
		end

		if #arg0_131.selectedIds < arg0_131.selectedMin then
			setActive(findTF(arg0_131.selectPanel, "confirm_button/mask"), true)
		else
			setActive(findTF(arg0_131.selectPanel, "confirm_button/mask"), false)
		end
	end
end

function var0_0.SwitchToDestroy(arg0_132)
	arg0_132.page = var2_0
	arg0_132.filterEquipWaitting = arg0_132.filterEquipWaitting + 1

	triggerToggle(arg0_132.weaponToggle, true)
	triggerButton(arg0_132.BatchDisposeBtn)
end

function var0_0.SwitchToSpWeaponStoreHouse(arg0_133)
	arg0_133.page = var4_0

	triggerToggle(arg0_133.weaponToggle, true)
end

function var0_0.SwitchEquipmentType(arg0_134, arg1_134)
	local var0_134

	if arg1_134 == var4_0 then
		var0_134 = i18n("search_sp_equipment")
	elseif arg1_134 == var3_0 then
		var0_134 = i18n("search_equipment_appearance")
	else
		var0_134 = i18n("search_equipment")
	end

	arg0_134.searchBar:UpdateHolder(var0_134)
	arg0_134.searchBar:ClearInputText()
end

function var0_0.willExit(arg0_135)
	arg0_135:UnOverlayPanel(arg0_135.blurPanel, arg0_135._tf)
	arg0_135:UnOverlayPanel(arg0_135.topItems, arg0_135._tf)

	if arg0_135.bulinTip then
		arg0_135.bulinTip:Destroy()

		arg0_135.bulinTip = nil
	end

	if arg0_135.searchBar then
		arg0_135.searchBar:Dispose()

		arg0_135.searchBar = nil
	end

	arg0_135.destroyConfirmView:Destroy()
	arg0_135.assignedItemView:Destroy()
	arg0_135.blueprintAssignedItemView:Destroy()
	arg0_135.equipDestroyConfirmWindow:Destroy()
	arg0_135.msgBox:Destroy()
end

return var0_0
