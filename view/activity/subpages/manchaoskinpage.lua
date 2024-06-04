local var0 = class("ManChaoSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#B67DA1FF") .. "/" .. #arg0.taskGroup)
end

return var0
