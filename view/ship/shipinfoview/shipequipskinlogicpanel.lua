local var0 = class("ShipEquipSkinLogicPanel", import("...base.BasePanel"))
local var1 = 0.2

function var0.init(arg0)
	arg0.equipmentTFs = {
		arg0:findTF("equipment_r/skin/equipment_r1"),
		arg0:findTF("equipment_r/skin/equipment_r2"),
		arg0:findTF("equipment_r/skin/equipment_r3"),
		arg0:findTF("equipment_l/skin/equipment_l1"),
		arg0:findTF("equipment_l/skin/equipment_l2")
	}
	arg0.equipmentNormalTFs = {
		arg0:findTF("equipment_r/equipment/equipment_r1"),
		arg0:findTF("equipment_r/equipment/equipment_r2"),
		arg0:findTF("equipment_r/equipment/equipment_r3"),
		arg0:findTF("equipment_l/equipment/equipment_l1"),
		arg0:findTF("equipment_l/equipment/equipment_l2")
	}
	arg0.spweaponNormalTF = arg0:findTF("equipment_b/equipment")
	arg0.equipmentR = arg0:findTF("equipment_r/equipment")
	arg0.equipmentL = arg0:findTF("equipment_l/equipment")
	arg0.skinR = arg0:findTF("equipment_r/skin")
	arg0.skinL = arg0:findTF("equipment_l/skin")
	arg0.infoPanel = arg0:findTF("info", arg0.equipmentTFs[1])
	arg0.inSkinPage = true

	for iter0 = 1, 3 do
		local var0 = findTF(arg0.skinR, "equipment_r" .. iter0 .. "/info/equip/info/unMatch/txt")

		setText(var0, i18n("equipskin_typewrong"))

		local var1 = findTF(arg0.skinR, "equipment_r" .. iter0 .. "/info/equip/info/unMatch/forbid_en")

		setText(var1, i18n("equipskin_typewrong_en"))

		local var2 = findTF(arg0.skinR, "equipment_r" .. iter0 .. "/info/equip/add/Text")

		setText(var2, i18n("equipskin_add"))

		local var3 = findTF(arg0.skinR, "equipment_r" .. iter0 .. "/info/forbid")

		setText(var3, i18n("equipskin_none"))
	end

	for iter1 = 1, 2 do
		local var4 = arg0.equipmentTFs[3 + iter1]
		local var5 = var4:Find("info")

		if IsNil(var5) then
			local var6 = cloneTplTo(arg0.infoPanel, var4, "info")
		end

		local var7 = findTF(arg0.skinL, "equipment_l" .. iter1 .. "/forbid")

		setActive(var7, false)

		local var8 = findTF(arg0.skinL, "equipment_l" .. iter1 .. "/info/equip/info/unMatch/txt")

		setText(var8, i18n("equipskin_typewrong"))

		local var9 = findTF(arg0.skinL, "equipment_l" .. iter1 .. "/info/equip/info/unMatch/forbid_en")

		setText(var9, i18n("equipskin_typewrong_en"))

		local var10 = findTF(arg0.skinL, "equipment_l" .. iter1 .. "/info/equip/add/Text")

		setText(var10, i18n("equipskin_add"))

		local var11 = findTF(arg0.skinL, "equipment_l" .. iter1 .. "/info/forbid")

		setText(var11, i18n("equipskin_none"))
	end

	for iter2 = 1, #arg0.equipmentNormalTFs do
		local var12 = findTF(arg0.equipmentNormalTFs[iter2], "empty/tip")

		setText(var12, i18n("equip_add"))
	end

	local var13 = findTF(arg0.spweaponNormalTF, "empty/tip")

	setText(var13, i18n("equip_add"))
end

function var0.setLabelResource(arg0, arg1)
	arg0.resource = arg1
end

function var0.doSwitchAnim(arg0, arg1)
	if arg0:isTweening() then
		return
	end

	arg0.inSkinPage = arg1

	arg0:doAnim(arg0.equipmentR, arg0.skinR)
	arg0:doAnim(arg0.equipmentL, arg0.skinL)
end

function var0.isTweening(arg0)
	if LeanTween.isTweening(go(arg0.equipmentR)) or LeanTween.isTweening(go(arg0.skinR)) or LeanTween.isTweening(go(arg0.equipmentL)) or LeanTween.isTweening(go(arg0.skinL)) then
		return true
	end

	return false
end

function var0.doAnim(arg0, arg1, arg2)
	local var0 = arg2.localPosition
	local var1 = arg1.localPosition
	local var2 = arg1:GetComponent(typeof(CanvasGroup))
	local var3 = arg2:GetComponent(typeof(CanvasGroup))

	LeanTween.moveLocal(go(arg1), var0, var1)
	LeanTween.moveLocal(go(arg2), var1, var1)

	local var4 = 0.8
	local var5 = 1

	if not arg0.inSkinPage then
		var4, var5 = 1, 0.8
	end

	LeanTween.value(go(arg1), var4, var5, var1):setOnUpdate(System.Action_float(function(arg0)
		var2.alpha = arg0
	end))
	LeanTween.value(go(arg2), var5, var4, var1):setOnUpdate(System.Action_float(function(arg0)
		var3.alpha = arg0
	end))

	var3.blocksRaycasts = not arg0.inSkinPage
	var2.blocksRaycasts = arg0.inSkinPage

	;(not arg0.inSkinPage and arg2 or arg1):SetAsLastSibling()
end

function var0.updateAll(arg0, arg1)
	if arg1 then
		for iter0, iter1 in ipairs(arg0.equipmentTFs) do
			if not not table.contains(ShipEquipView.UNLOCK_EQUIPMENT_SKIN_POS, iter0) then
				arg0:updateEquipmentTF(arg1, iter0)
			end

			local var0 = arg0:findTF("shadow", iter1)

			if var0 then
				setActive(var0, arg0.inSkinPage)
			end
		end

		for iter2, iter3 in ipairs(arg0.equipmentNormalTFs) do
			local var1 = arg0:findTF("shadow", iter3)

			if var1 then
				setActive(var1, not arg0.inSkinPage)
			end
		end
	end
end

function var0.updateEquipmentTF(arg0, arg1, arg2)
	arg0.shipVO = arg1

	if arg1 then
		local var0 = arg0.equipmentTFs[arg2]

		removeOnButton(var0)

		local var1 = arg1:getEquip(arg2)
		local var2 = arg1:getEquipSkin(arg2)
		local var3 = var0:Find("info")

		if IsNil(var3) then
			var3 = cloneTplTo(arg0.infoPanel, var0, "info")
		end

		local var4 = arg0:findTF("panel_title/type", var0)
		local var5 = EquipType.Types2Title(arg2, arg0.shipVO.configId)
		local var6 = EquipType.LabelToName(var5)

		var4:GetComponent(typeof(Text)).text = var6

		setActive(var0:Find("unequip"), false)

		local var7 = arg1:getCanEquipSkin(arg2)

		setActive(var3:Find("forbid"), not var7)

		local var8 = var3:Find("equip")

		setActive(var8, var7)

		if var7 then
			arg0:updateEquipmentPanel(var8, arg2)
		end
	end
end

function var0.updateEquipmentPanel(arg0, arg1, arg2)
	if not arg0.shipVO:getCanEquipSkin(arg2) then
		return
	end

	local var0 = arg0.shipVO:getEquipSkin(arg2) ~= 0
	local var1 = arg0.shipVO:getEquip(arg2)
	local var2 = arg0.shipVO:getEquipSkin(arg2)
	local var3 = false

	if var2 ~= 0 then
		if var1 then
			local var4 = var1:getType()
			local var5 = pg.equip_skin_template[var2].equip_type

			if not table.contains(var5, var4) then
				var3 = true
			end
		else
			var3 = true
		end
	end

	local var6 = arg1:Find("add")
	local var7 = arg1:Find("info")
	local var8 = var7:Find("unMatch")
	local var9 = var7:Find("desc")

	setActive(var7, var0)
	setActive(var6, not var0)
	setActive(var8, var3)
	setActive(var9, not var3)

	if var0 then
		arg0:updateSkinInfo(var7, var2)
		onButton(arg0, arg0.equipmentTFs[arg2], function()
			arg0:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, arg2)
		end, SFX_PANEL)
	else
		onButton(arg0, var6:Find("icon"), function()
			arg0:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, arg2)
		end, SFX_PANEL)
	end
end

function var0.updateSkinInfo(arg0, arg1, arg2)
	local var0 = pg.equip_skin_template[arg2]

	assert(var0, "miss config equip_skin_template >>" .. arg2)
	setText(arg1:Find("desc"), var0.desc)
	setText(arg1:Find("cont/name_mask/name"), shortenString(var0.name, 10))
	updateDrop(arg1:Find("IconTpl"), {
		type = DROP_TYPE_EQUIPMENT_SKIN,
		id = arg2
	})
end

return var0
