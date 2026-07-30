local var0_0 = class("ItemShowPanel", import(".MsgboxSubPanel"))

function var0_0.getUIName(arg0_1)
	return "ItemChangeNoticeBox"
end

function var0_0.UpdateView(arg0_2, arg1_2)
	arg0_2:PreRefresh(arg1_2)

	rtf(arg0_2.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	local var0_2 = arg0_2._tf:Find("title")
	local var1_2 = arg0_2._tf:Find("icon_origin")
	local var2_2 = arg0_2._tf:Find("icon_now")
	local var3_2 = arg0_2._tf:Find("name_origin")
	local var4_2 = arg0_2._tf:Find("name_now")
	local var5_2 = arg0_2._tf:Find("before/Text")
	local var6_2 = arg0_2._tf:Find("after/Text")
	local var7_2 = arg1_2.configData

	setText(var0_2, i18n(var7_2.title))
	setText(var3_2, i18n(var7_2.name_old))
	setText(var4_2, i18n(var7_2.name_new))
	setText(var5_2, i18n(var7_2.tip_old))
	setText(var6_2, i18n(var7_2.tip_new))
	setImageSprite(var1_2, LoadSprite(var7_2.icon_old))
	setImageSprite(var2_2, LoadSprite(var7_2.icon_new))
	arg0_2:PostRefresh(arg1_2)
end

return var0_0
