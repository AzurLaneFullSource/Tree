local var0_0 = class("YunLongSPCoreActivityUI", import("view.activity.CorePage.Helena.HelenaCoreActivityUI"))

function var0_0.getUIName(arg0_1)
	return "YunLongSPCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("SardiniaSPCoreActivityUI_title"))
end

return var0_0
