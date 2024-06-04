local var0 = class("LycorisActivationPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	arg0:PlayStory()
	setText(arg0.dayTF, tostring(arg0.nday) .. "/7")
end

return var0
