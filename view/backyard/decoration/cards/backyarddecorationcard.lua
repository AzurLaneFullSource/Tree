local var0 = class("BackYardDecorationCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0._bg = findTF(arg0._tf, "bg")
	arg0.maskTF = findTF(arg0._tf, "bg/mask")
	arg0.iconImg = findTF(arg0._tf, "bg/icon"):GetComponent(typeof(Image))
	arg0.comfortableTF = findTF(arg0._tf, "bg/comfortable")
	arg0.newTF = findTF(arg0._tf, "bg/new_bg")
	arg0.countTxt = findTF(arg0._tf, "bg/count")
	arg0.mark = findTF(arg0._tf, "bg/mark")
	arg0.animation = arg0._tf:GetComponent(typeof(Animation))
end

function var0.Update(arg0, arg1, arg2, arg3, arg4)
	arg0.furniture = arg1

	LoadSpriteAtlasAsync("furnitureicon/" .. arg1:getConfig("icon"), "", function(arg0)
		if IsNil(arg0.iconImg) then
			return
		end

		arg0.iconImg.sprite = arg0
	end)

	local var0 = HXSet.hxLan(arg1:getConfig("name"))

	setText(arg0.comfortableTF, shortenString(var0, 4))

	local var1 = arg1:getConfig("count")
	local var2 = arg1:GetOwnCnt()

	arg0.showMask = var2 <= arg2

	SetActive(arg0.maskTF, arg0.showMask)
	setText(arg0.maskTF:Find("Text"), i18n("courtyard_label_using", arg3))
	arg0:UpdateMark(arg4)

	if var1 > 1 then
		setText(arg0.countTxt, arg2 .. "/" .. var2)
		SetActive(arg0.maskTF, arg2 == var2)
	else
		setText(arg0.countTxt, "")
	end

	SetActive(arg0.newTF, arg1.newFlag)
end

function var0.PlayEnterAnimation(arg0)
	arg0.animation:Play("anim_backyard_furniture_itemin")
end

function var0.UpdateMark(arg0, arg1)
	if not arg0.furniture then
		setActive(arg0.mark, false)

		return
	end

	setActive(arg0.mark, arg1 and arg1 == arg0.furniture.id)
end

function var0.Flush(arg0, arg1, arg2, arg3)
	if arg1.id == arg0.furniture.id then
		arg0:Update(arg1, arg2, arg3)
	else
		arg0:Update(arg0.furniture, arg2, arg3)
	end
end

function var0.HasMask(arg0)
	return arg0.showMask
end

function var0.Dispose(arg0)
	return
end

return var0
