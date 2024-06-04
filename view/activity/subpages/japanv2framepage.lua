local var0 = class("JapanV2framePage", import(".TemplatePage.FrameTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setActive(arg0.gotBtn, false)
end

return var0
