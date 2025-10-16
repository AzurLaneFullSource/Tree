local var0_0 = class("AgoraFurnitureDescPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandAgoraFurnitureDescUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.width = arg0_2._tf.rect.width
	arg0_2.height = arg0_2._tf.rect.height
	arg0_2.prantLeftBound = arg0_2._tf.parent.rect.width / 2
	arg0_2.nameTxt = arg0_2._tf:Find("name"):GetComponent(typeof(Text))
	arg0_2.themeNameTxt = arg0_2._tf:Find("theme"):GetComponent(typeof(Text))
	arg0_2.capacityTxt = arg0_2._tf:Find("capacity/Text"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2._tf:Find("Text"):GetComponent(typeof(Text))
	arg0_2.icon = arg0_2._tf:Find("icon"):GetComponent(typeof(Image))
	arg0_2.cntTxt = arg0_2._tf:Find("cnt/Text"):GetComponent(typeof(Text))

	setActive(arg0_2._tf:Find("cnt"), false)
end

function var0_0.Show(arg0_3, arg1_3, arg2_3)
	var0_0.super.Show(arg0_3)

	arg0_3._tf.position = arg2_3

	if arg0_3._tf.localPosition.x + arg0_3.width > arg0_3.prantLeftBound then
		local var0_3 = arg0_3._tf.localPosition

		arg0_3._tf.localPosition = Vector3(var0_3.x - arg0_3.width, var0_3.y, var0_3.z)
	end

	arg0_3:FlushInfo(arg1_3)
end

function var0_0.FlushInfo(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetFirstItem()

	arg0_4.nameTxt.text = var0_4:GetName()
	arg0_4.themeNameTxt.text = i18n("agora_belong_theme", arg1_4:GetThemeName())
	arg0_4.capacityTxt.text = var0_4:GetCost()
	arg0_4.descTxt.text = var0_4:GetDesc()
	arg0_4.cntTxt.text = arg1_4:GetAvailableCnt()

	LoadSpriteAsync("island/IslandFurnitureIcon/" .. var0_4:GetIcon(), function(arg0_5)
		if not IsNil(arg0_4.icon) then
			arg0_4.icon.sprite = arg0_5
		end
	end)
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
