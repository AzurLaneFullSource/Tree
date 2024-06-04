local var0 = class("BulvxieerSPSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#FFCBAE") .. "/" .. #arg0.taskGroup)
end

function var0.GetProgressColor(arg0)
	return "#FFCBAE"
end

return var0
