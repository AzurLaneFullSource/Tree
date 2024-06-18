local var0_0 = class("ItemShowPanel", import(".MsgboxSubPanel"))

var0_0.ConfigData = {
	equipID = 908601,
	isOpen = true,
	title = "equipment_info_change_tip",
	icon_new = "equips/50860",
	icon_old = "equips/50860",
	name_new = "equipment_info_change_name_b",
	tip_old = "equipment_info_change_text_before",
	tip_new = "equipment_info_change_text_after",
	name_old = "equipment_info_change_name_a"
}

function var0_0.getUIName(arg0_1)
	return "ItemChangeNoticeBox"
end

function var0_0.UpdateView(arg0_2, arg1_2)
	arg0_2:PreRefresh(arg1_2)

	rtf(arg0_2.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	local var0_2 = arg0_2:findTF("title", arg0_2._tf)
	local var1_2 = arg0_2:findTF("icon_origin", arg0_2._tf)
	local var2_2 = arg0_2:findTF("icon_now", arg0_2._tf)
	local var3_2 = arg0_2:findTF("name_origin", arg0_2._tf)
	local var4_2 = arg0_2:findTF("name_now", arg0_2._tf)
	local var5_2 = arg0_2:findTF("before/Text", arg0_2._tf)
	local var6_2 = arg0_2:findTF("after/Text", arg0_2._tf)

	setText(var0_2, i18n(var0_0.ConfigData.title))
	setText(var3_2, i18n(var0_0.ConfigData.name_old))
	setText(var4_2, i18n(var0_0.ConfigData.name_new))
	setText(var5_2, i18n(var0_0.ConfigData.tip_old))
	setText(var6_2, i18n(var0_0.ConfigData.tip_new))
	setImageSprite(var1_2, LoadSprite(var0_0.ConfigData.icon_old))
	setImageSprite(var2_2, LoadSprite(var0_0.ConfigData.icon_new))
	arg0_2:PostRefresh(arg1_2)
end

return var0_0
