local var0_0 = class("DachaolifuSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.step_txt = arg0_1:findTF("step_text", arg0_1.bg)
end

function var0_0.OnUpdateFlush(arg0_2)
	var0_0.super.OnUpdateFlush(arg0_2)
	setText(arg0_2.step_txt, setColorStr(arg0_2.nday, "#89FF59FF") .. "/" .. #arg0_2.taskGroup)
end

return var0_0
