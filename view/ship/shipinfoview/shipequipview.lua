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
	if arg1_9 then
		local var0_9 = {}
		local var1_9 = {}
		local var2_9 = {}

		local function var3_9(arg0_10, arg1_10)
			eachChild(arg0_10, function(arg0_11)
				table.insert(arg1_10, arg0_11)
			end)
		end

		var3_9(arg0_9.equipmentR:Find("skin"), var1_9)
		var3_9(arg0_9.equipmentR:Find("equipment"), var1_9)
		var3_9(arg0_9.equipmentL:Find("skin"), var0_9)
		var3_9(arg0_9.equipmentL:Find("equipment"), var0_9)
		var3_9(arg0_9.equipmentB, var2_9)
		table.insert(var0_9, arg0_9.equipmentL:Find("equipment/equipment_l1"))
		arg0_9:OverlayPanel(arg0_9.equipRCon, {
			groupDelta = -1,
			pbList = var1_9,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
		arg0_9:OverlayPanel(arg0_9.equipLCon, {
			groupDelta = -1,
			pbList = var0_9,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
		arg0_9:OverlayPanel(arg0_9.equipBCon, {
			groupDelta = -1,
			pbList = var2_9,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		arg0_9:UnOverlayPanel(arg0_9.equipRCon, arg0_9._parentTf)
		arg0_9:UnOverlayPanel(arg0_9.equipLCon, arg0_9._parentTf)
		arg0_9:UnOverlayPanel(arg0_9.equipBCon, arg0_9._parentTf)
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
				onRemoved = function()
					arg0_13:setEquipDescVisible(true)
				end
			})
			arg0_13:setEquipDescVisible(false)
		end, SFX_UI_DOCKYARD_EQUIPADD)
	else
		onButton(arg0_13, var0_13, function()
			if var4_13 then
				local var0_18, var1_18 = ShipStatus.ShipStatusCheck("onModify", var4_13)

				if not var0_18 then
					pg.TipsMgr.GetInstance():ShowTips(var1_18)

					return
				end

				arg0_13:emit(ShipMainMediator.ON_SELECT_EQUIPMENT, arg1_13)
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
				shipId = var3_22.id,
				onRemoved = function()
					arg0_22:setEquipDescVisible(true)
				end
			})
			arg0_22:setEquipDescVisible(false)
		end, SFX_UI_DOCKYARD_EQUIPADD)
	else
		onButton(arg0_22, var0_22, function()
			if var3_22 then
				local var0_29, var1_29 = ShipStatus.ShipStatusCheck("onModify", var3_22)

				if not var0_29 then
					pg.TipsMgr.GetInstance():ShowTips(var1_29)

					return
				end

				arg0_22:emit(ShipMainMediator.ON_SELECT_SPWEAPON)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	end
end

function var0_0.switch2EquipmentSkinPage(arg0_30)
	if arg0_30.equipSkinLogicPanel:isTweening() then
		return
	end

	arg0_30.equipSkinLogicPanel:doSwitchAnim(arg0_30.contextData.isInEquipmentSkinPage)

	arg0_30.contextData.isInEquipmentSkinPage = not arg0_30.contextData.isInEquipmentSkinPage

	setActive(arg0_30.equipSkinBtn:Find("unsel"), not arg0_30.contextData.isInEquipmentSkinPage)
	setActive(arg0_30.equipSkinBtn:Find("sel"), arg0_30.contextData.isInEquipmentSkinPage)
	arg0_30.equipSkinLogicPanel:updateAll(arg0_30:GetShipVO())
end

function var0_0.OnDestroy(arg0_31)
	setParent(arg0_31.equipmentR, arg0_31._tf)
	setParent(arg0_31.equipmentL, arg0_31._tf)
	setParent(arg0_31.equipmentB, arg0_31._tf)

	arg0_31.shareData = nil
end

return var0_0
