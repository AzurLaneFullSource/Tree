local var0_0 = class("EquipmentSkinPanel", import("..base.BasePanel"))
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
	arg0_1.equipmentR = arg0_1:findTF("equipment_r/equipment")
	arg0_1.equipmentL = arg0_1:findTF("equipment_l/equipment")
	arg0_1.skinR = arg0_1:findTF("equipment_r/skin")
	arg0_1.skinL = arg0_1:findTF("equipment_l/skin")

	setActive(arg0_1.skinR, not LOCK_EQUIP_SKIN)
	setActive(arg0_1.skinL, not LOCK_EQUIP_SKIN)

	arg0_1.infoPanel = arg0_1:findTF("info", arg0_1.equipmentTFs[1])
	arg0_1.inSkinPage = true
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

	LeanTween.alphaCanvas(var2_5, var5_5, var1_0):setFrom(var4_5)
	LeanTween.value(go(arg2_5), var5_5, var4_5, var1_0):setOnUpdate(System.Action_float(function(arg0_6)
		var3_5.alpha = arg0_6
	end))

	var3_5.blocksRaycasts = not arg0_5.inSkinPage
	var2_5.blocksRaycasts = arg0_5.inSkinPage

	;(not arg0_5.inSkinPage and arg2_5 or arg1_5):SetAsLastSibling()
end

function var0_0.updateAll(arg0_7, arg1_7)
	if arg1_7 then
		for iter0_7, iter1_7 in ipairs(arg0_7.equipmentTFs) do
			if not not table.contains(ShipEquipView.UNLOCK_EQUIPMENT_SKIN_POS, iter0_7) then
				arg0_7:updateEquipmentTF(arg1_7, iter0_7)
			end

			local var0_7 = arg0_7:findTF("shadow", iter1_7)

			if var0_7 then
				setActive(var0_7, arg0_7.inSkinPage)
			end
		end

		for iter2_7, iter3_7 in ipairs(arg0_7.equipmentNormalTFs) do
			local var1_7 = arg0_7:findTF("shadow", iter3_7)

			if var1_7 then
				setActive(var1_7, not arg0_7.inSkinPage)
			end
		end
	end
end

function var0_0.updateEquipmentTF(arg0_8, arg1_8, arg2_8)
	arg0_8.shipVO = arg1_8

	if arg1_8 then
		local var0_8 = arg0_8.equipmentTFs[arg2_8]

		removeOnButton(var0_8)

		local var1_8 = arg1_8:getEquip(arg2_8)
		local var2_8 = var0_8:Find("info")

		if IsNil(var2_8) then
			var2_8 = cloneTplTo(arg0_8.infoPanel, var0_8, "info")
		end

		local var3_8 = arg0_8:findTF("panel_title/type", var0_8)
		local var4_8 = EquipType.Types2Title(arg2_8, arg0_8.shipVO.configId)
		local var5_8 = arg0_8:findTF(var4_8, arg0_8.resource):GetComponent(typeof(Image)).sprite

		var3_8:GetComponent(typeof(Image)).sprite = var5_8

		var3_8:GetComponent(typeof(Image)):SetNativeSize()
		setActive(var2_8, var1_8)
		setActive(var0_8:Find("unequip"), not var1_8)

		if var1_8 then
			local var6_8 = var1_8:canEquipSkin()

			setActive(var2_8:Find("forbid"), not var6_8)

			local var7_8 = var2_8:Find("equip")

			setActive(var7_8, var6_8)

			if var6_8 then
				arg0_8:updateEquipmentPanel(var7_8, arg2_8)
			end
		end
	end
end

function var0_0.updateEquipmentPanel(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.shipVO:getEquip(arg2_9)
	local var1_9 = var0_9.skinId
	local var2_9 = var0_9:hasSkin()
	local var3_9 = arg1_9:Find("add")
	local var4_9 = arg1_9:Find("info")

	setActive(var4_9, var2_9)
	setActive(var3_9, not var2_9)

	if var2_9 then
		arg0_9:updateSkinInfo(var4_9, var1_9)
		onButton(arg0_9, arg0_9.equipmentTFs[arg2_9], function()
			arg0_9:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, arg2_9)
		end, SFX_PANEL)
	else
		onButton(arg0_9, var3_9:Find("icon"), function()
			arg0_9:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, arg2_9)
		end, SFX_PANEL)
	end
end

function var0_0.updateSkinInfo(arg0_12, arg1_12, arg2_12)
	local var0_12 = pg.equip_skin_template[arg2_12]

	assert(var0_12, "miss config equip_skin_template >>" .. arg2_12)
	setText(arg1_12:Find("desc"), var0_12.desc)
	setText(arg1_12:Find("cont/name_mask/name"), var0_12.name)
	updateDrop(arg1_12:Find("IconTpl"), {
		type = DROP_TYPE_EQUIPMENT_SKIN,
		id = arg2_12
	})
end

return var0_0
