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

function var0_0.OnInit(arg0_2)
	arg0_2:InitDetail()
	arg0_2:InitEvent()
	setParent(arg0_2.randomFlagToggle, arg0_2._tf.parent)
	triggerToggle(arg0_2.showQuickBtn, false)
	triggerToggle(arg0_2.showRecordBtn, false)
end

function var0_0.InitDetail(arg0_3)
	arg0_3.mainPanel = arg0_3._parentTf.parent
	arg0_3.detailPanel = arg0_3._tf
	arg0_3.attrs = arg0_3.detailPanel:Find("attrs")

	setActive(arg0_3.attrs, false)

	arg0_3.shipDetailLogicPanel = ShipDetailLogicPanel.New(arg0_3.attrs)

	arg0_3.shipDetailLogicPanel:attach(arg0_3)

	arg0_3.equipments = arg0_3.detailPanel:Find("equipments")
	arg0_3.equipmentsGrid = arg0_3.equipments:Find("equipments")
	arg0_3.detailEquipmentTpl = arg0_3.equipments:Find("equipment_tpl")
	arg0_3.emptyGridTpl = arg0_3.equipments:Find("empty_tpl")
	arg0_3.showRecordBtn = arg0_3.equipments:Find("unload_all")
	arg0_3.showQuickBtn = arg0_3.equipments:Find("quickButton")
	arg0_3.showECodeShareBtn = arg0_3.equipments:Find("shareButton")
	arg0_3.equipCodeBtn = arg0_3.equipments:Find("equip_code")
	arg0_3.lockBtn = arg0_3.detailPanel:Find("lock_btn")
	arg0_3.unlockBtn = arg0_3.detailPanel:Find("unlock_btn")
	arg0_3.viewBtn = arg0_3.detailPanel:Find("view_btn")
	arg0_3.evaluationBtn = arg0_3.detailPanel:Find("evaluation_btn")
	arg0_3.profileBtn = arg0_3.detailPanel:Find("profile_btn")
	arg0_3.fashionToggle = arg0_3.detailPanel:Find("fashion_toggle")
	arg0_3.randomFlagToggle = arg0_3.detailPanel:Find("random_flag_toggle")
	arg0_3.fashionTag = arg0_3.fashionToggle:Find("Tag")
	arg0_3.commonTagToggle = arg0_3.detailPanel:Find("common_toggle")
	arg0_3.spWeaponSlot = arg0_3.equipments:Find("SpSlot")
	arg0_3.propertyIcons = arg0_3.detailPanel:Find("attrs/attrs/property/icons")
	arg0_3.intimacyTF = arg0_3._tf:Find("intimacy")
	arg0_3.updateItemTick = 0
	arg0_3.quickPanel = arg0_3.detailPanel:Find("quick_panel")
	arg0_3.equiping = arg0_3.quickPanel:Find("equiping")
	arg0_3.fillter = arg0_3.quickPanel:Find("fillter")
	arg0_3.selectTitle = arg0_3.quickPanel:Find("frame/selectTitle")
	arg0_3.emptyTitle = arg0_3.quickPanel:Find("frame/emptyTitle")
	arg0_3.list = arg0_3.quickPanel:Find("frame/container/Content"):GetComponent("LScrollRect")
	arg0_3.indexData = {}

	arg0_3:CloseQuickPanel()
	setText(arg0_3.quickPanel:Find("fillter/on/text2"), i18n("quick_equip_tip2"))
	setText(arg0_3.quickPanel:Find("fillter/off/text2"), i18n("quick_equip_tip2"))
	setText(arg0_3.quickPanel:Find("equiping/on/text2"), i18n("quick_equip_tip1"))
	setText(arg0_3.quickPanel:Find("equiping/off/text2"), i18n("quick_equip_tip1"))
	setText(arg0_3.quickPanel:Find("title/text"), i18n("quick_equip_tip3"))
	setText(arg0_3.quickPanel:Find("frame/emptyTitle/text"), i18n("quick_equip_tip4"))
	setText(arg0_3.quickPanel:Find("frame/selectTitle/text"), i18n("quick_equip_tip5"))
	setText(arg0_3.randomFlagToggle:Find("bg/Text"), i18n("ship_random_secretary_tag"))

	arg0_3.equipmentProxy = getProxy(EquipmentProxy)
	arg0_3.recordPanel = arg0_3.detailPanel:Find("record_panel")
	arg0_3.unloadAllBtn = arg0_3.recordPanel:Find("frame/unload_all")
	arg0_3.recordBars = _.map({
		1,
		2,
		3
	}, function(arg0_4)
		return arg0_3.recordPanel:Find("frame/container"):GetChild(arg0_4 - 1)
	end)
	arg0_3.recordBtns = {
		arg0_3.recordPanel:Find("frame/container/record_1/record_btn"),
		arg0_3.recordPanel:Find("frame/container/record_2/record_btn"),
		arg0_3.recordPanel:Find("frame/container/record_3/record_btn")
	}
	arg0_3.recordEquipmentsTFs = {
		arg0_3.recordPanel:Find("frame/container/record_1/equipments"),
		arg0_3.recordPanel:Find("frame/container/record_2/equipments"),
		arg0_3.recordPanel:Find("frame/container/record_3/equipments")
	}
	arg0_3.equipRecordBtns = {
		arg0_3.recordPanel:Find("frame/container/record_1/equip_btn"),
		arg0_3.recordPanel:Find("frame/container/record_2/equip_btn"),
		arg0_3.recordPanel:Find("frame/container/record_3/equip_btn")
	}
	arg0_3.nameSearchInput = arg0_3.quickPanel:Find("serachPanel/search")
	arg0_3.nameSearchText = arg0_3.nameSearchInput:Find("holder")

	setText(arg0_3.nameSearchText, i18n("search_equipment"))
	setInputText(arg0_3.nameSearchInput, "")
	onInputChanged(arg0_3, arg0_3.nameSearchInput, function()
		arg0_3:updateQuickPanel(true)
	end)
	setActive(arg0_3.detailPanel, true)
	setActive(arg0_3.attrs, true)
	setActive(arg0_3.recordPanel, false)
	setActive(arg0_3.detailEquipmentTpl, false)
	setActive(arg0_3.emptyGridTpl, false)
	setActive(arg0_3.detailPanel, true)

	arg0_3.onSelected = false

	if PLATFORM_CODE == PLATFORM_CHT and LOCK_SP_WEAPON then
		setActive(arg0_3.showRecordBtn, false)
		setActive(arg0_3.showQuickBtn, false)
		setActive(arg0_3.spWeaponSlot, false)

		arg0_3.showRecordBtn = arg0_3.equipments:Find("unload_all_2")
		arg0_3.showQuickBtn = arg0_3.equipments:Find("quickButton_2")

		setActive(arg0_3.showRecordBtn, true)
		setActive(arg0_3.showQuickBtn, true)
	end
end

function var0_0.InitEvent(arg0_6)
	onButton(arg0_6, arg0_6.fashionToggle, function()
		arg0_6:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.FASHION)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.propertyIcons, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_attr.tip,
			onClose = function()
				return
			end
		})
	end)
	onToggle(arg0_6, arg0_6.commonTagToggle, function(arg0_10)
		local var0_10 = arg0_6:GetShipVO().preferenceTag
		local var1_10 = var0_10 == Ship.PREFERENCE_TAG_COMMON

		if var1_10 ~= arg0_10 then
			if var0_10 == Ship.PREFERENCE_TAG_COMMON then
				var1_10 = Ship.PREFERENCE_TAG_NONE
			else
				var1_10 = Ship.PREFERENCE_TAG_COMMON
			end

			arg0_6:emit(ShipMainMediator.ON_TAG, arg0_6:GetShipVO().id, var1_10)
		end
	end, SFX_CONFIRM)
	onToggle(arg0_6, arg0_6.randomFlagToggle, function(arg0_11)
		if arg0_6:GetShipVO():getRandomFlag() ~= arg0_11 then
			arg0_6:emit(ShipMainMediator.CHANGE_RANDOM_FLAG, arg0_6:GetShipVO():GetShipPhantomMark(), arg0_11)
		end
	end, SFX_CONFIRM)
	onButton(arg0_6, arg0_6.lockBtn, function()
		arg0_6:emit(ShipMainMediator.ON_LOCK, {
			arg0_6:GetShipVO().id
		}, arg0_6:GetShipVO().LOCK_STATE_LOCK)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.unlockBtn, function()
		arg0_6:emit(ShipMainMediator.ON_LOCK, {
			arg0_6:GetShipVO().id
		}, arg0_6:GetShipVO().LOCK_STATE_UNLOCK)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.viewBtn, function()
		Input.multiTouchEnabled = true

		arg0_6:emit(ShipViewConst.PAINT_VIEW, true)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.evaluationBtn, function()
		arg0_6:emit(ShipMainMediator.OPEN_EVALUATION, arg0_6:GetShipVO():getGroupId(), arg0_6:GetShipVO():isActivityNpc())
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.profileBtn, function()
		arg0_6:emit(ShipMainMediator.OPEN_SHIPPROFILE, arg0_6:GetShipVO():getGroupId(), arg0_6:GetShipVO():isRemoulded())
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.intimacyTF, function()
		if arg0_6:GetShipVO():isActivityNpc() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("npc_propse_tip"))

			return
		end

		if LOCK_PROPOSE then
			return
		end

		arg0_6:emit(ShipMainMediator.PROPOSE, arg0_6:GetShipVO().id, function()
			return
		end)
	end)
	onToggle(arg0_6, arg0_6.showRecordBtn, function(arg0_19)
		local var0_19, var1_19 = ShipStatus.ShipStatusCheck("onModify", arg0_6:GetShipVO())

		if not var0_19 then
			if arg0_19 then
				pg.TipsMgr.GetInstance():ShowTips(var1_19)
				onNextTick(function()
					triggerToggle(arg0_6.showRecordBtn, false)
				end)
			end

			return
		end

		if arg0_19 then
			arg0_6:displayRecordPanel()

			if arg0_6.isShowQuick then
				triggerToggle(arg0_6.showQuickBtn, false)
			end
		else
			arg0_6:CloseRecordPanel(true)
		end
	end, SFX_PANEL)
	onToggle(arg0_6, arg0_6.showQuickBtn, function(arg0_21)
		local var0_21, var1_21 = ShipStatus.ShipStatusCheck("onModify", arg0_6:GetShipVO())

		if not var0_21 then
			if arg0_21 then
				pg.TipsMgr.GetInstance():ShowTips(var1_21)
				onNextTick(function()
					triggerToggle(arg0_6.showQuickBtn, false)
				end)
			end

			arg0_6:CloseRecordPanel(true)
			arg0_6:CloseQuickPanel()

			return
		end

		if arg0_21 then
			arg0_6:displayQuickPanel()

			if arg0_6.selectedEquip then
				arg0_6:selectedEquipItem(arg0_6.selectedEquip.index)
			else
				arg0_6:quickSelectEmpty()
			end

			if arg0_6.isShowRecord then
				triggerToggle(arg0_6.showRecordBtn, false)
			end
		else
			arg0_6:CloseQuickPanel()
		end
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.equipCodeBtn, function()
		arg0_6:emit(ShipMainMediator.OPEN_EQUIP_CODE, {})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.showECodeShareBtn, function()
		local var0_24 = arg0_6:GetShipVO()

		arg0_6:emit(ShipMainMediator.OPEN_EQUIP_CODE_SHARE, var0_24.id, var0_24:getGroupId())
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.unloadAllBtn, function()
		local var0_25, var1_25 = ShipStatus.ShipStatusCheck("onModify", arg0_6:GetShipVO())

		if not var0_25 then
			pg.TipsMgr.GetInstance():ShowTips(var1_25)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("ship_unequip_all_tip"),
				onYes = function()
					arg0_6:emit(ShipMainMediator.UNEQUIP_FROM_SHIP_ALL, arg0_6:GetShipVO().id)
				end
			})
		end
	end, SFX_PANEL)

	function arg0_6.list.onInitItem(arg0_27)
		ClearTweenItemAlphaAndWhite(arg0_27)
	end

	function arg0_6.list.onReturnItem(arg0_28, arg1_28)
		ClearTweenItemAlphaAndWhite(arg1_28)
	end

	function arg0_6.list.onUpdateItem(arg0_29, arg1_29)
		setActive(findTF(tf(arg1_29), "IconTpl/icon_bg/icon"), false)
		TweenItemAlphaAndWhite(arg1_29)

		if arg0_29 == 0 and not arg0_6.selectedEquip.empty then
			setActive(findTF(tf(arg1_29), "unEquip"), true)
			setActive(findTF(tf(arg1_29), "bg"), false)
			setActive(findTF(tf(arg1_29), "IconTpl"), false)
			onButton(arg0_6, tf(arg1_29), function()
				local var0_30 = arg0_6.selectedEquip.index
				local var1_30 = arg0_6:GetShipVO()
				local var2_30 = var1_30:getEquip(arg0_6.selectedEquip.index):getConfig("name")
				local var3_30 = var1_30:getName()

				arg0_6:emit(ShipMainMediator.UNEQUIP_FROM_SHIP, {
					shipId = var1_30.id,
					pos = var0_30
				})
			end, SFX_PANEL)
		else
			setActive(findTF(tf(arg1_29), "unEquip"), false)
			setActive(findTF(tf(arg1_29), "bg"), true)
			setActive(findTF(tf(arg1_29), "IconTpl"), true)

			local var0_29 = arg0_6.selectedEquip.empty and arg0_29 + 1 or arg0_29
			local var1_29 = arg0_6.fillterEquipments[var0_29]

			if not var1_29 then
				return
			end

			setActive(findTF(tf(arg1_29), "IconTpl/icon_bg/icon"), true)
			updateEquipment(findTF(tf(arg1_29), "IconTpl"), var1_29)

			if var1_29.shipId then
				local var2_29 = getProxy(BayProxy):getShipById(var1_29.shipId)

				setImageSprite(findTF(tf(arg1_29), "IconTpl/icon_bg/equip_flag/Image"), LoadSprite("qicon/" .. var2_29:getPainting()))
			end

			setActive(findTF(tf(arg1_29), "IconTpl/icon_bg/equip_flag"), var1_29.shipId and var1_29.shipId > 0)
			setActive(findTF(tf(arg1_29), "IconTpl/mask"), var1_29.mask)
			onButton(arg0_6, tf(arg1_29), function()
				if var1_29.mask then
					return
				end

				arg0_6:changeEquip(var1_29)
			end, SFX_PANEL)
		end
	end

	onToggle(arg0_6, arg0_6.equiping, function(arg0_32)
		arg0_6.equipingFlag = arg0_32

		if arg0_6.selectedEquip then
			arg0_6:updateQuickPanel(true)
		end
	end, SFX_PANEL)
	triggerToggle(arg0_6.equiping, true)
	onButton(arg0_6, arg0_6.fillter, function()
		arg0_6.indexData = arg0_6.indexData or {}

		if not var0_0.EQUIPMENT_INDEX then
			var0_0.EQUIPMENT_INDEX = Clone(StoreHouseConst.EQUIPMENT_INDEX_COMMON)

			table.removebyvalue(var0_0.EQUIPMENT_INDEX.customPanels.extraIndex.options, IndexConst.EquipmentExtraEquiping)
			table.removebyvalue(var0_0.EQUIPMENT_INDEX.customPanels.extraIndex.names, "index_equip")
		end

		local var0_33 = setmetatable({
			indexDatas = Clone(arg0_6.indexData),
			callback = function(arg0_34)
				arg0_6.indexData.typeIndex = arg0_34.typeIndex
				arg0_6.indexData.equipPropertyIndex = arg0_34.equipPropertyIndex
				arg0_6.indexData.equipPropertyIndex2 = arg0_34.equipPropertyIndex2
				arg0_6.indexData.equipAmmoIndex1 = arg0_34.equipAmmoIndex1
				arg0_6.indexData.equipAmmoIndex2 = arg0_34.equipAmmoIndex2
				arg0_6.indexData.equipCampIndex = arg0_34.equipCampIndex
				arg0_6.indexData.rarityIndex = arg0_34.rarityIndex
				arg0_6.indexData.extraIndex = arg0_34.extraIndex

				local var0_34 = underscore(arg0_6.indexData):chain():keys():all(function(arg0_35)
					return arg0_6.indexData[arg0_35] == var0_0.EQUIPMENT_INDEX.customPanels[arg0_35].options[1]
				end):value()

				setActive(findTF(arg0_6.fillter, "on"), not var0_34)
				setActive(findTF(arg0_6.fillter, "off"), var0_34)
				arg0_6:updateQuickPanel(true)
			end
		}, {
			__index = var0_0.EQUIPMENT_INDEX
		})

		arg0_6:emit(ShipMainMediator.OPEN_EQUIPMENT_INDEX, var0_33)
	end, SFX_PANEL)
end

function var0_0.changeEquip(arg0_36, arg1_36)
	local var0_36 = arg0_36.selectedEquip.index
	local var1_36 = arg0_36:GetShipVO()
	local var2_36 = {
		quickFlag = true,
		type = EquipmentInfoMediator.TYPE_REPLACE,
		equipmentId = arg1_36.id,
		shipId = var1_36.id,
		pos = var0_36,
		oldShipId = arg1_36.shipId,
		oldPos = arg1_36.shipPos
	}

	if var2_36 then
		if PlayerPrefs.GetInt("QUICK_CHANGE_EQUIP", 1) == 1 then
			arg0_36:emit(BaseUI.ON_EQUIPMENT, var2_36)
		else
			local var3_36, var4_36 = var1_36:canEquipAtPos(arg1_36, var0_36)

			if not var3_36 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentInfoLayer_error_canNotEquip", var4_36))

				return
			end

			if arg1_36.shipId then
				local var5_36 = getProxy(BayProxy):getShipById(arg1_36.shipId)
				local var6_36, var7_36 = ShipStatus.ShipStatusCheck("onModify", var5_36)

				if not var6_36 then
					pg.TipsMgr.GetInstance():ShowTips(var7_36)
				else
					arg0_36:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
						notice = GAME.EQUIP_FROM_SHIP,
						data = var2_36
					})
				end
			else
				arg0_36:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
					notice = GAME.EQUIP_TO_SHIP,
					data = var2_36
				})
			end
		end
	end
end

function var0_0.SetShareData(arg0_37, arg1_37)
	arg0_37.shareData = arg1_37
end

function var0_0.GetShipVO(arg0_38)
	if arg0_38.shareData and arg0_38.shareData.shipVO then
		return arg0_38.shareData.shipVO
	end

	return nil
end

function var0_0.OnSelected(arg0_39, arg1_39)
	if arg1_39 then
		arg0_39:OverlayPanel(arg0_39._parentTf, {
			pbList = {
				arg0_39.detailPanel:Find("attrs"),
				arg0_39.detailPanel:Find("equipments"),
				arg0_39.detailPanel:Find("quick_panel")
			},
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		arg0_39:UnOverlayPanel(arg0_39._parentTf, arg0_39.mainPanel)
	end

	arg0_39.onSelected = arg1_39

	if arg0_39.onSelected and arg0_39.selectedEquip then
		local var0_39 = arg0_39.selectedEquip.index

		arg0_39:selectedEquipItem(nil)
		arg0_39:selectedEquipItem(var0_39)
	end
end

function var0_0.UpdateUI(arg0_40)
	setInputText(arg0_40.nameSearchInput, "")

	local var0_40 = arg0_40:GetShipVO()

	arg0_40:UpdateIntimacy(var0_40)
	arg0_40:UpdateDetail(var0_40)
	arg0_40:UpdateEquipments(var0_40)
	arg0_40:UpdateLock()
	arg0_40:UpdatePreferenceTag()

	arg0_40.activeRandomFlag = not var0_40:isActivityNpc()

	setActive(arg0_40.randomFlagToggle, arg0_40.activeRandomFlag)
	triggerToggle(arg0_40.randomFlagToggle, var0_40:getRandomFlag())
end

function var0_0.UpdateIntimacy(arg0_41, arg1_41)
	setActive(arg0_41.intimacyTF, not LOCK_PROPOSE)
	setIntimacyIcon(arg0_41.intimacyTF, arg1_41:getIntimacyIcon())
end

function var0_0.UpdateDetail(arg0_42, arg1_42)
	arg0_42.shipDetailLogicPanel:flush(arg1_42)

	local var0_42 = arg0_42.shipDetailLogicPanel.attrs:Find("icons/hunting_range/bg")

	removeOnButton(var0_42)

	if table.contains(ShipType.SubShipType, arg1_42:getShipType()) then
		onButton(arg0_42, var0_42, function()
			arg0_42:emit(ShipViewConst.DISPLAY_HUNTING_RANGE, true)
		end, SFX_PANEL)
	end

	if not HXSet.isHxSkin() then
		setActive(arg0_42.fashionToggle, arg0_42.shareData:HasFashion())
	else
		setActive(arg0_42.fashionToggle, false)
	end

	arg0_42:UpdateFashionTag()
	setActive(arg0_42.profileBtn, not arg1_42:isActivityNpc())
end

function var0_0.UpdateFashionTag(arg0_44)
	local var0_44 = arg0_44:GetShipVO()

	setActive(arg0_44.fashionTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0_44) > 0)
end

function var0_0.UpdateEquipments(arg0_45, arg1_45)
	arg0_45:clearListener()
	removeAllChildren(arg0_45.equipmentsGrid)

	local var0_45 = arg1_45:getActiveEquipments()

	arg0_45.equipItems = {}

	for iter0_45, iter1_45 in ipairs(arg1_45.equipments) do
		local var1_45 = var0_45[iter0_45]
		local var2_45
		local var3_45 = iter0_45
		local var4_45

		if iter1_45 then
			var2_45 = cloneTplTo(arg0_45.detailEquipmentTpl, arg0_45.equipmentsGrid)
			var4_45 = {
				empty = false,
				tf = var2_45,
				index = var3_45
			}

			table.insert(arg0_45.equipItems, var4_45)
			updateEquipment(var2_45:Find("IconTpl"), iter1_45)
			onButton(arg0_45, var2_45, function()
				if arg0_45.isShowQuick then
					arg0_45:selectedEquipItem(var3_45)
				else
					arg0_45:emit(BaseUI.ON_EQUIPMENT, {
						type = EquipmentInfoMediator.TYPE_SHIP,
						shipId = arg0_45:GetShipVO().id,
						pos = iter0_45
					})
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		else
			var2_45 = cloneTplTo(arg0_45.emptyGridTpl, arg0_45.equipmentsGrid)
			var4_45 = {
				empty = true,
				tf = var2_45,
				index = var3_45
			}

			table.insert(arg0_45.equipItems, var4_45)
			onButton(arg0_45, var2_45, function()
				if arg0_45.isShowQuick then
					arg0_45:selectedEquipItem(var3_45)
				else
					arg0_45:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		end

		local var5_45 = GetOrAddComponent(var2_45, typeof(EventTriggerListener))

		var5_45:AddPointDownFunc(function()
			if var2_45 and not arg0_45.isShowQuick then
				LeanTween.delayedCall(go(var2_45), 1, System.Action(function()
					arg0_45.selectedEquip = var4_45

					triggerToggle(arg0_45.showQuickBtn, true)
				end))
			end
		end)
		var5_45:AddPointUpFunc(function()
			if var2_45 and LeanTween.isTweening(go(var2_45)) then
				LeanTween.cancel(go(var2_45))
			end
		end)
	end

	local var6_45, var7_45 = ShipStatus.ShipStatusCheck("onModify", arg0_45:GetShipVO())

	if not var6_45 then
		triggerToggle(arg0_45.showQuickBtn, false)
	elseif arg1_45.id ~= arg0_45.lastShipVo and arg0_45.isShowQuick then
		onNextTick(function()
			triggerToggle(arg0_45.showQuickBtn, false)
			triggerToggle(arg0_45.showQuickBtn, true)
		end)
	elseif arg0_45.selectedEquip and arg0_45.isShowQuick then
		local var8_45 = arg0_45.selectedEquip.index

		arg0_45:selectedEquipItem(nil)
		arg0_45:selectedEquipItem(var8_45)
	end

	arg0_45.lastShipVo = arg1_45.id

	local var9_45, var10_45 = arg1_45:IsSpweaponUnlock()

	setActive(arg0_45.spWeaponSlot:Find("Lock"), not var9_45)

	local var11_45 = arg1_45:GetSpWeapon()

	setActive(arg0_45.spWeaponSlot:Find("Icon"), var11_45)
	setActive(arg0_45.spWeaponSlot:Find("IconShadow"), var11_45)

	if var11_45 then
		UpdateSpWeaponSlot(arg0_45.spWeaponSlot, var11_45)
	end

	onButton(arg0_45, arg0_45.spWeaponSlot, function()
		if not var9_45 then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var10_45))

			return
		elseif var11_45 then
			arg0_45:emit(BaseUI.ON_SPWEAPON, {
				type = EquipmentInfoMediator.TYPE_SHIP,
				shipId = arg0_45:GetShipVO().id
			})
		else
			arg0_45:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
		end
	end, SFX_PANEL)
end

function var0_0.selectedEquipItem(arg0_53, arg1_53)
	if not arg1_53 then
		if arg0_53.selectedEquip then
			arg0_53.selectedEquip = nil
			arg0_53.showEquipItem = nil
		end
	else
		arg0_53.selectedEquip = arg0_53.equipItems[arg1_53]
	end

	if arg0_53.isShowQuick then
		arg0_53:updateQuickPanel()
	end
end

function var0_0.updateQuickPanel(arg0_54, arg1_54)
	setActive(arg0_54.selectTitle, not arg0_54.selectedEquip)

	if arg0_54.isShowQuick and arg0_54.selectedEquip then
		if arg0_54.selectedEquip ~= arg0_54.showEquipItem or arg1_54 then
			arg0_54.showEquipItem = arg0_54.selectedEquip

			arg0_54:updateQuickEquipments()
		end
	else
		arg0_54:setListCount(0, 0)
		setActive(arg0_54.emptyTitle, false)
	end

	if arg0_54.equipItems then
		for iter0_54 = 1, #arg0_54.equipItems do
			if arg0_54.selectedEquip and arg0_54.selectedEquip.index == iter0_54 then
				setActive(findTF(arg0_54.equipItems[iter0_54].tf, "selected"), true)
			else
				setActive(findTF(arg0_54.equipItems[iter0_54].tf, "selected"), false)
			end
		end
	end
end

function var0_0.updateQuickEquipments(arg0_55)
	arg0_55:setListCount(0, 0)

	arg0_55.fillterEquipments = arg0_55:getEquipments()

	setActive(arg0_55.emptyTitle, false)

	if arg0_55.selectedEquip and arg0_55.selectedEquip.empty then
		setActive(arg0_55.emptyTitle, #arg0_55.fillterEquipments == 0)
	end

	local var0_55 = arg0_55.selectedEquip.empty and 0 or 1

	arg0_55:setListCount(#arg0_55.fillterEquipments + var0_55, 0)
end

function var0_0.setListCount(arg0_56, arg1_56, arg2_56)
	if arg0_56.onSelected and isActive(arg0_56._tf) and arg0_56.list then
		arg0_56.list:SetTotalCount(arg1_56, arg2_56)
	end
end

function var0_0.getEquipments(arg0_57)
	local var0_57 = getProxy(BayProxy)
	local var1_57 = arg0_57:GetShipVO()
	local var2_57 = getProxy(EquipmentProxy)
	local var3_57 = pg.ship_data_template[var1_57.configId]["equip_" .. arg0_57.selectedEquip.index]
	local var4_57 = var1_57:getShipType()
	local var5_57 = var2_57:getEquipmentsByFillter(var4_57, var3_57)
	local var6_57 = getInputText(arg0_57.nameSearchInput)

	if arg0_57.equipingFlag then
		for iter0_57, iter1_57 in ipairs(var0_57:getEquipsInShips(function(arg0_58, arg1_58)
			return var1_57.id ~= arg1_58 and not var1_57:isForbiddenAtPos(arg0_58, arg0_57.selectedEquip.index)
		end)) do
			if var6_57 == "" or iter1_57:IsMatchKey(var6_57) then
				table.insert(var5_57, iter1_57)
			end
		end
	end

	local var7_57 = {}
	local var8_57 = {
		arg0_57.indexData.equipPropertyIndex,
		arg0_57.indexData.equipPropertyIndex2
	}

	for iter2_57, iter3_57 in pairs(var5_57) do
		if arg0_57:checkFillter(iter3_57, var8_57) and (var6_57 == "" or iter3_57:IsMatchKey(var6_57)) then
			table.insert(var7_57, iter3_57)
		end
	end

	_.each(var7_57, function(arg0_59)
		if not var1_57:canEquipAtPos(arg0_59, arg0_57.selectedEquip.index) then
			arg0_59.mask = true
		end
	end)
	table.sort(var7_57, CompareFuncs(var1_0.sortFunc(var1_0.sort[1], false)))

	return var7_57
end

function var0_0.checkFillter(arg0_60, arg1_60, arg2_60)
	return (arg1_60.count > 0 or arg1_60.shipId and arg0_60.equipingFlag) and IndexConst.filterEquipByType(arg1_60, arg0_60.indexData.typeIndex) and IndexConst.filterEquipByProperty(arg1_60, arg2_60) and IndexConst.filterEquipAmmo1(arg1_60, arg0_60.indexData.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(arg1_60, arg0_60.indexData.equipAmmoIndex2) and IndexConst.filterEquipByCamp(arg1_60, arg0_60.indexData.equipCampIndex) and IndexConst.filterEquipByRarity(arg1_60, arg0_60.indexData.rarityIndex) and IndexConst.filterEquipByExtra(arg1_60, arg0_60.indexData.extraIndex)
end

function var0_0.UpdateLock(arg0_61)
	local var0_61 = arg0_61:GetShipVO():GetLockState()

	if var0_61 == arg0_61:GetShipVO().LOCK_STATE_UNLOCK then
		setActive(arg0_61.lockBtn, true)
		setActive(arg0_61.unlockBtn, false)
	elseif var0_61 == arg0_61:GetShipVO().LOCK_STATE_LOCK then
		setActive(arg0_61.lockBtn, false)
		setActive(arg0_61.unlockBtn, true)
	end
end

function var0_0.displayQuickPanel(arg0_62)
	if not arg0_62:GetShipVO() then
		return
	end

	arg0_62.isShowQuick = true

	setActive(arg0_62.attrs, false)
	setActive(arg0_62.quickPanel, true)
	arg0_62:updateQuickPanel()
end

function var0_0.quickSelectEmpty(arg0_63)
	if not arg0_63.selectedEquip and arg0_63.equipItems then
		for iter0_63 = 1, #arg0_63.equipItems do
			if arg0_63.equipItems[iter0_63].empty then
				arg0_63:selectedEquipItem(arg0_63.equipItems[iter0_63].index)

				return
			end
		end
	end
end

function var0_0.Show(arg0_64)
	var0_0.super.Show(arg0_64)
	setActive(arg0_64.randomFlagToggle, arg0_64.activeRandomFlag)
end

function var0_0.Hide(arg0_65)
	var0_0.super.Hide(arg0_65)
	setActive(arg0_65.randomFlagToggle, false)
end

local var3_0 = 0.2

function var0_0.displayRecordPanel(arg0_66)
	if not arg0_66:GetShipVO() then
		return
	end

	arg0_66.isShowRecord = true

	setActive(arg0_66.recordPanel, true)
	setActive(arg0_66.attrs, false)

	for iter0_66, iter1_66 in ipairs(arg0_66.recordBtns) do
		onButton(arg0_66, iter1_66, function()
			arg0_66:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0_66:GetShipVO().id, iter0_66, 1)
		end, SFX_PANEL)
	end

	for iter2_66, iter3_66 in ipairs(arg0_66.equipRecordBtns) do
		onButton(arg0_66, iter3_66, function()
			arg0_66:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0_66:GetShipVO().id, iter2_66, 2)
		end, SFX_PANEL)
	end

	for iter4_66, iter5_66 in ipairs(arg0_66.recordEquipmentsTFs) do
		arg0_66:UpdateRecordEquipments(iter4_66)
	end

	arg0_66:UpdateRecordSpWeapons()
end

function var0_0.CloseRecordPanel(arg0_69, arg1_69)
	if arg1_69 then
		arg0_69.isShowRecord = nil

		setActive(arg0_69.recordPanel, false)

		if not arg0_69.isShowRecord and not arg0_69.isShowQuick then
			setActive(arg0_69.attrs, true)
		end
	else
		triggerToggle(arg0_69.showRecordBtn, false)
	end
end

function var0_0.CloseQuickPanel(arg0_70)
	arg0_70.isShowQuick = nil

	arg0_70:selectedEquipItem(nil)

	arg0_70.showEquipItem = nil

	if arg0_70.list then
		arg0_70:setListCount(0, 0)
	end

	setActive(arg0_70.quickPanel, false)

	if not arg0_70.isShowRecord and not arg0_70.isShowQuick then
		setActive(arg0_70.attrs, true)
	end

	arg0_70:updateQuickPanel()
end

function var0_0.UpdateRecordEquipments(arg0_71, arg1_71)
	local var0_71 = arg0_71.recordEquipmentsTFs[arg1_71]
	local var1_71 = arg0_71:GetShipVO():getEquipmentRecord(arg0_71.shareData.player.id)[arg1_71] or {}

	for iter0_71 = 1, 5 do
		local var2_71 = tonumber(var1_71[iter0_71])
		local var3_71 = var2_71 and var2_71 ~= -1
		local var4_71 = var0_71:Find("equipment_" .. iter0_71)
		local var5_71 = var4_71:Find("empty")
		local var6_71 = var4_71:Find("info")

		setActive(var6_71, var3_71)
		setActive(var5_71, not var3_71)

		if var3_71 then
			local var7_71 = arg0_71.equipmentProxy:getEquipmentById(var2_71)
			local var8_71 = arg0_71:GetShipVO().equipments[iter0_71]
			local var9_71 = not (var8_71 and var8_71.id == var2_71 or false) and (not var7_71 or not (var7_71.count > 0))

			setActive(var6_71:Find("tip"), var9_71)
			updateEquipment(var6_71:Find("IconTpl"), Equipment.New({
				id = var2_71
			}))

			if var9_71 then
				onButton(arg0_71, var6_71, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			end
		else
			removeOnButton(var6_71)
		end
	end
end

function var0_0.UpdateRecordSpWeapons(arg0_73, arg1_73)
	if LOCK_SP_WEAPON then
		return
	end

	local var0_73 = arg0_73:GetShipVO():GetSpWeaponRecord(arg0_73.shareData.player.id)

	table.Foreach(arg0_73.recordBars, function(arg0_74, arg1_74)
		if arg1_73 and arg0_74 ~= arg1_73 then
			return
		end

		local var0_74 = var0_73[arg0_74]
		local var1_74 = arg1_74:Find("SpSlot")
		local var2_74 = arg0_73:GetShipVO():IsSpweaponUnlock()

		setActive(var1_74:Find("Lock"), not var2_74)
		setActive(var1_74:Find("Icon"), var0_74)
		setActive(var1_74:Find("IconShadow"), var0_74)

		if var0_74 then
			UpdateSpWeaponSlot(var1_74, var0_74)

			local var3_74 = arg0_73:GetShipVO():GetSpWeapon()
			local var4_74 = var3_74 and var3_74:GetConfigID() or 0
			local var5_74 = var0_74:GetConfigID() ~= var4_74

			if var5_74 then
				local var6_74 = getProxy(EquipmentProxy):GetSameTypeSpWeapon(var0_74)

				if var6_74 and var6_74:GetConfigID() == var0_74:GetConfigID() then
					var5_74 = false
				end
			end

			setActive(var1_74:Find("Icon/tip"), var5_74)

			if var5_74 then
				onButton(arg0_73, var1_74, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			else
				removeOnButton(var1_74)
			end
		else
			removeOnButton(var1_74)
		end
	end)
end

function var0_0.UpdatePreferenceTag(arg0_76)
	triggerToggle(arg0_76.commonTagToggle, arg0_76:GetShipVO().preferenceTag == Ship.PREFERENCE_TAG_COMMON)
end

function var0_0.DoLeveUpAnim(arg0_77, arg1_77, arg2_77, arg3_77)
	arg0_77.shipDetailLogicPanel:doLeveUpAnim(arg1_77, arg2_77, arg3_77)
end

function var0_0.clearListener(arg0_78)
	if arg0_78.equipItems then
		for iter0_78 = 1, #arg0_78.equipItems do
			local var0_78 = arg0_78.equipItems[iter0_78].tf

			if var0_78 then
				ClearEventTrigger(GetOrAddComponent(go(var0_78), typeof(EventTriggerListener)))
				removeOnButton(go(var0_78))
			end
		end
	end
end

function var0_0.OnDestroy(arg0_79)
	triggerToggle(arg0_79.quickPanel:Find("serachPanel/Image"), true)
	setParent(arg0_79.randomFlagToggle, arg0_79._tf)
	arg0_79:clearListener()
	removeAllChildren(arg0_79.equipmentsGrid)

	if arg0_79.list then
		arg0_79.list:SetTotalCount(0)

		function arg0_79.list.onUpdateItem()
			return
		end
	end

	arg0_79.destroy = true

	if arg0_79.recordPanel then
		if LeanTween.isTweening(go(arg0_79.recordPanel)) then
			LeanTween.cancel(go(arg0_79.recordPanel))
		end

		arg0_79.recordPanel = nil
	end

	arg0_79.shipDetailLogicPanel:clear()
	arg0_79.shipDetailLogicPanel:detach()

	arg0_79.shareData = nil
end

return var0_0
