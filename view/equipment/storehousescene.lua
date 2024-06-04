local var0 = class("StoreHouseScene", import("view.base.BaseUI"))
local var1 = 1
local var2 = 0
local var3 = 1
local var4 = 2
local var5 = 1
local var6 = 2

function var0.getUIName(arg0)
	return "StoreHouseUI"
end

function var0.setEquipments(arg0, arg1)
	arg0.equipmentVOs = arg1

	arg0:setEquipmentByIds(arg1)
end

function var0.setEquipmentByIds(arg0, arg1)
	arg0.equipmentVOByIds = {}

	for iter0, iter1 in pairs(arg1) do
		if not iter1.isSkin then
			arg0.equipmentVOByIds[iter1.id] = iter1
		end
	end
end

local var7 = require("view.equipment.EquipmentSortCfg")
local var8 = require("view.equipment.SpWeaponSortCfg")

function var0.init(arg0)
	arg0.filterEquipWaitting = 0

	local var0 = arg0.contextData

	arg0.topItems = arg0:findTF("topItems")
	arg0.equipmentView = arg0:findTF("equipment_scrollview")
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.topPanel = arg0:findTF("adapt/top", arg0.blurPanel)
	arg0.indexBtn = arg0:findTF("buttons/index_button", arg0.topPanel)
	arg0.sortBtn = arg0:findTF("buttons/sort_button", arg0.topPanel)
	arg0.sortPanel = arg0:findTF("sort", arg0.topItems)
	arg0.sortContain = arg0:findTF("adapt/mask/panel", arg0.sortPanel)
	arg0.sortTpl = arg0:findTF("tpl", arg0.sortContain)

	setActive(arg0.sortTpl, false)

	arg0.equipSkinFilteBtn = arg0:findTF("buttons/EquipSkinFilteBtn", arg0.topPanel)
	arg0.itemView = arg0:findTF("item_scrollview")

	local var1
	local var2 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var2:CheckLargeScreen() then
		var1 = arg0.itemView.rect.width > 2000
	else
		var1 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var1 and 8 or 7
	arg0.itemView:Find("item_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var1 and 8 or 7
	arg0.decBtn = findTF(arg0.topPanel, "buttons/dec_btn")
	arg0.sortImgAsc = findTF(arg0.decBtn, "asc")
	arg0.sortImgDec = findTF(arg0.decBtn, "desc")
	arg0.equipmentToggle = arg0._tf:Find("blur_panel/adapt/left_length/frame/toggle_root")

	setActive(arg0.equipmentToggle, false)

	arg0.filterBusyToggle = arg0._tf:Find("blur_panel/adapt/left_length/frame/toggle_equip")

	setActive(arg0.filterBusyToggle, false)

	arg0.designTabRoot = arg0._tf:Find("blur_panel/adapt/left_length/frame/toggle_design")

	setActive(arg0.designTabRoot, false)

	arg0.designTabs = CustomIndexLayer.Clone2Full(arg0.designTabRoot, 2)
	arg0.bottomBack = arg0:findTF("adapt/bottom_back", arg0.topItems)
	arg0.bottomPanel = arg0:findTF("types", arg0.bottomBack)
	arg0.materialToggle = arg0.bottomPanel:Find("material")
	arg0.weaponToggle = arg0.bottomPanel:Find("weapon")
	arg0.designToggle = arg0.bottomPanel:Find("design")
	arg0.capacityTF = arg0:findTF("bottom_left/tip/capcity/Text", arg0.bottomBack)
	arg0.tipTF = arg0:findTF("bottom_left/tip", arg0.bottomBack)
	arg0.tip = arg0.tipTF:Find("label")
	arg0.helpBtn = arg0:findTF("adapt/help_btn", arg0.topItems)

	setActive(arg0.helpBtn, true)

	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back_btn")
	arg0.selectedMin = defaultValue(var0.selectedMin, 1)
	arg0.selectedMax = defaultValue(var0.selectedMax, pg.gameset.equip_select_limit.key_value or 0)
	arg0.selectedIds = Clone(var0.selectedIds or {})
	arg0.checkEquipment = var0.onEquipment or function(arg0, arg1, arg2)
		return true
	end
	arg0.onSelected = var0.onSelected or function()
		warning("not implemented.")
	end
	arg0.BatchDisposeBtn = arg0:findTF("dispos", arg0.bottomPanel)

	if not arg0.BatchDisposeBtn then
		arg0.BatchDisposeBtn = arg0:findTF("dispos", arg0.bottomBack)
	end

	arg0.selectPanel = arg0:findTF("adapt/select_panel", arg0.topItems)

	setActive(arg0.selectPanel, true)
	setAnchoredPosition(arg0.selectPanel, {
		y = -124
	})

	arg0.selectTransformPanel = arg0:findTF("adapt/select_transform_panel", arg0.topItems)

	setActive(arg0.selectTransformPanel, false)

	arg0.listEmptyTF = arg0:findTF("empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)
	arg0.destroyConfirmView = DestroyConfirmView.New(arg0.topItems, arg0.event)
	arg0.assignedItemView = AssignedItemView.New(arg0.topItems, arg0.event)
	arg0.blueprintAssignedItemView = BlueprintAssignedItemView.New(arg0.topItems, arg0.event)
	arg0.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0.topItems, arg0.event)
	arg0.isEquipingOn = false
	arg0.msgBox = SelectSkinMsgbox.New(arg0._tf, arg0.event)
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
		arg0.equipmentVOByIds[arg1.id] = arg1
	else
		table.remove(arg0.equipmentVOs, var0)

		arg0.equipmentVOByIds[arg1.id] = nil
	end
end

function var0.setEquipmentUpdate(arg0)
	if arg0.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
		arg0:filterEquipment()
		arg0:updateCapacity()
	end
end

function var0.addShipEquipment(arg0, arg1)
	for iter0, iter1 in pairs(arg0.equipmentVOs) do
		if EquipmentProxy.SameEquip(iter1, arg1) then
			arg0.equipmentVOs[iter0] = arg1

			return
		end
	end

	table.insert(arg0.equipmentVOs, arg1)
end

function var0.removeShipEquipment(arg0, arg1)
	for iter0 = #arg0.equipmentVOs, 1, -1 do
		local var0 = arg0.equipmentVOs[iter0]

		if EquipmentProxy.SameEquip(var0, arg1) then
			table.remove(arg0.equipmentVOs, iter0)
		end
	end
end

function var0.setEquipmentSkin(arg0, arg1)
	local var0 = true

	for iter0, iter1 in pairs(arg0.equipmentVOs) do
		if iter1.id == arg1.id and iter1.isSkin then
			arg0.equipmentVOs[iter0] = {
				isSkin = true,
				id = arg1.id,
				count = arg1.count
			}
			var0 = false
		end
	end

	if var0 then
		table.insert(arg0.equipmentVOs, {
			isSkin = true,
			id = arg1.id,
			count = arg1.count
		})
	end
end

function var0.setEquipmentSkinUpdate(arg0)
	if arg0.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
		arg0:filterEquipment()
		arg0:updateCapacity()
	end
end

function var0.SetSpWeapons(arg0, arg1)
	arg0.spweaponVOs = arg1
end

function var0.SetSpWeaponUpdate(arg0)
	if arg0.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0.page == var4 then
		arg0:filterEquipment()
		arg0:UpdateSpweaponCapacity()
	elseif arg0.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0.contextData.designPage == var6 then
		arg0:UpdateSpweaponCapacity()
	end
end

function var0.didEnter(arg0)
	setText(arg0:findTF("tip", arg0.selectPanel), i18n("equipment_select_device_destroy_tip"))
	setActive(arg0:findTF("adapt/stamp", arg0.topItems), getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0, arg0:findTF("adapt/stamp", arg0.topItems), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(2)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.helpBtn, function()
		local var0

		if arg0.contextData.warp == StoreHouseConst.WARP_TO_WEAPON then
			if arg0.page == var2 then
				var0 = pg.gametip.help_equipment.tip
			elseif arg0.page == var3 then
				var0 = pg.gametip.help_equipment_skin.tip
			elseif arg0.page == var4 then
				var0 = pg.gametip.spweapon_help_storage.tip
			end
		elseif arg0.contextData.warp == StoreHouseConst.WARP_TO_DESIGN then
			if arg0.contextData.designPage == var5 then
				var0 = pg.gametip.help_equipment.tip
			elseif arg0.contextData.designPage == var6 then
				var0 = pg.gametip.spweapon_help_storage.tip
			end
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0
		})
	end, SFX_PANEL)
	onToggle(arg0, arg0.equipmentToggle:Find("equipment"), function(arg0)
		if arg0 then
			arg0.page = var2

			arg0:UpdateWeaponWrapButtons()
			arg0:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.equipmentToggle:Find("skin"), function(arg0)
		if arg0 then
			arg0.page = var3

			arg0:UpdateWeaponWrapButtons()
			arg0:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.equipmentToggle:Find("spweapon"), function(arg0)
		if arg0 then
			arg0.page = var4

			arg0:UpdateWeaponWrapButtons()
			arg0:filterEquipment()
		end
	end, SFX_PANEL)
	setActive(arg0.equipmentToggle:Find("spweapon"), not LOCK_SP_WEAPON)
	onToggle(arg0, arg0.designTabs[var5], function(arg0)
		if arg0 then
			arg0.contextData.designPage = var5

			arg0:emit(EquipmentMediator.OPEN_DESIGN)
			arg0:updateCapacity()
			setActive(arg0.tip, false)
			setActive(arg0.listEmptyTF, false)
		else
			arg0:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.designTabs[var6], function(arg0)
		if arg0 then
			arg0.contextData.designPage = var6

			arg0:emit(EquipmentMediator.OPEN_SPWEAPON_DESIGN)
			arg0:UpdateSpweaponCapacity()
			setActive(arg0.tip, false)
			setActive(arg0.listEmptyTF, false)
		else
			arg0:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		if arg0.mode == StoreHouseConst.DESTROY then
			triggerButton(arg0.BatchDisposeBtn)

			return
		end

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
		local var0 = switch(arg0.page, {
			[var2] = function()
				return setmetatable({
					indexDatas = Clone(arg0.contextData.indexDatas),
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
				}, {
					__index = StoreHouseConst.EQUIPMENT_INDEX_COMMON
				})
			end,
			[var4] = function()
				return setmetatable({
					indexDatas = Clone(arg0.contextData.spweaponIndexDatas),
					callback = function(arg0)
						arg0.contextData.spweaponIndexDatas.typeIndex = arg0.typeIndex
						arg0.contextData.spweaponIndexDatas.rarityIndex = arg0.rarityIndex

						arg0:filterEquipment()
					end
				}, {
					__index = StoreHouseConst.SPWEAPON_INDEX_COMMON
				})
			end
		})

		arg0:emit(EquipmentMediator.OPEN_EQUIPMENT_INDEX, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.equipSkinFilteBtn, function()
		local var0 = {
			display = {
				equipSkinIndex = IndexConst.FlagRange2Bits(IndexConst.EquipSkinIndexAll, IndexConst.EquipSkinIndexAux),
				equipSkinTheme = IndexConst.FlagRange2Str(IndexConst.EquipSkinThemeAll, IndexConst.EquipSkinThemeEnd)
			},
			equipSkinSort = arg0.equipSkinSort or IndexConst.EquipSkinSortType,
			equipSkinIndex = arg0.equipSkinIndex or IndexConst.Flags2Bits({
				IndexConst.EquipSkinIndexAll
			}),
			equipSkinTheme = arg0.equipSkinTheme or IndexConst.Flags2Str({
				IndexConst.EquipSkinThemeAll
			}),
			callback = function(arg0)
				arg0.equipSkinSort = arg0.equipSkinSort
				arg0.equipSkinIndex = arg0.equipSkinIndex
				arg0.equipSkinTheme = arg0.equipSkinTheme

				arg0:filterEquipment()
			end
		}

		arg0:emit(EquipmentMediator.OPEN_EQUIPSKIN_INDEX_LAYER, var0)
	end, SFX_PANEL)

	arg0.equipmetItems = {}
	arg0.itemCards = {}

	arg0:initItems()
	arg0:initEquipments()

	arg0.asc = arg0.contextData.asc or false
	arg0.contextData.sortData = arg0.contextData.sortData or var7.sort[1]
	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}
	arg0.contextData.spweaponIndexDatas = arg0.contextData.spweaponIndexDatas or {}
	arg0.contextData.spweaponSortData = arg0.contextData.spweaponSortData or var8.sort[1]

	arg0:initSort()
	setActive(arg0.itemView, false)
	setActive(arg0.equipmentView, false)
	onToggle(arg0, arg0.materialToggle, function(arg0)
		arg0.inMaterial = arg0

		if arg0 and arg0.contextData.warp ~= StoreHouseConst.WARP_TO_MATERIAL then
			arg0.contextData.warp = StoreHouseConst.WARP_TO_MATERIAL

			setText(arg0.tip, i18n("equipment_select_materials_tip"))
			setActive(arg0.capacityTF.parent, false)
			setActive(arg0.tip, true)
			arg0:sortItems()
		end

		setActive(arg0.helpBtn, not arg0)
	end, SFX_PANEL)
	onToggle(arg0, arg0.weaponToggle, function(arg0)
		if arg0 then
			if arg0.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON then
				arg0.contextData.warp = StoreHouseConst.WARP_TO_WEAPON

				setActive(arg0.tip, false)
				setActive(arg0.capacityTF.parent, true)

				if arg0.page == var3 then
					triggerToggle(arg0.equipmentToggle:Find("skin"), true)
				elseif arg0.page == var4 then
					triggerToggle(arg0.equipmentToggle:Find("spweapon"), true)
				else
					triggerToggle(arg0.equipmentToggle:Find("equipment"), true)
				end
			end
		else
			setActive(arg0.BatchDisposeBtn, false)
			setActive(arg0.filterBusyToggle, false)
			setActive(arg0.equipmentToggle, false)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.designToggle, function(arg0)
		if arg0 then
			arg0.contextData.warp = StoreHouseConst.WARP_TO_DESIGN

			local var0 = arg0.contextData.designPage or var5

			triggerToggle(arg0.designTabs[var0], true)
			setActive(arg0.capacityTF.parent, true)
		else
			arg0:emit(EquipmentMediator.CLOSE_DESIGN_LAYER)
			arg0:emit(EquipmentMediator.CLOSE_SPWEAPON_DESIGN_LAYER)
		end

		setActive(arg0.designTabRoot, arg0 and not LOCK_SP_WEAPON)
	end, SFX_PANEL)
	onToggle(arg0, arg0.filterBusyToggle, function(arg0)
		arg0:SetShowBusyFlag(arg0)
		arg0:filterEquipment()
	end, SFX_PANEL)

	arg0.filterEquipWaitting = arg0.filterEquipWaitting + 1

	triggerToggle(arg0.filterBusyToggle, arg0.shipVO)
	onButton(arg0, arg0.BatchDisposeBtn, function()
		if arg0.mode == StoreHouseConst.DESTROY then
			arg0.mode = StoreHouseConst.OVERVIEW
			arg0.asc = arg0.lastasc
			arg0.lastasc = nil
			arg0.filterImportance = nil

			shiftPanel(arg0.bottomBack, nil, 0, nil, 0, true, true)
			shiftPanel(arg0.selectPanel, nil, -124, nil, 0, true, true)
			arg0:filterEquipment()
		else
			arg0.mode = StoreHouseConst.DESTROY
			arg0.lastasc = arg0.asc
			arg0.filterImportance = true
			arg0.asc = true

			shiftPanel(arg0.bottomBack, nil, -124, nil, 0, true, true)
			shiftPanel(arg0.selectPanel, nil, 0, nil, 0, true, true)

			arg0.contextData.asc = arg0.asc
			arg0.contextData.sortData = var7.sort[1]

			arg0:filterEquipment()
		end

		arg0:UpdateWeaponWrapButtons()
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0.selectPanel, "cancel_button"), function()
		arg0:unselecteAllEquips()
		triggerButton(arg0.BatchDisposeBtn)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.selectPanel, "confirm_button"), function()
		local var0 = {}

		if underscore.any(arg0.selectedIds, function(arg0)
			local var0 = arg0.equipmentVOByIds[arg0[1]]

			return var0:getConfig("rarity") >= 4 or var0:getConfig("level") > 1
		end) then
			table.insert(var0, function(arg0)
				arg0.equipDestroyConfirmWindow:Load()
				arg0.equipDestroyConfirmWindow:ActionInvoke("Show", underscore.map(arg0.selectedIds, function(arg0)
					return setmetatable({
						count = arg0[2]
					}, {
						__index = arg0.equipmentVOByIds[arg0[1]]
					})
				end), arg0)
			end)
		end

		seriesAsync(var0, function()
			arg0.destroyConfirmView:Load()
			arg0.destroyConfirmView:ActionInvoke("Show")
			arg0.destroyConfirmView:ActionInvoke("DisplayDestroyBonus", arg0.selectedIds)
			arg0.destroyConfirmView:ActionInvoke("SetConfirmBtnCB", function()
				arg0:unselecteAllEquips()
			end)
		end)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.blurPanel, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0.topItems, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})

	local var0 = arg0.contextData.warp or StoreHouseConst.WARP_TO_MATERIAL
	local var1 = arg0.contextData.mode or StoreHouseConst.OVERVIEW

	arg0.contextData.warp = nil
	arg0.contextData.mode = nil
	arg0.mode = arg0.mode or StoreHouseConst.OVERVIEW

	if var0 == StoreHouseConst.WARP_TO_DESIGN then
		triggerToggle(arg0.designToggle, true)
	elseif var0 == StoreHouseConst.WARP_TO_MATERIAL then
		triggerToggle(arg0.materialToggle, true)
	elseif var0 == StoreHouseConst.WARP_TO_WEAPON then
		if var1 == StoreHouseConst.DESTROY then
			arg0.filterEquipWaitting = arg0.filterEquipWaitting + 1

			triggerToggle(arg0.weaponToggle, true)
			triggerButton(arg0.BatchDisposeBtn)
		else
			if var1 == StoreHouseConst.SKIN then
				arg0.page = var3
			elseif var1 == StoreHouseConst.SPWEAPON then
				arg0.page = var4
			else
				arg0.page = var2
			end

			triggerToggle(arg0.weaponToggle, true)
		end
	end

	arg0.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0, arg0.topItems)
end

function var0.isDefaultStatus(arg0)
	return underscore(arg0.contextData.indexDatas):chain():keys():all(function(arg0)
		return arg0.contextData.indexDatas[arg0] == StoreHouseConst.EQUIPMENT_INDEX_COMMON.customPanels[arg0].options[1]
	end):value()
end

function var0.isDefaultSpWeaponIndexData(arg0)
	return underscore(arg0.contextData.spweaponIndexDatas):chain():keys():all(function(arg0)
		return arg0.contextData.spweaponIndexDatas[arg0] == StoreHouseConst.SPWEAPON_INDEX_COMMON.customPanels[arg0].options[1]
	end):value()
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0.sortPanel) then
		triggerButton(arg0.sortPanel)
	elseif arg0.destroyConfirmView:isShowing() then
		arg0.destroyConfirmView:Hide()
	elseif arg0.assignedItemView:isShowing() then
		arg0.assignedItemView:Hide()
	elseif arg0.blueprintAssignedItemView:isShowing() then
		arg0.blueprintAssignedItemView:Hide()
	elseif arg0.equipDestroyConfirmWindow:isShowing() then
		arg0.equipDestroyConfirmWindow:Hide()
	else
		triggerButton(arg0.backBtn)
	end
end

function var0.updateCapacity(arg0)
	if arg0.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
		return
	end

	setText(arg0.tip, "")
	setText(arg0.capacityTF, arg0.capacity .. "/" .. arg0.player:getMaxEquipmentBag())
end

function var0.setCapacity(arg0, arg1)
	arg0.capacity = arg1
end

function var0.UpdateSpweaponCapacity(arg0)
	local var0 = getProxy(EquipmentProxy)

	setText(arg0.capacityTF, var0:GetSpWeaponCount() .. "/" .. var0:GetSpWeaponCapacity())
end

function var0.setShip(arg0, arg1)
	arg0.shipVO = arg1

	setActive(arg0.bottomPanel, not tobool(arg1))
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1

	if arg0.contextData.warp == StoreHouseConst.WARP_TO_WEAPON and arg0.page == var2 then
		arg0:updateCapacity()
	elseif arg0.contextData.warp == StoreHouseConst.WARP_TO_DESIGN and arg0.contextData.designPage == var5 then
		arg0:updateCapacity()
	end
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

	for iter0, iter1 in ipairs(var7.sort) do
		local var0 = iter0 <= arg0.sortContain.childCount and arg0.sortContain:GetChild(iter0 - 1) or cloneTplTo(arg0.sortTpl, arg0.sortContain)

		setActive(var0, true)
		setImageSprite(findTF(var0, "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", iter1.spr), true)
		onToggle(arg0, var0, function(arg0)
			if arg0 then
				if arg0.page == var2 then
					arg0.contextData.sortData = iter1
				elseif arg0.page == var4 then
					arg0.contextData.spweaponSortData = var8.sort[iter0]
				end

				arg0:filterEquipment()
				triggerToggle(arg0.sortBtn, false)
			end
		end, SFX_PANEL)

		arg0.sortButtons[iter0] = var0
	end
end

function var0.UpdateWeaponWrapButtons(arg0)
	local var0 = arg0.page

	setActive(arg0.indexBtn, var0 == var2 or var0 == var4)
	setActive(arg0.sortBtn, var0 == var2 or var0 == var4)
	setActive(arg0.BatchDisposeBtn, var0 == var2)
	setActive(arg0.capacityTF.parent, var0 == var2 or var0 == var4)
	setActive(arg0.equipSkinFilteBtn, var0 == var3)
	setActive(arg0.filterBusyToggle, arg0.mode == StoreHouseConst.OVERVIEW)
	setActive(arg0.equipmentToggle, arg0.mode == StoreHouseConst.OVERVIEW and not arg0.contextData.shipId)
	arg0:updatePageFilterButtons(var0)
end

function var0.updatePageFilterButtons(arg0, arg1)
	for iter0, iter1 in ipairs(var7.sort) do
		triggerToggle(arg0.sortButtons[iter0], false)
		setActive(arg0.sortButtons[iter0], table.contains(iter1.pages, arg1))
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

	function arg0.equipmentRect.onStart()
		arg0:updateSelected()
	end

	arg0.equipmentRect.decelerationRate = 0.07
end

function var0.initEquipment(arg0, arg1)
	local var0 = EquipmentItem.New(arg1)

	onButton(arg0, var0.unloadBtn, function()
		if arg0.page == var3 then
			arg0:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT_SKIN)
		elseif arg0.page == var2 then
			arg0:emit(EquipmentMediator.ON_UNEQUIP_EQUIPMENT)
		end
	end, SFX_PANEL)
	onButton(arg0, var0.reduceBtn, function()
		arg0:selectEquip(var0.equipmentVO, 1)
	end, SFX_PANEL)

	arg0.equipmetItems[arg1] = var0
end

function var0.updateEquipment(arg0, arg1, arg2)
	local var0 = arg0.equipmetItems[arg2]

	assert(var0, "without init item")

	local var1 = arg0.loadEquipmentVOs[arg1 + 1]

	var0:update(var1)

	local var2 = false
	local var3 = 0

	if var1 then
		for iter0, iter1 in ipairs(arg0.selectedIds) do
			if var1.id == iter1[1] then
				var2 = true
				var3 = iter1[2]

				break
			end
		end
	end

	var0:updateSelected(var2, var3)

	if not var1 then
		removeOnButton(var0.go)
	elseif isa(var1, SpWeapon) then
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
	elseif var0.equipmentVO.isSkin then
		if var1.shipId then
			onButton(arg0, var0.go, function()
				local var0 = var1.shipId
				local var1 = var1.shipPos

				assert(var1, "equipment skin pos is nil")
				arg0:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1.id, arg0.contextData.pos, {
					id = var0,
					pos = var1
				})
			end, SFX_PANEL)
		else
			onButton(arg0, var0.go, function()
				arg0:emit(EquipmentMediator.ON_EQUIPMENT_SKIN_INFO, var1.id, arg0.contextData.pos)
			end, SFX_PANEL)
		end
	elseif var1.mask then
		removeOnButton(var0.go)
	elseif arg0.mode == StoreHouseConst.DESTROY then
		onButton(arg0, var0.go, function()
			arg0:selectEquip(var1, var1.count)
		end, SFX_PANEL)
	else
		onButton(arg0, var0.go, function()
			local var0 = arg0.shipVO and {
				type = EquipmentInfoMediator.TYPE_REPLACE,
				equipmentId = var1.id,
				shipId = arg0.contextData.shipId,
				pos = arg0.contextData.pos,
				oldShipId = var1.shipId,
				oldPos = var1.shipPos
			} or var1.shipId and {
				showTransformTip = true,
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				equipmentId = var1.id,
				shipId = var1.shipId,
				pos = var1.shipPos
			} or {
				destroy = true,
				type = EquipmentInfoMediator.TYPE_DEFAULT,
				equipmentId = var1.id
			}

			arg0:emit(var0.ON_EQUIPMENT, var0)
		end, SFX_PANEL)
	end
end

function var0.returnEquipment(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.equipmetItems[arg2]

	if var0 then
		removeOnButton(var0.go)
		var0:clear()
	end
end

function var0.updateEquipmentCount(arg0, arg1)
	arg0.equipmentRect:SetTotalCount(arg1 or #arg0.loadEquipmentVOs, -1)
	setActive(arg0.listEmptyTF, (arg1 or #arg0.loadEquipmentVOs) <= 0)
	setText(arg0.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	Canvas.ForceUpdateCanvases()
end

function var0.filterEquipment(arg0)
	if arg0.filterEquipWaitting > 0 then
		arg0.filterEquipWaitting = arg0.filterEquipWaitting - 1

		return
	end

	if arg0.page == var3 then
		arg0:filterEquipSkin()

		return
	elseif arg0.page == var4 then
		arg0:filterSpWeapon()

		return
	end

	local var0 = arg0:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0, function(arg0)
		setImageSprite(arg0.indexBtn, arg0, true)
	end)

	local var1 = {}

	arg0.loadEquipmentVOs = {}

	for iter0, iter1 in pairs(arg0.equipmentVOs) do
		if not iter1.isSkin then
			table.insert(var1, iter1)
		end
	end

	local var2 = {
		arg0.contextData.indexDatas.equipPropertyIndex,
		arg0.contextData.indexDatas.equipPropertyIndex2
	}

	for iter2, iter3 in pairs(var1) do
		if (iter3.count > 0 or iter3.shipId) and arg0:checkFitBusyCondition(iter3) and IndexConst.filterEquipByType(iter3, arg0.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(iter3, var2) and IndexConst.filterEquipAmmo1(iter3, arg0.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(iter3, arg0.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(iter3, arg0.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(iter3, arg0.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(iter3, arg0.contextData.indexDatas.extraIndex) then
			table.insert(arg0.loadEquipmentVOs, iter3)
		end
	end

	if arg0.filterImportance ~= nil then
		for iter4 = #arg0.loadEquipmentVOs, 1, -1 do
			local var3 = arg0.loadEquipmentVOs[iter4]

			if var3.isSkin or not var3.isSkin and var3:isImportance() then
				table.remove(arg0.loadEquipmentVOs, iter4)
			end
		end
	end

	local var4 = arg0.contextData.sortData

	if var4 then
		local var5 = arg0.asc

		table.sort(arg0.loadEquipmentVOs, CompareFuncs(var7.sortFunc(var4, var5)))
	end

	if arg0.contextData.qiutBtn then
		table.insert(arg0.loadEquipmentVOs, 1, false)
	end

	arg0:updateSelected()
	arg0:updateEquipmentCount()
	setImageSprite(arg0:findTF("Image", arg0.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var4.spr), true)
	setActive(arg0.sortImgAsc, arg0.asc)
	setActive(arg0.sortImgDec, not arg0.asc)
	arg0:updateCapacity()
end

function var0.filterEquipSkin(arg0)
	local var0 = arg0.equipSkinIndex
	local var1 = arg0.equipSkinTheme
	local var2 = arg0.page
	local var3 = {}

	arg0.loadEquipmentVOs = {}

	if var2 ~= var3 then
		assert(false, "不是外观分页")
	end

	for iter0, iter1 in pairs(arg0.equipmentVOs) do
		if iter1.isSkin and iter1.count > 0 then
			table.insert(var3, iter1)
		end
	end

	for iter2, iter3 in pairs(var3) do
		if IndexConst.filterEquipSkinByIndex(iter3, var0) and IndexConst.filterEquipSkinByTheme(iter3, var1) and arg0:checkFitBusyCondition(iter3) then
			table.insert(arg0.loadEquipmentVOs, iter3)
		end
	end

	if arg0.filterImportance ~= nil then
		for iter4 = #arg0.loadEquipmentVOs, 1, -1 do
			local var4 = arg0.loadEquipmentVOs[iter4]

			if var4.isSkin or not var4.isSkin and var4:isImportance() then
				table.remove(arg0.loadEquipmentVOs, iter4)
			end
		end
	end

	local var5 = arg0.contextData.sortData

	if var5 then
		local var6 = arg0.asc

		table.sort(arg0.loadEquipmentVOs, CompareFuncs(var7.sortFunc(var5, var6)))
	end

	if arg0.contextData.qiutBtn then
		table.insert(arg0.loadEquipmentVOs, 1, false)
	end

	arg0:updateSelected()
	arg0:updateEquipmentCount()
	setActive(arg0.sortImgAsc, arg0.asc)
	setActive(arg0.sortImgDec, not arg0.asc)
end

function var0.filterSpWeapon(arg0)
	if arg0.page ~= var4 then
		assert(false, "不是特殊兵装分页")
	end

	local var0 = arg0:isDefaultSpWeaponIndexData() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0, function(arg0)
		setImageSprite(arg0.indexBtn, arg0, true)
	end)

	arg0.loadEquipmentVOs = {}

	local var1 = arg0.contextData.spweaponIndexDatas.typeIndex
	local var2 = arg0.contextData.spweaponIndexDatas.rarityIndex

	for iter0, iter1 in pairs(arg0.spweaponVOs) do
		if IndexConst.filterSpWeaponByType(iter1, var1) and IndexConst.filterSpWeaponByRarity(iter1, var2) and arg0:checkFitBusyCondition(iter1) and (arg0.filterImportance == nil or iter1:IsImportant()) then
			table.insert(arg0.loadEquipmentVOs, iter1)
		end
	end

	local var3 = arg0.contextData.spweaponSortData

	if var3 then
		local var4 = arg0.asc

		table.sort(arg0.loadEquipmentVOs, CompareFuncs(var8.sortFunc(var3, var4)))
	end

	if arg0.contextData.qiutBtn then
		table.insert(arg0.loadEquipmentVOs, 1, false)
	end

	arg0:updateSelected()
	arg0:updateEquipmentCount()
	setImageSprite(arg0:findTF("Image", arg0.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", var3.spr), true)
	setActive(arg0.sortImgAsc, arg0.asc)
	setActive(arg0.sortImgDec, not arg0.asc)
	arg0:UpdateSpweaponCapacity()
end

function var0.GetShowBusyFlag(arg0)
	return arg0.isEquipingOn
end

function var0.SetShowBusyFlag(arg0, arg1)
	arg0.isEquipingOn = arg1
end

function var0.Scroll2Equip(arg0, arg1)
	if arg0.contextData.warp ~= StoreHouseConst.WARP_TO_WEAPON or arg0.page ~= var2 then
		return
	end

	for iter0, iter1 in ipairs(arg0.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(iter1, arg1) then
			local var0 = arg0.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
			local var1 = (var0.cellSize.y + var0.spacing.y) * math.floor((iter0 - 1) / var0.constraintCount) + arg0.equipmentRect.paddingFront + arg0.equipmentView.rect.height * 0.5

			arg0:ScrollEquipPos(var1 - arg0.equipmentRect.paddingFront)

			break
		end
	end
end

function var0.ScrollEquipPos(arg0, arg1)
	local var0 = arg0.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1 = (var0.cellSize.y + var0.spacing.y) * math.ceil(#arg0.loadEquipmentVOs / var0.constraintCount) - var0.spacing.y + arg0.equipmentRect.paddingFront + arg0.equipmentRect.paddingEnd
	local var2 = var1 - arg0.equipmentView.rect.height

	var2 = var2 > 0 and var2 or var1

	local var3 = (arg1 - arg0.equipmentView.rect.height * 0.5) / var2

	arg0.equipmentRect:ScrollTo(var3)
end

function var0.checkFitBusyCondition(arg0, arg1)
	return not arg1.shipId or arg0:GetShowBusyFlag() and arg0.mode ~= StoreHouseConst.DESTROY
end

function var0.setItems(arg0, arg1)
	arg0.itemVOs = arg1

	if arg0.isInitItems and arg0.contextData.warp == StoreHouseConst.WARP_TO_MATERIAL then
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

	arg0.itemRect.decelerationRate = 0.07
end

function var0.sortItems(arg0)
	table.sort(arg0.itemVOs, CompareFuncs({
		function(arg0)
			return -arg0:getConfig("order")
		end,
		function(arg0)
			return -arg0:getConfig("rarity")
		end,
		function(arg0)
			return arg0.id
		end
	}))
	arg0.itemRect:SetTotalCount(#arg0.itemVOs, -1)
	setActive(arg0.listEmptyTF, #arg0.itemVOs <= 0)
	setText(arg0.listEmptyTxt, i18n("list_empty_tip_storehouseui_item"))
	Canvas.ForceUpdateCanvases()
end

function var0.initItem(arg0, arg1)
	arg0.itemCards[arg1] = ItemCard.New(arg1)
end

function var0.updateItem(arg0, arg1, arg2)
	local var0 = arg0.itemCards[arg2]

	assert(var0, "without init item")

	local var1 = arg0.itemVOs[arg1 + 1]

	var0:update(var1)

	if not var1 then
		removeOnButton(var0.go)
	elseif tobool(getProxy(TechnologyProxy):getItemCanUnlockBluePrint(var1.id)) then
		local var2 = getProxy(TechnologyProxy)
		local var3 = underscore.map(var2:getItemCanUnlockBluePrint(var1.id), function(arg0)
			return var2:getBluePrintById(arg0)
		end)
		local var4 = underscore.detect(var3, function(arg0)
			return not arg0:isUnlock()
		end)

		if var4 then
			onButton(arg0, var0.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					item = var1,
					blueprints = var3,
					onYes = function()
						arg0:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.SHIPBLUEPRINT, {
							shipBluePrintVO = var4
						})
					end,
					yesText = i18n("text_forward")
				})
			end, SFX_PANEL)
		else
			onButton(arg0, var0.go, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM,
					windowSize = Vector2(1010, 685),
					item = var1,
					blueprints = var3,
					onYes = function()
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							type = MSGBOX_TYPE_ITEM_BOX,
							content = i18n("techpackage_item_use_confirm"),
							items = underscore.map(var1:getConfig("display_icon"), function(arg0)
								return {
									type = arg0[1],
									id = arg0[2],
									count = arg0[3]
								}
							end),
							onYes = function()
								arg0:emit(EquipmentMediator.ON_USE_ITEM, var1.id, 1)
							end
						})
					end
				})
			end, SFX_PANEL)
		end
	elseif var1:getConfig("type") == Item.INVITATION_TYPE then
		onButton(arg0, var0.go, function()
			arg0:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = var1
			})
		end, SFX_PANEL)
	elseif var1:getConfig("type") == Item.ASSIGNED_TYPE or var1:getConfig("type") == Item.EQUIPMENT_ASSIGNED_TYPE then
		if underscore.any(pg.gameset.general_blueprint_list.description, function(arg0)
			return var1.id == arg0
		end) then
			onButton(arg0, var0.go, function()
				arg0.blueprintAssignedItemView:Load()
				arg0.blueprintAssignedItemView:ActionInvoke("Show")
				arg0.blueprintAssignedItemView:ActionInvoke("update", var1)
			end, SFX_PANEL)
		else
			onButton(arg0, var0.go, function()
				arg0.assignedItemView:Load()
				arg0.assignedItemView:ActionInvoke("Show")
				arg0.assignedItemView:ActionInvoke("update", var1)
			end, SFX_PANEL)
		end
	elseif var1:getConfig("type") == Item.LOVE_LETTER_TYPE then
		onButton(arg0, var0.go, function()
			arg0:emit(var0.ON_ITEM_EXTRA, var1.id, var1.extra)
		end, SFX_PANEL)
	elseif var1:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
		onButton(arg0, var0.go, function()
			arg0:emit(var0.ON_ITEM, var1.id, function()
				local var0 = var1:getConfig("usage_arg")

				if var1:IsAllSkinOwner() then
					local var1 = Drop.New({
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var0[5]
					})

					arg0.msgBox:ExecuteAction("Show", {
						content = i18n("blackfriday_pack_select_skinall_dialog", var1:getConfig("name"), var1:getName()),
						leftDrop = {
							count = 1,
							type = DROP_TYPE_ITEM,
							id = var1.id
						},
						rightDrop = var1,
						onYes = function()
							arg0:emit(EquipmentMediator.ON_USE_ITEM, var1.id, 1, {
								0
							})
						end
					})
				else
					local var2 = {}

					for iter0, iter1 in ipairs(var0[2]) do
						var2[iter1] = true
					end

					arg0:emit(EquipmentMediator.ITEM_ADD_LAYER, Context.New({
						viewComponent = SelectSkinLayer,
						mediator = SkinAtlasMediator,
						data = {
							mode = SelectSkinLayer.MODE_SELECT,
							itemId = var1.id,
							selectableSkinList = underscore.map(var1:GetValidSkinList(), function(arg0)
								return SelectableSkin.New({
									id = arg0,
									isTimeLimit = var2[arg0] or false
								})
							end),
							OnConfirm = function(arg0)
								arg0:emit(EquipmentMediator.ON_USE_ITEM, var1.id, 1, {
									arg0
								})
							end
						}
					}))
				end
			end)
		end, SFX_PANEL)
	else
		onButton(arg0, var0.go, function()
			arg0:emit(var0.ON_ITEM, var1.id)
		end, SFX_PANEL)
	end
end

function var0.returnItem(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.itemCards[arg2]

	if var0 then
		removeOnButton(var0.go)
		var0:clear()
	end
end

function var0.selectCount(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.selectedIds) do
		var0 = var0 + iter1[2]
	end

	return var0
end

function var0.selectEquip(arg0, arg1, arg2)
	if not arg0:checkDestroyGold(arg1, arg2) then
		return
	end

	if arg0.mode == StoreHouseConst.DESTROY then
		local var0 = false
		local var1
		local var2 = 0

		for iter0, iter1 in pairs(arg0.selectedIds) do
			if iter1[1] == arg1.id then
				var0 = true
				var1 = iter0
				var2 = iter1[2]

				break
			end
		end

		if not var0 then
			local var3, var4 = arg0.checkEquipment(arg1, function()
				arg0:selectEquip(arg1, arg2)
			end, arg0.selectedIds)

			if not var3 then
				if var4 then
					pg.TipsMgr.GetInstance():ShowTips(var4)
				end

				return
			end

			local var5 = arg0:selectCount()

			if arg0.selectedMax > 0 and var5 + arg2 > arg0.selectedMax then
				arg2 = arg0.selectedMax - var5
			end

			if arg0.selectedMax == 0 or var5 < arg0.selectedMax then
				table.insert(arg0.selectedIds, {
					arg1.id,
					arg2
				})
			elseif arg0.selectedMax == 1 then
				arg0.selectedIds[1] = {
					arg1.id,
					arg2
				}
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentScene_selectError_more", arg0.selectedMax))

				return
			end
		elseif var2 - arg2 > 0 then
			arg0.selectedIds[var1][2] = var2 - arg2
		else
			table.remove(arg0.selectedIds, var1)
		end
	end

	arg0:updateSelected()
end

function var0.unselecteAllEquips(arg0)
	arg0.selectedIds = {}

	arg0:updateSelected()
end

function var0.checkDestroyGold(arg0, arg1, arg2)
	local var0 = 0
	local var1 = false

	for iter0, iter1 in pairs(arg0.selectedIds) do
		local var2 = iter1[2]

		if Equipment.CanInBag(iter1[1]) then
			var0 = var0 + (Equipment.getConfigData(iter1[1]).destory_gold or 0) * var2
		end

		if arg1 and iter1[1] == arg1.configId then
			var1 = true
		end
	end

	if not var1 and arg1 and arg2 > 0 then
		var0 = var0 + (arg1:getConfig("destory_gold") or 0) * arg2
	end

	if arg0.player:GoldMax(var0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0.updateSelected(arg0)
	for iter0, iter1 in pairs(arg0.equipmetItems) do
		if iter1.equipmentVO then
			local var0 = false
			local var1 = 0

			for iter2, iter3 in pairs(arg0.selectedIds) do
				if iter1.equipmentVO.id == iter3[1] then
					var0 = true
					var1 = iter3[2]

					break
				end
			end

			iter1:updateSelected(var0, var1)
		end
	end

	if arg0.mode == StoreHouseConst.DESTROY then
		local var2 = arg0:selectCount()

		if arg0.selectedMax == 0 then
			setText(findTF(arg0.selectPanel, "bottom_info/bg_input/count"), var2)
		else
			setText(findTF(arg0.selectPanel, "bottom_info/bg_input/count"), var2 .. "/" .. arg0.selectedMax)
		end

		if #arg0.selectedIds < arg0.selectedMin then
			setActive(findTF(arg0.selectPanel, "confirm_button/mask"), true)
		else
			setActive(findTF(arg0.selectPanel, "confirm_button/mask"), false)
		end
	end
end

function var0.SwitchToDestroy(arg0)
	arg0.page = var2
	arg0.filterEquipWaitting = arg0.filterEquipWaitting + 1

	triggerToggle(arg0.weaponToggle, true)
	triggerButton(arg0.BatchDisposeBtn)
end

function var0.SwitchToSpWeaponStoreHouse(arg0)
	arg0.page = var4

	triggerToggle(arg0.weaponToggle, true)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.topItems, arg0._tf)

	if arg0.bulinTip then
		arg0.bulinTip:Destroy()

		arg0.bulinTip = nil
	end

	arg0.destroyConfirmView:Destroy()
	arg0.assignedItemView:Destroy()
	arg0.blueprintAssignedItemView:Destroy()
	arg0.equipDestroyConfirmWindow:Destroy()
	arg0.msgBox:Destroy()
end

return var0
