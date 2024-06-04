local var0 = class("ShipEquipView", import("...base.BaseSubView"))

var0.UNLOCK_EQUIPMENT_SKIN_POS = {
	1,
	2,
	3,
	4,
	5
}

function var0.getUIName(arg0)
	return "ShipEquipView"
end

function var0.OnInit(arg0)
	arg0:InitEquipment()
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

function var0.UpdateUI(arg0)
	local var0 = arg0:GetShipVO()

	arg0:UpdateEquipments(var0)
end

function var0.InitEquipment(arg0)
	arg0.mainPanel = arg0._parentTf.parent
	arg0.equipRCon = arg0._parentTf:Find("equipment_r_container")
	arg0.equipLCon = arg0._parentTf:Find("equipment_l_container")
	arg0.equipBCon = arg0._parentTf:Find("equipment_b_container")
	arg0.equipmentR = arg0:findTF("equipment_r")
	arg0.equipmentL = arg0:findTF("equipment_l")
	arg0.equipmentB = arg0:findTF("equipment_b")
	arg0.equipmentR1 = arg0.equipmentR:Find("equipment/equipment_r1")
	arg0.equipmentR2 = arg0.equipmentR:Find("equipment/equipment_r2")
	arg0.equipmentR3 = arg0.equipmentR:Find("equipment/equipment_r3")
	arg0.equipmentL1 = arg0.equipmentL:Find("equipment/equipment_l1")
	arg0.equipmentL2 = arg0.equipmentL:Find("equipment/equipment_l2")
	arg0.equipSkinBtn = arg0.equipmentR:Find("equipment_skin_btn")
	arg0.equipmentB1 = arg0.equipmentB:Find("equipment")
	arg0.resource = arg0._tf:Find("resource")
	arg0.equipSkinLogicPanel = ShipEquipSkinLogicPanel.New(arg0._tf.gameObject)

	arg0.equipSkinLogicPanel:attach(arg0)
	arg0.equipSkinLogicPanel:setLabelResource(arg0.resource)
	setActive(arg0.equipSkinLogicPanel._go, true)
	setParent(arg0.equipmentR, arg0.equipRCon)
	setParent(arg0.equipmentL, arg0.equipLCon)
	setParent(arg0.equipmentB, arg0.equipBCon)
	setActive(arg0.equipmentR, true)
	setActive(arg0.equipmentL, true)
	setActive(arg0.equipmentB, true)
	setActive(arg0.equipSkinBtn, true)

	arg0.equipmentPanels = {
		arg0.equipmentR1,
		arg0.equipmentR2,
		arg0.equipmentR3,
		arg0.equipmentL1,
		arg0.equipmentL2
	}
	arg0.onSelected = false
end

function var0.InitEvent(arg0)
	onButton(arg0, arg0.equipSkinBtn, function()
		local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0:GetShipVO())

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		arg0:switch2EquipmentSkinPage()
	end)

	if arg0.contextData.isInEquipmentSkinPage then
		arg0.contextData.isInEquipmentSkinPage = nil

		triggerButton(arg0.equipSkinBtn)
	end
end

function var0.OnSelected(arg0, arg1)
	local var0 = pg.UIMgr.GetInstance()

	if arg1 then
		local var1 = {}
		local var2 = {}
		local var3 = {}

		local function var4(arg0, arg1)
			eachChild(arg0, function(arg0)
				table.insert(arg1, arg0)
			end)
		end

		var4(arg0.equipmentR:Find("skin"), var2)
		var4(arg0.equipmentR:Find("equipment"), var2)
		var4(arg0.equipmentL:Find("skin"), var1)
		var4(arg0.equipmentL:Find("equipment"), var1)
		var4(arg0.equipmentB, var3)
		table.insert(var1, arg0.equipmentL:Find("equipment/equipment_l1"))
		var0:OverlayPanelPB(arg0.equipRCon, {
			pbList = var2,
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT,
			weight = LayerWeightConst.LOWER_LAYER
		})
		var0:OverlayPanelPB(arg0.equipLCon, {
			pbList = var1,
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT,
			weight = LayerWeightConst.LOWER_LAYER
		})
		var0:OverlayPanelPB(arg0.equipBCon, {
			pbList = var3,
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT,
			weight = LayerWeightConst.LOWER_LAYER
		})
	else
		var0:UnOverlayPanel(arg0.equipRCon, arg0._parentTf)
		var0:UnOverlayPanel(arg0.equipLCon, arg0._parentTf)
		var0:UnOverlayPanel(arg0.equipBCon, arg0._parentTf)
	end

	arg0.onSelected = arg1
end

function var0.UpdateEquipments(arg0, arg1)
	local var0 = arg1:getActiveEquipments()

	for iter0, iter1 in ipairs(arg1.equipments) do
		local var1 = var0[iter0]

		arg0:UpdateEquipmentPanel(iter0, iter1, var1)
	end

	if arg0.equipSkinLogicPanel then
		arg0.equipSkinLogicPanel:updateAll(arg1)
	end

	if arg0.contextData.openEquipUpgrade == true then
		arg0.contextData.openEquipUpgrade = false

		local var2 = 0
		local var3 = arg0:GetShipVO().equipments

		for iter2, iter3 in ipairs(var3) do
			if iter3 then
				var2 = var2 + 1
			end
		end

		if var2 > 0 then
			arg0:emit(ShipMainMediator.OPEN_EQUIP_UPGRADE, arg0:GetShipVO().id)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("fightfail_noequip"))
		end
	end

	setActive(arg0.equipmentB, arg1:IsSpweaponUnlock() and not LOCK_SP_WEAPON)

	local var4 = arg1:GetSpWeapon()

	arg0:UpdateSpWeaponPanel(var4)
end

function var0.UpdateEquipmentPanel(arg0, arg1, arg2, arg3)
	local var0 = arg0.equipmentPanels[arg1]
	local var1 = findTF(var0, "info")
	local var2 = findTF(var0, "empty")
	local var3 = findTF(var1, "efficiency")

	setActive(var1, arg2)
	setActive(var2, not arg2)

	local var4 = arg0:GetShipVO()
	local var5 = {}

	for iter0, iter1 in pairs(var4.skills) do
		local var6 = ys.Battle.BattleDataFunction.GetBuffTemplate(iter1.id, iter1.level)

		if var6.shipInfoScene and var6.shipInfoScene.equip then
			for iter2, iter3 in ipairs(var6.shipInfoScene.equip) do
				table.insert(var5, iter3)
			end
		end
	end

	local var7 = var4:GetSpWeapon()

	if var7 and var7:GetEffect() ~= 0 then
		local var8 = var7:GetEffect()
		local var9 = ys.Battle.BattleDataFunction.GetBuffTemplate(var8, 1)

		if var9.shipInfoScene and var9.shipInfoScene.equip then
			for iter4, iter5 in ipairs(var9.shipInfoScene.equip) do
				table.insert(var5, iter5)
			end
		end
	end

	local var10 = findTF(var0, "panel_title/type")
	local var11 = findTF(var0, "skin_icon")

	if var11 then
		setActive(var11, arg2 and arg2:hasSkin())
	end

	local var12 = EquipType.Types2Title(arg1, var4.configId)
	local var13 = EquipType.LabelToName(var12)

	var10:GetComponent(typeof(Text)).text = var13

	if arg2 then
		setActive(var3, not arg2:isDevice())

		if not arg2:isDevice() then
			local var14 = pg.ship_data_statistics[var4.configId]
			local var15 = var4:getEquipProficiencyByPos(arg1)
			local var16 = var15 and var15 * 100 or 0
			local var17 = false

			if not (var4:getFlag("inWorld") and arg0.contextData.fromMediatorName == WorldMediator.__cname and WorldConst.FetchWorldShip(var4.id):IsBroken()) then
				for iter6, iter7 in ipairs(var5) do
					if arg0:equipmentCheck(iter7) and arg0.equipmentEnhance(iter7, arg2) then
						var16 = var16 + iter7.number
						var17 = true
					end
				end
			end

			if var16 - calcFloor(var16) > 1e-09 then
				var16 = string.format("%.1f", var16)
				GetComponent(findTF(var3, "Text"), typeof(Text)).fontSize = 45
			else
				GetComponent(findTF(var3, "Text"), typeof(Text)).fontSize = 50
			end

			setButtonText(var3, var17 and setColorStr(var16 .. "%", COLOR_GREEN) or var16 .. "%")
		end

		local var18 = arg0:findTF("IconTpl", var1)

		updateEquipment(var18, arg2)

		local var19 = arg2:getConfig("name")

		if arg2:getConfig("ammo_icon")[1] then
			setActive(findTF(var1, "cont/icon_ammo"), true)
			setImageSprite(findTF(var1, "cont/icon_ammo"), GetSpriteFromAtlas("ammo", arg2:getConfig("ammo_icon")[1]))
		else
			setActive(findTF(var1, "cont/icon_ammo"), false)
		end

		setScrollText(arg0.equipmentPanels[arg1]:Find("info/cont/name_mask/name"), var19)

		local var20 = var1:Find("attrs")

		eachChild(var20, function(arg0)
			setActive(arg0, false)
		end)

		local var21 = arg2:GetPropertiesInfo().attrs
		local var22 = underscore.filter(var21, function(arg0)
			return not arg0.type or arg0.type ~= AttributeType.AntiSiren
		end)
		local var23 = arg2:getConfig("skill_id")[1]
		local var24 = var23 and arg2:isDevice() and {
			1,
			2,
			5
		} or {
			1,
			4,
			2,
			3
		}

		for iter8, iter9 in ipairs(var24) do
			local var25 = var20:Find("attr_" .. iter9)
			local var26 = findTF(var25, "panel")
			local var27 = findTF(var25, "lock")

			setActive(var25, true)

			if iter9 == 5 then
				setText(var26:Find("values/value"), "")

				local var28 = getSkillName(var23)

				if PLATFORM_CODE == PLATFORM_US and string.len(var28) > 15 then
					GetComponent(var26:Find("values/value_1"), typeof(Text)).fontSize = 24
				end

				setText(var26:Find("values/value_1"), getSkillName(var23))
				setActive(var27, false)
			elseif #var22 > 0 then
				local var29 = table.remove(var22, 1)

				if arg2:isAircraft() and var29.type == AttributeType.CD then
					var29 = var4:getAircraftReloadCD()
				end

				local var30, var31 = Equipment.GetInfoTrans(var29, var4)

				setText(var26:Find("tag"), var30)

				local var32 = string.split(tostring(var31), "/")

				if #var32 >= 2 then
					setText(var26:Find("values/value"), var32[1] .. "/")
					setText(var26:Find("values/value_1"), var32[2])
				else
					setText(var26:Find("values/value"), var31)
					setText(var26:Find("values/value_1"), "")
				end

				setActive(var27, false)
			else
				setText(var26:Find("tag"), "")
				setText(var26:Find("values/value"), "")
				setText(var26:Find("values/value_1"), "")
				setActive(var27, true)
			end
		end

		onButton(arg0, var0, function()
			arg0:emit(BaseUI.ON_EQUIPMENT, {
				type = EquipmentInfoMediator.TYPE_SHIP,
				shipId = var4.id,
				pos = arg1,
				LayerWeightMgr_weight = LayerWeightConst.SECOND_LAYER
			})
		end, SFX_UI_DOCKYARD_EQUIPADD)
	else
		onButton(arg0, var0, function()
			if var4 then
				local var0, var1 = ShipStatus.ShipStatusCheck("onModify", var4)

				if not var0 then
					pg.TipsMgr.GetInstance():ShowTips(var1)

					return
				end

				arg0:emit(ShipMainMediator.ON_SELECT_EQUIPMENT, arg1)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	end
end

function var0.equipmentCheck(arg0, arg1)
	if not arg0:GetShipVO() then
		return false
	end

	local var0 = arg1.check_type
	local var1 = arg1.check_indexList
	local var2 = arg1.check_label

	if not var0 and not var1 and not var2 then
		return true
	end

	local var3 = false
	local var4 = {}
	local var5 = Clone(arg0:GetShipVO().equipments)

	if var1 then
		local var6 = #var5

		while var6 > 0 do
			if not table.contains(var1, var6) then
				table.remove(var5, var6)
			end

			var6 = var6 - 1
		end
	end

	if var0 then
		local var7 = #var5

		while var7 > 0 do
			local var8 = var5[var7]

			if not var8 or not table.contains(var0, var8:getConfig("type")) then
				table.remove(var5, var7)
			end

			var7 = var7 - 1
		end
	end

	if var2 then
		local var9 = #var5

		while var9 > 0 do
			local var10 = var5[var9]

			if var10 then
				local var11 = 1

				for iter0, iter1 in ipairs(var2) do
					if not table.contains(var10:getConfig("label"), iter1) then
						var11 = var11 * 0
					end
				end

				if var11 == 0 then
					table.remove(var5, var9)
				end
			else
				table.remove(var5, var9)
			end

			var9 = var9 - 1
		end
	end

	return #var5 > 0
end

function var0.equipmentEnhance(arg0, arg1)
	local var0 = 1
	local var1 = arg1:getConfig("label")

	if arg0.label then
		var0 = 1

		for iter0, iter1 in ipairs(arg0.label) do
			if not table.contains(var1, iter1) then
				var0 = 0

				break
			end
		end
	end

	return var0 == 1
end

function var0.UpdateSpWeaponPanel(arg0, arg1)
	local var0 = arg0.equipmentB1
	local var1 = findTF(var0, "info")
	local var2 = findTF(var0, "empty")

	setActive(var1, arg1)
	setActive(var2, not arg1)

	local var3 = arg0:GetShipVO()

	assert(var3)

	if arg1 then
		UpdateSpWeaponSlot(var1, arg1, {
			20,
			20,
			20,
			20
		})

		local var4 = var1:Find("attrs")

		eachChild(var4, function(arg0)
			setActive(arg0, false)
		end)

		local var5 = arg1:GetPropertiesInfo().attrs
		local var6 = underscore.filter(var5, function(arg0)
			return not arg0.type or arg0.type ~= AttributeType.AntiSiren
		end)

		for iter0 = 1, 2 do
			local var7 = var4:GetChild(iter0 - 1)

			setActive(var7, true)

			if #var6 > 0 then
				local var8 = table.remove(var6, 1)
				local var9, var10 = Equipment.GetInfoTrans(var8, var3)

				setText(var7:Find("tag"), var9)
				setText(var7:Find("values/value"), var10)
				setText(var7:Find("values/value_1"), "")
			end
		end

		Canvas.ForceUpdateCanvases()

		local var11 = var1:Find("cont")

		;(function()
			local var0 = var11:GetChild(0)

			setText(var0:Find("tag"), i18n("spweapon_ui_effect_tag"))

			local var1 = arg1:GetEffect()

			setActive(var0, var1 and var1 > 0)

			if not var1 or not (var1 > 0) then
				return
			end

			setScrollText(var0:Find("value/Text"), getSkillName(var1))
		end)()
		;(function()
			local var0 = var11:GetChild(1)

			setText(var0:Find("tag"), i18n("spweapon_ui_skill_tag"))

			local var1 = arg1:GetActiveUpgradableSkill(var3)

			setActive(var0, var1 and var1 > 0)

			if not var1 or not (var1 > 0) then
				return
			end

			setScrollText(var0:Find("value/Text"), getSkillName(var1))
		end)()
		onButton(arg0, var0, function()
			arg0:emit(BaseUI.ON_SPWEAPON, {
				type = SpWeaponInfoLayer.TYPE_SHIP,
				shipId = var3.id
			})
		end, SFX_UI_DOCKYARD_EQUIPADD)
	else
		onButton(arg0, var0, function()
			if var3 then
				local var0, var1 = ShipStatus.ShipStatusCheck("onModify", var3)

				if not var0 then
					pg.TipsMgr.GetInstance():ShowTips(var1)

					return
				end

				arg0:emit(ShipMainMediator.ON_SELECT_SPWEAPON)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	end
end

function var0.switch2EquipmentSkinPage(arg0)
	if arg0.equipSkinLogicPanel:isTweening() then
		return
	end

	arg0.equipSkinLogicPanel:doSwitchAnim(arg0.contextData.isInEquipmentSkinPage)

	arg0.contextData.isInEquipmentSkinPage = not arg0.contextData.isInEquipmentSkinPage

	setActive(arg0.equipSkinBtn:Find("unsel"), not arg0.contextData.isInEquipmentSkinPage)
	setActive(arg0.equipSkinBtn:Find("sel"), arg0.contextData.isInEquipmentSkinPage)
	arg0.equipSkinLogicPanel:updateAll(arg0:GetShipVO())
end

function var0.OnDestroy(arg0)
	setParent(arg0.equipmentR, arg0._tf)
	setParent(arg0.equipmentL, arg0._tf)
	setParent(arg0.equipmentB, arg0._tf)

	arg0.shareData = nil
end

return var0
