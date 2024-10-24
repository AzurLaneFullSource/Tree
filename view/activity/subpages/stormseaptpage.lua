local var0_0 = class("StormSeaPtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)

	local var0_1, var1_1, var2_1 = arg0_1.ptData:GetResProgress()

	setText(arg0_1.progress, setColorStr(var0_1 .. "/" .. var1_1, "#a6afd3"))
end

return var0_0
