local var0_0 = class("BackYardDecorationThemeCard", import(".BackYardDecorationCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.add = findTF(arg0_1._tf, "bg/Add")
	arg0_1.rawIcon = findTF(arg0_1._tf, "bg/icon_raw"):GetComponent(typeof(RawImage))

	setActive(arg0_1.rawIcon.gameObject, false)
	setActive(arg0_1.newTF, false)

	arg0_1.iconTr = findTF(arg0_1._tf, "bg/icon")
	arg0_1.pos = findTF(arg0_1._tf, "bg/pos")
	arg0_1.posTxt = arg0_1.pos:Find("new"):GetComponent(typeof(Text))
end

function var0_0.RemoveSizeTag(arg0_2, arg1_2)
	local var0_2 = string.gsub(arg1_2, "</size>", "")

	return string.gsub(var0_2, "<size=%d+>", "")
end

function var0_0.Update(arg0_3, arg1_3, arg2_3)
	arg0_3.themeVO = arg1_3

	local var0_3 = arg1_3.id == ""

	SetActive(arg0_3.add, var0_3)
	setActive(arg0_3.iconTr, not var0_3)

	if not var0_3 then
		local var1_3 = arg1_3:IsSystem()

		setActive(arg0_3.iconImg.gameObject, var1_3)
		setActive(arg0_3.rawIcon.gameObject, false)

		if not var1_3 then
			if BackYardThemeTempalteUtil.FileExists(arg1_3:GetTextureIconName()) or arg1_3:IsPushed() then
				local var2_3 = arg1_3:GetIconMd5()

				BackYardThemeTempalteUtil.GetTexture(arg1_3:GetTextureIconName(), var2_3, function(arg0_4)
					if not IsNil(arg0_3.rawIcon) and arg0_4 then
						setActive(arg0_3.rawIcon.gameObject, true)

						arg0_3.rawIcon.texture = arg0_4
					end
				end)
			else
				setActive(arg0_3.iconImg.gameObject, true)
				LoadSpriteAtlasAsync("furnitureicon/" .. arg1_3:getIcon(), "", function(arg0_5)
					arg0_3.iconImg.sprite = arg0_5
				end)
			end

			local var3_3 = arg1_3.pos

			if arg1_3.pos <= 9 then
				var3_3 = "0" .. arg1_3.pos
			end

			arg0_3.posTxt.text = var3_3
		else
			LoadSpriteAsync("furnitureicon/" .. arg1_3:getIcon(), function(arg0_6)
				arg0_3.iconImg.sprite = arg0_6
			end)
		end

		setActive(arg0_3.pos, not var1_3)

		local var4_3 = arg0_3:RemoveSizeTag(arg1_3:getName())

		setText(arg0_3.comfortableTF, shortenString(var4_3, 4))
		SetActive(arg0_3.newTF, false)
		arg0_3:UpdateState(arg2_3)
	else
		setActive(arg0_3.pos, false)
		setText(arg0_3.comfortableTF, "")
	end
end

function var0_0.UpdateState(arg0_7, arg1_7)
	if arg0_7.themeVO.id ~= "" then
		SetActive(arg0_7.maskTF, arg1_7)

		arg0_7.showMask = arg1_7
	end
end

function var0_0.Dispose(arg0_8)
	var0_0.super.Dispose(arg0_8)

	if not IsNil(arg0_8.rawIcon.texture) then
		Object.Destroy(arg0_8.rawIcon.texture)

		arg0_8.rawIcon.texture = nil
	end
end

return var0_0
