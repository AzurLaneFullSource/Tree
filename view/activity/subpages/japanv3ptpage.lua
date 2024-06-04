local var0 = class("JapanV3PtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, setColorStr(var0, "#1a97cb") .. "/" .. var1)
end

return var0
