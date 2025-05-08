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

function var0_0.OnInit(arg0_2)
	arg0_2:InitEquipment()
end

function var0_0.SetShareData(arg0_3, arg1_3)
	arg0_3.shareData = arg1_3
end

function var0_0.GetShipVO(arg0_4)
	if arg0_4.shareData and arg0_4.shareData.shipVO then
		return arg0_4.shareData.shipVO
	end

	return nil
end

function var0_0.UpdateUI(arg0_5)
	local var0_5 = arg0_5:GetShipVO()

	arg0_5:UpdateEquipments(var0_5)
end

function var0_0.InitEquipment(arg0_6)
	arg0_6.mainPanel = arg0_6._parentTf.parent
	arg0_6.equipRCon = arg0_6._parentTf:Find("equipment_r_container")
	arg0_6.equipLCon = arg0_6._parentTf:Find("equipment_l_container")
	arg0_6.equipBCon = arg0_6._parentTf:Find("equipment_b_container")
	arg0_6.equipmentR = arg0_6:findTF("equipment_r")
	arg0_6.equipmentL = arg0_6:findTF("equipment_l")
	arg0_6.equipmentB = arg0_6:findTF("equipment_b")
	arg0_6.equipmentR1 = arg0_6.equipmentR:Find("equipment/equipment_r1")
	arg0_6.equipmentR2 = arg0_6.equipmentR:Find("equipment/equipment_r2")
	arg0_6.equipmentR3 = arg0_6.equipmentR:Find("equipment/equipment_r3")
	arg0_6.equipmentL1 = arg0_6.equipmentL:Find("equipment/equipment_l1")
	arg0_6.equipmentL2 = arg0_6.equipmentL:Find("equipment/equipment_l2")
	arg0_6.equipSkinBtn = arg0_6.equipmentR:Find("equipment_skin_btn")
	arg0_6.equipmentB1 = arg0_6.equipmentB:Find("equipment")
	arg0_6.resource = arg0_6._tf:Find("resource")
	arg0_6.equipSkinLogicPanel = ShipEquipSkinLogicPanel.New(arg0_6._tf.gameObject)

	arg0_6.equipSkinLogicPanel:attach(arg0_6)
	arg0_6.equipSkinLogicPanel:setLabelResource(arg0_6.resource)
	setActive(arg0_6.equipSkinLogicPanel._go, true)
	setParent(arg0_6.equipmentR, arg0_6.equipRCon)
	setParent(arg0_6.equipmentL, arg0_6.equipLCon)
	setParent(arg0_6.equipmentB, arg0_6.equipBCon)
	setActive(arg0_6.equipmentR, true)
	setActive(arg0_6.equipmentL, true)
	setActive(arg0_6.equipmentB, true)
	setActive(arg0_6.equipSkinBtn, true)

	arg0_6.equipmentPanels = {
		arg0_6.equipmentR1,
		arg0_6.equipmentR2,
		arg0_6.equipmentR3,
		arg0_6.equipmentL1,
		arg0_6.equipmentL2
	}
	arg0_6.onSelected = false
end

function var0_0.InitEvent(arg0_7)
	onButton(arg0_7, arg0_7.equipSkinBtn, function()
		local var0_8, var1_8 = ShipStatus.ShipStatusCheck("onModify", arg0_7:GetShipVO())

		if not var0_8 then
			pg.TipsMgr.GetInstance():ShowTips(var1_8)

			return
		end

		arg0_7:switch2EquipmentSkinPage()
	end)

	if arg0_7.contextData.isInEquipmentSkinPage then
		arg0_7.contextData.isInEquipmentSkinPage = nil

		triggerButton(arg0_7.equipSkinBtn)
	end
end

function var0_0.OnSelected(arg0_9, arg1_9)
	local var0_9 = pg.UIMgr.GetInstance()

	if arg1_9 then
		local var1_9 = {}
		local var2_9 = {}
		local var3_9 = {}

		local function var4_9(arg0_10, arg1_10)
			eachChild(arg0_10, function(arg0_11)
				table.insert(arg1_10, arg0_11)
			end)
		end

		var4_9(arg0_9.equipmentR:Find("skin"), var2_9)
		var4_9(arg0_9.equipmentR:Find("equipment"), var2_9)
		var4_9(arg0_9.equipmentL:Find("skin"), var1_9)
		var4_9(arg0_9.equipmentL:Find("equipment"), var1_9)
		var4_9(arg0_9.equipmentB, var3_9)
		table.insert(var1_9, arg0_9.equipmentL:Find("equipment/equipment_l1"))
		var0_9:OverlayPanelPB(arg0_9.equipRCon, {
			pbList = var2_9,
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT,
			weight = LayerWeightConst.LOWER_LAYER
		})
		var0_9:OverlayPanelPB(arg0_9.equipLCon, {
			pbList = var1_9,
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT,
			weight = LayerWeightConst.LOWER_LAYER
		})
		var0_9:OverlayPanelPB(arg0_9.equipBCon, {
			pbList = var3_9,
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT,
			weight = LayerWeightConst.LOWER_LAYER
		})
	else
		var0_9:UnOverlayPanel(arg0_9.equipRCon, arg0_9._parentTf)
		var0_9:UnOverlayPanel(arg0_9.equipLCon, arg0_9._parentTf)
		var0_9:UnOverlayPanel(arg0_9.equipBCon, arg0_9._parentTf)
	end

	arg0_9.onSelected = arg1_9
end

function var0_0.UpdateEquipments(arg0_12, arg1_12)
	local var0_12 = arg1_12:getActiveEquipments()

	for iter0_12, iter1_12 in ipairs(arg1_12.equipments) do
		local var1_12 = var0_12[iter0_12]

		arg0_12:UpdateEquipmentPanel(iter0_12, iter1_12, var1_12)
	end

	if arg0_12.equipSkinLogicPanel then
		arg0_12.equipSkinLogicPanel:updateAll(arg1_12)
	end

	if arg0_12.contextData.openEquipUpgrade == true then
		arg0_12.contextData.openEquipUpgrade = false

		local var2_12 = 0
		local var3_12 = arg0_12:GetShipVO().equipments

		for iter2_12, iter3_12 in ipairs(var3_12) do
			if iter3_12 then
				var2_12 = var2_12 + 1
			end
		end

		if var2_12 > 0 then
			arg0_12:emit(ShipMainMediator.OPEN_EQUIP_UPGRADE, arg0_12:GetShipVO().id)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("fightfail_noequip"))
		end
	end

	setActive(arg0_12.equipmentB, arg1_12:IsSpweaponUnlock() and not LOCK_SP_WEAPON)

	local var4_12 = arg1_12:GetSpWeapon()

	arg0_12:UpdateSpWeaponPanel(var4_12)
end

function var0_0.UpdateEquipmentPanel(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg0_13.equipmentPanels[arg1_13]
	local var1_13 = findTF(var0_13, "info")
	local var2_13 = findTF(var0_13, "empty")
	local var3_13 = findTF(var1_13, "efficiency")

	setActive(var1_13, arg2_13)
	setActive(var2_13, not arg2_13)

	local var4_13 = arg0_13:GetShipVO()
	local var5_13 = {}
	local var6_13 = {}
	local var7_13 = var4_13:GetSpWeapon()

	if var7_13 and var7_13:GetUpgradableSkillInfo().unlock then
		local var8_13 = var7_13:GetUpgradableSkillInfo()

		table.insert(var6_13, var7_13:GetUpgradableSkillIds()[1][1])

		local var9_13 = var8_13.skillId
		local var10_13 = ys.Battle.BattleDataFunction.GetBuffTemplate(var9_13, var8_13.lv)

		if var10_13.shipInfoScene and var10_13.shipInfoScene.equip then
			for iter0_13, iter1_13 in ipairs(var10_13.shipInfoScene.equip) do
				table.insert(var5_13, iter1_13)
			end
		end
	end

	for iter2_13, iter3_13 in pairs(var4_13.skills) do
		if not table.contains(var6_13, iter3_13.id) then
			local var11_13 = ys.Battle.BattleDataFunction.GetBuffTemplate(iter3_13.id, iter3_13.level)

			if var11_13.shipInfoScene and var11_13.shipInfoScene.equip then
				for iter4_13, iter5_13 in ipairs(var11_13.shipInfoScene.equip) do
					table.insert(var5_13, iter5_13)
				end
			end
		end
	end

	if var7_13 and var7_13:GetEffect() ~= 0 then
		local var12_13 = var7_13:GetEffect()
		local var13_13 = ys.Battle.BattleDataFunction.GetBuffTemplate(var12_13, 1)

		if var13_13.shipInfoScene and var13_13.shipInfoScene.equip then
			for iter6_13, iter7_13 in ipairs(var13_13.shipInfoScene.equip) do
				table.insert(var5_13, iter7_13)
			end
		end
	end

	local var14_13 = findTF(var0_13, "panel_title/type")
	local var15_13 = findTF(var0_13, "skin_icon")

	if var15_13 then
		setActive(var15_13, arg2_13 and arg2_13:hasSkin())
	end

	local var16_13 = EquipType.Types2Title(arg1_13, var4_13.configId)
	local var17_13 = EquipType.LabelToName(var16_13)

	var14_13:GetComponent(typeof(Text)).text = var17_13

	if arg2_13 then
		setActive(var3_13, not arg2_13:isDevice())

		if not arg2_13:isDevice() then
			local var18_13 = pg.ship_data_statistics[var4_13.configId]
			local var19_13 = var4_13:getEquipProficiencyByPos(arg1_13)
			local var20_13 = var19_13 and var19_13 * 100 or 0
			local var21_13 = false

			if not (var4_13:getFlag("inWorld") and arg0_13.contextData.fromMediatorName == WorldMediator.__cname and WorldConst.FetchWorldShip(var4_13.id):IsBroken()) then
				for iter8_13, iter9_13 in ipairs(var5_13) do
					if arg0_13:equipmentCheck(iter9_13) and arg0_13.equipmentEnhance(iter9_13, arg2_13) then
						var20_13 = var20_13 + iter9_13.number
						var21_13 = true
					end
				end
			end

			if var20_13 - calcFloor(var20_13) > 1e-09 then
				var20_13 = string.format("%.1f", var20_13)
				GetComponent(findTF(var3_13, "Text"), typeof(Text)).fontSize = 45
			else
				GetComponent(findTF(var3_13, "Text"), typeof(Text)).fontSize = 50
			end

			setButtonText(var3_13, var21_13 and setColorStr(var20_13 .. "%", COLOR_GREEN) or var20_13 .. "%")
		end

		local var22_13 = arg0_13:findTF("IconTpl", var1_13)

		updateEquipment(var22_13, arg2_13)

		local var23_13 = arg2_13:getConfig("name")

		if arg2_13:getConfig("ammo_icon")[1] then
			setActive(findTF(var1_13, "cont/icon_ammo"), true)
			setImageSprite(findTF(var1_13, "cont/icon_ammo"), GetSpriteFromAtlas("ammo", arg2_13:getConfig("ammo_icon")[1]))
		else
			setActive(findTF(var1_13, "cont/icon_ammo"), false)
		end

		setScrollText(arg0_13.equipmentPanels[arg1_13]:Find("info/cont/name_mask/name"), var23_13)

		local var24_13 = var1_13:Find("attrs")

		eachChild(var24_13, function(arg0_14)
			setActive(arg0_14, false)
		end)

		local var25_13 = arg2_13:GetPropertiesInfo().attrs
		local var26_13 = underscore.filter(var25_13, function(arg0_15)
			return not arg0_15.type or arg0_15.type ~= AttributeType.AntiSiren
		end)
		local var27_13 = arg2_13:getConfig("skill_id")
		local var28_13 = var27_13[1] and var27_13[1][1]
		local var29_13 = var28_13 and arg2_13:isDevice() and {
			1,
			2,
			5
		} or {
			1,
			4,
			2,
			3
		}

		for iter10_13, iter11_13 in ipairs(var29_13) do
			local var30_13 = var24_13:Find("attr_" .. iter11_13)
			local var31_13 = findTF(var30_13, "panel")
			local var32_13 = findTF(var30_13, "lock")

			setActive(var30_13, true)

			if iter11_13 == 5 then
				setText(var31_13:Find("values/value"), "")

				local var33_13 = getSkillName(var28_13)

				if PLATFORM_CODE == PLATFORM_US and string.len(var33_13) > 15 then
					GetComponent(var31_13:Find("values/value_1"), typeof(Text)).fontSize = 24
				end

				setText(var31_13:Find("values/value_1"), getSkillName(var28_13))
				setActive(var32_13, false)
			elseif #var26_13 > 0 then
				local var34_13 = table.remove(var26_13, 1)

				if arg2_13:isAircraft() and var34_13.type == AttributeType.CD then
					var34_13 = var4_13:getAircraftReloadCD()
				end

				local var35_13, var36_13 = Equipment.GetInfoTrans(var34_13, var4_13)

				setText(var31_13:Find("tag"), var35_13)

				local var37_13 = string.split(tostring(var36_13), "/")

				if #var37_13 >= 2 then
					setText(var31_13:Find("values/value"), var37_13[1] .. "/")
					setText(var31_13:Find("values/value_1"), var37_13[2])
				else
					setText(var31_13:Find("values/value"), var36_13)
					setText(var31_13:Find("values/value_1"), "")
				end

				setActive(var32_13, false)
			else
				setText(var31_13:Find("tag"), "")
				setText(var31_13:Find("values/value"), "")
				setText(var31_13:Find("values/value_1"), "")
				setActive(var32_13, true)
			end
		end

		onButton(arg0_13, var0_13, function()
			arg0_13:emit(BaseUI.ON_EQUIPMENT, {
				type = EquipmentInfoMediator.TYPE_SHIP,
				shipId = var4_13.id,
				pos = arg1_13,
				LayerWeightMgr_weight = LayerWeightConst.SECOND_LAYER
			})
		end, SFX_UI_DOCKYARD_EQUIPADD)
	else
		onButton(arg0_13, var0_13, function()
			if var4_13 then
				local var0_17, var1_17 = ShipStatus.ShipStatusCheck("onModify", var4_13)

				if not var0_17 then
					pg.TipsMgr.GetInstance():ShowTips(var1_17)

					return
				end

				arg0_13:emit(ShipMainMediator.ON_SELECT_EQUIPMENT, arg1_13)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	end
end

function var0_0.equipmentCheck(arg0_18, arg1_18)
	if not arg0_18:GetShipVO() then
		return false
	end

	local var0_18 = arg1_18.check_type
	local var1_18 = arg1_18.check_indexList
	local var2_18 = arg1_18.check_label

	if not var0_18 and not var1_18 and not var2_18 then
		return true
	end

	local var3_18 = false
	local var4_18 = {}
	local var5_18 = Clone(arg0_18:GetShipVO().equipments)

	if var1_18 then
		local var6_18 = #var5_18

		while var6_18 > 0 do
			if not table.contains(var1_18, var6_18) then
				table.remove(var5_18, var6_18)
			end

			var6_18 = var6_18 - 1
		end
	end

	if var0_18 then
		local var7_18 = #var5_18

		while var7_18 > 0 do
			local var8_18 = var5_18[var7_18]

			if not var8_18 or not table.contains(var0_18, var8_18:getConfig("type")) then
				table.remove(var5_18, var7_18)
			end

			var7_18 = var7_18 - 1
		end
	end

	if var2_18 then
		local var9_18 = #var5_18

		while var9_18 > 0 do
			local var10_18 = var5_18[var9_18]

			if var10_18 then
				local var11_18 = 1

				for iter0_18, iter1_18 in ipairs(var2_18) do
					if not table.contains(var10_18:getConfig("label"), iter1_18) then
						var11_18 = var11_18 * 0
					end
				end

				if var11_18 == 0 then
					table.remove(var5_18, var9_18)
				end
			else
				table.remove(var5_18, var9_18)
			end

			var9_18 = var9_18 - 1
		end
	end

	return #var5_18 > 0
end

function var0_0.equipmentEnhance(arg0_19, arg1_19)
	local var0_19 = 1
	local var1_19 = arg1_19:getConfig("label")

	if arg0_19.label then
		var0_19 = 1

		for iter0_19, iter1_19 in ipairs(arg0_19.label) do
			if not table.contains(var1_19, iter1_19) then
				var0_19 = 0

				break
			end
		end
	end

	return var0_19 == 1
end

function var0_0.UpdateSpWeaponPanel(arg0_20, arg1_20)
	local var0_20 = arg0_20.equipmentB1
	local var1_20 = findTF(var0_20, "info")
	local var2_20 = findTF(var0_20, "empty")

	setActive(var1_20, arg1_20)
	setActive(var2_20, not arg1_20)

	local var3_20 = arg0_20:GetShipVO()

	assert(var3_20)

	if arg1_20 then
		UpdateSpWeaponSlot(var1_20, arg1_20, {
			20,
			20,
			20,
			20
		})

		local var4_20 = var1_20:Find("attrs")

		eachChild(var4_20, function(arg0_21)
			setActive(arg0_21, false)
		end)

		local var5_20 = arg1_20:GetPropertiesInfo().attrs
		local var6_20 = underscore.filter(var5_20, function(arg0_22)
			return not arg0_22.type or arg0_22.type ~= AttributeType.AntiSiren
		end)

		for iter0_20 = 1, 2 do
			local var7_20 = var4_20:GetChild(iter0_20 - 1)

			setActive(var7_20, true)

			if #var6_20 > 0 then
				local var8_20 = table.remove(var6_20, 1)
				local var9_20, var10_20 = Equipment.GetInfoTrans(var8_20, var3_20)

				setText(var7_20:Find("tag"), var9_20)
				setText(var7_20:Find("values/value"), var10_20)
				setText(var7_20:Find("values/value_1"), "")
			end
		end

		Canvas.ForceUpdateCanvases()

		local var11_20 = var1_20:Find("cont")

		;(function()
			local var0_23 = var11_20:GetChild(0)

			setText(var0_23:Find("tag"), i18n("spweapon_ui_effect_tag"))

			local var1_23 = arg1_20:GetEffect()

			setActive(var0_23, var1_23 and var1_23 > 0)

			if not var1_23 or not (var1_23 > 0) then
				return
			end

			setScrollText(var0_23:Find("value/Text"), getSkillName(var1_23))
		end)()
		;(function()
			local var0_24 = var11_20:GetChild(1)

			setText(var0_24:Find("tag"), i18n("spweapon_ui_skill_tag"))

			local var1_24 = arg1_20:GetActiveUpgradableSkill(var3_20)

			setActive(var0_24, var1_24 and var1_24 > 0)

			if not var1_24 or not (var1_24 > 0) then
				return
			end

			setScrollText(var0_24:Find("value/Text"), getSkillName(var1_24))
		end)()
		onButton(arg0_20, var0_20, function()
			arg0_20:emit(BaseUI.ON_SPWEAPON, {
				type = SpWeaponInfoLayer.TYPE_SHIP,
				shipId = var3_20.id
			})
		end, SFX_UI_DOCKYARD_EQUIPADD)
	else
		onButton(arg0_20, var0_20, function()
			if var3_20 then
				local var0_26, var1_26 = ShipStatus.ShipStatusCheck("onModify", var3_20)

				if not var0_26 then
					pg.TipsMgr.GetInstance():ShowTips(var1_26)

					return
				end

				arg0_20:emit(ShipMainMediator.ON_SELECT_SPWEAPON)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	end
end

function var0_0.switch2EquipmentSkinPage(arg0_27)
	if arg0_27.equipSkinLogicPanel:isTweening() then
		return
	end

	arg0_27.equipSkinLogicPanel:doSwitchAnim(arg0_27.contextData.isInEquipmentSkinPage)

	arg0_27.contextData.isInEquipmentSkinPage = not arg0_27.contextData.isInEquipmentSkinPage

	setActive(arg0_27.equipSkinBtn:Find("unsel"), not arg0_27.contextData.isInEquipmentSkinPage)
	setActive(arg0_27.equipSkinBtn:Find("sel"), arg0_27.contextData.isInEquipmentSkinPage)
	arg0_27.equipSkinLogicPanel:updateAll(arg0_27:GetShipVO())
end

function var0_0.OnDestroy(arg0_28)
	setParent(arg0_28.equipmentR, arg0_28._tf)
	setParent(arg0_28.equipmentL, arg0_28._tf)
	setParent(arg0_28.equipmentB, arg0_28._tf)

	arg0_28.shareData = nil
end

return var0_0
