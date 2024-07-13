local var0_0 = class("YingxiV4SkirmishPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#C9463C") .. "/" .. #arg0_1.taskGroup)
end

function var0_0.GetProgressColor(arg0_2)
	return "#FFD97C"
end

return var0_0
