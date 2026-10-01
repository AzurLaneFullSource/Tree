local var0_0 = class("EquipmentInfoLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EquipmentInfoUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/equipmentinfoui_atlas",
		"equiptype"
	}

	table.insertto(var0_2, var0_0.super.getResource(arg0_2))

	return var0_2
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

function var0_0.init(arg0_3)
	local var0_3 = {
		"default",
		"replace",
		"display",
		"destroy",
		"revert"
	}

	arg0_3.toggles = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		arg0_3[iter1_3 .. "Panel"] = arg0_3._tf:Find(iter1_3)
		arg0_3.toggles[iter1_3 .. "Panel"] = arg0_3._tf:Find("toggle_controll/" .. iter1_3)
	end

	arg0_3.sample = arg0_3._tf:Find("sample")

	setActive(arg0_3.sample, false)
	setActive(arg0_3.defaultPanel:Find("transform_tip"), false)

	arg0_3.txtQuickEnable = findTF(arg0_3._tf, "txtQuickEnable")

	setText(arg0_3.txtQuickEnable, i18n("ship_equip_check"))

	arg0_3.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0_3._tf, arg0_3.event)
end

function var0_0.setEquipment(arg0_4, arg1_4)
	arg0_4.equipmentVO = arg1_4
end

function var0_0.setShip(arg0_5, arg1_5, arg2_5)
	arg0_5.shipVO = arg1_5
	arg0_5.oldShipVO = arg2_5
end

function var0_0.setPlayer(arg0_6, arg1_6)
	arg0_6.player = arg1_6
end

function var0_0.checkOverGold(arg0_7, arg1_7)
	local var0_7 = _.detect(arg1_7, function(arg0_8)
		return arg0_8.type == DROP_TYPE_RESOURCE and arg0_8.id == 1
	end).count or 0

	if arg0_7.player:GoldMax(var0_7) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.setDestroyCount(arg0_9, arg1_9)
	arg1_9 = math.clamp(arg1_9, 1, arg0_9.equipmentVO.count)

	if arg0_9.destroyCount ~= arg1_9 then
		arg0_9.destroyCount = arg1_9

		arg0_9:updateDestroyCount()
	end
end

function var0_0.didEnter(arg0_10)
	setActive(arg0_10.txtQuickEnable, arg0_10.contextData.quickFlag or false)

	local var0_10 = defaultValue(arg0_10.contextData.type, EquipmentInfoMediator.TYPE_DEFAULT)

	arg0_10.isShowUnique = table.contains(EquipmentInfoMediator.SHOW_UNIQUE, var0_10)

	onButton(arg0_10, arg0_10._tf:Find("bg"), function()
		if isActive(arg0_10.destroyPanel) then
			triggerToggle(arg0_10.toggles.defaultPanel, true)

			return
		end

		arg0_10:closeView()
	end, SOUND_BACK)
	arg0_10:initAndSetBtn(var0_10)

	if var0_10 == EquipmentInfoMediator.TYPE_DEFAULT then
		arg0_10:updateOperation1()
	elseif var0_10 == EquipmentInfoMediator.TYPE_SHIP then
		arg0_10:updateOperation2()
	elseif var0_10 == EquipmentInfoMediator.TYPE_REPLACE then
		arg0_10:updateOperation3()
	elseif var0_10 == EquipmentInfoMediator.TYPE_DISPLAY then
		arg0_10:updateOperation4()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf, {
		staticBlur = true
	})
end

function var0_0.initAndSetBtn(arg0_12, arg1_12)
	if arg1_12 == EquipmentInfoMediator.TYPE_DEFAULT or arg1_12 == EquipmentInfoMediator.TYPE_SHIP then
		arg0_12.defaultEquipTF = arg0_12.defaultPanel:Find("equipment") or arg0_12:cloneSampleTo(arg0_12.defaultPanel, var0_0.Middle, "equipment")
		arg0_12.defaultReplaceBtn = arg0_12.defaultPanel:Find("actions/action_button_3")
		arg0_12.defaultDestroyBtn = arg0_12.defaultPanel:Find("actions/action_button_1")
		arg0_12.defaultEnhanceBtn = arg0_12.defaultPanel:Find("actions/action_button_2")
		arg0_12.defaultUnloadBtn = arg0_12.defaultPanel:Find("actions/action_button_4")
		arg0_12.defaultRevertBtn = arg0_12.defaultEquipTF:Find("info/equip/revert_btn")
		arg0_12.defaultTransformTipBar = arg0_12.defaultEquipTF:Find("transform_tip")

		if arg1_12 == EquipmentInfoMediator.TYPE_DEFAULT and not arg0_12.defaultTransformTipBar then
			local var0_12 = arg0_12.defaultPanel:Find("transform_tip")

			setParent(var0_12, arg0_12.defaultEquipTF)

			local var1_12 = var0_12.sizeDelta

			var1_12.y = 0
			var0_12.sizeDelta = var1_12

			setAnchoredPosition(var0_12, Vector2.zero)

			arg0_12.defaultTransformTipBar = var0_12
		end

		onButton(arg0_12, arg0_12.defaultReplaceBtn, function()
			local var0_13, var1_13 = ShipStatus.ShipStatusCheck("onModify", arg0_12.shipVO)

			if not var0_13 then
				pg.TipsMgr.GetInstance():ShowTips(var1_13)

				return
			end

			arg0_12:emit(EquipmentInfoMediator.ON_CHANGE)
		end, SFX_PANEL)
		onButton(arg0_12, arg0_12.defaultEnhanceBtn, function()
			if arg0_12.shipVO then
				local var0_14, var1_14 = ShipStatus.ShipStatusCheck("onModify", arg0_12.shipVO)

				if not var0_14 then
					pg.TipsMgr.GetInstance():ShowTips(var1_14)

					return
				end
			end

			arg0_12:emit(EquipmentInfoMediator.ON_INTENSIFY)
		end, SFX_PANEL)
		onButton(arg0_12, arg0_12.defaultUnloadBtn, function()
			local var0_15, var1_15 = ShipStatus.ShipStatusCheck("onModify", arg0_12.shipVO)

			if not var0_15 then
				pg.TipsMgr.GetInstance():ShowTips(var1_15)

				return
			end

			arg0_12:emit(EquipmentInfoMediator.ON_UNEQUIP)
		end, SFX_UI_DOCKYARD_EQUIPOFF)
		onButton(arg0_12, arg0_12.defaultDestroyBtn, function()
			triggerToggle(arg0_12.toggles.destroyPanel, true)

			if not arg0_12.initDestroyPanel then
				arg0_12:initAndSetBtn(var0_0.PANEL_DESTROY)
			end

			arg0_12:updateEquipmentPanel(arg0_12.destroyEquipTF, arg0_12.equipmentVO)

			if arg0_12.equipmentVO.count > 0 then
				arg0_12:setDestroyCount(1)
			end
		end, SFX_PANEL)
		onButton(arg0_12, arg0_12.defaultRevertBtn, function()
			triggerToggle(arg0_12.toggles.revertPanel, true)

			if not arg0_12.initRevertPanel then
				arg0_12:initAndSetBtn(var0_0.PANEL_REVERT)
			end

			arg0_12:updateRevertPanel()
		end, SFX_PANEL)
	elseif arg1_12 == EquipmentInfoMediator.TYPE_REPLACE then
		arg0_12.replaceSrcEquipTF = arg0_12.replacePanel:Find("equipment") or arg0_12:cloneSampleTo(arg0_12.replacePanel, var0_0.Left, "equipment")
		arg0_12.replaceDstEquipTF = arg0_12.replacePanel:Find("equipment_on_ship") or arg0_12:cloneSampleTo(arg0_12.replacePanel, var0_0.Right, "equipment_on_ship")
		arg0_12.replaceCancelBtn = arg0_12.replacePanel:Find("actions/cancel_button")
		arg0_12.replaceConfirmBtn = arg0_12.replacePanel:Find("actions/action_button_2")

		onButton(arg0_12, arg0_12.replaceCancelBtn, function()
			if isActive(arg0_12.destroyPanel) then
				triggerToggle(arg0_12.toggles.defaultPanel, true)

				return
			end

			arg0_12:closeView()
		end, SFX_CANCEL)
		onButton(arg0_12, arg0_12.replaceConfirmBtn, function()
			local var0_19, var1_19 = arg0_12.shipVO:canEquipAtPos(arg0_12.equipmentVO, arg0_12.contextData.pos)

			if not var0_19 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentInfoLayer_error_canNotEquip", var1_19))

				return
			end

			if arg0_12.contextData.quickCallback then
				arg0_12.contextData.quickCallback()
				arg0_12:closeView()
			else
				arg0_12:emit(EquipmentInfoMediator.ON_EQUIP)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	elseif arg1_12 == EquipmentInfoMediator.TYPE_DISPLAY then
		arg0_12.displayEquipTF = arg0_12.displayPanel:Find("equipment") or arg0_12:cloneSampleTo(arg0_12.displayPanel, var0_0.Middle, "equipment")
		arg0_12.displayMoveBtn = arg0_12.displayPanel:Find("actions/move_button")
		arg0_12.defaultTransformTipBar = arg0_12.displayEquipTF:Find("transform_tip")

		if arg0_12.contextData.showTransformTip and not arg0_12.defaultTransformTipBar then
			local var2_12 = arg0_12.defaultPanel:Find("transform_tip")

			setParent(var2_12, arg0_12.displayEquipTF)

			local var3_12 = var2_12.sizeDelta

			var3_12.y = 0
			var2_12.sizeDelta = var3_12

			setAnchoredPosition(var2_12, Vector2.zero)

			arg0_12.defaultTransformTipBar = var2_12
		end

		onButton(arg0_12, arg0_12.displayMoveBtn, function()
			arg0_12:emit(EquipmentInfoMediator.ON_MOVE, arg0_12.shipVO.id)
		end)
	elseif arg1_12 == var0_0.PANEL_DESTROY then
		arg0_12.initDestroyPanel = true
		arg0_12.destroyEquipTF = arg0_12.destroyPanel:Find("equipment") or arg0_12:cloneSampleTo(arg0_12.destroyPanel, var0_0.Left, "equipment")
		arg0_12.destroyCounter = arg0_12.destroyPanel:Find("destroy")
		arg0_12.destroyValue = arg0_12.destroyCounter:Find("count/number_panel/value")
		arg0_12.destroyLeftButton = arg0_12.destroyCounter:Find("count/number_panel/left")
		arg0_12.destroyRightButton = arg0_12.destroyCounter:Find("count/number_panel/right")
		arg0_12.destroyBonusList = arg0_12.destroyCounter:Find("got/list")
		arg0_12.destroyBonusItem = arg0_12.destroyCounter:Find("got/item")
		arg0_12.destroyCancelBtn = arg0_12.destroyPanel:Find("actions/cancel_button")
		arg0_12.destroyConfirmBtn = arg0_12.destroyPanel:Find("actions/destroy_button")

		onButton(arg0_12, arg0_12.destroyLeftButton, function()
			arg0_12:setDestroyCount(arg0_12.destroyCount - 1)
		end, SFX_PANEL)
		onButton(arg0_12, arg0_12.destroyRightButton, function()
			arg0_12:setDestroyCount(arg0_12.destroyCount + 1)
		end, SFX_PANEL)
		onButton(arg0_12, arg0_12.destroyCounter:Find("count/max"), function()
			arg0_12:setDestroyCount(arg0_12.equipmentVO.count)
		end, SFX_PANEL)
		onButton(arg0_12, arg0_12.destroyCancelBtn, function()
			triggerToggle(arg0_12.toggles.defaultPanel, true)
		end, SFX_CANCEL)
		onButton(arg0_12, arg0_12.destroyConfirmBtn, function()
			if not arg0_12:checkOverGold(arg0_12.awards) then
				return
			end

			local var0_25 = {}

			if arg0_12.equipmentVO:isImportance() then
				table.insert(var0_25, function(arg0_26)
					arg0_12.equipDestroyConfirmWindow:Load()
					arg0_12.equipDestroyConfirmWindow:ActionInvoke("Show", {
						setmetatable({
							count = arg0_12.destroyCount
						}, {
							__index = arg0_12.equipmentVO
						})
					}, arg0_26)
				end)
			end

			seriesAsync(var0_25, function()
				arg0_12:emit(EquipmentInfoMediator.ON_DESTROY, arg0_12.destroyCount)
			end)
		end, SFX_UI_EQUIPMENT_RESOLVE)
	elseif arg1_12 == var0_0.PANEL_REVERT then
		arg0_12.initRevertPanel = true
		arg0_12.revertEquipTF = arg0_12.revertPanel:Find("equipment") or arg0_12:cloneSampleTo(arg0_12.revertPanel, var0_0.Left, "equipment")
		arg0_12.revertAwardContainer = arg0_12.revertPanel:Find("item_panel/got/list")
		arg0_12.revertCancelBtn = arg0_12.revertPanel:Find("actions/cancel_button")
		arg0_12.revertConfirmBtn = arg0_12.revertPanel:Find("actions/revert_button")
		arg0_12.itemTpl = arg0_12:getTpl("item_panel/got/item", arg0_12.revertPanel)

		onButton(arg0_12, arg0_12.revertCancelBtn, function()
			triggerToggle(arg0_12.toggles.defaultPanel, true)
		end, SFX_CANCEL)
		onButton(arg0_12, arg0_12.revertConfirmBtn, function()
			if not arg0_12:checkOverGold(arg0_12.awards) then
				return
			end

			local var0_29 = arg0_12.equipmentVO

			arg0_12:emit(EquipmentInfoMediator.ON_REVERT, var0_29.id)
		end, SFX_UI_EQUIPMENT_RESOLVE)
	end
end

function var0_0.updateOperation1(arg0_30)
	triggerToggle(arg0_30.toggles.defaultPanel, true)
	arg0_30:updateEquipmentPanel(arg0_30.defaultEquipTF, arg0_30.equipmentVO)
	setActive(arg0_30.defaultRevertBtn, not LOCK_EQUIP_REVERT and arg0_30.fromEquipmentView and arg0_30.equipmentVO:getConfig("level") > 1 and getProxy(BagProxy):getItemCountById(Item.REVERT_EQUIPMENT_ID) > 0)
	setActive(arg0_30.defaultReplaceBtn, false)
	setActive(arg0_30.defaultUnloadBtn, false)
	setActive(arg0_30.defaultDestroyBtn, arg0_30.contextData.destroy and arg0_30.equipmentVO.count > 0)
	arg0_30:UpdateTransformTipBar(arg0_30.equipmentVO)
end

function var0_0.updateOperation2(arg0_31)
	triggerToggle(arg0_31.toggles.defaultPanel, true)
	arg0_31:updateEquipmentPanel(arg0_31.defaultEquipTF, arg0_31.shipVO:getEquip(arg0_31.contextData.pos))
	setActive(arg0_31.defaultDestroyBtn, false)
	setActive(arg0_31.defaultReplaceBtn, true)
	setActive(arg0_31.defaultUnloadBtn, true)
	setActive(arg0_31.defaultRevertBtn, false)

	local var0_31 = arg0_31.defaultEquipTF:Find("head")

	setActive(var0_31, arg0_31.shipVO)

	if arg0_31.shipVO then
		setImageSprite(findTF(var0_31, "Image"), LoadSprite("qicon/" .. arg0_31.shipVO:getPainting()))
	end

	if arg0_31.defaultTransformTipBar then
		setActive(arg0_31.defaultTransformTipBar, false)
	end
end

function var0_0.updateOperation3(arg0_32)
	triggerToggle(arg0_32.toggles.replacePanel, true)

	local var0_32 = arg0_32.shipVO:getEquip(arg0_32.contextData.pos)

	if var0_32 then
		local var1_32 = var0_32:GetPropertiesInfo()
		local var2_32 = arg0_32.equipmentVO:GetPropertiesInfo()

		if EquipType.getCompareGroup(var0_32.configId) == EquipType.getCompareGroup(arg0_32.equipmentVO.configId) then
			Equipment.InsertAttrsCompare(var1_32.attrs, var2_32.attrs, arg0_32.shipVO)
		end

		arg0_32:updateEquipmentPanel(arg0_32.replaceSrcEquipTF, var0_32, var1_32)
		arg0_32:updateEquipmentPanel(arg0_32.replaceDstEquipTF, arg0_32.equipmentVO, var2_32)
	else
		arg0_32:updateEquipmentPanel(arg0_32.replaceSrcEquipTF, var0_32)
		arg0_32:updateEquipmentPanel(arg0_32.replaceDstEquipTF, arg0_32.equipmentVO)
	end

	local var3_32 = arg0_32.replaceDstEquipTF:Find("head")

	setActive(var3_32, arg0_32.oldShipVO)

	if arg0_32.oldShipVO then
		setImageSprite(findTF(var3_32, "Image"), LoadSprite("qicon/" .. arg0_32.oldShipVO:getPainting()))
	end
end

function var0_0.updateOperation4(arg0_33)
	triggerToggle(arg0_33.toggles.displayPanel, true)
	arg0_33:updateEquipmentPanel(arg0_33.displayEquipTF, arg0_33.equipmentVO)
	setActive(arg0_33.displayMoveBtn, arg0_33.shipVO)

	local var0_33 = arg0_33.displayEquipTF:Find("head")

	setActive(var0_33, arg0_33.shipVO)

	if arg0_33.shipVO then
		setImageSprite(findTF(var0_33, "Image"), LoadSprite("qicon/" .. arg0_33.shipVO:getPainting()))
	end

	arg0_33:UpdateTransformTipBar(arg0_33.equipmentVO)
end

function var0_0.updateRevertPanel(arg0_34)
	local var0_34 = arg0_34.equipmentVO:GetRootEquipment()
	local var1_34 = arg0_34.equipmentVO:GetPropertiesInfo()
	local var2_34 = var0_34:GetPropertiesInfo()

	Equipment.InsertAttrsCompare(var1_34.attrs, var2_34.attrs, arg0_34.shipVO)
	arg0_34:updateEquipmentPanel(arg0_34.revertEquipTF, var0_34, var2_34, arg0_34.equipmentVO:getConfig("level"))
	arg0_34:updateOperationAward(arg0_34.revertAwardContainer, arg0_34.itemTpl, arg0_34.equipmentVO:getRevertAwards())
end

function var0_0.updateDestroyCount(arg0_35)
	local var0_35 = arg0_35.destroyCount

	setText(arg0_35.destroyValue, var0_35)

	local var1_35 = {}
	local var2_35 = 0
	local var3_35 = arg0_35.equipmentVO:getConfig("destory_item") or {}
	local var4_35 = var2_35 + (arg0_35.equipmentVO:getConfig("destory_gold") or 0) * var0_35

	for iter0_35, iter1_35 in ipairs(var3_35) do
		table.insert(var1_35, {
			type = DROP_TYPE_ITEM,
			id = iter1_35[1],
			count = iter1_35[2] * var0_35
		})
	end

	table.insert(var1_35, {
		id = 1,
		type = DROP_TYPE_RESOURCE,
		count = var4_35
	})
	arg0_35:updateOperationAward(arg0_35.destroyBonusList, arg0_35.destroyBonusItem, var1_35)
end

function var0_0.updateOperationAward(arg0_36, arg1_36, arg2_36, arg3_36)
	arg0_36.awards = arg3_36

	if arg1_36.childCount == 0 then
		for iter0_36 = 1, #arg3_36 do
			cloneTplTo(arg2_36, arg1_36)
		end
	end

	for iter1_36 = 1, #arg3_36 do
		local var0_36 = arg1_36:GetChild(iter1_36 - 1)
		local var1_36 = arg3_36[iter1_36]

		updateDrop(var0_36, var1_36)
		onButton(arg0_36, var0_36, function()
			arg0_36:emit(var0_0.ON_DROP, var1_36)
		end, SFX_PANEL)
		setText(findTF(var0_36, "name_panel/name"), getText(findTF(var0_36, "name")))
		setText(findTF(var0_36, "name_panel/number"), " x " .. getText(findTF(var0_36, "icon_bg/count")))
		setActive(findTF(var0_36, "icon_bg/count"), false)
	end
end

function var0_0.updateEquipmentPanel(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	local var0_38 = arg1_38:Find("info")
	local var1_38 = arg1_38:Find("empty")

	setActive(var0_38, arg2_38)
	setActive(var1_38, not arg2_38)

	if arg2_38 then
		local var2_38 = findTF(var0_38, "name")

		setScrollText(findTF(var2_38, "mask/Text"), arg2_38:getConfig("name"))
		setActive(findTF(var2_38, "unique"), arg2_38:isUnique() and arg0_38.isShowUnique)

		local var3_38 = findTF(var0_38, "equip")

		setImageSprite(findTF(var3_38, "bg"), GetSpriteFromAtlas("ui/equipmentinfoui_atlas", "equip_bg_" .. EquipmentRarity.Rarity2Print(arg2_38:getConfig("rarity"))))
		updateEquipment(var3_38, arg2_38, {
			noIconColorful = true
		})
		setActive(findTF(var3_38, "revert_btn"), false)
		setActive(findTF(var3_38, "slv"), arg4_38 or arg2_38:getConfig("level") > 1)
		setText(findTF(var3_38, "slv/Text"), arg4_38 and arg4_38 - 1 or arg2_38:getConfig("level") - 1)
		setActive(findTF(var3_38, "slv/next"), arg4_38)
		setText(findTF(var3_38, "slv/next/Text"), arg2_38:getConfig("level") - 1)

		local var4_38 = var3_38:Find("tier")

		setActive(var4_38, arg2_38)

		local var5_38 = arg2_38:getConfig("tech") or 1

		eachChild(var4_38, function(arg0_39)
			setActive(arg0_39, tostring(var5_38) == arg0_39.gameObject.name)
		end)
		setImageSprite(findTF(var3_38, "title"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(arg2_38:getConfig("type"))))
		setText(var3_38:Find("speciality/Text"), arg2_38:getConfig("speciality") ~= "无" and arg2_38:getConfig("speciality") or i18n1("—"))
		updateEquipInfo(var0_38:Find("attributes/view/content"), arg3_38 or arg2_38:GetPropertiesInfo(), arg2_38:GetSkill(), arg0_38.shipVO)
	end
end

function var0_0.UpdateTransformTipBar(arg0_40, arg1_40)
	if not arg0_40.defaultTransformTipBar then
		return
	end

	local var0_40 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "EquipmentTransformTreeMediator")
	local var1_40 = EquipmentProxy.GetTransformTargets(Equipment.GetEquipRootStatic(arg1_40.id))

	setActive(arg0_40.defaultTransformTipBar, not LOCK_EQUIPMENT_TRANSFORM and var0_40 and #var1_40 > 0)

	if isActive(arg0_40.defaultTransformTipBar) then
		local var2_40 = pg.equip_upgrade_data

		UIItemList.StaticAlign(arg0_40.defaultTransformTipBar:Find("list"), arg0_40.defaultTransformTipBar:Find("list/transformTarget"), #var1_40, function(arg0_41, arg1_41, arg2_41)
			if arg0_41 == UIItemList.EventUpdate then
				setActive(arg2_41:Find("link"), arg1_41 > 0)

				local var0_41 = var2_40[var1_40[arg1_41 + 1]]
				local var1_41 = var0_41 and var0_41.target_id

				if not var1_41 then
					setActive(arg2_41, false)

					return
				end

				updateDrop(arg2_41:Find("item"), {
					type = DROP_TYPE_EQUIP,
					id = var1_41
				})
				onButton(arg0_40, arg2_41:Find("item"), function()
					local var0_42 = CreateShell(arg1_40)

					if arg0_40.shipVO then
						var0_42.shipId = arg0_40.shipVO.id
						var0_42.shipPos = arg0_40.contextData.pos
					end

					arg0_40:emit(EquipmentInfoMediator.OPEN_LAYER, Context.New({
						mediator = EquipmentTransformMediator,
						viewComponent = EquipmentTransformLayer,
						data = {
							fromStoreHouse = true,
							formulaId = var1_40[arg1_41 + 1],
							sourceEquipmentInstance = {
								type = DROP_TYPE_EQUIP,
								id = arg1_40.id,
								template = var0_42
							}
						}
					}))
				end, SFX_PANEL)
				arg2_41:Find("mask/name"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(var1_41).name)
			end
		end)
	end
end

function var0_0.cloneSampleTo(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43)
	local var0_43 = cloneTplTo(arg0_43.sample, arg1_43, arg3_43)

	var0_43.localPosition = Vector3.New(var0_0.pos[arg2_43][1], var0_0.pos[arg2_43][2], var0_0.pos[arg2_43][3])

	if arg4_43 then
		var0_43:SetSiblingIndex(arg4_43)
	end

	return var0_43
end

function var0_0.willExit(arg0_44)
	arg0_44.equipDestroyConfirmWindow:Destroy()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_44._tf)
end

function var0_0.onBackPressed(arg0_45)
	if arg0_45.equipDestroyConfirmWindow:isShowing() then
		arg0_45.equipDestroyConfirmWindow:Hide()

		return
	end

	if isActive(arg0_45.destroyPanel) then
		triggerToggle(arg0_45.toggles.defaultPanel, true)

		return
	end

	arg0_45:closeView()
end

return var0_0
