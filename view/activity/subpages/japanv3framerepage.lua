local var0_0 = class("JapanV3FrameRePage", import(".TemplatePage.FrameReTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.super.OnInit(arg0_1)

	arg0_1.bar = arg0_1:findTF("frame/barContent/bar", arg0_1.bg)
end

return var0_0
