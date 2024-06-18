local var0_0 = class("LycorisActivationPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	arg0_1:PlayStory()
	setText(arg0_1.dayTF, tostring(arg0_1.nday) .. "/7")
end

return var0_0
