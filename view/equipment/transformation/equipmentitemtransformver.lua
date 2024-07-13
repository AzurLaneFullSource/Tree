local var0_0 = class("EquipmentItemTransformVer", import("view.equipment.EquipmentItem"))

function var0_0.update(arg0_1, arg1_1)
	setActive(arg0_1.equiped, false)
	setActive(arg0_1.unloadBtn, not arg1_1)
	setActive(arg0_1.bg, arg1_1)
	TweenItemAlphaAndWhite(arg0_1.go)

	if not arg1_1 then
		return
	end

	arg0_1.sourceVO = arg1_1

	updateDrop(arg0_1.bg, arg1_1)

	local var0_1 = arg1_1.template
	local var1_1 = arg0_1.bg

	if arg1_1.type == DROP_TYPE_EQUIP then
		local var2_1 = findTF(var1_1, "icon_bg/new")

		setActive(var2_1, var0_1.new ~= 0)

		local var3_1 = findTF(var1_1, "equip_flag")

		setActive(var3_1, var0_1.shipId)

		if var0_1.shipId then
			local var4_1 = getProxy(BayProxy):getShipById(var0_1.shipId)

			setImageSprite(findTF(var3_1, "Image"), LoadSprite("qicon/" .. var4_1:getPainting()))
		end
	end

	findTF(var1_1, "name"):GetComponent(typeof(Text)).text = shortenString(arg1_1:getConfig("name"), 5)

	if not IsNil(arg0_1.mask) then
		setActive(arg0_1.mask, var0_1.mask)
	end

	local var5_1 = arg0_1.bg:Find("frameMask")

	setActive(var5_1, false)

	if arg1_1.type == DROP_TYPE_ITEM then
		local var6_1 = findTF(arg0_1.bg, "icon_bg/count")

		if not IsNil(var6_1) then
			local var7_1 = var0_1.count
			local var8_1 = arg1_1.composeCfg.material_num
			local var9_1 = var8_1 <= var7_1
			local var10_1 = setColorStr(var7_1 .. "/" .. var8_1, var9_1 and COLOR_WHITE or COLOR_RED)

			setText(var6_1, var10_1)
			setActive(var5_1, not var9_1)
		end
	end
end

function var0_0.updateSelected(arg0_2, arg1_2)
	arg0_2.selected = arg1_2

	setActive(arg0_2.selectedMask, arg1_2)
end

return var0_0
