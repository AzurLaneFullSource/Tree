local var0_0 = class("BackYardDecorationCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1._bg = findTF(arg0_1._tf, "bg")
	arg0_1.maskTF = findTF(arg0_1._tf, "bg/mask")
	arg0_1.iconImg = findTF(arg0_1._tf, "bg/icon"):GetComponent(typeof(Image))
	arg0_1.comfortableTF = findTF(arg0_1._tf, "bg/comfortable")
	arg0_1.newTF = findTF(arg0_1._tf, "bg/new_bg")
	arg0_1.countTxt = findTF(arg0_1._tf, "bg/count")
	arg0_1.mark = findTF(arg0_1._tf, "bg/mark")
	arg0_1.animation = arg0_1._tf:GetComponent(typeof(Animation))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.furniture = arg1_2

	LoadSpriteAtlasAsync("furnitureicon/" .. arg1_2:getConfig("icon"), "", function(arg0_3)
		if IsNil(arg0_2.iconImg) then
			return
		end

		arg0_2.iconImg.sprite = arg0_3
	end)

	local var0_2 = HXSet.hxLan(arg1_2:getConfig("name"))

	setText(arg0_2.comfortableTF, shortenString(var0_2, 4))

	local var1_2 = arg1_2:getConfig("count")
	local var2_2 = arg1_2:GetOwnCnt()

	arg0_2.showMask = var2_2 <= arg2_2

	SetActive(arg0_2.maskTF, arg0_2.showMask)
	setText(arg0_2.maskTF:Find("Text"), i18n("courtyard_label_using", arg3_2))
	arg0_2:UpdateMark(arg4_2)

	if var1_2 > 1 then
		setText(arg0_2.countTxt, arg2_2 .. "/" .. var2_2)
		SetActive(arg0_2.maskTF, arg2_2 == var2_2)
	else
		setText(arg0_2.countTxt, "")
	end

	SetActive(arg0_2.newTF, arg1_2.newFlag)
end

function var0_0.PlayEnterAnimation(arg0_4)
	arg0_4.animation:Play("anim_backyard_furniture_itemin")
end

function var0_0.UpdateMark(arg0_5, arg1_5)
	if not arg0_5.furniture then
		setActive(arg0_5.mark, false)

		return
	end

	setActive(arg0_5.mark, arg1_5 and arg1_5 == arg0_5.furniture.id)
end

function var0_0.Flush(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg1_6.id == arg0_6.furniture.id then
		arg0_6:Update(arg1_6, arg2_6, arg3_6)
	else
		arg0_6:Update(arg0_6.furniture, arg2_6, arg3_6)
	end
end

function var0_0.HasMask(arg0_7)
	return arg0_7.showMask
end

function var0_0.Dispose(arg0_8)
	return
end

return var0_0
