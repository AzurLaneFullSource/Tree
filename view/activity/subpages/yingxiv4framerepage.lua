local var0_0 = class("YingxiV4FrameRePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	setActive(arg0_1.switchBtn, false)
end

return var0_0
