local var0_0 = class("BisimaiStoryActPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#d9413d") .. setColorStr("/" .. #arg0_1.taskGroup, "#ffffff"))
end

function var0_0.GetProgressColor(arg0_2)
	return "#ff4644", "#ffffff"
end

return var0_0
