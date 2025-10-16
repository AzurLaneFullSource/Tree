local var0_0 = class("VampireSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.bg:Find("total_day"), #arg0_1.taskGroup)
end

return var0_0
