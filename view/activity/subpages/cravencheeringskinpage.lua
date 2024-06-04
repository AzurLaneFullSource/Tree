local var0 = class("CravenCheeringSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.step_txt = arg0:findTF("step_text", arg0.bg)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.step_txt, setColorStr(arg0.nday, "#89FF59FF") .. "/" .. #arg0.taskGroup)
end

return var0
