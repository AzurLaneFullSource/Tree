local var0 = class("JavelinDressSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#D57BEF") .. "/" .. #arg0.taskGroup)
end

return var0
