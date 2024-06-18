local var0_0 = class("JapanV2framePage", import(".TemplatePage.FrameTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setActive(arg0_1.gotBtn, false)
end

return var0_0
