local var0 = class("BackYardThemeCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.content = arg0._tf:Find("content")
	arg0.icon = arg0.content:Find("icon_mask/icon"):GetComponent(typeof(Image))
	arg0.nameTxt = arg0.content:Find("Text"):GetComponent(typeof(Text))
	arg0.discountTF = arg0.content:Find("discount")
	arg0.discountTxt = arg0.discountTF:Find("Text"):GetComponent(typeof(Text))
	arg0.hotTF = arg0.content:Find("hot")
	arg0.newTF = arg0.content:Find("new")
	arg0.maskPurchased = arg0.content:Find("mask1")
end

function var0.Update(arg0, arg1, arg2)
	arg0.themeVO = arg1

	LoadSpriteAtlasAsync("BackYardTheme/" .. arg1.id, "", function(arg0)
		arg0.icon.sprite = arg0
	end)

	local var0 = shortenString(arg1:GetName(), 7)
	local var1 = string.gsub(var0, "<size=%d+>", "")

	arg0.nameTxt.text = string.gsub(var1, "</size>", "")

	local var2 = arg1:GetDiscount()
	local var3 = arg1:HasDiscount()

	setActive(arg0.discountTF, var3)

	if var3 then
		arg0.discountTxt.text = var2 .. "%"
	end

	local var4 = false
	local var5 = arg1:getConfig("new") > 0

	if not var5 then
		var4 = arg1:getConfig("hot") > 0
	end

	setActive(arg0.hotTF, var4 and not arg2)
	setActive(arg0.newTF, var5 and not arg2)
	setActive(arg0.maskPurchased, arg2)
end

function var0.UpdateSelected(arg0, arg1)
	local var0 = arg1 and arg1.id == arg0.themeVO.id

	if IsNil(arg0.content) then
		return
	end

	if LeanTween.isTweening(arg0.content.gameObject) then
		LeanTween.cancel(arg0.content.gameObject)
	end

	local var1 = arg0.content.anchoredPosition.y
	local var2 = var0 and 0 or -70

	LeanTween.value(arg0.content.gameObject, var1, var2, 0.264):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.content, {
			y = arg0
		})
	end))
end

function var0.Dispose(arg0)
	if LeanTween.isTweening(arg0.content.gameObject) then
		LeanTween.cancel(arg0.content.gameObject)
	end
end

return var0
