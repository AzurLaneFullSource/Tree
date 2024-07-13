local var0_0 = class("StrengthenBackPanel", import(".MsgboxSubPanel"))

var0_0.ConfigData = {
	equipID = 96000,
	btnTxt = "text_forward",
	isOpen = true,
	icon = "equips/56000",
	content = "equipment_info_change_strengthen"
}

function var0_0.getUIName(arg0_1)
	return "StrengthenBackBox"
end

function var0_0.UpdateView(arg0_2, arg1_2)
	arg0_2:PreRefresh(arg1_2)

	rtf(arg0_2.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	local var0_2 = arg0_2:findTF("info_view/Viewport/Content/Text", arg0_2._tf)
	local var1_2 = Equipment.getConfigData(var0_0.ConfigData.equipID).name

	setText(var0_2, i18n(var0_0.ConfigData.content, var1_2))

	local var2_2 = arg0_2:findTF("button_container/custom_button_1(Clone)/pic", arg0_2._tf.parent)

	setText(var2_2, i18n(var0_0.ConfigData.btnTxt))

	local var3_2 = arg0_2:findTF("icon_bg/icon", arg0_2._tf)

	setImageSprite(var3_2, LoadSprite(var0_0.ConfigData.icon))

	if arg1_2.windowSize then
		arg0_2._tf.parent.sizeDelta = Vector2(arg1_2.windowSize.x, arg1_2.windowSize.y)
	end

	arg0_2:PostRefresh(arg1_2)
end

return var0_0
