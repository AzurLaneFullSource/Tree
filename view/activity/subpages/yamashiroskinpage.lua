local var0 = class("YamashiroSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, arg0.nday .. setColorStr("/" .. #arg0.taskGroup, COLOR_WHITE))
end

return var0
