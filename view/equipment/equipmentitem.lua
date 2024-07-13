local var0_0 = class("EquipmentItem")
local var1_0 = 0.5

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.bg = findTF(arg1_1, "frame/bg")
	arg0_1.mask = findTF(arg1_1, "frame/bg/mask")
	arg0_1.nameTF = findTF(arg1_1, "frame/bg/name"):GetComponent(typeof(Text))
	arg0_1.newTF = findTF(arg1_1, "frame/bg/icon_bg/new")
	arg0_1.unloadBtn = findTF(arg1_1, "frame/unload")
	arg0_1.reduceBtn = findTF(arg1_1, "frame/bg/selected/reduce")
	arg0_1.selectCount = findTF(arg1_1, "frame/bg/selected/reduce/Text")
	arg0_1.tr = arg1_1.transform
	arg0_1.selectedGo = findTF(arg0_1.tr, "frame/bg/selected").gameObject

	arg0_1.selectedGo:SetActive(false)

	arg0_1.equiped = findTF(arg0_1.tr, "frame/bg/equip_flag")

	setActive(arg0_1.equiped, false)

	arg0_1.selectedMask = findTF(arg0_1.tr, "frame/bg/selected_transform")

	if arg0_1.selectedMask then
		setActive(arg0_1.selectedMask, false)
	end

	ClearTweenItemAlphaAndWhite(arg0_1.go)
end

function var0_0.update(arg0_2, arg1_2, arg2_2)
	setActive(arg0_2.equiped, false)
	setActive(arg0_2.unloadBtn, not arg1_2)
	setActive(arg0_2.bg, arg1_2)
	TweenItemAlphaAndWhite(arg0_2.go)

	if not arg1_2 then
		return
	end

	arg0_2.equipmentVO = arg1_2

	if isa(arg1_2, SpWeapon) then
		arg0_2:updateSpWeapon()
	elseif arg1_2.isSkin then
		arg0_2:updateSkin()
	else
		updateEquipment(arg0_2.bg, arg1_2)

		if not IsNil(arg0_2.mask) then
			setActive(arg0_2.mask, arg1_2.mask)
		end

		setActive(arg0_2.newTF, arg1_2.new ~= 0 or arg1_2.isSkin)
		setActive(arg0_2.nameTF, not arg2_2)

		arg0_2.nameTF.text = shortenString(arg0_2.equipmentVO:getConfig("name"), 5)

		setActive(arg0_2.equiped, arg1_2.shipId)

		if arg1_2.shipId then
			local var0_2 = getProxy(BayProxy):getShipById(arg1_2.shipId)

			setImageSprite(findTF(arg0_2.equiped, "Image"), LoadSprite("qicon/" .. var0_2:getPainting()))
		end
	end
end

function var0_0.updateSkin(arg0_3)
	local var0_3 = arg0_3.equipmentVO

	setActive(arg0_3.equiped, var0_3.shipId)

	if var0_3.shipId then
		local var1_3 = getProxy(BayProxy):getShipById(var0_3.shipId)

		setImageSprite(findTF(arg0_3.equiped, "Image"), LoadSprite("qicon/" .. var1_3:getPainting()))
	end

	updateDrop(arg0_3.bg, {
		id = var0_3.id,
		type = DROP_TYPE_EQUIPMENT_SKIN,
		count = var0_3.count
	})

	arg0_3.nameTF.text = shortenString(getText(arg0_3.nameTF), 5)
end

function var0_0.updateSpWeapon(arg0_4)
	local var0_4 = arg0_4.equipmentVO

	updateSpWeapon(arg0_4.bg, var0_4)
	setActive(arg0_4.newTF, false)
	setActive(arg0_4.nameTF, true)

	arg0_4.nameTF.text = shortenString(var0_4:GetName(), 5)

	local var1_4 = var0_4:GetShipId()

	setActive(arg0_4.equiped, var1_4)

	if var1_4 then
		local var2_4 = getProxy(BayProxy):getShipById(var1_4)

		setImageSprite(findTF(arg0_4.equiped, "Image"), LoadSprite("qicon/" .. var2_4:getPainting()))
	end
end

function var0_0.clear(arg0_5)
	ClearTweenItemAlphaAndWhite(arg0_5.go)
end

function var0_0.dispose(arg0_6)
	return
end

function var0_0.updateSelected(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.selected = arg1_7

	local var0_7 = arg0_7.selected

	arg0_7.selectedGo:SetActive(var0_7)

	if var0_7 then
		setText(arg0_7.selectCount, arg2_7)

		if not arg0_7.selectedTwId then
			arg0_7.selectedTwId = LeanTween.alpha(arg0_7.selectedGo.transform, 1, var1_0):setFrom(0):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId
		end
	elseif arg0_7.selectedTwId then
		LeanTween.cancel(arg0_7.selectedTwId)

		arg0_7.selectedTwId = nil
	end
end

return var0_0
