local var0 = class("SpWeaponItemView")
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
	arg0.specialFrame = findTF(arg1, "frame/bg/icon_bg/frame/specialFrame")
	arg0.tr = arg1.transform
	arg0.equiped = findTF(arg0.tr, "frame/bg/equip_flag")

	setActive(arg0.equiped, false)
	ClearTweenItemAlphaAndWhite(arg0.go)
end

function var0.update(arg0, arg1, arg2)
	setActive(arg0.equiped, false)
	setActive(arg0.unloadBtn, not arg1)
	setActive(arg0.bg, tobool(arg1))
	TweenItemAlphaAndWhite(arg0.go)

	if not arg1 then
		return
	end

	arg0.spWeaponVO = arg1

	updateSpWeapon(arg0.bg, arg1)

	if not IsNil(arg0.mask) then
		setActive(arg0.mask, false)
	end

	setActive(arg0.newTF, false)
	setActive(arg0.nameTF, not arg2)

	arg0.nameTF.text = shortenString(arg0.spWeaponVO:GetName(), 5)

	local var0 = arg0.spWeaponVO:GetShipId()

	setActive(arg0.equiped, tobool(var0))

	if var0 and var0 > 0 then
		local var1 = getProxy(BayProxy):getShipById(var0)

		setImageSprite(findTF(arg0.equiped, "Image"), LoadSprite("qicon/" .. var1:getPainting()))
	end

	setActive(arg0.specialFrame, not arg1:IsReal())

	local var2 = arg1.owned and "frame_design_owned" or "frame_design"

	GetImageSpriteFromAtlasAsync("weaponframes", var2, arg0.specialFrame)
end

function var0.clear(arg0)
	ClearTweenItemAlphaAndWhite(arg0.go)
end

return var0
