local var0_0 = class("USDefenceOilPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)

	local var0_1, var1_1, var2_1 = arg0_1.ptData:GetResProgress()

	setText(arg0_1.progress, (var2_1 >= 1 and setColorStr(var0_1, "#E8656BFF") or var0_1) .. "/" .. var1_1)
end

return var0_0
