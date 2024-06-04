local var0 = class("EquipmentInfoLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "EquipmentInfoUI"
end

var0.PANEL_DESTROY = "Destroy"
var0.PANEL_REVERT = "Revert"
var0.Left = 1
var0.Middle = 2
var0.Right = 3
var0.pos = {
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

function var0.init(arg0)
	local var0 = {
		"default",
		"replace",
		"display",
		"destroy",
		"revert"
	}

	arg0.toggles = {}

	for iter0, iter1 in ipairs(var0) do
		arg0[iter1 .. "Panel"] = arg0:findTF(iter1)
		arg0.toggles[iter1 .. "Panel"] = arg0:findTF("toggle_controll/" .. iter1)
	end

	arg0.sample = arg0:findTF("sample")

	setActive(arg0.sample, false)
	setActive(arg0.defaultPanel:Find("transform_tip"), false)

	arg0.txtQuickEnable = findTF(arg0._tf, "txtQuickEnable")

	setText(arg0.txtQuickEnable, i18n("ship_equip_check"))

	arg0.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0._tf, arg0.event)
end

function var0.setEquipment(arg0, arg1)
	arg0.equipmentVO = arg1
end

function var0.setShip(arg0, arg1, arg2)
	arg0.shipVO = arg1
	arg0.oldShipVO = arg2
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.checkOverGold(arg0, arg1)
	local var0 = _.detect(arg1, function(arg0)
		return arg0.type == DROP_TYPE_RESOURCE and arg0.id == 1
	end).count or 0

	if arg0.player:GoldMax(var0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0.setDestroyCount(arg0, arg1)
	arg1 = math.clamp(arg1, 1, arg0.equipmentVO.count)

	if arg0.destroyCount ~= arg1 then
		arg0.destroyCount = arg1

		arg0:updateDestroyCount()
	end
end

function var0.didEnter(arg0)
	setActive(arg0.txtQuickEnable, arg0.contextData.quickFlag or false)

	local var0 = defaultValue(arg0.contextData.type, EquipmentInfoMediator.TYPE_DEFAULT)

	arg0.isShowUnique = table.contains(EquipmentInfoMediator.SHOW_UNIQUE, var0)

	onButton(arg0, arg0._tf:Find("bg"), function()
		if isActive(arg0.destroyPanel) then
			triggerToggle(arg0.toggles.defaultPanel, true)

			return
		end

		arg0:closeView()
	end, SOUND_BACK)
	arg0:initAndSetBtn(var0)

	if var0 == EquipmentInfoMediator.TYPE_DEFAULT then
		arg0:updateOperation1()
	elseif var0 == EquipmentInfoMediator.TYPE_SHIP then
		arg0:updateOperation2()
	elseif var0 == EquipmentInfoMediator.TYPE_REPLACE then
		arg0:updateOperation3()
	elseif var0 == EquipmentInfoMediator.TYPE_DISPLAY then
		arg0:updateOperation4()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, true, {
		weight = arg0:getWeightFromData()
	})
end

function var0.initAndSetBtn(arg0, arg1)
	if arg1 == EquipmentInfoMediator.TYPE_DEFAULT or arg1 == EquipmentInfoMediator.TYPE_SHIP then
		arg0.defaultEquipTF = arg0:findTF("equipment", arg0.defaultPanel) or arg0:cloneSampleTo(arg0.defaultPanel, var0.Middle, "equipment")
		arg0.defaultReplaceBtn = arg0:findTF("actions/action_button_3", arg0.defaultPanel)
		arg0.defaultDestroyBtn = arg0:findTF("actions/action_button_1", arg0.defaultPanel)
		arg0.defaultEnhanceBtn = arg0:findTF("actions/action_button_2", arg0.defaultPanel)
		arg0.defaultUnloadBtn = arg0:findTF("actions/action_button_4", arg0.defaultPanel)
		arg0.defaultRevertBtn = arg0:findTF("info/equip/revert_btn", arg0.defaultEquipTF)
		arg0.defaultTransformTipBar = arg0:findTF("transform_tip", arg0.defaultEquipTF)

		if arg1 == EquipmentInfoMediator.TYPE_DEFAULT and not arg0.defaultTransformTipBar then
			local var0 = arg0.defaultPanel:Find("transform_tip")

			setParent(var0, arg0.defaultEquipTF)

			local var1 = var0.sizeDelta

			var1.y = 0
			var0.sizeDelta = var1

			setAnchoredPosition(var0, Vector2.zero)

			arg0.defaultTransformTipBar = var0
		end

		onButton(arg0, arg0.defaultReplaceBtn, function()
			local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0.shipVO)

			if not var0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)

				return
			end

			arg0:emit(EquipmentInfoMediator.ON_CHANGE)
		end, SFX_PANEL)
		onButton(arg0, arg0.defaultEnhanceBtn, function()
			if arg0.shipVO then
				local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0.shipVO)

				if not var0 then
					pg.TipsMgr.GetInstance():ShowTips(var1)

					return
				end
			end

			arg0:emit(EquipmentInfoMediator.ON_INTENSIFY)
		end, SFX_PANEL)
		onButton(arg0, arg0.defaultUnloadBtn, function()
			local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0.shipVO)

			if not var0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)

				return
			end

			arg0:emit(EquipmentInfoMediator.ON_UNEQUIP)
		end, SFX_UI_DOCKYARD_EQUIPOFF)
		onButton(arg0, arg0.defaultDestroyBtn, function()
			triggerToggle(arg0.toggles.destroyPanel, true)

			if not arg0.initDestroyPanel then
				arg0:initAndSetBtn(var0.PANEL_DESTROY)
			end

			arg0:updateEquipmentPanel(arg0.destroyEquipTF, arg0.equipmentVO)

			if arg0.equipmentVO.count > 0 then
				arg0:setDestroyCount(1)
			end
		end, SFX_PANEL)
		onButton(arg0, arg0.defaultRevertBtn, function()
			triggerToggle(arg0.toggles.revertPanel, true)

			if not arg0.initRevertPanel then
				arg0:initAndSetBtn(var0.PANEL_REVERT)
			end

			arg0:updateRevertPanel()
		end, SFX_PANEL)
	elseif arg1 == EquipmentInfoMediator.TYPE_REPLACE then
		arg0.replaceSrcEquipTF = arg0:findTF("equipment", arg0.replacePanel) or arg0:cloneSampleTo(arg0.replacePanel, var0.Left, "equipment")
		arg0.replaceDstEquipTF = arg0:findTF("equipment_on_ship", arg0.replacePanel) or arg0:cloneSampleTo(arg0.replacePanel, var0.Right, "equipment_on_ship")
		arg0.replaceCancelBtn = arg0:findTF("actions/cancel_button", arg0.replacePanel)
		arg0.replaceConfirmBtn = arg0:findTF("actions/action_button_2", arg0.replacePanel)

		onButton(arg0, arg0.replaceCancelBtn, function()
			if isActive(arg0.destroyPanel) then
				triggerToggle(arg0.toggles.defaultPanel, true)

				return
			end

			arg0:closeView()
		end, SFX_CANCEL)
		onButton(arg0, arg0.replaceConfirmBtn, function()
			local var0, var1 = arg0.shipVO:canEquipAtPos(arg0.equipmentVO, arg0.contextData.pos)

			if not var0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_equipmentInfoLayer_error_canNotEquip", var1))

				return
			end

			if arg0.contextData.quickCallback then
				arg0.contextData.quickCallback()
				arg0:closeView()
			else
				arg0:emit(EquipmentInfoMediator.ON_EQUIP)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	elseif arg1 == EquipmentInfoMediator.TYPE_DISPLAY then
		arg0.displayEquipTF = arg0:findTF("equipment", arg0.displayPanel) or arg0:cloneSampleTo(arg0.displayPanel, var0.Middle, "equipment")
		arg0.displayMoveBtn = arg0:findTF("actions/move_button", arg0.displayPanel)
		arg0.defaultTransformTipBar = arg0:findTF("transform_tip", arg0.displayEquipTF)

		if arg0.contextData.showTransformTip and not arg0.defaultTransformTipBar then
			local var2 = arg0.defaultPanel:Find("transform_tip")

			setParent(var2, arg0.displayEquipTF)

			local var3 = var2.sizeDelta

			var3.y = 0
			var2.sizeDelta = var3

			setAnchoredPosition(var2, Vector2.zero)

			arg0.defaultTransformTipBar = var2
		end

		onButton(arg0, arg0.displayMoveBtn, function()
			arg0:emit(EquipmentInfoMediator.ON_MOVE, arg0.shipVO.id)
		end)
	elseif arg1 == var0.PANEL_DESTROY then
		arg0.initDestroyPanel = true
		arg0.destroyEquipTF = arg0:findTF("equipment", arg0.destroyPanel) or arg0:cloneSampleTo(arg0.destroyPanel, var0.Left, "equipment")
		arg0.destroyCounter = arg0:findTF("destroy", arg0.destroyPanel)
		arg0.destroyValue = arg0:findTF("count/number_panel/value", arg0.destroyCounter)
		arg0.destroyLeftButton = arg0:findTF("count/number_panel/left", arg0.destroyCounter)
		arg0.destroyRightButton = arg0:findTF("count/number_panel/right", arg0.destroyCounter)
		arg0.destroyBonusList = arg0:findTF("got/list", arg0.destroyCounter)
		arg0.destroyBonusItem = arg0:findTF("got/item", arg0.destroyCounter)
		arg0.destroyCancelBtn = arg0:findTF("actions/cancel_button", arg0.destroyPanel)
		arg0.destroyConfirmBtn = arg0:findTF("actions/destroy_button", arg0.destroyPanel)

		onButton(arg0, arg0.destroyLeftButton, function()
			arg0:setDestroyCount(arg0.destroyCount - 1)
		end, SFX_PANEL)
		onButton(arg0, arg0.destroyRightButton, function()
			arg0:setDestroyCount(arg0.destroyCount + 1)
		end, SFX_PANEL)
		onButton(arg0, arg0:findTF("count/max", arg0.destroyCounter), function()
			arg0:setDestroyCount(arg0.equipmentVO.count)
		end, SFX_PANEL)
		onButton(arg0, arg0.destroyCancelBtn, function()
			triggerToggle(arg0.toggles.defaultPanel, true)
		end, SFX_CANCEL)
		onButton(arg0, arg0.destroyConfirmBtn, function()
			if not arg0:checkOverGold(arg0.awards) then
				return
			end

			local var0 = {}

			if arg0.equipmentVO:isImportance() then
				table.insert(var0, function(arg0)
					arg0.equipDestroyConfirmWindow:Load()
					arg0.equipDestroyConfirmWindow:ActionInvoke("Show", {
						setmetatable({
							count = arg0.destroyCount
						}, {
							__index = arg0.equipmentVO
						})
					}, arg0)
				end)
			end

			seriesAsync(var0, function()
				arg0:emit(EquipmentInfoMediator.ON_DESTROY, arg0.destroyCount)
			end)
		end, SFX_UI_EQUIPMENT_RESOLVE)
	elseif arg1 == var0.PANEL_REVERT then
		arg0.initRevertPanel = true
		arg0.revertEquipTF = arg0:findTF("equipment", arg0.revertPanel) or arg0:cloneSampleTo(arg0.revertPanel, var0.Left, "equipment")
		arg0.revertAwardContainer = arg0:findTF("item_panel/got/list", arg0.revertPanel)
		arg0.revertCancelBtn = arg0:findTF("actions/cancel_button", arg0.revertPanel)
		arg0.revertConfirmBtn = arg0:findTF("actions/revert_button", arg0.revertPanel)
		arg0.itemTpl = arg0:getTpl("item_panel/got/item", arg0.revertPanel)

		onButton(arg0, arg0.revertCancelBtn, function()
			triggerToggle(arg0.toggles.defaultPanel, true)
		end, SFX_CANCEL)
		onButton(arg0, arg0.revertConfirmBtn, function()
			if not arg0:checkOverGold(arg0.awards) then
				return
			end

			local var0 = arg0.equipmentVO

			arg0:emit(EquipmentInfoMediator.ON_REVERT, var0.id)
		end, SFX_UI_EQUIPMENT_RESOLVE)
	end
end

function var0.updateOperation1(arg0)
	triggerToggle(arg0.toggles.defaultPanel, true)
	arg0:updateEquipmentPanel(arg0.defaultEquipTF, arg0.equipmentVO)
	setActive(arg0.defaultRevertBtn, not LOCK_EQUIP_REVERT and arg0.fromEquipmentView and arg0.equipmentVO:getConfig("level") > 1 and getProxy(BagProxy):getItemCountById(Item.REVERT_EQUIPMENT_ID) > 0)
	setActive(arg0.defaultReplaceBtn, false)
	setActive(arg0.defaultUnloadBtn, false)
	setActive(arg0.defaultDestroyBtn, arg0.contextData.destroy and arg0.equipmentVO.count > 0)
	arg0:UpdateTransformTipBar(arg0.equipmentVO)
end

function var0.updateOperation2(arg0)
	triggerToggle(arg0.toggles.defaultPanel, true)
	arg0:updateEquipmentPanel(arg0.defaultEquipTF, arg0.shipVO:getEquip(arg0.contextData.pos))
	setActive(arg0.defaultDestroyBtn, false)
	setActive(arg0.defaultReplaceBtn, true)
	setActive(arg0.defaultUnloadBtn, true)
	setActive(arg0.defaultRevertBtn, false)

	local var0 = arg0:findTF("head", arg0.defaultEquipTF)

	setActive(var0, arg0.shipVO)

	if arg0.shipVO then
		setImageSprite(findTF(var0, "Image"), LoadSprite("qicon/" .. arg0.shipVO:getPainting()))
	end

	if arg0.defaultTransformTipBar then
		setActive(arg0.defaultTransformTipBar, false)
	end
end

function var0.updateOperation3(arg0)
	triggerToggle(arg0.toggles.replacePanel, true)

	local var0 = arg0.shipVO:getEquip(arg0.contextData.pos)

	if var0 then
		local var1 = var0:GetPropertiesInfo()
		local var2 = arg0.equipmentVO:GetPropertiesInfo()

		if EquipType.getCompareGroup(var0.configId) == EquipType.getCompareGroup(arg0.equipmentVO.configId) then
			Equipment.InsertAttrsCompare(var1.attrs, var2.attrs, arg0.shipVO)
		end

		arg0:updateEquipmentPanel(arg0.replaceSrcEquipTF, var0, var1)
		arg0:updateEquipmentPanel(arg0.replaceDstEquipTF, arg0.equipmentVO, var2)
	else
		arg0:updateEquipmentPanel(arg0.replaceSrcEquipTF, var0)
		arg0:updateEquipmentPanel(arg0.replaceDstEquipTF, arg0.equipmentVO)
	end

	local var3 = arg0:findTF("head", arg0.replaceDstEquipTF)

	setActive(var3, arg0.oldShipVO)

	if arg0.oldShipVO then
		setImageSprite(findTF(var3, "Image"), LoadSprite("qicon/" .. arg0.oldShipVO:getPainting()))
	end
end

function var0.updateOperation4(arg0)
	triggerToggle(arg0.toggles.displayPanel, true)
	arg0:updateEquipmentPanel(arg0.displayEquipTF, arg0.equipmentVO)
	setActive(arg0.displayMoveBtn, arg0.shipVO)

	local var0 = arg0:findTF("head", arg0.displayEquipTF)

	setActive(var0, arg0.shipVO)

	if arg0.shipVO then
		setImageSprite(findTF(var0, "Image"), LoadSprite("qicon/" .. arg0.shipVO:getPainting()))
	end

	arg0:UpdateTransformTipBar(arg0.equipmentVO)
end

function var0.updateRevertPanel(arg0)
	local var0 = arg0.equipmentVO:GetRootEquipment()
	local var1 = arg0.equipmentVO:GetPropertiesInfo()
	local var2 = var0:GetPropertiesInfo()

	Equipment.InsertAttrsCompare(var1.attrs, var2.attrs, arg0.shipVO)
	arg0:updateEquipmentPanel(arg0.revertEquipTF, var0, var2, arg0.equipmentVO:getConfig("level"))
	arg0:updateOperationAward(arg0.revertAwardContainer, arg0.itemTpl, arg0.equipmentVO:getRevertAwards())
end

function var0.updateDestroyCount(arg0)
	local var0 = arg0.destroyCount

	setText(arg0.destroyValue, var0)

	local var1 = {}
	local var2 = 0
	local var3 = arg0.equipmentVO:getConfig("destory_item") or {}
	local var4 = var2 + (arg0.equipmentVO:getConfig("destory_gold") or 0) * var0

	for iter0, iter1 in ipairs(var3) do
		table.insert(var1, {
			type = DROP_TYPE_ITEM,
			id = iter1[1],
			count = iter1[2] * var0
		})
	end

	table.insert(var1, {
		id = 1,
		type = DROP_TYPE_RESOURCE,
		count = var4
	})
	arg0:updateOperationAward(arg0.destroyBonusList, arg0.destroyBonusItem, var1)
end

function var0.updateOperationAward(arg0, arg1, arg2, arg3)
	arg0.awards = arg3

	if arg1.childCount == 0 then
		for iter0 = 1, #arg3 do
			cloneTplTo(arg2, arg1)
		end
	end

	for iter1 = 1, #arg3 do
		local var0 = arg1:GetChild(iter1 - 1)
		local var1 = arg3[iter1]

		updateDrop(var0, var1)
		onButton(arg0, var0, function()
			arg0:emit(var0.ON_DROP, var1)
		end, SFX_PANEL)
		setText(findTF(var0, "name_panel/name"), getText(findTF(var0, "name")))
		setText(findTF(var0, "name_panel/number"), " x " .. getText(findTF(var0, "icon_bg/count")))
		setActive(findTF(var0, "icon_bg/count"), false)
	end
end

function var0.updateEquipmentPanel(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:findTF("info", arg1)
	local var1 = arg0:findTF("empty", arg1)

	setActive(var0, arg2)
	setActive(var1, not arg2)

	if arg2 then
		local var2 = findTF(var0, "name")

		setScrollText(findTF(var2, "mask/Text"), arg2:getConfig("name"))
		setActive(findTF(var2, "unique"), arg2:isUnique() and arg0.isShowUnique)

		local var3 = findTF(var0, "equip")

		setImageSprite(findTF(var3, "bg"), GetSpriteFromAtlas("ui/equipmentinfoui_atlas", "equip_bg_" .. EquipmentRarity.Rarity2Print(arg2:getConfig("rarity"))))
		updateEquipment(var3, arg2, {
			noIconColorful = true
		})
		setActive(findTF(var3, "revert_btn"), false)
		setActive(findTF(var3, "slv"), arg4 or arg2:getConfig("level") > 1)
		setText(findTF(var3, "slv/Text"), arg4 and arg4 - 1 or arg2:getConfig("level") - 1)
		setActive(findTF(var3, "slv/next"), arg4)
		setText(findTF(var3, "slv/next/Text"), arg2:getConfig("level") - 1)

		local var4 = arg0:findTF("tier", var3)

		setActive(var4, arg2)

		local var5 = arg2:getConfig("tech") or 1

		eachChild(var4, function(arg0)
			setActive(arg0, tostring(var5) == arg0.gameObject.name)
		end)
		setImageSprite(findTF(var3, "title"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(arg2:getConfig("type"))))
		setText(var3:Find("speciality/Text"), arg2:getConfig("speciality") ~= "无" and arg2:getConfig("speciality") or i18n1("—"))
		updateEquipInfo(var0:Find("attributes/view/content"), arg3 or arg2:GetPropertiesInfo(), arg2:GetSkill(), arg0.shipVO)
	end
end

function var0.UpdateTransformTipBar(arg0, arg1)
	if not arg0.defaultTransformTipBar then
		return
	end

	local var0 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "EquipmentTransformTreeMediator")
	local var1 = EquipmentProxy.GetTransformTargets(Equipment.GetEquipRootStatic(arg1.id))

	setActive(arg0.defaultTransformTipBar, not LOCK_EQUIPMENT_TRANSFORM and var0 and #var1 > 0)

	if isActive(arg0.defaultTransformTipBar) then
		local var2 = pg.equip_upgrade_data

		UIItemList.StaticAlign(arg0.defaultTransformTipBar:Find("list"), arg0.defaultTransformTipBar:Find("list/transformTarget"), #var1, function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				setActive(arg2:Find("link"), arg1 > 0)

				local var0 = var2[var1[arg1 + 1]]
				local var1 = var0 and var0.target_id

				if not var1 then
					setActive(arg2, false)

					return
				end

				updateDrop(arg2:Find("item"), {
					type = DROP_TYPE_EQUIP,
					id = var1
				})
				onButton(arg0, arg2:Find("item"), function()
					local var0 = CreateShell(arg1)

					if arg0.shipVO then
						var0.shipId = arg0.shipVO.id
						var0.shipPos = arg0.contextData.pos
					end

					arg0:emit(EquipmentInfoMediator.OPEN_LAYER, Context.New({
						mediator = EquipmentTransformMediator,
						viewComponent = EquipmentTransformLayer,
						data = {
							fromStoreHouse = true,
							formulaId = var1[arg1 + 1],
							sourceEquipmentInstance = {
								type = DROP_TYPE_EQUIP,
								id = arg1.id,
								template = var0
							}
						}
					}))
				end, SFX_PANEL)
				arg2:Find("mask/name"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(var1).name)
			end
		end)
	end
end

function var0.cloneSampleTo(arg0, arg1, arg2, arg3, arg4)
	local var0 = cloneTplTo(arg0.sample, arg1, arg3)

	var0.localPosition = Vector3.New(var0.pos[arg2][1], var0.pos[arg2][2], var0.pos[arg2][3])

	if arg4 then
		var0:SetSiblingIndex(arg4)
	end

	return var0
end

function var0.willExit(arg0)
	arg0.equipDestroyConfirmWindow:Destroy()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.onBackPressed(arg0)
	if arg0.equipDestroyConfirmWindow:isShowing() then
		arg0.equipDestroyConfirmWindow:Hide()

		return
	end

	if isActive(arg0.destroyPanel) then
		triggerToggle(arg0.toggles.defaultPanel, true)

		return
	end

	arg0:closeView()
end

return var0
