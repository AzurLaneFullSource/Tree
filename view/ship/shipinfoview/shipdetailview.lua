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
	end)
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
	onToggle(arg0_5, arg0_5.showRecordBtn, function(arg0_17)
		local var0_17, var1_17 = ShipStatus.ShipStatusCheck("onModify", arg0_5:GetShipVO())

		if not var0_17 then
			if arg0_17 then
				pg.TipsMgr.GetInstance():ShowTips(var1_17)
				onNextTick(function()
					triggerToggle(arg0_5.showRecordBtn, false)
				end)
			end

			return
		end

		if arg0_17 then
			arg0_5:displayRecordPanel()

			if arg0_5.isShowQuick then
				triggerToggle(arg0_5.showQuickBtn, false)
			end
		else
			arg0_5:CloseRecordPanel(true)
		end
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.showQuickBtn, function(arg0_19)
		local var0_19, var1_19 = ShipStatus.ShipStatusCheck("onModify", arg0_5:GetShipVO())

		if not var0_19 then
			if arg0_19 then
				pg.TipsMgr.GetInstance():ShowTips(var1_19)
				onNextTick(function()
					triggerToggle(arg0_5.showQuickBtn, false)
				end)
			end

			arg0_5:CloseRecordPanel(true)
			arg0_5:CloseQuickPanel()

			return
		end

		if arg0_19 then
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
		local var0_22 = arg0_5:GetShipVO()

		arg0_5:emit(ShipMainMediator.OPEN_EQUIP_CODE_SHARE, var0_22.id, var0_22:getGroupId())
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.unloadAllBtn, function()
		local var0_23, var1_23 = ShipStatus.ShipStatusCheck("onModify", arg0_5:GetShipVO())

		if not var0_23 then
			pg.TipsMgr.GetInstance():ShowTips(var1_23)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("ship_unequip_all_tip"),
				onYes = function()
					arg0_5:emit(ShipMainMediator.UNEQUIP_FROM_SHIP_ALL, arg0_5:GetShipVO().id)
				end
			})
		end
	end, SFX_PANEL)

	function arg0_5.list.onInitItem(arg0_25)
		ClearTweenItemAlphaAndWhite(arg0_25)
	end

	function arg0_5.list.onReturnItem(arg0_26, arg1_26)
		ClearTweenItemAlphaAndWhite(arg1_26)
	end

	function arg0_5.list.onUpdateItem(arg0_27, arg1_27)
		setActive(findTF(tf(arg1_27), "IconTpl/icon_bg/icon"), false)
		TweenItemAlphaAndWhite(arg1_27)

		if arg0_27 == 0 and not arg0_5.selectedEquip.empty then
			setActive(findTF(tf(arg1_27), "unEquip"), true)
			setActive(findTF(tf(arg1_27), "bg"), false)
			setActive(findTF(tf(arg1_27), "IconTpl"), false)
			onButton(arg0_5, tf(arg1_27), function()
				local var0_28 = arg0_5.selectedEquip.index
				local var1_28 = arg0_5:GetShipVO()
				local var2_28 = var1_28:getEquip(arg0_5.selectedEquip.index):getConfig("name")
				local var3_28 = var1_28:getName()

				arg0_5:emit(ShipMainMediator.UNEQUIP_FROM_SHIP, {
					shipId = var1_28.id,
					pos = var0_28
				})
			end, SFX_PANEL)
		else
			setActive(findTF(tf(arg1_27), "unEquip"), false)
			setActive(findTF(tf(arg1_27), "bg"), true)
			setActive(findTF(tf(arg1_27), "IconTpl"), true)

			local var0_27 = arg0_5.selectedEquip.empty and arg0_27 + 1 or arg0_27
			local var1_27 = arg0_5.fillterEquipments[var0_27]

			if not var1_27 then
				return
			end

			setActive(findTF(tf(arg1_27), "IconTpl/icon_bg/icon"), true)
			updateEquipment(arg0_5:findTF("IconTpl", tf(arg1_27)), var1_27)

			if var1_27.shipId then
				local var2_27 = getProxy(BayProxy):getShipById(var1_27.shipId)

				setImageSprite(findTF(tf(arg1_27), "IconTpl/icon_bg/equip_flag/Image"), LoadSprite("qicon/" .. var2_27:getPainting()))
			end

			setActive(findTF(tf(arg1_27), "IconTpl/icon_bg/equip_flag"), var1_27.shipId and var1_27.shipId > 0)
			setActive(findTF(tf(arg1_27), "IconTpl/mask"), var1_27.mask)
			onButton(arg0_5, tf(arg1_27), function()
				if var1_27.mask then
					return
				end

				arg0_5:changeEquip(var1_27)
			end, SFX_PANEL)
		end
	end

	onToggle(arg0_5, arg0_5.equiping, function(arg0_30)
		arg0_5.equipingFlag = arg0_30

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

		local var0_31 = setmetatable({
			indexDatas = Clone(arg0_5.indexData),
			callback = function(arg0_32)
				arg0_5.indexData.typeIndex = arg0_32.typeIndex
				arg0_5.indexData.equipPropertyIndex = arg0_32.equipPropertyIndex
				arg0_5.indexData.equipPropertyIndex2 = arg0_32.equipPropertyIndex2
				arg0_5.indexData.equipAmmoIndex1 = arg0_32.equipAmmoIndex1
				arg0_5.indexData.equipAmmoIndex2 = arg0_32.equipAmmoIndex2
				arg0_5.indexData.equipCampIndex = arg0_32.equipCampIndex
				arg0_5.indexData.rarityIndex = arg0_32.rarityIndex
				arg0_5.indexData.extraIndex = arg0_32.extraIndex

				local var0_32 = underscore(arg0_5.indexData):chain():keys():all(function(arg0_33)
					return arg0_5.indexData[arg0_33] == var0_0.EQUIPMENT_INDEX.customPanels[arg0_33].options[1]
				end):value()

				setActive(findTF(arg0_5.fillter, "on"), not var0_32)
				setActive(findTF(arg0_5.fillter, "off"), var0_32)
				arg0_5:updateQuickPanel(true)
			end
		}, {
			__index = var0_0.EQUIPMENT_INDEX
		})

		arg0_5:emit(ShipMainMediator.OPEN_EQUIPMENT_INDEX, var0_31)
	end, SFX_PANEL)
end

function var0_0.changeEquip(arg0_34, arg1_34)
	local var0_34 = arg0_34.selectedEquip.index
	local var1_34 = arg0_34:GetShipVO()
	local var2_34 = {
		quickFlag = true,
		type = EquipmentInfoMediator.TYPE_REPLACE,
		equipmentId = arg1_34.id,
		shipId = var1_34.id,
		pos = var0_34,
		oldShipId = arg1_34.shipId,
		oldPos = arg1_34.shipPos
	}

	if var2_34 then
		if PlayerPrefs.GetInt("QUICK_CHANGE_EQUIP", 1) == 1 then
			arg0_34:emit(BaseUI.ON_EQUIPMENT, var2_34)
		else
			local var3_34, var4_34 = var1_34:canEquipAtPos(arg1_34, var0_34)

			if not var3_34 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentInfoLayer_error_canNotEquip", var4_34))

				return
			end

			if arg1_34.shipId then
				local var5_34 = getProxy(BayProxy):getShipById(arg1_34.shipId)
				local var6_34, var7_34 = ShipStatus.ShipStatusCheck("onModify", var5_34)

				if not var6_34 then
					pg.TipsMgr.GetInstance():ShowTips(var7_34)
				else
					arg0_34:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
						notice = GAME.EQUIP_FROM_SHIP,
						data = var2_34
					})
				end
			else
				arg0_34:emit(ShipMainMediator.EQUIP_CHANGE_NOTICE, {
					notice = GAME.EQUIP_TO_SHIP,
					data = var2_34
				})
			end
		end
	end
end

function var0_0.SetShareData(arg0_35, arg1_35)
	arg0_35.shareData = arg1_35
end

function var0_0.GetShipVO(arg0_36)
	if arg0_36.shareData and arg0_36.shareData.shipVO then
		return arg0_36.shareData.shipVO
	end

	return nil
end

function var0_0.OnSelected(arg0_37, arg1_37)
	local var0_37 = pg.UIMgr.GetInstance()

	if arg1_37 then
		var0_37:OverlayPanelPB(arg0_37._parentTf, {
			pbList = {
				arg0_37.detailPanel:Find("attrs"),
				arg0_37.detailPanel:Find("equipments"),
				arg0_37.detailPanel:Find("quick_panel")
			},
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		var0_37:UnOverlayPanel(arg0_37._parentTf, arg0_37.mainPanel)
	end

	arg0_37.onSelected = arg1_37

	if arg0_37.onSelected and arg0_37.selectedEquip then
		local var1_37 = arg0_37.selectedEquip.index

		arg0_37:selectedEquipItem(nil)
		arg0_37:selectedEquipItem(var1_37)
	end
end

function var0_0.UpdateUI(arg0_38)
	local var0_38 = arg0_38:GetShipVO()

	arg0_38:UpdateIntimacy(var0_38)
	arg0_38:UpdateDetail(var0_38)
	arg0_38:UpdateEquipments(var0_38)
	arg0_38:UpdateLock()
	arg0_38:UpdatePreferenceTag()
end

function var0_0.UpdateIntimacy(arg0_39, arg1_39)
	setActive(arg0_39.intimacyTF, not LOCK_PROPOSE)
	setIntimacyIcon(arg0_39.intimacyTF, arg1_39:getIntimacyIcon())
end

function var0_0.UpdateDetail(arg0_40, arg1_40)
	arg0_40.shipDetailLogicPanel:flush(arg1_40)

	local var0_40 = arg0_40.shipDetailLogicPanel.attrs:Find("icons/hunting_range/bg")

	removeOnButton(var0_40)

	if table.contains(TeamType.SubShipType, arg1_40:getShipType()) then
		onButton(arg0_40, var0_40, function()
			arg0_40:emit(ShipViewConst.DISPLAY_HUNTING_RANGE, true)
		end, SFX_PANEL)
	end

	if not HXSet.isHxSkin() then
		setActive(arg0_40.fashionToggle, arg0_40.shareData:HasFashion())
	else
		setActive(arg0_40.fashionToggle, false)
	end

	arg0_40:UpdateFashionTag()
	setActive(arg0_40.profileBtn, not arg1_40:isActivityNpc())
end

function var0_0.UpdateFashionTag(arg0_42)
	local var0_42 = arg0_42:GetShipVO()

	setActive(arg0_42.fashionTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0_42) > 0)
end

function var0_0.UpdateEquipments(arg0_43, arg1_43)
	arg0_43:clearListener()
	removeAllChildren(arg0_43.equipmentsGrid)

	local var0_43 = arg1_43:getActiveEquipments()

	arg0_43.equipItems = {}

	for iter0_43, iter1_43 in ipairs(arg1_43.equipments) do
		local var1_43 = var0_43[iter0_43]
		local var2_43
		local var3_43 = iter0_43
		local var4_43

		if iter1_43 then
			var2_43 = cloneTplTo(arg0_43.detailEquipmentTpl, arg0_43.equipmentsGrid)
			var4_43 = {
				empty = false,
				tf = var2_43,
				index = var3_43
			}

			table.insert(arg0_43.equipItems, var4_43)
			updateEquipment(arg0_43:findTF("IconTpl", var2_43), iter1_43)
			onButton(arg0_43, var2_43, function()
				if arg0_43.isShowQuick then
					arg0_43:selectedEquipItem(var3_43)
				else
					arg0_43:emit(BaseUI.ON_EQUIPMENT, {
						type = EquipmentInfoMediator.TYPE_SHIP,
						shipId = arg0_43:GetShipVO().id,
						pos = iter0_43,
						LayerWeightMgr_weight = LayerWeightConst.SECOND_LAYER
					})
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		else
			var2_43 = cloneTplTo(arg0_43.emptyGridTpl, arg0_43.equipmentsGrid)
			var4_43 = {
				empty = true,
				tf = var2_43,
				index = var3_43
			}

			table.insert(arg0_43.equipItems, var4_43)
			onButton(arg0_43, var2_43, function()
				if arg0_43.isShowQuick then
					arg0_43:selectedEquipItem(var3_43)
				else
					arg0_43:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
				end
			end, SFX_UI_DOCKYARD_EQUIPADD)
		end

		local var5_43 = GetOrAddComponent(var2_43, typeof(EventTriggerListener))

		var5_43:AddPointDownFunc(function()
			if var2_43 and not arg0_43.isShowQuick then
				LeanTween.delayedCall(go(var2_43), 1, System.Action(function()
					arg0_43.selectedEquip = var4_43

					triggerToggle(arg0_43.showQuickBtn, true)
				end))
			end
		end)
		var5_43:AddPointUpFunc(function()
			if var2_43 and LeanTween.isTweening(go(var2_43)) then
				LeanTween.cancel(go(var2_43))
			end
		end)
	end

	local var6_43, var7_43 = ShipStatus.ShipStatusCheck("onModify", arg0_43:GetShipVO())

	if not var6_43 then
		triggerToggle(arg0_43.showQuickBtn, false)
	elseif arg1_43.id ~= arg0_43.lastShipVo and arg0_43.isShowQuick then
		onNextTick(function()
			triggerToggle(arg0_43.showQuickBtn, false)
			triggerToggle(arg0_43.showQuickBtn, true)
		end)
	elseif arg0_43.selectedEquip and arg0_43.isShowQuick then
		local var8_43 = arg0_43.selectedEquip.index

		arg0_43:selectedEquipItem(nil)
		arg0_43:selectedEquipItem(var8_43)
	end

	arg0_43.lastShipVo = arg1_43.id

	local var9_43, var10_43 = arg1_43:IsSpweaponUnlock()

	setActive(arg0_43.spWeaponSlot:Find("Lock"), not var9_43)

	local var11_43 = arg1_43:GetSpWeapon()

	setActive(arg0_43.spWeaponSlot:Find("Icon"), var11_43)
	setActive(arg0_43.spWeaponSlot:Find("IconShadow"), var11_43)

	if var11_43 then
		UpdateSpWeaponSlot(arg0_43.spWeaponSlot, var11_43)
	end

	onButton(arg0_43, arg0_43.spWeaponSlot, function()
		if not var9_43 then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var10_43))

			return
		elseif var11_43 then
			arg0_43:emit(BaseUI.ON_SPWEAPON, {
				type = EquipmentInfoMediator.TYPE_SHIP,
				shipId = arg0_43:GetShipVO().id
			})
		else
			arg0_43:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.EQUIPMENT)
		end
	end, SFX_PANEL)
end

function var0_0.selectedEquipItem(arg0_51, arg1_51)
	if not arg1_51 then
		if arg0_51.selectedEquip then
			arg0_51.selectedEquip = nil
			arg0_51.showEquipItem = nil
		end
	else
		arg0_51.selectedEquip = arg0_51.equipItems[arg1_51]
	end

	if arg0_51.isShowQuick then
		arg0_51:updateQuickPanel()
	end
end

function var0_0.updateQuickPanel(arg0_52, arg1_52)
	setActive(arg0_52.selectTitle, not arg0_52.selectedEquip)

	if arg0_52.isShowQuick and arg0_52.selectedEquip then
		if arg0_52.selectedEquip ~= arg0_52.showEquipItem or arg1_52 then
			arg0_52.showEquipItem = arg0_52.selectedEquip

			arg0_52:updateQuickEquipments()
		end
	else
		arg0_52:setListCount(0, 0)
		setActive(arg0_52.emptyTitle, false)
	end

	if arg0_52.equipItems then
		for iter0_52 = 1, #arg0_52.equipItems do
			if arg0_52.selectedEquip and arg0_52.selectedEquip.index == iter0_52 then
				setActive(findTF(arg0_52.equipItems[iter0_52].tf, "selected"), true)
			else
				setActive(findTF(arg0_52.equipItems[iter0_52].tf, "selected"), false)
			end
		end
	end
end

function var0_0.updateQuickEquipments(arg0_53)
	arg0_53:setListCount(0, 0)

	arg0_53.fillterEquipments = arg0_53:getEquipments()

	setActive(arg0_53.emptyTitle, false)

	if arg0_53.selectedEquip and arg0_53.selectedEquip.empty then
		setActive(arg0_53.emptyTitle, #arg0_53.fillterEquipments == 0)
	end

	local var0_53 = arg0_53.selectedEquip.empty and 0 or 1

	arg0_53:setListCount(#arg0_53.fillterEquipments + var0_53, 0)
end

function var0_0.setListCount(arg0_54, arg1_54, arg2_54)
	if arg0_54.onSelected and isActive(arg0_54._tf) and arg0_54.list then
		arg0_54.list:SetTotalCount(arg1_54, arg2_54)
	end
end

function var0_0.getEquipments(arg0_55)
	local var0_55 = getProxy(BayProxy)
	local var1_55 = arg0_55:GetShipVO()
	local var2_55 = getProxy(EquipmentProxy)
	local var3_55 = pg.ship_data_template[var1_55.configId]["equip_" .. arg0_55.selectedEquip.index]
	local var4_55 = var1_55:getShipType()
	local var5_55 = var2_55:getEquipmentsByFillter(var4_55, var3_55)

	if arg0_55.equipingFlag then
		for iter0_55, iter1_55 in ipairs(var0_55:getEquipsInShips(function(arg0_56, arg1_56)
			return var1_55.id ~= arg1_56 and not var1_55:isForbiddenAtPos(arg0_56, arg0_55.selectedEquip.index)
		end)) do
			table.insert(var5_55, iter1_55)
		end
	end

	local var6_55 = {}
	local var7_55 = {
		arg0_55.indexData.equipPropertyIndex,
		arg0_55.indexData.equipPropertyIndex2
	}

	for iter2_55, iter3_55 in pairs(var5_55) do
		if arg0_55:checkFillter(iter3_55, var7_55) then
			table.insert(var6_55, iter3_55)
		end
	end

	_.each(var6_55, function(arg0_57)
		if not var1_55:canEquipAtPos(arg0_57, arg0_55.selectedEquip.index) then
			arg0_57.mask = true
		end
	end)
	table.sort(var6_55, CompareFuncs(var1_0.sortFunc(var1_0.sort[1], false)))

	return var6_55
end

function var0_0.checkFillter(arg0_58, arg1_58, arg2_58)
	return (arg1_58.count > 0 or arg1_58.shipId and arg0_58.equipingFlag) and IndexConst.filterEquipByType(arg1_58, arg0_58.indexData.typeIndex) and IndexConst.filterEquipByProperty(arg1_58, arg2_58) and IndexConst.filterEquipAmmo1(arg1_58, arg0_58.indexData.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(arg1_58, arg0_58.indexData.equipAmmoIndex2) and IndexConst.filterEquipByCamp(arg1_58, arg0_58.indexData.equipCampIndex) and IndexConst.filterEquipByRarity(arg1_58, arg0_58.indexData.rarityIndex) and IndexConst.filterEquipByExtra(arg1_58, arg0_58.indexData.extraIndex)
end

function var0_0.UpdateLock(arg0_59)
	local var0_59 = arg0_59:GetShipVO():GetLockState()

	if var0_59 == arg0_59:GetShipVO().LOCK_STATE_UNLOCK then
		setActive(arg0_59.lockBtn, true)
		setActive(arg0_59.unlockBtn, false)
	elseif var0_59 == arg0_59:GetShipVO().LOCK_STATE_LOCK then
		setActive(arg0_59.lockBtn, false)
		setActive(arg0_59.unlockBtn, true)
	end
end

function var0_0.displayQuickPanel(arg0_60)
	if not arg0_60:GetShipVO() then
		return
	end

	arg0_60.isShowQuick = true

	setActive(arg0_60.attrs, false)
	setActive(arg0_60.quickPanel, true)
	arg0_60:updateQuickPanel()
end

function var0_0.quickSelectEmpty(arg0_61)
	if not arg0_61.selectedEquip and arg0_61.equipItems then
		for iter0_61 = 1, #arg0_61.equipItems do
			if arg0_61.equipItems[iter0_61].empty then
				arg0_61:selectedEquipItem(arg0_61.equipItems[iter0_61].index)

				return
			end
		end
	end
end

local var3_0 = 0.2

function var0_0.displayRecordPanel(arg0_62)
	if not arg0_62:GetShipVO() then
		return
	end

	arg0_62.isShowRecord = true

	setActive(arg0_62.recordPanel, true)
	setActive(arg0_62.attrs, false)

	for iter0_62, iter1_62 in ipairs(arg0_62.recordBtns) do
		onButton(arg0_62, iter1_62, function()
			arg0_62:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0_62:GetShipVO().id, iter0_62, 1)
		end, SFX_PANEL)
	end

	for iter2_62, iter3_62 in ipairs(arg0_62.equipRecordBtns) do
		onButton(arg0_62, iter3_62, function()
			arg0_62:emit(ShipMainMediator.ON_RECORD_EQUIPMENT, arg0_62:GetShipVO().id, iter2_62, 2)
		end, SFX_PANEL)
	end

	for iter4_62, iter5_62 in ipairs(arg0_62.recordEquipmentsTFs) do
		arg0_62:UpdateRecordEquipments(iter4_62)
	end

	arg0_62:UpdateRecordSpWeapons()
end

function var0_0.CloseRecordPanel(arg0_65, arg1_65)
	if arg1_65 then
		arg0_65.isShowRecord = nil

		setActive(arg0_65.recordPanel, false)

		if not arg0_65.isShowRecord and not arg0_65.isShowQuick then
			setActive(arg0_65.attrs, true)
		end
	else
		triggerToggle(arg0_65.showRecordBtn, false)
	end
end

function var0_0.CloseQuickPanel(arg0_66)
	arg0_66.isShowQuick = nil

	arg0_66:selectedEquipItem(nil)

	arg0_66.showEquipItem = nil

	if arg0_66.list then
		arg0_66:setListCount(0, 0)
	end

	setActive(arg0_66.quickPanel, false)

	if not arg0_66.isShowRecord and not arg0_66.isShowQuick then
		setActive(arg0_66.attrs, true)
	end

	arg0_66:updateQuickPanel()
end

function var0_0.UpdateRecordEquipments(arg0_67, arg1_67)
	local var0_67 = arg0_67.recordEquipmentsTFs[arg1_67]
	local var1_67 = arg0_67:GetShipVO():getEquipmentRecord(arg0_67.shareData.player.id)[arg1_67] or {}

	for iter0_67 = 1, 5 do
		local var2_67 = tonumber(var1_67[iter0_67])
		local var3_67 = var2_67 and var2_67 ~= -1
		local var4_67 = var0_67:Find("equipment_" .. iter0_67)
		local var5_67 = var4_67:Find("empty")
		local var6_67 = var4_67:Find("info")

		setActive(var6_67, var3_67)
		setActive(var5_67, not var3_67)

		if var3_67 then
			local var7_67 = arg0_67.equipmentProxy:getEquipmentById(var2_67)
			local var8_67 = arg0_67:GetShipVO().equipments[iter0_67]
			local var9_67 = not (var8_67 and var8_67.id == var2_67 or false) and (not var7_67 or not (var7_67.count > 0))

			setActive(var6_67:Find("tip"), var9_67)
			updateEquipment(arg0_67:findTF("IconTpl", var6_67), Equipment.New({
				id = var2_67
			}))

			if var9_67 then
				onButton(arg0_67, var6_67, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			end
		else
			removeOnButton(var6_67)
		end
	end
end

function var0_0.UpdateRecordSpWeapons(arg0_69, arg1_69)
	if LOCK_SP_WEAPON then
		return
	end

	local var0_69 = arg0_69:GetShipVO():GetSpWeaponRecord(arg0_69.shareData.player.id)

	table.Foreach(arg0_69.recordBars, function(arg0_70, arg1_70)
		if arg1_69 and arg0_70 ~= arg1_69 then
			return
		end

		local var0_70 = var0_69[arg0_70]
		local var1_70 = arg1_70:Find("SpSlot")
		local var2_70 = arg0_69:GetShipVO():IsSpweaponUnlock()

		setActive(var1_70:Find("Lock"), not var2_70)
		setActive(var1_70:Find("Icon"), var0_70)
		setActive(var1_70:Find("IconShadow"), var0_70)

		if var0_70 then
			UpdateSpWeaponSlot(var1_70, var0_70)

			local var3_70 = arg0_69:GetShipVO():GetSpWeapon()
			local var4_70 = var3_70 and var3_70:GetConfigID() or 0
			local var5_70 = var0_70:GetConfigID() ~= var4_70

			if var5_70 then
				local var6_70 = getProxy(EquipmentProxy):GetSameTypeSpWeapon(var0_70)

				if var6_70 and var6_70:GetConfigID() == var0_70:GetConfigID() then
					var5_70 = false
				end
			end

			setActive(var1_70:Find("Icon/tip"), var5_70)

			if var5_70 then
				onButton(arg0_69, var1_70, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_nofreeequip"))
				end, SFX_PANEL)
			else
				removeOnButton(var1_70)
			end
		else
			removeOnButton(var1_70)
		end
	end)
end

function var0_0.UpdatePreferenceTag(arg0_72)
	triggerToggle(arg0_72.commonTagToggle, arg0_72:GetShipVO().preferenceTag == Ship.PREFERENCE_TAG_COMMON)
end

function var0_0.DoLeveUpAnim(arg0_73, arg1_73, arg2_73, arg3_73)
	arg0_73.shipDetailLogicPanel:doLeveUpAnim(arg1_73, arg2_73, arg3_73)
end

function var0_0.clearListener(arg0_74)
	if arg0_74.equipItems then
		for iter0_74 = 1, #arg0_74.equipItems do
			local var0_74 = arg0_74.equipItems[iter0_74].tf

			if var0_74 then
				ClearEventTrigger(GetOrAddComponent(go(var0_74), typeof(EventTriggerListener)))
				removeOnButton(go(var0_74))
			end
		end
	end
end

function var0_0.OnDestroy(arg0_75)
	arg0_75:clearListener()
	removeAllChildren(arg0_75.equipmentsGrid)

	if arg0_75.list then
		arg0_75.list:SetTotalCount(0)

		function arg0_75.list.onUpdateItem()
			return
		end
	end

	arg0_75.destroy = true

	if arg0_75.recordPanel then
		if LeanTween.isTweening(go(arg0_75.recordPanel)) then
			LeanTween.cancel(go(arg0_75.recordPanel))
		end

		arg0_75.recordPanel = nil
	end

	arg0_75.shipDetailLogicPanel:clear()
	arg0_75.shipDetailLogicPanel:detach()

	arg0_75.shareData = nil
end

return var0_0
