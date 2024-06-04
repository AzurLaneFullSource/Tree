local var0 = class("USDefenceOilPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var2 >= 1 and setColorStr(var0, "#E8656BFF") or var0) .. "/" .. var1)
end

return var0
