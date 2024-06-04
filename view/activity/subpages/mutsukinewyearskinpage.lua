local var0 = class("MutsukiNewYearSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, arg0.nday .. "/" .. #arg0.taskGroup)
end

return var0
