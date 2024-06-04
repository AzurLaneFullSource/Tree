local var0 = class("BackYardThemeTemplateCard", import("...Shop.cards.BackYardThemeCard"))

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.content = arg0._tf:Find("content")
	arg0.mask = arg0.content:Find("mask")
	arg0.iconRaw = arg0.content:Find("icon_mask/icon_raw"):GetComponent(typeof(RawImage))
	arg0.nameTxt = arg0.content:Find("Text"):GetComponent(typeof(Text))
	arg0.pos = arg0.content:Find("pos")
	arg0.posTxt = arg0.pos:Find("Text"):GetComponent(typeof(Text))
end

function var0.FlushData(arg0, arg1)
	arg0.template = arg1
	arg0.themeVO = arg1
	arg0.nameTxt.text = arg1:GetName()
end

function var0.Update(arg0, arg1)
	if arg0.template and arg1.id == arg0.template.id then
		arg0:FlushData(arg1)

		return
	else
		arg0:FlushData(arg1)
		setActive(arg0.iconRaw.gameObject, false)

		local var0 = arg1:GetIconMd5()

		BackYardThemeTempalteUtil.GetTexture(arg1:GetTextureIconName(), var0, function(arg0)
			if not IsNil(arg0.iconRaw) and arg0 then
				setActive(arg0.iconRaw.gameObject, true)

				arg0.iconRaw.texture = arg0
			end
		end)

		local var1 = arg1:IsSelfUsage()

		setActive(arg0.mask, arg1:IsPushed() and var1)
		setActive(arg0.pos, var1)

		if var1 then
			local var2 = arg1.pos

			if arg1.pos <= 9 then
				var2 = "0" .. arg1.pos
			end

			arg0.posTxt.text = var2
		end
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	if not IsNil(arg0.iconRaw.texture) then
		Object.Destroy(arg0.iconRaw.texture)

		arg0.iconRaw.texture = nil
	end
end

return var0
