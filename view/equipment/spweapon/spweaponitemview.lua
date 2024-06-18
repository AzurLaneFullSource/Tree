local var0_0 = class("SpWeaponItemView")
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
	arg0_1.specialFrame = findTF(arg1_1, "frame/bg/icon_bg/frame/specialFrame")
	arg0_1.tr = arg1_1.transform
	arg0_1.equiped = findTF(arg0_1.tr, "frame/bg/equip_flag")

	setActive(arg0_1.equiped, false)
	ClearTweenItemAlphaAndWhite(arg0_1.go)
end

function var0_0.update(arg0_2, arg1_2, arg2_2)
	setActive(arg0_2.equiped, false)
	setActive(arg0_2.unloadBtn, not arg1_2)
	setActive(arg0_2.bg, tobool(arg1_2))
	TweenItemAlphaAndWhite(arg0_2.go)

	if not arg1_2 then
		return
	end

	arg0_2.spWeaponVO = arg1_2

	updateSpWeapon(arg0_2.bg, arg1_2)

	if not IsNil(arg0_2.mask) then
		setActive(arg0_2.mask, false)
	end

	setActive(arg0_2.newTF, false)
	setActive(arg0_2.nameTF, not arg2_2)

	arg0_2.nameTF.text = shortenString(arg0_2.spWeaponVO:GetName(), 5)

	local var0_2 = arg0_2.spWeaponVO:GetShipId()

	setActive(arg0_2.equiped, tobool(var0_2))

	if var0_2 and var0_2 > 0 then
		local var1_2 = getProxy(BayProxy):getShipById(var0_2)

		setImageSprite(findTF(arg0_2.equiped, "Image"), LoadSprite("qicon/" .. var1_2:getPainting()))
	end

	setActive(arg0_2.specialFrame, not arg1_2:IsReal())

	local var2_2 = arg1_2.owned and "frame_design_owned" or "frame_design"

	GetImageSpriteFromAtlasAsync("weaponframes", var2_2, arg0_2.specialFrame)
end

function var0_0.clear(arg0_3)
	ClearTweenItemAlphaAndWhite(arg0_3.go)
end

return var0_0
