local var0_0 = class("ShipDetailView", import("...base.BaseSubView"))
local var1_0 = require("view.equipment.EquipmentSortCfg")
local var2_0 = {
	equipCampIndex = 2047,
	equipPropertyIndex = 4095,
	equipPropertyIndex2 = 4095,
	equipAmmoIndex1 = 15,
	equipAmmoIndex2 = 3,
	extraIndex = 0,
	typeIndex = 2047,
	rarityIndex = 31
}

function var0_0.getUIName(arg0_1)
	return "ShipDetailView"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/RecordableSearchBarUI4ShipDetailView",
		"template/intimacytpl"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.OnInit(arg0_3)
	arg0_3:InitDetail()
	arg0_3:InitEvent()
	setParent(arg0_3.randomFlagToggle, arg0_3._tf.parent)
	triggerToggle(arg0_3.showQuickBtn, false)
	triggerToggle(arg0_3.showRecordBtn, false)
end

function var0_0.InitDetail(arg0_4)
	arg0_4.mainPanel = arg0_4._parentTf.parent
	arg0_4.detailPanel = arg0_4._tf
	arg0_4.attrs = arg0_4.detailPanel:Find("attrs")

	setActive(arg0_4.attrs, false)

	arg0_4.shipDetailLogicPanel = ShipDetailLogicPanel.New(arg0_4.attrs)

	arg0_4.shipDetailLogicPanel:attach(arg0_4)

	arg0_4.equipments = arg0_4.detailPanel:Find("equipments")
	arg0_4.equipmentsGrid = arg0_4.equipments:Find("equipments")
	arg0_4.detailEquipmentTpl = arg0_4.equipments:Find("equipment_tpl")
	arg0_4.emptyGridTpl = arg0_4.equipments:Find("empty_tpl")
	arg0_4.showRecordBtn = arg0_4.equipments:Find("unload_all")
	arg0_4.showQuickBtn = arg0_4.equipments:Find("quickButton")
	arg0_4.showECodeShareBtn = arg0_4.equipments:Find("shareButton")
	arg0_4.equipCodeBtn = arg0_4.equipments:Find("equip_code")
	arg0_4.lockBtn = arg0_4.detailPanel:Find("lock_btn")
	arg0_4.unlockBtn = arg0_4.detailPanel:Find("unlock_btn")
	arg0_4.viewBtn = arg0_4.detailPanel:Find("view_btn")
	arg0_4.evaluationBtn = arg0_4.detailPanel:Find("evaluation_btn")
	arg0_4.profileBtn = arg0_4.detailPanel:Find("profile_btn")
	arg0_4.fashionToggle = arg0_4.detailPanel:Find("fashion_toggle")
	arg0_4.randomFlagToggle = arg0_4.detailPanel:Find("random_flag_toggle")
	arg0_4.fashionTag = arg0_4.fashionToggle:Find("Tag")
	arg0_4.commonTagToggle = arg0_4.detailPanel:Find("common_toggle")
	arg0_4.spWeaponSlot = arg0_4.equipments:Find("SpSlot")
	arg0_4.propertyIcons = arg0_4.detailPanel:Find("attrs/attrs/property/icons")
	arg0_4.intimacyTF = arg0_4._tf:Find("intimacy")
	arg0_4.updateItemTick = 0
	arg0_4.quickPanel = arg0_4.detailPanel:Find("quick_panel")
	arg0_4.equiping = arg0_4.quickPanel:Find("equiping")
	arg0_4.fillter = arg0_4.quickPanel:Find("fillter")
	arg0_4.selectTitle = arg0_4.quickPanel:Find("frame/selectTitle")
	arg0_4.emptyTitle = arg0_4.quickPanel:Find("frame/emptyTitle")
	arg0_4.list = arg0_4.quickPanel:Find("frame/container/Content"):GetComponent("LScrollRect")
	arg0_4.indexData = {}

	arg0_4:CloseQuickPanel()
	setText(arg0_4.quickPanel:Find("fillter/on/text2"), i18n("quick_equip_tip2"))
	setText(arg0_4.quickPanel:Find("fillter/off/text2"), i18n("quick_equip_tip2"))
	setText(arg0_4.quickPanel:Find("equiping/on/text2"), i18n("quick_equip_tip1"))
	setText(arg0_4.quickPanel:Find("equiping/off/text2"), i18n("quick_equip_tip1"))
	setText(arg0_4.quickPanel:Find("title/text"), i18n("quick_equip_tip3"))
	setText(arg0_4.quickPanel:Find("frame/emptyTitle/text"), i18n("quick_equip_tip4"))
	setText(arg0_4.quickPanel:Find("frame/selectTitle/text"), i18n("quick_equip_tip5"))
	setText(arg0_4.randomFlagToggle:Find("bg/Text"), i18n("ship_random_secretary_tag"))

	arg0_4.equipmentProxy = getProxy(EquipmentProxy)
	arg0_4.recordPanel = arg0_4.detailPanel:Find("record_panel")
	arg0_4.unloadAllBtn = arg0_4.recordPanel:Find("frame/unload_all")
	arg0_4.recordBars = _.map({
		1,
		2,
		3
	}, function(arg0_5)
		return arg0_4.recordPanel:Find("frame/container"):GetChild(arg0_5 - 1)
	end)
	arg0_4.recordBtns = {
		arg0_4.recordPanel:Find("frame/container/record_1/record_btn"),
		arg0_4.recordPanel:Find("frame/container/record_2/record_btn"),
		arg0_4.recordPanel:Find("frame/container/record_3/record_btn")
	}
	arg0_4.recordEquipmentsTFs = {
		arg0_4.recordPanel:Find("frame/container/record_1/equipments"),
		arg0_4.recordPanel:Find("frame/container/record_2/equipments"),
		arg0_4.recordPanel:Find("frame/container/record_3/equipments")
	}
	arg0_4.equipRecordBtns = {
		arg0_4.recordPanel:Find("frame/container/record_1/equip_btn"),
		arg0_4.recordPanel:Find("frame/container/record_2/equip_btn"),
		arg0_4.recordPanel:Find("frame/container/record_3/equip_btn")
	}
	arg0_4.searchBar = RecordableSearchBar.New(RecordableSearchBar.CreateData({
		uiName = "RecordableSearchBarUI4ShipDetailView",
		holder = i18n("search_equipment"),
		onInputChanged = function()
			arg0_4:updateQuickPanel(true)
		end,
		key = arg0_4.__cname,
		parent = arg0_4.quickPanel,
		anchoredPosition = Vector3(-623, -34, 0)
	}))

	setActive(arg0_4.detailPanel, true)
	setActive(arg0_4.attrs, true)
	setActive(arg0_4.recordPanel, false)
	setActive(arg0_4.detailEquipmentTpl, false)
	setActive(arg0_4.emptyGridTpl, false)
	setActive(arg0_4.detailPanel, true)

	arg0_4.onSelected = false

	if PLATFORM_CODE == PLATFORM_CHT and LOCK_SP_WEAPON then
		setActive(arg0_4.showRecordBtn, false)
		setActive(arg0_4.showQuickBtn, false)
		setActive(arg0_4.spWeaponSlot, false)

		arg0_4.showRecordBtn = arg0_4.equipments:Find("unload_all_2")
		arg0_4.showQuickBtn = arg0_4.equipments:Find("quickButton_2")

		setActive(arg0_4.showRecordBtn, true)
		setActive(arg0_4.showQuickBtn, true)
	end
end

function var0_0.InitEvent(arg0_7)
	onButton(arg0_7, arg0_7.fashionToggle, function()
		arg0_7:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.FASHION)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.propertyIcons, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_attr.tip,
			onClose = function()
				return
			end
		})
	end)
	onToggle(arg0_7, arg0_7.commonTagToggle, function(arg0_11)
		local var0_11 = arg0_7:GetShipVO().preferenceTag
		local var1_11 = var0_11 == Ship.PREFERENCE_TAG_COMMON

		if var1_11 ~= arg0_11 then
			if var0_11 == Ship.PREFERENCE_TAG_COMMON then
				var1_11 = Ship.PREFERENCE_TAG_NONE
			else
				var1_11 = Ship.PREFERENCE_TAG_COMMON
			end

			arg0_7:emit(ShipMainMediator.ON_TAG, arg0_7:GetShipVO().id, var1_11)
		end
	end, SFX_CONFIRM)
	onToggle(arg0_7, arg0_7.randomFlagToggle, function(arg0_12)
		if arg0_7:GetShipVO():getRandomFlag() ~= arg0_12 then
			arg0_7:emit(ShipMainMediator.CHANGE_RANDOM_FLAG, arg0_7:GetShipVO():GetShipPhantomMark(), arg0_12)
		end
	end, SFX_CONFIRM)
	onButton(arg0_7, arg0_7.lockBtn, function()
		arg0_7:emit(ShipMainMediator.ON_LOCK, {
			arg0_7:GetShipVO().id
		}, arg0_7:GetShipVO().LOCK_STATE_LOCK)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.unlockBtn, function()
		arg0_7:emit(ShipMainMediator.ON_LOCK, {
			arg0_7:GetShipVO().id
		}, arg0_7:GetShipVO().LOCK_STATE_UNLOCK)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.viewBtn, function()
		Input.multiTouchEnabled = true

		arg0_7:emit(ShipViewConst.PAINT_VIEW, true)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.evaluationBtn, function()
		arg0_7:emit(ShipMainMediator.OPEN_EVALUATION, arg0_7:GetShipVO():getGroupId(), arg0_7:GetShipVO():isActivityNpc())
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.profileBtn, function()
		arg0_7:emit(ShipMainMediator.OPEN_SHIPPROFILE, arg0_7:GetShipVO():getGroupId(), arg0_7:GetShipVO():isRemoulded())
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.intimacyTF, function()
		if arg0_7:GetShipVO():isActivityNpc() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("npc_propse_tip"))

			return
		end

		if LOCK_PROPOSE then
			return
		end

		arg0_7:emit(ShipMainMediator.PROPOSE, arg0_7:GetShipVO().id, function()
			return
		end)
	end)
	onToggle(arg0_7, arg0_7.showRecordBtn, function(arg0_20)
		local var0_20, var1_20 = ShipStatus.ShipStatusCheck("onModify", arg0_7:GetShipVO())

		if not var0_20 then
			if arg0_20 then
				pg.TipsMgr.GetInstance():ShowTips(var1_20)
				onNextTick(function()
					triggerToggle(arg0_7.showRecordBtn, false)
				end)
			end

			return
		end

		if arg0_20 then
			arg0_7:displayRecordPanel()

			if arg0_7.isShowQuick then
				triggerToggle(arg0_7.showQuickBtn, false)
			end
		else
			arg0_7:CloseRecordPanel(true)
		end
	end, SFX_PANEL)
	onToggle(arg0_7, arg0_7.showQuickBtn, function(arg0_22)
		local var0_22, var1_22 = ShipStatus.ShipStatusCheck("onModify", arg0_7:GetShipVO())

		if not var0_22 then
			if arg0_22 then
				pg.TipsMgr.GetInstance():ShowTips(var1_22)
				onNextTick(function()
					triggerToggle(arg0_7.showQuickBtn, false)
				end)
			end

			arg0_7:CloseRecordPanel(true)
			arg0_7:CloseQuickPanel()

			return
		end

		if arg0_22 then
			arg0_7:displayQuickPanel()

			if arg0_7.selectedEquip then
				arg0_7:selectedEquipItem(arg0_7.selectedEquip.index)
			else
				arg0_7:quickSelectEmpty()
			end

			if arg0_7.isShowRecord then
				triggerToggle(arg0_7.showRecordBtn, false)
			end
		else
			arg0_7:CloseQuickPanel()
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.equipCodeBtn, function()
		arg0_7:emit(ShipMainMediator.OPEN_EQUIP_CODE, {})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.showECodeShareBtn, function()
		local var0_25 = arg0_7:GetShipVO()

		arg0_7:emit(ShipMainMediator.OPEN_EQUIP_CODE_SHARE, var0_25.id, var0_25:getGroupId())
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.unloadAllBtn, function()
		local var0_26, var1_26 = ShipStatus.ShipStatusCheck("onModify", arg0_7:GetShipVO())

		if not var0_26 then
			pg.TipsMgr.GetInstance():ShowTips(var1_26)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("ship_unequip_all_tip"),
				onYes = function()
					arg0_7:emit(ShipMainMediator.UNEQUIP_FROM_SHIP_ALL, arg0_7:GetShipVO().id)
				end
			})
		end
	end, SFX_PANEL)

	function arg0_7.list.onInitItem(arg0_28)
		ClearTweenItemAlphaAndWhite(arg0_28)
	end

	function arg0_7.list.onReturnItem(arg0_29, arg1_29)
		ClearTweenItemAlphaAndWhite(arg1_29)
	end

	function arg0_7.list.onUpdateItem(arg0_30, arg1_30)
		setActive(findTF(tf(arg1_30), "IconTpl/icon_bg/icon"), false)
		TweenItemAlphaAndWhite(arg1_30)

		if arg0_30 == 0 and not arg0_7.selectedEquip.empty then
			setActive(findTF(tf(arg1_30), "unEquip"), true)
			setActive(findTF(tf(arg1_30), "bg"), false)
			setActive(findTF(tf(arg1_30), "IconTpl"), false)
			onButton(arg0_7, tf(arg1_30), function()
				local var0_31 = arg0_7.selectedEquip.index
				local var1_31 = arg0_7:GetShipVO()
				local var2_31 = var1_31:getEquip(arg0_7.selectedEquip.index):getConfig("name")
				local var3_31 = var1_31:getName()

				arg0_7:emit(ShipMainMediator.UNEQUIP_FROM_SHIP, {
					shipId = var1_31.id,
					pos = var0_31
				})
			end, SFX_PANEL)
		else
			setActive(findTF(tf(arg1_30), "unEquip"), false)
			setActive(findTF(tf(arg1_30), "bg"), true)
			setActive(findTF(tf(arg1_30), "IconTpl"), true)

			local var0_30 = arg0_7.selectedEquip.empty and arg0_30 + 1 or arg0_30
			local var1_30 = arg0_7.fillterEquipments[var0_30]

			if not var1_30 then
				return
			end

			setActive(findTF(tf(arg1_30), "IconTpl/icon_bg/icon"), true)
			updateEquipment(findTF(tf(arg1_30), "IconTpl"), var1_30)

			if var1_30.shipId then
				local var2_30 = getProxy(BayProxy):getShipById(var1_30.shipId)

				setImageSprite(findTF(tf(arg1_30), "IconTpl/icon_bg/equip_flag/Image"), LoadSprite("qicon/" .. var2_30:getPainting()))
			end

			setActive(findTF(tf(arg1_30), "IconTpl/icon_bg/equip_flag"), var1_30.shipId and var1_30.shipId > 0)
			setActive(findTF(tf(arg1_30), "IconTpl/mask"), var1_30.mask)
			onButton(arg0_7, tf(arg1_30), function()
				if var1_30.mask then
					return
				end

				arg0_7:changeEquip(var1_30)
			end, SFX_PANEL)
		end
	end

	onToggle(arg0_7, arg0_7.equiping, function(arg0_33)
		arg0_7.equipingFlag = arg0_33

		if arg0_7.selectedEquip then
			arg0_7:updateQuickPanel(true)
		end
	end, SFX_PANEL)
	triggerToggle(arg0_7.equiping, true)
	onButton(arg0_7, arg0_7.fillter, function()
		arg0_7.indexData = arg0_7.indexData or {}

		if not var0_0.EQUIPMENT_INDEX then
			var0_0.EQUIPMENT_INDEX = Clone(StoreHouseConst.EQUIPMENT_INDEX_COMMON)

			table.removebyvalue(var0_0.EQUIPMENT_INDEX.customPanels.extraIndex.options, IndexConst.EquipmentExtraEquiping)
			table.removebyvalue(var0_0.EQUIPMENT_INDEX.customPanels.extraIndex.names, "index_equip")
		end

		local var0_34 = setmetatable({
			indexDatas = Clone(arg0_7.indexData),
			callback = function(arg0_35)
				arg0_7.indexData.typeIndex = arg0_35.typeIndex
				arg0_7.indexData.equipPropertyIndex = arg0_35.equipPropertyIndex
				arg0_7.indexData.equipPropertyIndex2 = arg0_35.equipPropertyIndex2
				arg0_7.indexData.equipAmmoIndex1 = arg0_35.equipAmmoIndex1
				arg0_7.indexData.equipAmmoIndex2 = arg0_35.equipAmmoIndex2
				arg0_7.indexData.equipCampIndex = arg0_35.equipCampIndex
				arg0_7.indexData.rarityIndex = arg0_35.rarityIndex
				arg0_7.indexData.extraIndex = arg0_35.extraIndex

				local var0_35 = underscore(arg0_7.indexData):chain():keys():all(function(arg0_36)
					return arg0_7.indexData[arg0_36] == var0_0.EQUIPMENT_INDEX.customPanels[arg0_36].options[1]
				end):value()

				setActive(findTF(arg0_7.fillter, "on"), not var0_35)
				setActive(findTF(arg0_7.fillter, "off"), var0_35)
				arg0_7:updateQuickPanel(true)
			end
		}, {
			__index = var0_0.EQUIPMENT_INDEX
		})

		arg0_7:emit(ShipMainMediator.OPEN_EQUIPMENT_INDEX, var0_34)
	end, SFX_PANEL)
end

function var0_0.changeEquip(arg0_37, arg1_37)
	local var0_37 = arg0_37.selectedEquip.index
	local var1_37 = arg0_37:GetShipVO()
	local var2_37 = {
		quickFlag = true,
		type = EquipmentInfoMediator.TYPE_REPLACE,
		equipmentId = arg1_37.id,
		shipId = var1_37.id,
		pos = var0_37,
		oldShipId = arg1_37.shipId,
		oldPos = arg1_37.shipPos
	}

	if var2_37 then
		if PlayerPrefs.GetInt("QUICK_CHANGE_EQUIP", 1) == 1 then
			arg0_37:emit(BaseUI.ON_EQUIPMENT, var2_37)
		else
			local var3_37, var4_37 = var1_37:canEquipAtPos(arg1_37, var0_37)

			if not var3_37 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentInfoLayer_error_canNotEquip", var4_37))

				return
			end

			if arg1_37.shipId then
				local var5_37 = getProxy(BayProxy):getShipById(arg1_37.shipId)
				local var6_37, var7_37 = ShipStatus.ShipStatusCheck("onModify", var5_37)

				if not var6_37 then
					pg.TipsMgr.GetInstance():ShowTips(var7_37)
				else
					arg0_37:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
						notice = GAME.EQUIP_FROM_SHIP,
						data = var2_37
					})
				end
			else
				arg0_37:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
					notice = GAME.EQUIP_TO_SHIP,
					data = var2_37
				})
			end
		end
	end
end

function var0_0.SetShareData(arg0_38, arg1_38)
	arg0_38.shareData = arg1_38
end

function var0_0.GetShipVO(arg0_39)
	if arg0_39.shareData and arg0_39.shareData.shipVO then
		return arg0_39.shareData.shipVO
	end

	return nil
end

function var0_0.OnSelected(arg0_40, arg1_40)
	if arg1_40 then
		arg0_40:OverlayPanel(arg0_40._parentTf, {
			pbList = {
				arg0_40.detailPanel:Find("attrs"),
				arg0_40.detailPanel:Find("equipments"),
				arg0_40.detailPanel:Find("quick_panel")
			},
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		arg0_40:UnOverlayPanel(arg0_40._parentTf, arg0_40.mainPanel)
	end

	arg0_40.onSelected = arg1_40

	if arg0_40.onSelected and arg0_40.selectedEquip then
		local var0_40 = arg0_40.selectedEquip.index

		arg0_40:selectedEquipItem(nil)
		arg0_40:selectedEquipItem(var0_40)
	end
end

function var0_0.UpdateUI(arg0_41)
	arg0_41.searchBar:ClearInputText()

	local var0_41 = arg0_41:GetShipVO()

	arg0_41:UpdateIntimacy(var0_41)
	arg0_41:UpdateDetail(var0_41)
	arg0_41:UpdateEquipments(var0_41)
	arg0_41:UpdateLock()
	arg0_41:UpdatePreferenceTag()

	arg0_41.activeRandomFlag = not var0_41:isActivityNpc()

	setActive(arg0_41.randomFlagToggle, arg0_41.activeRandomFlag)
	triggerToggle(arg0_41.randomFlagToggle, var0_41:getRandomFlag())
end

function var0_0.UpdateIntimacy(arg0_42, arg1_42)
	setActive(arg0_42.intimacyTF, not LOCK_PROPOSE)
	setIntimacyIcon(arg0_42.intimacyTF, arg1_42:getIntimacyIcon())
end

function var0_0.UpdateDetail(arg0_43, arg1_43)
	arg0_43.shipDetailLogicPanel:flush(arg1_43)

	local var0_43 = arg0_43.shipDetailLogicPanel.attrs:Find("icons/hunting_range/bg")

	removeOnButton(var0_43)

	if table.contains(ShipType.SubShipType, arg1_43:getShipType()) then
		onButton(arg0_43, var0_43, function()
			arg0_43:emit(ShipViewConst.DISPLAY_HUNTING_RANGE, true)
		end, SFX_PANEL)
	end

	if not HXSet.isHxSkin() then
		setActive(arg0_43.fashionToggle, arg0_43.shareData:HasFashion())
	else
		setActive(arg0_43.fashionToggle, false)
	end

	arg0_43:UpdateFashionTag()
	setActive(arg0_43.profileBtn, not arg1_43:isActivityNpc())
end

function var0_0.UpdateFashionTag(arg0_45)
	local var0_45 = arg0_45:GetShipVO()

	setActive(arg0_45.fashionTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0_45) > 0)
end

function var0_0.UpdateEquipments(arg0_46, arg1_46)
	arg0_46:clearListener()
	removeAllChildren(arg0_46.equipmentsGrid)

	local var0_46 = arg1_46:getActiveEquipments()

	arg0_46.equipItems = {}

	for iter0_46, iter1_46 in ipairs(arg1_46.equipments) do
		local var1_46 = var0_46[iter0_46]
		local var2_46
		local var3_46 = iter0_46
		local var4_46

		if iter1_46 then
			var2_46 = cloneTplTo(arg0_46.detailEquipmentTpl, arg0_46.equipmentsGrid)
			var4_46 = {
				empty = false,
				tf = var2_46,
				index = var3_46
			}

			table.insert(arg0_46.equipItems, var4_46)
			updateEquipment(var2_46:Find("IconTpl"), iter1_46)
			onButton(arg0_46, var2_46, function()
				if arg0_46.isShowQuick then
					arg0_46:selectedEquipItem(var3_46)
				else
					arg0_46:emit(BaseUI.ON_EQUIPMENT, {
						type = EquipmentInfoMediator.TYPE_SHIP,
						shipId = arg0_46:GetShipVO().id,
						pos = iter0_46
					})
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		else
			var2_46 = cloneTplTo(arg0_46.emptyGridTpl, arg0_46.equipmentsGrid)
			var4_46 = {
				empty = true,
				tf = var2_46,
				index = var3_46
			}

			table.insert(arg0_46.equipItems, var4_46)
			onButton(arg0_46, var2_46, function()
				if arg0_46.isShowQuick then
					arg0_46:selectedEquipItem(var3_46)
				else
					arg0_46:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		end

		local var5_46 = GetOrAddComponent(var2_46, typeof(EventTriggerListener))

		var5_46:AddPointDownFunc(function()
			if var2_46 and not arg0_46.isShowQuick then
				LeanTween.delayedCall(go(var2_46), 1, System.Action(function()
					arg0_46.selectedEquip = var4_46

					triggerToggle(arg0_46.showQuickBtn, true)
				end))
			end
		end)
		var5_46:AddPointUpFunc(function()
			if var2_46 and LeanTween.isTweening(go(var2_46)) then
				LeanTween.cancel(go(var2_46))
			end
		end)
	end

	local var6_46, var7_46 = ShipStatus.ShipStatusCheck("onModify", arg0_46:GetShipVO())

	if not var6_46 then
		triggerToggle(arg0_46.showQuickBtn, false)
	elseif arg1_46.id ~= arg0_46.lastShipVo and arg0_46.isShowQuick then
		onNextTick(function()
			triggerToggle(arg0_46.showQuickBtn, false)
			triggerToggle(arg0_46.showQuickBtn, true)
		end)
	elseif arg0_46.selectedEquip and arg0_46.isShowQuick then
		local var8_46 = arg0_46.selectedEquip.index

		arg0_46:selectedEquipItem(nil)
		arg0_46:selectedEquipItem(var8_46)
	end

	arg0_46.lastShipVo = arg1_46.id

	local var9_46, var10_46 = arg1_46:IsSpweaponUnlock()

	setActive(arg0_46.spWeaponSlot:Find("Lock"), not var9_46)

	local var11_46 = arg1_46:GetSpWeapon()

	setActive(arg0_46.spWeaponSlot:Find("Icon"), var11_46)
	setActive(arg0_46.spWeaponSlot:Find("IconShadow"), var11_46)

	if var11_46 then
		UpdateSpWeaponSlot(arg0_46.spWeaponSlot, var11_46)
	end

	onButton(arg0_46, arg0_46.spWeaponSlot, function()
		if not var9_46 then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var10_46))

			return
		elseif var11_46 then
			arg0_46:emit(BaseUI.ON_SPWEAPON, {
				type = EquipmentInfoMediator.TYPE_SHIP,
				shipId = arg0_46:GetShipVO().id
			})
		else
			arg0_46:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
		end
	end, SFX_PANEL)
end

function var0_0.selectedEquipItem(arg0_54, arg1_54)
	if not arg1_54 then
		if arg0_54.selectedEquip then
			arg0_54.selectedEquip = nil
			arg0_54.showEquipItem = nil
		end
	else
		arg0_54.selectedEquip = arg0_54.equipItems[arg1_54]
	end

	if arg0_54.isShowQuick then
		arg0_54:updateQuickPanel()
	end
end

function var0_0.updateQuickPanel(arg0_55, arg1_55)
	setActive(arg0_55.selectTitle, not arg0_55.selectedEquip)

	if arg0_55.isShowQuick and arg0_55.selectedEquip then
		if arg0_55.selectedEquip ~= arg0_55.showEquipItem or arg1_55 then
			arg0_55.showEquipItem = arg0_55.selectedEquip

			arg0_55:updateQuickEquipments()
		end
	else
		arg0_55:setListCount(0, 0)
		setActive(arg0_55.emptyTitle, false)
	end

	if arg0_55.equipItems then
		for iter0_55 = 1, #arg0_55.equipItems do
			if arg0_55.selectedEquip and arg0_55.selectedEquip.index == iter0_55 then
				setActive(findTF(arg0_55.equipItems[iter0_55].tf, "selected"), true)
			else
				setActive(findTF(arg0_55.equipItems[iter0_55].tf, "selected"), false)
			end
		end
	end
end

function var0_0.updateQuickEquipments(arg0_56)
	arg0_56:setListCount(0, 0)

	arg0_56.fillterEquipments = arg0_56:getEquipments()

	setActive(arg0_56.emptyTitle, false)

	if arg0_56.selectedEquip and arg0_56.selectedEquip.empty then
		setActive(arg0_56.emptyTitle, #arg0_56.fillterEquipments == 0)
	end

	local var0_56 = arg0_56.selectedEquip.empty and 0 or 1

	arg0_56:setListCount(#arg0_56.fillterEquipments + var0_56, 0)
end

function var0_0.setListCount(arg0_57, arg1_57, arg2_57)
	if arg0_57.onSelected and isActive(arg0_57._tf) and arg0_57.list then
		arg0_57.list:SetTotalCount(arg1_57, arg2_57)
	end
end

function var0_0.getEquipments(arg0_58)
	local var0_58 = getProxy(BayProxy)
	local var1_58 = arg0_58:GetShipVO()
	local var2_58 = getProxy(EquipmentProxy)
	local var3_58 = pg.ship_data_template[var1_58.configId]["equip_" .. arg0_58.selectedEquip.index]
	local var4_58 = var1_58:getShipType()
	local var5_58 = var2_58:getEquipmentsByFillter(var4_58, var3_58)
	local var6_58 = arg0_58.searchBar:GetInputText()

	if arg0_58.equipingFlag then
		for iter0_58, iter1_58 in ipairs(var0_58:getEquipsInShips(function(arg0_59, arg1_59)
			return var1_58.id ~= arg1_59 and not var1_58:isForbiddenAtPos(arg0_59, arg0_58.selectedEquip.index)
		end)) do
			if var6_58 == "" or iter1_58:IsMatchKey(var6_58) then
				table.insert(var5_58, iter1_58)
			end
		end
	end

	local var7_58 = {}
	local var8_58 = {
		arg0_58.indexData.equipPropertyIndex,
		arg0_58.indexData.equipPropertyIndex2
	}

	for iter2_58, iter3_58 in pairs(var5_58) do
		if arg0_58:checkFillter(iter3_58, var8_58) and (var6_58 == "" or iter3_58:IsMatchKey(var6_58)) then
			table.insert(var7_58, iter3_58)
		end
	end

	_.each(var7_58, function(arg0_60)
		if not var1_58:canEquipAtPos(arg0_60, arg0_58.selectedEquip.index) then
			arg0_60.mask = true
		end
	end)
	table.sort(var7_58, CompareFuncs(var1_0.sortFunc(var1_0.sort[1], false)))

	return var7_58
end

function var0_0.checkFillter(arg0_61, arg1_61, arg2_61)
	return (arg1_61.count > 0 or arg1_61.shipId and arg0_61.equipingFlag) and IndexConst.filterEquipByType(arg1_61, arg0_61.indexData.typeIndex) and IndexConst.filterEquipByProperty(arg1_61, arg2_61) and IndexConst.filterEquipAmmo1(arg1_61, arg0_61.indexData.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(arg1_61, arg0_61.indexData.equipAmmoIndex2) and IndexConst.filterEquipByCamp(arg1_61, arg0_61.indexData.equipCampIndex) and IndexConst.filterEquipByRarity(arg1_61, arg0_61.indexData.rarityIndex) and IndexConst.filterEquipByExtra(arg1_61, arg0_61.indexData.extraIndex)
end

function var0_0.UpdateLock(arg0_62)
	local var0_62 = arg0_62:GetShipVO():GetLockState()

	if var0_62 == arg0_62:GetShipVO().LOCK_STATE_UNLOCK then
		setActive(arg0_62.lockBtn, true)
		setActive(arg0_62.unlockBtn, false)
	elseif var0_62 == arg0_62:GetShipVO().LOCK_STATE_LOCK then
		setActive(arg0_62.lockBtn, false)
		setActive(arg0_62.unlockBtn, true)
	end
end

function var0_0.displayQuickPanel(arg0_63)
	if not arg0_63:GetShipVO() then
		return
	end

	arg0_63.isShowQuick = true

	setActive(arg0_63.attrs, false)
	setActive(arg0_63.quickPanel, true)
	arg0_63:updateQuickPanel()
end

function var0_0.quickSelectEmpty(arg0_64)
	if not arg0_64.selectedEquip and arg0_64.equipItems then
		for iter0_64 = 1, #arg0_64.equipItems do
			if arg0_64.equipItems[iter0_64].empty then
				arg0_64:selectedEquipItem(arg0_64.equipItems[iter0_64].index)

				return
			end
		end
	end
end

function var0_0.Show(arg0_65)
	var0_0.super.Show(arg0_65)
	setActive(arg0_65.randomFlagToggle, arg0_65.activeRandomFlag)
end

function var0_0.Hide(arg0_66)
	var0_0.super.Hide(arg0_66)
	setActive(arg0_66.randomFlagToggle, false)
end

local var3_0 = 0.2

function var0_0.displayRecordPanel(arg0_67)
	if not arg0_67:GetShipVO() then
		return
	end

	arg0_67.isShowRecord = true

	setActive(arg0_67.recordPanel, true)
	setActive(arg0_67.attrs, false)

	for iter0_67, iter1_67 in ipairs(arg0_67.recordBtns) do
		onButton(arg0_67, iter1_67, function()
			arg0_67:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0_67:GetShipVO().id, iter0_67, 1)
		end, SFX_PANEL)
	end

	for iter2_67, iter3_67 in ipairs(arg0_67.equipRecordBtns) do
		onButton(arg0_67, iter3_67, function()
			arg0_67:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0_67:GetShipVO().id, iter2_67, 2)
		end, SFX_PANEL)
	end

	for iter4_67, iter5_67 in ipairs(arg0_67.recordEquipmentsTFs) do
		arg0_67:UpdateRecordEquipments(iter4_67)
	end

	arg0_67:UpdateRecordSpWeapons()
end

function var0_0.CloseRecordPanel(arg0_70, arg1_70)
	if arg1_70 then
		arg0_70.isShowRecord = nil

		setActive(arg0_70.recordPanel, false)

		if not arg0_70.isShowRecord and not arg0_70.isShowQuick then
			setActive(arg0_70.attrs, true)
		end
	else
		triggerToggle(arg0_70.showRecordBtn, false)
	end
end

function var0_0.CloseQuickPanel(arg0_71)
	arg0_71.isShowQuick = nil

	arg0_71:selectedEquipItem(nil)

	arg0_71.showEquipItem = nil

	if arg0_71.list then
		arg0_71:setListCount(0, 0)
	end

	setActive(arg0_71.quickPanel, false)

	if not arg0_71.isShowRecord and not arg0_71.isShowQuick then
		setActive(arg0_71.attrs, true)
	end

	arg0_71:updateQuickPanel()
end

function var0_0.UpdateRecordEquipments(arg0_72, arg1_72)
	local var0_72 = arg0_72.recordEquipmentsTFs[arg1_72]
	local var1_72 = arg0_72:GetShipVO():getEquipmentRecord(arg0_72.shareData.player.id)[arg1_72] or {}

	for iter0_72 = 1, 5 do
		local var2_72 = tonumber(var1_72[iter0_72])
		local var3_72 = var2_72 and var2_72 ~= -1
		local var4_72 = var0_72:Find("equipment_" .. iter0_72)
		local var5_72 = var4_72:Find("empty")
		local var6_72 = var4_72:Find("info")

		setActive(var6_72, var3_72)
		setActive(var5_72, not var3_72)

		if var3_72 then
			local var7_72 = arg0_72.equipmentProxy:getEquipmentById(var2_72)
			local var8_72 = arg0_72:GetShipVO().equipments[iter0_72]
			local var9_72 = not (var8_72 and var8_72.id == var2_72 or false) and (not var7_72 or not (var7_72.count > 0))

			setActive(var6_72:Find("tip"), var9_72)
			updateEquipment(var6_72:Find("IconTpl"), Equipment.New({
				id = var2_72
			}))

			if var9_72 then
				onButton(arg0_72, var6_72, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			end
		else
			removeOnButton(var6_72)
		end
	end
end

function var0_0.UpdateRecordSpWeapons(arg0_74, arg1_74)
	if LOCK_SP_WEAPON then
		return
	end

	local var0_74 = arg0_74:GetShipVO():GetSpWeaponRecord(arg0_74.shareData.player.id)

	table.Foreach(arg0_74.recordBars, function(arg0_75, arg1_75)
		if arg1_74 and arg0_75 ~= arg1_74 then
			return
		end

		local var0_75 = var0_74[arg0_75]
		local var1_75 = arg1_75:Find("SpSlot")
		local var2_75 = arg0_74:GetShipVO():IsSpweaponUnlock()

		setActive(var1_75:Find("Lock"), not var2_75)
		setActive(var1_75:Find("Icon"), var0_75)
		setActive(var1_75:Find("IconShadow"), var0_75)

		if var0_75 then
			UpdateSpWeaponSlot(var1_75, var0_75)

			local var3_75 = arg0_74:GetShipVO():GetSpWeapon()
			local var4_75 = var3_75 and var3_75:GetConfigID() or 0
			local var5_75 = var0_75:GetConfigID() ~= var4_75

			if var5_75 then
				local var6_75 = getProxy(EquipmentProxy):GetSameTypeSpWeapon(var0_75)

				if var6_75 and var6_75:GetConfigID() == var0_75:GetConfigID() then
					var5_75 = false
				end
			end

			setActive(var1_75:Find("Icon/tip"), var5_75)

			if var5_75 then
				onButton(arg0_74, var1_75, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			else
				removeOnButton(var1_75)
			end
		else
			removeOnButton(var1_75)
		end
	end)
end

function var0_0.UpdatePreferenceTag(arg0_77)
	triggerToggle(arg0_77.commonTagToggle, arg0_77:GetShipVO().preferenceTag == Ship.PREFERENCE_TAG_COMMON)
end

function var0_0.DoLeveUpAnim(arg0_78, arg1_78, arg2_78, arg3_78)
	arg0_78.shipDetailLogicPanel:doLeveUpAnim(arg1_78, arg2_78, arg3_78)
end

function var0_0.clearListener(arg0_79)
	if arg0_79.equipItems then
		for iter0_79 = 1, #arg0_79.equipItems do
			local var0_79 = arg0_79.equipItems[iter0_79].tf

			if var0_79 then
				ClearEventTrigger(GetOrAddComponent(go(var0_79), typeof(EventTriggerListener)))
				removeOnButton(go(var0_79))
			end
		end
	end
end

function var0_0.OnDestroy(arg0_80)
	setParent(arg0_80.randomFlagToggle, arg0_80._tf)
	arg0_80:clearListener()
	removeAllChildren(arg0_80.equipmentsGrid)

	if arg0_80.list then
		arg0_80.list:SetTotalCount(0)

		function arg0_80.list.onUpdateItem()
			return
		end
	end

	arg0_80.destroy = true

	if arg0_80.recordPanel then
		if LeanTween.isTweening(go(arg0_80.recordPanel)) then
			LeanTween.cancel(go(arg0_80.recordPanel))
		end

		arg0_80.recordPanel = nil
	end

	arg0_80.shipDetailLogicPanel:clear()
	arg0_80.shipDetailLogicPanel:detach()

	arg0_80.shareData = nil

	if arg0_80.searchBar then
		arg0_80.searchBar:Dispose()

		arg0_80.searchBar = nil
	end
end

return var0_0
