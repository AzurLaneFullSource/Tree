local var0 = class("YingxiV4SkirmishPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#C9463C") .. "/" .. #arg0.taskGroup)
end

function var0.GetProgressColor(arg0)
	return "#FFD97C"
end

return var0
