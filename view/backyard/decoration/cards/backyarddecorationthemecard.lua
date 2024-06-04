local var0 = class("BackYardDecorationThemeCard", import(".BackYardDecorationCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.add = findTF(arg0._tf, "bg/Add")
	arg0.rawIcon = findTF(arg0._tf, "bg/icon_raw"):GetComponent(typeof(RawImage))

	setActive(arg0.rawIcon.gameObject, false)
	setActive(arg0.newTF, false)

	arg0.iconTr = findTF(arg0._tf, "bg/icon")
	arg0.pos = findTF(arg0._tf, "bg/pos")
	arg0.posTxt = arg0.pos:Find("new"):GetComponent(typeof(Text))
end

function var0.RemoveSizeTag(arg0, arg1)
	local var0 = string.gsub(arg1, "</size>", "")

	return string.gsub(var0, "<size=%d+>", "")
end

function var0.Update(arg0, arg1, arg2)
	arg0.themeVO = arg1

	local var0 = arg1.id == ""

	SetActive(arg0.add, var0)
	setActive(arg0.iconTr, not var0)

	if not var0 then
		local var1 = arg1:IsSystem()

		setActive(arg0.iconImg.gameObject, var1)
		setActive(arg0.rawIcon.gameObject, false)

		if not var1 then
			if BackYardThemeTempalteUtil.FileExists(arg1:GetTextureIconName()) or arg1:IsPushed() then
				local var2 = arg1:GetIconMd5()

				BackYardThemeTempalteUtil.GetTexture(arg1:GetTextureIconName(), var2, function(arg0)
					if not IsNil(arg0.rawIcon) and arg0 then
						setActive(arg0.rawIcon.gameObject, true)

						arg0.rawIcon.texture = arg0
					end
				end)
			else
				setActive(arg0.iconImg.gameObject, true)
				LoadSpriteAtlasAsync("furnitureicon/" .. arg1:getIcon(), "", function(arg0)
					arg0.iconImg.sprite = arg0
				end)
			end

			local var3 = arg1.pos

			if arg1.pos <= 9 then
				var3 = "0" .. arg1.pos
			end

			arg0.posTxt.text = var3
		else
			LoadSpriteAsync("furnitureicon/" .. arg1:getIcon(), function(arg0)
				arg0.iconImg.sprite = arg0
			end)
		end

		setActive(arg0.pos, not var1)

		local var4 = arg0:RemoveSizeTag(arg1:getName())

		setText(arg0.comfortableTF, shortenString(var4, 4))
		SetActive(arg0.newTF, false)
		arg0:UpdateState(arg2)
	else
		setActive(arg0.pos, false)
		setText(arg0.comfortableTF, "")
	end
end

function var0.UpdateState(arg0, arg1)
	if arg0.themeVO.id ~= "" then
		SetActive(arg0.maskTF, arg1)

		arg0.showMask = arg1
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	if not IsNil(arg0.rawIcon.texture) then
		Object.Destroy(arg0.rawIcon.texture)

		arg0.rawIcon.texture = nil
	end
end

return var0
