local var0 = class("GongHaiPtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	setText(arg0:findTF("title", arg0.bg), i18n("pt_count_tip"))
end

return var0
