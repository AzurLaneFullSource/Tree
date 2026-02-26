local var0_0 = class("MoscowURPtPage", import("view.activity.CorePage.CorePageNewPtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	setText(arg0_1.bg:Find("exchange_btn/Text"), i18n("yumia_pt_3"))
	setText(arg0_1.bg:Find("gray/Text"), i18n("yumia_pt_2"))
	setText(arg0_1.bg:Find("get_btn/Text"), i18n("yumia_pt_2"))
end

return var0_0
