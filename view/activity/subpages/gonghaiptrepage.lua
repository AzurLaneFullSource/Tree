local var0_0 = class("GongHaiPtRePage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	setText(arg0_1:findTF("title", arg0_1.bg), i18n("pt_count_tip"))
end

return var0_0
