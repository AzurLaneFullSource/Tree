local var0 = class("BisimaiStoryActPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#d9413d") .. setColorStr("/" .. #arg0.taskGroup, "#ffffff"))
end

function var0.GetProgressColor(arg0)
	return "#ff4644", "#ffffff"
end

return var0
