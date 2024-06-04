local var0 = class("DexiV4PtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetLevelProgress()
	local var3, var4, var5 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var5 >= 1 and setColorStr(var3, COLOR_GREEN) or setColorStr(var3, "#F11123")) .. setColorStr("/" .. var4, "#635968"))
end

return var0
