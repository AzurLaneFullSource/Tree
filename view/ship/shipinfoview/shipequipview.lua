local var0_0 = class("ShipEquipView", import("...base.BaseSubView"))

var0_0.UNLOCK_EQUIPMENT_SKIN_POS = {
	1,
	2,
	3,
	4,
	5
}

function var0_0.getUIName(arg0_1)
	return "ShipEquipView"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ammo"
	}

	table.insertto(var0_2, var0_0.super.getResource(arg0_2))

	return var0_2
end

function var0_0.OnInit(arg0_3)
	arg0_3:InitEquipment()
end

function var0_0.SetShareData(arg0_4, arg1_4)
	arg0_4.shareData = arg1_4
end

function var0_0.GetShipVO(arg0_5)
	if arg0_5.shareData and arg0_5.shareData.shipVO then
		return arg0_5.shareData.shipVO
	end

	return nil
end

function var0_0.UpdateUI(arg0_6)
	local var0_6 = arg0_6:GetShipVO()

	arg0_6:UpdateEquipments(var0_6)
end

function var0_0.InitEquipment(arg0_7)
	arg0_7.mainPanel = arg0_7._parentTf.parent
	arg0_7.equipRCon = arg0_7._parentTf:Find("equipment_r_container")
	arg0_7.equipLCon = arg0_7._parentTf:Find("equipment_l_container")
	arg0_7.equipBCon = arg0_7._parentTf:Find("equipment_b_container")
	arg0_7.equipmentR = arg0_7._tf:Find("equipment_r")
	arg0_7.equipmentL = arg0_7._tf:Find("equipment_l")
	arg0_7.equipmentB = arg0_7._tf:Find("equipment_b")
	arg0_7.equipmentR1 = arg0_7.equipmentR:Find("equipment/equipment_r1")
	arg0_7.equipmentR2 = arg0_7.equipmentR:Find("equipment/equipment_r2")
	arg0_7.equipmentR3 = arg0_7.equipmentR:Find("equipment/equipment_r3")
	arg0_7.equipmentL1 = arg0_7.equipmentL:Find("equipment/equipment_l1")
	arg0_7.equipmentL2 = arg0_7.equipmentL:Find("equipment/equipment_l2")
	arg0_7.equipSkinBtn = arg0_7.equipmentR:Find("equipment_skin_btn")
	arg0_7.equipmentB1 = arg0_7.equipmentB:Find("equipment")
	arg0_7.resource = arg0_7._tf:Find("resource")
	arg0_7.equipSkinLogicPanel = ShipEquipSkinLogicPanel.New(arg0_7._tf.gameObject)

	arg0_7.equipSkinLogicPanel:attach(arg0_7)
	arg0_7.equipSkinLogicPanel:setLabelResource(arg0_7.resource)
	setActive(arg0_7.equipSkinLogicPanel._go, true)
	setParent(arg0_7.equipmentR, arg0_7.equipRCon)
	setParent(arg0_7.equipmentL, arg0_7.equipLCon)
	setParent(arg0_7.equipmentB, arg0_7.equipBCon)
	setActive(arg0_7.equipmentR, true)
	setActive(arg0_7.equipmentL, true)
	setActive(arg0_7.equipmentB, true)
	setActive(arg0_7.equipSkinBtn, true)

	arg0_7.equipmentPanels = {
		arg0_7.equipmentR1,
		arg0_7.equipmentR2,
		arg0_7.equipmentR3,
		arg0_7.equipmentL1,
		arg0_7.equipmentL2
	}
	arg0_7.onSelected = false
end

function var0_0.InitEvent(arg0_8)
	onButton(arg0_8, arg0_8.equipSkinBtn, function()
		local var0_9, var1_9 = ShipStatus.ShipStatusCheck("onModify", arg0_8:GetShipVO())

		if not var0_9 then
			pg.TipsMgr.GetInstance():ShowTips(var1_9)

			return
		end

		arg0_8:switch2EquipmentSkinPage()
	end)

	if arg0_8.contextData.isInEquipmentSkinPage then
		arg0_8.contextData.isInEquipmentSkinPage = nil

		triggerButton(arg0_8.equipSkinBtn)
	end
end

function var0_0.OnSelected(arg0_10, arg1_10)
	if arg1_10 then
		local var0_10 = {}
		local var1_10 = {}
		local var2_10 = {}

		local function var3_10(arg0_11, arg1_11)
			eachChild(arg0_11, function(arg0_12)
				table.insert(arg1_11, arg0_12)
			end)
		end

		var3_10(arg0_10.equipmentR:Find("skin"), var1_10)
		var3_10(arg0_10.equipmentR:Find("equipment"), var1_10)
		var3_10(arg0_10.equipmentL:Find("skin"), var0_10)
		var3_10(arg0_10.equipmentL:Find("equipment"), var0_10)
		var3_10(arg0_10.equipmentB, var2_10)
		table.insert(var0_10, arg0_10.equipmentL:Find("equipment/equipment_l1"))
		arg0_10:OverlayPanel(arg0_10.equipRCon, {
			groupDelta = -1,
			pbList = var1_10,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
		arg0_10:OverlayPanel(arg0_10.equipLCon, {
			groupDelta = -1,
			pbList = var0_10,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
		arg0_10:OverlayPanel(arg0_10.equipBCon, {
			groupDelta = -1,
			pbList = var2_10,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		arg0_10:UnOverlayPanel(arg0_10.equipRCon, arg0_10._parentTf)
		arg0_10:UnOverlayPanel(arg0_10.equipLCon, arg0_10._parentTf)
		arg0_10:UnOverlayPanel(arg0_10.equipBCon, arg0_10._parentTf)
	end

	arg0_10.onSelected = arg1_10
end

function var0_0.UpdateEquipments(arg0_13, arg1_13)
	local var0_13 = arg1_13:getActiveEquipments()

	for iter0_13, iter1_13 in ipairs(arg1_13.equipments) do
		local var1_13 = var0_13[iter0_13]

		arg0_13:UpdateEquipmentPanel(iter0_13, iter1_13, var1_13)
	end

	if arg0_13.equipSkinLogicPanel then
		arg0_13.equipSkinLogicPanel:updateAll(arg1_13)
	end

	if arg0_13.contextData.openEquipUpgrade == true then
		arg0_13.contextData.openEquipUpgrade = false

		local var2_13 = 0
		local var3_13 = arg0_13:GetShipVO().equipments

		for iter2_13, iter3_13 in ipairs(var3_13) do
			if iter3_13 then
				var2_13 = var2_13 + 1
			end
		end

		if var2_13 > 0 then
			arg0_13:emit(ShipMainMediator.OPEN_EQUIP_UPGRADE, arg0_13:GetShipVO().id)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("fightfail_noequip"))
		end
	end

	setActive(arg0_13.equipmentB, arg1_13:IsSpweaponUnlock() and not LOCK_SP_WEAPON)

	local var4_13 = arg1_13:GetSpWeapon()

	arg0_13:UpdateSpWeaponPanel(var4_13)
end

function var0_0.UpdateEquipmentPanel(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = arg0_14.equipmentPanels[arg1_14]
	local var1_14 = findTF(var0_14, "info")
	local var2_14 = findTF(var0_14, "empty")
	local var3_14 = findTF(var1_14, "efficiency")

	setActive(var1_14, arg2_14)
	setActive(var2_14, not arg2_14)

	local var4_14 = arg0_14:GetShipVO()
	local var5_14 = {}
	local var6_14 = {}
	local var7_14 = var4_14:GetSpWeapon()

	if var7_14 then
		local var8_14 = var7_14:GetUpgradableSkillInfo()

		for iter0_14, iter1_14 in ipairs(var8_14) do
			if iter1_14.unlock then
				table.insert(var6_14, var7_14:GetUpgradableSkillIds()[1][1])

				local var9_14 = iter1_14.skillId
				local var10_14 = ys.Battle.BattleDataFunction.GetBuffTemplate(var9_14, iter1_14.lv)

				if var10_14.shipInfoScene and var10_14.shipInfoScene.equip then
					for iter2_14, iter3_14 in ipairs(var10_14.shipInfoScene.equip) do
						table.insert(var5_14, iter3_14)
					end
				end
			end
		end
	end

	for iter4_14, iter5_14 in pairs(var4_14.skills) do
		if not table.contains(var6_14, iter5_14.id) then
			local var11_14 = ys.Battle.BattleDataFunction.GetBuffTemplate(iter5_14.id, iter5_14.level)

			if var11_14.shipInfoScene and var11_14.shipInfoScene.equip then
				for iter6_14, iter7_14 in ipairs(var11_14.shipInfoScene.equip) do
					table.insert(var5_14, iter7_14)
				end
			end
		end
	end

	if var7_14 and var7_14:GetEffect() ~= 0 then
		local var12_14 = var7_14:GetEffect()
		local var13_14 = ys.Battle.BattleDataFunction.GetBuffTemplate(var12_14, 1)

		if var13_14.shipInfoScene and var13_14.shipInfoScene.equip then
			for iter8_14, iter9_14 in ipairs(var13_14.shipInfoScene.equip) do
				table.insert(var5_14, iter9_14)
			end
		end
	end

	local var14_14 = findTF(var0_14, "panel_title/type")
	local var15_14 = findTF(var0_14, "skin_icon")

	if var15_14 then
		setActive(var15_14, arg2_14 and arg2_14:hasSkin())
	end

	local var16_14 = EquipType.Types2Title(arg1_14, var4_14.configId)
	local var17_14 = EquipType.LabelToName(var16_14)

	var14_14:GetComponent(typeof(Text)).text = var17_14

	if arg2_14 then
		setActive(var3_14, not arg2_14:isDevice())

		if not arg2_14:isDevice() then
			local var18_14 = pg.ship_data_statistics[var4_14.configId]
			local var19_14 = var4_14:getEquipProficiencyByPos(arg1_14)
			local var20_14 = var19_14 and var19_14 * 100 or 0
			local var21_14 = false

			if not (var4_14:getFlag("inWorld") and arg0_14.contextData.fromMediatorName == WorldMediator.__cname and WorldConst.FetchWorldShip(var4_14.id):IsBroken()) then
				for iter10_14, iter11_14 in ipairs(var5_14) do
					print(arg0_14:equipmentCheck(iter11_14), arg0_14.equipmentEnhance(iter11_14, arg2_14))

					if arg0_14:equipmentCheck(iter11_14) and arg0_14.equipmentEnhance(iter11_14, arg2_14) then
						var20_14 = var20_14 + iter11_14.number
						var21_14 = true
					end
				end
			end

			if var20_14 - calcFloor(var20_14) > 1e-09 then
				var20_14 = string.format("%.1f", var20_14)
				GetComponent(findTF(var3_14, "Text"), typeof(Text)).fontSize = 45
			else
				GetComponent(findTF(var3_14, "Text"), typeof(Text)).fontSize = 50
			end

			setButtonText(var3_14, var21_14 and setColorStr(var20_14 .. "%", COLOR_GREEN) or var20_14 .. "%")
		end

		local var22_14 = var1_14:Find("IconTpl")

		updateEquipment(var22_14, arg2_14)

		local var23_14 = arg2_14:getConfig("name")

		if arg2_14:getConfig("ammo_icon")[1] then
			setActive(findTF(var1_14, "cont/icon_ammo"), true)
			setImageSprite(findTF(var1_14, "cont/icon_ammo"), GetSpriteFromAtlas("ammo", arg2_14:getConfig("ammo_icon")[1]))
		else
			setActive(findTF(var1_14, "cont/icon_ammo"), false)
		end

		setScrollText(arg0_14.equipmentPanels[arg1_14]:Find("info/cont/name_mask/name"), var23_14)

		local var24_14 = var1_14:Find("attrs")

		eachChild(var24_14, function(arg0_15)
			setActive(arg0_15, false)
		end)

		local var25_14 = arg2_14:GetPropertiesInfo().attrs
		local var26_14 = underscore.filter(var25_14, function(arg0_16)
			return not arg0_16.type or arg0_16.type ~= AttributeType.AntiSiren
		end)
		local var27_14 = arg2_14:getConfig("skill_id")
		local var28_14 = var27_14[1] and var27_14[1][1]
		local var29_14 = var28_14 and arg2_14:isDevice() and {
			1,
			2,
			5
		} or {
			1,
			4,
			2,
			3
		}

		for iter12_14, iter13_14 in ipairs(var29_14) do
			local var30_14 = var24_14:Find("attr_" .. iter13_14)
			local var31_14 = findTF(var30_14, "panel")
			local var32_14 = findTF(var30_14, "lock")

			setActive(var30_14, true)

			if iter13_14 == 5 then
				setText(var31_14:Find("values/value"), "")

				local var33_14 = getSkillName(var28_14)

				if PLATFORM_CODE == PLATFORM_US and string.len(var33_14) > 15 then
					GetComponent(var31_14:Find("values/value_1"), typeof(Text)).fontSize = 24
				end

				setText(var31_14:Find("values/value_1"), getSkillName(var28_14))
				setActive(var32_14, false)
			elseif #var26_14 > 0 then
				local var34_14 = table.remove(var26_14, 1)

				if arg2_14:isAircraft() and var34_14.type == AttributeType.CD then
					var34_14 = var4_14:getAircraftReloadCD()
				end

				local var35_14, var36_14 = Equipment.GetInfoTrans(var34_14, var4_14)

				setText(var31_14:Find("tag"), var35_14)

				local var37_14 = string.split(tostring(var36_14), "/")

				if #var37_14 >= 2 then
					setText(var31_14:Find("values/value"), var37_14[1] .. "/")
					setText(var31_14:Find("values/value_1"), var37_14[2])
				else
					setText(var31_14:Find("values/value"), var36_14)
					setText(var31_14:Find("values/value_1"), "")
				end

				setActive(var32_14, false)
			else
				setText(var31_14:Find("tag"), "")
				setText(var31_14:Find("values/value"), "")
				setText(var31_14:Find("values/value_1"), "")
				setActive(var32_14, true)
			end
		end

		onButton(arg0_14, var0_14, function()
			arg0_14:emit(BaseUI.ON_EQUIPMENT, {
				type = EquipmentInfoMediator.TYPE_SHIP,
				shipId = var4_14.id,
				pos = arg1_14
			})
		end, SFX_UI_DOCKYARD_EQUIPADD)
	else
		onButton(arg0_14, var0_14, function()
			if var4_14 then
				local var0_18, var1_18 = ShipStatus.ShipStatusCheck("onModify", var4_14)

				if not var0_18 then
					pg.TipsMgr.GetInstance():ShowTips(var1_18)

					return
				end

				arg0_14:emit(ShipMainMediator.ON_SELECT_EQUIPMENT, arg1_14)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	end
end

function var0_0.setEquipDescVisible(arg0_19, arg1_19)
	if not arg0_19.equipmentPanels then
		return
	end

	for iter0_19 = 1, #arg0_19.equipmentPanels do
		local var0_19 = arg0_19.equipmentPanels[iter0_19]

		if var0_19 then
			local var1_19 = var0_19:Find("info/cont/name_mask/name")
			local var2_19 = GetComponent(var1_19, typeof(ScrollText))

			if var2_19 then
				var2_19:SetVisible(arg1_19)
			end
		end
	end
end

function var0_0.equipmentCheck(arg0_20, arg1_20)
	if not arg0_20:GetShipVO() then
		return false
	end

	local var0_20 = arg1_20.check_type
	local var1_20 = arg1_20.check_indexList
	local var2_20 = arg1_20.check_label

	if not var0_20 and not var1_20 and not var2_20 then
		return true
	end

	local var3_20 = false
	local var4_20 = {}
	local var5_20 = Clone(arg0_20:GetShipVO().equipments)

	if var1_20 then
		local var6_20 = #var5_20

		while var6_20 > 0 do
			if not table.contains(var1_20, var6_20) then
				table.remove(var5_20, var6_20)
			end

			var6_20 = var6_20 - 1
		end
	end

	if var0_20 then
		local var7_20 = #var5_20

		while var7_20 > 0 do
			local var8_20 = var5_20[var7_20]

			if not var8_20 or not table.contains(var0_20, var8_20:getConfig("type")) then
				table.remove(var5_20, var7_20)
			end

			var7_20 = var7_20 - 1
		end
	end

	if var2_20 then
		local var9_20 = #var5_20

		while var9_20 > 0 do
			local var10_20 = var5_20[var9_20]

			if var10_20 then
				local var11_20 = 1

				for iter0_20, iter1_20 in ipairs(var2_20) do
					if not table.contains(var10_20:getConfig("label"), iter1_20) then
						var11_20 = var11_20 * 0
					end
				end

				if var11_20 == 0 then
					table.remove(var5_20, var9_20)
				end
			else
				table.remove(var5_20, var9_20)
			end

			var9_20 = var9_20 - 1
		end
	end

	return #var5_20 > 0
end

function var0_0.equipmentEnhance(arg0_21, arg1_21)
	local var0_21 = 1
	local var1_21 = arg1_21:getConfig("label")

	if arg0_21.label then
		var0_21 = 1

		for iter0_21, iter1_21 in ipairs(arg0_21.label) do
			if not table.contains(var1_21, iter1_21) then
				var0_21 = 0

				break
			end
		end
	end

	return var0_21 == 1
end

function var0_0.UpdateSpWeaponPanel(arg0_22, arg1_22)
	local var0_22 = arg0_22.equipmentB1
	local var1_22 = findTF(var0_22, "info")
	local var2_22 = findTF(var0_22, "empty")

	setActive(var1_22, arg1_22)
	setActive(var2_22, not arg1_22)

	local var3_22 = arg0_22:GetShipVO()

	assert(var3_22)

	if arg1_22 then
		UpdateSpWeaponSlot(var1_22, arg1_22, {
			20,
			20,
			20,
			20
		})

		local var4_22 = var1_22:Find("attrs")

		eachChild(var4_22, function(arg0_23)
			setActive(arg0_23, false)
		end)

		local var5_22 = arg1_22:GetPropertiesInfo().attrs
		local var6_22 = underscore.filter(var5_22, function(arg0_24)
			return not arg0_24.type or arg0_24.type ~= AttributeType.AntiSiren
		end)

		for iter0_22 = 1, 2 do
			local var7_22 = var4_22:GetChild(iter0_22 - 1)

			setActive(var7_22, true)

			if #var6_22 > 0 then
				local var8_22 = table.remove(var6_22, 1)
				local var9_22, var10_22 = Equipment.GetInfoTrans(var8_22, var3_22)

				setText(var7_22:Find("tag"), var9_22)
				setText(var7_22:Find("values/value"), var10_22)
				setText(var7_22:Find("values/value_1"), "")
			end
		end

		Canvas.ForceUpdateCanvases()

		local var11_22 = var1_22:Find("cont")

		;(function()
			local var0_25 = var11_22:GetChild(0)

			setText(var0_25:Find("tag"), i18n("spweapon_ui_effect_tag"))

			local var1_25 = arg1_22:GetEffect()

			setActive(var0_25, var1_25 and var1_25 > 0)

			if not var1_25 or not (var1_25 > 0) then
				return
			end

			setScrollText(var0_25:Find("value/Text"), getSkillName(var1_25))
		end)()

		local function var12_22(arg0_26)
			local var0_26 = var11_22:GetChild(1)

			setText(var0_26:Find("tag"), i18n("spweapon_ui_skill_tag"))
			setActive(var0_26, arg0_26 and arg0_26 > 0)

			if not arg0_26 or not (arg0_26 > 0) then
				return
			end

			setScrollText(var0_26:Find("value/Text"), getSkillName(arg0_26))
		end

		local var13_22 = arg1_22:GetActiveUpgradableSkillList(var3_22)

		if #var13_22 == 0 then
			setActive(var11_22:GetChild(1), false)
		else
			var12_22(var13_22[1].mapSkillID)
		end

		onButton(arg0_22, var0_22, function()
			arg0_22:emit(BaseUI.ON_SPWEAPON, {
				type = SpWeaponInfoLayer.TYPE_SHIP,
				shipId = var3_22.id
			})
		end, SFX_UI_DOCKYARD_EQUIPADD)
	else
		onButton(arg0_22, var0_22, function()
			if var3_22 then
				local var0_28, var1_28 = ShipStatus.ShipStatusCheck("onModify", var3_22)

				if not var0_28 then
					pg.TipsMgr.GetInstance():ShowTips(var1_28)

					return
				end

				arg0_22:emit(ShipMainMediator.ON_SELECT_SPWEAPON)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	end
end

function var0_0.switch2EquipmentSkinPage(arg0_29)
	if arg0_29.equipSkinLogicPanel:isTweening() then
		return
	end

	arg0_29.equipSkinLogicPanel:doSwitchAnim(arg0_29.contextData.isInEquipmentSkinPage)

	arg0_29.contextData.isInEquipmentSkinPage = not arg0_29.contextData.isInEquipmentSkinPage

	setActive(arg0_29.equipSkinBtn:Find("unsel"), not arg0_29.contextData.isInEquipmentSkinPage)
	setActive(arg0_29.equipSkinBtn:Find("sel"), arg0_29.contextData.isInEquipmentSkinPage)
	arg0_29.equipSkinLogicPanel:updateAll(arg0_29:GetShipVO())
end

function var0_0.OnDestroy(arg0_30)
	setParent(arg0_30.equipmentR, arg0_30._tf)
	setParent(arg0_30.equipmentL, arg0_30._tf)
	setParent(arg0_30.equipmentB, arg0_30._tf)

	arg0_30.shareData = nil
end

return var0_0
