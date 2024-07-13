local var0_0 = class("ShipEquipSkinLogicPanel", import("...base.BasePanel"))
local var1_0 = 0.2

function var0_0.init(arg0_1)
	arg0_1.equipmentTFs = {
		arg0_1:findTF("equipment_r/skin/equipment_r1"),
		arg0_1:findTF("equipment_r/skin/equipment_r2"),
		arg0_1:findTF("equipment_r/skin/equipment_r3"),
		arg0_1:findTF("equipment_l/skin/equipment_l1"),
		arg0_1:findTF("equipment_l/skin/equipment_l2")
	}
	arg0_1.equipmentNormalTFs = {
		arg0_1:findTF("equipment_r/equipment/equipment_r1"),
		arg0_1:findTF("equipment_r/equipment/equipment_r2"),
		arg0_1:findTF("equipment_r/equipment/equipment_r3"),
		arg0_1:findTF("equipment_l/equipment/equipment_l1"),
		arg0_1:findTF("equipment_l/equipment/equipment_l2")
	}
	arg0_1.spweaponNormalTF = arg0_1:findTF("equipment_b/equipment")
	arg0_1.equipmentR = arg0_1:findTF("equipment_r/equipment")
	arg0_1.equipmentL = arg0_1:findTF("equipment_l/equipment")
	arg0_1.skinR = arg0_1:findTF("equipment_r/skin")
	arg0_1.skinL = arg0_1:findTF("equipment_l/skin")
	arg0_1.infoPanel = arg0_1:findTF("info", arg0_1.equipmentTFs[1])
	arg0_1.inSkinPage = true

	for iter0_1 = 1, 3 do
		local var0_1 = findTF(arg0_1.skinR, "equipment_r" .. iter0_1 .. "/info/equip/info/unMatch/txt")

		setText(var0_1, i18n("equipskin_typewrong"))

		local var1_1 = findTF(arg0_1.skinR, "equipment_r" .. iter0_1 .. "/info/equip/info/unMatch/forbid_en")

		setText(var1_1, i18n("equipskin_typewrong_en"))

		local var2_1 = findTF(arg0_1.skinR, "equipment_r" .. iter0_1 .. "/info/equip/add/Text")

		setText(var2_1, i18n("equipskin_add"))

		local var3_1 = findTF(arg0_1.skinR, "equipment_r" .. iter0_1 .. "/info/forbid")

		setText(var3_1, i18n("equipskin_none"))
	end

	for iter1_1 = 1, 2 do
		local var4_1 = arg0_1.equipmentTFs[3 + iter1_1]
		local var5_1 = var4_1:Find("info")

		if IsNil(var5_1) then
			local var6_1 = cloneTplTo(arg0_1.infoPanel, var4_1, "info")
		end

		local var7_1 = findTF(arg0_1.skinL, "equipment_l" .. iter1_1 .. "/forbid")

		setActive(var7_1, false)

		local var8_1 = findTF(arg0_1.skinL, "equipment_l" .. iter1_1 .. "/info/equip/info/unMatch/txt")

		setText(var8_1, i18n("equipskin_typewrong"))

		local var9_1 = findTF(arg0_1.skinL, "equipment_l" .. iter1_1 .. "/info/equip/info/unMatch/forbid_en")

		setText(var9_1, i18n("equipskin_typewrong_en"))

		local var10_1 = findTF(arg0_1.skinL, "equipment_l" .. iter1_1 .. "/info/equip/add/Text")

		setText(var10_1, i18n("equipskin_add"))

		local var11_1 = findTF(arg0_1.skinL, "equipment_l" .. iter1_1 .. "/info/forbid")

		setText(var11_1, i18n("equipskin_none"))
	end

	for iter2_1 = 1, #arg0_1.equipmentNormalTFs do
		local var12_1 = findTF(arg0_1.equipmentNormalTFs[iter2_1], "empty/tip")

		setText(var12_1, i18n("equip_add"))
	end

	local var13_1 = findTF(arg0_1.spweaponNormalTF, "empty/tip")

	setText(var13_1, i18n("equip_add"))
end

function var0_0.setLabelResource(arg0_2, arg1_2)
	arg0_2.resource = arg1_2
end

function var0_0.doSwitchAnim(arg0_3, arg1_3)
	if arg0_3:isTweening() then
		return
	end

	arg0_3.inSkinPage = arg1_3

	arg0_3:doAnim(arg0_3.equipmentR, arg0_3.skinR)
	arg0_3:doAnim(arg0_3.equipmentL, arg0_3.skinL)
end

function var0_0.isTweening(arg0_4)
	if LeanTween.isTweening(go(arg0_4.equipmentR)) or LeanTween.isTweening(go(arg0_4.skinR)) or LeanTween.isTweening(go(arg0_4.equipmentL)) or LeanTween.isTweening(go(arg0_4.skinL)) then
		return true
	end

	return false
end

function var0_0.doAnim(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg2_5.localPosition
	local var1_5 = arg1_5.localPosition
	local var2_5 = arg1_5:GetComponent(typeof(CanvasGroup))
	local var3_5 = arg2_5:GetComponent(typeof(CanvasGroup))

	LeanTween.moveLocal(go(arg1_5), var0_5, var1_0)
	LeanTween.moveLocal(go(arg2_5), var1_5, var1_0)

	local var4_5 = 0.8
	local var5_5 = 1

	if not arg0_5.inSkinPage then
		var4_5, var5_5 = 1, 0.8
	end

	LeanTween.value(go(arg1_5), var4_5, var5_5, var1_0):setOnUpdate(System.Action_float(function(arg0_6)
		var2_5.alpha = arg0_6
	end))
	LeanTween.value(go(arg2_5), var5_5, var4_5, var1_0):setOnUpdate(System.Action_float(function(arg0_7)
		var3_5.alpha = arg0_7
	end))

	var3_5.blocksRaycasts = not arg0_5.inSkinPage
	var2_5.blocksRaycasts = arg0_5.inSkinPage

	;(not arg0_5.inSkinPage and arg2_5 or arg1_5):SetAsLastSibling()
end

function var0_0.updateAll(arg0_8, arg1_8)
	if arg1_8 then
		for iter0_8, iter1_8 in ipairs(arg0_8.equipmentTFs) do
			if not not table.contains(ShipEquipView.UNLOCK_EQUIPMENT_SKIN_POS, iter0_8) then
				arg0_8:updateEquipmentTF(arg1_8, iter0_8)
			end

			local var0_8 = arg0_8:findTF("shadow", iter1_8)

			if var0_8 then
				setActive(var0_8, arg0_8.inSkinPage)
			end
		end

		for iter2_8, iter3_8 in ipairs(arg0_8.equipmentNormalTFs) do
			local var1_8 = arg0_8:findTF("shadow", iter3_8)

			if var1_8 then
				setActive(var1_8, not arg0_8.inSkinPage)
			end
		end
	end
end

function var0_0.updateEquipmentTF(arg0_9, arg1_9, arg2_9)
	arg0_9.shipVO = arg1_9

	if arg1_9 then
		local var0_9 = arg0_9.equipmentTFs[arg2_9]

		removeOnButton(var0_9)

		local var1_9 = arg1_9:getEquip(arg2_9)
		local var2_9 = arg1_9:getEquipSkin(arg2_9)
		local var3_9 = var0_9:Find("info")

		if IsNil(var3_9) then
			var3_9 = cloneTplTo(arg0_9.infoPanel, var0_9, "info")
		end

		local var4_9 = arg0_9:findTF("panel_title/type", var0_9)
		local var5_9 = EquipType.Types2Title(arg2_9, arg0_9.shipVO.configId)
		local var6_9 = EquipType.LabelToName(var5_9)

		var4_9:GetComponent(typeof(Text)).text = var6_9

		setActive(var0_9:Find("unequip"), false)

		local var7_9 = arg1_9:getCanEquipSkin(arg2_9)

		setActive(var3_9:Find("forbid"), not var7_9)

		local var8_9 = var3_9:Find("equip")

		setActive(var8_9, var7_9)

		if var7_9 then
			arg0_9:updateEquipmentPanel(var8_9, arg2_9)
		end
	end
end

function var0_0.updateEquipmentPanel(arg0_10, arg1_10, arg2_10)
	if not arg0_10.shipVO:getCanEquipSkin(arg2_10) then
		return
	end

	local var0_10 = arg0_10.shipVO:getEquipSkin(arg2_10) ~= 0
	local var1_10 = arg0_10.shipVO:getEquip(arg2_10)
	local var2_10 = arg0_10.shipVO:getEquipSkin(arg2_10)
	local var3_10 = false

	if var2_10 ~= 0 then
		if var1_10 then
			local var4_10 = var1_10:getType()
			local var5_10 = pg.equip_skin_template[var2_10].equip_type

			if not table.contains(var5_10, var4_10) then
				var3_10 = true
			end
		else
			var3_10 = true
		end
	end

	local var6_10 = arg1_10:Find("add")
	local var7_10 = arg1_10:Find("info")
	local var8_10 = var7_10:Find("unMatch")
	local var9_10 = var7_10:Find("desc")

	setActive(var7_10, var0_10)
	setActive(var6_10, not var0_10)
	setActive(var8_10, var3_10)
	setActive(var9_10, not var3_10)

	if var0_10 then
		arg0_10:updateSkinInfo(var7_10, var2_10)
		onButton(arg0_10, arg0_10.equipmentTFs[arg2_10], function()
			arg0_10:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, arg2_10)
		end, SFX_PANEL)
	else
		onButton(arg0_10, var6_10:Find("icon"), function()
			arg0_10:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, arg2_10)
		end, SFX_PANEL)
	end
end

function var0_0.updateSkinInfo(arg0_13, arg1_13, arg2_13)
	local var0_13 = pg.equip_skin_template[arg2_13]

	assert(var0_13, "miss config equip_skin_template >>" .. arg2_13)
	setText(arg1_13:Find("desc"), var0_13.desc)
	setText(arg1_13:Find("cont/name_mask/name"), shortenString(var0_13.name, 10))
	updateDrop(arg1_13:Find("IconTpl"), {
		type = DROP_TYPE_EQUIPMENT_SKIN,
		id = arg2_13
	})
end

return var0_0
