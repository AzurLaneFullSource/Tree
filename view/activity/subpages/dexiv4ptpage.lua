local var0_0 = class("DexiV4PtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)

	local var0_1, var1_1, var2_1 = arg0_1.ptData:GetLevelProgress()
	local var3_1, var4_1, var5_1 = arg0_1.ptData:GetResProgress()

	setText(arg0_1.progress, (var5_1 >= 1 and setColorStr(var3_1, COLOR_GREEN) or setColorStr(var3_1, "#F11123")) .. setColorStr("/" .. var4_1, "#635968"))
end

return var0_0
