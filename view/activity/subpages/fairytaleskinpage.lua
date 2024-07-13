local var0_0 = class("FairyTaleSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, arg0_1.nday .. "/" .. #arg0_1.taskGroup)
end

return var0_0
