local var0_0 = class("JiFengJKSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#EC8FBBFF") .. "/" .. #arg0_1.taskGroup)
end

return var0_0
