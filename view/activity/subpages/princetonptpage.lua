local var0 = class("PrincetonPtPage", import(".TemplatePage.SpTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetLevelProgress()
	local var3, var4, var5 = arg0.ptData:GetResProgress()

	setText(arg0.step, setColorStr(var0, "#4180FFFF") .. "/" .. var1)
	setText(arg0.progress, setColorStr(var3, "#4180FFFF") .. "/" .. var4)
end

return var0
