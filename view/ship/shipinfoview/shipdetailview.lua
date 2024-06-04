local var0 = class("ShipDetailView", import("...base.BaseSubView"))
local var1 = require("view.equipment.EquipmentSortCfg")
local var2 = {
	equipCampIndex = 2047,
	equipPropertyIndex = 4095,
	equipPropertyIndex2 = 4095,
	equipAmmoIndex1 = 15,
	equipAmmoIndex2 = 3,
	extraIndex = 0,
	typeIndex = 2047,
	rarityIndex = 31
}

function var0.getUIName(arg0)
	return "ShipDetailView"
end

function var0.OnInit(arg0)
	arg0:InitDetail()
	arg0:InitEvent()
end

function var0.InitDetail(arg0)
	arg0.mainPanel = arg0._parentTf.parent
	arg0.detailPanel = arg0._tf
	arg0.attrs = arg0.detailPanel:Find("attrs")

	setActive(arg0.attrs, false)

	arg0.shipDetailLogicPanel = ShipDetailLogicPanel.New(arg0.attrs)

	arg0.shipDetailLogicPanel:attach(arg0)

	arg0.equipments = arg0.detailPanel:Find("equipments")
	arg0.equipmentsGrid = arg0.equipments:Find("equipments")
	arg0.detailEquipmentTpl = arg0.equipments:Find("equipment_tpl")
	arg0.emptyGridTpl = arg0.equipments:Find("empty_tpl")
	arg0.showRecordBtn = arg0.equipments:Find("unload_all")
	arg0.showQuickBtn = arg0.equipments:Find("quickButton")
	arg0.showECodeShareBtn = arg0.equipments:Find("shareButton")
	arg0.equipCodeBtn = arg0.equipments:Find("equip_code")
	arg0.lockBtn = arg0.detailPanel:Find("lock_btn")
	arg0.unlockBtn = arg0.detailPanel:Find("unlock_btn")
	arg0.viewBtn = arg0.detailPanel:Find("view_btn")
	arg0.evaluationBtn = arg0.detailPanel:Find("evaluation_btn")
	arg0.profileBtn = arg0.detailPanel:Find("profile_btn")
	arg0.fashionToggle = arg0.detailPanel:Find("fashion_toggle")
	arg0.fashionTag = arg0.fashionToggle:Find("Tag")
	arg0.commonTagToggle = arg0.detailPanel:Find("common_toggle")
	arg0.spWeaponSlot = arg0.equipments:Find("SpSlot")
	arg0.propertyIcons = arg0.detailPanel:Find("attrs/attrs/property/icons")
	arg0.intimacyTF = arg0:findTF("intimacy")
	arg0.updateItemTick = 0
	arg0.quickPanel = arg0.detailPanel:Find("quick_panel")
	arg0.equiping = arg0.quickPanel:Find("equiping")
	arg0.fillter = arg0.quickPanel:Find("fillter")
	arg0.selectTitle = arg0.quickPanel:Find("frame/selectTitle")
	arg0.emptyTitle = arg0.quickPanel:Find("frame/emptyTitle")
	arg0.list = arg0.quickPanel:Find("frame/container/Content"):GetComponent("LScrollRect")
	arg0.indexData = {}

	arg0:CloseQuickPanel()
	setText(arg0.quickPanel:Find("fillter/on/text2"), i18n("quick_equip_tip2"))
	setText(arg0.quickPanel:Find("fillter/off/text2"), i18n("quick_equip_tip2"))
	setText(arg0.quickPanel:Find("equiping/on/text2"), i18n("quick_equip_tip1"))
	setText(arg0.quickPanel:Find("equiping/off/text2"), i18n("quick_equip_tip1"))
	setText(arg0.quickPanel:Find("title/text"), i18n("quick_equip_tip3"))
	setText(arg0.quickPanel:Find("frame/emptyTitle/text"), i18n("quick_equip_tip4"))
	setText(arg0.quickPanel:Find("frame/selectTitle/text"), i18n("quick_equip_tip5"))

	arg0.equipmentProxy = getProxy(EquipmentProxy)
	arg0.recordPanel = arg0.detailPanel:Find("record_panel")
	arg0.unloadAllBtn = arg0.recordPanel:Find("frame/unload_all")
	arg0.recordBars = _.map({
		1,
		2,
		3
	}, function(arg0)
		return arg0.recordPanel:Find("frame/container"):GetChild(arg0 - 1)
	end)
	arg0.recordBtns = {
		arg0.recordPanel:Find("frame/container/record_1/record_btn"),
		arg0.recordPanel:Find("frame/container/record_2/record_btn"),
		arg0.recordPanel:Find("frame/container/record_3/record_btn")
	}
	arg0.recordEquipmentsTFs = {
		arg0.recordPanel:Find("frame/container/record_1/equipments"),
		arg0.recordPanel:Find("frame/container/record_2/equipments"),
		arg0.recordPanel:Find("frame/container/record_3/equipments")
	}
	arg0.equipRecordBtns = {
		arg0.recordPanel:Find("frame/container/record_1/equip_btn"),
		arg0.recordPanel:Find("frame/container/record_2/equip_btn"),
		arg0.recordPanel:Find("frame/container/record_3/equip_btn")
	}

	setActive(arg0.detailPanel, true)
	setActive(arg0.attrs, true)
	setActive(arg0.recordPanel, false)
	setActive(arg0.detailEquipmentTpl, false)
	setActive(arg0.emptyGridTpl, false)
	setActive(arg0.detailPanel, true)

	arg0.onSelected = false

	if PLATFORM_CODE == PLATFORM_CHT and LOCK_SP_WEAPON then
		setActive(arg0.showRecordBtn, false)
		setActive(arg0.showQuickBtn, false)
		setActive(arg0.spWeaponSlot, false)

		arg0.showRecordBtn = arg0.equipments:Find("unload_all_2")
		arg0.showQuickBtn = arg0.equipments:Find("quickButton_2")

		setActive(arg0.showRecordBtn, true)
		setActive(arg0.showQuickBtn, true)
	end
end

function var0.InitEvent(arg0)
	onButton(arg0, arg0.fashionToggle, function()
		arg0:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.FASHION)
	end, SFX_PANEL)
	onButton(arg0, arg0.propertyIcons, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_attr.tip,
			onClose = function()
				return
			end
		})
	end)
	onToggle(arg0, arg0.commonTagToggle, function(arg0)
		local var0 = arg0:GetShipVO().preferenceTag
		local var1 = var0 == Ship.PREFERENCE_TAG_COMMON

		if var1 ~= arg0 then
			if var0 == Ship.PREFERENCE_TAG_COMMON then
				var1 = Ship.PREFERENCE_TAG_NONE
			else
				var1 = Ship.PREFERENCE_TAG_COMMON
			end

			arg0:emit(ShipMainMediator.ON_TAG, arg0:GetShipVO().id, var1)
		end
	end)
	onButton(arg0, arg0.lockBtn, function()
		arg0:emit(ShipMainMediator.ON_LOCK, {
			arg0:GetShipVO().id
		}, arg0:GetShipVO().LOCK_STATE_LOCK)
	end, SFX_PANEL)
	onButton(arg0, arg0.unlockBtn, function()
		arg0:emit(ShipMainMediator.ON_LOCK, {
			arg0:GetShipVO().id
		}, arg0:GetShipVO().LOCK_STATE_UNLOCK)
	end, SFX_PANEL)
	onButton(arg0, arg0.viewBtn, function()
		Input.multiTouchEnabled = true

		arg0:emit(ShipViewConst.PAINT_VIEW, true)
	end, SFX_PANEL)
	onButton(arg0, arg0.evaluationBtn, function()
		arg0:emit(ShipMainMediator.OPEN_EVALUATION, arg0:GetShipVO():getGroupId(), arg0:GetShipVO():isActivityNpc())
	end, SFX_PANEL)
	onButton(arg0, arg0.profileBtn, function()
		arg0:emit(ShipMainMediator.OPEN_SHIPPROFILE, arg0:GetShipVO():getGroupId(), arg0:GetShipVO():isRemoulded())
	end, SFX_PANEL)
	onButton(arg0, arg0.intimacyTF, function()
		if arg0:GetShipVO():isActivityNpc() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("npc_propse_tip"))

			return
		end

		if LOCK_PROPOSE then
			return
		end

		arg0:emit(ShipMainMediator.PROPOSE, arg0:GetShipVO().id, function()
			return
		end)
	end)
	onToggle(arg0, arg0.showRecordBtn, function(arg0)
		local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0:GetShipVO())

		if not var0 then
			if arg0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)
				onNextTick(function()
					triggerToggle(arg0.showRecordBtn, false)
				end)
			end

			return
		end

		if arg0 then
			arg0:displayRecordPanel()

			if arg0.isShowQuick then
				triggerToggle(arg0.showQuickBtn, false)
			end
		else
			arg0:CloseRecordPanel(true)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.showQuickBtn, function(arg0)
		local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0:GetShipVO())

		if not var0 then
			if arg0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)
				onNextTick(function()
					triggerToggle(arg0.showQuickBtn, false)
				end)
			end

			arg0:CloseRecordPanel(true)
			arg0:CloseQuickPanel()

			return
		end

		if arg0 then
			arg0:displayQuickPanel()

			if arg0.selectedEquip then
				arg0:selectedEquipItem(arg0.selectedEquip.index)
			else
				arg0:quickSelectEmpty()
			end

			if arg0.isShowRecord then
				triggerToggle(arg0.showRecordBtn, false)
			end
		else
			arg0:CloseQuickPanel()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.equipCodeBtn, function()
		arg0:emit(ShipMainMediator.OPEN_EQUIP_CODE, {})
	end, SFX_PANEL)
	onButton(arg0, arg0.showECodeShareBtn, function()
		local var0 = arg0:GetShipVO()

		arg0:emit(ShipMainMediator.OPEN_EQUIP_CODE_SHARE, var0.id, var0:getGroupId())
	end, SFX_PANEL)
	onButton(arg0, arg0.unloadAllBtn, function()
		local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0:GetShipVO())

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("ship_unequip_all_tip"),
				onYes = function()
					arg0:emit(ShipMainMediator.UNEQUIP_FROM_SHIP_ALL, arg0:GetShipVO().id)
				end
			})
		end
	end, SFX_PANEL)

	function arg0.list.onInitItem(arg0)
		ClearTweenItemAlphaAndWhite(arg0)
	end

	function arg0.list.onReturnItem(arg0, arg1)
		ClearTweenItemAlphaAndWhite(arg1)
	end

	function arg0.list.onUpdateItem(arg0, arg1)
		setActive(findTF(tf(arg1), "IconTpl/icon_bg/icon"), false)
		TweenItemAlphaAndWhite(arg1)

		if arg0 == 0 and not arg0.selectedEquip.empty then
			setActive(findTF(tf(arg1), "unEquip"), true)
			setActive(findTF(tf(arg1), "bg"), false)
			setActive(findTF(tf(arg1), "IconTpl"), false)
			onButton(arg0, tf(arg1), function()
				local var0 = arg0.selectedEquip.index
				local var1 = arg0:GetShipVO()
				local var2 = var1:getEquip(arg0.selectedEquip.index):getConfig("name")
				local var3 = var1:getName()

				arg0:emit(ShipMainMediator.UNEQUIP_FROM_SHIP, {
					shipId = var1.id,
					pos = var0
				})
			end, SFX_PANEL)
		else
			setActive(findTF(tf(arg1), "unEquip"), false)
			setActive(findTF(tf(arg1), "bg"), true)
			setActive(findTF(tf(arg1), "IconTpl"), true)

			local var0 = arg0.selectedEquip.empty and arg0 + 1 or arg0
			local var1 = arg0.fillterEquipments[var0]

			if not var1 then
				return
			end

			setActive(findTF(tf(arg1), "IconTpl/icon_bg/icon"), true)
			updateEquipment(arg0:findTF("IconTpl", tf(arg1)), var1)

			if var1.shipId then
				local var2 = getProxy(BayProxy):getShipById(var1.shipId)

				setImageSprite(findTF(tf(arg1), "IconTpl/icon_bg/equip_flag/Image"), LoadSprite("qicon/" .. var2:getPainting()))
			end

			setActive(findTF(tf(arg1), "IconTpl/icon_bg/equip_flag"), var1.shipId and var1.shipId > 0)
			setActive(findTF(tf(arg1), "IconTpl/mask"), var1.mask)
			onButton(arg0, tf(arg1), function()
				if var1.mask then
					return
				end

				arg0:changeEquip(var1)
			end, SFX_PANEL)
		end
	end

	onToggle(arg0, arg0.equiping, function(arg0)
		arg0.equipingFlag = arg0

		if arg0.selectedEquip then
			arg0:updateQuickPanel(true)
		end
	end, SFX_PANEL)
	triggerToggle(arg0.equiping, true)
	onButton(arg0, arg0.fillter, function()
		arg0.indexData = arg0.indexData or {}

		if not var0.EQUIPMENT_INDEX then
			var0.EQUIPMENT_INDEX = Clone(StoreHouseConst.EQUIPMENT_INDEX_COMMON)

			table.removebyvalue(var0.EQUIPMENT_INDEX.customPanels.extraIndex.options, IndexConst.EquipmentExtraEquiping)
			table.removebyvalue(var0.EQUIPMENT_INDEX.customPanels.extraIndex.names, "index_equip")
		end

		local var0 = setmetatable({
			indexDatas = Clone(arg0.indexData),
			callback = function(arg0)
				arg0.indexData.typeIndex = arg0.typeIndex
				arg0.indexData.equipPropertyIndex = arg0.equipPropertyIndex
				arg0.indexData.equipPropertyIndex2 = arg0.equipPropertyIndex2
				arg0.indexData.equipAmmoIndex1 = arg0.equipAmmoIndex1
				arg0.indexData.equipAmmoIndex2 = arg0.equipAmmoIndex2
				arg0.indexData.equipCampIndex = arg0.equipCampIndex
				arg0.indexData.rarityIndex = arg0.rarityIndex
				arg0.indexData.extraIndex = arg0.extraIndex

				local var0 = underscore(arg0.indexData):chain():keys():all(function(arg0)
					return arg0.indexData[arg0] == var0.EQUIPMENT_INDEX.customPanels[arg0].options[1]
				end):value()

				setActive(findTF(arg0.fillter, "on"), not var0)
				setActive(findTF(arg0.fillter, "off"), var0)
				arg0:updateQuickPanel(true)
			end
		}, {
			__index = var0.EQUIPMENT_INDEX
		})

		arg0:emit(ShipMainMediator.OPEN_EQUIPMENT_INDEX, var0)
	end, SFX_PANEL)
end

function var0.changeEquip(arg0, arg1)
	local var0 = arg0.selectedEquip.index
	local var1 = arg0:GetShipVO()
	local var2 = {
		quickFlag = true,
		type = EquipmentInfoMediator.TYPE_REPLACE,
		equipmentId = arg1.id,
		shipId = var1.id,
		pos = var0,
		oldShipId = arg1.shipId,
		oldPos = arg1.shipPos
	}

	if var2 then
		if PlayerPrefs.GetInt("QUICK_CHANGE_EQUIP", 1) == 1 then
			arg0:emit(BaseUI.ON_EQUIPMENT, var2)
		else
			local var3, var4 = var1:canEquipAtPos(arg1, var0)

			if not var3 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentInfoLayer_error_canNotEquip", var4))

				return
			end

			if arg1.shipId then
				local var5 = getProxy(BayProxy):getShipById(arg1.shipId)
				local var6, var7 = ShipStatus.ShipStatusCheck("onModify", var5)

				if not var6 then
					pg.TipsMgr.GetInstance():ShowTips(var7)
				else
					arg0:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
						notice = GAME.EQUIP_FROM_SHIP,
						data = var2
					})
				end
			else
				arg0:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
					notice = GAME.EQUIP_TO_SHIP,
					data = var2
				})
			end
		end
	end
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.GetShipVO(arg0)
	if arg0.shareData and arg0.shareData.shipVO then
		return arg0.shareData.shipVO
	end

	return nil
end

function var0.OnSelected(arg0, arg1)
	local var0 = pg.UIMgr.GetInstance()

	if arg1 then
		var0:OverlayPanelPB(arg0._parentTf, {
			pbList = {
				arg0.detailPanel:Find("attrs"),
				arg0.detailPanel:Find("equipments"),
				arg0.detailPanel:Find("quick_panel")
			},
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		var0:UnOverlayPanel(arg0._parentTf, arg0.mainPanel)
	end

	arg0.onSelected = arg1

	if arg0.onSelected and arg0.selectedEquip then
		local var1 = arg0.selectedEquip.index

		arg0:selectedEquipItem(nil)
		arg0:selectedEquipItem(var1)
	end
end

function var0.UpdateUI(arg0)
	local var0 = arg0:GetShipVO()

	arg0:UpdateIntimacy(var0)
	arg0:UpdateDetail(var0)
	arg0:UpdateEquipments(var0)
	arg0:UpdateLock()
	arg0:UpdatePreferenceTag()
end

function var0.UpdateIntimacy(arg0, arg1)
	setActive(arg0.intimacyTF, not LOCK_PROPOSE)
	setIntimacyIcon(arg0.intimacyTF, arg1:getIntimacyIcon())
end

function var0.UpdateDetail(arg0, arg1)
	arg0.shipDetailLogicPanel:flush(arg1)

	local var0 = arg0.shipDetailLogicPanel.attrs:Find("icons/hunting_range/bg")

	removeOnButton(var0)

	if table.contains(TeamType.SubShipType, arg1:getShipType()) then
		onButton(arg0, var0, function()
			arg0:emit(ShipViewConst.DISPLAY_HUNTING_RANGE, true)
		end, SFX_PANEL)
	end

	if not HXSet.isHxSkin() then
		setActive(arg0.fashionToggle, arg0.shareData:HasFashion())
	else
		setActive(arg0.fashionToggle, false)
	end

	arg0:UpdateFashionTag()
	setActive(arg0.profileBtn, not arg1:isActivityNpc())
end

function var0.UpdateFashionTag(arg0)
	local var0 = arg0:GetShipVO()

	setActive(arg0.fashionTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0) > 0)
end

function var0.UpdateEquipments(arg0, arg1)
	arg0:clearListener()
	removeAllChildren(arg0.equipmentsGrid)

	local var0 = arg1:getActiveEquipments()

	arg0.equipItems = {}

	for iter0, iter1 in ipairs(arg1.equipments) do
		local var1 = var0[iter0]
		local var2
		local var3 = iter0
		local var4

		if iter1 then
			var2 = cloneTplTo(arg0.detailEquipmentTpl, arg0.equipmentsGrid)
			var4 = {
				empty = false,
				tf = var2,
				index = var3
			}

			table.insert(arg0.equipItems, var4)
			updateEquipment(arg0:findTF("IconTpl", var2), iter1)
			onButton(arg0, var2, function()
				if arg0.isShowQuick then
					arg0:selectedEquipItem(var3)
				else
					arg0:emit(BaseUI.ON_EQUIPMENT, {
						type = EquipmentInfoMediator.TYPE_SHIP,
						shipId = arg0:GetShipVO().id,
						pos = iter0,
						LayerWeightMgr_weight = LayerWeightConst.SECOND_LAYER
					})
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		else
			var2 = cloneTplTo(arg0.emptyGridTpl, arg0.equipmentsGrid)
			var4 = {
				empty = true,
				tf = var2,
				index = var3
			}

			table.insert(arg0.equipItems, var4)
			onButton(arg0, var2, function()
				if arg0.isShowQuick then
					arg0:selectedEquipItem(var3)
				else
					arg0:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		end

		local var5 = GetOrAddComponent(var2, typeof(EventTriggerListener))

		var5:AddPointDownFunc(function()
			if var2 and not arg0.isShowQuick then
				LeanTween.delayedCall(go(var2), 1, System.Action(function()
					arg0.selectedEquip = var4

					triggerToggle(arg0.showQuickBtn, true)
				end))
			end
		end)
		var5:AddPointUpFunc(function()
			if var2 and LeanTween.isTweening(go(var2)) then
				LeanTween.cancel(go(var2))
			end
		end)
	end

	local var6, var7 = ShipStatus.ShipStatusCheck("onModify", arg0:GetShipVO())

	if not var6 then
		triggerToggle(arg0.showQuickBtn, false)
	elseif arg1.id ~= arg0.lastShipVo and arg0.isShowQuick then
		onNextTick(function()
			triggerToggle(arg0.showQuickBtn, false)
			triggerToggle(arg0.showQuickBtn, true)
		end)
	elseif arg0.selectedEquip and arg0.isShowQuick then
		local var8 = arg0.selectedEquip.index

		arg0:selectedEquipItem(nil)
		arg0:selectedEquipItem(var8)
	end

	arg0.lastShipVo = arg1.id

	local var9, var10 = arg1:IsSpweaponUnlock()

	setActive(arg0.spWeaponSlot:Find("Lock"), not var9)

	local var11 = arg1:GetSpWeapon()

	setActive(arg0.spWeaponSlot:Find("Icon"), var11)
	setActive(arg0.spWeaponSlot:Find("IconShadow"), var11)

	if var11 then
		UpdateSpWeaponSlot(arg0.spWeaponSlot, var11)
	end

	onButton(arg0, arg0.spWeaponSlot, function()
		if not var9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var10))

			return
		elseif var11 then
			arg0:emit(BaseUI.ON_SPWEAPON, {
				type = EquipmentInfoMediator.TYPE_SHIP,
				shipId = arg0:GetShipVO().id
			})
		else
			arg0:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
		end
	end, SFX_PANEL)
end

function var0.selectedEquipItem(arg0, arg1)
	if not arg1 then
		if arg0.selectedEquip then
			arg0.selectedEquip = nil
			arg0.showEquipItem = nil
		end
	else
		arg0.selectedEquip = arg0.equipItems[arg1]
	end

	if arg0.isShowQuick then
		arg0:updateQuickPanel()
	end
end

function var0.updateQuickPanel(arg0, arg1)
	setActive(arg0.selectTitle, not arg0.selectedEquip)

	if arg0.isShowQuick and arg0.selectedEquip then
		if arg0.selectedEquip ~= arg0.showEquipItem or arg1 then
			arg0.showEquipItem = arg0.selectedEquip

			arg0:updateQuickEquipments()
		end
	else
		arg0:setListCount(0, 0)
		setActive(arg0.emptyTitle, false)
	end

	if arg0.equipItems then
		for iter0 = 1, #arg0.equipItems do
			if arg0.selectedEquip and arg0.selectedEquip.index == iter0 then
				setActive(findTF(arg0.equipItems[iter0].tf, "selected"), true)
			else
				setActive(findTF(arg0.equipItems[iter0].tf, "selected"), false)
			end
		end
	end
end

function var0.updateQuickEquipments(arg0)
	arg0:setListCount(0, 0)

	arg0.fillterEquipments = arg0:getEquipments()

	setActive(arg0.emptyTitle, false)

	if arg0.selectedEquip and arg0.selectedEquip.empty then
		setActive(arg0.emptyTitle, #arg0.fillterEquipments == 0)
	end

	local var0 = arg0.selectedEquip.empty and 0 or 1

	arg0:setListCount(#arg0.fillterEquipments + var0, 0)
end

function var0.setListCount(arg0, arg1, arg2)
	if arg0.onSelected and isActive(arg0._tf) and arg0.list then
		arg0.list:SetTotalCount(arg1, arg2)
	end
end

function var0.getEquipments(arg0)
	local var0 = getProxy(BayProxy)
	local var1 = arg0:GetShipVO()
	local var2 = getProxy(EquipmentProxy)
	local var3 = pg.ship_data_template[var1.configId]["equip_" .. arg0.selectedEquip.index]
	local var4 = var1:getShipType()
	local var5 = var2:getEquipmentsByFillter(var4, var3)

	if arg0.equipingFlag then
		for iter0, iter1 in ipairs(var0:getEquipsInShips(function(arg0, arg1)
			return var1.id ~= arg1 and not var1:isForbiddenAtPos(arg0, arg0.selectedEquip.index)
		end)) do
			table.insert(var5, iter1)
		end
	end

	local var6 = {}
	local var7 = {
		arg0.indexData.equipPropertyIndex,
		arg0.indexData.equipPropertyIndex2
	}

	for iter2, iter3 in pairs(var5) do
		if arg0:checkFillter(iter3, var7) then
			table.insert(var6, iter3)
		end
	end

	_.each(var6, function(arg0)
		if not var1:canEquipAtPos(arg0, arg0.selectedEquip.index) then
			arg0.mask = true
		end
	end)
	table.sort(var6, CompareFuncs(var1.sortFunc(var1.sort[1], false)))

	return var6
end

function var0.checkFillter(arg0, arg1, arg2)
	return (arg1.count > 0 or arg1.shipId and arg0.equipingFlag) and IndexConst.filterEquipByType(arg1, arg0.indexData.typeIndex) and IndexConst.filterEquipByProperty(arg1, arg2) and IndexConst.filterEquipAmmo1(arg1, arg0.indexData.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(arg1, arg0.indexData.equipAmmoIndex2) and IndexConst.filterEquipByCamp(arg1, arg0.indexData.equipCampIndex) and IndexConst.filterEquipByRarity(arg1, arg0.indexData.rarityIndex) and IndexConst.filterEquipByExtra(arg1, arg0.indexData.extraIndex)
end

function var0.UpdateLock(arg0)
	local var0 = arg0:GetShipVO():GetLockState()

	if var0 == arg0:GetShipVO().LOCK_STATE_UNLOCK then
		setActive(arg0.lockBtn, true)
		setActive(arg0.unlockBtn, false)
	elseif var0 == arg0:GetShipVO().LOCK_STATE_LOCK then
		setActive(arg0.lockBtn, false)
		setActive(arg0.unlockBtn, true)
	end
end

function var0.displayQuickPanel(arg0)
	if not arg0:GetShipVO() then
		return
	end

	arg0.isShowQuick = true

	setActive(arg0.attrs, false)
	setActive(arg0.quickPanel, true)
	arg0:updateQuickPanel()
end

function var0.quickSelectEmpty(arg0)
	if not arg0.selectedEquip and arg0.equipItems then
		for iter0 = 1, #arg0.equipItems do
			if arg0.equipItems[iter0].empty then
				arg0:selectedEquipItem(arg0.equipItems[iter0].index)

				return
			end
		end
	end
end

local var3 = 0.2

function var0.displayRecordPanel(arg0)
	if not arg0:GetShipVO() then
		return
	end

	arg0.isShowRecord = true

	setActive(arg0.recordPanel, true)
	setActive(arg0.attrs, false)

	for iter0, iter1 in ipairs(arg0.recordBtns) do
		onButton(arg0, iter1, function()
			arg0:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0:GetShipVO().id, iter0, 1)
		end, SFX_PANEL)
	end

	for iter2, iter3 in ipairs(arg0.equipRecordBtns) do
		onButton(arg0, iter3, function()
			arg0:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0:GetShipVO().id, iter2, 2)
		end, SFX_PANEL)
	end

	for iter4, iter5 in ipairs(arg0.recordEquipmentsTFs) do
		arg0:UpdateRecordEquipments(iter4)
	end

	arg0:UpdateRecordSpWeapons()
end

function var0.CloseRecordPanel(arg0, arg1)
	if arg1 then
		arg0.isShowRecord = nil

		setActive(arg0.recordPanel, false)

		if not arg0.isShowRecord and not arg0.isShowQuick then
			setActive(arg0.attrs, true)
		end
	else
		triggerToggle(arg0.showRecordBtn, false)
	end
end

function var0.CloseQuickPanel(arg0)
	arg0.isShowQuick = nil

	arg0:selectedEquipItem(nil)

	arg0.showEquipItem = nil

	if arg0.list then
		arg0:setListCount(0, 0)
	end

	setActive(arg0.quickPanel, false)

	if not arg0.isShowRecord and not arg0.isShowQuick then
		setActive(arg0.attrs, true)
	end

	arg0:updateQuickPanel()
end

function var0.UpdateRecordEquipments(arg0, arg1)
	local var0 = arg0.recordEquipmentsTFs[arg1]
	local var1 = arg0:GetShipVO():getEquipmentRecord(arg0.shareData.player.id)[arg1] or {}

	for iter0 = 1, 5 do
		local var2 = tonumber(var1[iter0])
		local var3 = var2 and var2 ~= -1
		local var4 = var0:Find("equipment_" .. iter0)
		local var5 = var4:Find("empty")
		local var6 = var4:Find("info")

		setActive(var6, var3)
		setActive(var5, not var3)

		if var3 then
			local var7 = arg0.equipmentProxy:getEquipmentById(var2)
			local var8 = arg0:GetShipVO().equipments[iter0]
			local var9 = not (var8 and var8.id == var2 or false) and (not var7 or not (var7.count > 0))

			setActive(var6:Find("tip"), var9)
			updateEquipment(arg0:findTF("IconTpl", var6), Equipment.New({
				id = var2
			}))

			if var9 then
				onButton(arg0, var6, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			end
		else
			removeOnButton(var6)
		end
	end
end

function var0.UpdateRecordSpWeapons(arg0, arg1)
	if LOCK_SP_WEAPON then
		return
	end

	local var0 = arg0:GetShipVO():GetSpWeaponRecord(arg0.shareData.player.id)

	table.Foreach(arg0.recordBars, function(arg0, arg1)
		if arg1 and arg0 ~= arg1 then
			return
		end

		local var0 = var0[arg0]
		local var1 = arg1:Find("SpSlot")
		local var2 = arg0:GetShipVO():IsSpweaponUnlock()

		setActive(var1:Find("Lock"), not var2)
		setActive(var1:Find("Icon"), var0)
		setActive(var1:Find("IconShadow"), var0)

		if var0 then
			UpdateSpWeaponSlot(var1, var0)

			local var3 = not var0:IsReal() or var0:GetShipId() ~= nil and var0:GetShipId() ~= arg0:GetShipVO().id

			setActive(var1:Find("Icon/tip"), var3)

			if var3 then
				onButton(arg0, var1, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			else
				removeOnButton(var1)
			end
		else
			removeOnButton(var1)
		end
	end)
end

function var0.UpdatePreferenceTag(arg0)
	triggerToggle(arg0.commonTagToggle, arg0:GetShipVO().preferenceTag == Ship.PREFERENCE_TAG_COMMON)
end

function var0.DoLeveUpAnim(arg0, arg1, arg2, arg3)
	arg0.shipDetailLogicPanel:doLeveUpAnim(arg1, arg2, arg3)
end

function var0.clearListener(arg0)
	if arg0.equipItems then
		for iter0 = 1, #arg0.equipItems do
			local var0 = arg0.equipItems[iter0].tf

			if var0 then
				ClearEventTrigger(GetOrAddComponent(go(var0), typeof(EventTriggerListener)))
				removeOnButton(go(var0))
			end
		end
	end
end

function var0.OnDestroy(arg0)
	arg0:clearListener()
	removeAllChildren(arg0.equipmentsGrid)

	if arg0.list then
		arg0.list:SetTotalCount(0)

		function arg0.list.onUpdateItem()
			return
		end
	end

	arg0.destroy = true

	if arg0.recordPanel then
		if LeanTween.isTweening(go(arg0.recordPanel)) then
			LeanTween.cancel(go(arg0.recordPanel))
		end

		arg0.recordPanel = nil
	end

	arg0.shipDetailLogicPanel:clear()
	arg0.shipDetailLogicPanel:detach()

	arg0.shareData = nil
end

return var0
