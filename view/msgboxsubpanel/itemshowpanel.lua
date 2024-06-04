local var0 = class("ItemShowPanel", import(".MsgboxSubPanel"))

var0.ConfigData = {
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

function var0.getUIName(arg0)
	return "ItemChangeNoticeBox"
end

function var0.UpdateView(arg0, arg1)
	arg0:PreRefresh(arg1)

	rtf(arg0.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	local var0 = arg0:findTF("title", arg0._tf)
	local var1 = arg0:findTF("icon_origin", arg0._tf)
	local var2 = arg0:findTF("icon_now", arg0._tf)
	local var3 = arg0:findTF("name_origin", arg0._tf)
	local var4 = arg0:findTF("name_now", arg0._tf)
	local var5 = arg0:findTF("before/Text", arg0._tf)
	local var6 = arg0:findTF("after/Text", arg0._tf)

	setText(var0, i18n(var0.ConfigData.title))
	setText(var3, i18n(var0.ConfigData.name_old))
	setText(var4, i18n(var0.ConfigData.name_new))
	setText(var5, i18n(var0.ConfigData.tip_old))
	setText(var6, i18n(var0.ConfigData.tip_new))
	setImageSprite(var1, LoadSprite(var0.ConfigData.icon_old))
	setImageSprite(var2, LoadSprite(var0.ConfigData.icon_new))
	arg0:PostRefresh(arg1)
end

return var0
