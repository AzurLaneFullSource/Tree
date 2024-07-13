local var0_0 = class("YidaliSPPTPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)

	local var0_1, var1_1, var2_1 = arg0_1.ptData:GetResProgress()

	setText(arg0_1.progress, (var2_1 >= 1 and setColorStr(var0_1, COLOR_GREEN) or setColorStr(var0_1, COLOR_WHITE)) .. "/" .. var1_1)
end

return var0_0
