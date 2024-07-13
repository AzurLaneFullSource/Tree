local var0_0 = class("YamashiroSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, arg0_1.nday .. setColorStr("/" .. #arg0_1.taskGroup, COLOR_WHITE))
end

return var0_0
