local var0 = class("StrengthenBackPanel", import(".MsgboxSubPanel"))

var0.ConfigData = {
	equipID = 96000,
	btnTxt = "text_forward",
	isOpen = true,
	icon = "equips/56000",
	content = "equipment_info_change_strengthen"
}

function var0.getUIName(arg0)
	return "StrengthenBackBox"
end

function var0.UpdateView(arg0, arg1)
	arg0:PreRefresh(arg1)

	rtf(arg0.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	local var0 = arg0:findTF("info_view/Viewport/Content/Text", arg0._tf)
	local var1 = Equipment.getConfigData(var0.ConfigData.equipID).name

	setText(var0, i18n(var0.ConfigData.content, var1))

	local var2 = arg0:findTF("button_container/custom_button_1(Clone)/pic", arg0._tf.parent)

	setText(var2, i18n(var0.ConfigData.btnTxt))

	local var3 = arg0:findTF("icon_bg/icon", arg0._tf)

	setImageSprite(var3, LoadSprite(var0.ConfigData.icon))

	if arg1.windowSize then
		arg0._tf.parent.sizeDelta = Vector2(arg1.windowSize.x, arg1.windowSize.y)
	end

	arg0:PostRefresh(arg1)
end

return var0
