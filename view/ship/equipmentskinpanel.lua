local var0 = class("EquipmentSkinPanel", import("..base.BasePanel"))
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
	arg0.equipmentR = arg0:findTF("equipment_r/equipment")
	arg0.equipmentL = arg0:findTF("equipment_l/equipment")
	arg0.skinR = arg0:findTF("equipment_r/skin")
	arg0.skinL = arg0:findTF("equipment_l/skin")

	setActive(arg0.skinR, not LOCK_EQUIP_SKIN)
	setActive(arg0.skinL, not LOCK_EQUIP_SKIN)

	arg0.infoPanel = arg0:findTF("info", arg0.equipmentTFs[1])
	arg0.inSkinPage = true
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

	LeanTween.alphaCanvas(var2, var5, var1):setFrom(var4)
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
		local var2 = var0:Find("info")

		if IsNil(var2) then
			var2 = cloneTplTo(arg0.infoPanel, var0, "info")
		end

		local var3 = arg0:findTF("panel_title/type", var0)
		local var4 = EquipType.Types2Title(arg2, arg0.shipVO.configId)
		local var5 = arg0:findTF(var4, arg0.resource):GetComponent(typeof(Image)).sprite

		var3:GetComponent(typeof(Image)).sprite = var5

		var3:GetComponent(typeof(Image)):SetNativeSize()
		setActive(var2, var1)
		setActive(var0:Find("unequip"), not var1)

		if var1 then
			local var6 = var1:canEquipSkin()

			setActive(var2:Find("forbid"), not var6)

			local var7 = var2:Find("equip")

			setActive(var7, var6)

			if var6 then
				arg0:updateEquipmentPanel(var7, arg2)
			end
		end
	end
end

function var0.updateEquipmentPanel(arg0, arg1, arg2)
	local var0 = arg0.shipVO:getEquip(arg2)
	local var1 = var0.skinId
	local var2 = var0:hasSkin()
	local var3 = arg1:Find("add")
	local var4 = arg1:Find("info")

	setActive(var4, var2)
	setActive(var3, not var2)

	if var2 then
		arg0:updateSkinInfo(var4, var1)
		onButton(arg0, arg0.equipmentTFs[arg2], function()
			arg0:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, arg2)
		end, SFX_PANEL)
	else
		onButton(arg0, var3:Find("icon"), function()
			arg0:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, arg2)
		end, SFX_PANEL)
	end
end

function var0.updateSkinInfo(arg0, arg1, arg2)
	local var0 = pg.equip_skin_template[arg2]

	assert(var0, "miss config equip_skin_template >>" .. arg2)
	setText(arg1:Find("desc"), var0.desc)
	setText(arg1:Find("cont/name_mask/name"), var0.name)
	updateDrop(arg1:Find("IconTpl"), {
		type = DROP_TYPE_EQUIPMENT_SKIN,
		id = arg2
	})
end

return var0
