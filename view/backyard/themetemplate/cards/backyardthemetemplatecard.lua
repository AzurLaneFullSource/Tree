local var0_0 = class("BackYardThemeTemplateCard", import("...Shop.cards.BackYardThemeCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.content = arg0_1._tf:Find("content")
	arg0_1.mask = arg0_1.content:Find("mask")
	arg0_1.iconRaw = arg0_1.content:Find("icon_mask/icon_raw"):GetComponent(typeof(RawImage))
	arg0_1.nameTxt = arg0_1.content:Find("Text"):GetComponent(typeof(Text))
	arg0_1.pos = arg0_1.content:Find("pos")
	arg0_1.posTxt = arg0_1.pos:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.FlushData(arg0_2, arg1_2)
	arg0_2.template = arg1_2
	arg0_2.themeVO = arg1_2
	arg0_2.nameTxt.text = arg1_2:GetName()
end

function var0_0.Update(arg0_3, arg1_3)
	if arg0_3.template and arg1_3.id == arg0_3.template.id then
		arg0_3:FlushData(arg1_3)

		return
	else
		arg0_3:FlushData(arg1_3)
		setActive(arg0_3.iconRaw.gameObject, false)

		local var0_3 = arg1_3:GetIconMd5()

		BackYardThemeTempalteUtil.GetTexture(arg1_3:GetTextureIconName(), var0_3, function(arg0_4)
			if not IsNil(arg0_3.iconRaw) and arg0_4 then
				setActive(arg0_3.iconRaw.gameObject, true)

				arg0_3.iconRaw.texture = arg0_4
			end
		end)

		local var1_3 = arg1_3:IsSelfUsage()

		setActive(arg0_3.mask, arg1_3:IsPushed() and var1_3)
		setActive(arg0_3.pos, var1_3)

		if var1_3 then
			local var2_3 = arg1_3.pos

			if arg1_3.pos <= 9 then
				var2_3 = "0" .. arg1_3.pos
			end

			arg0_3.posTxt.text = var2_3
		end
	end
end

function var0_0.Dispose(arg0_5)
	var0_0.super.Dispose(arg0_5)

	if not IsNil(arg0_5.iconRaw.texture) then
		Object.Destroy(arg0_5.iconRaw.texture)

		arg0_5.iconRaw.texture = nil
	end
end

return var0_0
