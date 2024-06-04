local var0 = class("EquipmentItem")
local var1 = 0.5

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.bg = findTF(arg1, "frame/bg")
	arg0.mask = findTF(arg1, "frame/bg/mask")
	arg0.nameTF = findTF(arg1, "frame/bg/name"):GetComponent(typeof(Text))
	arg0.newTF = findTF(arg1, "frame/bg/icon_bg/new")
	arg0.unloadBtn = findTF(arg1, "frame/unload")
	arg0.reduceBtn = findTF(arg1, "frame/bg/selected/reduce")
	arg0.selectCount = findTF(arg1, "frame/bg/selected/reduce/Text")
	arg0.tr = arg1.transform
	arg0.selectedGo = findTF(arg0.tr, "frame/bg/selected").gameObject

	arg0.selectedGo:SetActive(false)

	arg0.equiped = findTF(arg0.tr, "frame/bg/equip_flag")

	setActive(arg0.equiped, false)

	arg0.selectedMask = findTF(arg0.tr, "frame/bg/selected_transform")

	if arg0.selectedMask then
		setActive(arg0.selectedMask, false)
	end

	ClearTweenItemAlphaAndWhite(arg0.go)
end

function var0.update(arg0, arg1, arg2)
	setActive(arg0.equiped, false)
	setActive(arg0.unloadBtn, not arg1)
	setActive(arg0.bg, arg1)
	TweenItemAlphaAndWhite(arg0.go)

	if not arg1 then
		return
	end

	arg0.equipmentVO = arg1

	if isa(arg1, SpWeapon) then
		arg0:updateSpWeapon()
	elseif arg1.isSkin then
		arg0:updateSkin()
	else
		updateEquipment(arg0.bg, arg1)

		if not IsNil(arg0.mask) then
			setActive(arg0.mask, arg1.mask)
		end

		setActive(arg0.newTF, arg1.new ~= 0 or arg1.isSkin)
		setActive(arg0.nameTF, not arg2)

		arg0.nameTF.text = shortenString(arg0.equipmentVO:getConfig("name"), 5)

		setActive(arg0.equiped, arg1.shipId)

		if arg1.shipId then
			local var0 = getProxy(BayProxy):getShipById(arg1.shipId)

			setImageSprite(findTF(arg0.equiped, "Image"), LoadSprite("qicon/" .. var0:getPainting()))
		end
	end
end

function var0.updateSkin(arg0)
	local var0 = arg0.equipmentVO

	setActive(arg0.equiped, var0.shipId)

	if var0.shipId then
		local var1 = getProxy(BayProxy):getShipById(var0.shipId)

		setImageSprite(findTF(arg0.equiped, "Image"), LoadSprite("qicon/" .. var1:getPainting()))
	end

	updateDrop(arg0.bg, {
		id = var0.id,
		type = DROP_TYPE_EQUIPMENT_SKIN,
		count = var0.count
	})

	arg0.nameTF.text = shortenString(getText(arg0.nameTF), 5)
end

function var0.updateSpWeapon(arg0)
	local var0 = arg0.equipmentVO

	updateSpWeapon(arg0.bg, var0)
	setActive(arg0.newTF, false)
	setActive(arg0.nameTF, true)

	arg0.nameTF.text = shortenString(var0:GetName(), 5)

	local var1 = var0:GetShipId()

	setActive(arg0.equiped, var1)

	if var1 then
		local var2 = getProxy(BayProxy):getShipById(var1)

		setImageSprite(findTF(arg0.equiped, "Image"), LoadSprite("qicon/" .. var2:getPainting()))
	end
end

function var0.clear(arg0)
	ClearTweenItemAlphaAndWhite(arg0.go)
end

function var0.dispose(arg0)
	return
end

function var0.updateSelected(arg0, arg1, arg2, arg3)
	arg0.selected = arg1

	local var0 = arg0.selected

	arg0.selectedGo:SetActive(var0)

	if var0 then
		setText(arg0.selectCount, arg2)

		if not arg0.selectedTwId then
			arg0.selectedTwId = LeanTween.alpha(arg0.selectedGo.transform, 1, var1):setFrom(0):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId
		end
	elseif arg0.selectedTwId then
		LeanTween.cancel(arg0.selectedTwId)

		arg0.selectedTwId = nil
	end
end

return var0
