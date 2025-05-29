local var0_0 = class("ChangFengSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	arg0_1.nday = arg0_1.activity.data3

	arg0_1:PlayStory()
	SetActive(arg0_1.dayTF, false)
	arg0_1.uilist:align(#arg0_1.taskGroup[arg0_1.nday])
end

function var0_0.GetProgressColor(arg0_2)
	return "#34424b"
end

return var0_0
