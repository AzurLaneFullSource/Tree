local var0 = class("EquipmentItemTransformVer", import("view.equipment.EquipmentItem"))

function var0.update(arg0, arg1)
	setActive(arg0.equiped, false)
	setActive(arg0.unloadBtn, not arg1)
	setActive(arg0.bg, arg1)
	TweenItemAlphaAndWhite(arg0.go)

	if not arg1 then
		return
	end

	arg0.sourceVO = arg1

	updateDrop(arg0.bg, arg1)

	local var0 = arg1.template
	local var1 = arg0.bg

	if arg1.type == DROP_TYPE_EQUIP then
		local var2 = findTF(var1, "icon_bg/new")

		setActive(var2, var0.new ~= 0)

		local var3 = findTF(var1, "equip_flag")

		setActive(var3, var0.shipId)

		if var0.shipId then
			local var4 = getProxy(BayProxy):getShipById(var0.shipId)

			setImageSprite(findTF(var3, "Image"), LoadSprite("qicon/" .. var4:getPainting()))
		end
	end

	findTF(var1, "name"):GetComponent(typeof(Text)).text = shortenString(arg1:getConfig("name"), 5)

	if not IsNil(arg0.mask) then
		setActive(arg0.mask, var0.mask)
	end

	local var5 = arg0.bg:Find("frameMask")

	setActive(var5, false)

	if arg1.type == DROP_TYPE_ITEM then
		local var6 = findTF(arg0.bg, "icon_bg/count")

		if not IsNil(var6) then
			local var7 = var0.count
			local var8 = arg1.composeCfg.material_num
			local var9 = var8 <= var7
			local var10 = setColorStr(var7 .. "/" .. var8, var9 and COLOR_WHITE or COLOR_RED)

			setText(var6, var10)
			setActive(var5, not var9)
		end
	end
end

function var0.updateSelected(arg0, arg1)
	arg0.selected = arg1

	setActive(arg0.selectedMask, arg1)
end

return var0
