local var0_0 = class("BackYardThemeCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.content = arg0_1._tf:Find("content")
	arg0_1.icon = arg0_1.content:Find("icon_mask/icon"):GetComponent(typeof(Image))
	arg0_1.nameTxt = arg0_1.content:Find("Text"):GetComponent(typeof(Text))
	arg0_1.discountTF = arg0_1.content:Find("discount")
	arg0_1.discountTxt = arg0_1.discountTF:Find("Text"):GetComponent(typeof(Text))
	arg0_1.hotTF = arg0_1.content:Find("hot")
	arg0_1.newTF = arg0_1.content:Find("new")
	arg0_1.maskPurchased = arg0_1.content:Find("mask1")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.themeVO = arg1_2

	LoadSpriteAtlasAsync("BackYardTheme/" .. arg1_2.id, "", function(arg0_3)
		arg0_2.icon.sprite = arg0_3
	end)

	local var0_2 = shortenString(arg1_2:GetName(), 7)
	local var1_2 = string.gsub(var0_2, "<size=%d+>", "")

	arg0_2.nameTxt.text = string.gsub(var1_2, "</size>", "")

	local var2_2 = arg1_2:GetDiscount()
	local var3_2 = arg1_2:HasDiscount()

	setActive(arg0_2.discountTF, var3_2)

	if var3_2 then
		arg0_2.discountTxt.text = var2_2 .. "%"
	end

	local var4_2 = false
	local var5_2 = arg1_2:getConfig("new") > 0

	if not var5_2 then
		var4_2 = arg1_2:getConfig("hot") > 0
	end

	setActive(arg0_2.hotTF, var4_2 and not arg2_2)
	setActive(arg0_2.newTF, var5_2 and not arg2_2)
	setActive(arg0_2.maskPurchased, arg2_2)
end

function var0_0.UpdateSelected(arg0_4, arg1_4)
	local var0_4 = arg1_4 and arg1_4.id == arg0_4.themeVO.id

	if IsNil(arg0_4.content) then
		return
	end

	if LeanTween.isTweening(arg0_4.content.gameObject) then
		LeanTween.cancel(arg0_4.content.gameObject)
	end

	local var1_4 = arg0_4.content.anchoredPosition.y
	local var2_4 = var0_4 and 0 or -70

	LeanTween.value(arg0_4.content.gameObject, var1_4, var2_4, 0.264):setOnUpdate(System.Action_float(function(arg0_5)
		setAnchoredPosition(arg0_4.content, {
			y = arg0_5
		})
	end))
end

function var0_0.Dispose(arg0_6)
	if LeanTween.isTweening(arg0_6.content.gameObject) then
		LeanTween.cancel(arg0_6.content.gameObject)
	end
end

return var0_0
