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
	setActive(arg0_2.randomFlagToggle, true)
	triggerToggle(arg0_2.showQuickBtn, false)
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
	arg0_3.intimacyTF = arg0_3:findTF("intimacy")
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

function var0_0.InitEvent(arg0_5)
	onButton(arg0_5, arg0_5.fashionToggle, function()
		arg0_5:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.FASHION)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.propertyIcons, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_attr.tip,
			onClose = function()
				return
			end
		})
	end)
	onToggle(arg0_5, arg0_5.commonTagToggle, function(arg0_9)
		local var0_9 = arg0_5:GetShipVO().preferenceTag
		local var1_9 = var0_9 == Ship.PREFERENCE_TAG_COMMON

		if var1_9 ~= arg0_9 then
			if var0_9 == Ship.PREFERENCE_TAG_COMMON then
				var1_9 = Ship.PREFERENCE_TAG_NONE
			else
				var1_9 = Ship.PREFERENCE_TAG_COMMON
			end

			arg0_5:emit(ShipMainMediator.ON_TAG, arg0_5:GetShipVO().id, var1_9)
		end
	end, SFX_CONFIRM)
	onToggle(arg0_5, arg0_5.randomFlagToggle, function(arg0_10)
		if arg0_5:GetShipVO():getRandomFlag() ~= arg0_10 then
			arg0_5:emit(ShipMainMediator.CHANGE_RANDOM_FLAG, arg0_5:GetShipVO():GetShipPhantomMark(), arg0_10)
		end
	end, SFX_CONFIRM)
	onButton(arg0_5, arg0_5.lockBtn, function()
		arg0_5:emit(ShipMainMediator.ON_LOCK, {
			arg0_5:GetShipVO().id
		}, arg0_5:GetShipVO().LOCK_STATE_LOCK)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.unlockBtn, function()
		arg0_5:emit(ShipMainMediator.ON_LOCK, {
			arg0_5:GetShipVO().id
		}, arg0_5:GetShipVO().LOCK_STATE_UNLOCK)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.viewBtn, function()
		Input.multiTouchEnabled = true

		arg0_5:emit(ShipViewConst.PAINT_VIEW, true)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.evaluationBtn, function()
		arg0_5:emit(ShipMainMediator.OPEN_EVALUATION, arg0_5:GetShipVO():getGroupId(), arg0_5:GetShipVO():isActivityNpc())
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.profileBtn, function()
		arg0_5:emit(ShipMainMediator.OPEN_SHIPPROFILE, arg0_5:GetShipVO():getGroupId(), arg0_5:GetShipVO():isRemoulded())
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.intimacyTF, function()
		if arg0_5:GetShipVO():isActivityNpc() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("npc_propse_tip"))

			return
		end

		if LOCK_PROPOSE then
			return
		end

		arg0_5:emit(ShipMainMediator.PROPOSE, arg0_5:GetShipVO().id, function()
			return
		end)
	end)
	onToggle(arg0_5, arg0_5.showRecordBtn, function(arg0_18)
		local var0_18, var1_18 = ShipStatus.ShipStatusCheck("onModify", arg0_5:GetShipVO())

		if not var0_18 then
			if arg0_18 then
				pg.TipsMgr.GetInstance():ShowTips(var1_18)
				onNextTick(function()
					triggerToggle(arg0_5.showRecordBtn, false)
				end)
			end

			return
		end

		if arg0_18 then
			arg0_5:displayRecordPanel()

			if arg0_5.isShowQuick then
				triggerToggle(arg0_5.showQuickBtn, false)
			end
		else
			arg0_5:CloseRecordPanel(true)
		end
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.showQuickBtn, function(arg0_20)
		local var0_20, var1_20 = ShipStatus.ShipStatusCheck("onModify", arg0_5:GetShipVO())

		if not var0_20 then
			if arg0_20 then
				pg.TipsMgr.GetInstance():ShowTips(var1_20)
				onNextTick(function()
					triggerToggle(arg0_5.showQuickBtn, false)
				end)
			end

			arg0_5:CloseRecordPanel(true)
			arg0_5:CloseQuickPanel()

			return
		end

		if arg0_20 then
			arg0_5:displayQuickPanel()

			if arg0_5.selectedEquip then
				arg0_5:selectedEquipItem(arg0_5.selectedEquip.index)
			else
				arg0_5:quickSelectEmpty()
			end

			if arg0_5.isShowRecord then
				triggerToggle(arg0_5.showRecordBtn, false)
			end
		else
			arg0_5:CloseQuickPanel()
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.equipCodeBtn, function()
		arg0_5:emit(ShipMainMediator.OPEN_EQUIP_CODE, {})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.showECodeShareBtn, function()
		local var0_23 = arg0_5:GetShipVO()

		arg0_5:emit(ShipMainMediator.OPEN_EQUIP_CODE_SHARE, var0_23.id, var0_23:getGroupId())
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.unloadAllBtn, function()
		local var0_24, var1_24 = ShipStatus.ShipStatusCheck("onModify", arg0_5:GetShipVO())

		if not var0_24 then
			pg.TipsMgr.GetInstance():ShowTips(var1_24)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("ship_unequip_all_tip"),
				onYes = function()
					arg0_5:emit(ShipMainMediator.UNEQUIP_FROM_SHIP_ALL, arg0_5:GetShipVO().id)
				end
			})
		end
	end, SFX_PANEL)

	function arg0_5.list.onInitItem(arg0_26)
		ClearTweenItemAlphaAndWhite(arg0_26)
	end

	function arg0_5.list.onReturnItem(arg0_27, arg1_27)
		ClearTweenItemAlphaAndWhite(arg1_27)
	end

	function arg0_5.list.onUpdateItem(arg0_28, arg1_28)
		setActive(findTF(tf(arg1_28), "IconTpl/icon_bg/icon"), false)
		TweenItemAlphaAndWhite(arg1_28)

		if arg0_28 == 0 and not arg0_5.selectedEquip.empty then
			setActive(findTF(tf(arg1_28), "unEquip"), true)
			setActive(findTF(tf(arg1_28), "bg"), false)
			setActive(findTF(tf(arg1_28), "IconTpl"), false)
			onButton(arg0_5, tf(arg1_28), function()
				local var0_29 = arg0_5.selectedEquip.index
				local var1_29 = arg0_5:GetShipVO()
				local var2_29 = var1_29:getEquip(arg0_5.selectedEquip.index):getConfig("name")
				local var3_29 = var1_29:getName()

				arg0_5:emit(ShipMainMediator.UNEQUIP_FROM_SHIP, {
					shipId = var1_29.id,
					pos = var0_29
				})
			end, SFX_PANEL)
		else
			setActive(findTF(tf(arg1_28), "unEquip"), false)
			setActive(findTF(tf(arg1_28), "bg"), true)
			setActive(findTF(tf(arg1_28), "IconTpl"), true)

			local var0_28 = arg0_5.selectedEquip.empty and arg0_28 + 1 or arg0_28
			local var1_28 = arg0_5.fillterEquipments[var0_28]

			if not var1_28 then
				return
			end

			setActive(findTF(tf(arg1_28), "IconTpl/icon_bg/icon"), true)
			updateEquipment(arg0_5:findTF("IconTpl", tf(arg1_28)), var1_28)

			if var1_28.shipId then
				local var2_28 = getProxy(BayProxy):getShipById(var1_28.shipId)

				setImageSprite(findTF(tf(arg1_28), "IconTpl/icon_bg/equip_flag/Image"), LoadSprite("qicon/" .. var2_28:getPainting()))
			end

			setActive(findTF(tf(arg1_28), "IconTpl/icon_bg/equip_flag"), var1_28.shipId and var1_28.shipId > 0)
			setActive(findTF(tf(arg1_28), "IconTpl/mask"), var1_28.mask)
			onButton(arg0_5, tf(arg1_28), function()
				if var1_28.mask then
					return
				end

				arg0_5:changeEquip(var1_28)
			end, SFX_PANEL)
		end
	end

	onToggle(arg0_5, arg0_5.equiping, function(arg0_31)
		arg0_5.equipingFlag = arg0_31

		if arg0_5.selectedEquip then
			arg0_5:updateQuickPanel(true)
		end
	end, SFX_PANEL)
	triggerToggle(arg0_5.equiping, true)
	onButton(arg0_5, arg0_5.fillter, function()
		arg0_5.indexData = arg0_5.indexData or {}

		if not var0_0.EQUIPMENT_INDEX then
			var0_0.EQUIPMENT_INDEX = Clone(StoreHouseConst.EQUIPMENT_INDEX_COMMON)

			table.removebyvalue(var0_0.EQUIPMENT_INDEX.customPanels.extraIndex.options, IndexConst.EquipmentExtraEquiping)
			table.removebyvalue(var0_0.EQUIPMENT_INDEX.customPanels.extraIndex.names, "index_equip")
		end

		local var0_32 = setmetatable({
			indexDatas = Clone(arg0_5.indexData),
			callback = function(arg0_33)
				arg0_5.indexData.typeIndex = arg0_33.typeIndex
				arg0_5.indexData.equipPropertyIndex = arg0_33.equipPropertyIndex
				arg0_5.indexData.equipPropertyIndex2 = arg0_33.equipPropertyIndex2
				arg0_5.indexData.equipAmmoIndex1 = arg0_33.equipAmmoIndex1
				arg0_5.indexData.equipAmmoIndex2 = arg0_33.equipAmmoIndex2
				arg0_5.indexData.equipCampIndex = arg0_33.equipCampIndex
				arg0_5.indexData.rarityIndex = arg0_33.rarityIndex
				arg0_5.indexData.extraIndex = arg0_33.extraIndex

				local var0_33 = underscore(arg0_5.indexData):chain():keys():all(function(arg0_34)
					return arg0_5.indexData[arg0_34] == var0_0.EQUIPMENT_INDEX.customPanels[arg0_34].options[1]
				end):value()

				setActive(findTF(arg0_5.fillter, "on"), not var0_33)
				setActive(findTF(arg0_5.fillter, "off"), var0_33)
				arg0_5:updateQuickPanel(true)
			end
		}, {
			__index = var0_0.EQUIPMENT_INDEX
		})

		arg0_5:emit(ShipMainMediator.OPEN_EQUIPMENT_INDEX, var0_32)
	end, SFX_PANEL)
end

function var0_0.changeEquip(arg0_35, arg1_35)
	local var0_35 = arg0_35.selectedEquip.index
	local var1_35 = arg0_35:GetShipVO()
	local var2_35 = {
		quickFlag = true,
		type = EquipmentInfoMediator.TYPE_REPLACE,
		equipmentId = arg1_35.id,
		shipId = var1_35.id,
		pos = var0_35,
		oldShipId = arg1_35.shipId,
		oldPos = arg1_35.shipPos
	}

	if var2_35 then
		if PlayerPrefs.GetInt("QUICK_CHANGE_EQUIP", 1) == 1 then
			arg0_35:emit(BaseUI.ON_EQUIPMENT, var2_35)
		else
			local var3_35, var4_35 = var1_35:canEquipAtPos(arg1_35, var0_35)

			if not var3_35 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentInfoLayer_error_canNotEquip", var4_35))

				return
			end

			if arg1_35.shipId then
				local var5_35 = getProxy(BayProxy):getShipById(arg1_35.shipId)
				local var6_35, var7_35 = ShipStatus.ShipStatusCheck("onModify", var5_35)

				if not var6_35 then
					pg.TipsMgr.GetInstance():ShowTips(var7_35)
				else
					arg0_35:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
						notice = GAME.EQUIP_FROM_SHIP,
						data = var2_35
					})
				end
			else
				arg0_35:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
					notice = GAME.EQUIP_TO_SHIP,
					data = var2_35
				})
			end
		end
	end
end

function var0_0.SetShareData(arg0_36, arg1_36)
	arg0_36.shareData = arg1_36
end

function var0_0.GetShipVO(arg0_37)
	if arg0_37.shareData and arg0_37.shareData.shipVO then
		return arg0_37.shareData.shipVO
	end

	return nil
end

function var0_0.OnSelected(arg0_38, arg1_38)
	if arg1_38 then
		arg0_38:OverlayPanel(arg0_38._parentTf, {
			pbList = {
				arg0_38.detailPanel:Find("attrs"),
				arg0_38.detailPanel:Find("equipments"),
				arg0_38.detailPanel:Find("quick_panel")
			},
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		arg0_38:UnOverlayPanel(arg0_38._parentTf, arg0_38.mainPanel)
	end

	arg0_38.onSelected = arg1_38

	if arg0_38.onSelected and arg0_38.selectedEquip then
		local var0_38 = arg0_38.selectedEquip.index

		arg0_38:selectedEquipItem(nil)
		arg0_38:selectedEquipItem(var0_38)
	end
end

function var0_0.UpdateUI(arg0_39)
	local var0_39 = arg0_39:GetShipVO()

	arg0_39:UpdateIntimacy(var0_39)
	arg0_39:UpdateDetail(var0_39)
	arg0_39:UpdateEquipments(var0_39)
	arg0_39:UpdateLock()
	arg0_39:UpdatePreferenceTag()
	triggerToggle(arg0_39.randomFlagToggle, arg0_39:GetShipVO():getRandomFlag())
end

function var0_0.UpdateIntimacy(arg0_40, arg1_40)
	setActive(arg0_40.intimacyTF, not LOCK_PROPOSE)
	setIntimacyIcon(arg0_40.intimacyTF, arg1_40:getIntimacyIcon())
end

function var0_0.UpdateDetail(arg0_41, arg1_41)
	arg0_41.shipDetailLogicPanel:flush(arg1_41)

	local var0_41 = arg0_41.shipDetailLogicPanel.attrs:Find("icons/hunting_range/bg")

	removeOnButton(var0_41)

	if table.contains(TeamType.SubShipType, arg1_41:getShipType()) then
		onButton(arg0_41, var0_41, function()
			arg0_41:emit(ShipViewConst.DISPLAY_HUNTING_RANGE, true)
		end, SFX_PANEL)
	end

	if not HXSet.isHxSkin() then
		setActive(arg0_41.fashionToggle, arg0_41.shareData:HasFashion())
	else
		setActive(arg0_41.fashionToggle, false)
	end

	arg0_41:UpdateFashionTag()
	setActive(arg0_41.profileBtn, not arg1_41:isActivityNpc())
end

function var0_0.UpdateFashionTag(arg0_43)
	local var0_43 = arg0_43:GetShipVO()

	setActive(arg0_43.fashionTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0_43) > 0)
end

function var0_0.UpdateEquipments(arg0_44, arg1_44)
	arg0_44:clearListener()
	removeAllChildren(arg0_44.equipmentsGrid)

	local var0_44 = arg1_44:getActiveEquipments()

	arg0_44.equipItems = {}

	for iter0_44, iter1_44 in ipairs(arg1_44.equipments) do
		local var1_44 = var0_44[iter0_44]
		local var2_44
		local var3_44 = iter0_44
		local var4_44

		if iter1_44 then
			var2_44 = cloneTplTo(arg0_44.detailEquipmentTpl, arg0_44.equipmentsGrid)
			var4_44 = {
				empty = false,
				tf = var2_44,
				index = var3_44
			}

			table.insert(arg0_44.equipItems, var4_44)
			updateEquipment(arg0_44:findTF("IconTpl", var2_44), iter1_44)
			onButton(arg0_44, var2_44, function()
				if arg0_44.isShowQuick then
					arg0_44:selectedEquipItem(var3_44)
				else
					arg0_44:emit(BaseUI.ON_EQUIPMENT, {
						type = EquipmentInfoMediator.TYPE_SHIP,
						shipId = arg0_44:GetShipVO().id,
						pos = iter0_44
					})
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		else
			var2_44 = cloneTplTo(arg0_44.emptyGridTpl, arg0_44.equipmentsGrid)
			var4_44 = {
				empty = true,
				tf = var2_44,
				index = var3_44
			}

			table.insert(arg0_44.equipItems, var4_44)
			onButton(arg0_44, var2_44, function()
				if arg0_44.isShowQuick then
					arg0_44:selectedEquipItem(var3_44)
				else
					arg0_44:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		end

		local var5_44 = GetOrAddComponent(var2_44, typeof(EventTriggerListener))

		var5_44:AddPointDownFunc(function()
			if var2_44 and not arg0_44.isShowQuick then
				LeanTween.delayedCall(go(var2_44), 1, System.Action(function()
					arg0_44.selectedEquip = var4_44

					triggerToggle(arg0_44.showQuickBtn, true)
				end))
			end
		end)
		var5_44:AddPointUpFunc(function()
			if var2_44 and LeanTween.isTweening(go(var2_44)) then
				LeanTween.cancel(go(var2_44))
			end
		end)
	end

	local var6_44, var7_44 = ShipStatus.ShipStatusCheck("onModify", arg0_44:GetShipVO())

	if not var6_44 then
		triggerToggle(arg0_44.showQuickBtn, false)
	elseif arg1_44.id ~= arg0_44.lastShipVo and arg0_44.isShowQuick then
		onNextTick(function()
			triggerToggle(arg0_44.showQuickBtn, false)
			triggerToggle(arg0_44.showQuickBtn, true)
		end)
	elseif arg0_44.selectedEquip and arg0_44.isShowQuick then
		local var8_44 = arg0_44.selectedEquip.index

		arg0_44:selectedEquipItem(nil)
		arg0_44:selectedEquipItem(var8_44)
	end

	arg0_44.lastShipVo = arg1_44.id

	local var9_44, var10_44 = arg1_44:IsSpweaponUnlock()

	setActive(arg0_44.spWeaponSlot:Find("Lock"), not var9_44)

	local var11_44 = arg1_44:GetSpWeapon()

	setActive(arg0_44.spWeaponSlot:Find("Icon"), var11_44)
	setActive(arg0_44.spWeaponSlot:Find("IconShadow"), var11_44)

	if var11_44 then
		UpdateSpWeaponSlot(arg0_44.spWeaponSlot, var11_44)
	end

	onButton(arg0_44, arg0_44.spWeaponSlot, function()
		if not var9_44 then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var10_44))

			return
		elseif var11_44 then
			arg0_44:emit(BaseUI.ON_SPWEAPON, {
				type = EquipmentInfoMediator.TYPE_SHIP,
				shipId = arg0_44:GetShipVO().id
			})
		else
			arg0_44:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
		end
	end, SFX_PANEL)
end

function var0_0.selectedEquipItem(arg0_52, arg1_52)
	if not arg1_52 then
		if arg0_52.selectedEquip then
			arg0_52.selectedEquip = nil
			arg0_52.showEquipItem = nil
		end
	else
		arg0_52.selectedEquip = arg0_52.equipItems[arg1_52]
	end

	if arg0_52.isShowQuick then
		arg0_52:updateQuickPanel()
	end
end

function var0_0.updateQuickPanel(arg0_53, arg1_53)
	setActive(arg0_53.selectTitle, not arg0_53.selectedEquip)

	if arg0_53.isShowQuick and arg0_53.selectedEquip then
		if arg0_53.selectedEquip ~= arg0_53.showEquipItem or arg1_53 then
			arg0_53.showEquipItem = arg0_53.selectedEquip

			arg0_53:updateQuickEquipments()
		end
	else
		arg0_53:setListCount(0, 0)
		setActive(arg0_53.emptyTitle, false)
	end

	if arg0_53.equipItems then
		for iter0_53 = 1, #arg0_53.equipItems do
			if arg0_53.selectedEquip and arg0_53.selectedEquip.index == iter0_53 then
				setActive(findTF(arg0_53.equipItems[iter0_53].tf, "selected"), true)
			else
				setActive(findTF(arg0_53.equipItems[iter0_53].tf, "selected"), false)
			end
		end
	end
end

function var0_0.updateQuickEquipments(arg0_54)
	arg0_54:setListCount(0, 0)

	arg0_54.fillterEquipments = arg0_54:getEquipments()

	setActive(arg0_54.emptyTitle, false)

	if arg0_54.selectedEquip and arg0_54.selectedEquip.empty then
		setActive(arg0_54.emptyTitle, #arg0_54.fillterEquipments == 0)
	end

	local var0_54 = arg0_54.selectedEquip.empty and 0 or 1

	arg0_54:setListCount(#arg0_54.fillterEquipments + var0_54, 0)
end

function var0_0.setListCount(arg0_55, arg1_55, arg2_55)
	if arg0_55.onSelected and isActive(arg0_55._tf) and arg0_55.list then
		arg0_55.list:SetTotalCount(arg1_55, arg2_55)
	end
end

function var0_0.getEquipments(arg0_56)
	local var0_56 = getProxy(BayProxy)
	local var1_56 = arg0_56:GetShipVO()
	local var2_56 = getProxy(EquipmentProxy)
	local var3_56 = pg.ship_data_template[var1_56.configId]["equip_" .. arg0_56.selectedEquip.index]
	local var4_56 = var1_56:getShipType()
	local var5_56 = var2_56:getEquipmentsByFillter(var4_56, var3_56)

	if arg0_56.equipingFlag then
		for iter0_56, iter1_56 in ipairs(var0_56:getEquipsInShips(function(arg0_57, arg1_57)
			return var1_56.id ~= arg1_57 and not var1_56:isForbiddenAtPos(arg0_57, arg0_56.selectedEquip.index)
		end)) do
			table.insert(var5_56, iter1_56)
		end
	end

	local var6_56 = {}
	local var7_56 = {
		arg0_56.indexData.equipPropertyIndex,
		arg0_56.indexData.equipPropertyIndex2
	}

	for iter2_56, iter3_56 in pairs(var5_56) do
		if arg0_56:checkFillter(iter3_56, var7_56) then
			table.insert(var6_56, iter3_56)
		end
	end

	_.each(var6_56, function(arg0_58)
		if not var1_56:canEquipAtPos(arg0_58, arg0_56.selectedEquip.index) then
			arg0_58.mask = true
		end
	end)
	table.sort(var6_56, CompareFuncs(var1_0.sortFunc(var1_0.sort[1], false)))

	return var6_56
end

function var0_0.checkFillter(arg0_59, arg1_59, arg2_59)
	return (arg1_59.count > 0 or arg1_59.shipId and arg0_59.equipingFlag) and IndexConst.filterEquipByType(arg1_59, arg0_59.indexData.typeIndex) and IndexConst.filterEquipByProperty(arg1_59, arg2_59) and IndexConst.filterEquipAmmo1(arg1_59, arg0_59.indexData.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(arg1_59, arg0_59.indexData.equipAmmoIndex2) and IndexConst.filterEquipByCamp(arg1_59, arg0_59.indexData.equipCampIndex) and IndexConst.filterEquipByRarity(arg1_59, arg0_59.indexData.rarityIndex) and IndexConst.filterEquipByExtra(arg1_59, arg0_59.indexData.extraIndex)
end

function var0_0.UpdateLock(arg0_60)
	local var0_60 = arg0_60:GetShipVO():GetLockState()

	if var0_60 == arg0_60:GetShipVO().LOCK_STATE_UNLOCK then
		setActive(arg0_60.lockBtn, true)
		setActive(arg0_60.unlockBtn, false)
	elseif var0_60 == arg0_60:GetShipVO().LOCK_STATE_LOCK then
		setActive(arg0_60.lockBtn, false)
		setActive(arg0_60.unlockBtn, true)
	end
end

function var0_0.displayQuickPanel(arg0_61)
	if not arg0_61:GetShipVO() then
		return
	end

	arg0_61.isShowQuick = true

	setActive(arg0_61.attrs, false)
	setActive(arg0_61.quickPanel, true)
	arg0_61:updateQuickPanel()
end

function var0_0.quickSelectEmpty(arg0_62)
	if not arg0_62.selectedEquip and arg0_62.equipItems then
		for iter0_62 = 1, #arg0_62.equipItems do
			if arg0_62.equipItems[iter0_62].empty then
				arg0_62:selectedEquipItem(arg0_62.equipItems[iter0_62].index)

				return
			end
		end
	end
end

function var0_0.Show(arg0_63)
	var0_0.super.Show(arg0_63)
	setActive(arg0_63.randomFlagToggle, true)
end

function var0_0.Hide(arg0_64)
	var0_0.super.Hide(arg0_64)
	setActive(arg0_64.randomFlagToggle, false)
end

local var3_0 = 0.2

function var0_0.displayRecordPanel(arg0_65)
	if not arg0_65:GetShipVO() then
		return
	end

	arg0_65.isShowRecord = true

	setActive(arg0_65.recordPanel, true)
	setActive(arg0_65.attrs, false)

	for iter0_65, iter1_65 in ipairs(arg0_65.recordBtns) do
		onButton(arg0_65, iter1_65, function()
			arg0_65:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0_65:GetShipVO().id, iter0_65, 1)
		end, SFX_PANEL)
	end

	for iter2_65, iter3_65 in ipairs(arg0_65.equipRecordBtns) do
		onButton(arg0_65, iter3_65, function()
			arg0_65:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0_65:GetShipVO().id, iter2_65, 2)
		end, SFX_PANEL)
	end

	for iter4_65, iter5_65 in ipairs(arg0_65.recordEquipmentsTFs) do
		arg0_65:UpdateRecordEquipments(iter4_65)
	end

	arg0_65:UpdateRecordSpWeapons()
end

function var0_0.CloseRecordPanel(arg0_68, arg1_68)
	if arg1_68 then
		arg0_68.isShowRecord = nil

		setActive(arg0_68.recordPanel, false)

		if not arg0_68.isShowRecord and not arg0_68.isShowQuick then
			setActive(arg0_68.attrs, true)
		end
	else
		triggerToggle(arg0_68.showRecordBtn, false)
	end
end

function var0_0.CloseQuickPanel(arg0_69)
	arg0_69.isShowQuick = nil

	arg0_69:selectedEquipItem(nil)

	arg0_69.showEquipItem = nil

	if arg0_69.list then
		arg0_69:setListCount(0, 0)
	end

	setActive(arg0_69.quickPanel, false)

	if not arg0_69.isShowRecord and not arg0_69.isShowQuick then
		setActive(arg0_69.attrs, true)
	end

	arg0_69:updateQuickPanel()
end

function var0_0.UpdateRecordEquipments(arg0_70, arg1_70)
	local var0_70 = arg0_70.recordEquipmentsTFs[arg1_70]
	local var1_70 = arg0_70:GetShipVO():getEquipmentRecord(arg0_70.shareData.player.id)[arg1_70] or {}

	for iter0_70 = 1, 5 do
		local var2_70 = tonumber(var1_70[iter0_70])
		local var3_70 = var2_70 and var2_70 ~= -1
		local var4_70 = var0_70:Find("equipment_" .. iter0_70)
		local var5_70 = var4_70:Find("empty")
		local var6_70 = var4_70:Find("info")

		setActive(var6_70, var3_70)
		setActive(var5_70, not var3_70)

		if var3_70 then
			local var7_70 = arg0_70.equipmentProxy:getEquipmentById(var2_70)
			local var8_70 = arg0_70:GetShipVO().equipments[iter0_70]
			local var9_70 = not (var8_70 and var8_70.id == var2_70 or false) and (not var7_70 or not (var7_70.count > 0))

			setActive(var6_70:Find("tip"), var9_70)
			updateEquipment(arg0_70:findTF("IconTpl", var6_70), Equipment.New({
				id = var2_70
			}))

			if var9_70 then
				onButton(arg0_70, var6_70, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			end
		else
			removeOnButton(var6_70)
		end
	end
end

function var0_0.UpdateRecordSpWeapons(arg0_72, arg1_72)
	if LOCK_SP_WEAPON then
		return
	end

	local var0_72 = arg0_72:GetShipVO():GetSpWeaponRecord(arg0_72.shareData.player.id)

	table.Foreach(arg0_72.recordBars, function(arg0_73, arg1_73)
		if arg1_72 and arg0_73 ~= arg1_72 then
			return
		end

		local var0_73 = var0_72[arg0_73]
		local var1_73 = arg1_73:Find("SpSlot")
		local var2_73 = arg0_72:GetShipVO():IsSpweaponUnlock()

		setActive(var1_73:Find("Lock"), not var2_73)
		setActive(var1_73:Find("Icon"), var0_73)
		setActive(var1_73:Find("IconShadow"), var0_73)

		if var0_73 then
			UpdateSpWeaponSlot(var1_73, var0_73)

			local var3_73 = arg0_72:GetShipVO():GetSpWeapon()
			local var4_73 = var3_73 and var3_73:GetConfigID() or 0
			local var5_73 = var0_73:GetConfigID() ~= var4_73

			if var5_73 then
				local var6_73 = getProxy(EquipmentProxy):GetSameTypeSpWeapon(var0_73)

				if var6_73 and var6_73:GetConfigID() == var0_73:GetConfigID() then
					var5_73 = false
				end
			end

			setActive(var1_73:Find("Icon/tip"), var5_73)

			if var5_73 then
				onButton(arg0_72, var1_73, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			else
				removeOnButton(var1_73)
			end
		else
			removeOnButton(var1_73)
		end
	end)
end

function var0_0.UpdatePreferenceTag(arg0_75)
	triggerToggle(arg0_75.commonTagToggle, arg0_75:GetShipVO().preferenceTag == Ship.PREFERENCE_TAG_COMMON)
end

function var0_0.DoLeveUpAnim(arg0_76, arg1_76, arg2_76, arg3_76)
	arg0_76.shipDetailLogicPanel:doLeveUpAnim(arg1_76, arg2_76, arg3_76)
end

function var0_0.clearListener(arg0_77)
	if arg0_77.equipItems then
		for iter0_77 = 1, #arg0_77.equipItems do
			local var0_77 = arg0_77.equipItems[iter0_77].tf

			if var0_77 then
				ClearEventTrigger(GetOrAddComponent(go(var0_77), typeof(EventTriggerListener)))
				removeOnButton(go(var0_77))
			end
		end
	end
end

function var0_0.OnDestroy(arg0_78)
	setParent(arg0_78.randomFlagToggle, arg0_78._tf)
	arg0_78:clearListener()
	removeAllChildren(arg0_78.equipmentsGrid)

	if arg0_78.list then
		arg0_78.list:SetTotalCount(0)

		function arg0_78.list.onUpdateItem()
			return
		end
	end

	arg0_78.destroy = true

	if arg0_78.recordPanel then
		if LeanTween.isTweening(go(arg0_78.recordPanel)) then
			LeanTween.cancel(go(arg0_78.recordPanel))
		end

		arg0_78.recordPanel = nil
	end

	arg0_78.shipDetailLogicPanel:clear()
	arg0_78.shipDetailLogicPanel:detach()

	arg0_78.shareData = nil
end

return var0_0
