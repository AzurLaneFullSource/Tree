local var0 = class("YingxiV4PtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetLevelProgress()
	local var3, var4, var5 = arg0.ptData:GetResProgress()

	setText(arg0.step, setColorStr(var0, "#EBD3CD") .. "/" .. var1)
	setText(arg0.progress, (var5 >= 1 and setColorStr(var3, COLOR_GREEN) or setColorStr(var3, "#EBD3CD")) .. "/" .. var4)
end

return var0
