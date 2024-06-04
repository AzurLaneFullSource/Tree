local var0 = class("VampireSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0:findTF("total_day", arg0.bg), #arg0.taskGroup)
end

return var0
