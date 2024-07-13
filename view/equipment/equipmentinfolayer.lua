local var0_0 = class("EquipmentInfoLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EquipmentInfoUI"
end

var0_0.PANEL_DESTROY = "Destroy"
var0_0.PANEL_REVERT = "Revert"
var0_0.Left = 1
var0_0.Middle = 2
var0_0.Right = 3
var0_0.pos = {
	{
		-353,
		30,
		0
	},
	{
		0,
		30,
		0
	},
	{
		353,
		30,
		0
	}
}

function var0_0.init(arg0_2)
	local var0_2 = {
		"default",
		"replace",
		"display",
		"destroy",
		"revert"
	}

	arg0_2.toggles = {}

	for iter0_2, iter1_2 in ipairs(var0_2) do
		arg0_2[iter1_2 .. "Panel"] = arg0_2:findTF(iter1_2)
		arg0_2.toggles[iter1_2 .. "Panel"] = arg0_2:findTF("toggle_controll/" .. iter1_2)
	end

	arg0_2.sample = arg0_2:findTF("sample")

	setActive(arg0_2.sample, false)
	setActive(arg0_2.defaultPanel:Find("transform_tip"), false)

	arg0_2.txtQuickEnable = findTF(arg0_2._tf, "txtQuickEnable")

	setText(arg0_2.txtQuickEnable, i18n("ship_equip_check"))

	arg0_2.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0_2._tf, arg0_2.event)
end

function var0_0.setEquipment(arg0_3, arg1_3)
	arg0_3.equipmentVO = arg1_3
end

function var0_0.setShip(arg0_4, arg1_4, arg2_4)
	arg0_4.shipVO = arg1_4
	arg0_4.oldShipVO = arg2_4
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.player = arg1_5
end

function var0_0.checkOverGold(arg0_6, arg1_6)
	local var0_6 = _.detect(arg1_6, function(arg0_7)
		return arg0_7.type == DROP_TYPE_RESOURCE and arg0_7.id == 1
	end).count or 0

	if arg0_6.player:GoldMax(var0_6) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.setDestroyCount(arg0_8, arg1_8)
	arg1_8 = math.clamp(arg1_8, 1, arg0_8.equipmentVO.count)

	if arg0_8.destroyCount ~= arg1_8 then
		arg0_8.destroyCount = arg1_8

		arg0_8:updateDestroyCount()
	end
end

function var0_0.didEnter(arg0_9)
	setActive(arg0_9.txtQuickEnable, arg0_9.contextData.quickFlag or false)

	local var0_9 = defaultValue(arg0_9.contextData.type, EquipmentInfoMediator.TYPE_DEFAULT)

	arg0_9.isShowUnique = table.contains(EquipmentInfoMediator.SHOW_UNIQUE, var0_9)

	onButton(arg0_9, arg0_9._tf:Find("bg"), function()
		if isActive(arg0_9.destroyPanel) then
			triggerToggle(arg0_9.toggles.defaultPanel, true)

			return
		end

		arg0_9:closeView()
	end, SOUND_BACK)
	arg0_9:initAndSetBtn(var0_9)

	if var0_9 == EquipmentInfoMediator.TYPE_DEFAULT then
		arg0_9:updateOperation1()
	elseif var0_9 == EquipmentInfoMediator.TYPE_SHIP then
		arg0_9:updateOperation2()
	elseif var0_9 == EquipmentInfoMediator.TYPE_REPLACE then
		arg0_9:updateOperation3()
	elseif var0_9 == EquipmentInfoMediator.TYPE_DISPLAY then
		arg0_9:updateOperation4()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf, true, {
		weight = arg0_9:getWeightFromData()
	})
end

function var0_0.initAndSetBtn(arg0_11, arg1_11)
	if arg1_11 == EquipmentInfoMediator.TYPE_DEFAULT or arg1_11 == EquipmentInfoMediator.TYPE_SHIP then
		arg0_11.defaultEquipTF = arg0_11:findTF("equipment", arg0_11.defaultPanel) or arg0_11:cloneSampleTo(arg0_11.defaultPanel, var0_0.Middle, "equipment")
		arg0_11.defaultReplaceBtn = arg0_11:findTF("actions/action_button_3", arg0_11.defaultPanel)
		arg0_11.defaultDestroyBtn = arg0_11:findTF("actions/action_button_1", arg0_11.defaultPanel)
		arg0_11.defaultEnhanceBtn = arg0_11:findTF("actions/action_button_2", arg0_11.defaultPanel)
		arg0_11.defaultUnloadBtn = arg0_11:findTF("actions/action_button_4", arg0_11.defaultPanel)
		arg0_11.defaultRevertBtn = arg0_11:findTF("info/equip/revert_btn", arg0_11.defaultEquipTF)
		arg0_11.defaultTransformTipBar = arg0_11:findTF("transform_tip", arg0_11.defaultEquipTF)

		if arg1_11 == EquipmentInfoMediator.TYPE_DEFAULT and not arg0_11.defaultTransformTipBar then
			local var0_11 = arg0_11.defaultPanel:Find("transform_tip")

			setParent(var0_11, arg0_11.defaultEquipTF)

			local var1_11 = var0_11.sizeDelta

			var1_11.y = 0
			var0_11.sizeDelta = var1_11

			setAnchoredPosition(var0_11, Vector2.zero)

			arg0_11.defaultTransformTipBar = var0_11
		end

		onButton(arg0_11, arg0_11.defaultReplaceBtn, function()
			local var0_12, var1_12 = ShipStatus.ShipStatusCheck("onModify", arg0_11.shipVO)

			if not var0_12 then
				pg.TipsMgr.GetInstance():ShowTips(var1_12)

				return
			end

			arg0_11:emit(EquipmentInfoMediator.ON_CHANGE)
		end, SFX_PANEL)
		onButton(arg0_11, arg0_11.defaultEnhanceBtn, function()
			if arg0_11.shipVO then
				local var0_13, var1_13 = ShipStatus.ShipStatusCheck("onModify", arg0_11.shipVO)

				if not var0_13 then
					pg.TipsMgr.GetInstance():ShowTips(var1_13)

					return
				end
			end

			arg0_11:emit(EquipmentInfoMediator.ON_INTENSIFY)
		end, SFX_PANEL)
		onButton(arg0_11, arg0_11.defaultUnloadBtn, function()
			local var0_14, var1_14 = ShipStatus.ShipStatusCheck("onModify", arg0_11.shipVO)

			if not var0_14 then
				pg.TipsMgr.GetInstance():ShowTips(var1_14)

				return
			end

			arg0_11:emit(EquipmentInfoMediator.ON_UNEQUIP)
		end, SFX_UI_DOCKYARD_EQUIPOFF)
		onButton(arg0_11, arg0_11.defaultDestroyBtn, function()
			triggerToggle(arg0_11.toggles.destroyPanel, true)

			if not arg0_11.initDestroyPanel then
				arg0_11:initAndSetBtn(var0_0.PANEL_DESTROY)
			end

			arg0_11:updateEquipmentPanel(arg0_11.destroyEquipTF, arg0_11.equipmentVO)

			if arg0_11.equipmentVO.count > 0 then
				arg0_11:setDestroyCount(1)
			end
		end, SFX_PANEL)
		onButton(arg0_11, arg0_11.defaultRevertBtn, function()
			triggerToggle(arg0_11.toggles.revertPanel, true)

			if not arg0_11.initRevertPanel then
				arg0_11:initAndSetBtn(var0_0.PANEL_REVERT)
			end

			arg0_11:updateRevertPanel()
		end, SFX_PANEL)
	elseif arg1_11 == EquipmentInfoMediator.TYPE_REPLACE then
		arg0_11.replaceSrcEquipTF = arg0_11:findTF("equipment", arg0_11.replacePanel) or arg0_11:cloneSampleTo(arg0_11.replacePanel, var0_0.Left, "equipment")
		arg0_11.replaceDstEquipTF = arg0_11:findTF("equipment_on_ship", arg0_11.replacePanel) or arg0_11:cloneSampleTo(arg0_11.replacePanel, var0_0.Right, "equipment_on_ship")
		arg0_11.replaceCancelBtn = arg0_11:findTF("actions/cancel_button", arg0_11.replacePanel)
		arg0_11.replaceConfirmBtn = arg0_11:findTF("actions/action_button_2", arg0_11.replacePanel)

		onButton(arg0_11, arg0_11.replaceCancelBtn, function()
			if isActive(arg0_11.destroyPanel) then
				triggerToggle(arg0_11.toggles.defaultPanel, true)

				return
			end

			arg0_11:closeView()
		end, SFX_CANCEL)
		onButton(arg0_11, arg0_11.replaceConfirmBtn, function()
			local var0_18, var1_18 = arg0_11.shipVO:canEquipAtPos(arg0_11.equipmentVO, arg0_11.contextData.pos)

			if not var0_18 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentInfoLayer_error_canNotEquip", var1_18))

				return
			end

			if arg0_11.contextData.quickCallback then
				arg0_11.contextData.quickCallback()
				arg0_11:closeView()
			else
				arg0_11:emit(EquipmentInfoMediator.ON_EQUIP)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	elseif arg1_11 == EquipmentInfoMediator.TYPE_DISPLAY then
		arg0_11.displayEquipTF = arg0_11:findTF("equipment", arg0_11.displayPanel) or arg0_11:cloneSampleTo(arg0_11.displayPanel, var0_0.Middle, "equipment")
		arg0_11.displayMoveBtn = arg0_11:findTF("actions/move_button", arg0_11.displayPanel)
		arg0_11.defaultTransformTipBar = arg0_11:findTF("transform_tip", arg0_11.displayEquipTF)

		if arg0_11.contextData.showTransformTip and not arg0_11.defaultTransformTipBar then
			local var2_11 = arg0_11.defaultPanel:Find("transform_tip")

			setParent(var2_11, arg0_11.displayEquipTF)

			local var3_11 = var2_11.sizeDelta

			var3_11.y = 0
			var2_11.sizeDelta = var3_11

			setAnchoredPosition(var2_11, Vector2.zero)

			arg0_11.defaultTransformTipBar = var2_11
		end

		onButton(arg0_11, arg0_11.displayMoveBtn, function()
			arg0_11:emit(EquipmentInfoMediator.ON_MOVE, arg0_11.shipVO.id)
		end)
	elseif arg1_11 == var0_0.PANEL_DESTROY then
		arg0_11.initDestroyPanel = true
		arg0_11.destroyEquipTF = arg0_11:findTF("equipment", arg0_11.destroyPanel) or arg0_11:cloneSampleTo(arg0_11.destroyPanel, var0_0.Left, "equipment")
		arg0_11.destroyCounter = arg0_11:findTF("destroy", arg0_11.destroyPanel)
		arg0_11.destroyValue = arg0_11:findTF("count/number_panel/value", arg0_11.destroyCounter)
		arg0_11.destroyLeftButton = arg0_11:findTF("count/number_panel/left", arg0_11.destroyCounter)
		arg0_11.destroyRightButton = arg0_11:findTF("count/number_panel/right", arg0_11.destroyCounter)
		arg0_11.destroyBonusList = arg0_11:findTF("got/list", arg0_11.destroyCounter)
		arg0_11.destroyBonusItem = arg0_11:findTF("got/item", arg0_11.destroyCounter)
		arg0_11.destroyCancelBtn = arg0_11:findTF("actions/cancel_button", arg0_11.destroyPanel)
		arg0_11.destroyConfirmBtn = arg0_11:findTF("actions/destroy_button", arg0_11.destroyPanel)

		onButton(arg0_11, arg0_11.destroyLeftButton, function()
			arg0_11:setDestroyCount(arg0_11.destroyCount - 1)
		end, SFX_PANEL)
		onButton(arg0_11, arg0_11.destroyRightButton, function()
			arg0_11:setDestroyCount(arg0_11.destroyCount + 1)
		end, SFX_PANEL)
		onButton(arg0_11, arg0_11:findTF("count/max", arg0_11.destroyCounter), function()
			arg0_11:setDestroyCount(arg0_11.equipmentVO.count)
		end, SFX_PANEL)
		onButton(arg0_11, arg0_11.destroyCancelBtn, function()
			triggerToggle(arg0_11.toggles.defaultPanel, true)
		end, SFX_CANCEL)
		onButton(arg0_11, arg0_11.destroyConfirmBtn, function()
			if not arg0_11:checkOverGold(arg0_11.awards) then
				return
			end

			local var0_24 = {}

			if arg0_11.equipmentVO:isImportance() then
				table.insert(var0_24, function(arg0_25)
					arg0_11.equipDestroyConfirmWindow:Load()
					arg0_11.equipDestroyConfirmWindow:ActionInvoke("Show", {
						setmetatable({
							count = arg0_11.destroyCount
						}, {
							__index = arg0_11.equipmentVO
						})
					}, arg0_25)
				end)
			end

			seriesAsync(var0_24, function()
				arg0_11:emit(EquipmentInfoMediator.ON_DESTROY, arg0_11.destroyCount)
			end)
		end, SFX_UI_EQUIPMENT_RESOLVE)
	elseif arg1_11 == var0_0.PANEL_REVERT then
		arg0_11.initRevertPanel = true
		arg0_11.revertEquipTF = arg0_11:findTF("equipment", arg0_11.revertPanel) or arg0_11:cloneSampleTo(arg0_11.revertPanel, var0_0.Left, "equipment")
		arg0_11.revertAwardContainer = arg0_11:findTF("item_panel/got/list", arg0_11.revertPanel)
		arg0_11.revertCancelBtn = arg0_11:findTF("actions/cancel_button", arg0_11.revertPanel)
		arg0_11.revertConfirmBtn = arg0_11:findTF("actions/revert_button", arg0_11.revertPanel)
		arg0_11.itemTpl = arg0_11:getTpl("item_panel/got/item", arg0_11.revertPanel)

		onButton(arg0_11, arg0_11.revertCancelBtn, function()
			triggerToggle(arg0_11.toggles.defaultPanel, true)
		end, SFX_CANCEL)
		onButton(arg0_11, arg0_11.revertConfirmBtn, function()
			if not arg0_11:checkOverGold(arg0_11.awards) then
				return
			end

			local var0_28 = arg0_11.equipmentVO

			arg0_11:emit(EquipmentInfoMediator.ON_REVERT, var0_28.id)
		end, SFX_UI_EQUIPMENT_RESOLVE)
	end
end

function var0_0.updateOperation1(arg0_29)
	triggerToggle(arg0_29.toggles.defaultPanel, true)
	arg0_29:updateEquipmentPanel(arg0_29.defaultEquipTF, arg0_29.equipmentVO)
	setActive(arg0_29.defaultRevertBtn, not LOCK_EQUIP_REVERT and arg0_29.fromEquipmentView and arg0_29.equipmentVO:getConfig("level") > 1 and getProxy(BagProxy):getItemCountById(Item.REVERT_EQUIPMENT_ID) > 0)
	setActive(arg0_29.defaultReplaceBtn, false)
	setActive(arg0_29.defaultUnloadBtn, false)
	setActive(arg0_29.defaultDestroyBtn, arg0_29.contextData.destroy and arg0_29.equipmentVO.count > 0)
	arg0_29:UpdateTransformTipBar(arg0_29.equipmentVO)
end

function var0_0.updateOperation2(arg0_30)
	triggerToggle(arg0_30.toggles.defaultPanel, true)
	arg0_30:updateEquipmentPanel(arg0_30.defaultEquipTF, arg0_30.shipVO:getEquip(arg0_30.contextData.pos))
	setActive(arg0_30.defaultDestroyBtn, false)
	setActive(arg0_30.defaultReplaceBtn, true)
	setActive(arg0_30.defaultUnloadBtn, true)
	setActive(arg0_30.defaultRevertBtn, false)

	local var0_30 = arg0_30:findTF("head", arg0_30.defaultEquipTF)

	setActive(var0_30, arg0_30.shipVO)

	if arg0_30.shipVO then
		setImageSprite(findTF(var0_30, "Image"), LoadSprite("qicon/" .. arg0_30.shipVO:getPainting()))
	end

	if arg0_30.defaultTransformTipBar then
		setActive(arg0_30.defaultTransformTipBar, false)
	end
end

function var0_0.updateOperation3(arg0_31)
	triggerToggle(arg0_31.toggles.replacePanel, true)

	local var0_31 = arg0_31.shipVO:getEquip(arg0_31.contextData.pos)

	if var0_31 then
		local var1_31 = var0_31:GetPropertiesInfo()
		local var2_31 = arg0_31.equipmentVO:GetPropertiesInfo()

		if EquipType.getCompareGroup(var0_31.configId) == EquipType.getCompareGroup(arg0_31.equipmentVO.configId) then
			Equipment.InsertAttrsCompare(var1_31.attrs, var2_31.attrs, arg0_31.shipVO)
		end

		arg0_31:updateEquipmentPanel(arg0_31.replaceSrcEquipTF, var0_31, var1_31)
		arg0_31:updateEquipmentPanel(arg0_31.replaceDstEquipTF, arg0_31.equipmentVO, var2_31)
	else
		arg0_31:updateEquipmentPanel(arg0_31.replaceSrcEquipTF, var0_31)
		arg0_31:updateEquipmentPanel(arg0_31.replaceDstEquipTF, arg0_31.equipmentVO)
	end

	local var3_31 = arg0_31:findTF("head", arg0_31.replaceDstEquipTF)

	setActive(var3_31, arg0_31.oldShipVO)

	if arg0_31.oldShipVO then
		setImageSprite(findTF(var3_31, "Image"), LoadSprite("qicon/" .. arg0_31.oldShipVO:getPainting()))
	end
end

function var0_0.updateOperation4(arg0_32)
	triggerToggle(arg0_32.toggles.displayPanel, true)
	arg0_32:updateEquipmentPanel(arg0_32.displayEquipTF, arg0_32.equipmentVO)
	setActive(arg0_32.displayMoveBtn, arg0_32.shipVO)

	local var0_32 = arg0_32:findTF("head", arg0_32.displayEquipTF)

	setActive(var0_32, arg0_32.shipVO)

	if arg0_32.shipVO then
		setImageSprite(findTF(var0_32, "Image"), LoadSprite("qicon/" .. arg0_32.shipVO:getPainting()))
	end

	arg0_32:UpdateTransformTipBar(arg0_32.equipmentVO)
end

function var0_0.updateRevertPanel(arg0_33)
	local var0_33 = arg0_33.equipmentVO:GetRootEquipment()
	local var1_33 = arg0_33.equipmentVO:GetPropertiesInfo()
	local var2_33 = var0_33:GetPropertiesInfo()

	Equipment.InsertAttrsCompare(var1_33.attrs, var2_33.attrs, arg0_33.shipVO)
	arg0_33:updateEquipmentPanel(arg0_33.revertEquipTF, var0_33, var2_33, arg0_33.equipmentVO:getConfig("level"))
	arg0_33:updateOperationAward(arg0_33.revertAwardContainer, arg0_33.itemTpl, arg0_33.equipmentVO:getRevertAwards())
end

function var0_0.updateDestroyCount(arg0_34)
	local var0_34 = arg0_34.destroyCount

	setText(arg0_34.destroyValue, var0_34)

	local var1_34 = {}
	local var2_34 = 0
	local var3_34 = arg0_34.equipmentVO:getConfig("destory_item") or {}
	local var4_34 = var2_34 + (arg0_34.equipmentVO:getConfig("destory_gold") or 0) * var0_34

	for iter0_34, iter1_34 in ipairs(var3_34) do
		table.insert(var1_34, {
			type = DROP_TYPE_ITEM,
			id = iter1_34[1],
			count = iter1_34[2] * var0_34
		})
	end

	table.insert(var1_34, {
		id = 1,
		type = DROP_TYPE_RESOURCE,
		count = var4_34
	})
	arg0_34:updateOperationAward(arg0_34.destroyBonusList, arg0_34.destroyBonusItem, var1_34)
end

function var0_0.updateOperationAward(arg0_35, arg1_35, arg2_35, arg3_35)
	arg0_35.awards = arg3_35

	if arg1_35.childCount == 0 then
		for iter0_35 = 1, #arg3_35 do
			cloneTplTo(arg2_35, arg1_35)
		end
	end

	for iter1_35 = 1, #arg3_35 do
		local var0_35 = arg1_35:GetChild(iter1_35 - 1)
		local var1_35 = arg3_35[iter1_35]

		updateDrop(var0_35, var1_35)
		onButton(arg0_35, var0_35, function()
			arg0_35:emit(var0_0.ON_DROP, var1_35)
		end, SFX_PANEL)
		setText(findTF(var0_35, "name_panel/name"), getText(findTF(var0_35, "name")))
		setText(findTF(var0_35, "name_panel/number"), " x " .. getText(findTF(var0_35, "icon_bg/count")))
		setActive(findTF(var0_35, "icon_bg/count"), false)
	end
end

function var0_0.updateEquipmentPanel(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	local var0_37 = arg0_37:findTF("info", arg1_37)
	local var1_37 = arg0_37:findTF("empty", arg1_37)

	setActive(var0_37, arg2_37)
	setActive(var1_37, not arg2_37)

	if arg2_37 then
		local var2_37 = findTF(var0_37, "name")

		setScrollText(findTF(var2_37, "mask/Text"), arg2_37:getConfig("name"))
		setActive(findTF(var2_37, "unique"), arg2_37:isUnique() and arg0_37.isShowUnique)

		local var3_37 = findTF(var0_37, "equip")

		setImageSprite(findTF(var3_37, "bg"), GetSpriteFromAtlas("ui/equipmentinfoui_atlas", "equip_bg_" .. EquipmentRarity.Rarity2Print(arg2_37:getConfig("rarity"))))
		updateEquipment(var3_37, arg2_37, {
			noIconColorful = true
		})
		setActive(findTF(var3_37, "revert_btn"), false)
		setActive(findTF(var3_37, "slv"), arg4_37 or arg2_37:getConfig("level") > 1)
		setText(findTF(var3_37, "slv/Text"), arg4_37 and arg4_37 - 1 or arg2_37:getConfig("level") - 1)
		setActive(findTF(var3_37, "slv/next"), arg4_37)
		setText(findTF(var3_37, "slv/next/Text"), arg2_37:getConfig("level") - 1)

		local var4_37 = arg0_37:findTF("tier", var3_37)

		setActive(var4_37, arg2_37)

		local var5_37 = arg2_37:getConfig("tech") or 1

		eachChild(var4_37, function(arg0_38)
			setActive(arg0_38, tostring(var5_37) == arg0_38.gameObject.name)
		end)
		setImageSprite(findTF(var3_37, "title"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(arg2_37:getConfig("type"))))
		setText(var3_37:Find("speciality/Text"), arg2_37:getConfig("speciality") ~= "无" and arg2_37:getConfig("speciality") or i18n1("—"))
		updateEquipInfo(var0_37:Find("attributes/view/content"), arg3_37 or arg2_37:GetPropertiesInfo(), arg2_37:GetSkill(), arg0_37.shipVO)
	end
end

function var0_0.UpdateTransformTipBar(arg0_39, arg1_39)
	if not arg0_39.defaultTransformTipBar then
		return
	end

	local var0_39 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "EquipmentTransformTreeMediator")
	local var1_39 = EquipmentProxy.GetTransformTargets(Equipment.GetEquipRootStatic(arg1_39.id))

	setActive(arg0_39.defaultTransformTipBar, not LOCK_EQUIPMENT_TRANSFORM and var0_39 and #var1_39 > 0)

	if isActive(arg0_39.defaultTransformTipBar) then
		local var2_39 = pg.equip_upgrade_data

		UIItemList.StaticAlign(arg0_39.defaultTransformTipBar:Find("list"), arg0_39.defaultTransformTipBar:Find("list/transformTarget"), #var1_39, function(arg0_40, arg1_40, arg2_40)
			if arg0_40 == UIItemList.EventUpdate then
				setActive(arg2_40:Find("link"), arg1_40 > 0)

				local var0_40 = var2_39[var1_39[arg1_40 + 1]]
				local var1_40 = var0_40 and var0_40.target_id

				if not var1_40 then
					setActive(arg2_40, false)

					return
				end

				updateDrop(arg2_40:Find("item"), {
					type = DROP_TYPE_EQUIP,
					id = var1_40
				})
				onButton(arg0_39, arg2_40:Find("item"), function()
					local var0_41 = CreateShell(arg1_39)

					if arg0_39.shipVO then
						var0_41.shipId = arg0_39.shipVO.id
						var0_41.shipPos = arg0_39.contextData.pos
					end

					arg0_39:emit(EquipmentInfoMediator.OPEN_LAYER, Context.New({
						mediator = EquipmentTransformMediator,
						viewComponent = EquipmentTransformLayer,
						data = {
							fromStoreHouse = true,
							formulaId = var1_39[arg1_40 + 1],
							sourceEquipmentInstance = {
								type = DROP_TYPE_EQUIP,
								id = arg1_39.id,
								template = var0_41
							}
						}
					}))
				end, SFX_PANEL)
				arg2_40:Find("mask/name"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(var1_40).name)
			end
		end)
	end
end

function var0_0.cloneSampleTo(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42)
	local var0_42 = cloneTplTo(arg0_42.sample, arg1_42, arg3_42)

	var0_42.localPosition = Vector3.New(var0_0.pos[arg2_42][1], var0_0.pos[arg2_42][2], var0_0.pos[arg2_42][3])

	if arg4_42 then
		var0_42:SetSiblingIndex(arg4_42)
	end

	return var0_42
end

function var0_0.willExit(arg0_43)
	arg0_43.equipDestroyConfirmWindow:Destroy()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_43._tf)
end

function var0_0.onBackPressed(arg0_44)
	if arg0_44.equipDestroyConfirmWindow:isShowing() then
		arg0_44.equipDestroyConfirmWindow:Hide()

		return
	end

	if isActive(arg0_44.destroyPanel) then
		triggerToggle(arg0_44.toggles.defaultPanel, true)

		return
	end

	arg0_44:closeView()
end

return var0_0
