local var0_0 = class("ANTTFFCoreActivityUI", import("view.activity.CorePage.Helena.HelenaCoreActivityUI"))

function var0_0.getUIName(arg0_1)
	return "ANTTFFCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("ANTTFFCoreActivity_title"))
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("ANTTFFCoreActivity_title2"))
end

function var0_0.OnToggleName(arg0_3, arg1_3, arg2_3)
	setText(arg1_3:Find("on/name"), i18n(arg2_3:getConfig("title_res_tag")))
	setText(arg1_3:Find("name"), i18n(arg2_3:getConfig("title_res_tag")))
end

function var0_0.OnAnimations(arg0_4, arg1_4, arg2_4)
	return
end

return var0_0
