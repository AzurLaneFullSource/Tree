local var0 = class("KelifulanSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#f56544") .. "/" .. #arg0.taskGroup)
end

function var0.GetProgressColor(arg0)
	return "#f56544", "#efdf1e6"
end

return var0
